From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>, Serge Ayoun
	<serge.ayoun@intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v13 09/13] x86/sgx: Enclave Page Cache (EPC) memory manager
Date: Mon, 27 Aug 2018 21:53:30 +0300
Message-ID: <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

Add a Enclave Page Cache (EPC) memory manager that can be used to
allocate and free EPC pages. The swapper thread ksgxswapd reclaims pages
on the event when the number of free EPC pages goes below
%SGX_NR_LOW_PAGES up until it reaches %SGX_NR_HIGH_PAGES.

Pages are reclaimed in LRU fashion from a global list. The consumers
take care of calling EBLOCK (block page from new accesses), ETRACK
(restart counting the entering hardware threads) and EWB (write page to
the regular memory) because executing these operations usually (if not
always) requires to do some subsystem-internal locking operations.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx.h      |  56 ++++--
 arch/x86/kernel/cpu/intel_sgx.c | 322 ++++++++++++++++++++++++++++++++
 2 files changed, 362 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index f8e419378f30..baf30d49b71f 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -13,8 +13,36 @@
 
 #define SGX_MAX_EPC_BANKS 8
 
+struct sgx_epc_page;
+
+/**
+ * struct sgx_epc_page_ops - operations to reclaim an EPC page
+ * @get:	Pin the page. Returns false when the consumer is freeing the
+ *		page itself.
+ * @put:	Unpin the page.
+ * @reclaim:	Try to reclaim the page. Returns false when the consumer is
+ *		actively using needs the page.
+ * @block:	Perform EBLOCK on the page.
+ * @write:	Perform ETRACK (when required) and EWB on the page.
+ *
+ * These operations must be implemented by the EPC consumer to assist to reclaim
+ * EPC pages.
+ */
+struct sgx_epc_page_ops {
+	bool (*get)(struct sgx_epc_page *epc_page);
+	void (*put)(struct sgx_epc_page *epc_page);
+	bool (*reclaim)(struct sgx_epc_page *epc_page);
+	void (*block)(struct sgx_epc_page *epc_page);
+	void (*write)(struct sgx_epc_page *epc_page);
+};
+
+struct sgx_epc_page_impl {
+	const struct sgx_epc_page_ops *ops;
+};
+
 struct sgx_epc_page {
 	unsigned long desc;
+	struct sgx_epc_page_impl *impl;
 	struct list_head list;
 };
 
@@ -32,6 +60,10 @@ extern bool sgx_enabled;
 extern bool sgx_lc_enabled;
 extern struct sgx_epc_bank sgx_epc_banks[SGX_MAX_EPC_BANKS];
 
+enum sgx_alloc_flags {
+	SGX_ALLOC_ATOMIC	= BIT(0),
+};
+
 /*
  * enum sgx_epc_page_desc - defines bits and masks for an EPC page's desc
  * @SGX_EPC_BANK_MASK:	      SGX allows a system to multiple EPC banks (at
@@ -69,22 +101,14 @@ static inline void *sgx_epc_addr(struct sgx_epc_page *page)
 	return (void *)(bank->va + (page->desc & PAGE_MASK) - bank->pa);
 }
 
-/**
- * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
- *
- * ENCLS has its own (positive value) error codes and also generates
- * ENCLS specific #GP and #PF faults.  And the ENCLS values get munged
- * with system error codes as everything percolates back up the stack.
- * Unfortunately (for us), we need to precisely identify each unique
- * error code, e.g. the action taken if EWB fails varies based on the
- * type of fault and on the exact SGX error code, i.e. we can't simply
- * convert all faults to -EFAULT.
- *
- * To make all three error types coexist, we set bit 30 to identify an
- * ENCLS fault.  Bit 31 (technically bits N:31) is used to differentiate
- * between positive (faults and SGX error codes) and negative (system
- * error codes) values.
- */
+struct sgx_epc_page *sgx_alloc_page(struct sgx_epc_page_impl *impl,
+				    unsigned int flags);
+int __sgx_free_page(struct sgx_epc_page *page);
+void sgx_free_page(struct sgx_epc_page *page);
+void sgx_page_reclaimable(struct sgx_epc_page *page);
+struct page *sgx_get_backing(struct file *file, pgoff_t index);
+void sgx_put_backing(struct page *backing_page, bool write);
+
 #define ENCLS_FAULT_FLAG 0x40000000UL
 #define ENCLS_FAULT_FLAG_ASM "$0x40000000"
 
