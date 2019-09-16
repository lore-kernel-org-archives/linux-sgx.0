Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC5BC4CECF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E0AC214AF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfIPEPl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:15:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:16475 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEPl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:15:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:15:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387076132"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:15:39 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v2 16/17] x86/sgx: Introduce sgx_encl_get_backing()
Date:   Mon, 16 Sep 2019 07:14:16 +0300
Message-Id: <20190916041417.12533-17-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Since __sgx_encl_eldu() and __sgx_encl_ewb() pin the backing storage in the
same way, consolidate this to sgx_encl_get_backing() replacing
sgx_encl_get_backing_page().

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c    | 86 +++++++++++++++++++------------
 arch/x86/kernel/cpu/sgx/encl.h    | 20 +++----
 arch/x86/kernel/cpu/sgx/reclaim.c | 39 ++++----------
 3 files changed, 71 insertions(+), 74 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 66762b9c1517..a71414ce05b1 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -17,11 +17,8 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
 	struct sgx_encl *encl = encl_page->encl;
 	struct sgx_pageinfo pginfo;
-	unsigned long pcmd_offset;
-	struct page *backing;
+	struct sgx_backing b;
 	pgoff_t page_index;
-	pgoff_t pcmd_index;
-	struct page *pcmd;
 	int ret;
 
 	if (secs_page)
@@ -29,24 +26,14 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	else
 		page_index = PFN_DOWN(encl->size);
 
-	pcmd_index = sgx_pcmd_index(encl, page_index);
-	pcmd_offset = sgx_pcmd_offset(page_index);
-
-	backing = sgx_encl_get_backing_page(encl, page_index);
-	if (IS_ERR(backing)) {
-		ret = PTR_ERR(backing);
-		goto err_backing;
-	}
-
-	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
-	if (IS_ERR(pcmd)) {
-		ret = PTR_ERR(pcmd);
-		goto err_pcmd;
-	}
+	ret = sgx_encl_get_backing(encl, page_index, &b);
+	if (ret)
+		return ret;
 
 	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
-	pginfo.contents = (unsigned long)kmap_atomic(backing);
-	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
+	pginfo.contents = (unsigned long)kmap_atomic(b.contents);
+	pginfo.metadata = (unsigned long)kmap_atomic(b.pcmd) +
+			  b.pcmd_offset;
 
 	if (secs_page)
 		pginfo.secs = (u64)sgx_epc_addr(secs_page);
@@ -62,15 +49,12 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 		ret = -EFAULT;
 	}
 
-	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
+	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - b.pcmd_offset));
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
-	put_page(pcmd);
+	put_page(b.pcmd);
+	put_page(b.contents);
 
-err_pcmd:
-	put_page(backing);
-
-err_backing:
 	return ret;
 }
 
@@ -537,14 +521,8 @@ void sgx_encl_release(struct kref *ref)
 	kfree(encl);
 }
 
-/**
- * sgx_encl_encl_get_backing_page() - Pin the backing page
- * @encl:	an enclave
- * @index:	page index
- *
- * Return: the pinned backing page
- */
-struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index)
+static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
+					      pgoff_t index)
 {
 	struct inode *inode = encl->backing->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
@@ -553,6 +531,46 @@ struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index)
 	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
 }
 
+/**
+ * sgx_encl_get_backing() - Access the backing storage
+ * @encl:	an enclave
+ * @page_index:	enclave page index
+ * @backing:	data for accessing backing storage for the page
+ *
+ * Pin the backing storage pages for storing the encrypted contents and Paging
+ * Crypto MetaData (PCMD) of an enclave page.
+ *
+ * Return:
+ *   0 on success,
+ *   -errno otherwise.
+ */
+int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
+			 struct sgx_backing *backing)
+{
+	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
+	struct page *contents;
+	struct page *pcmd;
+
+	contents = sgx_encl_get_backing_page(encl, page_index);
+	if (IS_ERR(contents))
+		return PTR_ERR(contents);
+
+	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
+	if (IS_ERR(pcmd)) {
+		put_page(contents);
+		return PTR_ERR(pcmd);
+	}
+
+	backing->page_index = page_index;
+	backing->contents = contents;
+	backing->pcmd = pcmd;
+	backing->pcmd_offset =
+		(page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
+		sizeof(struct sgx_pcmd);
+
+	return 0;
+}
+
 static int sgx_encl_test_and_clear_young_cb(pte_t *ptep, unsigned long addr,
 					    void *data)
 {
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index c7abca1fcb9d..59bc4a5bf7e6 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -97,23 +97,19 @@ struct sgx_va_page {
 
 extern const struct vm_operations_struct sgx_vm_ops;
 
-static inline pgoff_t sgx_pcmd_index(struct sgx_encl *encl,
-				     pgoff_t page_index)
-{
-	return PFN_DOWN(encl->size) + 1 + (page_index >> 5);
-}
-
-static inline unsigned long sgx_pcmd_offset(pgoff_t page_index)
-{
-	return (page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
-	       sizeof(struct sgx_pcmd);
-}
+struct sgx_backing {
+	pgoff_t page_index;
+	struct page *contents;
+	struct page *pcmd;
+	unsigned long pcmd_offset;
+};
 
 int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
 		  struct vm_area_struct **vma);
 void sgx_encl_destroy(struct sgx_encl *encl);
 void sgx_encl_release(struct kref *ref);
-struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index);
+int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
+			 struct sgx_backing *backing);
 int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index e06e9489a5d1..aa13556689ac 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -209,47 +209,30 @@ static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
 			  unsigned int page_index)
 {
 	struct sgx_pageinfo pginfo;
-	unsigned long pcmd_offset;
-	struct page *backing;
-	pgoff_t pcmd_index;
-	struct page *pcmd;
+	struct sgx_backing b;
 	int ret;
 
-	pcmd_index = sgx_pcmd_index(encl, page_index);
-	pcmd_offset = sgx_pcmd_offset(page_index);
-
-	backing = sgx_encl_get_backing_page(encl, page_index);
-	if (IS_ERR(backing)) {
-		ret = PTR_ERR(backing);
-		goto err_backing;
-	}
-
-	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
-	if (IS_ERR(pcmd)) {
-		ret = PTR_ERR(pcmd);
-		goto err_pcmd;
-	}
+	ret = sgx_encl_get_backing(encl, page_index, &b);
+	if (ret)
+		return ret;
 
 	pginfo.addr = 0;
-	pginfo.contents = (unsigned long)kmap_atomic(backing);
-	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
+	pginfo.contents = (unsigned long)kmap_atomic(b.contents);
+	pginfo.metadata = (unsigned long)kmap_atomic(b.pcmd) + b.pcmd_offset;
 	pginfo.secs = 0;
 	ret = __ewb(&pginfo, sgx_epc_addr(epc_page),
 		    sgx_epc_addr(va_page->epc_page) + va_offset);
-	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
+	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - b.pcmd_offset));
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
 	if (!ret) {
-		set_page_dirty(pcmd);
-		set_page_dirty(backing);
+		set_page_dirty(b.pcmd);
+		set_page_dirty(b.contents);
 	}
 
-	put_page(pcmd);
-
-err_pcmd:
-	put_page(backing);
+	put_page(b.pcmd);
+	put_page(b.contents);
 
-err_backing:
 	return ret;
 }
 
-- 
2.20.1

