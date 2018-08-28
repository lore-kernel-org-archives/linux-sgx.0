Date: Tue, 28 Aug 2018 11:35:40 +0300
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
Message-ID: <20180828083540.GH15508@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
 <7c5df14e-3028-46b3-fe93-aa6ba8352317@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <7c5df14e-3028-46b3-fe93-aa6ba8352317@intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Aug 27, 2018 at 02:15:34PM -0700, Dave Hansen wrote:
> On 08/27/2018 11:53 AM, Jarkko Sakkinen wrote:
> > +struct sgx_epc_page_ops {
> > +	bool (*get)(struct sgx_epc_page *epc_page);
> > +	void (*put)(struct sgx_epc_page *epc_page);
> > +	bool (*reclaim)(struct sgx_epc_page *epc_page);
> > +	void (*block)(struct sgx_epc_page *epc_page);
> > +	void (*write)(struct sgx_epc_page *epc_page);
> > +};
> 
> Why do we need a fancy, slow (retpoline'd) set of function pointers when
> we only have one user of these (the SGX driver)?

KVM has its own implementation for these operations.

/Jarkko
