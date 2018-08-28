Date: Tue, 28 Aug 2018 10:01:29 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"nhorman@redhat.com" <nhorman@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Christopherson, Sean J"
	<sean.j.christopherson@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>, "Ayoun, Serge"
	<serge.ayoun@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"npmccallum@redhat.com" <npmccallum@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: [PATCH v13 10/13] x86/sgx: Add sgx_einit() for initializing
 enclaves
Message-ID: <20180828070129.GA5301@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com>
 <1535406078.3416.9.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1535406078.3416.9.camel@intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Aug 27, 2018 at 09:41:22PM +0000, Huang, Kai wrote:
> On Mon, 2018-08-27 at 21:53 +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add a function to perform ENCLS(EINIT), which initializes an enclave,
> > which can be used by a driver for running enclaves and VMMs.
> > 
> > Writing the LE hash MSRs is extraordinarily expensive, e.g. 3-4x
> > slower
> > than normal MSRs, so we use a per-cpu cache to track the last known
> > value
> > of the MSRs to avoid unnecessarily writing the MSRs with the current
> > value.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/include/asm/sgx.h      |  2 +
> >  arch/x86/kernel/cpu/intel_sgx.c | 86
> > +++++++++++++++++++++++++++++++--
> >  2 files changed, 85 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> > index baf30d49b71f..c15c156436be 100644
> > --- a/arch/x86/include/asm/sgx.h
> > +++ b/arch/x86/include/asm/sgx.h
> > @@ -108,6 +108,8 @@ void sgx_free_page(struct sgx_epc_page *page);
> >  void sgx_page_reclaimable(struct sgx_epc_page *page);
> >  struct page *sgx_get_backing(struct file *file, pgoff_t index);
> >  void sgx_put_backing(struct page *backing_page, bool write);
> > +int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken
> > *token,
> > +	      struct sgx_epc_page *secs_page, u64 lepubkeyhash[4]);
> >  
> >  #define ENCLS_FAULT_FLAG 0x40000000UL
> >  #define ENCLS_FAULT_FLAG_ASM "$0x40000000"
> > diff --git a/arch/x86/kernel/cpu/intel_sgx.c
> > b/arch/x86/kernel/cpu/intel_sgx.c
> > index 1046478a3ab9..fe25e6805680 100644
> > --- a/arch/x86/kernel/cpu/intel_sgx.c
> > +++ b/arch/x86/kernel/cpu/intel_sgx.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/sched/signal.h>
> >  #include <linux/shmem_fs.h>
> >  #include <linux/slab.h>
> > +#include <linux/suspend.h>
> >  #include <asm/sgx.h>
> >  #include <asm/sgx_pr.h>
> >  
> > @@ -38,6 +39,18 @@ static LIST_HEAD(sgx_active_page_list);
> >  static DEFINE_SPINLOCK(sgx_active_page_list_lock);
> >  static struct task_struct *ksgxswapd_tsk;
> >  static DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
> > +static struct notifier_block sgx_pm_notifier;
> > +static u64 sgx_pm_cnt;
> > +
> > +/* The cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs
> > for each
> > + * CPU. The entries are initialized when they are first used by
> > sgx_einit().
> > + */
> > +struct sgx_lepubkeyhash {
> > +	u64 msrs[4];
> > +	u64 pm_cnt;
> 
> May I ask why do we need pm_cnt here? In fact why do we need suspend
> staff (namely, sgx_pm_cnt above, and related code in this patch) here
> in this patch? From the patch commit message I don't see why we need PM
> staff here. Please give comment why you need PM staff, or you may
> consider to split the PM staff to another patch.

Refining the commit message probably makes more sense because without PM
code sgx_einit() would be broken. The MSRs have been reset after waking
up.

Some kind of counter is required to keep track of the power cycle. When
going to sleep the sgx_pm_cnt is increased. sgx_einit() compares the
current value of the global count to the value in the cache entry to see
whether we are in a new power cycle.

This brings up one question though: how do we deal with VM host going
to sleep? VM guest would not be aware of this.

I think the best measure would be to add a new parameter to sgx_einit()
that enforces update of the MSRs. The driver can then set this parameter
in the case when sgx_einit() returns SGX_INVALID_LICENSE. This is
coherent because the driver requires writable MSRs. It would not be
coherent to do it directly in the core because KVM does not require
writable MSRs.

> 
> > +};
> > +
> > +static DEFINE_PER_CPU(struct sgx_lepubkeyhash *,
> > sgx_lepubkeyhash_cache);
> >  
> >  /**
> >   * sgx_reclaim_pages - reclaim EPC pages from the consumers
> > @@ -328,6 +341,54 @@ void sgx_put_backing(struct page *backing_page,
> > bool write)
> >  }
> >  EXPORT_SYMBOL_GPL(sgx_put_backing);
> >  
> > +/**
> > + * sgx_einit - initialize an enclave
> > + * @sigstruct:		a pointer to the SIGSTRUCT
> > + * @token:		a pointer to the EINITTOKEN
> > + * @secs_page:		a pointer to the SECS EPC page
> > + * @lepubkeyhash:	the desired value for IA32_SGXLEPUBKEYHASHx
> > MSRs
> > + *
> > + * Try to perform EINIT operation. If the MSRs are writable, they
> > are updated
> > + * according to @lepubkeyhash.
> > + *
> > + * Return:
> > + *   0 on success,
> > + *   -errno on failure
> > + *   SGX error code if EINIT fails
> > + */
> > +int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken
> > *token,
> > +	      struct sgx_epc_page *secs_page, u64 lepubkeyhash[4])
> > +{
> > +	struct sgx_lepubkeyhash __percpu *cache;
> > +	bool cache_valid;
> > +	int i, ret;
> > +
> > +	if (!sgx_lc_enabled)
> > +		return __einit(sigstruct, token,
> > sgx_epc_addr(secs_page));
> > +
> > +	cache = per_cpu(sgx_lepubkeyhash_cache, smp_processor_id());
> > +	if (!cache) {
> > +		cache = kzalloc(sizeof(struct sgx_lepubkeyhash),
> > GFP_KERNEL);
> > +		if (!cache)
> > +			return -ENOMEM;
> > +	}
> 
> It seems per-cpu variable is a pointer to struct sgx_lepubkeyhash, and
> the actual structure is allocated at the first time the function is
> called. May I ask when will it be freed? It seems the free is not in
> this patch. Or I am misunderstanding something?

Well, it is part of the core. When the power goes of from the DRAM
banks, everything is wiped out :-)


