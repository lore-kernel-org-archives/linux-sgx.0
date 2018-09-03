References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com> <20180827185507.17087-5-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180827185507.17087-5-jarkko.sakkinen@linux.intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 3 Sep 2018 16:16:42 +0300
Message-ID: <CAHp75VchsQXGRrcrcB06w68PzUZb5NJLo2B_ZKf6ZLqyBbvWhA@mail.gmail.com>
Subject: Re: [PATCH v13 04/13] x86/sgx: Architectural structures
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>, Dave Hansen
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Aug 27, 2018 at 9:57 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> Add arch/x86/include/asm/sgx_arch.h, which contains definitions for the
> architectural data structures used by the CPU to implement the SGX.

> +/**
> + * enum sgx_encls_leaves - ENCLS leaf functions
> + * %ECREATE:   Create an enclave.
> + * %EADD:      Add a page to an enclave.
> + * %EINIT:     Launch an enclave.
> + * %EREMOVE:   Remove a page from an enclave.
> + * %EDBGRD:    Read a word from an enclve (peek).
> + * %EDBGWR:    Write a word to an enclave (poke).
> + * %EEXTEND:   Measure 256 bytes of an added enclave page.
> + * %ELDB:      Load a swapped page in blocked state.
> + * %ELDU:      Load a swapped page in unblocked state.
> + * %EBLOCK:    Change page state to blocked i.e. entering hardware threads
> + *             cannot access it and create new TLB entries.
> + * %EPA:       Create a Version Array (VA) page used to store isvsvn number
> + *             for a swapped EPC page.
> + * %EWB:       Swap an enclave page to the regular memory. Checks that all
> + *             threads have exited that were in the previous shoot-down
> + *             sequence.
> + * %ETRACK:    Start a new shoot down sequence. Used to together with EBLOCK
> + *             to make sure that a page is safe to swap.
> + */
> +enum sgx_encls_leaves {
> +       ECREATE = 0x0,
> +       EADD    = 0x1,
> +       EINIT   = 0x2,
> +       EREMOVE = 0x3,
> +       EDGBRD  = 0x4,
> +       EDGBWR  = 0x5,
> +       EEXTEND = 0x6,
> +       ELDB    = 0x7,
> +       ELDU    = 0x8,
> +       EBLOCK  = 0x9,
> +       EPA     = 0xA,
> +       EWB     = 0xB,
> +       ETRACK  = 0xC,
> +       EAUG    = 0xD,
> +       EMODPR  = 0xE,
> +       EMODT   = 0xF,
> +};

Hmm... This E prefix confuses me with (system wide) error codes. Has
it been discussed before? If so, can you point on the conclusion why
the current format is good?

> +enum sgx_miscselect {
> +       SGX_MISC_EXINFO         = 0x01,
> +};
> +
> +#define SGX_MISC_RESERVED_MASK 0xFFFFFFFFFFFFFFFEULL

Any idea why we are not using BIT_ULL() / BIT() and GENMASK_ULL() /
GENMASK() in the code?

> +enum sgx_attribute {
> +       SGX_ATTR_DEBUG          = 0x02,
> +       SGX_ATTR_MODE64BIT      = 0x04,
> +       SGX_ATTR_PROVISIONKEY   = 0x10,
> +       SGX_ATTR_EINITTOKENKEY  = 0x20,
> +};
> +
> +#define SGX_ATTR_RESERVED_MASK 0xFFFFFFFFFFFFFFC9ULL

Some times listing explicitly not-reserved bits might be better and
figuring out reserved mask is a simple ~ operation.

> +enum sgx_tcs_flags {
> +       SGX_TCS_DBGOPTIN        = 0x01,
> +};
> +
> +#define SGX_TCS_RESERVED_MASK 0xFFFFFFFFFFFFFFFEULL

> +#define SGX_SECINFO_PERMISSION_MASK    0x0000000000000007ULL
> +#define SGX_SECINFO_PAGE_TYPE_MASK     0x000000000000FF00ULL
> +#define SGX_SECINFO_RESERVED_MASK      0xFFFFFFFFFFFF00F8ULL

So, something like

MASK1 GENMASK_ULL
MASK2 GENMASK_ULL
MASK3 ~(MASK1  | MASK2)

?

-- 
With Best Regards,
Andy Shevchenko
