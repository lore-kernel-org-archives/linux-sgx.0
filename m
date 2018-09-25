Date: Tue, 25 Sep 2018 07:27:17 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, "open list:DOCUMENTATION"
	<linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 19/19] x86/sgx: Driver documentation
Message-ID: <20180925072717.3a41af75@lwn.net>
In-Reply-To: <20180925130845.9962-20-jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
	<20180925130845.9962-20-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="US-ASCII"
Return-Path: corbet@lwn.net
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, 25 Sep 2018 16:06:56 +0300
Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:

> Documentation of the features of the Software Guard eXtensions used
> by the Linux kernel and basic design choices for the core and driver
> and functionality.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  Documentation/index.rst         |   1 +
>  Documentation/x86/intel_sgx.rst | 185 ++++++++++++++++++++++++++++++++
>  2 files changed, 186 insertions(+)
>  create mode 100644 Documentation/x86/intel_sgx.rst
> 
> diff --git a/Documentation/index.rst b/Documentation/index.rst
> index 5db7e87c7cb1..1cdc139adb40 100644
> --- a/Documentation/index.rst
> +++ b/Documentation/index.rst
> @@ -104,6 +104,7 @@ implementation.
>     :maxdepth: 2
>  
>     sh/index
> +   x86/index

So you're adding this reference to x86/index, but the actual file
(Documentation/x86/index.rst) doesn't exist; that will break the docs
build.  I do appreciate your doing your document in RST, though!

Who is the intended audience for this document?  I see a bit of UAPI
stuff that might be better placed in the userspace-api manual, mixed with
stuff that user-space developers are unlikely to take much interest in.
Might it be worth splitting this into two pieces?

Thanks,

jon
