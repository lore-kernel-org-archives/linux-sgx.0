From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<andriy.shevchenko@linux.intel.com>, <tglx@linutronix.de>,
	<kai.svahn@intel.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko
	<andy@infradead.org>, Suresh Siddha <suresh.b.siddha@intel.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: [PATCH v16 20/22] x86/sgx: Add a simple swapper for the EPC memory manager
Date: Tue, 6 Nov 2018 15:45:59 +0200
Message-ID: <20181106134758.10572-21-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

Wire up the EPC manager's reclaim flow to the SGX driver's swapping
functionality.  In the long term there will be multiple users of the
EPC manager, e.g. SGX driver and KVM, thus the interface between the
EPC manager and the driver is fairly genericized and decoupled.  But
to avoid adding unusued infrastructure, do not add any indirection
between the EPC manager and the SGX driver.  This has the unfortunate
and odd side effect of preventing the SGX driver from being compiled
as a loadable module.  However, this should be a temporary situation
that is remedied when a second user of EPC is added, i.e. KVM.

The swapper thread ksgxswapd reclaims pages on the event when the number
of free EPC pages goes below %SGX_NR_LOW_PAGES up until it reaches
%SGX_NR_HIGH_PAGES.

Pages are reclaimed in LRU fashion from a global list. The consumers
take care of calling EBLOCK (block page from new accesses), ETRACK
(restart counting the entering hardware threads) and EWB (write page to
the regular memory) because executing these operations usually (if not
always) requires to do some subsystem-internal locking operations.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
---
 arch/x86/Kconfig                              |   1 +
 arch/x86/include/asm/sgx.h                    |  10 +-
 arch/x86/kernel/cpu/intel_sgx.c               | 241 +++++++++++++++++-
 drivers/platform/x86/intel_sgx/sgx_encl.c     |   5 +-
 .../platform/x86/intel_sgx/sgx_encl_page.c    |   3 +-
 drivers/platform/x86/intel_sgx/sgx_fault.c    |   3 +-
 drivers/platform/x86/intel_sgx/sgx_util.c     |   2 +-
 7 files changed, 245 insertions(+), 20 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b47e1a144409..5c329dfd0fd9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1916,6 +1916,7 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 config INTEL_SGX_CORE
 	bool "Intel SGX core functionality"
 	depends on X86_64 && CPU_SUP_INTEL
+	select INTEL_SGX
 	help
 	Intel Software Guard eXtensions (SGX) CPU feature that allows ring 3
 	applications to create enclaves: private regions of memory that are
diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 4cdfa1d22c6e..afe1291a17d5 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -12,6 +12,7 @@
 
 struct sgx_epc_page {
 	unsigned long desc;
+	void *owner;
 	struct list_head list;
 };
 
@@ -307,10 +308,17 @@ static inline int __emodt(struct sgx_secinfo *secinfo, void *addr)
 	return __encls_ret_2(SGX_EMODT, secinfo, addr);
 }
 
-struct sgx_epc_page *sgx_alloc_page(void);
+struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
 int __sgx_free_page(struct sgx_epc_page *page);
 void sgx_free_page(struct sgx_epc_page *page);
 int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
 	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
+void sgx_page_reclaimable(struct sgx_epc_page *page);
+
+bool sgx_encl_page_get(struct sgx_epc_page *epc_page);
+void sgx_encl_page_put(struct sgx_epc_page *epc_page);
+bool sgx_encl_page_reclaim(struct sgx_epc_page *epc_page);
+void sgx_encl_page_block(struct sgx_epc_page *epc_page);
+void sgx_encl_page_write(struct sgx_epc_page *epc_page);
 
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/intel_sgx.c b/arch/x86/kernel/cpu/intel_sgx.c
index ec3d5de6b037..8a62e1b0809d 100644
--- a/arch/x86/kernel/cpu/intel_sgx.c
+++ b/arch/x86/kernel/cpu/intel_sgx.c
@@ -10,24 +10,141 @@
 #include <linux/slab.h>
 #include <asm/sgx.h>
 
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
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 EXPORT_SYMBOL_GPL(sgx_epc_sections);
 
 static int sgx_nr_epc_sections;
