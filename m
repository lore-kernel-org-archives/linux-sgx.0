Return-Path: <SRS0=NgZr=W6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB96C3A5A2
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 14:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96ED0206B8
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 14:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbfICO3N (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:29:13 -0400
Received: from mga12.intel.com ([192.55.52.136]:46590 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729560AbfICO3N (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 3 Sep 2019 10:29:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 07:29:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="189826117"
Received: from vkuppusa-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.39.67])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Sep 2019 07:29:03 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v22 14/24] x86/sgx: Add a page reclaimer
Date:   Tue,  3 Sep 2019 17:26:45 +0300
Message-Id: <20190903142655.21943-15-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

There is a limited amount of SGX reserved memory available. Therefore,
some of it must be copied to the regular memory, and only subset kept in
the SGX reserved memory. While kernel cannot directly access enclave
memory, SGX provides ENCLS leaf functions to perform reclaiming
functionality.

This commits implements a page reclaimer by using these leaf functions,
which picks the victim pages in LRU fashion from all enclaves running in
an enclave's pages back to the SGX reserved memory.

The thread ksgxswapd reclaims pages on the event when the number of free
EPC pages goes below %SGX_NR_LOW_PAGES up until it reaches
%SGX_NR_HIGH_PAGES.

sgx_alloc_page() can now optionally reclaim pages with @reclaim boolean
parameter. The caller must also supply owner for each page so that the
reclaimer can access the associated enclaves. This is needed for locking,
as most of the ENCLS leafs cannot be executed concurrently for an enclave,
and accessing SECS, which is required to be resident when its child pages
are being reclaimed.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c  |   1 +
 arch/x86/kernel/cpu/sgx/encl.c    | 293 ++++++++++++++++++++--
 arch/x86/kernel/cpu/sgx/encl.h    |  48 +++-
 arch/x86/kernel/cpu/sgx/ioctl.c   |  82 ++++++-
 arch/x86/kernel/cpu/sgx/main.c    |  92 +++++--
 arch/x86/kernel/cpu/sgx/reclaim.c | 393 +++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h     |  18 +-
 7 files changed, 870 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index f046518cbdf6..a1da479ffd3a 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -33,6 +33,7 @@ static int sgx_open(struct inode *inode, struct file *file)
 
 	atomic_set(&encl->flags, 0);
 	kref_init(&encl->refcount);
+	INIT_LIST_HEAD(&encl->va_pages);
 	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
 	mutex_init(&encl->lock);
 	INIT_LIST_HEAD(&encl->mm_list);
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 72b147bf0030..48306a868292 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -9,11 +9,103 @@
 #include <linux/sched/mm.h>
 #include "arch.h"
 #include "encl.h"
+#include "encls.h"
 #include "sgx.h"
 
+static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
+			   struct sgx_epc_page *epc_page,
+			   struct sgx_epc_page *secs_page)
+{
+	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
+	struct sgx_encl *encl = encl_page->encl;
+	struct sgx_pageinfo pginfo;
+	unsigned long pcmd_offset;
+	struct page *backing;
+	pgoff_t page_index;
+	pgoff_t pcmd_index;
+	struct page *pcmd;
+	int ret;
+
+	if (secs_page)
+		page_index = SGX_ENCL_PAGE_INDEX(encl_page);
+	else
+		page_index = PFN_DOWN(encl->size);
+
+	pcmd_index = sgx_pcmd_index(encl, page_index);
+	pcmd_offset = sgx_pcmd_offset(page_index);
+
+	backing = sgx_encl_get_backing_page(encl, page_index);
+	if (IS_ERR(backing)) {
+		ret = PTR_ERR(backing);
+		goto err_backing;
+	}
+
+	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
+	if (IS_ERR(pcmd)) {
+		ret = PTR_ERR(pcmd);
+		goto err_pcmd;
+	}
+
+	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
+	pginfo.contents = (unsigned long)kmap_atomic(backing);
+	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
+
+	if (secs_page)
+		pginfo.secs = (u64)sgx_epc_addr(secs_page);
+	else
+		pginfo.secs = 0;
+
+	ret = __eldu(&pginfo, sgx_epc_addr(epc_page),
+		     sgx_epc_addr(encl_page->va_page->epc_page) + va_offset);
+	if (ret) {
+		if (encls_failed(ret) || encls_returned_code(ret))
+			ENCLS_WARN(ret, "ELDU");
+
+		ret = -EFAULT;
+	}
+
+	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
+	kunmap_atomic((void *)(unsigned long)pginfo.contents);
+
+	put_page(pcmd);
+
+err_pcmd:
+	put_page(backing);
+
+err_backing:
+	return ret;
+}
+
+static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
+					  struct sgx_epc_page *secs_page)
+{
+	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
+	struct sgx_encl *encl = encl_page->encl;
+	struct sgx_epc_page *epc_page;
+	int ret;
+
+	epc_page = sgx_alloc_page(encl_page, false);
+	if (IS_ERR(epc_page))
+		return epc_page;
+
+	ret = __sgx_encl_eldu(encl_page, epc_page, secs_page);
+	if (ret) {
+		sgx_free_page(epc_page);
+		return ERR_PTR(ret);
+	}
+
+	sgx_free_va_slot(encl_page->va_page, va_offset);
+	list_move(&encl_page->va_page->list, &encl->va_pages);
+	encl_page->desc &= ~SGX_ENCL_PAGE_VA_OFFSET_MASK;
+	encl_page->epc_page = epc_page;
+
+	return epc_page;
+}
+
 static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 						unsigned long addr)
 {
+	struct sgx_epc_page *epc_page;
 	struct sgx_encl_page *entry;
 	unsigned int flags;
 
@@ -33,10 +125,27 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 		return ERR_PTR(-EFAULT);
 
 	/* Page is already resident in the EPC. */
-	if (entry->epc_page)
+	if (entry->epc_page) {
+		if (entry->desc & SGX_ENCL_PAGE_RECLAIMED)
+			return ERR_PTR(-EBUSY);
+
 		return entry;
+	}
 
-	return ERR_PTR(-EFAULT);
+	if (!(encl->secs.epc_page)) {
+		epc_page = sgx_encl_eldu(&encl->secs, NULL);
+		if (IS_ERR(epc_page))
+			return ERR_CAST(epc_page);
+	}
+
+	epc_page = sgx_encl_eldu(entry, encl->secs.epc_page);
+	if (IS_ERR(epc_page))
+		return ERR_CAST(epc_page);
+
+	encl->secs_child_cnt++;
+	sgx_mark_page_reclaimable(entry->epc_page);
+
+	return entry;
 }
 
 static void sgx_encl_mm_release_deferred(struct rcu_head *rcu)
