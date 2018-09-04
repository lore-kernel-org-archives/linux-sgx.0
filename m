Received: from mga18.intel.com ([134.134.136.126]:24310 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726367AbeIDULk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 4
 Sep 2018 16:11:40 -0400
Date: Tue, 4 Sep 2018 08:45:53 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: Andy Shevchenko <andy.shevchenko@gmail.com>, "maintainer:X86 ARCHITECTURE
 (32-BIT AND 64-BIT)" <x86@kernel.org>, Platform Driver
	<platform-driver-x86@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, <suresh.b.siddha@intel.com>,
	<serge.ayoun@intel.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 09/13] x86/sgx: Enclave Page Cache (EPC) memory
 manager
Message-ID: <20180904154553.GA5412@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-10-jarkko.sakkinen@linux.intel.com>
 <CAHp75Vf39J8U3VnmxP+BBYi7rqzidxdD58Yx_fdnLXRro_QBgg@mail.gmail.com>
 <20180904153803.GC8344@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180904153803.GC8344@linux.intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Tue, Sep 04, 2018 at 06:38:03PM +0300, Jarkko Sakkinen wrote:
> On Mon, Sep 03, 2018 at 10:02:16PM +0300, Andy Shevchenko wrote:
> > On Mon, Aug 27, 2018 at 9:58 PM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > +       WARN(ret < 0, "sgx: cannot free page, reclaim in-progress");
> > > +       WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
> > 
> > I'm not sure (though it's easy to check) that you need sgx: prefix
> > here. WARN() might take pr_fmt() if defined.
> 
> Sean, you took care of this one. Was it so that WARN() does not respect
> pr_fmt?

Yep, WARN() doesn't respect pr_fmt.