+static LIST_HEAD(sgx_active_page_list);
+static DEFINE_SPINLOCK(sgx_active_page_list_lock);
+static struct task_struct *ksgxswapd_tsk;
+static DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
 
 /* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
 static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
 
 /**
- * sgx_alloc_page - Allocate an EPC page
- *
- * Try to grab a page from the free EPC page list.
+ * sgx_reclaim_pages - reclaim EPC pages from the consumers
  *
- * Return:
- *   a pointer to a &struct sgx_epc_page instance,
- *   -errno on error
+ * Takes a fixed chunk of pages from the global list of consumed EPC pages and
+ * tries to swap them. Only the pages that are either being freed by the
+ * consumer or actively used are skipped.
  */
-struct sgx_epc_page *sgx_alloc_page(void)
+static void sgx_reclaim_pages(void)
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
+		if (sgx_encl_page_get(epc_page))
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
+		if (sgx_encl_page_reclaim(epc_page))
+			continue;
+
+		sgx_encl_page_put(epc_page);
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
+			sgx_encl_page_block(epc_page);
+	}
+
+	for (i = 0; i < j; i++) {
+		epc_page = chunk[i];
+		if (epc_page) {
+			sgx_encl_page_write(epc_page);
+			sgx_encl_page_put(epc_page);
+			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+
+			section = sgx_epc_section(epc_page);
+			spin_lock(&section->lock);
+			section->pages[section->free_cnt++] = epc_page;
+			spin_unlock(&section->lock);
+		}
+	}
+}
+
+static unsigned long sgx_calc_free_cnt(void)
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
+static struct sgx_epc_page *sgx_try_alloc_page(void *owner)
 {
 	struct sgx_epc_section *section;
 	struct sgx_epc_page *page;
@@ -42,11 +159,58 @@ struct sgx_epc_page *sgx_alloc_page(void)
 		}
 		spin_unlock(&section->lock);
 
-		if (page)
+		if (page) {
+			page->owner = owner;
 			return page;
+		}
+	}
+
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
 	}
 
-	return ERR_PTR(-ENOMEM);
+	if (sgx_calc_free_cnt() < SGX_NR_LOW_PAGES)
+		wake_up(&ksgxswapd_waitq);
+
+	return entry;
 }
 EXPORT_SYMBOL_GPL(sgx_alloc_page);
 
@@ -54,10 +218,12 @@ EXPORT_SYMBOL_GPL(sgx_alloc_page);
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
@@ -65,6 +231,23 @@ int __sgx_free_page(struct sgx_epc_page *page)
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
@@ -81,15 +264,17 @@ EXPORT_SYMBOL_GPL(__sgx_free_page);
  * sgx_free_page - Free an EPC page and WARN on failure
  * @page:	pointer to a previously allocated EPC page
  *
- * EREMOVE an EPC page and insert it back to the list of free pages, and WARN
- * if EREMOVE fails.  For use when the call site cannot (or chooses not to)
- * handle failure, i.e. the page is leaked on failure.
+ * EREMOVE an EPC page and insert it back to the list of free pages.  If the
+ * page is reclaimable, delete it from the active page list.  WARN on any
+ * failure.  For use when the call site cannot (or chooses not to) handle
+ * failure, i.e. the page is leaked on failure.
  */
 void sgx_free_page(struct sgx_epc_page *page)
 {
 	int ret;
 
 	ret = __sgx_free_page(page);
+	WARN(ret < 0, "sgx: cannot free page, reclaim in-progress");
 	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
 }
 EXPORT_SYMBOL_GPL(sgx_free_page);
@@ -142,6 +327,23 @@ int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
 }
 EXPORT_SYMBOL(sgx_einit);
 
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
 static __init void sgx_free_epc_section(struct sgx_epc_section *section)
 {
 	int i;
@@ -190,6 +392,11 @@ static __init void sgx_page_cache_teardown(void)
 {
 	int i;
 
+	if (ksgxswapd_tsk) {
+		kthread_stop(ksgxswapd_tsk);
+		ksgxswapd_tsk = NULL;
+	}
+
 	for (i = 0; i < sgx_nr_epc_sections; i++)
 		sgx_free_epc_section(&sgx_epc_sections[i]);
 }
@@ -254,6 +461,7 @@ static __init int sgx_page_cache_init(void)
 
 static __init int sgx_init(void)
 {
+	struct task_struct *tsk;
 	int ret;
 
 	if (!boot_cpu_has(X86_FEATURE_SGX))
@@ -263,6 +471,13 @@ static __init int sgx_init(void)
 	if (ret)
 		return ret;
 
+	tsk = kthread_run(ksgxswapd, NULL, "ksgxswapd");
+	if (IS_ERR(tsk)) {
+		sgx_page_cache_teardown();
+		return PTR_ERR(tsk);
+	}
+	ksgxswapd_tsk = tsk;
+
 	return 0;
 }
 
diff --git a/drivers/platform/x86/intel_sgx/sgx_encl.c b/drivers/platform/x86/intel_sgx/sgx_encl.c
index 1d0a51120e3d..5ef2fa7e92c3 100644
--- a/drivers/platform/x86/intel_sgx/sgx_encl.c
+++ b/drivers/platform/x86/intel_sgx/sgx_encl.c
@@ -191,6 +191,7 @@ static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
 	encl->secs_child_cnt++;
 	sgx_set_page_loaded(encl_page, epc_page);
 	sgx_test_and_clear_young(encl_page);
+	sgx_page_reclaimable(encl_page->epc_page);
 	return true;
 }
 
