Subject: Re: [PATCH v15 23/23] x86/sgx: Driver documentation
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>, <linux-sgx@vger.kernel.org>
CC: <sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, <andriy.shevchenko@linux.intel.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	"open list" <linux-kernel@vger.kernel.org>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-24-jarkko.sakkinen@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <154ded23-fd1d-f324-4e0a-9de8eddcda6d@intel.com>
Date: Mon, 5 Nov 2018 12:27:11 -0800
In-Reply-To: <20181102231320.29164-24-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Return-Path: dave.hansen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 11/2/18 4:11 PM, Jarkko Sakkinen wrote:
>  Documentation/index.rst         |   1 +
>  Documentation/x86/intel_sgx.rst | 185 ++++++++++++++++++++++++++++++++
>  2 files changed, 186 insertions(+)
>  create mode 100644 Documentation/x86/intel_sgx.rst

This patch set establishes an ABI.  It basically sets in stone a bunch
of behaviors that the enclave, the kernel, and the out-of-enclave code
must follow.

There are a bunch of things that the enclave can do to %rsp or %rip, for
instance, that it is capable and/or permitted to do.

The ABI seems entirely undocumented and rather lightly designed, which
seems like something we should fix before this is merged.

Also, for a feature as massive and complicated as this one, it seems
irresponsible to not have a selftest.  Is that not feasible for some reason?
