From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Darren Hart <dvhart@infradead.org>, "Andy
 Shevchenko" <andy@infradead.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v14 16/19] platform/x86: Add swapping functionality to the Intel SGX driver
Date: Tue, 25 Sep 2018 16:06:53 +0300
Message-ID: <20180925130845.9962-17-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

Add functions to swap EPC pages to the driver:

* sgx_encl_page_get() pins and sgx_encl_page_put() unpins an enclave
  page.
* sgx_encl_page_reclaim() tries to mark page as being reclaimed. The
  page is considered reclaimable if it hasn't been accessed recently and
  it isn't reserved by the driver for other use.
* sgx_encl_page_block() and sgx_encl_page_track() implement EBLOCK and
  ETRACK operations.
* sgx_encl_page_write() writes the page to the regular memory with EWB.

This commit also contains the #PF handler for loading the swapped pages
back.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
---
 drivers/platform/x86/intel_sgx/Makefile       |   2 +
 drivers/platform/x86/intel_sgx/sgx.h          |  32 ++++
 drivers/platform/x86/intel_sgx/sgx_encl.c     | 129 ++++++++++++-
 .../platform/x86/intel_sgx/sgx_encl_page.c    | 177 ++++++++++++++++++
 drivers/platform/x86/intel_sgx/sgx_fault.c    | 107 +++++++++++
 drivers/platform/x86/intel_sgx/sgx_util.c     |  71 +++++++
 drivers/platform/x86/intel_sgx/sgx_vma.c      |  15 ++
 7 files changed, 532 insertions(+), 1 deletion(-)
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_encl_page.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_fault.c

diff --git a/drivers/platform/x86/intel_sgx/Makefile b/drivers/platform/x86/intel_sgx/Makefile
index 117e97effeff..5023c5ebd57d 100644
--- a/drivers/platform/x86/intel_sgx/Makefile
+++ b/drivers/platform/x86/intel_sgx/Makefile
@@ -6,6 +6,8 @@ obj-$(CONFIG_INTEL_SGX) += intel_sgx.o
 
 intel_sgx-$(CONFIG_INTEL_SGX) += \
 	sgx_encl.o \
+	sgx_encl_page.o \
+	sgx_fault.o \
 	sgx_ioctl.o \
 	sgx_main.o \
 	sgx_util.o \
diff --git a/drivers/platform/x86/intel_sgx/sgx.h b/drivers/platform/x86/intel_sgx/sgx.h
index 67bd8ea1d53d..f707701e422d 100644
--- a/drivers/platform/x86/intel_sgx/sgx.h
+++ b/drivers/platform/x86/intel_sgx/sgx.h
@@ -36,16 +36,32 @@
 #define SGX_EINIT_SLEEP_COUNT	50
 #define SGX_EINIT_SLEEP_TIME	20
 
+#define SGX_VA_SLOT_COUNT 512
+
+struct sgx_va_page {
+	struct sgx_epc_page *epc_page;
+	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
+	struct list_head list;
+};
+
 /**
  * enum sgx_encl_page_desc - defines bits for an enclave page's descriptor
  * %SGX_ENCL_PAGE_TCS:			The page is a TCS page.
  * %SGX_ENCL_PAGE_LOADED:		The page is not swapped.
+ * %SGX_ENCL_PAGE_RESERVED:		The page cannot be reclaimed.
+ * %SGX_ENCL_PAGE_RECLAIMED:		The page is in the process of being
+ *					reclaimed.
+ * %SGX_ENCL_PAGE_VA_OFFSET_MASK:	Holds the offset in the Version Array
+ *					(VA) page for a swapped page.
  * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
  */
 enum sgx_encl_page_desc {
 	SGX_ENCL_PAGE_TCS		= BIT(0),
 	SGX_ENCL_PAGE_LOADED		= BIT(1),
 	/* Bits 11:3 are available when the page is not swapped. */
+	SGX_ENCL_PAGE_RESERVED		= BIT(3),
+	SGX_ENCL_PAGE_RECLAIMED		= BIT(4),
+	SGX_ENCL_PAGE_VA_OFFSET_MASK	= GENMASK_ULL(11, 3),
 	SGX_ENCL_PAGE_ADDR_MASK		= PAGE_MASK,
 };
 
