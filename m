Date: Thu, 18 Oct 2018 02:45:27 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>, <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "open
 list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 19/19] x86/sgx: Driver documentation
In-Reply-To: <20181015205436.GA28500@amd>
Message-ID: <alpine.DEB.2.21.1810180205490.5022@jsakkine-mobl1>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com> <20180925130845.9962-20-jarkko.sakkinen@linux.intel.com> <20181015205436.GA28500@amd>
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Mon, 15 Oct 2018, Pavel Machek wrote:
> On Tue 2018-09-25 16:06:56, Jarkko Sakkinen wrote:
>> +Intel(R) SGX is a set of CPU instructions that can be used by applications to
>> +set aside private regions of code and data. The code outside the enclave is
>> +disallowed to access the memory inside the enclave by the CPU access control.
>> +In a way you can think that SGX provides inverted sandbox. It protects the
>> +application from a malicious host.
>
> Well, recently hardware had some problems keeping its
> promises. So... what about rowhammer, meltdown and spectre?

Doesn't hardware always have this problem over time?

> Which ones apply, which ones do not, and on what cpu generations?

Definitely should be refined.

Meltdowns approach AFAIK does not work because reads outside the enclave
will always have a predefined value (-1) but only if the page is present,
which was later exploited in the Foreshadow attack.

> Encryption, that sounds nice, but it is hard to do right. If SGX
> protected code changes single bit in its memory, how many bits will be
> changed in physical RAM?

512-bit blocks and merkle tree based mac. It is pretty well documented
in https://eprint.iacr.org/2016/204.pdf. I'll take not to myself to add
this to the references.

Thanks for the feedback. The ocumentation is hard to drive forward w/o it.

/Jarkko
