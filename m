Date: Tue, 28 Aug 2018 11:36:15 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>, Serge Ayoun
	<serge.ayoun@intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 09/13] x86/sgx: Enclave Page Cache (EPC) memory
 manager
Message-ID: <20180828083615.GI15508@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
 <40632d90-8222-e31a-4729-22b89ed52a8d@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <40632d90-8222-e31a-4729-22b89ed52a8d@intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Aug 27, 2018 at 02:14:24PM -0700, Dave Hansen wrote:
> On 08/27/2018 11:53 AM, Jarkko Sakkinen wrote:
> > +enum sgx_alloc_flags {
> > +	SGX_ALLOC_ATOMIC	= BIT(0),
> > +};
> 
> Doing this with enums is unprecedented IMNHO.  Why are you doing it this
> way for simple, one-off constants?

I'll change it to bool, thanks.

/Jarkko