diff --git a/arch/x86/kernel/cpu/intel_sgx.c b/arch/x86/kernel/cpu/intel_sgx.c
index 53ac172e8006..1046478a3ab9 100644
--- a/arch/x86/kernel/cpu/intel_sgx.c
+++ b/arch/x86/kernel/cpu/intel_sgx.c
@@ -12,6 +12,20 @@
 #include <asm/sgx.h>
 #include <asm/sgx_pr.h>
 
+/**
+ * enum sgx_swap_constants - the constants used by the swapping code
+ * %SGX_NR_TO_SCAN:	the number of pages to scan in a single round
+ * %SGX_NR_LOW_PAGES:	the low watermark for ksgxswapd when it starts to swap
+ *			pages.
+ * %SGX_NR_HIGH_PAGES:	the high watermark for ksgxswapd what it stops swapping
+ *			pages.
+ */
+enum sgx_swap_constants {
+	SGX_NR_TO_SCAN		= 16,
+	SGX_NR_LOW_PAGES	= 32,
+	SGX_NR_HIGH_PAGES	= 64,
+};
+
 bool sgx_enabled __ro_after_init;
 EXPORT_SYMBOL_GPL(sgx_enabled);
 bool sgx_lc_enabled __ro_after_init;
@@ -20,6 +34,299 @@ struct sgx_epc_bank sgx_epc_banks[SGX_MAX_EPC_BANKS];
 EXPORT_SYMBOL_GPL(sgx_epc_banks);
 
 static int sgx_nr_epc_banks;
