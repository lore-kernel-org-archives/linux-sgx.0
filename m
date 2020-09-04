Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41241C43461
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 11:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17E1D214F1
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 11:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbgIDL4G (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:56:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:18862 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgIDL4E (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 07:56:04 -0400
IronPort-SDR: r6ms9fWef2U8iWfk3BrffXJwFKXqIfe9nGuuwsGWJSNoOkJ8NrIWURlOvQbE0bLrSUHcJS2NWw
 sNF7zEUJfy4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="137780964"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="137780964"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 04:56:02 -0700
IronPort-SDR: aZCKaJZwpyuOqsS9X/Mx39D0LYJ3IwvfBtppRR/RFrVVBbkRkbL4nWxh594vXYRhMGw1xocQwn
 rCgAj8bZXOQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="334861195"
Received: from pipper-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.56.104])
  by fmsmga002.fm.intel.com with ESMTP; 04 Sep 2020 04:55:56 -0700
Date:   Fri, 4 Sep 2020 14:55:55 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, josh@joshtriplett.org,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v36 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20200904115555.GA39023@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-13-jarkko.sakkinen@linux.intel.com>
 <op.0p9xohs2wjvjmi@hhuan26-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0p9xohs2wjvjmi@hhuan26-mobl1.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 01, 2020 at 11:41:14AM -0500, Haitao Huang wrote:
