Return-Path: <SRS0=WfLj=WR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BB3C3A59E
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Aug 2019 23:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BC2A22DD3
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Aug 2019 23:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfHUX3P (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 19:29:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:20495 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbfHUX3P (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 19:29:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 16:29:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,414,1559545200"; 
   d="scan'208";a="354095495"
Received: from soegtrop-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.52.79])
  by orsmga005.jf.intel.com with ESMTP; 21 Aug 2019 16:29:12 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 2/2] x86/sgx: Determine SECS at compile time in sgx_encl_eldu()
Date:   Thu, 22 Aug 2019 02:29:02 +0300
Message-Id: <20190821232902.29476-3-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190821232902.29476-1-jarkko.sakkinen@linux.intel.com>
References: <20190821232902.29476-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Using address resolution of any kind is obviously an overkill for
anything that we know at compile time. Those sites should not hard
bind how we store SECS.

This commit adds @secs_child to sgx_encl_eldu() and sgx_encl_ewb()
and replaces sgx_encl_get_index() with a macro SGX_ENCL_PAGE_INDEX()

The new macro assumes that it is operated on SECS children and it is a
right call because it neither makes sense to bind large architectural
decisions inside the smallest helpers (e.g. where and how we store SECS).

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c |  4 +--
 arch/x86/kernel/cpu/sgx/encl.c         | 50 ++++++++++++--------------
 arch/x86/kernel/cpu/sgx/encl.h         |  4 +--
 arch/x86/kernel/cpu/sgx/reclaim.c      | 34 +++++++++++-------
 4 files changed, 48 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 9b784a061a47..fbf2aa9da5fc 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -82,7 +82,7 @@ static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
 {
 	struct sgx_encl_page *encl_page = req->encl_page;
 	struct sgx_encl *encl = req->encl;
-	unsigned long page_index = sgx_encl_get_index(encl_page);
+	unsigned long page_index = SGX_ENCL_PAGE_INDEX(encl_page);
 	struct sgx_secinfo secinfo;
 	struct sgx_pageinfo pginfo;
 	struct page *backing;
@@ -475,7 +475,7 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 			       struct sgx_secinfo *secinfo,
 			       unsigned int mrmask)
 {
-	unsigned long page_index = sgx_encl_get_index(encl_page);
+	unsigned long page_index = SGX_ENCL_PAGE_INDEX(encl_page);
 	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
 	struct sgx_add_page_req *req = NULL;
 	struct page *backing;
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index d6397f7ef3b8..16d97198dafb 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -13,18 +13,26 @@
 #include "sgx.h"
 
 static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
-			   struct sgx_epc_page *epc_page)
+			   struct sgx_epc_page *epc_page, bool secs_child)
 {
 	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
 	struct sgx_encl *encl = encl_page->encl;
-	pgoff_t page_index = sgx_encl_get_index(encl_page);
-	pgoff_t pcmd_index = sgx_pcmd_index(encl, page_index);
-	unsigned long pcmd_offset = sgx_pcmd_offset(page_index);
 	struct sgx_pageinfo pginfo;
+	unsigned long pcmd_offset;
 	struct page *backing;
+	pgoff_t page_index;
+	pgoff_t pcmd_index;
 	struct page *pcmd;
 	int ret;
 
+	if (secs_child)
+		page_index = SGX_ENCL_PAGE_INDEX(encl_page);
+	else
+		page_index = PFN_DOWN(encl->size);
+
+	pcmd_index = sgx_pcmd_index(encl, page_index);
+	pcmd_offset = sgx_pcmd_offset(page_index);
+
 	backing = sgx_encl_get_backing_page(encl, page_index);
 	if (IS_ERR(backing)) {
 		ret = PTR_ERR(backing);
@@ -40,8 +48,11 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
 	pginfo.contents = (unsigned long)kmap_atomic(backing);
 	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
-	pginfo.secs = SGX_ENCL_PAGE_IS_SECS(encl_page) ? 0 :
-			(unsigned long)sgx_epc_addr(encl->secs.epc_page);
+
+	if (secs_child)
+		pginfo.secs = (u64)sgx_epc_addr(encl->secs.epc_page);
+	else
+		pginfo.secs = 0;
 
 	ret = __eldu(&pginfo, sgx_epc_addr(epc_page),
 		     sgx_epc_addr(encl_page->va_page->epc_page) + va_offset);
@@ -64,7 +75,8 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	return ret;
 }
 
-static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page)
+static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
+					  bool secs_child)
 {
 	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
 	struct sgx_encl *encl = encl_page->encl;
@@ -75,7 +87,7 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page)
 	if (IS_ERR(epc_page))
 		return epc_page;
 
-	ret = __sgx_encl_eldu(encl_page, epc_page);
+	ret = __sgx_encl_eldu(encl_page, epc_page, secs_child);
 	if (ret) {
 		sgx_free_page(epc_page);
 		return ERR_PTR(ret);
@@ -118,12 +130,12 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 	}
 
 	if (!(encl->secs.epc_page)) {
-		epc_page = sgx_encl_eldu(&encl->secs);
+		epc_page = sgx_encl_eldu(&encl->secs, false);
 		if (IS_ERR(epc_page))
 			return ERR_CAST(epc_page);
 	}
 
-	epc_page = sgx_encl_eldu(entry);
+	epc_page = sgx_encl_eldu(entry, true);
 	if (IS_ERR(epc_page))
 		return ERR_CAST(epc_page);
 
