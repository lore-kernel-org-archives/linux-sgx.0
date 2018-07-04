Received: from mga01.intel.com ([192.55.52.88]:20993 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1752165AbeGDSJU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Wed, 4
 Jul 2018 14:09:20 -0400
Date: Wed, 4 Jul 2018 21:09:13 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 05/13] x86/sgx: architectural structures
Message-ID: <20180704180913.GN6724@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-6-jarkko.sakkinen@linux.intel.com>
 <5790d6a4-7d30-1ed8-0214-f68f1cb72294@intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5790d6a4-7d30-1ed8-0214-f68f1cb72294@intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Tue, Jul 03, 2018 at 02:22:52PM -0700, Dave Hansen wrote:
> On 07/03/2018 11:19 AM, Jarkko Sakkinen wrote:
> > +enum sgx_cpuid {
> > +	SGX_CPUID_CAPABILITIES	= 0,
> > +	SGX_CPUID_ATTRIBUTES	= 1,
> > +	SGX_CPUID_EPC_BANKS	= 2,
> > +};
> 
> I made a review comment about these last time.  I don't remember
> receiving any kind of response from you on it, or seeing it addressed in
> these patches in any kind of way.
> 
> I've also seen comments from Thomas that sound really familiar such as
> the lack of comments on the paging code or the use of a semaphore to
> protect things that don't sleep.  I made very, very similar comments on
> the last posting.
> 
> Is there a reason that those comments were not addressed?

My sloppiness is the reason.

The feedback has been awesome from you and Thomas for this version,
which will help me to get these things right for the next version.

Thank you.

/Jarkko
