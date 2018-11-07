Subject: Re: [PATCH v15 23/23] x86/sgx: Driver documentation
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, <andriy.shevchenko@linux.intel.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	"open list" <linux-kernel@vger.kernel.org>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-24-jarkko.sakkinen@linux.intel.com>
 <154ded23-fd1d-f324-4e0a-9de8eddcda6d@intel.com>
 <20181106054911.GA15575@linux.intel.com>
 <e7b4c432-7005-308c-4da0-a80e0d294244@intel.com>
 <20181107163019.GA11509@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <914dd171-b48a-12d9-eb77-3c40c8b210cb@intel.com>
Date: Wed, 7 Nov 2018 09:09:37 -0800
In-Reply-To: <20181107163019.GA11509@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Return-Path: dave.hansen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 11/7/18 8:30 AM, Jarkko Sakkinen wrote:
>> Does this code run when I type "make kselftest"?  If not, I think we
>> should rectify that.
> No, it doesn't. It is just my backup for the non-SDK user space code
> that I've made that I will use to fork my user space SGX projects in
> the future.
> 
> I can work-out a selftest (and provide a new patch in the series) but
> I'm still wondering what the enclave should do. I would suggest that
> we start with an enclave that does just EEXIT and nothing else.

Yeah, that's a start.  But, a good selftest would include things like
faults and error conditions.
