Received: from mga17.intel.com ([192.55.52.151]:28806 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1725843AbeKBCzt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Thu, 1
 Nov 2018 22:55:49 -0400
Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs w/
 PF_SGX
To: Andy Lutomirski <luto@amacapital.net>
CC: Jethro Beekman <jethro@fortanix.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Andrew Lutomirski <luto@kernel.org>, "X86
 ML" <x86@kernel.org>, Platform Driver <platform-driver-x86@vger.kernel.org>,
	"nhorman@redhat.com" <nhorman@redhat.com>, "npmccallum@redhat.com"
	<npmccallum@redhat.com>, "Ayoun, Serge" <serge.ayoun@intel.com>,
	"shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
	"Thomas Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20180926173516.GA10920@linux.intel.com>
 <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net>
 <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com>
 <20180926204400.GA11446@linux.intel.com>
 <b7e14c6e-fc05-93fa-eef9-5e3f06ab4729@intel.com>
 <CALCETrXByb2UVuZ6AXUeOd8y90NAikbZuvdN3wf_TjHZ+CxNhA@mail.gmail.com>
 <992b1d6d-cc0f-776f-d938-2a1f7cad52c8@intel.com>
 <20180927135603.GF8242@linux.intel.com>
 <ae76dfe7-3587-0d21-37b7-535279edc235@fortanix.com>
 <2e7b81e1-818f-7d76-e2b4-793d9ec5d5a6@intel.com>
 <20181031213036.GA23089@linux.intel.com>
 <a9c23203-476d-875d-9fbb-263716833e17@intel.com>
 <dc0f8bc8-4d69-517e-68af-abda2d51423f@fortanix.com>
 <a6deac4e-ce8f-aa43-2d75-a04c05bac104@intel.com>
 <2833FD27-42A0-435C-AEA5-2DC73315867A@amacapital.net>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <99b6de19-5620-7f3b-5c37-dbf8a6baef17@intel.com>
Date: Thu, 1 Nov 2018 10:51:50 -0700
In-Reply-To: <2833FD27-42A0-435C-AEA5-2DC73315867A@amacapital.net>
Content-Type: text/plain; charset="utf-8"
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On 10/31/18 3:52 PM, Andy Lutomirski wrote:
> I think EENTER in plain user code should have well defined semantics,
> and it should get regular signals with the appropriate bits set in
> the error code field in the ucontext.  But we should probably
> simultaneously offer a nicer API, and the libraries will use it
> because it’s nicer.

FWIW, if we have a signal-based version and a VDSO-based version, nobody
will use the VDSO one.

The Intel libraries are surely going to keep using the approach they've
been using for years and I doubt their owners will be tempted even by a
simpler interface to change one line of code.

If we want to do the VDSO route, I think we probably need to go
whole-hog and toss the signal-based one.
