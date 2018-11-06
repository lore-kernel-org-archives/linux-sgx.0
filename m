Date: Tue, 6 Nov 2018 08:26:55 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, <andriy.shevchenko@linux.intel.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open
 list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 23/23] x86/sgx: Driver documentation
Message-ID: <20181106062655.GA18671@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-24-jarkko.sakkinen@linux.intel.com>
 <154ded23-fd1d-f324-4e0a-9de8eddcda6d@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <154ded23-fd1d-f324-4e0a-9de8eddcda6d@intel.com>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, Nov 05, 2018 at 12:27:11PM -0800, Dave Hansen wrote:
> This patch set establishes an ABI.  It basically sets in stone a bunch
> of behaviors that the enclave, the kernel, and the out-of-enclave code
> must follow.
> 
> There are a bunch of things that the enclave can do to %rsp or %rip, for
> instance, that it is capable and/or permitted to do.

Just want to ask a follow-up from this so that I understand you better.
Now we are talking abou ioctl API, right? I'm not exactly sure how
EENTER/EEXIT/ERESUME behavior connects to that. I understand the tail
of your message but this paragraph left me a bit puzzled...

/Jarkko