@@ -534,24 +546,6 @@ void sgx_encl_release(struct kref *ref)
 	kfree(encl);
 }
 
-/**
- * sgx_encl_get_index() - Convert a page descriptor to a page index
- * @page:	an enclave page
- *
- * Given an enclave page descriptor, convert it to a page index used to access
- * backing storage. The backing page for SECS is located after the enclave
- * pages.
- */
-pgoff_t sgx_encl_get_index(struct sgx_encl_page *page)
-{
-	struct sgx_encl *encl = page->encl;
-
-	if (SGX_ENCL_PAGE_IS_SECS(page))
-		return PFN_DOWN(encl->size);
-
-	return PFN_DOWN(page->desc - encl->base);
-}
-
 /**
  * sgx_encl_encl_get_backing_page() - Pin the backing page
  * @encl:	an enclave
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index d3a1687ed84c..b7d4494d09ba 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -40,7 +40,8 @@ enum sgx_encl_page_desc {
 	((page)->desc & SGX_ENCL_PAGE_ADDR_MASK)
 #define SGX_ENCL_PAGE_VA_OFFSET(page) \
 	((page)->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK)
-#define SGX_ENCL_PAGE_IS_SECS(page) ((page) == &(page)->encl->secs)
+#define SGX_ENCL_PAGE_INDEX(page) \
+	PFN_DOWN((page)->desc - (page)->encl->base)
 
 struct sgx_encl_page {
 	unsigned long desc;
@@ -120,7 +121,6 @@ int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
 		  struct vm_area_struct **vma);
 void sgx_encl_destroy(struct sgx_encl *encl);
 void sgx_encl_release(struct kref *ref);
-pgoff_t sgx_encl_get_index(struct sgx_encl_page *page);
 struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index);
 int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 7da9631ed434..6acc9d41aab3 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -220,17 +220,26 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 }
 
 static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
-			  struct sgx_va_page *va_page, unsigned int va_offset)
+			  struct sgx_va_page *va_page, unsigned int va_offset,
+			  bool secs_child)
 {
 	struct sgx_encl_page *encl_page = epc_page->owner;
-	pgoff_t page_index = sgx_encl_get_index(encl_page);
-	pgoff_t pcmd_index = sgx_pcmd_index(encl, page_index);
-	unsigned long pcmd_offset = sgx_pcmd_offset(page_index);
 	struct sgx_pageinfo pginfo;
+	unsigned long pcmd_offset;
 	struct page *backing;
+	pgoff_t page_index;
+	pgoff_t pcmd_index;
 	struct page *pcmd;
 	int ret;
 
+	if (secs_child)
+		page_index = SGX_ENCL_PAGE_INDEX(encl_page);
+	else
+		page_index = PFN_DOWN(encl->size);
+
+	pcmd_index = sgx_pcmd_index(encl, page_index);
+	pcmd_offset = sgx_pcmd_offset(page_index);
+
 	backing = sgx_encl_get_backing_page(encl, page_index);
 	if (IS_ERR(backing)) {
 		ret = PTR_ERR(backing);
@@ -291,7 +300,7 @@ static const cpumask_t *sgx_encl_ewb_cpumask(struct sgx_encl *encl)
 	return cpumask;
 }
 
-static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool do_free)
+static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool secs_child)
 {
 	struct sgx_encl_page *encl_page = epc_page->owner;
 	struct sgx_encl *encl = encl_page->encl;
@@ -308,7 +317,8 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool do_free)
 		if (sgx_va_page_full(va_page))
 			list_move_tail(&va_page->list, &encl->va_pages);
 
-		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset);
+		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
+				     secs_child);
 		if (ret == SGX_NOT_TRACKED) {
 			ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
 			if (ret) {
@@ -318,7 +328,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool do_free)
 			}
 
 			ret = __sgx_encl_ewb(encl, epc_page, va_page,
-					     va_offset);
+					     va_offset, secs_child);
 			if (ret == SGX_NOT_TRACKED) {
 				/*
 				 * Slow path, send IPIs to kick cpus out of the
@@ -330,7 +340,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool do_free)
 				on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
 						 sgx_ipi_cb, NULL, 1);
 				ret = __sgx_encl_ewb(encl, epc_page, va_page,
-						     va_offset);
+						     va_offset, secs_child);
 			}
 		}
 
@@ -340,12 +350,12 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool do_free)
 
 		encl_page->desc |= va_offset;
 		encl_page->va_page = va_page;
-	} else if (!do_free) {
+	} else if (secs_child) {
 		ret = __eremove(sgx_epc_addr(epc_page));
 		WARN(ret, "EREMOVE returned %d\n", ret);
 	}
 
-	if (do_free)
+	if (!secs_child)
 		sgx_free_page(epc_page);
 
 	encl_page->epc_page = NULL;
@@ -358,11 +368,11 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
 
 	mutex_lock(&encl->lock);
 
-	sgx_encl_ewb(epc_page, false);
+	sgx_encl_ewb(epc_page, true);
 	encl->secs_child_cnt--;
 	if (!encl->secs_child_cnt &&
 	    (encl->flags & (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED))) {
-		sgx_encl_ewb(encl->secs.epc_page, true);
+		sgx_encl_ewb(encl->secs.epc_page, false);
 	}
 
 	mutex_unlock(&encl->lock);
-- 
2.20.1

