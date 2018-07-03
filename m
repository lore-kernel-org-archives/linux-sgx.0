From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v12 09/13] x86/sgx: EPC page allocation routines
Date: Tue, 3 Jul 2018 21:19:54 +0300
Message-ID: <20180703182118.15024-10-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

SGX has a set of data structures to maintain information about the enclaves
and their security properties. BIOS reserves a fixed size region of
physical memory for these structures by setting Processor Reserved Memory
Range Registers (PRMRR). This memory area is called Enclave Page Cache
(EPC).

This commit implements the routines to allocate and free pages from
different EPC banks. There is also a swapper thread ksgxswapd for EPC
pages that gets woken up by sgx_alloc_page() when we run below the low
watermark. The swapper thread continues swapping pages up until it
reaches the high watermark.

The SGX driver and in future KVM provide a set of callbacks that are
used to reclaim, block and write an EPC pages. Kernel takes the
responsibility of maintaining LRU cache for them.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx.h      |  26 ++++
 arch/x86/kernel/cpu/intel_sgx.c | 216 ++++++++++++++++++++++++++++++++
 2 files changed, 242 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index a42c8ed10f7d..4f5f32b37b5d 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -169,8 +169,23 @@ static inline int __emodt(struct sgx_secinfo *secinfo, void *epc)
 #define SGX_EPC_PFN(epc_page) PFN_DOWN((unsigned long)(epc_page->desc))
 #define SGX_EPC_ADDR(epc_page) ((unsigned long)(epc_page->desc) & PAGE_MASK)
 
+struct sgx_epc_page;
+
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
 