@@ -186,6 +295,8 @@ static unsigned int sgx_vma_fault(struct vm_fault *vmf)
 		goto out;
 	}
 
+	sgx_encl_test_and_clear_young(vma->vm_mm, entry);
+
 out:
 	mutex_unlock(&encl->lock);
 	return ret;
@@ -283,6 +394,7 @@ int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
  */
 void sgx_encl_destroy(struct sgx_encl *encl)
 {
+	struct sgx_va_page *va_page;
 	struct sgx_encl_page *entry;
 	struct radix_tree_iter iter;
 	void **slot;
@@ -307,6 +419,15 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 		sgx_free_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
+
+
+	while (!list_empty(&encl->va_pages)) {
+		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
+					   list);
+		list_del(&va_page->list);
+		sgx_free_page(va_page->epc_page);
+		kfree(va_page);
+	}
 }
 
 /**
@@ -331,35 +452,169 @@ void sgx_encl_release(struct kref *ref)
 }
 
 /**
- * sgx_encl_get_index() - Convert a page descriptor to a page index
- * @page:	an enclave page
+ * sgx_encl_encl_get_backing_page() - Pin the backing page
+ * @encl:	an enclave
+ * @index:	page index
  *
- * Given an enclave page descriptor, convert it to a page index used to access
- * backing storage. The backing page for SECS is located after the enclave
- * pages.
+ * Return: the pinned backing page
  */
-pgoff_t sgx_encl_get_index(struct sgx_encl_page *page)
+struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index)
 {
+	struct inode *inode = encl->backing->f_path.dentry->d_inode;
+	struct address_space *mapping = inode->i_mapping;
+	gfp_t gfpmask = mapping_gfp_mask(mapping);
+
+	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
+}
+
+static int sgx_encl_test_and_clear_young_cb(pte_t *ptep, unsigned long addr,
+					    void *data)
+{
+	pte_t pte;
+	int ret;
+
+	ret = pte_young(*ptep);
+	if (ret) {
+		pte = pte_mkold(*ptep);
+		set_pte_at((struct mm_struct *)data, addr, ptep, pte);
+	}
+
+	return ret;
+}
+
+/**
+ * sgx_encl_test_and_clear_young() - Test and reset the accessed bit
+ * @mm:		mm_struct that is checked
+ * @page:	enclave page to be tested for recent access
+ *
+ * Checks the Access (A) bit from the PTE corresponding to the enclave page and
+ * clears it.
+ *
+ * Return: 1 if the page has been recently accessed and 0 if not.
+ */
+int sgx_encl_test_and_clear_young(struct mm_struct *mm,
+				  struct sgx_encl_page *page)
+{
+	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
 	struct sgx_encl *encl = page->encl;
+	struct vm_area_struct *vma;
+	int ret;
 
-	if (SGX_ENCL_PAGE_IS_SECS(page))
-		return PFN_DOWN(encl->size);
+	ret = sgx_encl_find(mm, addr, &vma);
+	if (ret)
+		return 0;
+
+	if (encl != vma->vm_private_data)
+		return 0;
 
-	return PFN_DOWN(page->desc - encl->base);
+	ret = apply_to_page_range(vma->vm_mm, addr, PAGE_SIZE,
+				  sgx_encl_test_and_clear_young_cb, vma->vm_mm);
+	if (ret < 0)
+		return 0;
+
+	return ret;
 }
 
 /**
- * sgx_encl_encl_get_backing_page() - Pin the backing page
+ * sgx_encl_reserve_page() - Reserve an enclave page
  * @encl:	an enclave
- * @index:	page index
+ * @addr:	a page address
  *
- * Return: the pinned backing page
+ * Load an enclave page and lock the enclave so that the page can be used by
+ * EDBG* and EMOD*.
+ *
+ * Return:
+ *   an enclave page on success
+ *   -EFAULT	if the load fails
  */
-struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index)
+struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
+					    unsigned long addr)
 {
-	struct inode *inode = encl->backing->f_path.dentry->d_inode;
-	struct address_space *mapping = inode->i_mapping;
-	gfp_t gfpmask = mapping_gfp_mask(mapping);
+	struct sgx_encl_page *entry;
 
-	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
+	for ( ; ; ) {
+		mutex_lock(&encl->lock);
+
+		entry = sgx_encl_load_page(encl, addr);
+		if (PTR_ERR(entry) != -EBUSY)
+			break;
+
+		mutex_unlock(&encl->lock);
+	}
+
+	if (IS_ERR(entry))
+		mutex_unlock(&encl->lock);
+
+	return entry;
+}
+
+/**
+ * sgx_alloc_page - allocate a VA page
+ *
+ * Allocates an &sgx_epc_page instance and converts it to a VA page.
+ *
+ * Return:
+ *   a &struct sgx_va_page instance,
+ *   -errno otherwise
+ */
+struct sgx_epc_page *sgx_alloc_va_page(void)
+{
+	struct sgx_epc_page *epc_page;
+	int ret;
+
+	epc_page = sgx_alloc_page(NULL, true);
+	if (IS_ERR(epc_page))
+		return ERR_CAST(epc_page);
+
+	ret = __epa(sgx_epc_addr(epc_page));
+	if (ret) {
+		WARN_ONCE(1, "sgx: EPA returned %d (0x%x)", ret, ret);
+		sgx_free_page(epc_page);
+		return ERR_PTR(-EFAULT);
+	}
+
+	return epc_page;
+}
+
+/**
+ * sgx_alloc_va_slot - allocate a VA slot
+ * @va_page:	a &struct sgx_va_page instance
+ *
+ * Allocates a slot from a &struct sgx_va_page instance.
+ *
+ * Return: offset of the slot inside the VA page
+ */
+unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page)
+{
+	int slot = find_first_zero_bit(va_page->slots, SGX_VA_SLOT_COUNT);
+
+	if (slot < SGX_VA_SLOT_COUNT)
+		set_bit(slot, va_page->slots);
+
+	return slot << 3;
+}
+
+/**
+ * sgx_free_va_slot - free a VA slot
+ * @va_page:	a &struct sgx_va_page instance
+ * @offset:	offset of the slot inside the VA page
+ *
+ * Frees a slot from a &struct sgx_va_page instance.
+ */
+void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset)
+{
+	clear_bit(offset >> 3, va_page->slots);
+}
+
+/**
+ * sgx_va_page_full - is the VA page full?
+ * @va_page:	a &struct sgx_va_page instance
+ *
+ * Return: true if all slots have been taken
+ */
+bool sgx_va_page_full(struct sgx_va_page *va_page)
+{
+	int slot = find_first_zero_bit(va_page->slots, SGX_VA_SLOT_COUNT);
+
+	return slot == SGX_VA_SLOT_COUNT;
 }
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index f0e6c22728b0..c7608964d69e 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -19,6 +19,10 @@
 /**
  * enum sgx_encl_page_desc - defines bits for an enclave page's descriptor
  * %SGX_ENCL_PAGE_TCS:			The page is a TCS page.
+ * %SGX_ENCL_PAGE_RECLAIMED:		The page is in the process of being
+ *					reclaimed.
+ * %SGX_ENCL_PAGE_VA_OFFSET_MASK:	Holds the offset in the Version Array
+ *					(VA) page for a swapped page.
  * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
  *
  * The page address for SECS is zero and is used by the subsystem to recognize
@@ -27,19 +31,23 @@
 enum sgx_encl_page_desc {
 	SGX_ENCL_PAGE_TCS		= BIT(0),
 	/* Bits 11:3 are available when the page is not swapped. */
+	SGX_ENCL_PAGE_RECLAIMED		= BIT(3),
+	SGX_ENCL_PAGE_VA_OFFSET_MASK	= GENMASK_ULL(11, 3),
 	SGX_ENCL_PAGE_ADDR_MASK		= PAGE_MASK,
 };
 
 #define SGX_ENCL_PAGE_ADDR(page) \
 	((page)->desc & SGX_ENCL_PAGE_ADDR_MASK)
-#define SGX_ENCL_PAGE_VA_OFFSET(encl_page) \
+#define SGX_ENCL_PAGE_VA_OFFSET(page) \
 	((page)->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK)
-#define SGX_ENCL_PAGE_IS_SECS(page) ((page) == &(page)->encl->secs)
+#define SGX_ENCL_PAGE_INDEX(page) \
+	PFN_DOWN((page)->desc - (page)->encl->base)
 
 struct sgx_encl_page {
 	unsigned long desc;
 	unsigned long vm_max_prot_bits;
 	struct sgx_epc_page *epc_page;
+	struct sgx_va_page *va_page;
 	struct sgx_encl *encl;
 };
 
@@ -74,27 +82,51 @@ struct sgx_encl {
 	unsigned long base;
 	unsigned long size;
 	unsigned long ssaframesize;
+	struct list_head va_pages;
 	struct radix_tree_root page_tree;
 	struct sgx_encl_page secs;
 	cpumask_t cpumask;
 };
 
-extern const struct vm_operations_struct sgx_vm_ops;
+#define SGX_VA_SLOT_COUNT 512
 