@@ -79,10 +95,12 @@ struct sgx_encl {
 	struct mutex lock;
 	struct mm_struct *mm;
 	struct file *backing;
+	struct file *pcmd;
 	struct kref refcount;
 	unsigned long base;
 	unsigned long size;
 	unsigned long ssaframesize;
+	struct list_head va_pages;
 	struct radix_tree_root page_tree;
 	struct list_head add_page_reqs;
 	struct work_struct add_page_work;
@@ -102,6 +120,16 @@ static inline pgoff_t sgx_encl_page_backing_index(struct sgx_encl_page *page,
 	return PFN_DOWN(page->desc - encl->base);
 }
 
+static inline int sgx_encl_page_pcmd_offset(struct sgx_encl_page *page,
+					    struct sgx_encl *encl)
+{
+	int index;
+
+	index = sgx_encl_page_backing_index(page, encl);
+	return (index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
+	       sizeof(struct sgx_pcmd);
+}
+
 extern struct workqueue_struct *sgx_add_page_wq;
 extern u64 sgx_encl_size_max_32;
 extern u64 sgx_encl_size_max_64;
@@ -174,6 +202,10 @@ int sgx_test_and_clear_young(struct sgx_encl_page *page);
 void sgx_flush_cpus(struct sgx_encl *encl);
 void sgx_set_page_loaded(struct sgx_encl_page *encl_page,
 			 struct sgx_epc_page *epc_page);
+struct sgx_epc_page *sgx_alloc_va_page(void);
+unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
+void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
+bool sgx_va_page_full(struct sgx_va_page *va_page);
 struct page *sgx_get_backing(struct file *file, pgoff_t index);
 void sgx_put_backing(struct page *backing_page, bool write);
 
diff --git a/drivers/platform/x86/intel_sgx/sgx_encl.c b/drivers/platform/x86/intel_sgx/sgx_encl.c
index b9ecdc20d67e..f3306bd58978 100644
--- a/drivers/platform/x86/intel_sgx/sgx_encl.c
+++ b/drivers/platform/x86/intel_sgx/sgx_encl.c
@@ -92,7 +92,8 @@ void sgx_invalidate(struct sgx_encl *encl, bool flush_cpus)
 		 * need to check that and let the swapper thread to free the
 		 * page if this is the case.
 		 */
-		if (entry->desc & SGX_ENCL_PAGE_LOADED) {
+		if (entry->desc & SGX_ENCL_PAGE_LOADED &&
+		    !(entry->desc & SGX_ENCL_PAGE_RECLAIMED)) {
 			if (!__sgx_free_page(entry->epc_page))
 				entry->desc &= ~SGX_ENCL_PAGE_LOADED;
 		}
@@ -301,6 +302,41 @@ static const struct mmu_notifier_ops sgx_mmu_notifier_ops = {
 	.release	= sgx_mmu_notifier_release,
 };
 
+static int sgx_encl_grow(struct sgx_encl *encl)
+{
+	struct sgx_va_page *va_page;
+	int ret;
+
+	BUILD_BUG_ON(SGX_VA_SLOT_COUNT !=
+		(SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
+
+	mutex_lock(&encl->lock);
+	if (!(encl->page_cnt % SGX_VA_SLOT_COUNT)) {
+		mutex_unlock(&encl->lock);
+
+		va_page = kzalloc(sizeof(*va_page), GFP_KERNEL);
+		if (!va_page)
+			return -ENOMEM;
+		va_page->epc_page = sgx_alloc_va_page();
+		if (IS_ERR(va_page->epc_page)) {
+			ret = PTR_ERR(va_page->epc_page);
+			kfree(va_page);
+			return ret;
+		}
+
+		mutex_lock(&encl->lock);
+		if (encl->page_cnt % SGX_VA_SLOT_COUNT) {
+			sgx_free_page(va_page->epc_page);
+			kfree(va_page);
+		} else {
+			list_add(&va_page->list, &encl->va_pages);
+		}
+	}
+	encl->page_cnt++;
+	mutex_unlock(&encl->lock);
+	return 0;
+}
+
 /**
  * sgx_encl_alloc - allocate memory for an enclave and set attributes
  *
@@ -319,6 +355,7 @@ struct sgx_encl *sgx_encl_alloc(struct sgx_secs *secs)
 	unsigned long ssaframesize;
 	struct sgx_encl *encl;
 	struct file *backing;
+	struct file *pcmd;
 
 	ssaframesize = sgx_calc_ssaframesize(secs->miscselect, secs->xfrm);
 	if (sgx_validate_secs(secs, ssaframesize))
@@ -329,9 +366,17 @@ struct sgx_encl *sgx_encl_alloc(struct sgx_secs *secs)
 	if (IS_ERR(backing))
 		return ERR_CAST(backing);
 
+	pcmd = shmem_file_setup("[dev/sgx]", (secs->size + PAGE_SIZE) >> 5,
+				VM_NORESERVE);
+	if (IS_ERR(pcmd)) {
+		fput(backing);
+		return ERR_CAST(pcmd);
+	}
+
 	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
 	if (!encl) {
 		fput(backing);
+		fput(pcmd);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -340,6 +385,7 @@ struct sgx_encl *sgx_encl_alloc(struct sgx_secs *secs)
 
 	kref_init(&encl->refcount);
 	INIT_LIST_HEAD(&encl->add_page_reqs);
+	INIT_LIST_HEAD(&encl->va_pages);
 	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
 	mutex_init(&encl->lock);
 	INIT_WORK(&encl->add_page_work, sgx_add_page_worker);
@@ -349,6 +395,7 @@ struct sgx_encl *sgx_encl_alloc(struct sgx_secs *secs)
 	encl->size = secs->size;
 	encl->ssaframesize = secs->ssa_frame_size;
 	encl->backing = backing;
+	encl->pcmd = pcmd;
 
 	return encl;
 }
@@ -400,6 +447,10 @@ int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->secs.encl = encl;
 	encl->tgid = get_pid(task_tgid(current));
 
+	ret = sgx_encl_grow(encl);
+	if (ret)
+		return ret;
+
 	pginfo.addr = 0;
 	pginfo.contents = (unsigned long)secs;
 	pginfo.metadata = (unsigned long)&secinfo;
@@ -630,6 +681,9 @@ int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr, void *data,
 		if (ret)
 			return ret;
 	}
+	ret = sgx_encl_grow(encl);
+	if (ret)
+		return ret;
 	mutex_lock(&encl->lock);
 	if (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
 		mutex_unlock(&encl->lock);
@@ -787,6 +841,67 @@ void sgx_encl_track(struct sgx_encl *encl)
 	SGX_INVD(ret, encl, "ETRACK returned %d\n", ret);
 }
 
+/**
+ * sgx_encl_load_page - load an enclave page
+ * @encl_page:	an enclave page
+ * @epc_page:	an EPC page
+ *
+ * Loads an enclave page from the regular memory to the EPC. The pages, which
+ * are not children of a SECS (eg SECS itself and VA pages) should set their
+ * address to zero.
+ *
+ * Return:
+ *   0 on success,
+ *   -errno or SGX error code on failure
+ */
+int sgx_encl_load_page(struct sgx_encl_page *encl_page,
+		       struct sgx_epc_page *epc_page)
+{
+	unsigned long addr = SGX_ENCL_PAGE_ADDR(encl_page);
+	struct sgx_encl *encl = encl_page->encl;
+	struct sgx_pageinfo pginfo;
+	unsigned long pcmd_offset;
+	unsigned long va_offset;
+	pgoff_t backing_index;
+	struct page *backing;
+	struct page *pcmd;
+	int ret;
+
+	backing_index = sgx_encl_page_backing_index(encl_page, encl);
+	pcmd_offset = sgx_encl_page_pcmd_offset(encl_page, encl);
+	va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
+
+	backing = sgx_get_backing(encl->backing, backing_index);
+	if (IS_ERR(backing))
+		return PTR_ERR(backing);
+
+	pcmd = sgx_get_backing(encl->pcmd, backing_index >> 5);
+	if (IS_ERR(pcmd)) {
+		sgx_put_backing(backing, false);
+		return PTR_ERR(pcmd);
+	}
+
+	pginfo.addr = addr;
+	pginfo.contents = (unsigned long)kmap_atomic(backing);
+	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
+	pginfo.secs = addr ? (unsigned long)sgx_epc_addr(encl->secs.epc_page) :
+		      0;
+
+	ret = __eldu(&pginfo, sgx_epc_addr(epc_page),
+		     sgx_epc_addr(encl_page->va_page->epc_page) + va_offset);
+	if (ret) {
+		sgx_err(encl, "ELDU returned %d\n", ret);
+		ret = encls_to_err(ret);
+	}
+
+	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
+	kunmap_atomic((void *)(unsigned long)pginfo.contents);
+
+	sgx_put_backing(pcmd, false);
+	sgx_put_backing(backing, false);
+	return ret;
+}
+
 /**
  * sgx_encl_release - destroy an enclave instance
  * @kref:	address of a kref inside &sgx_encl
@@ -799,6 +914,7 @@ void sgx_encl_release(struct kref *ref)
 	struct sgx_encl *encl = container_of(ref, struct sgx_encl, refcount);
 	struct sgx_encl_page *entry;
 	struct radix_tree_iter iter;
+	struct sgx_va_page *va_page;
 	void **slot;
 
 	if (encl->mmu_notifier.ops)
@@ -816,11 +932,22 @@ void sgx_encl_release(struct kref *ref)
 	if (encl->tgid)
 		put_pid(encl->tgid);
 
+	while (!list_empty(&encl->va_pages)) {
+		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
+					   list);
+		list_del(&va_page->list);
+		sgx_free_page(va_page->epc_page);
+		kfree(va_page);
+	}
+
 	if (encl->secs.desc & SGX_ENCL_PAGE_LOADED)
 		sgx_free_page(encl->secs.epc_page);
 
 	if (encl->backing)
 		fput(encl->backing);
 
+	if (encl->pcmd)
+		fput(encl->pcmd);
+
 	kfree(encl);
 }
diff --git a/drivers/platform/x86/intel_sgx/sgx_encl_page.c b/drivers/platform/x86/intel_sgx/sgx_encl_page.c
new file mode 100644
index 000000000000..7318a1ffeffd
--- /dev/null
+++ b/drivers/platform/x86/intel_sgx/sgx_encl_page.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include <linux/device.h>
+#include <linux/freezer.h>
+#include <linux/highmem.h>
+#include <linux/kthread.h>
+#include <linux/ratelimit.h>
+#include <linux/sched/signal.h>
+#include <linux/slab.h>
+#include "sgx.h"
+
+static inline struct sgx_encl_page *to_encl_page(struct sgx_epc_page *epc_page)
+{
+	return (struct sgx_encl_page *)epc_page->owner;
+}
+
+bool sgx_encl_page_get(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+
+	return kref_get_unless_zero(&encl->refcount) != 0;
+}
+
+void sgx_encl_page_put(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+
+	kref_put(&encl->refcount, sgx_encl_release);
+}
+
+bool sgx_encl_page_reclaim(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+	bool ret;
+
+	down_read(&encl->mm->mmap_sem);
+	mutex_lock(&encl->lock);
+
+	if (encl->flags & SGX_ENCL_DEAD)
+		ret = true;
+	else if (encl_page->desc & SGX_ENCL_PAGE_RESERVED)
+		ret = false;
+	else
+		ret = !sgx_test_and_clear_young(encl_page);
+	if (ret)
+		encl_page->desc |= SGX_ENCL_PAGE_RECLAIMED;
+
+	mutex_unlock(&encl->lock);
+	up_read(&encl->mm->mmap_sem);
+
+	return ret;
+}
+
+void sgx_encl_page_block(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+
+	down_read(&encl->mm->mmap_sem);
+	mutex_lock(&encl->lock);
+	sgx_encl_block(encl_page);
+	mutex_unlock(&encl->lock);
+	up_read(&encl->mm->mmap_sem);
+}
+
+static int sgx_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
+		   struct sgx_va_page *va_page, unsigned int va_offset)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	int pcmd_offset = sgx_encl_page_pcmd_offset(encl_page, encl);
+	struct sgx_pageinfo pginfo;
+	pgoff_t backing_index;
+	struct page *backing;
+	struct page *pcmd;
+	int ret;
+
+	backing_index = sgx_encl_page_backing_index(encl_page, encl);
+
+	backing = sgx_get_backing(encl->backing, backing_index);
+	if (IS_ERR(backing)) {
+		ret = PTR_ERR(backing);
+		return ret;
+	}
+
+	pcmd = sgx_get_backing(encl->pcmd, backing_index >> 5);
+	if (IS_ERR(pcmd)) {
+		ret = PTR_ERR(pcmd);
+		sgx_put_backing(backing, true);
+		return ret;
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
+	sgx_put_backing(pcmd, true);
+	sgx_put_backing(backing, true);
+
+	return ret;
+}
+
+/**
+ * sgx_write_page - write a page to the regular memory
+ *
+ * Writes an EPC page to the shmem file associated with the enclave. Flushes
+ * CPUs and retries if there are hardware threads that can potentially have TLB
+ * entries to the page (indicated by SGX_NOT_TRACKED). Clears the reserved flag
+ * after the page is swapped.
+ *
+ * @epc_page:	an EPC page
+ */
+static void sgx_write_page(struct sgx_epc_page *epc_page, bool do_free)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+	struct sgx_va_page *va_page;
+	unsigned int va_offset;
+	int ret;
+
+	encl_page->desc &= ~(SGX_ENCL_PAGE_LOADED | SGX_ENCL_PAGE_RECLAIMED);
+
+	if (!(encl->flags & SGX_ENCL_DEAD)) {
+		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
+					   list);
+		va_offset = sgx_alloc_va_slot(va_page);
+		if (sgx_va_page_full(va_page))
+			list_move_tail(&va_page->list, &encl->va_pages);
+
+		ret = sgx_ewb(encl, epc_page, va_page, va_offset);
+		if (ret == SGX_NOT_TRACKED) {
+			sgx_encl_track(encl);
+			ret = sgx_ewb(encl, epc_page, va_page, va_offset);
+			if (ret == SGX_NOT_TRACKED) {
+				/* slow path, IPI needed */
+				sgx_flush_cpus(encl);
+				ret = sgx_ewb(encl, epc_page, va_page,
+					      va_offset);
+			}
+		}
+		SGX_INVD(ret, encl, "EWB returned %d\n", ret);
+
+		SGX_INVD(encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK, encl,
+			"Flags set in VA offset area: %lx", encl_page->desc);
+		encl_page->desc |= va_offset;
+		encl_page->va_page = va_page;
+	} else if (!do_free) {
+		ret = __eremove(sgx_epc_addr(epc_page));
+		WARN(ret, "EREMOVE returned %d\n", ret);
+	}
+
+	if (do_free)
+		sgx_free_page(epc_page);
+}
+
+void sgx_encl_page_write(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+
+	down_read(&encl->mm->mmap_sem);
+	mutex_lock(&encl->lock);
+	sgx_write_page(epc_page, false);
+	encl->secs_child_cnt--;
+	if (!encl->secs_child_cnt && (encl->flags & SGX_ENCL_INITIALIZED))
+		sgx_write_page(encl->secs.epc_page, true);
+	mutex_unlock(&encl->lock);
+	up_read(&encl->mm->mmap_sem);
+}
diff --git a/drivers/platform/x86/intel_sgx/sgx_fault.c b/drivers/platform/x86/intel_sgx/sgx_fault.c
new file mode 100644
index 000000000000..2f459329f29c
--- /dev/null
+++ b/drivers/platform/x86/intel_sgx/sgx_fault.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include <linux/highmem.h>
+#include <linux/sched/mm.h>
+#include "sgx.h"
+
+static struct sgx_epc_page *__sgx_load_faulted_page(
+	struct sgx_encl_page *encl_page)
+{
+	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
+	struct sgx_encl *encl = encl_page->encl;
+	struct sgx_epc_page *epc_page;
+	int ret;
+
+	epc_page = sgx_alloc_page(encl_page, false);
+	if (IS_ERR(epc_page))
+		return epc_page;
+	ret = sgx_encl_load_page(encl_page, epc_page);
+	if (ret) {
+		sgx_free_page(epc_page);
+		return ERR_PTR(ret);
+	}
+	sgx_free_va_slot(encl_page->va_page, va_offset);
+	list_move(&encl_page->va_page->list, &encl->va_pages);
+	encl_page->desc &= ~SGX_ENCL_PAGE_VA_OFFSET_MASK;
+	sgx_set_page_loaded(encl_page, epc_page);
+	return epc_page;
+}
+
+static struct sgx_encl_page *__sgx_fault_page(struct vm_area_struct *vma,
+					      unsigned long addr,
+					      bool do_reserve)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_epc_page *epc_page;
+	struct sgx_encl_page *entry;
+	int rc = 0;
+
+	if ((encl->flags & SGX_ENCL_DEAD) ||
+	    !(encl->flags & SGX_ENCL_INITIALIZED))
+		return ERR_PTR(-EFAULT);
+
+	entry = radix_tree_lookup(&encl->page_tree, addr >> PAGE_SHIFT);
+	if (!entry)
+		return ERR_PTR(-EFAULT);
+
+	/* Page is already resident in the EPC. */
+	if (entry->desc & SGX_ENCL_PAGE_LOADED) {
+		if (entry->desc & SGX_ENCL_PAGE_RESERVED) {
+			sgx_dbg(encl, "EPC page 0x%p is already reserved\n",
+				(void *)SGX_ENCL_PAGE_ADDR(entry));
+			return ERR_PTR(-EBUSY);
+		}
+		if (entry->desc & SGX_ENCL_PAGE_RECLAIMED) {
+			sgx_dbg(encl, "EPC page 0x%p is being reclaimed\n",
+				(void *)SGX_ENCL_PAGE_ADDR(entry));
+			return ERR_PTR(-EBUSY);
+		}
+		if (do_reserve)
+			entry->desc |= SGX_ENCL_PAGE_RESERVED;
+		return entry;
+	}
+
+	if (!(encl->secs.desc & SGX_ENCL_PAGE_LOADED)) {
+		epc_page = __sgx_load_faulted_page(&encl->secs);
+		if (IS_ERR(epc_page))
+			return ERR_CAST(epc_page);
+	}
+	epc_page = __sgx_load_faulted_page(entry);
+	if (IS_ERR(epc_page))
+		return ERR_CAST(epc_page);
+
+	encl->secs_child_cnt++;
+	sgx_test_and_clear_young(entry);
+	if (do_reserve)
+		entry->desc |= SGX_ENCL_PAGE_RESERVED;
+
+	rc = vm_insert_pfn(vma, addr, PFN_DOWN(entry->epc_page->desc));
+	SGX_INVD(rc, encl, "%s: vm_insert_pfn() returned %d\n", __func__, rc);
+	if (rc)
+		return ERR_PTR(rc);
+
+	return entry;
+}
+
+struct sgx_encl_page *sgx_fault_page(struct vm_area_struct *vma,
+				     unsigned long addr, bool do_reserve)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_encl_page *entry;
+
+	/* If process was forked, VMA is still there but vm_private_data is set
+	 * to NULL.
+	 */
+	if (!encl)
+		return ERR_PTR(-EFAULT);
+	do {
+		mutex_lock(&encl->lock);
+		entry = __sgx_fault_page(vma, addr, do_reserve);
+		mutex_unlock(&encl->lock);
+		if (!do_reserve)
+			break;
+	} while (PTR_ERR(entry) == -EBUSY);
+
+	return entry;
+}
diff --git a/drivers/platform/x86/intel_sgx/sgx_util.c b/drivers/platform/x86/intel_sgx/sgx_util.c
index cbea4c0e794b..ddd50449db46 100644
--- a/drivers/platform/x86/intel_sgx/sgx_util.c
+++ b/drivers/platform/x86/intel_sgx/sgx_util.c
@@ -67,6 +67,77 @@ void sgx_set_page_loaded(struct sgx_encl_page *encl_page,
 	encl_page->epc_page = epc_page;
 }
 
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
+		pr_crit("sgx: EPA failed\n");
+		sgx_free_page(epc_page);
+		return ERR_PTR(ret);
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
+}
+
 struct page *sgx_get_backing(struct file *file, pgoff_t index)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
diff --git a/drivers/platform/x86/intel_sgx/sgx_vma.c b/drivers/platform/x86/intel_sgx/sgx_vma.c
index 17e95a0c734c..cc0993b4fd40 100644
--- a/drivers/platform/x86/intel_sgx/sgx_vma.c
+++ b/drivers/platform/x86/intel_sgx/sgx_vma.c
@@ -37,7 +37,22 @@ static void sgx_vma_close(struct vm_area_struct *vma)
 	kref_put(&encl->refcount, sgx_encl_release);
 }
 
+static int sgx_vma_fault(struct vm_fault *vmf)
+{
+	unsigned long addr = (unsigned long)vmf->address;
+	struct vm_area_struct *vma = vmf->vma;
+	struct sgx_encl_page *entry;
+
+	entry = sgx_fault_page(vma, addr, 0);
+
+	if (!IS_ERR(entry) || PTR_ERR(entry) == -EBUSY)
+		return VM_FAULT_NOPAGE;
+	else
+		return VM_FAULT_SIGBUS;
+}
+
 const struct vm_operations_struct sgx_vm_ops = {
 	.close = sgx_vma_close,
 	.open = sgx_vma_open,
+	.fault = sgx_vma_fault,
 };
-- 
2.17.1