> 
> > +
> > +	cache_valid = cache->pm_cnt == sgx_pm_cnt;
> > +	cache->pm_cnt = sgx_pm_cnt;
> > +	preempt_disable();
> > +	for (i = 0; i < 4; i++) {
> > +		if (cache_valid && lepubkeyhash[i] == cache-
> > >msrs[i])
> > +			continue;
> > +
> > +		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i,
> > lepubkeyhash[i]);
> > +		cache->msrs[i] = lepubkeyhash[i];
> > +	}
> > +	ret = __einit(sigstruct, token, sgx_epc_addr(secs_page));
> > +	preempt_enable();
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(sgx_einit);
> > +
> >  static __init int sgx_init_epc_bank(u64 addr, u64 size, unsigned
> > long index,
> >  				    struct sgx_epc_bank *bank)
> >  {
> > @@ -426,6 +487,15 @@ static __init int sgx_page_cache_init(void)
> >  	return 0;
> >  }
> >  
> > +static int sgx_pm_notifier_cb(struct notifier_block *nb, unsigned
> > long action,
> > +			      void *data)
> > +{
> > +	if (action == PM_SUSPEND_PREPARE || action ==
> > PM_HIBERNATION_PREPARE)
> > +		sgx_pm_cnt++;
> > +
> > +	return NOTIFY_DONE;
> > +}
> > +
> >  static __init int sgx_init(void)
> >  {
> >  	struct task_struct *tsk;
> > @@ -452,20 +522,30 @@ static __init int sgx_init(void)
> >  	if (!(fc & FEATURE_CONTROL_SGX_LE_WR))
> >  		pr_info("IA32_SGXLEPUBKEYHASHn MSRs are not
> > writable\n");
> >  
> > -	ret = sgx_page_cache_init();
> > +	sgx_pm_notifier.notifier_call = sgx_pm_notifier_cb;
> > +	ret = register_pm_notifier(&sgx_pm_notifier);
> >  	if (ret)
> >  		return ret;
> >  
> > +	ret = sgx_page_cache_init();
> > +	if (ret)
> > +		goto out_pm;
> > +
> >  	tsk = kthread_run(ksgxswapd, NULL, "ksgxswapd");
> >  	if (IS_ERR(tsk)) {
> > -		sgx_page_cache_teardown();
> > -		return PTR_ERR(tsk);
> > +		ret = PTR_ERR(tsk);
> > +		goto out_pcache;
> >  	}
> >  	ksgxswapd_tsk = tsk;
> >  
> >  	sgx_enabled = true;
> >  	sgx_lc_enabled = !!(fc & FEATURE_CONTROL_SGX_LE_WR);
> >  	return 0;
> > +out_pcache:
> > +	sgx_page_cache_teardown();
> 
> I don't think this particular 2 lines of code of 'out_pcache' case
> should be in this patch?

Yea, you are right. It cold be implemented already in the earlier patch
(note taken).

> Thanks,
> -Kai

/Jarkko
