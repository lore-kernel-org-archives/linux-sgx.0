From: "Huang, Kai" <kai.huang@intel.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Subject: RE: [PATCH v13 10/13] x86/sgx: Add sgx_einit() for initializing
 enclaves
Date: Wed, 29 Aug 2018 00:33:54 -0700
Message-ID: 
 <105F7BF4D0229846AF094488D65A09893541037C@PGSMSX112.gar.corp.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com>
 <1535406078.3416.9.camel@intel.com> <20180828070129.GA5301@linux.intel.com>
In-Reply-To: <20180828070129.GA5301@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

[snip..]

> > >
> > > @@ -38,6 +39,18 @@ static LIST_HEAD(sgx_active_page_list);  static
> > > DEFINE_SPINLOCK(sgx_active_page_list_lock);
> > >  static struct task_struct *ksgxswapd_tsk;  static
> > > DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
> > > +static struct notifier_block sgx_pm_notifier; static u64
> > > +sgx_pm_cnt;
> > > +
> > > +/* The cache for the last known values of IA32_SGXLEPUBKEYHASHx
> > > +MSRs
> > > for each
> > > + * CPU. The entries are initialized when they are first used by
> > > sgx_einit().
> > > + */
> > > +struct sgx_lepubkeyhash {
> > > +	u64 msrs[4];
> > > +	u64 pm_cnt;
> >
> > May I ask why do we need pm_cnt here? In fact why do we need suspend
> > staff (namely, sgx_pm_cnt above, and related code in this patch) here
> > in this patch? From the patch commit message I don't see why we need
> > PM staff here. Please give comment why you need PM staff, or you may
> > consider to split the PM staff to another patch.
> 
> Refining the commit message probably makes more sense because without PM
> code sgx_einit() would be broken. The MSRs have been reset after waking up.
> 
> Some kind of counter is required to keep track of the power cycle. When going
> to sleep the sgx_pm_cnt is increased. sgx_einit() compares the current value of
> the global count to the value in the cache entry to see whether we are in a new
> power cycle.

You mean reset to Intel default? I think we can also just reset the cached MSR values on each power cycle, which would be simpler, IMHO?

I think we definitely need some code to handle S3-S5, but should be in separate patches, since I think the major impact of S3-S5 is entire EPC being destroyed. I think keeping pm_cnt is not sufficient enough to handle such case?

> 
> This brings up one question though: how do we deal with VM host going to sleep?
> VM guest would not be aware of this.

IMO VM just gets "sudden loss of EPC" after suspend & resume in host. SGX driver and SDK should be able to handle "sudden loss of EPC", ie, co-working together to re-establish the missing enclaves.

Actually supporting "sudden loss of EPC" is a requirement to support live migration of VM w/ SGX. Internally long time ago we had a discussion and the decision was we should support SGX live migration given two facts:

1) losing platform-dependent is not important. For example, losing sealing key is not a problem, as we could get secrets provisioned again from remote. 2) Both windows & linux driver commit to support "sudden loss of EPC".

I don't think we have to support in very first upstream driver, but I think we need to support someday.

Sean, 

Would you be able to comment here?

> 
> I think the best measure would be to add a new parameter to sgx_einit() that
> enforces update of the MSRs. The driver can then set this parameter in the case
> when sgx_einit() returns SGX_INVALID_LICENSE. This is coherent because the
> driver requires writable MSRs. It would not be coherent to do it directly in the
> core because KVM does not require writable MSRs.

IMHO this is not required, as I mentioned above.

And 
[snip...]

Thanks,
-Kai
