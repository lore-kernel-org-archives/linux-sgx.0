From: "Huang, Kai" <kai.huang@intel.com>
To: "Christopherson, Sean J" <sean.j.christopherson@intel.com>, Jarkko
 Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"nhorman@redhat.com" <nhorman@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>, "Ayoun, Serge"
	<serge.ayoun@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"npmccallum@redhat.com" <npmccallum@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"Hansen, Dave" <dave.hansen@intel.com>
Subject: RE: [PATCH v13 10/13] x86/sgx: Add sgx_einit() for initializing
 enclaves
Date: Tue, 4 Sep 2018 15:13:34 -0700
Message-ID: 
 <105F7BF4D0229846AF094488D65A09893541AF39@PGSMSX112.gar.corp.intel.com>
References: <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com>
 <1535406078.3416.9.camel@intel.com> <20180828070129.GA5301@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893541037C@PGSMSX112.gar.corp.intel.com>
 <20180831121645.GA18075@linux.intel.com>
 <20180831181509.GB21555@linux.intel.com>
 <20180903191926.GC13497@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893541970F@PGSMSX112.gar.corp.intel.com>
 <20180904145451.GA5233@linux.intel.com>
 <20180904153021.GB8344@linux.intel.com>
 <20180904163546.GA5421@linux.intel.com>
In-Reply-To: <20180904163546.GA5421@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>


> -----Original Message-----
> From: platform-driver-x86-owner@vger.kernel.org [mailto:platform-driver-x86-
> owner@vger.kernel.org] On Behalf Of Sean Christopherson
> Sent: Wednesday, September 5, 2018 4:36 AM
> To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Cc: Huang, Kai <kai.huang@intel.com>; platform-driver-x86@vger.kernel.org;
> x86@kernel.org; nhorman@redhat.com; linux-kernel@vger.kernel.org;
> tglx@linutronix.de; suresh.b.siddha@intel.com; Ayoun, Serge
> <serge.ayoun@intel.com>; hpa@zytor.com; npmccallum@redhat.com;
> mingo@redhat.com; linux-sgx@vger.kernel.org; Hansen, Dave
> <dave.hansen@intel.com>
> Subject: Re: [PATCH v13 10/13] x86/sgx: Add sgx_einit() for initializing enclaves
> 
> On Tue, Sep 04, 2018 at 06:30:21PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Sep 04, 2018 at 07:54:51AM -0700, Sean Christopherson wrote:
> > > I don't see any value in trying to rule out specific causes of
> > > INVALID_TOKEN, but we should only retry EINIT if ret==INVALID_TOKEN
> > > and RDMSR(HASH0) != sgx_lepubkeyhash[0].  Only the first MSR needs
> > > to be checked for validity as they're a package deal, i.e. they'll
> > > all be valid or all be reset.  There shouldn't be a limit on retry
> > > attempts, e.g. the MSRs could theoretically be reset between WRMSR and
> EINIT.
> >
> > Why is doing rdmsrs necessary? With the INVALID_TOKEN error we know we
> > are out-of-sync i.e. have been sleeping and then one just needs to do
> > wrmsrs.
> 
> As Kai mentioned, INVALID_TOKEN is returned for other reasons, e.g. a
> production enclave trying to use a debug token or reserved bits set in the token.
> And in the KVM case, the hash and token are provided by the guest, so it's
> entirely possible the enclave/token is not signed with the key specified in the
> hash.  RDMSR is relatively inexpensive compared to the overall cost of EINIT.
> Though of course EINIT failure isn't exactly a fast path, so I'm ok if you want to
> opt for simplicity and retry on INVALID_TOKEN without checking the MSRs, just
> make sure to add a comment indicating we're intentionally not checking the
> MSRs.
> 
> > I think one retry should be enough given that VMM traps EINIT. One
> > retry is needed to take care of the guest itself (or host if we are
> > running on bare metal) having been in a sleep state.
> 
> Assuming we do RDMSR(hash0), that should be sufficient to prevent infinite retry
> and 

IMHO probably we need to review this assumption w/ crypto guys, at least Intel internally.

Thanks,
-Kai

it protects against the MSRs being lost between WRMSR and EINIT during
> retry.  That being said, I'm ok retrying only once, especially if you want to omit
> the RDMSR.  Disabling preemption should prevent the kernel from suspending
> between WRMSR and EINIT, I'm just being paranoid.