-enum sgx_encl_mm_iter {
-	SGX_ENCL_MM_ITER_DONE		= 0,
-	SGX_ENCL_MM_ITER_NEXT		= 1,
-	SGX_ENCL_MM_ITER_RESTART	= 2,
+struct sgx_va_page {
+	struct sgx_epc_page *epc_page;
+	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
+	struct list_head list;
 };
 
+extern const struct vm_operations_struct sgx_vm_ops;
+
+static inline pgoff_t sgx_pcmd_index(struct sgx_encl *encl,
+				     pgoff_t page_index)
+{
+	return PFN_DOWN(encl->size) + 1 + (page_index >> 5);
+}
+
+static inline unsigned long sgx_pcmd_offset(pgoff_t page_index)
+{
+	return (page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
+	       sizeof(struct sgx_pcmd);
+}
+
 int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
 		  struct vm_area_struct **vma);
 void sgx_encl_destroy(struct sgx_encl *encl);
 void sgx_encl_release(struct kref *ref);
-pgoff_t sgx_encl_get_index(struct sgx_encl_page *page);
 struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index);
 int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
+int sgx_encl_test_and_clear_young(struct mm_struct *mm,
+				  struct sgx_encl_page *page);
+struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
+					    unsigned long addr);
+
+struct sgx_epc_page *sgx_alloc_va_page(void);
+unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
+void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
+bool sgx_va_page_full(struct sgx_va_page *va_page);
 
 int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 		     unsigned long end, unsigned long vm_prot_bits);
+
 #endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 2fcdd080158e..e2205a433b87 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -14,6 +14,43 @@
 #include <linux/suspend.h>
 #include "driver.h"
 
