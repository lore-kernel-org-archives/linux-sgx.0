Date: Tue, 3 Jul 2018 21:09:52 +0200
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Vikas
 Shivappa" <vikas.shivappa@linux.intel.com>, "Rafael J. Wysocki"
	<rafael.j.wysocki@intel.com>, Andi Kleen <ak@linux.intel.com>, "Kirill A.
 Shutemov" <kirill.shutemov@linux.intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "open list:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 06/13] x86/sgx: detect Intel SGX
In-Reply-To: <20180703182118.15024-7-jarkko.sakkinen@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1807032105290.1816@nanos.tec.linutronix.de>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com> <20180703182118.15024-7-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="US-ASCII"
Return-Path: tglx@linutronix.de
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:
> @@ -0,0 +1,54 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-17 Intel Corporation.
> +
> +#include <asm/sgx.h>
> +#include <asm/sgx_pr.h>
> +#include <linux/freezer.h>
> +#include <linux/highmem.h>
> +#include <linux/kthread.h>
> +#include <linux/ratelimit.h>
> +#include <linux/sched/signal.h>
> +#include <linux/slab.h>

The common include ordering is

include linux/....

include asm/...

> +
> +bool sgx_enabled __ro_after_init;
> +EXPORT_SYMBOL(sgx_enabled);


> +bool sgx_lc_enabled __ro_after_init;
> +EXPORT_SYMBOL(sgx_lc_enabled);
> +
> +static __init bool sgx_is_enabled(bool *lc_enabled)
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
> +
> +	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
> +		pr_info("disabled by the firmware\n");
> +		return false;
> +	}
> +
> +	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
> +		pr_info("IA32_SGXLEPUBKEYHASHn MSRs are not writable\n");
> +		return false;
> +	}
> +
> +	*lc_enabled = !!(fc & FEATURE_CONTROL_SGX_LE_WR);
> +	return true;
> +}
> +
> +static __init int sgx_init(void)
> +{
> +	sgx_enabled = sgx_is_enabled(&sgx_lc_enabled);

This is horrible, really. Both variables are global. So what the heck is
wrong with assigning them directly in the function? 

Thanks,

	tglx
