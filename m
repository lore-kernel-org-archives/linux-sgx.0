Received: from mga01.intel.com ([192.55.52.88]:60233 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1727412AbeH1OVs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 28
 Aug 2018 10:21:48 -0400
Date: Tue, 28 Aug 2018 13:30:40 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Serge Ayoun
	<serge.ayoun@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 07/13] x86/sgx: Add data structures for tracking the
 EPC pages
Message-ID: <20180828103040.GA21326@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-8-jarkko.sakkinen@linux.intel.com>
 <4666cae8-c711-8dd5-cbce-3d97cc19a9e5@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4666cae8-c711-8dd5-cbce-3d97cc19a9e5@intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Mon, Aug 27, 2018 at 02:07:53PM -0700, Dave Hansen wrote:
> On 08/27/2018 11:53 AM, Jarkko Sakkinen wrote:
> > Add data structures to track Enclave Page Cache (EPC) pages.  EPC is
> > divided into multiple banks (1-N) of which addresses and sizes can be
> > enumerated with CPUID by the OS.
> > 
> > On NUMA systems a node can have at most bank. A bank can be at most part of
> > two nodes. SGX supports both nodes with a single memory controller and also
> > sub-cluster nodes with severals memory controllers on a single die.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
> > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/include/asm/sgx.h      |  60 ++++++++++++++++++
> >  arch/x86/kernel/cpu/intel_sgx.c | 106 +++++++++++++++++++++++++++++++-
> >  2 files changed, 164 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> > index 2130e639ab49..17b7b3aa66bf 100644
> > --- a/arch/x86/include/asm/sgx.h
> > +++ b/arch/x86/include/asm/sgx.h
> > @@ -4,9 +4,69 @@
> >  #ifndef _ASM_X86_SGX_H
> >  #define _ASM_X86_SGX_H
> >  
> > +#include <linux/bitops.h>
> > +#include <linux/err.h>
> > +#include <linux/rwsem.h>
> >  #include <linux/types.h>
> > +#include <asm/sgx_arch.h>
> > +#include <asm/asm.h>
> > +
> > +#define SGX_MAX_EPC_BANKS 8
> 
> This is _still_ missing a meaningful description of what a bank is and
> whether it is a hardware or software structure.
> 
> It would also help us to determine whether your bit packing below is
> really required.

I think a better name would be EPC section as this is what the SDM uses
in the Table 3-8 when describing subleaves of EAX=0x12 (SGX specific
leaf) starting from ECX=0x02. It is a software structure that contains
the information given by these subleaves.

These sections constitute the physical pages that are part of the EPC.

> > +struct sgx_epc_page {
> > +	unsigned long desc;
> > +	struct list_head list;
> > +};
> > +
> > +struct sgx_epc_bank {
> > +	unsigned long pa;
> > +	void *va;
> > +	unsigned long size;
> 
> Please add units.  size could be bytes or pages, or who knows what.  I
> can't tell you how many bugs I've tripped over in the past from simple
> unit conversions

Will do.

> > +	struct sgx_epc_page *pages_data;
> > +	struct sgx_epc_page **pages;
> > +	unsigned long free_cnt;
> > +	spinlock_t lock;
> > +};
> >  
> >  extern bool sgx_enabled;
> >  extern bool sgx_lc_enabled;
> > +extern struct sgx_epc_bank sgx_epc_banks[SGX_MAX_EPC_BANKS];
> > +
> > +/*
> > + * enum sgx_epc_page_desc - defines bits and masks for an EPC page's desc
> 
> Why are you bothering packing these bits?  This seems a rather
> convoluted way to store two integers.

To keep struct sgx_epc_page 64 bytes.

> > +static __init int sgx_init_epc_bank(u64 addr, u64 size, unsigned long index,
> > +				    struct sgx_epc_bank *bank)
> > +{
> > +	unsigned long nr_pages = size >> PAGE_SHIFT;
> > +	struct sgx_epc_page *pages_data;
> > +	unsigned long i;
> > +	void *va;
> > +
> > +	va = ioremap_cache(addr, size);
> > +	if (!va)
> > +		return -ENOMEM;
> > +
> > +	pages_data = kcalloc(nr_pages, sizeof(struct sgx_epc_page), GFP_KERNEL);
> > +	if (!pages_data)
> > +		goto out_iomap;
> 
> This looks like you're roughly limited by the page allocator to a bank
> size of ~1.4GB which seems kinda small.  Is this really OK?

Where does this limitation come from?

> 
> > +	bank->pages = kcalloc(nr_pages, sizeof(struct sgx_epc_page *),
> > +			      GFP_KERNEL);
> > +	if (!bank->pages)
> > +		goto out_pdata;
> > +
> > +	for (i = 0; i < nr_pages; i++) {
> > +		bank->pages[i] = &pages_data[i];
> > +		bank->pages[i]->desc = (addr + (i << PAGE_SHIFT)) | index;
> > +	}
> > +
> > +	bank->pa = addr;
> > +	bank->size = size;
> > +	bank->va = va;
> > +	bank->free_cnt = nr_pages;
> > +	bank->pages_data = pages_data;
> > +	spin_lock_init(&bank->lock);
> > +	return 0;
> > +out_pdata:
> > +	kfree(pages_data);
> > +out_iomap:
> > +	iounmap(va);
> > +	return -ENOMEM;
> > +}
> > +
> > +static __init void sgx_page_cache_teardown(void)
> > +{
> > +	struct sgx_epc_bank *bank;
> > +	int i;
> > +
> > +	for (i = 0; i < sgx_nr_epc_banks; i++) {
> > +		bank = &sgx_epc_banks[i];
> > +		iounmap((void *)bank->va);
> > +		kfree(bank->pages);
> > +		kfree(bank->pages_data);
> > +	}
> > +}
> > +
> > +static inline u64 sgx_combine_bank_regs(u64 low, u64 high)
> > +{
> > +	return (low & 0xFFFFF000) + ((high & 0xFFFFF) << 32);
> > +}
> 
> -ENOCOMMENT for a rather weird looking calculation

Yea, totally agreed... I'll think about how to make this cleaner. Maybe
it would be anyway better idea to open code this to the call sites and
explain the calculation in a comment.

> > +static __init int sgx_page_cache_init(void)
> > +{
> > +	u32 eax, ebx, ecx, edx;
> > +	u64 pa, size;
> > +	int ret;
> > +	int i;
> > +
> > +	for (i = 0; i < SGX_MAX_EPC_BANKS; i++) {
> > +		cpuid_count(SGX_CPUID, 2 + i, &eax, &ebx, &ecx, &edx);
> > +		if (!(eax & 0xF))
> > +			break;
> 
> So, we have random data coming out of a random CPUID leaf being called
> 'eax' and then being tested against a random hard-coded mask.  This
> seems rather unfortunate for someone trying to understand the code.  Can
> we do better?

Should probably do something along the lines:

#define SGX_CPUID_SECTION(i) (2 + (i))

enum sgx_section {
	SGX_CPUID_SECTION_INVALID	= 0x00,
	SGX_CPUID_SECTION_VALID		= 0x1B,
	SGX_CPUID_SECTION_MASK		= 0xFF,
};


for (i = 0; i < SGX_MAX_EPC_BANKS; i++) {
	cpuid_count(SGX_CPUID, SGX_CPUID_SECTION(i), &eax, &ebx, &ecx, &edx);

	section = eax & SGX_SECTION_MASK;
	if (section != SGX_CPUID_SECTION_VALID) {
		if (section != SGX_CPUID_SECTION_INVALID) {
			/* Maybe a warning here for any other value as
			 * they are reserved according to the SDM?
			 */
		}

		continue;
	}

	/* ... */
}

