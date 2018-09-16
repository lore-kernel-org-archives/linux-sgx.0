Date: Sun, 16 Sep 2018 14:40:11 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <nhorman@redhat.com>, <npmccallum@redhat.com>,
	<linux-sgx@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, Serge Ayoun <serge.ayoun@intel.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 09/13] x86/sgx: Enclave Page Cache (EPC) memory
 manager
Message-ID: <20180916114011.GA5040@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
 <1536678279.5992.9.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <1536678279.5992.9.camel@intel.com>
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Sep 11, 2018 at 08:04:39AM -0700, Sean Christopherson wrote:
> > +static void sgx_reclaim_pages(void)
> > +{
> > +	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN + 1];
> 
> The array size should simply be SGX_NR_TO_SCAN.  The +1 is a remnant
> from the previous version that bounded the for-loops with "!chunk[i]"
> check instead of "i < j".  No functional issue, essentially just an
> unused variable.

Thanks, yep, it is cruft.

/Jarkko
