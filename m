Message-ID: <1536678279.5992.9.camel@intel.com>
Subject: Re: [PATCH v13 09/13] x86/sgx: Enclave Page Cache (EPC) memory
 manager
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <nhorman@redhat.com>, <npmccallum@redhat.com>,
	<linux-sgx@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, Serge Ayoun <serge.ayoun@intel.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Date: Tue, 11 Sep 2018 08:04:39 -0700
In-Reply-To: <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
	 <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Return-Path: sean.j.christopherson@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, 2018-08-27 at 21:53 +0300, Jarkko Sakkinen wrote:
> Add a Enclave Page Cache (EPC) memory manager that can be used to
> allocate and free EPC pages. The swapper thread ksgxswapd reclaims pages
> on the event when the number of free EPC pages goes below
> %SGX_NR_LOW_PAGES up until it reaches %SGX_NR_HIGH_PAGES.
> 
> Pages are reclaimed in LRU fashion from a global list. The consumers
> take care of calling EBLOCK (block page from new accesses), ETRACK
> (restart counting the entering hardware threads) and EWB (write page to
> the regular memory) because executing these operations usually (if not
> always) requires to do some subsystem-internal locking operations.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/sgx.h      |  56 ++++--
>  arch/x86/kernel/cpu/intel_sgx.c | 322 ++++++++++++++++++++++++++++++++
>  2 files changed, 362 insertions(+), 16 deletions(-)

...

> +/**
> + * sgx_reclaim_pages - reclaim EPC pages from the consumers
> + *
> + * Takes a fixed chunk of pages from the global list of consumed EPC pages and
> + * tries to swap them. Only the pages that are either being freed by the
> + * consumer or actively used are skipped.
> + */
> +static void sgx_reclaim_pages(void)
> +{
> +	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN + 1];

The array size should simply be SGX_NR_TO_SCAN.  The +1 is a remnant
from the previous version that bounded the for-loops with "!chunk[i]"
check instead of "i < j".  No functional issue, essentially just an
unused variable.

> +	struct sgx_epc_page *epc_page;
> +	struct sgx_epc_bank *bank;
> +	int i, j;
> +
> +	spin_lock(&sgx_active_page_list_lock);
> +	for (i = 0, j = 0; i < SGX_NR_TO_SCAN; i++) {
> +		if (list_empty(&sgx_active_page_list))
> +			break;
> +
> +		epc_page = list_first_entry(&sgx_active_page_list,
> +					    struct sgx_epc_page, list);
> +		list_del_init(&epc_page->list);
> +
> +		if (epc_page->impl->ops->get(epc_page))
> +			chunk[j++] = epc_page;
> +		else
> +			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
> +	}
> +	spin_unlock(&sgx_active_page_list_lock);
> +
> +	for (i = 0; i < j; i++) {
> +		epc_page = chunk[i];
> +		if (epc_page->impl->ops->reclaim(epc_page))
> +			continue;
> +
> +		spin_lock(&sgx_active_page_list_lock);
> +		list_add_tail(&epc_page->list, &sgx_active_page_list);
> +		spin_unlock(&sgx_active_page_list_lock);
> +
> +		epc_page->impl->ops->put(epc_page);
> +		chunk[i] = NULL;
> +	}
> +
> +	for (i = 0; i < j; i++) {
> +		epc_page = chunk[i];
> +		if (epc_page)
> +			epc_page->impl->ops->block(epc_page);
> +	}
> +
> +	for (i = 0; i < j; i++) {
> +		epc_page = chunk[i];
> +		if (epc_page) {
> +			epc_page->impl->ops->write(epc_page);
> +			epc_page->impl->ops->put(epc_page);
> +
> +			/*
> +			 * Put the page back on the free list only after we
> +			 * have put() our reference to the owner of the EPC
> +			 * page, otherwise the page could be re-allocated and
> +			 * we'd call put() on the wrong impl.
> +			 */
> +			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
> +
> +			bank = sgx_epc_bank(epc_page);
> +			spin_lock(&bank->lock);
> +			bank->pages[bank->free_cnt++] = epc_page;
> +			spin_unlock(&bank->lock);
> +		}
> +	}
> +}
