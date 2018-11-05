Received: from mga14.intel.com ([192.55.52.115]:46489 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S2387515AbeKFC4w (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Mon, 5
 Nov 2018 21:56:52 -0500
Date: Mon, 5 Nov 2018 19:35:57 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	Platform Driver <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, <suresh.b.siddha@intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Reinette Chatre
	<reinette.chatre@intel.com>, "Rafael J. Wysocki"
	<rafael.j.wysocki@intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 16/23] x86/sgx: Enumerate and track EPC sections
Message-ID: <20181105173557.GF4502@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-17-jarkko.sakkinen@linux.intel.com>
 <CAHp75Vcq_L5RYSEDcBSd-q09onp6O6_JU1_2MrZ3sAmyX7XgLQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHp75Vcq_L5RYSEDcBSd-q09onp6O6_JU1_2MrZ3sAmyX7XgLQ@mail.gmail.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Sat, Nov 03, 2018 at 03:22:34PM +0200, Andy Shevchenko wrote:
> On Sat, Nov 3, 2018 at 1:17 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > Enumerate Enclave Page Cache (EPC) sections via CPUID and add the data
> > structures necessary to track EPC pages so that they can be allocated,
> > freed and managed.  As a system may have multiple EPC sections, invoke
> > CPUID on SGX sub-leafs until an invalid leaf is encountered.
> >
> > On NUMA systems, a node can have at most one bank. A bank can be at
> > most part of two nodes.  SGX supports both nodes with a single memory
> > controller and also sub-cluster nodes with severals memory controllers
> > on a single die.
> >
> > For simplicity, support a maximum of eight EPC sections.  Current
> > client hardware supports only a single section, while upcoming server
> > hardware will support at most eight sections.  Bounding the number of
> > sections also allows the section ID to be embedded along with a page's
> > offset in a single unsigned long, enabling easy retrieval of both the
> > VA and PA for a given page.
> 
> > +       iounmap(section->va);
> 
> > +       section->va = ioremap_cache(addr, size);
> > +       if (!section->va)
> > +               return -ENOMEM;
> 
> I forgot if it's a place in code on which we discussed ioremap() vs.
> memremap() call.
> And I forgot why the conclusion is to leave ioremap().
> 
> Sorry, if I'm mistaken.

Thanks for pointing this out. It very well might I have either

1. forgotten to do the switch.
2. had some open about it that I forgot to ask.

Anyway, I'll check this and at minimum document the reason to the
change log if there is one to keep the ioremap().

/Jarkko
