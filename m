Return-Path: <SRS0=RnOm=7L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56426C433E2
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4328F2074D
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgE2RyN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 May 2020 13:54:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:51589 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbgE2RyM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 29 May 2020 13:54:12 -0400
IronPort-SDR: uONlsrNg8bnJNbaBUvEDJdYXID9ofzYdQg2XHEptEBONZEdlGp4++hY3ZAe5LAp24s5dy7Ckar
 xT/i3MX6PoiQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:54:09 -0700
IronPort-SDR: oyaowmBIHQMqk0AcOoYuAQLO+xs9vPYJSD2IVwF0Shv5Cr32Mfu1lh26hy+tJIKat+jaEMCntY
 Etxoiz84k4cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="271292327"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 29 May 2020 10:54:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v31 3/6] x86/sgx: Rename sgx_free_page() to sgx_free_epc_page()
Date:   Fri, 29 May 2020 10:54:04 -0700
Message-Id: <20200529175407.2109-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200529175407.2109-1-sean.j.christopherson@intel.com>
References: <20200529175407.2109-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add "epc" into the free page helper to match sgx_alloc_epc_page().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c  | 10 +++++-----
 arch/x86/kernel/cpu/sgx/ioctl.c |  6 +++---
 arch/x86/kernel/cpu/sgx/main.c  | 12 ++++++------
 arch/x86/kernel/cpu/sgx/sgx.h   |  2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index c52c937b8d67b..e9d72f05a1f12 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -73,7 +73,7 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
 
 	ret = __sgx_encl_eldu(encl_page, epc_page, secs_page);
 	if (ret) {
-		sgx_free_page(epc_page);
+		sgx_free_epc_page(epc_page);
 		return ERR_PTR(ret);
 	}
 
@@ -482,7 +482,7 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 			if (sgx_unmark_page_reclaimable(entry->epc_page))
 				continue;
 
-			sgx_free_page(entry->epc_page);
+			sgx_free_epc_page(entry->epc_page);
 			encl->secs_child_cnt--;
 			entry->epc_page = NULL;
 		}
@@ -493,7 +493,7 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 	}
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
-		sgx_free_page(encl->secs.epc_page);
+		sgx_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
 
@@ -506,7 +506,7 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
-		sgx_free_page(va_page->epc_page);
+		sgx_free_epc_page(va_page->epc_page);
 		kfree(va_page);
 	}
 }
@@ -706,7 +706,7 @@ struct sgx_epc_page *sgx_grab_va_page(void)
 	ret = __epa(sgx_get_epc_addr(epc_page));
 	if (ret) {
 		WARN_ONCE(1, "EPA returned %d (0x%x)", ret, ret);
-		sgx_free_page(epc_page);
+		sgx_free_epc_page(epc_page);
 		return ERR_PTR(-EFAULT);
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 2019ee1dc0b3e..f7232a5343262 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -50,7 +50,7 @@ static void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
 	encl->page_cnt--;
 
 	if (va_page) {
-		sgx_free_page(va_page->epc_page);
+		sgx_free_epc_page(va_page->epc_page);
 		list_del(&va_page->list);
 		kfree(va_page);
 	}
@@ -223,7 +223,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	return 0;
 
 err_out:
-	sgx_free_page(encl->secs.epc_page);
+	sgx_free_epc_page(encl->secs.epc_page);
 	encl->secs.epc_page = NULL;
 
 err_out_backing:
@@ -449,7 +449,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	up_read(&current->mm->mmap_sem);
 
 err_out_free:
-	sgx_free_page(epc_page);
+	sgx_free_epc_page(epc_page);
 	kfree(encl_page);
 
 	/*
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ef7061bfa2a07..855b14237e7c4 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -376,7 +376,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 
 	if (!encl->secs_child_cnt) {
 		if (atomic_read(&encl->flags) & SGX_ENCL_DEAD) {
-			sgx_free_page(encl->secs.epc_page);
+			sgx_free_epc_page(encl->secs.epc_page);
 			encl->secs.epc_page = NULL;
 		} else if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) {
 			ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
@@ -386,7 +386,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 
 			sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
 
-			sgx_free_page(encl->secs.epc_page);
+			sgx_free_epc_page(encl->secs.epc_page);
 			encl->secs.epc_page = NULL;
 
 			sgx_encl_put_backing(&secs_backing, true);
@@ -508,7 +508,7 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
  * __sgx_alloc_epc_page() - Grab a free EPC page
  *
  * Iterate through EPC sections and borrow a free EPC page to the caller. When a
- * page is no longer needed it must be released with sgx_free_page().
+ * page is no longer needed it must be released with sgx_free_epc_page().
  *
  * Return:
  *   an EPC page,
@@ -539,7 +539,7 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
  * @reclaim:	reclaim pages if necessary
  *
  * Iterate through EPC sections and borrow a free EPC page to the caller. When a
- * page is no longer needed it must be released with sgx_free_page(). If
+ * page is no longer needed it must be released with sgx_free_epc_page(). If
  * @reclaim is set to true, directly reclaim pages when we are out of pages. No
  * mm's can be locked when @reclaim is set to true.
  *
@@ -585,12 +585,12 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 }
 
 /**
- * sgx_free_page() - Free an EPC page
+ * sgx_free_epc_page() - Free an EPC page
  * @page:	an EPC page
  *
  * Call EREMOVE for an EPC page and insert it back to the list of free pages.
  */
-void sgx_free_page(struct sgx_epc_page *page)
+void sgx_free_epc_page(struct sgx_epc_page *page)
 {
 	struct sgx_epc_section *section = sgx_get_epc_section(page);
 	int ret;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 5b9dbcef981b0..2983c1a3d725d 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -62,6 +62,6 @@ static inline void *sgx_get_epc_addr(struct sgx_epc_page *page)
 
 struct sgx_epc_page *__sgx_alloc_epc_page(void);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
-void sgx_free_page(struct sgx_epc_page *page);
+void sgx_free_epc_page(struct sgx_epc_page *page);
 
 #endif /* _X86_SGX_H */
-- 
2.26.0

