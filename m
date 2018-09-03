References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com> <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 3 Sep 2018 15:53:24 +0200
Message-ID: <CAG48ez2_EgP_-FcLV0g=EU2KuKEwFAmZufjGevMX4j--fJ_0+w@mail.gmail.com>
Subject: Re: [PATCH v13 10/13] x86/sgx: Add sgx_einit() for initializing enclaves
To: <jarkko.sakkinen@linux.intel.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin"
	<hpa@zytor.com>, <suresh.b.siddha@intel.com>, <serge.ayoun@intel.com>,
	"kernel list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Return-Path: jannh@google.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Sep 3, 2018 at 3:33 PM Jarkko Sakkinen
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
[...]
> +/**
> + * sgx_einit - initialize an enclave
> + * @sigstruct:         a pointer to the SIGSTRUCT
> + * @token:             a pointer to the EINITTOKEN
> + * @secs_page:         a pointer to the SECS EPC page
> + * @lepubkeyhash:      the desired value for IA32_SGXLEPUBKEYHASHx MSRs
> + *
> + * Try to perform EINIT operation. If the MSRs are writable, they are updated
> + * according to @lepubkeyhash.
> + *
> + * Return:
> + *   0 on success,
> + *   -errno on failure
> + *   SGX error code if EINIT fails
> + */
> +int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
> +             struct sgx_epc_page *secs_page, u64 lepubkeyhash[4])
> +{
> +       struct sgx_lepubkeyhash __percpu *cache;
> +       bool cache_valid;
> +       int i, ret;
> +
> +       if (!sgx_lc_enabled)
> +               return __einit(sigstruct, token, sgx_epc_addr(secs_page));
> +
> +       cache = per_cpu(sgx_lepubkeyhash_cache, smp_processor_id());

At this point, preemption must be off, because smp_processor_id() is
called; I don't think it is off here? If you have hardware/emulation
on which you can test this, you may want to test your patches with
DEBUG_PREEMPT enabled.

> +       if (!cache) {
> +               cache = kzalloc(sizeof(struct sgx_lepubkeyhash), GFP_KERNEL);

But then here you do a GFP_KERNEL allocation, which can sleep.

Also: After "cache" has been allocated in this branch, when do you
store the reference to it? As far as I can tell, you never write to
sgx_lepubkeyhash_cache, and the allocation just leaks.

> +               if (!cache)
> +                       return -ENOMEM;
> +       }
> +
> +       cache_valid = cache->pm_cnt == sgx_pm_cnt;

The cache should probably not be treated as valid if it has just been
created and only contains zeroes, right?

> +       cache->pm_cnt = sgx_pm_cnt;

Can sgx_pm_cnt be modified concurrently? If so, please use at least
READ_ONCE() to document that and prevent the compiler from doing weird
stuff.

> +       preempt_disable();

And here you turn off preemption, but it should already have been off?

> +       for (i = 0; i < 4; i++) {
> +               if (cache_valid && lepubkeyhash[i] == cache->msrs[i])
> +                       continue;
> +
> +               wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
> +               cache->msrs[i] = lepubkeyhash[i];
> +       }
> +       ret = __einit(sigstruct, token, sgx_epc_addr(secs_page));
> +       preempt_enable();
> +       return ret;
> +}
> +EXPORT_SYMBOL(sgx_einit);
> +
