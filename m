Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D54EBC433F5
	for <linux-sgx@archiver.kernel.org>; Mon,  9 May 2022 21:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiEIVxg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 17:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiEIVwZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 17:52:25 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9737C2734EB
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 14:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652132894; x=1683668894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mduTokMMrJYVyD5/g6ZiIHRpR8h3VCNe5bSzvlrzGVY=;
  b=QP/5bNrcBcxpWZT4tsBQVAq8/keRphklxHDHN4yZAdpDRyMyPv0dCdnJ
   pNH4zTzwlxwAYi/SraafxqHbPR7rtqU/AzWS5c+utx04m9A69PGDZtc5X
   lw2bJeieZCDrgrY2XlF3ONrVvsuTkLvMtKXgi+mOkPSlH2FyVtMJ/JghV
   qIybS9rr1JeCHqpQznFJ65e4PO5Q355+SVxqdmJD1Cc0TtO8gVuQDgAaG
   Jc/YrkCzTYmV5s6YhXpMCDggGL6zmPYUqEn/cykxrNwlv+ERiLMLcNXcQ
   bNDTQUui/6SDYpL+DDMm/CcXeI4ckl53qGMan4Q9qn7akhNL6A6vg4Y5E
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="332212852"
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="332212852"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 14:48:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="565293490"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 14:48:08 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Subject: [PATCH V2 1/5] x86/sgx: Disconnect backing page references from dirty status
Date:   Mon,  9 May 2022 14:47:59 -0700
Message-Id: <4cda80a0049de6bc47480b4ad119091027c11d45.1652131695.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1652131695.git.reinette.chatre@intel.com>
References: <cover.1652131695.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

sgx_encl_put_backing() is used to release references to the
backing storage and, optionally, mark both backing store pages
as dirty.

Managing references and dirty status together has two consequences:
1) Both backing store pages are marked as dirty, even if only one of
   the backing store pages are changed.
2) Backing store pages are marked dirty after the important data
   has been written to it. This is against the custom of marking
   pages as dirty before important data are written to them.

Remove the option to sgx_encl_put_backing() to set the backing
pages as dirty and set the needed pages as dirty right before
receiving important data. This aligns the usage with the
existing custom and prepares the code for a following change
where only one of the backing pages need to be marked as dirty.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 10 ++--------
 arch/x86/kernel/cpu/sgx/encl.h |  2 +-
 arch/x86/kernel/cpu/sgx/main.c |  6 ++++--
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7c63a1911fae..398695a20605 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -94,7 +94,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	kunmap_atomic(pcmd_page);
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
-	sgx_encl_put_backing(&b, false);
+	sgx_encl_put_backing(&b);
 
 	sgx_encl_truncate_backing_page(encl, page_index);
 
@@ -645,15 +645,9 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 /**
  * sgx_encl_put_backing() - Unpin the backing storage
  * @backing:	data for accessing backing storage for the page
- * @do_write:	mark pages dirty
  */
-void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write)
+void sgx_encl_put_backing(struct sgx_backing *backing)
 {
-	if (do_write) {
-		set_page_dirty(backing->pcmd);
-		set_page_dirty(backing->contents);
-	}
-
 	put_page(backing->pcmd);
 	put_page(backing->contents);
 }
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index fec43ca65065..d44e7372151f 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -107,7 +107,7 @@ void sgx_encl_release(struct kref *ref);
 int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
 int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 			 struct sgx_backing *backing);
-void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write);
+void sgx_encl_put_backing(struct sgx_backing *backing);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8e4bc6453d26..fad3d6c4756e 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -190,6 +190,8 @@ static int __sgx_encl_ewb(struct sgx_epc_page *epc_page, void *va_slot,
 	pginfo.metadata = (unsigned long)kmap_atomic(backing->pcmd) +
 			  backing->pcmd_offset;
 
+	set_page_dirty(backing->pcmd);
+	set_page_dirty(backing->contents);
 	ret = __ewb(&pginfo, sgx_get_epc_virt_addr(epc_page), va_slot);
 
 	kunmap_atomic((void *)(unsigned long)(pginfo.metadata -
@@ -320,7 +322,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 		sgx_encl_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 
-		sgx_encl_put_backing(&secs_backing, true);
+		sgx_encl_put_backing(&secs_backing);
 	}
 
 out:
@@ -411,7 +413,7 @@ static void sgx_reclaim_pages(void)
 
 		encl_page = epc_page->owner;
 		sgx_reclaimer_write(epc_page, &backing[i]);
-		sgx_encl_put_backing(&backing[i], true);
+		sgx_encl_put_backing(&backing[i]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
-- 
2.25.1

