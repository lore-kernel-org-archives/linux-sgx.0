References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com> <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 3 Sep 2018 22:02:16 +0300
Message-ID: <CAHp75Vf39J8U3VnmxP+BBYi7rqzidxdD58Yx_fdnLXRro_QBgg@mail.gmail.com>
Subject: Re: [PATCH v13 09/13] x86/sgx: Enclave Page Cache (EPC) memory manager
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>, Dave Hansen
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, <suresh.b.siddha@intel.com>,
	<serge.ayoun@intel.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Aug 27, 2018 at 9:58 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> Add a Enclave Page Cache (EPC) memory manager that can be used to
> allocate and free EPC pages. The swapper thread ksgxswapd reclaims pages
> on the event when the number of free EPC pages goes below
> %SGX_NR_LOW_PAGES up until it reaches %SGX_NR_HIGH_PAGES.
>
> Pages are reclaimed in LRU fashion from a global list. The consumers
> take care of calling EBLOCK (block page from new accesses), ETRACK
> (restart counting the entering hardware threads) and EWB (write page to
> the regular memory) because executing these operations usually (if not
> always) requires to do some subsystem-internal locking operations.

> +                       list_del(&page->list);

Is this page will be completely gone? Otherwise it might be needed to
reinit list head here as well.

> +       WARN(ret < 0, "sgx: cannot free page, reclaim in-progress");
> +       WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);

I'm not sure (though it's easy to check) that you need sgx: prefix
here. WARN() might take pr_fmt() if defined.

-- 
With Best Regards,
Andy Shevchenko
