Subject: Re: [PATCH v13 06/13] x86/sgx: Detect Intel SGX
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-7-jarkko.sakkinen@linux.intel.com>
CC: <sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Suresh Siddha
	<suresh.b.siddha@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Serge Ayoun
	<serge.ayoun@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Borislav Petkov <bp@suse.de>, Reinette Chatre <reinette.chatre@intel.com>,
	Andi Kleen <ak@linux.intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <50c199b6-e8eb-9120-0d2a-5e60ac0139b4@intel.com>
Date: Mon, 27 Aug 2018 12:53:59 -0700
In-Reply-To: <20180827185507.17087-7-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

> +config INTEL_SGX_CORE
> +	prompt "Intel SGX core functionality"
> +	def_bool n
> +	depends on X86_64 && CPU_SUP_INTEL
> +	help
> +	Intel Software Guard eXtensions (SGX) is a set of CPU instructions
> +	that allows ring 3 applications to create enclaves, private regions
> +	of memory that are protected, by hardware, from unauthorized access
> +	and/or modification.

This is a bit comma-crazy.  Also, considering some of our recent CVE
fun, I'd probably not claim hardware protection. :)

Maybe:

	Intel Software Guard eXtensions (SGX) CPU feature that allows
	ring 3 applications to create enclaves: private regions
	of memory that are architecturally protected from unauthorized
	access and/or modification.

> +	This option enables kernel recognition of SGX, high-level management
> +	of the Enclave Page Cache (EPC), tracking and writing of SGX Launch
> +	Enclave Hash MSRs, and allows for virtualization of SGX via KVM. By
> +	iteslf, this option does not provide SGX support to userspace.

itself


> diff --git a/arch/x86/include/asm/sgx_pr.h b/arch/x86/include/asm/sgx_pr.h
> new file mode 100644
> index 000000000000..c68578127620
> --- /dev/null
> +++ b/arch/x86/include/asm/sgx_pr.h
> @@ -0,0 +1,13 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-17 Intel Corporation.
> +
> +#ifndef _ASM_X86_SGX_PR_H
> +#define _ASM_X86_SGX_PR_H
> +
> +#include <linux/printk.h>
> +#include <linux/ratelimit.h>
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt) "sgx: " fmt
> +
> +#endif /* _ASM_X86_SGX_PR_H */

I don't think this belongs in a generic header.  Generally, we do the
pr_fmt stuff in .c files, not in headers.  If someone includes this
header directly or indirectly, they'll get a big surprise.

If you *must* have this in a .h file, put it in
arch/x86/kernel/cpu/intel_sgx.h or something and #include "intel_sgx.h"
in all the .c files where you want this.


> +static __init int sgx_init(void)
> +{
> +	unsigned long fc;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SGX))
> +		return false;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SGX1))
> +		return false;
> +
> +	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
> +	if (!(fc & FEATURE_CONTROL_LOCKED)) {
> +		pr_info("IA32_FEATURE_CONTROL MSR is not locked\n");
> +		return false;
> +	}

This is a rather crummy error message.  Doesn't this keep sgx from
initializing?  Would something like this be more informative?

	pr_info("failed init: IA32_FEATURE_CONTROL MSR not locked\n");

> +	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
> +		pr_info("disabled by the firmware\n");
> +		return false;
> +	}
> +
> +	if (!(fc & FEATURE_CONTROL_SGX_LE_WR))
> +		pr_info("IA32_SGXLEPUBKEYHASHn MSRs are not writable\n");

How about something that might help an end user?  Perhaps:

	pr_warn("launch configuration not available\n");

> +	sgx_enabled = true;
> +	sgx_lc_enabled = !!(fc & FEATURE_CONTROL_SGX_LE_WR);
> +	return 0;
> +}
> +
> +arch_initcall(sgx_init);
>
