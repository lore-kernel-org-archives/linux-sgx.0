Content-Type: text/plain; charset="us-ascii"
Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs w/ PF_SGX
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <20180926173516.GA10920@linux.intel.com>
Date: Wed, 26 Sep 2018 11:12:27 -0700
CC: Andy Lutomirski <luto@kernel.org>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, X86 ML <x86@kernel.org>, Platform Driver
	<platform-driver-x86@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, "Ayoun, Serge"
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>,
	<linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>
Message-ID: <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com> <20180925130845.9962-10-jarkko.sakkinen@linux.intel.com> <CALCETrVAhiwv+g5fzVO3ZSHZgcQKbeeG8r3HUcXO9k7Gi94NdQ@mail.gmail.com> <20180926173516.GA10920@linux.intel.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>


> On Sep 26, 2018, at 10:35 AM, Sean Christopherson <sean.j.christopherson@=
intel.com> wrote:
>=20
>> On Tue, Sep 25, 2018 at 03:53:48PM -0700, Andy Lutomirski wrote:
>> Minor nit:
>>=20
>> On Tue, Sep 25, 2018 at 6:12 AM Jarkko Sakkinen
>> <jarkko.sakkinen@linux.intel.com> wrote:
>>>=20
>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>=20
>>=20
>>> by (c) as the kernel doesn't really have any other reasonable option,
>>> e.g. we could kill the task or panic, but neither is warranted.
>>=20
>> Not killing the task is quite nice, but...
>>=20
>>> +       /*
>>> +        * Access is blocked by the Enclave Page Cache Map (EPCM),
>>> +        * i.e. the access is allowed by the PTE but not the EPCM.
>>> +        * This usually happens when the EPCM is yanked out from
>>> +        * under us, e.g. by hardware after a suspend/resume cycle.
>>> +        * In any case, there is nothing that can be done by the
>>> +        * kernel to resolve the fault (short of killing the task).
>>=20
>> Maybe s/killing the task/sending a signal/?
>=20
> My intent was to document that, unlike all other page faults, the
> kernel can't fix the source of the fault even if it were omniscient.
>=20
> How about this?  With formatting changes since it's long-winded...
>=20
>        /*
>         * Access is blocked by the Enclave Page Cache Map (EPCM), i.e. th=
e
>         * access is allowed by the PTE but not the EPCM.  This usually ha=
ppens
>         * when the EPCM is yanked out from under us, e.g. by hardware aft=
er a
>         * suspend/resume cycle.  In any case, software, i.e. the kernel, =
can't
>         * fix the source of the fault as the EPCM can't be directly modif=
ied
>         * by software.  Handle the fault as an access error in order to s=
ignal
>         * userspace, e.g. so that userspace can rebuild their enclave(s),=
 even
>         * though userspace may not have actually violated access permissi=
ons.
>         */
>=20

Looks good to me.=