> On Thu, 16 Jul 2020 08:52:51 -0500, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> 
> > Add an ioctl that performs ENCLS[ECREATE], which creates SGX Enclave
> > Control Structure for the enclave. SECS contains attributes about the
> > enclave that are used by the hardware and cannot be directly accessed by
> > software, as SECS resides in the EPC.
> > 
> > One essential field in SECS is a field that stores the SHA256 of the
> > measured enclave pages. This field, MRENCLAVE, is initialized by the
> > ECREATE instruction and updated by every EADD and EEXTEND operation.
> > Finally, EINIT locks down the value.
> > 
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
> >  arch/x86/include/uapi/asm/sgx.h               |  25 ++
> >  arch/x86/kernel/cpu/sgx/Makefile              |   1 +
> >  arch/x86/kernel/cpu/sgx/driver.c              |  12 +
> >  arch/x86/kernel/cpu/sgx/driver.h              |   1 +
> >  arch/x86/kernel/cpu/sgx/ioctl.c               | 226 ++++++++++++++++++
> >  6 files changed, 266 insertions(+)
> >  create mode 100644 arch/x86/include/uapi/asm/sgx.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/ioctl.c
> > 
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > index 59472cd6a11d..35f713e3a267 100644
> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -323,6 +323,7 @@ Code  Seq#    Include File
> > Comments
> >                                                                       <mailto:tlewis@mindspring.com>
> >  0xA3  90-9F  linux/dtlk.h
> >  0xA4  00-1F  uapi/linux/tee.h
> > Generic TEE subsystem
> > +0xA4  00-1F  uapi/asm/sgx.h
> > Intel SGX subsystem (a legit conflict as TEE and SGX do not co-exist)
> >  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
> >  0xAB  00-1F  linux/nbd.h
> >  0xAC  00-1F  linux/raw.h
> > diff --git a/arch/x86/include/uapi/asm/sgx.h
> > b/arch/x86/include/uapi/asm/sgx.h
> > new file mode 100644
> > index 000000000000..3787d278e84b
> > --- /dev/null
> > +++ b/arch/x86/include/uapi/asm/sgx.h
> > @@ -0,0 +1,25 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH
> > Linux-syscall-note */
> > +/*
> > + * Copyright(c) 2016-19 Intel Corporation.
> > + */
> > +#ifndef _UAPI_ASM_X86_SGX_H
> > +#define _UAPI_ASM_X86_SGX_H
> > +
> > +#include <linux/types.h>
> > +#include <linux/ioctl.h>
> > +
> > +#define SGX_MAGIC 0xA4
> > +
> > +#define SGX_IOC_ENCLAVE_CREATE \
> > +	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
> > +
> > +/**
> > + * struct sgx_enclave_create - parameter structure for the
> > + *                             %SGX_IOC_ENCLAVE_CREATE ioctl
> > + * @src:	address for the SECS page data
> > + */
> > +struct sgx_enclave_create  {
> > +	__u64	src;
> > +};
> > +
> > +#endif /* _UAPI_ASM_X86_SGX_H */
> > diff --git a/arch/x86/kernel/cpu/sgx/Makefile
> > b/arch/x86/kernel/cpu/sgx/Makefile
> > index 3fc451120735..91d3dc784a29 100644
> > --- a/arch/x86/kernel/cpu/sgx/Makefile
> > +++ b/arch/x86/kernel/cpu/sgx/Makefile
> > @@ -1,4 +1,5 @@
> >  obj-y += \
> >  	driver.o \
> >  	encl.o \
> > +	ioctl.o \
> >  	main.o
> > diff --git a/arch/x86/kernel/cpu/sgx/driver.c
> > b/arch/x86/kernel/cpu/sgx/driver.c
> > index b52520407f5b..5559bc18de41 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver.c
> > @@ -118,10 +118,22 @@ static unsigned long sgx_get_unmapped_area(struct
> > file *file,
> >  	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
> >  }
> > +#ifdef CONFIG_COMPAT
> > +static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
> > +			      unsigned long arg)
> > +{
> > +	return sgx_ioctl(filep, cmd, arg);
> > +}
> > +#endif
> > +
> >  static const struct file_operations sgx_encl_fops = {
> >  	.owner			= THIS_MODULE,
> >  	.open			= sgx_open,
> >  	.release		= sgx_release,
> > +	.unlocked_ioctl		= sgx_ioctl,
> > +#ifdef CONFIG_COMPAT
> > +	.compat_ioctl		= sgx_compat_ioctl,
> > +#endif
> >  	.mmap			= sgx_mmap,
> >  	.get_unmapped_area	= sgx_get_unmapped_area,
> >  };
> > diff --git a/arch/x86/kernel/cpu/sgx/driver.h
> > b/arch/x86/kernel/cpu/sgx/driver.h
> > index f7ce40dedc91..e4063923115b 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver.h
> > +++ b/arch/x86/kernel/cpu/sgx/driver.h
> > @@ -9,6 +9,7 @@
> >  #include <linux/rwsem.h>
> >  #include <linux/sched.h>
> >  #include <linux/workqueue.h>
> > +#include <uapi/asm/sgx.h>
> >  #include "sgx.h"
> > #define SGX_EINIT_SPIN_COUNT	20
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c
> > b/arch/x86/kernel/cpu/sgx/ioctl.c
> > new file mode 100644
> > index 000000000000..7981c411b05a
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -0,0 +1,226 @@
> > +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> > +// Copyright(c) 2016-19 Intel Corporation.
> > +
> > +#include <asm/mman.h>
> > +#include <linux/mman.h>
> > +#include <linux/delay.h>
> > +#include <linux/file.h>
> > +#include <linux/hashtable.h>
> > +#include <linux/highmem.h>
> > +#include <linux/ratelimit.h>
> > +#include <linux/sched/signal.h>
> > +#include <linux/shmem_fs.h>
> > +#include <linux/slab.h>
> > +#include <linux/suspend.h>
> > +#include "driver.h"
> > +#include "encl.h"
> > +#include "encls.h"
> > +
> > +static u32 sgx_calc_ssa_frame_size(u32 miscselect, u64 xfrm)
> > +{
> > +	u32 size_max = PAGE_SIZE;
> > +	u32 size;
> > +	int i;
> > +
> > +	for (i = 2; i < 64; i++) {
> > +		if (!((1 << i) & xfrm))
> > +			continue;
> > +
> 
> Potential overflow for signed integer shift. Originally spotted and fixed in
> OOT from Colin I. K.: https://github.com/intel/linux-sgx-driver/pull/16
> 
> Thanks
> Haitao

Thank you. It is true that this also applies to the mainline SGX.

I fixed this and added this entry to v37 changelog:

* Fixed signed integer shift overflow.
  https://github.com/intel/linux-sgx-driver/pull/16/commits/d27ca6071b2b28e2e789d265eda796dd9fc65a64

/Jarkko
