Date: Tue, 3 Jul 2018 21:46:43 +0200
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 07/13] x86/sgx: data structures for tracking available
 EPC pages
In-Reply-To: <20180703182118.15024-8-jarkko.sakkinen@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1807032110460.1816@nanos.tec.linutronix.de>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com> <20180703182118.15024-8-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="US-ASCII"
Return-Path: tglx@linutronix.de
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:

> SGX has a set of data structures to maintain information about the enclaves
> and their security properties. BIOS reserves a fixed size region of
> physical memory for these structures by setting Processor Reserved Memory
> Range Registers (PRMRR). This memory area is called Enclave Page Cache
> (EPC).
> 
> This commit adds a database of EPC banks for kernel to easily access the

Add a ....

> available EPC pages. On UMA architectures there is a singe bank of EPC

singe? Spell checkers exist for a reason.

> pages. On NUMA architectures there is an EPC bank for each node.

> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 2130e639ab49..77b2294fcfb0 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -4,9 +4,39 @@
>  #ifndef _ASM_X86_SGX_H
>  #define _ASM_X86_SGX_H
>  
> +#include <asm/sgx_arch.h>
> +#include <asm/asm.h>

asm includes go below.

> +#include <linux/bitops.h>
> +#include <linux/err.h>
> +#include <linux/rwsem.h>
>  #include <linux/types.h>
>  
> +#define SGX_MAX_EPC_BANKS 8
> +
> +#define SGX_EPC_BANK(epc_page) \
> +	(&sgx_epc_banks[(unsigned long)(epc_page->desc) & ~PAGE_MASK])
> +#define SGX_EPC_PFN(epc_page) PFN_DOWN((unsigned long)(epc_page->desc))
> +#define SGX_EPC_ADDR(epc_page) ((unsigned long)(epc_page->desc) & PAGE_MASK)

And these need to be macros because MACROS_ARE_SO_PROMINENT, while inline
functions are so boring and type safe.

