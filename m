Received: from mail.skyhub.de ([5.9.137.197]:39092 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726664AbeIYW5M (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 25
 Sep 2018 18:57:12 -0400
Date: Tue, 25 Sep 2018 18:48:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, David Woodhouse
	<dwmw@amazon.co.uk>, David Wang <davidwang@zhaoxin.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, "Levin, Alexander (Sasha Levin)"
	<alexander.levin@verizon.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 04/19] x86/cpufeatures: Add SGX feature bits
Message-ID: <20180925164854.GF23986@zn.tnic>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-5-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20180925130845.9962-5-jarkko.sakkinen@linux.intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Tue, Sep 25, 2018 at 04:06:41PM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add SGX feature bits as part of the Linux defined leaf 8, which
> currently contains virtualization flags.  There are currently four
> documented SGX feature bits, with more expected in the not-too-distant
> future.

...

> +static void detect_sgx(struct cpuinfo_x86 *c)
> +{
> +#define _X86_FEATURE_SGX1		BIT(0)
> +#define _X86_FEATURE_SGX2		BIT(1)
> +#define _X86_FEATURE_SGX_ENCLV		BIT(5)
> +#define _X86_FEATURE_SGX_ENCLS_C	BIT(6)
> +
> +	unsigned int eax;
> +
> +	clear_cpu_cap(c, X86_FEATURE_SGX1);
> +	clear_cpu_cap(c, X86_FEATURE_SGX2);
> +	clear_cpu_cap(c, X86_FEATURE_SGX_ENCLV);
> +	clear_cpu_cap(c, X86_FEATURE_SGX_ENCLS_C);
> +
> +	if (c->cpuid_level < SGX_CPUID) {
> +		pr_err_once("x86/sgx: cannot enumerate CPUID leaf (0x%x)\n",
> +			    SGX_CPUID);
> +		clear_cpu_cap(c, X86_FEATURE_SGX);
> +		return;
> +	}
> +
> +	eax = cpuid_eax(SGX_CPUID);
> +
> +	if (eax & _X86_FEATURE_SGX1)
> +		set_cpu_cap(c, X86_FEATURE_SGX1);
> +
> +	if (eax & _X86_FEATURE_SGX2)
> +		set_cpu_cap(c, X86_FEATURE_SGX2);
> +
> +	if (eax & _X86_FEATURE_SGX_ENCLV)
> +		set_cpu_cap(c, X86_FEATURE_SGX_ENCLV);
> +
> +	if (eax & _X86_FEATURE_SGX_ENCLS_C)
> +		set_cpu_cap(c, X86_FEATURE_SGX_ENCLS_C);


Look at arch/x86/kernel/cpu/scattered.c for how to do this properly.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