@@ -186,9 +201,20 @@ struct sgx_epc_bank {
 
 extern bool sgx_enabled;
 extern bool sgx_lc_enabled;
+extern struct list_head sgx_active_page_list;
+extern struct spinlock sgx_active_page_list_lock;
+
+enum sgx_alloc_flags {
+	SGX_ALLOC_ATOMIC	= BIT(0),
+};
 
+struct sgx_epc_page *sgx_alloc_page(struct sgx_epc_page_impl *impl,
+				    unsigned int flags);
+int sgx_free_page(struct sgx_epc_page *page);
 void *sgx_get_page(struct sgx_epc_page *ptr);
 void sgx_put_page(void *epc_page_ptr);
+struct page *sgx_get_backing(struct file *file, pgoff_t index);
+void sgx_put_backing(struct page *backing_page, bool write);
 
 #define SGX_FN(name, params...)		\
 {					\
diff --git a/arch/x86/kernel/cpu/intel_sgx.c b/arch/x86/kernel/cpu/intel_sgx.c
index 60cbc7cfb868..b52bab8eff99 100644
--- a/arch/x86/kernel/cpu/intel_sgx.c
+++ b/arch/x86/kernel/cpu/intel_sgx.c
@@ -12,14 +12,199 @@
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 
+#define SGX_NR_TO_SCAN	16
+#define SGX_NR_LOW_PAGES 32
+#define SGX_NR_HIGH_PAGES 64
+
 bool sgx_enabled __ro_after_init;
 EXPORT_SYMBOL(sgx_enabled);
 bool sgx_lc_enabled __ro_after_init;
 EXPORT_SYMBOL(sgx_lc_enabled);
+LIST_HEAD(sgx_active_page_list);
+EXPORT_SYMBOL(sgx_active_page_list);
+DEFINE_SPINLOCK(sgx_active_page_list_lock);
+EXPORT_SYMBOL(sgx_active_page_list_lock);
 
 static atomic_t sgx_nr_free_pages = ATOMIC_INIT(0);
 static struct sgx_epc_bank sgx_epc_banks[SGX_MAX_EPC_BANKS];
 static int sgx_nr_epc_banks;
+static struct task_struct *ksgxswapd_tsk;
+static DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
+
+static void sgx_swap_cluster(void)
+{
+	struct sgx_epc_page *cluster[SGX_NR_TO_SCAN + 1];
+	struct sgx_epc_page *epc_page;
+	int i;
+	int j;
+
+	memset(cluster, 0, sizeof(cluster));
+
+	for (i = 0, j = 0; i < SGX_NR_TO_SCAN; i++) {
+		spin_lock(&sgx_active_page_list_lock);
+		if (list_empty(&sgx_active_page_list)) {
+			spin_unlock(&sgx_active_page_list_lock);
+			break;
+		}
+		epc_page = list_first_entry(&sgx_active_page_list,
+					    struct sgx_epc_page, list);
+		if (!epc_page->impl->ops->get(epc_page)) {
+			list_move_tail(&epc_page->list, &sgx_active_page_list);
+			spin_unlock(&sgx_active_page_list_lock);
+			continue;
+		}
+		list_del(&epc_page->list);
+		spin_unlock(&sgx_active_page_list_lock);
+
+		if (epc_page->impl->ops->reclaim(epc_page)) {
+			cluster[j++] = epc_page;
+		} else {
+			spin_lock(&sgx_active_page_list_lock);
+			list_add_tail(&epc_page->list, &sgx_active_page_list);
+			spin_unlock(&sgx_active_page_list_lock);
+			epc_page->impl->ops->put(epc_page);
+		}
+	}
+
+	for (i = 0; cluster[i]; i++) {
+		epc_page = cluster[i];
+		epc_page->impl->ops->block(epc_page);
+	}
+
+	for (i = 0; cluster[i]; i++) {
+		epc_page = cluster[i];
+		epc_page->impl->ops->write(epc_page);
+		epc_page->impl->ops->put(epc_page);
+		sgx_free_page(epc_page);
+	}
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
+				     atomic_read(&sgx_nr_free_pages) <
+				     SGX_NR_HIGH_PAGES);
+
+		if (atomic_read(&sgx_nr_free_pages) < SGX_NR_HIGH_PAGES)
+			sgx_swap_cluster();
+	}
+
+	pr_info("%s: done\n", __func__);
+	return 0;
+}
+
+static struct sgx_epc_page *sgx_try_alloc_page(struct sgx_epc_page_impl *impl)
+{
+	struct sgx_epc_bank *bank;
+	struct sgx_epc_page *page = NULL;
+	int i;
+
+	for (i = 0; i < sgx_nr_epc_banks; i++) {
+		bank = &sgx_epc_banks[i];
+
+		down_write(&bank->lock);
+
+		if (atomic_read(&bank->free_cnt))
+			page = bank->pages[atomic_dec_return(&bank->free_cnt)];
+
+		up_write(&bank->lock);
+
+		if (page)
+			break;
+	}
+
+	if (page) {
+		atomic_dec(&sgx_nr_free_pages);
+		page->impl = impl;
+	}
+
+	return page;
+}
+
+/**
+ * sgx_alloc_page - allocate an EPC page
+ * @flags:	allocation flags
+ * @impl:	implementation for the struct sgx_epc_page
+ *
+ * Try to grab a page from the free EPC page list. If there is a free page
+ * available, it is returned to the caller. If called with SGX_ALLOC_ATOMIC,
+ * the function will return immediately if the list is empty. Otherwise, it
+ * will swap pages up until there is a free page available. Upon returning the
+ * low watermark is checked and ksgxswapd is waken up if we are below it.
+ *
+ * Return:
+ *   a &struct sgx_epc_page instace,
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
+		sgx_swap_cluster();
+		schedule();
+	}
+
+	if (atomic_read(&sgx_nr_free_pages) < SGX_NR_LOW_PAGES)
+		wake_up(&ksgxswapd_waitq);
+
+	return entry;
+}
+EXPORT_SYMBOL(sgx_alloc_page);
+
+/**
+ * sgx_free_page - free an EPC page
+ *
+ * @page:	any EPC page
+ *
+ * Remove an EPC page and insert it back to the list of free pages.
+ *
+ * Return: SGX error code
+ */
+int sgx_free_page(struct sgx_epc_page *page)
+{
+	struct sgx_epc_bank *bank = SGX_EPC_BANK(page);
+	int ret;
+
+	ret = sgx_eremove(page);
+	if (ret) {
+		pr_debug("EREMOVE returned %d\n", ret);
+		return ret;
+	}
+
+	down_read(&bank->lock);
+	bank->pages[atomic_inc_return(&bank->free_cnt) - 1] = page;
+	atomic_inc(&sgx_nr_free_pages);
+	up_read(&bank->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(sgx_free_page);
 
 /**
  * sgx_get_page - pin an EPC page
@@ -51,6 +236,25 @@ void sgx_put_page(void *ptr)
 }
 EXPORT_SYMBOL(sgx_put_page);
 
+struct page *sgx_get_backing(struct file *file, pgoff_t index)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct address_space *mapping = inode->i_mapping;
+	gfp_t gfpmask = mapping_gfp_mask(mapping);
+
+	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
+}
+EXPORT_SYMBOL(sgx_get_backing);
+
+void sgx_put_backing(struct page *backing_page, bool write)
+{
+	if (write)
+		set_page_dirty(backing_page);
+
+	put_page(backing_page);
+}
+EXPORT_SYMBOL(sgx_put_backing);
+
 static __init int sgx_init_epc_bank(unsigned long addr, unsigned long size,
 				    unsigned long index,
 				    struct sgx_epc_bank *bank)
@@ -114,6 +318,11 @@ static __init void sgx_page_cache_teardown(void)
 		kfree(bank->pages);
 		kfree(bank->pages_data);
 	}
+
+	if (ksgxswapd_tsk) {
+		kthread_stop(ksgxswapd_tsk);
+		ksgxswapd_tsk = NULL;
+	}
 }
 
 static __init int sgx_page_cache_init(void)
@@ -182,6 +391,7 @@ static __init bool sgx_is_enabled(bool *lc_enabled)
 
 static __init int sgx_init(void)
 {
+	struct task_struct *tsk;
 	int ret;
 
 	if (!sgx_is_enabled(&sgx_lc_enabled))
@@ -191,6 +401,12 @@ static __init int sgx_init(void)
 	if (ret)
 		return ret;
 
+	tsk = kthread_run(ksgxswapd, NULL, "ksgxswapd");
+	if (IS_ERR(tsk)) {
+		sgx_page_cache_teardown();
+		return PTR_ERR(tsk);
+	}
+	ksgxswapd_tsk = tsk;
 	sgx_enabled = true;
 	return 0;
 }
-- 
2.17.1
