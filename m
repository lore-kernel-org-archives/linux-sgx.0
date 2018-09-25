References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com> <20180925130845.9962-10-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180925130845.9962-10-jarkko.sakkinen@linux.intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 25 Sep 2018 15:53:48 -0700
Message-ID: <CALCETrVAhiwv+g5fzVO3ZSHZgcQKbeeG8r3HUcXO9k7Gi94NdQ@mail.gmail.com>
Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs w/ PF_SGX
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: X86 ML <x86@kernel.org>, Platform Driver
	<platform-driver-x86@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	"Christopherson, Sean J" <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, "Ayoun, Serge"
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>,
	<linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Andrew Lutomirski <luto@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Return-Path: luto@kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

Minor nit:

On Tue, Sep 25, 2018 at 6:12 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>

> by (c) as the kernel doesn't really have any other reasonable option,
> e.g. we could kill the task or panic, but neither is warranted.

Not killing the task is quite nice, but...

> +       /*
> +        * Access is blocked by the Enclave Page Cache Map (EPCM),
> +        * i.e. the access is allowed by the PTE but not the EPCM.
> +        * This usually happens when the EPCM is yanked out from
> +        * under us, e.g. by hardware after a suspend/resume cycle.
> +        * In any case, there is nothing that can be done by the
> +        * kernel to resolve the fault (short of killing the task).

Maybe s/killing the task/sending a signal/?

--Andy
