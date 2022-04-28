Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB30C433FE
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 20:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiD1UO4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 16:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236958AbiD1UOz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 16:14:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57266BAB83
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 13:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651176699; x=1682712699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MwZD4A5ibwQEWUZhITr2v2x3X9zt9CcswzCScYnQjWg=;
  b=DOxs9UD2P6mvjVcw9nBE7jyf9so9dJmut6qiHjCmCmztJ25JDuyzVZx5
   f6XCK4ArVy6pGuijwrbB8BHcS4A2h8UERTR3vHqr+8LAwz4ycElcXRkQS
   Ex/hAd5Skl27KUGntq/ny5SdqYdCI3p5Fzm8qi7K6zmUL61OAHePRImmW
   +mK62OJsC9mekFw/FzgRLzzKfup3x8VMLoUfONJcg++g7Vktt+I7qtNPk
   DIKNhH+yagcqWx2KRZhtpghJv4xqF7LcvILJYG+lZY6PLw+IIfGDYlZCB
   TDoRUCBNWm2Un+vzxjMi2SGSWwyFOVQr6Gd/pKMSoDOKEXGSxO0OdzB5N
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246324259"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="246324259"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:11:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="514458610"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:11:32 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Subject: [RFC PATCH 3/4] x86/sgx: Obtain backing storage page with enclave mutex held
Date:   Thu, 28 Apr 2022 13:11:26 -0700
Message-Id: <24fd9203331d11918b785c6a67f85d799d100be8.1651171455.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651171455.git.reinette.chatre@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The SGX backing storage is accessed on two paths: when there
are insufficient enclave pages in the EPC the reclaimer works
to move enclave pages to the backing storage and as enclaves
access pages that have been moved to the backing storage
they are retrieved from there as part of page fault handling.

An oversubscribed SGX system will often run the reclaimer and
page fault handler concurrently and needs to ensure that the
backing store is accessed safely between the reclaimer and
the page fault handler. The scenarios to consider here are:
(a) faulting a page right after it was reclaimed,
(b) faulting a page and reclaiming another page that are
    sharing a PCMD page.

The reclaimer obtains pages from the backing storage without
holding the enclave mutex and runs the risk of concurrently
accessing the backing storage with the page fault handler that
does access the backing storage with the enclave mutex held.

In the scenario below a page is written to the backing store
by the reclaimer and then immediately faulted back, before
the reclaimer is able to set the dirty bit of the page:

sgx_reclaim_pages() {                    sgx_vma_fault() {
...                                      ...
/* write data to backing store */
sgx_reclaimer_write();
                                         mutex_lock(&encl->lock);
                                         __sgx_encl_eldu() {
                                         ...
                                         /* page not dirty -
                                          * contents may not be
                                          * up to date
                                         */
                                         sgx_encl_get_backing();
                                         ...
                                         }
                                         ...
/* set page dirty */
sgx_encl_put_backing();
...
                                         mutex_unlock(&encl->lock);
}                                        }

While it is not possible to concurrently reclaim and fault the same
enclave page the PCMD pages are shared between enclave pages
in the enclave and enclave pages in the backing store.
In the below scenario a PCMD page is truncated from the backing
store after all its pages have been loaded in to the enclave
at the same time the PCMD page is loaded from the backing store
when one of its pages are reclaimed:

sgx_reclaim_pages() {              sgx_vma_fault() {
                                     ...
                                     mutex_lock(&encl->lock);
                                     ...
                                     __sgx_encl_eldu() {
                                       ...
                                       if (pcmd_page_empty) {
/*
 * EPC page being reclaimed              /*
 * shares a PCMD page with an             * PCMD page truncated
 * enclave page that is being             * while requested from
 * faulted in.                            * reclaimer.
 */                                       */
sgx_encl_get_backing()  <---------->      sgx_encl_truncate_backing_page()
                                        }
}                                    }

Protect the reclaimer's backing store access with the enclave's mutex
to ensure that it can safely run concurrently with the page fault handler.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 0e8741a80cf3..ae79b8d6f645 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -252,6 +252,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 	sgx_encl_ewb(epc_page, backing);
 	encl_page->epc_page = NULL;
 	encl->secs_child_cnt--;
+	sgx_encl_put_backing(backing, true);
 
 	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
 		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
@@ -323,11 +324,14 @@ static void sgx_reclaim_pages(void)
 			goto skip;
 
 		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
+
+		mutex_lock(&encl_page->encl->lock);
 		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&encl_page->encl->lock);
 			goto skip;
+		}
 
-		mutex_lock(&encl_page->encl->lock);
 		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
 		mutex_unlock(&encl_page->encl->lock);
 		continue;
@@ -355,7 +359,6 @@ static void sgx_reclaim_pages(void)
 
 		encl_page = epc_page->owner;
 		sgx_reclaimer_write(epc_page, &backing[i]);
-		sgx_encl_put_backing(&backing[i], true);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
-- 
2.25.1

