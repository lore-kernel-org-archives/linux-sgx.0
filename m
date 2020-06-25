Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039AAC433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 20:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4FA420709
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 20:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405882AbgFYUWJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 16:22:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:32248 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405161AbgFYUWJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 16:22:09 -0400
IronPort-SDR: UrKirvB5NzeMCIqqq6yJo5bPJQtZdyi8MSNMHO3wbvLUjOR8X0tAWeiqdFqldpstNj/E9dBJt8
 AScOsr3gWP/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="210159888"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="210159888"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 13:22:08 -0700
IronPort-SDR: R45DjzFoWLvaRnggtE28YTOQaiLYLE/n5nNGen1bQUCnKlPC/2LM9YOVC0Gvt8E90cYh3/7Vkh
 BU88SOje2Adw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="276145202"
Received: from drews-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.49.247])
  by orsmga003.jf.intel.com with ESMTP; 25 Jun 2020 13:21:54 -0700
Date:   Thu, 25 Jun 2020 23:21:48 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200625202148.GB15394@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200625172319.GJ20319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625172319.GJ20319@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 07:23:19PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > can be used by applications to set aside private regions of code and
> > data. The code outside the SGX hosted software entity is disallowed to
> > access the memory inside the enclave enforced by the CPU. We call these
> > entities as enclaves.
> > 
> > This commit implements a driver that provides an ioctl API to construct
> > and run enclaves. Enclaves are constructed from pages residing in
> > reserved physical memory areas. The contents of these pages can only be
> > accessed when they are mapped as part of an enclave, by a hardware
> > thread running inside the enclave.
> > 
> > The starting state of an enclave consists of a fixed measured set of
> > pages that are copied to the EPC during the construction process by
> > using ENCLS leaf functions and Software Enclave Control Structure (SECS)
> > that defines the enclave properties.
> > 
> > Enclave are constructed by using ENCLS leaf functions ECREATE, EADD and
> > EINIT. ECREATE initializes SECS, EADD copies pages from system memory to
> > the EPC and EINIT check a given signed measurement and moves the enclave
> > into a state ready for execution.
> > 
> > An initialized enclave can only be accessed through special Thread Control
> > Structure (TCS) pages by using ENCLU (ring-3 only) leaf EENTER.  This leaf
> > function converts a thread into enclave mode and continues the execution in
> > the offset defined by the TCS provided to EENTER. An enclave is exited
> > through syscall, exception, interrupts or by explicitly calling another
> > ENCLU leaf EEXIT.
> > 
> > The permissions, which enclave page is added will set the limit for maximum
> > permissions that can be set for mmap() and mprotect(). This will
> > effectively allow to build different security schemes between producers and
> > consumers of enclaves. Later on we can increase granularity with LSM hooks
> > for page addition (i.e. for producers) and mapping of the enclave (i.e. for
> > consumers)
> > 
> > Cc: linux-security-module@vger.kernel.org
> > Acked-by: Jethro Beekman <jethro@fortanix.com>
> > Tested-by: Jethro Beekman <jethro@fortanix.com>
> > Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
> > Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
> > Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
> > Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
> > Tested-by: Seth Moore <sethmo@google.com>
> > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
> >  arch/x86/include/uapi/asm/sgx.h               |  66 ++
> >  arch/x86/kernel/cpu/sgx/Makefile              |   3 +
> >  arch/x86/kernel/cpu/sgx/driver.c              | 194 +++++
> >  arch/x86/kernel/cpu/sgx/driver.h              |  30 +
> >  arch/x86/kernel/cpu/sgx/encl.c                | 335 +++++++++
> >  arch/x86/kernel/cpu/sgx/encl.h                |  87 +++
> >  arch/x86/kernel/cpu/sgx/ioctl.c               | 706 ++++++++++++++++++
> >  arch/x86/kernel/cpu/sgx/main.c                |  11 +
> >  9 files changed, 1433 insertions(+)
> >  create mode 100644 arch/x86/include/uapi/asm/sgx.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/driver.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/driver.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/encl.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/ioctl.c
> > 
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > index 59472cd6a11d..35f713e3a267 100644
> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -323,6 +323,7 @@ Code  Seq#    Include File                                           Comments
> >                                                                       <mailto:tlewis@mindspring.com>
> >  0xA3  90-9F  linux/dtlk.h
> >  0xA4  00-1F  uapi/linux/tee.h                                        Generic TEE subsystem
> > +0xA4  00-1F  uapi/asm/sgx.h                                          Intel SGX subsystem (a legit conflict as TEE and SGX do not co-exist)
> >  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
> >  0xAB  00-1F  linux/nbd.h
> >  0xAC  00-1F  linux/raw.h
> > diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> > new file mode 100644
> > index 000000000000..5edb08ab8fd0
> > --- /dev/null
> > +++ b/arch/x86/include/uapi/asm/sgx.h
> > @@ -0,0 +1,66 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */
> 
> Checkpatch complains here:
> 
> WARNING: 'SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */' is not supported in LICENSES/...
> #114: FILE: arch/x86/include/uapi/asm/sgx.h:1:
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */
> 
> Also, you had all patches until now split nice and logically doing one
> thing only.
> 
> But this one is huge. Why?
> 
> Why can't you split out the facilities which the driver uses: encl.[ch]
> into a patch, then ioctl.c into a separate one and then the driver into
> a third one? Or do they all belong together inseparably?
> 
> I guess I'll find out eventually but it would've been nice if they were
> split out...

It's still kind a strongly connected set of functionalities, but I get
your point.

I'd consider splitting for a slighly different angle:

1. Commit for the base driver.
2. Commit for each ioctl, adding the necessary "framework" to get that
   piece of functionality completed. The order would be:
   A. Create
   B. Add
   C. Initialize

Would be probably easier to review also this way because the commit kind
of rationalizes why things exist.

What do you think?

/Jarkko
 
 /Jarkko

/Jarkko