> > +		pa = sgx_combine_bank_regs(eax, ebx);
> > +		size = sgx_combine_bank_regs(ecx, edx);
> > +		pr_info("EPC bank 0x%llx-0x%llx\n", pa, pa + size - 1);
> > +		ret = sgx_init_epc_bank(pa, size, i, &sgx_epc_banks[i]);
> > +		if (ret) {
> > +			sgx_page_cache_teardown();
> > +			return ret;
> > +		}
> 
> So if one bank fails, we tear down all banks, yet leave sgx_nr_epc_banks
> incremented?  That sounds troublesome.

It is. Thanks for spotting that out.

> > +		sgx_nr_epc_banks++;
> > +	}
> > +
> > +	if (!sgx_nr_epc_banks) {
> > +		pr_err("There are zero EPC banks.\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> Does this support hot-addition of a bank?  If not, why not?

This is the DSDT for this data from my GLK NUC:

    Scope (_SB)
    {
        Device (EPC)
        {
            Name (_HID, EisaId ("INT0E0C"))  // _HID: Hardware ID
            Name (_STR, Unicode ("Enclave Page Cache 1.0"))  // _STR: Description String
            Name (_MLS, Package (0x01)  // _MLS: Multiple Language String
            {
                Package (0x02)
                {
                    "en", 
                    Unicode ("Enclave Page Cache 1.0")
                }
            })
            Name (RBUF, ResourceTemplate ()
            {
                QWordMemory (ResourceConsumer, PosDecode, MinNotFixed, MaxNotFixed, NonCacheable, ReadWrite,
                    0x0000000000000000, // Granularity
                    0x0000000000000000, // Range Minimum
                    0x0000000000000000, // Range Maximum
                    0x0000000000000000, // Translation Offset
                    0x0000000000000001, // Length
                    ,, _Y18, AddressRangeMemory, TypeStatic)
            })
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                CreateQWordField (RBUF, \_SB.EPC._Y18._MIN, EMIN)  // _MIN: Minimum Base Address
                CreateQWordField (RBUF, \_SB.EPC._Y18._MAX, EMAX)  // _MAX: Maximum Base Address
                CreateQWordField (RBUF, \_SB.EPC._Y18._LEN, ELEN)  // _LEN: Length
                EMIN = EMNA /* External reference */
                ELEN = ELNG /* External reference */
                EMAX = ((EMNA + ELNG) - One)
                Return (RBUF) /* \_SB_.EPC_.RBUF */
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((EPCS != Zero))
                {
                    Return (0x0F)
                }

                Return (Zero)
            }
        }
    }

I'm not aware that we would have an ACPI specification for SGX so this
is all I have at the moment (does not show any ACPI event for
hotplugging).

/Jarkko
