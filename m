Subject: Re: [PATCH v13 07/13] x86/sgx: Add data structures for tracking the
 EPC pages
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-8-jarkko.sakkinen@linux.intel.com>
CC: <sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Serge Ayoun
	<serge.ayoun@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <4666cae8-c711-8dd5-cbce-3d97cc19a9e5@intel.com>
Date: Mon, 27 Aug 2018 14:07:53 -0700
In-Reply-To: <20180827185507.17087-8-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 08/27/2018 11:53 AM, Jarkko Sakkinen wrote:
> Add data structures to track Enclave Page Cache (EPC) pages.  EPC is
> divided into multiple banks (1-N) of which addresses and sizes can be
> enumerated with CPUID by the OS.
> 
> On NUMA systems a node can have at most bank. A bank can be at most part of
> two nodes. SGX supports both nodes with a single memory controller and also
> sub-cluster nodes with severals memory controllers on a single die.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/sgx.h      |  60 ++++++++++++++++++
>  arch/x86/kernel/cpu/intel_sgx.c | 106 +++++++++++++++++++++++++++++++-
>  2 files changed, 164 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 2130e639ab49..17b7b3aa66bf 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -4,9 +4,69 @@
>  #ifndef _ASM_X86_SGX_H
>  #define _ASM_X86_SGX_H
>  
> +#include <linux/bitops.h>
> +#include <linux/err.h>
> +#include <linux/rwsem.h>
>  #include <linux/types.h>
> +#include <asm/sgx_arch.h>
> +#include <asm/asm.h>
> +
> +#define SGX_MAX_EPC_BANKS 8

This is _still_ missing a meaningful description of what a bank is and
whether it is a hardware or software structure.

It would also help us to determine whether your bit packing below is
really required.

> +struct sgx_epc_page {
> +	unsigned long desc;
> +	struct list_head list;
> +};
> +
> +struct sgx_epc_bank {
> +	unsigned long pa;
> +	void *va;
> +	unsigned long size;

Please add units.  size could be bytes or pages, or who knows what.  I
can't tell you how many bugs I've tripped over in the past from simple
unit conversions

> +	struct sgx_epc_page *pages_data;
> +	struct sgx_epc_page **pages;
> +	unsigned long free_cnt;
> +	spinlock_t lock;
> +};
>  
>  extern bool sgx_enabled;
>  extern bool sgx_lc_enabled;
> +extern struct sgx_epc_bank sgx_epc_banks[SGX_MAX_EPC_BANKS];
> +
> +/*
> + * enum sgx_epc_page_desc - defines bits and masks for an EPC page's desc

Why are you bothering packing these bits?  This seems a rather
convoluted way to store two integers.

> +static __init int sgx_init_epc_bank(u64 addr, u64 size, unsigned long index,
> +				    struct sgx_epc_bank *bank)
> +{
> +	unsigned long nr_pages = size >> PAGE_SHIFT;
> +	struct sgx_epc_page *pages_data;
> +	unsigned long i;
> +	void *va;
> +
> +	va = ioremap_cache(addr, size);
> +	if (!va)
> +		return -ENOMEM;
> +
> +	pages_data = kcalloc(nr_pages, sizeof(struct sgx_epc_page), GFP_KERNEL);
> +	if (!pages_data)
> +		goto out_iomap;

This looks like you're roughly limited by the page allocator to a bank
size of ~1.4GB which seems kinda small.  Is this really OK?

> +	bank->pages = kcalloc(nr_pages, sizeof(struct sgx_epc_page *),
> +			      GFP_KERNEL);
> +	if (!bank->pages)
> +		goto out_pdata;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		bank->pages[i] = &pages_data[i];
> +		bank->pages[i]->desc = (addr + (i << PAGE_SHIFT)) | index;
> +	}
> +
> +	bank->pa = addr;
> +	bank->size = size;
> +	bank->va = va;
> +	bank->free_cnt = nr_pages;
> +	bank->pages_data = pages_data;
> +	spin_lock_init(&bank->lock);
> +	return 0;
> +out_pdata:
> +	kfree(pages_data);
> +out_iomap:
> +	iounmap(va);
> +	return -ENOMEM;
> +}
> +
> +static __init void sgx_page_cache_teardown(void)
> +{
> +	struct sgx_epc_bank *bank;
> +	int i;
> +
> +	for (i = 0; i < sgx_nr_epc_banks; i++) {
> +		bank = &sgx_epc_banks[i];
> +		iounmap((void *)bank->va);
> +		kfree(bank->pages);
> +		kfree(bank->pages_data);
> +	}
> +}
> +
> +static inline u64 sgx_combine_bank_regs(u64 low, u64 high)
> +{
> +	return (low & 0xFFFFF000) + ((high & 0xFFFFF) << 32);
> +}

-ENOCOMMENT for a rather weird looking calculation

> +static __init int sgx_page_cache_init(void)
> +{
> +	u32 eax, ebx, ecx, edx;
> +	u64 pa, size;
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i < SGX_MAX_EPC_BANKS; i++) {
> +		cpuid_count(SGX_CPUID, 2 + i, &eax, &ebx, &ecx, &edx);
> +		if (!(eax & 0xF))
> +			break;

So, we have random data coming out of a random CPUID leaf being called
'eax' and then being tested against a random hard-coded mask.  This
seems rather unfortunate for someone trying to understand the code.  Can
we do better?

> +		pa = sgx_combine_bank_regs(eax, ebx);
> +		size = sgx_combine_bank_regs(ecx, edx);
> +		pr_info("EPC bank 0x%llx-0x%llx\n", pa, pa + size - 1);
> +		ret = sgx_init_epc_bank(pa, size, i, &sgx_epc_banks[i]);
> +		if (ret) {
> +			sgx_page_cache_teardown();
> +			return ret;
> +		}

So if one bank fails, we tear down all banks, yet leave sgx_nr_epc_banks
incremented?  That sounds troublesome.

> +		sgx_nr_epc_banks++;
> +	}
> +
> +	if (!sgx_nr_epc_banks) {
> +		pr_err("There are zero EPC banks.\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}

Does this support hot-addition of a bank?  If not, why not?
