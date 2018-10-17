Subject: Re: [PATCH v14 19/19] x86/sgx: Driver documentation
To: Pavel Machek <pavel@ucw.cz>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-20-jarkko.sakkinen@linux.intel.com>
 <20181015205436.GA28500@amd>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
	"Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "open
 list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <fe28962d-367b-b8bb-8280-fe48c7d08813@intel.com>
Date: Wed, 17 Oct 2018 16:56:51 -0700
In-Reply-To: <20181015205436.GA28500@amd>
Content-Type: text/plain; charset="windows-1252"
Sender: <platform-driver-x86-owner@vger.kernel.org>
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On 10/15/2018 01:54 PM, Pavel Machek wrote:
>> +Intel(R) SGX is a set of CPU instructions that can be used by applications to
>> +set aside private regions of code and data. The code outside the enclave is
>> +disallowed to access the memory inside the enclave by the CPU access control.
>> +In a way you can think that SGX provides inverted sandbox. It protects the
>> +application from a malicious host.
> Well, recently hardware had some problems keeping its
> promises. So... what about rowhammer, meltdown and spectre?

There's a ton of documentation out there about what kinds of protections
SGX provides.  I don't think this is an appropriate place to have an
exhaustive discussion about it.  But, there's extensive discussion of it
on Intel's security site:

https://software.intel.com/security-software-guidance/

There's documentation on how L1TF affects SGX here:

https://software.intel.com/security-software-guidance/software-guidance/l1-terminal-fault

Or Spectre v2 here:

https://software.intel.com/security-software-guidance/software-guidance/bounds-check-bypass

> Which ones apply, which ones do not, and on what cpu generations?

The CVEs list this in pretty exhaustive detail.  The L1TF/SGX one, for
example:

https://nvd.nist.gov/vuln/detail/CVE-2018-3615

Lists a bunch of processor models.
