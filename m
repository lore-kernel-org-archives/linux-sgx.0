Date: Tue, 4 Sep 2018 18:26:05 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "nhorman@redhat.com" <nhorman@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "suresh.b.siddha@intel.com"
	<suresh.b.siddha@intel.com>, "Ayoun, Serge" <serge.ayoun@intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "npmccallum@redhat.com"
	<npmccallum@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>
Subject: Re: [PATCH v13 10/13] x86/sgx: Add sgx_einit() for initializing
 enclaves
Message-ID: <20180904152605.GA8344@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com>
 <1535406078.3416.9.camel@intel.com>
 <20180828070129.GA5301@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893541037C@PGSMSX112.gar.corp.intel.com>
 <20180831121645.GA18075@linux.intel.com>
 <20180831181509.GB21555@linux.intel.com>
 <20180903191926.GC13497@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893541970F@PGSMSX112.gar.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <105F7BF4D0229846AF094488D65A09893541970F@PGSMSX112.gar.corp.intel.com>
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Sep 03, 2018 at 11:45:14PM +0000, Huang, Kai wrote:
> But INVALID_TOKEN is not only returned when MSRs are mismatched, so do
> you plan to check to rule out other cases that cause INVALID_TOKEN
> before retrying EINIT, or unconditionally  retry EINIT? And we should
> only retry once?

In the case of this error we will do wrmsrs and retry einit once.
This is how I understood it at least.

Q: Do we have to care about VMM sleep anyway? I mean if VMM always traps
EINIT it can write the MSRs with guest values if it has been sleeping.

If the answer is no, then retrying once should be a complete solution
and we don't need pm_cnt.

/Jarkko
