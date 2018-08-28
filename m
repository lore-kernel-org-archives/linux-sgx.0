Received: from mx2.suse.de ([195.135.220.15]:40344 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP        id
 S1727124AbeH1OMQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 28
 Aug 2018 10:12:16 -0400
Date: Tue, 28 Aug 2018 12:21:40 +0200
From: Borislav Petkov <bp@suse.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim
 =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Woodhouse <dwmw@amazon.co.uk>, Alexei Starovoitov <ast@kernel.org>,
	Andi Kleen <ak@linux.intel.com>, Konrad Rzeszutek Wilk
	<konrad.wilk@oracle.com>, Ricardo Neri
	<ricardo.neri-calderon@linux.intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>,
	"open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" <kvm@vger.kernel.org>
Subject: Re: [PATCH v13 03/13] x86/cpufeatures: Add Intel-defined SGX leaf
 CPUID_12_EAX
Message-ID: <20180828102140.GA31102@nazgul.tnic>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-4-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20180827185507.17087-4-jarkko.sakkinen@linux.intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Mon, Aug 27, 2018 at 09:53:24PM +0300, Jarkko Sakkinen wrote:
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 7bb647f57d42..4af60a0fdb20 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -13,7 +13,7 @@
>  /*
>   * Defines x86 CPU feature bits
>   */
> -#define NCAPINTS			19	   /* N 32-bit words worth of info */
> +#define NCAPINTS			20	   /* N 32-bit words worth of info */
>  #define NBUGINTS			1	   /* N 32-bit bug flags */
>  
>  /*
> @@ -349,6 +349,12 @@
>  #define X86_FEATURE_ARCH_CAPABILITIES	(18*32+29) /* IA32_ARCH_CAPABILITIES MSR (Intel) */
>  #define X86_FEATURE_SPEC_CTRL_SSBD	(18*32+31) /* "" Speculative Store Bypass Disable */
>  
> +/* Intel SGX CPU features, CPUID level 0x000000012:0 (EAX), word 19 */
> +#define X86_FEATURE_SGX1		(19*32+ 0) /* SGX1 leaf functions */
> +#define X86_FEATURE_SGX2		(19*32+ 1) /* SGX2 leaf functions */
> +#define X86_FEATURE_SGX_ENCLV		(19*32+ 5) /* SGX ENCLV instruction, leafs E[INC|DEC]VIRTCHILD, ESETCONTEXT */
> +#define X86_FEATURE_SGX_ENCLS_C		(19*32+ 6) /* SGX ENCLS leafs ERDINFO, ETRACK, ELDBC and ELDUC */

No need to add a whole new ->x86_capability member for 4 bits - just add
those bits to leaf 8 where the artificial virtualization flags are -
there's some room there.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
--
