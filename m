Date: Fri, 31 Aug 2018 11:18:04 -0500
From: "Dr. Greg" <greg@enjellic.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Kai Huang <kai.huang@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Borislav
 Petkov" <bp@suse.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "David
 Woodhouse" <dwmw@amazon.co.uk>, "open list:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 02/13] x86/cpufeature: Add SGX and SGX_LC CPU features
Message-ID: <20180831161804.GA1923@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com> <20180827185507.17087-3-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180827185507.17087-3-jarkko.sakkinen@linux.intel.com>
Return-Path: greg@wind.enjellic.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Aug 27, 2018 at 09:53:23PM +0300, Jarkko Sakkinen wrote:

Good morning, I hope the week has gone well for everyone.

> From: Kai Huang <kai.huang@linux.intel.com>
> 
> Add X86_FEATURE_SGX and X86_FEATURE_SGX_LC that define the bits
> determining whether the CPU supports SGX and user launch configuration
> i.e. using a custom root key rather the Intel proprietary key for
> enclave signing.

First of all thanks to Jarkko, Sean et.al who have been working on
Linux SGX eco-system support.  Given the nature and apparent mystique
surrounding this technology, we are assuming that Intel has you locked
away in dungeons somewhere... :-)

I direct engineering efforts for an SGX development company.  We are a
licensed Intel ISV, ie. we have a signing key on the launch enclave
whitelist.  Due to the nature of our products we designed an
independent implementation of the PSW which includes enclave loading
and execution, EPID provisioning and remote attestation
infrastructure.  We have also done initial engineering on the
feasibility of developing an independent authentication and
attestation service.

So I think we understand this technology about as well as anyone.

Our reflections on the patch series are not technical as much as
operational.  To wit; are you guys developing this driver 'blind',
ie. simply based on guidance from the SDM or are you testing them on
simulators or do you actually have real live hardware with these
capabilities?

If you boil these 'new' patches down they basically address three
primary areas of functionality; Enclave Dynamic Memory Management
(EDMM), Flexible Launch Control (Unlocked identity modulus signature
registers) and NUMA support.  You could also throw in virtualization
as that is another whole can of worms given a VM may not end up on the
same die, ie. TCB base.

Other then a smattering of machines which advertise basic SGX2
instruction support for EDMM, there is virtually no hardware available
to test any of this functionality on.  Also of interest, there is
virtually no guidance available as to when any of this functionality
will become available.

We don't see how the Linux/SGX community can effectively debug and
support this driver without some kind of an idea as to what hardware
to be acquiring to test this functionality.  I'm assuming that Intel
has 'preferred partners' which do have access to this knowledge, which
is fine, but it would seem odd to expect general community support of
a driver that uses this model.

It would be a significant statement in support of the community if the
documentation for the driver included a table of functionality and the
chip and chipset versions needed to support the stated functionality.
That would significantly increase the ability for this driver to be
supported and tested.

Once again, thanks for all the legwork on the driver, however you are
managing to exercise its functionality.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"The couple is registered at Herbergers, Target and Fleet Farm."
                                -- Wedding invitation
                                   West Central Minnesota