+static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
+{
+	struct sgx_va_page *va_page = NULL;
+	void *err;
+
+	BUILD_BUG_ON(SGX_VA_SLOT_COUNT !=
+		(SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
+
+	if (!(encl->page_cnt % SGX_VA_SLOT_COUNT)) {
+		va_page = kzalloc(sizeof(*va_page), GFP_KERNEL);
+		if (!va_page)
+			return ERR_PTR(-ENOMEM);
+
+		va_page->epc_page = sgx_alloc_va_page();
+		if (IS_ERR(va_page->epc_page)) {
+			err = ERR_CAST(va_page->epc_page);
+			kfree(va_page);
+			return err;
+		}
+
+		WARN_ON_ONCE(encl->page_cnt % SGX_VA_SLOT_COUNT);
+	}
+	encl->page_cnt++;
+	return va_page;
+}
+
+static void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
+{
+	encl->page_cnt--;
+
+	if (va_page) {
+		sgx_free_page(va_page->epc_page);
+		list_del(&va_page->list);
+		kfree(va_page);
+	}
+}
+
 static u32 sgx_calc_ssaframesize(u32 miscselect, u64 xfrm)
 {
 	u32 size_max = PAGE_SIZE;
@@ -112,6 +149,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 {
 	unsigned long encl_size = secs->size + PAGE_SIZE;
 	struct sgx_epc_page *secs_epc;
+	struct sgx_va_page *va_page;
 	unsigned long ssaframesize;
 	struct sgx_pageinfo pginfo;
 	struct sgx_secinfo secinfo;
@@ -121,20 +159,29 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	if (atomic_read(&encl->flags) & SGX_ENCL_CREATED)
 		return -EINVAL;
 
+	va_page = sgx_encl_grow(encl);
+	if (IS_ERR(va_page))
+		return PTR_ERR(va_page);
+	else if (va_page)
+		list_add(&va_page->list, &encl->va_pages);
+
 	ssaframesize = sgx_calc_ssaframesize(secs->miscselect, secs->xfrm);
 	if (sgx_validate_secs(secs, ssaframesize)) {
 		pr_debug("sgx: invalid SECS\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_out_shrink;
 	}
 
 	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
 				   VM_NORESERVE);
-	if (IS_ERR(backing))
-		return PTR_ERR(backing);
+	if (IS_ERR(backing)) {
+		ret = PTR_ERR(backing);
+		goto err_out_shrink;
+	}
 
 	encl->backing = backing;
 
-	secs_epc = sgx_alloc_page();
+	secs_epc = sgx_alloc_page(&encl->secs, true);
 	if (IS_ERR(secs_epc)) {
 		ret = PTR_ERR(secs_epc);
 		goto err_out_backing;
@@ -181,6 +228,9 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	fput(encl->backing);
 	encl->backing = NULL;
 
+err_out_shrink:
+	sgx_encl_shrink(encl, va_page);
+
 	return ret;
 }
 
@@ -313,21 +363,22 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 {
 	struct sgx_encl_page *encl_page;
 	struct sgx_epc_page *epc_page;
+	struct sgx_va_page *va_page;
 	int ret;
 
 	encl_page = sgx_encl_page_alloc(encl, addp->addr, secinfo->flags);
 	if (IS_ERR(encl_page))
 		return PTR_ERR(encl_page);
 
-	epc_page = sgx_alloc_page();
+	epc_page = sgx_alloc_page(encl_page, true);
 	if (IS_ERR(epc_page)) {
 		kfree(encl_page);
 		return PTR_ERR(epc_page);
 	}
 
-	if (atomic_read(&encl->flags) &
-	    (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
-		ret = -EFAULT;
+	va_page = sgx_encl_grow(encl);
+	if (IS_ERR(va_page)) {
+		ret = PTR_ERR(va_page);
 		goto err_out_free;
 	}
 
@@ -335,6 +386,13 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 
 	mutex_lock(&encl->lock);
 
+	/*
+	 * Adding to encl->va_pages must be done under encl->lock.  Ditto for
+	 * deleting (via sgx_encl_shrink()) in the error path.
+	 */
+	if (va_page)
+		list_add(&va_page->list, &encl->va_pages);
+
 	/*
 	 * Insert prior to EADD in case of OOM.  EADD modifies MRENCLAVE, i.e.
 	 * can't be gracefully unwound, while failure on EADD/EXTEND is limited
@@ -344,7 +402,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 				encl_page);
 	if (ret) {
 		up_read(&current->mm->mmap_sem);
-		goto err_out_unlock;
+		goto err_out_shrink;
 	}
 
 	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
@@ -362,15 +420,17 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 	encl_page->epc_page = epc_page;
 	encl->secs_child_cnt++;
 
-	mutex_unlock(&encl->lock);
+	sgx_mark_page_reclaimable(encl_page->epc_page);
 
+	mutex_unlock(&encl->lock);
 	return 0;
 
 err_out:
 	radix_tree_delete(&encl_page->encl->page_tree,
 			  PFN_DOWN(encl_page->desc));
 
-err_out_unlock:
+err_out_shrink:
+	sgx_encl_shrink(encl, va_page);
 	mutex_unlock(&encl->lock);
 
 err_out_free:
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index dfb813d2bbcc..e4f751651a65 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -19,7 +19,7 @@ int sgx_nr_epc_sections;
 /* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
 static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
 
-static struct sgx_epc_page *sgx_section_get_page(
+static struct sgx_epc_page *sgx_section_try_take_page(
 	struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
@@ -27,23 +27,14 @@ static struct sgx_epc_page *sgx_section_get_page(
 	if (!section->free_cnt)
 		return NULL;
 
-	page = list_first_entry(&section->page_list,
-				struct sgx_epc_page, list);
+	page = list_first_entry(&section->page_list, struct sgx_epc_page,
+				list);
 	list_del_init(&page->list);
 	section->free_cnt--;
 	return page;
 }
 
-/**
- * sgx_alloc_page - Allocate an EPC page
- *
- * Try to grab a page from the free EPC page list.
- *
- * Return:
- *   a pointer to a &struct sgx_epc_page instance,
- *   -errno on error
- */
-struct sgx_epc_page *sgx_alloc_page(void)
+static struct sgx_epc_page *sgx_try_alloc_page(void *owner)
 {
 	struct sgx_epc_section *section;
 	struct sgx_epc_page *page;
@@ -52,24 +43,73 @@ struct sgx_epc_page *sgx_alloc_page(void)
 	for (i = 0; i < sgx_nr_epc_sections; i++) {
 		section = &sgx_epc_sections[i];
 		spin_lock(&section->lock);
-		page = sgx_section_get_page(section);
+		page = sgx_section_try_take_page(section);
 		spin_unlock(&section->lock);
 
-		if (page)
+		if (page) {
+			page->owner = owner;
 			return page;
+		}
 	}
 
-	return ERR_PTR(-ENOMEM);
+	return NULL;
+}
+
+/**
+ * sgx_alloc_page - Allocate an EPC page
+ * @owner:	the owner of the EPC page
+ * @reclaim:	reclaim pages if necessary
+ *
+ * Try to grab a page from the free EPC page list. If there is a free page
+ * available, it is returned to the caller. The @reclaim parameter hints
+ * the EPC memory manager to swap pages when required.
+ *
+ * Return:
+ *   a pointer to a &struct sgx_epc_page instance,
+ *   -errno on error
+ */
+struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
+{
+	struct sgx_epc_page *entry;
+
+	for ( ; ; ) {
+		entry = sgx_try_alloc_page(owner);
+		if (entry)
+			break;
+
+		if (list_empty(&sgx_active_page_list))
+			return ERR_PTR(-ENOMEM);
+
+		if (!reclaim) {
+			entry = ERR_PTR(-EBUSY);
+			break;
+		}
+
+		if (signal_pending(current)) {
+			entry = ERR_PTR(-ERESTARTSYS);
+			break;
+		}
+
+		sgx_reclaim_pages();
+		schedule();
+	}
+
+	if (sgx_calc_free_cnt() < SGX_NR_LOW_PAGES)
+		wake_up(&ksgxswapd_waitq);
+
+	return entry;
 }
 
 /**
  * __sgx_free_page - Free an EPC page
  * @page:	pointer a previously allocated EPC page
  *
- * EREMOVE an EPC page and insert it back to the list of free pages.
+ * EREMOVE an EPC page and insert it back to the list of free pages.  If the
+ * page is reclaimable, delete it from the active page list.
  *
  * Return:
  *   0 on success
+ *   -EBUSY if the page cannot be removed from the active list
  *   SGX error code if EREMOVE fails
  */
 int __sgx_free_page(struct sgx_epc_page *page)
@@ -77,6 +117,23 @@ int __sgx_free_page(struct sgx_epc_page *page)
 	struct sgx_epc_section *section = sgx_epc_section(page);
 	int ret;
 
+	/*
+	 * Remove the page from the active list if necessary.  If the page
+	 * is actively being reclaimed, i.e. RECLAIMABLE is set but the
+	 * page isn't on the active list, return -EBUSY as we can't free
+	 * the page at this time since it is "owned" by the reclaimer.
+	 */
+	spin_lock(&sgx_active_page_list_lock);
+	if (page->desc & SGX_EPC_PAGE_RECLAIMABLE) {
+		if (list_empty(&page->list)) {
+			spin_unlock(&sgx_active_page_list_lock);
+			return -EBUSY;
+		}
+		list_del(&page->list);
+		page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+	}
+	spin_unlock(&sgx_active_page_list_lock);
+
 	ret = __eremove(sgx_epc_addr(page));
 	if (ret)
 		return ret;
@@ -102,6 +159,7 @@ void sgx_free_page(struct sgx_epc_page *page)
 	int ret;
 
 	ret = __sgx_free_page(page);
+	WARN(ret < 0, "sgx: cannot free page, reclaim in-progress");
 	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 62a9233330f9..bd8ac11a4278 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -9,10 +9,13 @@
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
-#include "encls.h"
+#include "driver.h"
 #include "sgx.h"
 
 struct task_struct *ksgxswapd_tsk;
+DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
+LIST_HEAD(sgx_active_page_list);
+DEFINE_SPINLOCK(sgx_active_page_list_lock);
 
 static void sgx_sanitize_section(struct sgx_epc_section *section)
 {
@@ -58,6 +61,12 @@ static void sgx_sanitize_section(struct sgx_epc_section *section)
 	}
 }
 
+static inline bool sgx_should_reclaim(void)
+{
+	return sgx_calc_free_cnt() < SGX_NR_HIGH_PAGES &&
+	       !list_empty(&sgx_active_page_list);
+}
+
 static int ksgxswapd(void *p)
 {
 	int i;
@@ -67,6 +76,19 @@ static int ksgxswapd(void *p)
 	for (i = 0; i < sgx_nr_epc_sections; i++)
 		sgx_sanitize_section(&sgx_epc_sections[i]);
 
+	while (!kthread_should_stop()) {
+		if (try_to_freeze())
+			continue;
+
+		wait_event_freezable(ksgxswapd_waitq, kthread_should_stop() ||
+						      sgx_should_reclaim());
+
+		if (sgx_should_reclaim())
+			sgx_reclaim_pages();
+
+		cond_resched();
+	}
+
 	return 0;
 }
 
@@ -82,3 +104,372 @@ int sgx_page_reclaimer_init(void)
 
 	return 0;
 }
+
+/**
+ * sgx_mark_page_reclaimable() - Mark a page as reclaimable
+ * @page:	EPC page
+ *
+ * Mark a page as reclaimable and add it to the active page list. Pages
+ * are automatically removed from the active list when freed.
+ */
+void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
+{
+	spin_lock(&sgx_active_page_list_lock);
+	page->desc |= SGX_EPC_PAGE_RECLAIMABLE;
+	list_add_tail(&page->list, &sgx_active_page_list);
+	spin_unlock(&sgx_active_page_list_lock);
+}
+
+bool sgx_reclaimer_get(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl *encl = encl_page->encl;
+
+	return kref_get_unless_zero(&encl->refcount) != 0;
+}
+
+void sgx_reclaimer_put(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl *encl = encl_page->encl;
+
+	kref_put(&encl->refcount, sgx_encl_release);
+}
+
+static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *page = epc_page->owner;
+	struct sgx_encl *encl = page->encl;
+	struct sgx_encl_mm *encl_mm;
+	bool ret = true;
+	int idx;
+
+	idx = srcu_read_lock(&encl->srcu);
+
+	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
+		if (!mmget_not_zero(encl_mm->mm))
+			continue;
+
+		down_read(&encl_mm->mm->mmap_sem);
+		ret = !sgx_encl_test_and_clear_young(encl_mm->mm, page);
+		up_read(&encl_mm->mm->mmap_sem);
+
+		mmput_async(encl_mm->mm);
+
+		if (!ret || (atomic_read(&encl->flags) & SGX_ENCL_DEAD))
+			break;
+	}
+
+	srcu_read_unlock(&encl->srcu, idx);
+
+	/*
+	 * Do not reclaim this page if it has been recently accessed by any
+	 * mm_struct *and* if the enclave is still alive.  No need to take
+	 * the enclave's lock, worst case scenario reclaiming pages from a
+	 * dead enclave is delayed slightly.  A live enclave with a recently
+	 * accessed page is more common and avoiding lock contention in that
+	 * case is a boon to performance.
+	 */
+	if (!ret && !(atomic_read(&encl->flags) & SGX_ENCL_DEAD))
+		return false;
+
+	mutex_lock(&encl->lock);
+	page->desc |= SGX_ENCL_PAGE_RECLAIMED;
+	mutex_unlock(&encl->lock);
+
+	return true;
+}
+
+static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *page = epc_page->owner;
+	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
+	struct sgx_encl *encl = page->encl;
+	struct sgx_encl_mm *encl_mm;
+	struct vm_area_struct *vma;
+	int idx, ret;
+
+	idx = srcu_read_lock(&encl->srcu);
+
+	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
+		if (!mmget_not_zero(encl_mm->mm))
+			continue;
+
+		down_read(&encl_mm->mm->mmap_sem);
+
+		ret = sgx_encl_find(encl_mm->mm, addr, &vma);
+		if (!ret && encl == vma->vm_private_data)
+			zap_vma_ptes(vma, addr, PAGE_SIZE);
+
+		up_read(&encl_mm->mm->mmap_sem);
+
+		mmput_async(encl_mm->mm);
+	}
+
+	srcu_read_unlock(&encl->srcu, idx);
+
+	mutex_lock(&encl->lock);
+
+	if (!(atomic_read(&encl->flags) & SGX_ENCL_DEAD)) {
+		ret = __eblock(sgx_epc_addr(epc_page));
+		if (encls_failed(ret))
+			ENCLS_WARN(ret, "EBLOCK");
+	}
+
+	mutex_unlock(&encl->lock);
+}
+
+static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
+			  struct sgx_va_page *va_page, unsigned int va_offset,
+			  unsigned int pt)
+{
+	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_pageinfo pginfo;
+	unsigned long pcmd_offset;
+	struct page *backing;
+	pgoff_t page_index;
+	pgoff_t pcmd_index;
+	struct page *pcmd;
+	int ret;
+
+	if (pt != SGX_SECINFO_SECS && pt != SGX_SECINFO_TCS &&
+	    pt != SGX_SECINFO_REG)
+		return -EINVAL;
+
+	if (pt == SGX_SECINFO_SECS)
+		page_index = PFN_DOWN(encl->size);
+	else
+		page_index = SGX_ENCL_PAGE_INDEX(encl_page);
+
+	pcmd_index = sgx_pcmd_index(encl, page_index);
+	pcmd_offset = sgx_pcmd_offset(page_index);
+
+	backing = sgx_encl_get_backing_page(encl, page_index);
+	if (IS_ERR(backing)) {
+		ret = PTR_ERR(backing);
+		goto err_backing;
+	}
+
+	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
+	if (IS_ERR(pcmd)) {
+		ret = PTR_ERR(pcmd);
+		goto err_pcmd;
+	}
+
+	pginfo.addr = 0;
+	pginfo.contents = (unsigned long)kmap_atomic(backing);
+	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
+	pginfo.secs = 0;
+	ret = __ewb(&pginfo, sgx_epc_addr(epc_page),
+		    sgx_epc_addr(va_page->epc_page) + va_offset);
+	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
+	kunmap_atomic((void *)(unsigned long)pginfo.contents);
+
+	set_page_dirty(pcmd);
+	put_page(pcmd);
+	set_page_dirty(backing);
+
+err_pcmd:
+	put_page(backing);
+
+err_backing:
+	return ret;
+}
+
+static void sgx_ipi_cb(void *info)
+{
+}
+
+static const cpumask_t *sgx_encl_ewb_cpumask(struct sgx_encl *encl)
+{
+	cpumask_t *cpumask = &encl->cpumask;
+	struct sgx_encl_mm *encl_mm;
+	int idx;
+
+	cpumask_clear(cpumask);
+
+	idx = srcu_read_lock(&encl->srcu);
+
+	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
+		if (!mmget_not_zero(encl_mm->mm))
+			continue;
+
+		cpumask_or(cpumask, cpumask, mm_cpumask(encl_mm->mm));
+
+		mmput_async(encl_mm->mm);
+	}
+
+	srcu_read_unlock(&encl->srcu, idx);
+
+	return cpumask;
+}
+
+static void sgx_encl_ewb(struct sgx_epc_page *epc_page, unsigned int pt)
+{
+	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl *encl = encl_page->encl;
+	struct sgx_va_page *va_page;
+	unsigned int va_offset;
+	int ret;
+
+	encl_page->desc &= ~SGX_ENCL_PAGE_RECLAIMED;
+
+	if (!(atomic_read(&encl->flags) & SGX_ENCL_DEAD)) {
+		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
+					   list);
+		va_offset = sgx_alloc_va_slot(va_page);
+		if (sgx_va_page_full(va_page))
+			list_move_tail(&va_page->list, &encl->va_pages);
+
+		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset, pt);
+		if (ret == SGX_NOT_TRACKED) {
+			ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
+			if (ret) {
+				if (encls_failed(ret) ||
+				    encls_returned_code(ret))
+					ENCLS_WARN(ret, "ETRACK");
+			}
+
+			ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
+					     pt);
+			if (ret == SGX_NOT_TRACKED) {
+				/*
+				 * Slow path, send IPIs to kick cpus out of the
+				 * enclave.  Note, it's imperative that the cpu
+				 * mask is generated *after* ETRACK, else we'll
+				 * miss cpus that entered the enclave between
+				 * generating the mask and incrementing epoch.
+				 */
+				on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
+						 sgx_ipi_cb, NULL, 1);
+				ret = __sgx_encl_ewb(encl, epc_page, va_page,
+						     va_offset, pt);
+			}
+		}
+
+		if (ret)
+			if (encls_failed(ret) || encls_returned_code(ret))
+				ENCLS_WARN(ret, "EWB");
+
+		encl_page->desc |= va_offset;
+		encl_page->va_page = va_page;
+	} else if (pt != SGX_SECINFO_SECS) {
+		ret = __eremove(sgx_epc_addr(epc_page));
+		WARN(ret, "EREMOVE returned %d\n", ret);
+	}
+
+	/* The reclaimer is not aware of SECS pages. */
+	if (pt == SGX_SECINFO_SECS)
+		sgx_free_page(epc_page);
+
+	encl_page->epc_page = NULL;
+}
+
+static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl *encl = encl_page->encl;
+	unsigned int pt;
+
+	if (encl_page->desc & SGX_ENCL_PAGE_TCS)
+		pt = SGX_SECINFO_TCS;
+	else
+		pt = SGX_SECINFO_REG;
+
+	mutex_lock(&encl->lock);
+
+	sgx_encl_ewb(epc_page, pt);
+
+	encl->secs_child_cnt--;
+
+	if (!encl->secs_child_cnt &&
+	    (atomic_read(&encl->flags) &
+	     (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED)))
+		sgx_encl_ewb(encl->secs.epc_page, SGX_SECINFO_SECS);
+
+	mutex_unlock(&encl->lock);
+}
+
+/**
+ * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
+ * Takes a fixed chunk of pages from the global list of consumed EPC pages and
+ * tries to swap them. Only the pages that are either being freed by the
+ * consumer or actively used are skipped.
+ */
+void sgx_reclaim_pages(void)
+{
+	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN + 1];
+	struct sgx_epc_page *epc_page;
+	struct sgx_epc_section *section;
+	int i, j;
+
+	spin_lock(&sgx_active_page_list_lock);
+	for (i = 0, j = 0; i < SGX_NR_TO_SCAN; i++) {
+		if (list_empty(&sgx_active_page_list))
+			break;
+
+		epc_page = list_first_entry(&sgx_active_page_list,
+					    struct sgx_epc_page, list);
+		list_del_init(&epc_page->list);
+
+		if (sgx_reclaimer_get(epc_page))
+			chunk[j++] = epc_page;
+		else
+			/* The owner is freeing the page. No need to add the
+			 * page back to the list of reclaimable pages.
+			 */
+			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+	}
+	spin_unlock(&sgx_active_page_list_lock);
+
+	for (i = 0; i < j; i++) {
+		epc_page = chunk[i];
+		if (sgx_reclaimer_evict(epc_page))
+			continue;
+
+		sgx_reclaimer_put(epc_page);
+
+		spin_lock(&sgx_active_page_list_lock);
+		list_add_tail(&epc_page->list, &sgx_active_page_list);
+		spin_unlock(&sgx_active_page_list_lock);
+
+		chunk[i] = NULL;
+	}
+
+	for (i = 0; i < j; i++) {
+		epc_page = chunk[i];
+		if (epc_page)
+			sgx_reclaimer_block(epc_page);
+	}
+
+	for (i = 0; i < j; i++) {
+		epc_page = chunk[i];
+		if (epc_page) {
+			sgx_reclaimer_write(epc_page);
+			sgx_reclaimer_put(epc_page);
+			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+
+			section = sgx_epc_section(epc_page);
+
+			spin_lock(&section->lock);
+			list_add_tail(&epc_page->list,
+				      &section->page_list);
+			section->free_cnt++;
+			spin_unlock(&section->lock);
+		}
+	}
+}
+
+unsigned long sgx_calc_free_cnt(void)
+{
+	struct sgx_epc_section *section;
+	unsigned long free_cnt = 0;
+	int i;
+
+	for (i = 0; i < sgx_nr_epc_sections; i++) {
+		section = &sgx_epc_sections[i];
+		free_cnt += section->free_cnt;
+	}
+
+	return free_cnt;
+}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index fa37da4c7b63..f0ff7bd3d18e 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -12,6 +12,7 @@
 
 struct sgx_epc_page {
 	unsigned long desc;
+	struct sgx_encl_page *owner;
 	struct list_head list;
 };
 