@@ -220,7 +221,7 @@ static void sgx_add_page_worker(struct work_struct *work)
 		if (skip_rest)
 			goto next;
 
-		epc_page = sgx_alloc_page();
+		epc_page = sgx_alloc_page(req->encl_page, true);
 		down_read(&encl->mm->mmap_sem);
 		mutex_lock(&encl->lock);
 
@@ -467,7 +468,7 @@ int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	struct sgx_epc_page *secs_epc;
 	long ret;
 
-	secs_epc = sgx_alloc_page();
+	secs_epc = sgx_alloc_page(&encl->secs, true);
 	if (IS_ERR(secs_epc)) {
 		ret = PTR_ERR(secs_epc);
 		return ret;
diff --git a/drivers/platform/x86/intel_sgx/sgx_encl_page.c b/drivers/platform/x86/intel_sgx/sgx_encl_page.c
index fc9bea9f4aea..885eea019c86 100644
--- a/drivers/platform/x86/intel_sgx/sgx_encl_page.c
+++ b/drivers/platform/x86/intel_sgx/sgx_encl_page.c
@@ -12,8 +12,7 @@
 
 static inline struct sgx_encl_page *to_encl_page(struct sgx_epc_page *epc_page)
 {
-	WARN_ON_ONCE(1);
-	return NULL;
+	return (struct sgx_encl_page *)epc_page->owner;
 }
 
 bool sgx_encl_page_get(struct sgx_epc_page *epc_page)
diff --git a/drivers/platform/x86/intel_sgx/sgx_fault.c b/drivers/platform/x86/intel_sgx/sgx_fault.c
index 61d77e9f8fec..71acb2d3f65c 100644
--- a/drivers/platform/x86/intel_sgx/sgx_fault.c
+++ b/drivers/platform/x86/intel_sgx/sgx_fault.c
@@ -13,7 +13,7 @@ static struct sgx_epc_page *__sgx_load_faulted_page(
 	struct sgx_epc_page *epc_page;
 	int ret;
 
-	epc_page = sgx_alloc_page();
+	epc_page = sgx_alloc_page(encl_page, false);
 	if (IS_ERR(epc_page))
 		return epc_page;
 	ret = sgx_encl_load_page(encl_page, epc_page);
@@ -73,6 +73,7 @@ static struct sgx_encl_page *__sgx_fault_page(struct vm_area_struct *vma,
 
 	encl->secs_child_cnt++;
 	sgx_test_and_clear_young(entry);
+	sgx_page_reclaimable(entry->epc_page);
 	if (do_reserve)
 		entry->desc |= SGX_ENCL_PAGE_RESERVED;
 
diff --git a/drivers/platform/x86/intel_sgx/sgx_util.c b/drivers/platform/x86/intel_sgx/sgx_util.c
index eb8072b36a47..1480c4ad0d33 100644
--- a/drivers/platform/x86/intel_sgx/sgx_util.c
+++ b/drivers/platform/x86/intel_sgx/sgx_util.c
@@ -81,7 +81,7 @@ struct sgx_epc_page *sgx_alloc_va_page(void)
 	struct sgx_epc_page *epc_page;
 	int ret;
 
-	epc_page = sgx_alloc_page();
+	epc_page = sgx_alloc_page(NULL, true);
 	if (IS_ERR(epc_page))
 		return ERR_CAST(epc_page);
 
-- 
2.19.1
