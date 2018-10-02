Received: from mga07.intel.com ([134.134.136.100]:57680 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1725936AbeJBGry (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 2
 Oct 2018 02:47:54 -0400
Date: Tue, 2 Oct 2018 03:07:25 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
CC: Andy Lutomirski <luto@amacapital.net>, Dave Hansen
	<dave.hansen@intel.com>, Andrew Lutomirski <luto@kernel.org>, X86 ML
	<x86@kernel.org>, Platform Driver <platform-driver-x86@vger.kernel.org>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, "Ayoun, Serge"
	<serge.ayoun@intel.com>, <shay.katz-zamir@intel.com>,
	<linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs
 w/ PF_SGX
Message-ID: <20181002000725.GB21814@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-10-jarkko.sakkinen@linux.intel.com>
 <CALCETrVAhiwv+g5fzVO3ZSHZgcQKbeeG8r3HUcXO9k7Gi94NdQ@mail.gmail.com>
 <20180926173516.GA10920@linux.intel.com>
 <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net>
 <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com>
 <20180926204400.GA11446@linux.intel.com>
 <b7e14c6e-fc05-93fa-eef9-5e3f06ab4729@intel.com>
 <CALCETrXByb2UVuZ6AXUeOd8y90NAikbZuvdN3wf_TjHZ+CxNhA@mail.gmail.com>
 <1538404143.30715.27.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <1538404143.30715.27.camel@intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Mon, Oct 01, 2018 at 07:29:03AM -0700, Sean Christopherson wrote:
> On Wed, 2018-09-26 at 14:15 -0700, Andy Lutomirski wrote:
> > runs an enclave an returns an error code, and rig up the #PF handler
> > to check if the error happened in the vDSO entry and fix it up rather
> > than sending a signal?
> 
> 
> If we want to avoid having to install a signal handler then I'm pretty
> sure we'd need to fixup all #GPs and "bad access" #PFs that occur on
> EENTER or in the enclave, not just PF_SGX faults.  SGX1 hardware takes
> a #GP instead of a #PF on EPCM faults, and SGX2 hardware allows enclaves
> to allocate/free/adjust EPC pages at runtime, e.g. an enclave runtime
> might want to intercept #PFs from within the enclave so that the enclave
> can dynamically grow its stack.

If I've understood Andy's proposal correctly, the run-time would get the
same information as with a signal. The delivery path for this
information would be just different.

/Jarkko
