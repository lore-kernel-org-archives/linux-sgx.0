Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514D2C2BA4C
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Jan 2022 19:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244389AbiAZTRX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Jan 2022 14:17:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:3417 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244391AbiAZTRW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 26 Jan 2022 14:17:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643224642; x=1674760642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rAhC7ZZ+JYTEV9vz4W2n8rbRsbKiX58rPBIDPPAqyxk=;
  b=jWRApIBcg4vTZp8s/N/YmhRfguc/rjw3GTxuasBbc8bLeZLVmY4u3otv
   eKgo2n583433TNqBIZy/2+LRMP883er7k1VpN+pWUqzFRpcxaTkbAf1Hu
   aMkkOQWvHBbybnN7py0eFGHe92ydKYiVgJE5+FKEx8kJgszF8sWzO/Eyq
   R4WLRvMmQ97NtDFh07wCWt3BwAjJ5NanLkV12zEb1nxnMp8fcK7ZYUouJ
   D9i8AB0Qf0BgU7c9Wywr5FEPvr9/Zio97OoXa+DwE0G8ObF6ATG/9AE+j
   JGlElRDvHqo3WTY/t5cfNN7hgXec54XN1sQcWXm3BnL23ssE2UeCtqxLf
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="271082420"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="271082420"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 11:17:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="479992551"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.3.61])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 11:17:21 -0800
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     linux-sgx@vger.kernel.org, dave.hansen@intel.com
Cc:     haitao.huang@linux.intel.com, jarkko@kernel.org
Subject: [PATCH 2/2] x86/sgx: Allow sgx_reclaim_pages() to report failure
Date:   Wed, 26 Jan 2022 11:17:11 -0800
Message-Id: <20220126191711.4917-3-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220126191711.4917-1-kristen@linux.intel.com>
References: <20220126191711.4917-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

If backing pages are not able to be allocated during
sgx_reclaim_pages(), return an error code to the caller.
sgx_reclaim_pages() can be called from the reclaimer thread,
or when adding pages via an ioctl. When it is called from the
kernel thread, it's safe to ignore the return value, however,
calls from the ioctls should forward the error.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c4030fb608c6..0e95f69ebcb7 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -377,17 +377,18 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
  * problematic as it would increase the lock contention too much, which would
  * halt forward progress.
  */
-static void sgx_reclaim_pages(void)
+static int sgx_reclaim_pages(void)
 {
 	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
 	struct sgx_backing backing[SGX_NR_TO_SCAN];
 	struct sgx_epc_section *section;
 	struct sgx_encl_page *encl_page;
+	int pages_being_reclaimed = 0;
 	struct sgx_epc_page *epc_page;
 	struct sgx_numa_node *node;
 	pgoff_t page_index;
 	int cnt = 0;
-	int ret;
+	int ret = 0;
 	int i;
 
 	spin_lock(&sgx_reclaimer_lock);
@@ -422,6 +423,8 @@ static void sgx_reclaim_pages(void)
 		if (ret)
 			goto skip;
 
+		pages_being_reclaimed++;
+
 		mutex_lock(&encl_page->encl->lock);
 		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
 		mutex_unlock(&encl_page->encl->lock);
@@ -437,6 +440,9 @@ static void sgx_reclaim_pages(void)
 		chunk[i] = NULL;
 	}
 
+	if (!pages_being_reclaimed)
+		return ret;
+
 	for (i = 0; i < cnt; i++) {
 		epc_page = chunk[i];
 		if (epc_page)
@@ -463,6 +469,7 @@ static void sgx_reclaim_pages(void)
 		spin_unlock(&node->lock);
 		atomic_long_inc(&sgx_nr_free_pages);
 	}
+	return ret;
 }
 
 static bool sgx_should_reclaim(unsigned long watermark)
@@ -636,6 +643,7 @@ int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 {
 	struct sgx_epc_page *page;
+	int ret;
 
 	for ( ; ; ) {
 		page = __sgx_alloc_epc_page();
@@ -657,7 +665,11 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 			break;
 		}
 
-		sgx_reclaim_pages();
+		ret = sgx_reclaim_pages();
+		if (ret) {
+			page = ERR_PTR(-ENOMEM);
+			break;
+		}
 		cond_resched();
 	}
 
-- 
2.20.1

