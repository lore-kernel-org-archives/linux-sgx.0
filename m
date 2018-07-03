Date: Tue, 3 Jul 2018 22:41:14 +0200
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 09/13] x86/sgx: EPC page allocation routines
In-Reply-To: <20180703182118.15024-10-jarkko.sakkinen@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1807032216390.1816@nanos.tec.linutronix.de>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com> <20180703182118.15024-10-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="US-ASCII"
Return-Path: tglx@linutronix.de
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:
>  
> +#define SGX_NR_TO_SCAN	16
> +#define SGX_NR_LOW_PAGES 32
> +#define SGX_NR_HIGH_PAGES 64
> +
>  bool sgx_enabled __ro_after_init;
>  EXPORT_SYMBOL(sgx_enabled);
>  bool sgx_lc_enabled __ro_after_init;
>  EXPORT_SYMBOL(sgx_lc_enabled);
> +LIST_HEAD(sgx_active_page_list);
> +EXPORT_SYMBOL(sgx_active_page_list);
> +DEFINE_SPINLOCK(sgx_active_page_list_lock);
> +EXPORT_SYMBOL(sgx_active_page_list_lock);

Why is all of this exported. If done right then no call site has to fiddle
with the list and the lock at all.

>  static atomic_t sgx_nr_free_pages = ATOMIC_INIT(0);
>  static struct sgx_epc_bank sgx_epc_banks[SGX_MAX_EPC_BANKS];
>  static int sgx_nr_epc_banks;
> +static struct task_struct *ksgxswapd_tsk;
> +static DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
> +
> +static void sgx_swap_cluster(void)
> +{
> +	struct sgx_epc_page *cluster[SGX_NR_TO_SCAN + 1];
> +	struct sgx_epc_page *epc_page;
> +	int i;
> +	int j;

  	int i, j;

> +	memset(cluster, 0, sizeof(cluster));
> +
> +	for (i = 0, j = 0; i < SGX_NR_TO_SCAN; i++) {
> +		spin_lock(&sgx_active_page_list_lock);
> +		if (list_empty(&sgx_active_page_list)) {
> +			spin_unlock(&sgx_active_page_list_lock);
> +			break;
> +		}
> +		epc_page = list_first_entry(&sgx_active_page_list,
> +					    struct sgx_epc_page, list);
> +		if (!epc_page->impl->ops->get(epc_page)) {
> +			list_move_tail(&epc_page->list, &sgx_active_page_list);
> +			spin_unlock(&sgx_active_page_list_lock);
> +			continue;
> +		}
> +		list_del(&epc_page->list);
> +		spin_unlock(&sgx_active_page_list_lock);
> +
> +		if (epc_page->impl->ops->reclaim(epc_page)) {
> +			cluster[j++] = epc_page;
> +		} else {
> +			spin_lock(&sgx_active_page_list_lock);
> +			list_add_tail(&epc_page->list, &sgx_active_page_list);
> +			spin_unlock(&sgx_active_page_list_lock);
> +			epc_page->impl->ops->put(epc_page);
> +		}
> +	}
> +
> +	for (i = 0; cluster[i]; i++) {
> +		epc_page = cluster[i];
> +		epc_page->impl->ops->block(epc_page);
> +	}
> +
> +	for (i = 0; cluster[i]; i++) {
> +		epc_page = cluster[i];
> +		epc_page->impl->ops->write(epc_page);
> +		epc_page->impl->ops->put(epc_page);
> +		sgx_free_page(epc_page);
> +	}

Thanks a lot for commenting this piece of art thoughtfully. It's entirely
clear how all of this works now.

> +}
> +
> +static int ksgxswapd(void *p)
> +{
> +	set_freezable();
> +
> +	while (!kthread_should_stop()) {
> +		if (try_to_freeze())
> +			continue;
> +
> +		wait_event_freezable(ksgxswapd_waitq, kthread_should_stop() ||
> +				     atomic_read(&sgx_nr_free_pages) <
> +				     SGX_NR_HIGH_PAGES);
> +
> +		if (atomic_read(&sgx_nr_free_pages) < SGX_NR_HIGH_PAGES)
> +			sgx_swap_cluster();
> +	}
> +
> +	pr_info("%s: done\n", __func__);

Really useful. 

> +	return 0;
> +}
> +
> +static struct sgx_epc_page *sgx_try_alloc_page(struct sgx_epc_page_impl *impl)
> +{
> +	struct sgx_epc_bank *bank;
> +	struct sgx_epc_page *page = NULL;
> +	int i;
> +
> +	for (i = 0; i < sgx_nr_epc_banks; i++) {
> +		bank = &sgx_epc_banks[i];
> +
> +		down_write(&bank->lock);
> +
> +		if (atomic_read(&bank->free_cnt))

And these atomics are required becasue bank->lock protection is not
sufficient or what am I missing here?

> +			page = bank->pages[atomic_dec_return(&bank->free_cnt)];
> +
> +		up_write(&bank->lock);
> +
> +		if (page)
> +			break;
> +	}
> +
> +	if (page) {
> +		atomic_dec(&sgx_nr_free_pages);
> +		page->impl = impl;
> +	}
> +
> +	return page;
> +}
> +
> +/**
> + * sgx_alloc_page - allocate an EPC page
> + * @flags:	allocation flags
> + * @impl:	implementation for the struct sgx_epc_page
> + *
> + * Try to grab a page from the free EPC page list. If there is a free page
> + * available, it is returned to the caller. If called with SGX_ALLOC_ATOMIC,
> + * the function will return immediately if the list is empty. Otherwise, it
> + * will swap pages up until there is a free page available. Upon returning the
> + * low watermark is checked and ksgxswapd is waken up if we are below it.
> + *
> + * Return:
> + *   a &struct sgx_epc_page instace,
> + *   -ENOMEM if all pages are unreclaimable,
> + *   -EBUSY when called with SGX_ALLOC_ATOMIC and out of free pages
> + */
> +struct sgx_epc_page *sgx_alloc_page(struct sgx_epc_page_impl *impl,
> +				    unsigned int flags)
> +{
> +	struct sgx_epc_page *entry;
> +
> +	for ( ; ; ) {
> +		entry = sgx_try_alloc_page(impl);
> +		if (entry)
> +			break;
> +
> +		if (list_empty(&sgx_active_page_list))
> +			return ERR_PTR(-ENOMEM);
> +
> +		if (flags & SGX_ALLOC_ATOMIC) {
> +			entry = ERR_PTR(-EBUSY);
> +			break;
> +		}
> +
> +		if (signal_pending(current)) {
> +			entry = ERR_PTR(-ERESTARTSYS);
> +			break;
> +		}
> +
> +		sgx_swap_cluster();
> +		schedule();
> +	}
> +
> +	if (atomic_read(&sgx_nr_free_pages) < SGX_NR_LOW_PAGES)
> +		wake_up(&ksgxswapd_waitq);

What's the logic of SGX_NR_LOW_PAGES vs. SGX_NR_HIGH_PAGES? 

> +
> +	return entry;
> +}
> +EXPORT_SYMBOL(sgx_alloc_page);
> +
> +/**
> + * sgx_free_page - free an EPC page
> + *
> + * @page:	any EPC page
> + *
> + * Remove an EPC page and insert it back to the list of free pages.
> + *
> + * Return: SGX error code
> + */
> +int sgx_free_page(struct sgx_epc_page *page)
> +{
> +	struct sgx_epc_bank *bank = SGX_EPC_BANK(page);
> +	int ret;
> +
> +	ret = sgx_eremove(page);
> +	if (ret) {
> +		pr_debug("EREMOVE returned %d\n", ret);
> +		return ret;
> +	}
> +
> +	down_read(&bank->lock);
> +	bank->pages[atomic_inc_return(&bank->free_cnt) - 1] = page;
> +	atomic_inc(&sgx_nr_free_pages);
> +	up_read(&bank->lock);

I have hard time to see the benefit of this reader/writer semaphore
here. Both sides which fiddle with the bank pages are doing a simple
de/increment of free_cnt and a store resp. load. So what justifies the
overhead of a rwsem?

>  static __init int sgx_init_epc_bank(unsigned long addr, unsigned long size,
>  				    unsigned long index,
>  				    struct sgx_epc_bank *bank)
> @@ -114,6 +318,11 @@ static __init void sgx_page_cache_teardown(void)
>  		kfree(bank->pages);
>  		kfree(bank->pages_data);
>  	}
> +
> +	if (ksgxswapd_tsk) {
> +		kthread_stop(ksgxswapd_tsk);
> +		ksgxswapd_tsk = NULL;

This stops the thread _AFTER_ freeing all the bank memory. Is that actually
correct?

Thanks,

	tglx
