Received: from mga12.intel.com ([192.55.52.136]:9551 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726087AbeIDOXw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 4
 Sep 2018 10:23:52 -0400
Date: Tue, 4 Sep 2018 12:59:23 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>, Dave Hansen
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	<serge.ayoun@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	<suresh.b.siddha@intel.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 07/13] x86/sgx: Add data structures for tracking the
 EPC pages
Message-ID: <20180904095923.GC5423@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-8-jarkko.sakkinen@linux.intel.com>
 <CAHp75VcjKkJR4_H-acbVm3BwA4tVR8gUtkg9STqOK2UG20Tvgg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHp75VcjKkJR4_H-acbVm3BwA4tVR8gUtkg9STqOK2UG20Tvgg@mail.gmail.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Mon, Sep 03, 2018 at 05:41:53PM +0300, Andy Shevchenko wrote:
> On Mon, Aug 27, 2018 at 9:58 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > Add data structures to track Enclave Page Cache (EPC) pages.  EPC is
> > divided into multiple banks (1-N) of which addresses and sizes can be
> > enumerated with CPUID by the OS.
> >
> > On NUMA systems a node can have at most bank. A bank can be at most part of
> > two nodes. SGX supports both nodes with a single memory controller and also
> > sub-cluster nodes with severals memory controllers on a single die.
> 
> > -#include <asm/sgx.h>
> > -#include <asm/sgx_pr.h>
> >  #include <linux/freezer.h>
> >  #include <linux/highmem.h>
> >  #include <linux/kthread.h>
> > +#include <linux/pagemap.h>
> >  #include <linux/ratelimit.h>
> >  #include <linux/sched/signal.h>
> > +#include <linux/shmem_fs.h>
> >  #include <linux/slab.h>
> > +#include <asm/sgx.h>
> > +#include <asm/sgx_pr.h>
> 
> Squash issues?

Yes :-/

> > +       va = ioremap_cache(addr, size);
> > +       if (!va)
> > +               return -ENOMEM;
> 
> I'm not sure this is a right API. Do we operate with memory? Does it
> have I/O side effects?
> If no, memremap() would be better to use.

Had this idea a long time ago but had forgotten it. EPC is from caching
perspective like regular memory.

> -- 
> With Best Regards,
> Andy Shevchenko
> 

/Jarkko