+static LIST_HEAD(sgx_active_page_list);
+static DEFINE_SPINLOCK(sgx_active_page_list_lock);
+static struct task_struct *ksgxswapd_tsk;
+static DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
+
+/**
+ * sgx_reclaim_pages - reclaim EPC pages from the consumers
+ *
+ * Takes a fixed chunk of pages from the global list of consumed EPC pages and
+ * tries to swap them. Only the pages that are either being freed by the
+ * consumer or actively used are skipped.
+ */
+static void sgx_reclaim_pages(void)
+{
+	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN + 1];
+	struct sgx_epc_page *epc_page;
+	struct sgx_epc_bank *bank;
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
+		if (epc_page->impl->ops->get(epc_page))
+			chunk[j++] = epc_page;
+		else
+			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+	}
+	spin_unlock(&sgx_active_page_list_lock);
+
+	for (i = 0; i < j; i++) {
+		epc_page = chunk[i];
+		if (epc_page->impl->ops->reclaim(epc_page))
+			continue;
+
+		spin_lock(&sgx_active_page_list_lock);
+		list_add_tail(&epc_page->list, &sgx_active_page_list);
+		spin_unlock(&sgx_active_page_list_lock);
+
+		epc_page->impl->ops->put(epc_page);
+		chunk[i] = NULL;
+	}
+
+	for (i = 0; i < j; i++) {
+		epc_page = chunk[i];
+		if (epc_page)
+			epc_page->impl->ops->block(epc_page);
+	}
+
+	for (i = 0; i < j; i++) {
+		epc_page = chunk[i];
+		if (epc_page) {
+			epc_page->impl->ops->write(epc_page);
+			epc_page->impl->ops->put(epc_page);
+
+			/*
+			 * Put the page back on the free list only after we
+			 * have put() our reference to the owner of the EPC
+			 * page, otherwise the page could be re-allocated and
+			 * we'd call put() on the wrong impl.
+			 */
+			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+
+			bank = sgx_epc_bank(epc_page);
+			spin_lock(&bank->lock);
+			bank->pages[bank->free_cnt++] = epc_page;
+			spin_unlock(&bank->lock);
+		}
+	}
+}
+
+static unsigned long sgx_calc_free_cnt(void)
+{
+	struct sgx_epc_bank *bank;
+	unsigned long free_cnt = 0;
+	int i;
+
+	for (i = 0; i < sgx_nr_epc_banks; i++) {
+		bank = &sgx_epc_banks[i];
+		free_cnt += bank->free_cnt;
+	}
+
+	return free_cnt;
+}
+
+static inline bool sgx_should_reclaim(void)
+{
+	return sgx_calc_free_cnt() < SGX_NR_HIGH_PAGES &&
+	       !list_empty(&sgx_active_page_list);
+}
+
+static int ksgxswapd(void *p)
+{
+	set_freezable();
+
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
+	return 0;
+}
+
+static struct sgx_epc_page *sgx_try_alloc_page(struct sgx_epc_page_impl *impl)
+{
+	struct sgx_epc_bank *bank;
+	struct sgx_epc_page *page;
+	int i;
+
+	for (i = 0; i < sgx_nr_epc_banks; i++) {
+		bank = &sgx_epc_banks[i];
+		spin_lock(&bank->lock);
+		if (bank->free_cnt) {
+			page = bank->pages[bank->free_cnt - 1];
+			bank->free_cnt--;
+		}
+		spin_unlock(&bank->lock);
+
+		if (page) {
+			page->impl = impl;
+			return page;
+		}
+	}
+
+	return NULL;
+}
+
+/**
+ * sgx_alloc_page - Allocate an EPC page
+ * @flags:	allocation flags
+ * @impl:	implementation for the EPC page
+ *
+ * Try to grab a page from the free EPC page list. If there is a free page
+ * available, it is returned to the caller. If called with SGX_ALLOC_ATOMIC,
+ * the function will return immediately if the list is empty. Otherwise, it
+ * will swap pages up until there is a free page available. Upon returning the
+ * low watermark is checked and ksgxswapd is waken up if we are below it.
+ *
+ * Return:
+ *   a pointer to a &struct sgx_epc_page instace,
+ *   -ENOMEM if all pages are unreclaimable,
+ *   -EBUSY when called with SGX_ALLOC_ATOMIC and out of free pages
+ */
+struct sgx_epc_page *sgx_alloc_page(struct sgx_epc_page_impl *impl,
+				    unsigned int flags)
+{
+	struct sgx_epc_page *entry;
+
+	for ( ; ; ) {
+		entry = sgx_try_alloc_page(impl);
+		if (entry)
+			break;
+
+		if (list_empty(&sgx_active_page_list))
+			return ERR_PTR(-ENOMEM);
+
+		if (flags & SGX_ALLOC_ATOMIC) {
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
+}
+EXPORT_SYMBOL_GPL(sgx_alloc_page);
+
+/**
+ * __sgx_free_page - Free an EPC page
+ * @page:	pointer a previously allocated EPC page
+ *
+ * EREMOVE an EPC page and insert it back to the list of free pages.
+ * If the page is reclaimable, deletes it from the active page list.
+ *
+ * Return:
+ *   0 on success
+ *   -EBUSY if the page cannot be removed from the active list
+ *   SGX error code if EREMOVE fails
+ */
+int __sgx_free_page(struct sgx_epc_page *page)
+{
+	struct sgx_epc_bank *bank = sgx_epc_bank(page);
+	int ret;
+
+	/*
+	 * Remove the page from the active list if necessary.  If the page
+	 * is actively being reclaimed, i.e. RECLAIMABLE is set but the
+	 * page isn't on the active list, return -EBUSY as we can't free
+	 * the page at this time since it is "owned" by the reclaimer.
+	 */
+	if (page->desc & SGX_EPC_PAGE_RECLAIMABLE) {
+		spin_lock(&sgx_active_page_list_lock);
+		if (page->desc & SGX_EPC_PAGE_RECLAIMABLE) {
+			if (list_empty(&page->list)) {
+				spin_unlock(&sgx_active_page_list_lock);
+				return -EBUSY;
+			}
+			list_del(&page->list);
+			page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+		}
+		spin_unlock(&sgx_active_page_list_lock);
+	}
+
+	ret = __eremove(sgx_epc_addr(page));
+	if (ret)
+		return ret;
+
+	spin_lock(&bank->lock);
+	bank->pages[bank->free_cnt++] = page;
+	spin_unlock(&bank->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__sgx_free_page);
+
+/**
+ * sgx_free_page - Free an EPC page and WARN on failure
+ * @page:	pointer to a previously allocated EPC page
+ *
+ * EREMOVE an EPC page and insert it back to the list of free pages.
+ * If the page is reclaimable, deletes it from the active page list.
+ * WARN on any failure.  For use when the call site cannot (or chooses
+ * not to) handle failure, i.e. the page is leaked on failure.
+ */
+void sgx_free_page(struct sgx_epc_page *page)
+{
+	int ret;
+
+	ret = __sgx_free_page(page);
+	WARN(ret < 0, "sgx: cannot free page, reclaim in-progress");
+	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
+}
+EXPORT_SYMBOL_GPL(sgx_free_page);
+
+
+/**
+ * sgx_page_reclaimable - mark a page as reclaimable
+ *
+ * @page:	EPC page
+ *
+ * Mark a page as reclaimable and add it to the active page list.  Pages
+ * are automatically removed from the active list when freed.
+ */
+void sgx_page_reclaimable(struct sgx_epc_page *page)
+{
+	spin_lock(&sgx_active_page_list_lock);
+	page->desc |= SGX_EPC_PAGE_RECLAIMABLE;
+	list_add_tail(&page->list, &sgx_active_page_list);
+	spin_unlock(&sgx_active_page_list_lock);
+}
+EXPORT_SYMBOL_GPL(sgx_page_reclaimable);
+
+struct page *sgx_get_backing(struct file *file, pgoff_t index)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct address_space *mapping = inode->i_mapping;
+	gfp_t gfpmask = mapping_gfp_mask(mapping);
+
+	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
+}
+EXPORT_SYMBOL_GPL(sgx_get_backing);
+
+void sgx_put_backing(struct page *backing_page, bool write)
+{
+	if (write)
+		set_page_dirty(backing_page);
+
+	put_page(backing_page);
+}
+EXPORT_SYMBOL_GPL(sgx_put_backing);
 
 static __init int sgx_init_epc_bank(u64 addr, u64 size, unsigned long index,
 				    struct sgx_epc_bank *bank)
@@ -66,6 +373,11 @@ static __init void sgx_page_cache_teardown(void)
 	struct sgx_epc_bank *bank;
 	int i;
 
+	if (ksgxswapd_tsk) {
+		kthread_stop(ksgxswapd_tsk);
+		ksgxswapd_tsk = NULL;
+	}
+
 	for (i = 0; i < sgx_nr_epc_banks; i++) {
 		bank = &sgx_epc_banks[i];
 		iounmap((void *)bank->va);
@@ -86,6 +398,8 @@ static __init int sgx_page_cache_init(void)
 	int ret;
 	int i;
 
+	BUILD_BUG_ON(SGX_MAX_EPC_BANKS > (SGX_EPC_BANK_MASK + 1));
+
 	for (i = 0; i < SGX_MAX_EPC_BANKS; i++) {
 		cpuid_count(SGX_CPUID, 2 + i, &eax, &ebx, &ecx, &edx);
 		if (!(eax & 0xF))
@@ -114,6 +428,7 @@ static __init int sgx_page_cache_init(void)
 
 static __init int sgx_init(void)
 {
+	struct task_struct *tsk;
 	unsigned long fc;
 	int ret;
 
@@ -141,6 +456,13 @@ static __init int sgx_init(void)
 	if (ret)
 		return ret;
 
+	tsk = kthread_run(ksgxswapd, NULL, "ksgxswapd");
+	if (IS_ERR(tsk)) {
+		sgx_page_cache_teardown();
+		return PTR_ERR(tsk);
+	}
+	ksgxswapd_tsk = tsk;
+
 	sgx_enabled = true;
 	sgx_lc_enabled = !!(fc & FEATURE_CONTROL_SGX_LE_WR);
 	return 0;
-- 
2.17.1
