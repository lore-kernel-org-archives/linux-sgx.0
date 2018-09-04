Received: from mga05.intel.com ([192.55.52.43]:60916 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726507AbeIDWor (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 4
 Sep 2018 18:44:47 -0400
Date: Tue, 4 Sep 2018 11:17:35 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "maintainer:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Platform Driver
	<platform-driver-x86@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	<serge.ayoun@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	<suresh.b.siddha@intel.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 07/13] x86/sgx: Add data structures for tracking the
 EPC pages
Message-ID: <20180904181735.GA5820@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-8-jarkko.sakkinen@linux.intel.com>
 <CAHp75VcjKkJR4_H-acbVm3BwA4tVR8gUtkg9STqOK2UG20Tvgg@mail.gmail.com>
 <20180904174914.GA5690@linux.intel.com>
 <CAHp75VeC0n82thqKKywfiTwd7_fngrc5Zf_1dMzmNdjgafgMvA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHp75VeC0n82thqKKywfiTwd7_fngrc5Zf_1dMzmNdjgafgMvA@mail.gmail.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Tue, Sep 04, 2018 at 09:01:15PM +0300, Andy Shevchenko wrote:
> On Tue, Sep 4, 2018 a> +/**
> 
> > > > +       va = ioremap_cache(addr, size);
> > > > +       if (!va)
> > > > +               return -ENOMEM;
> > >
> > > I'm not sure this is a right API. Do we operate with memory? Does it
> > > have I/O side effects?
> > > If no, memremap() would be better to use.
> >
> > Preserving __iomem is desirable.  There aren't side effects per se,
> > but direct non-enclave accesses to the EPC get abort page semantics so
> > the kernel shouldn't be directly dereferencing a pointer to the EPC.
> > Though by that argument, sgx_epc_bank.va, sgx_epc_addr's return and
> > all ENCLS helpers should be tagged __iomem.
> 
> Why?
> Does it related to *any* I/O?

No, hence my other comment that __private or a new tag altogether may
be more appropriate.  The noderef attribute is what we truly care
about.
