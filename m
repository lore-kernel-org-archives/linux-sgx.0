Date: Thu, 27 Sep 2018 16:11:14 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 12/19] x86/sgx: Add data structures for tracking the
 EPC pages
Message-ID: <20180927131114.GA5436@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
 <20180925130845.9962-13-jarkko.sakkinen@linux.intel.com>
 <9b2bf157-e162-89ff-000b-190aa8dddb53@infradead.org>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <9b2bf157-e162-89ff-000b-190aa8dddb53@infradead.org>
Return-Path: jarkko.sakkinen@linux.intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, Sep 25, 2018 at 01:00:42PM -0700, Randy Dunlap wrote:
> On 9/25/18 6:06 AM, Jarkko Sakkinen wrote:
> > Add data structures to track Enclave Page Cache (EPC) pages.  EPC is
> > divided into multiple banks (1-N) of which addresses and sizes can be
> > enumerated with CPUID by the OS.
> > 
> > On NUMA systems a node can have at most bank. A bank can be at most part of
> > two nodes. SGX supports both nodes with a single memory controller and also
> > sub-cluster nodes with severals memory controllers on a single die.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
> > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/include/asm/sgx.h      |  55 +++++++++++++++
> >  arch/x86/kernel/cpu/intel_sgx.c | 115 ++++++++++++++++++++++++++++++++
> >  2 files changed, 170 insertions(+)
> 
> Hi,
> 
> Several comment blocks begin with "/**" but they are either not intended
> to be kernel-doc notation or they are incomplete kernel-doc notation.

I'll enumerate them through.

Thank you for the feedback.

/Jarkko
