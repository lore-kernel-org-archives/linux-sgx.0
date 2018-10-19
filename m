Received: from mga12.intel.com ([192.55.52.136]:30884 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726349AbeJTIIV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Sat, 20
 Oct 2018 04:08:21 -0400
Date: Sat, 20 Oct 2018 02:59:57 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>, <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
	"Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "open
 list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 19/19] x86/sgx: Driver documentation
In-Reply-To: <20181018095727.GC10861@amd>
Message-ID: <alpine.DEB.2.21.1810200235290.9963@jsakkine-mobl1>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com> <20180925130845.9962-20-jarkko.sakkinen@linux.intel.com> <20181015205436.GA28500@amd> <alpine.DEB.2.21.1810180205490.5022@jsakkine-mobl1> <20181018095727.GC10861@amd>
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Thu, 18 Oct 2018, Pavel Machek wrote:
>> Definitely should be refined.
>>
>> Meltdowns approach AFAIK does not work because reads outside the enclave
>> will always have a predefined value (-1) but only if the page is present,
>> which was later exploited in the Foreshadow attack.
>
> What about L1tf and https://github.com/lsds/spectre-attack-sgx ?

L1TF is the vuln and Foreshadow is the attack taking advantage of the
vuln. I didn't mean to patch the documention in my response or give
extensive list of the vulns if you expected that.

For kernel documentation it does make sense to give a threat model
but not enumerate every possible vuln.

/Jarkko
