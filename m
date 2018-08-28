Received: from mga14.intel.com ([192.55.52.115]:6038 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1727216AbeH2Bqb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 28
 Aug 2018 21:46:31 -0400
Date: Tue, 28 Aug 2018 14:52:40 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>, Serge Ayoun
	<serge.ayoun@intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 09/13] x86/sgx: Enclave Page Cache (EPC) memory
 manager
Message-ID: <20180828215240.GA29684@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
 <7c5df14e-3028-46b3-fe93-aa6ba8352317@intel.com>
 <20180828083540.GH15508@linux.intel.com>
 <132d309d-77e2-52ed-7251-abb2c80cdf49@intel.com>
 <20180828212244.GA29488@linux.intel.com>
 <81adf7e1-b9c2-e906-95a3-c6e08cbcc52a@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <81adf7e1-b9c2-e906-95a3-c6e08cbcc52a@intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Tue, Aug 28, 2018 at 02:26:36PM -0700, Dave Hansen wrote:
> On 08/28/2018 02:22 PM, Sean Christopherson wrote:
> > On Tue, Aug 28, 2018 at 07:07:33AM -0700, Dave Hansen wrote:
> >> On 08/28/2018 01:35 AM, Jarkko Sakkinen wrote:
> >>> On Mon, Aug 27, 2018 at 02:15:34PM -0700, Dave Hansen wrote:
> >>>> On 08/27/2018 11:53 AM, Jarkko Sakkinen wrote:
> >>>>> +struct sgx_epc_page_ops {
> >>>>> +	bool (*get)(struct sgx_epc_page *epc_page);
> >>>>> +	void (*put)(struct sgx_epc_page *epc_page);
> >>>>> +	bool (*reclaim)(struct sgx_epc_page *epc_page);
> >>>>> +	void (*block)(struct sgx_epc_page *epc_page);
> >>>>> +	void (*write)(struct sgx_epc_page *epc_page);
> >>>>> +};
> >>>> Why do we need a fancy, slow (retpoline'd) set of function pointers when
> >>>> we only have one user of these (the SGX driver)?
> >>> KVM has its own implementation for these operations.
> >>
> >> That belongs in the changelog.
> >>
> >> Also, where is the implementation?  How can we assess this code that was
> >> built to create an abstraction without both of the users?
> > 
> > I can provide an early preview of the KVM reclaim code, but honestly
> > I think that would do more harm than good.  The VMX architecture for
> > EPC reclaim is complex, even for SGX standards.  Opening that can of
> > worms would likely derail this discussion.  That being said, this
> > abstraction isn't exactly what KVM will need, but it's pretty close
> > and gives us something to build on.
> 
> Please remove the abstraction code.  We don't introduce infrastructure
> which no one will use.

The infrastructure is used in the sense that it allows us to split the
userspace-facing code, i.e. the driver, into a separate module.  This
in turn allows virtualization of SGX without having to load the driver
or building it in the first place, e.g. to virtualize SGX on a system
that doesn't meet the driver's requirements.

We could eliminate the abstraction by moving the EPC management code
into the driver, but that would directly conflict with past feedback
and would need to be completely undone to enable KVM.  The abstraction
could be dumbed down to a single function, but as mentioned earlier,
that comes with its own costs.  I can dive into exactly what we lose
with a single function approach if this is a sticking point.