> +static atomic_t sgx_nr_free_pages = ATOMIC_INIT(0);
> +static struct sgx_epc_bank sgx_epc_banks[SGX_MAX_EPC_BANKS];
> +static int sgx_nr_epc_banks;
> +
> +/**
> + * sgx_get_page - pin an EPC page

Description starts with an uppercase letter.

> + * @page:	an EPC page

That's not an EPC page. It's a pointer to an EPC page. Please make these
comments useful and do not add them just that they exist.

> + *
> + * Return: a pointer to the pinned EPC page
> + */
> +void *sgx_get_page(struct sgx_epc_page *page)
> +{
> +	struct sgx_epc_bank *bank = SGX_EPC_BANK(page);
> +
> +	if (IS_ENABLED(CONFIG_X86_64))

And this is needed because the SGX config switch has:

       depends on X86_64 && CPU_SUP_INTEL

So what is this for and why do you need the 32bit implementation at all?

> +		return (void *)(bank->va + SGX_EPC_ADDR(page) - bank->pa);
> +
> +	return kmap_atomic_pfn(SGX_EPC_PFN(page));
> +}
> +EXPORT_SYMBOL(sgx_get_page);
> +
> +/**
> + * sgx_put_page - unpin an EPC page
> + * @ptr:	a pointer to the pinned EPC page
> + */
> +void sgx_put_page(void *ptr)
> +{
> +	if (IS_ENABLED(CONFIG_X86_64))
> +		return;

Ditto

>
> +	kunmap_atomic(ptr);
> +}
> +EXPORT_SYMBOL(sgx_put_page);
> +
> +static __init int sgx_init_epc_bank(unsigned long addr, unsigned long size,
> +				    unsigned long index,
> +				    struct sgx_epc_bank *bank)
> +{
> +	unsigned long nr_pages = size >> PAGE_SHIFT;
> +	unsigned long i;
> +	void *va;
> +
> +	if (IS_ENABLED(CONFIG_X86_64)) {

And more.

> +		va = ioremap_cache(addr, size);
> +		if (!va)
> +			return -ENOMEM;
> +	}
> +
> +	bank->pages_data = kzalloc(nr_pages * sizeof(struct sgx_epc_page),
> +				   GFP_KERNEL);
> +	if (!bank->pages_data) {
> +		if (IS_ENABLED(CONFIG_X86_64))
> +			iounmap(va);
> +
> +		return -ENOMEM;
> +	}

  	if (!bank->pages_data)
		goto out_iomap;

> +
> +	bank->pages = kzalloc(nr_pages * sizeof(struct sgx_epc_page *),
> +			      GFP_KERNEL);
> +	if (!bank->pages) {
> +		if (IS_ENABLED(CONFIG_X86_64))
> +			iounmap(va);
> +		kfree(bank->pages_data);
> +		bank->pages_data = NULL;
> +		return -ENOMEM;
> +	}

  	if (!bank->pages)
		goto out_pdata;

> +	for (i = 0; i < nr_pages; i++) {
> +		bank->pages[i] = &bank->pages_data[i];
> +		bank->pages[i]->desc = (addr + (i << PAGE_SHIFT)) | index;
> +	}
> +
> +	bank->pa = addr;
> +	bank->size = size;
> +	if (IS_ENABLED(CONFIG_X86_64))
> +		bank->va = (unsigned long)va;

Why is bank->va unsigned long and not a void *? That's spare the type casts.

> +
> +	atomic_set(&bank->free_cnt, nr_pages);
> +	init_rwsem(&bank->lock);
> +	atomic_add(nr_pages, &sgx_nr_free_pages);
> +	return 0;

out_iomap:
	iounmap(va);
out_pdata:
	kfree(bank->pages_data);
	bank->pages_data = NULL;
	return -ENOMEM;


> +static __init int sgx_page_cache_init(void)
> +{
> +	unsigned long size;
> +	unsigned int eax;
> +	unsigned int ebx;
> +	unsigned int ecx;
> +	unsigned int edx;
> +	unsigned long pa;
> +	int i;
> +	int ret;

Please aggregate the declarations of the same type. No point in wasting all
the screen space. And please use 'u32' for ea-dx

> +
> +	for (i = 0; i < SGX_MAX_EPC_BANKS; i++) {
> +		cpuid_count(SGX_CPUID, i + SGX_CPUID_EPC_BANKS, &eax, &ebx,
> +			    &ecx, &edx);
> +		if (!(eax & 0xf))
> +			break;
> +
> +		pa = ((u64)(ebx & 0xfffff) << 32) + (u64)(eax & 0xfffff000);
> +		size = ((u64)(edx & 0xfffff) << 32) + (u64)(ecx & 0xfffff000);

These magic constants should be 'U', using uppercase 'F' and defines. Plus
this wants a comment how pa and size are cobbled together from the cpuid
regs.

> +
> +		pr_info("EPC bank 0x%lx-0x%lx\n", pa, pa + size);

	size - 1 because the bank does not reach into the next page.

> +		ret = sgx_init_epc_bank(pa, size, i, &sgx_epc_banks[i]);
> +		if (ret) {
> +			sgx_page_cache_teardown();
> +			return ret;
> +		}
> +
> +		sgx_nr_epc_banks++;
> +	}
> +
> +	return 0;

This returns success even when the number of detected banks is zero.

> + }

This whole thing can be written readable.

{
	int i, cnt = SGX_CPUID_EPC_BANKS;

	for (i = 0; i < SGX_MAX_EPC_BANKS; i++, cnt++) {
	     	u32 eax, ebx, ecx, edx;
		unsigned long pa, size;
		int ret;

		cpuid_count(SGX_CPUID, cnt, &eax, &ebx, &ecx, &edx);
		if (!(eax & 0xF))
			break;

		pa = combine_regs(ebx, eax);
		size = combine_regs(edx, ecx);

		pr_info("EPC bank 0x%lx-0x%lx\n", pa, pa + size);

		ret = sgx_init_epc_bank(pa, size, i, &sgx_epc_banks[i]);
		if (ret) {
			sgx_page_cache_teardown();
			return ret;
		}
		sgx_nr_epc_banks++;
	}

	return sgx_nr_epc_banks ? : -ENODEV;
}

You get the idea...

Thanks,

	tglx