@@ -42,9 +43,14 @@ extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
  *				physical memory. The existing and near-future
  *				hardware defines at most eight sections, hence
  *				three bits to hold a section.
+ * %SGX_EPC_PAGE_RECLAIMABLE:	The page has been been marked as reclaimable.
+ *				Pages need to be colored this way because a page
+ *				can be out of the active page list in the
+ *				process of being swapped out.
  */
 enum sgx_epc_page_desc {
 	SGX_EPC_SECTION_MASK			= GENMASK_ULL(3, 0),
+	SGX_EPC_PAGE_RECLAIMABLE		= BIT(4),
 	/* bits 12-63 are reserved for the physical page address of the page */
 };
 
@@ -60,12 +66,22 @@ static inline void *sgx_epc_addr(struct sgx_epc_page *page)
 	return section->va + (page->desc & PAGE_MASK) - section->pa;
 }
 
+#define SGX_NR_TO_SCAN		16
+#define SGX_NR_LOW_PAGES	32
+#define SGX_NR_HIGH_PAGES	64
+
 extern int sgx_nr_epc_sections;
 extern struct task_struct *ksgxswapd_tsk;
+extern struct wait_queue_head(ksgxswapd_waitq);
+extern struct list_head sgx_active_page_list;
+extern spinlock_t sgx_active_page_list_lock;
 
 int sgx_page_reclaimer_init(void);
+void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
+unsigned long sgx_calc_free_cnt(void);
+void sgx_reclaim_pages(void);
 
-struct sgx_epc_page *sgx_alloc_page(void);
+struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
 int __sgx_free_page(struct sgx_epc_page *page);
 void sgx_free_page(struct sgx_epc_page *page);
 int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
-- 
2.20.1

