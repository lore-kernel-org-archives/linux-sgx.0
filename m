Received: from out02.mta.xmission.com ([166.70.13.232]:50820 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbeI1CDp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 27 Sep 2018 22:03:45 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>,
	"Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, "open list:X86 MM" <linux-kernel@vger.kernel.org>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
        <20180925130845.9962-10-jarkko.sakkinen@linux.intel.com>
Date: Thu, 27 Sep 2018 21:43:15 +0200
In-Reply-To: <20180925130845.9962-10-jarkko.sakkinen@linux.intel.com> (Jarkko
        Sakkinen's message of "Tue, 25 Sep 2018 16:06:46 +0300")
Message-ID: <87zhw2ohf0.fsf@xmission.com>
Content-Type: text/plain
Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs w/ PF_SGX
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> writes:

> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Signal SIGSEGV(SEGV_SGXERR) for all faults with PF_SGX set in the
> error code.  The PF_SGX bit is set if and only if the #PF is detected
> by the Enclave Page Cache Map (EPCM), which is consulted only after
> an access walks the kernel's page tables, i.e.:
>
>   a. the access was allowed by the kernel
>   b. the kernel's tables have become less restrictive than the EPCM
>   c. the kernel cannot fixup the cause of the fault
>
> Noteably, (b) implies that either the kernel has botched the EPC
> mappings or the EPCM has been invalidated due to a power event.  In
> either case, userspace needs to be alerted so that it can take
> appropriate action, e.g. restart the enclave.  This is reinforced
> by (c) as the kernel doesn't really have any other reasonable option,
> e.g. we could kill the task or panic, but neither is warranted.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/mm/fault.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 85d20516b2f3..3fb2b2838d6c 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -960,10 +960,13 @@ static noinline void
>  bad_area_access_error(struct pt_regs *regs, unsigned long error_code,
>  		      unsigned long address, struct vm_area_struct *vma)
>  {
> +	int si_code = SEGV_ACCERR;
> +
>  	if (bad_area_access_from_pkeys(error_code, vma))
> -		__bad_area(regs, error_code, address, vma, SEGV_PKUERR);
> -	else
> -		__bad_area(regs, error_code, address, vma, SEGV_ACCERR);
> +		si_code = SEGV_PKUERR;
> +	else if (unlikely(error_code & X86_PF_SGX))
> +		si_code = SEGV_SGXERR;
> +	__bad_area(regs, error_code, address, vma, si_code);
>  }

This conflicts with a cleanup in this area I have sitting in linux-next.
It isn't in the x86 tree but you can find my siginfo tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git siginfo-next

In my tree bad area no longer takes a vma parameter.

If you are going to make changes to the fault handling code this cycle
please let's figure out how to build it on top of my clean ups.

Thank you,
Eric Biederman
