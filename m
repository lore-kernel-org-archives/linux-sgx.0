References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com> <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 4 Sep 2018 19:05:09 +0300
Message-ID: <CAHp75VfKdb6fj6EqghEuQazVqGUNJ=FLk+ka+5PyX795-1T-MA@mail.gmail.com>
Subject: Re: [PATCH v13 10/13] x86/sgx: Add sgx_einit() for initializing enclaves
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
Return-Path: andy.shevchenko@gmail.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Aug 27, 2018 at 9:58 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Add a function to perform ENCLS(EINIT), which initializes an enclave,
> which can be used by a driver for running enclaves and VMMs.
>
> Writing the LE hash MSRs is extraordinarily expensive, e.g. 3-4x slower
> than normal MSRs, so we use a per-cpu cache to track the last known value
> of the MSRs to avoid unnecessarily writing the MSRs with the current value.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

> +int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
> +             struct sgx_epc_page *secs_page, u64 lepubkeyhash[4]);

This [4] doesn't make any sense in a C when used in function call
parameter list.

> +/* The cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs for each
> + * CPU. The entries are initialized when they are first used by sgx_einit().
> + */
> +struct sgx_lepubkeyhash {
> +       u64 msrs[4];

4 is MAGIC.

> +       u64 pm_cnt;
> +};

> +int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
> +             struct sgx_epc_page *secs_page, u64 lepubkeyhash[4])

Same two comments about [4].

> +{

> +       cache = per_cpu(sgx_lepubkeyhash_cache, smp_processor_id());

> +       if (!cache) {

How often it's being expected to happen?

> +               cache = kzalloc(sizeof(struct sgx_lepubkeyhash), GFP_KERNEL);
> +               if (!cache)
> +                       return -ENOMEM;
> +       }

> +       for (i = 0; i < 4; i++) {

Same MAGIC?

> +       }

> +}

-- 
With Best Regards,
Andy Shevchenko
