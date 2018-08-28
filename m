Subject: Re: [PATCH v13 07/13] x86/sgx: Add data structures for tracking the
 EPC pages
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-8-jarkko.sakkinen@linux.intel.com>
 <4666cae8-c711-8dd5-cbce-3d97cc19a9e5@intel.com>
 <20180828103040.GA21326@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Serge Ayoun
	<serge.ayoun@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <68d730bc-898c-973f-9506-648fd8a7c610@intel.com>
Date: Tue, 28 Aug 2018 09:53:11 -0700
In-Reply-To: <20180828103040.GA21326@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

>>>  extern bool sgx_enabled;
>>>  extern bool sgx_lc_enabled;
>>> +extern struct sgx_epc_bank sgx_epc_banks[SGX_MAX_EPC_BANKS];
>>> +
>>> +/*
>>> + * enum sgx_epc_page_desc - defines bits and masks for an EPC page's desc
>>
>> Why are you bothering packing these bits?  This seems a rather
>> convoluted way to store two integers.
> 
> To keep struct sgx_epc_page 64 bytes.

It's a list_head and a ulong now.  That doesn't add up to 64.

If you properly describe the bounds and limits of banks we can possibly
help you find a nice solution.  As it stands, they are totally opaque
and we have no idea what is going on.

>>> +static __init int sgx_init_epc_bank(u64 addr, u64 size, unsigned long index,
>>> +				    struct sgx_epc_bank *bank)
>>> +{
>>> +	unsigned long nr_pages = size >> PAGE_SHIFT;
>>> +	struct sgx_epc_page *pages_data;
>>> +	unsigned long i;
>>> +	void *va;
>>> +
>>> +	va = ioremap_cache(addr, size);
>>> +	if (!va)
>>> +		return -ENOMEM;
>>> +
>>> +	pages_data = kcalloc(nr_pages, sizeof(struct sgx_epc_page), GFP_KERNEL);
>>> +	if (!pages_data)
>>> +		goto out_iomap;
>>
>> This looks like you're roughly limited by the page allocator to a bank
>> size of ~1.4GB which seems kinda small.  Is this really OK?
> 
> Where does this limitation come from?

The page allocator can only do 4MB at a time.  Using your 64 byte
numbers: 4MB/64 = 64k sgx_epc_pages.  64k*PAGE_SIZE = 256MB.  So you can
only handle 256MB banks with this code.

BTW, if you only have 64k worth of pages, you can use a u16 for the index.

>>> +	u32 eax, ebx, ecx, edx;
>>> +	u64 pa, size;
>>> +	int ret;
>>> +	int i;
>>> +
>>> +	for (i = 0; i < SGX_MAX_EPC_BANKS; i++) {
>>> +		cpuid_count(SGX_CPUID, 2 + i, &eax, &ebx, &ecx, &edx);
>>> +		if (!(eax & 0xF))
>>> +			break;
>>
>> So, we have random data coming out of a random CPUID leaf being called
>> 'eax' and then being tested against a random hard-coded mask.  This
>> seems rather unfortunate for someone trying to understand the code.  Can
>> we do better?
> 
> Should probably do something along the lines:
> 
> #define SGX_CPUID_SECTION(i) (2 + (i))
> 
> enum sgx_section {
> 	SGX_CPUID_SECTION_INVALID	= 0x00,
> 	SGX_CPUID_SECTION_VALID		= 0x1B,
> 	SGX_CPUID_SECTION_MASK		= 0xFF,
> };

Plus comments, that would be nice.

>>> +		sgx_nr_epc_banks++;
>>> +	}
>>> +
>>> +	if (!sgx_nr_epc_banks) {
>>> +		pr_err("There are zero EPC banks.\n");
>>> +		return -ENODEV;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>
>> Does this support hot-addition of a bank?  If not, why not?
...
> I'm not aware that we would have an ACPI specification for SGX so this
> is all I have at the moment (does not show any ACPI event for
> hotplugging).

So you're saying the one platform you looked at don't support hotplug.
I was looking for a more broad statement about SGX.
