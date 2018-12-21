Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B76C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6AD21927
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388562AbeLUXPX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 18:15:23 -0500
Received: from mga17.intel.com ([192.55.52.151]:17725 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730803AbeLUXPX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 18:15:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 15:15:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120338694"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 15:15:14 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v18 21/25] x86/sgx: Add a simple swapper for the EPC memory manager
Date:   Sat, 22 Dec 2018 01:11:50 +0200
Message-Id: <20181221231154.6120-22-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

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

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
---
 arch/x86/Kconfig                           |   1 +
 arch/x86/include/asm/sgx.h                 |  15 +-
 arch/x86/kernel/cpu/sgx/driver/encl.c      |   5 +-
 arch/x86/kernel/cpu/sgx/driver/encl_page.c |   3 +-
 arch/x86/kernel/cpu/sgx/driver/fault.c     |   3 +-
 arch/x86/kernel/cpu/sgx/driver/va.c        |   2 +-
 arch/x86/kernel/cpu/sgx/main.c             | 241 +++++++++++++++++++--
 7 files changed, 250 insertions(+), 20 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9673d74dc744..267df58d9704 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1922,6 +1922,7 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 config INTEL_SGX_CORE
 	bool "Intel SGX core functionality"
 	depends on X86_64 && CPU_SUP_INTEL
+	select INTEL_SGX
 	help
 	Intel(R) SGX is a set of CPU instructions that can be used by
 	applications to set aside private regions of code and data.  The code
diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index ad4a8ea57bd5..d4f61d1c5c2a 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -12,6 +12,7 @@
 
 struct sgx_epc_page {
 	unsigned long desc;
+	void *owner;
 	struct list_head list;
 };
 
@@ -41,9 +42,14 @@ extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
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
 
@@ -303,10 +309,17 @@ static inline int __emodt(struct sgx_secinfo *secinfo, void *addr)
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
diff --git a/arch/x86/kernel/cpu/sgx/driver/encl.c b/arch/x86/kernel/cpu/sgx/driver/encl.c
index 4ae7674e9c8c..ded5105f2a8d 100644
--- a/arch/x86/kernel/cpu/sgx/driver/encl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/encl.c
@@ -193,6 +193,7 @@ static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
 	encl_page->desc |= SGX_ENCL_PAGE_LOADED;
 	encl->secs_child_cnt++;
 	sgx_test_and_clear_young(encl_page);
+	sgx_page_reclaimable(encl_page->epc_page);
 
 	return true;
 }
@@ -223,7 +224,7 @@ static void sgx_add_page_worker(struct work_struct *work)
 		if (skip_rest)
 			goto next;
 
-		epc_page = sgx_alloc_page();
+		epc_page = sgx_alloc_page(req->encl_page, true);
 		down_read(&encl->mm->mmap_sem);
 		mutex_lock(&encl->lock);
 
@@ -461,7 +462,7 @@ int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	struct sgx_epc_page *secs_epc;
 	long ret;
 
-	secs_epc = sgx_alloc_page();
+	secs_epc = sgx_alloc_page(&encl->secs, true);
 	if (IS_ERR(secs_epc)) {
 		ret = PTR_ERR(secs_epc);
 		return ret;
diff --git a/arch/x86/kernel/cpu/sgx/driver/encl_page.c b/arch/x86/kernel/cpu/sgx/driver/encl_page.c
index 1bd27444a1f9..58da36b0e39c 100644
--- a/arch/x86/kernel/cpu/sgx/driver/encl_page.c
+++ b/arch/x86/kernel/cpu/sgx/driver/encl_page.c
@@ -12,8 +12,7 @@
 
 static inline struct sgx_encl_page *to_encl_page(struct sgx_epc_page *epc_page)
 {
-	WARN_ON_ONCE(1);
-	return NULL;
+	return (struct sgx_encl_page *)epc_page->owner;
 }
 
 bool sgx_encl_page_get(struct sgx_epc_page *epc_page)
diff --git a/arch/x86/kernel/cpu/sgx/driver/fault.c b/arch/x86/kernel/cpu/sgx/driver/fault.c
index b30c4b837f0f..ec5b76fdc709 100644
--- a/arch/x86/kernel/cpu/sgx/driver/fault.c
+++ b/arch/x86/kernel/cpu/sgx/driver/fault.c
@@ -71,7 +71,7 @@ static struct sgx_epc_page *sgx_load_page(struct sgx_encl_page *encl_page)
 	struct sgx_epc_page *epc_page;
 	int ret;
 
-	epc_page = sgx_alloc_page();
+	epc_page = sgx_alloc_page(encl_page, false);
 	if (IS_ERR(epc_page))
 		return epc_page;
 
@@ -135,6 +135,7 @@ static struct sgx_encl_page *sgx_try_fault_page(struct vm_area_struct *vma,
 
 	encl->secs_child_cnt++;
 	sgx_test_and_clear_young(entry);
+	sgx_page_reclaimable(entry->epc_page);
 	if (do_reserve)
 		entry->desc |= SGX_ENCL_PAGE_RESERVED;
 
diff --git a/arch/x86/kernel/cpu/sgx/driver/va.c b/arch/x86/kernel/cpu/sgx/driver/va.c
index f57aacefb6eb..fe0fc39bc098 100644
--- a/arch/x86/kernel/cpu/sgx/driver/va.c
+++ b/arch/x86/kernel/cpu/sgx/driver/va.c
@@ -17,7 +17,7 @@ struct sgx_epc_page *sgx_alloc_va_page(void)
 	struct sgx_epc_page *epc_page;
 	int ret;
 
-	epc_page = sgx_alloc_page();
+	epc_page = sgx_alloc_page(NULL, true);
 	if (IS_ERR(epc_page))
 		return ERR_CAST(epc_page);
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index d10cd0ceb96e..30fd69f1fc07 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -10,10 +10,28 @@
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
@@ -41,15 +59,114 @@ static struct sgx_epc_page *sgx_section_get_page(
 }
 
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
+			sgx_section_put_page(section, epc_page);
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
@@ -61,11 +178,58 @@ struct sgx_epc_page *sgx_alloc_page(void)
 		page = sgx_section_get_page(section);
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
 
@@ -73,10 +237,12 @@ EXPORT_SYMBOL_GPL(sgx_alloc_page);
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
@@ -84,6 +250,23 @@ int __sgx_free_page(struct sgx_epc_page *page)
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
@@ -100,15 +283,17 @@ EXPORT_SYMBOL_GPL(__sgx_free_page);
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
@@ -161,6 +346,23 @@ int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
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
 	struct sgx_epc_page *page;
@@ -207,6 +409,11 @@ static __init void sgx_page_cache_teardown(void)
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
@@ -272,6 +479,7 @@ static __init int sgx_page_cache_init(void)
 
 static __init int sgx_init(void)
 {
+	struct task_struct *tsk;
 	int ret;
 
 	if (!boot_cpu_has(X86_FEATURE_SGX))
@@ -281,6 +489,13 @@ static __init int sgx_init(void)
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
 
-- 
2.19.1

