Return-Path: <SRS0=MzOG=DK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F0EDC4363C
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 03:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01716206FA
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 03:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgJCDZF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Oct 2020 23:25:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:50788 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgJCDZF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Oct 2020 23:25:05 -0400
IronPort-SDR: Dt+sa7bQwSjTet1yBuoIsYczcXXcgFF2NHV0rIJ25UtLOiRDSBCO7vrwcnQE4FSHtcgyYTsunu
 5UAG8NlJdLvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9762"; a="163991979"
X-IronPort-AV: E=Sophos;i="5.77,330,1596524400"; 
   d="scan'208";a="163991979"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 20:25:00 -0700
IronPort-SDR: zzctGCZVC1CXy+ZYVMZeiE42q6+nOKGKyD/8BB5X+Se0m5aMD7w6bKHdezGU3GppzTXu1LSmUZ
 5h7CIjCo9Qeg==
X-IronPort-AV: E=Sophos;i="5.77,330,1596524400"; 
   d="scan'208";a="511971236"
Received: from srudgex-mobl.amr.corp.intel.com (HELO localhost) ([10.252.32.33])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 20:24:52 -0700
Date:   Sat, 3 Oct 2020 06:24:51 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20201003032439.GA626429@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-13-jarkko.sakkinen@linux.intel.com>
 <op.0rvxzr02wjvjmi@mqcpg7oapc828.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0rvxzr02wjvjmi@mqcpg7oapc828.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 02, 2020 at 07:23:55PM -0500, Haitao Huang wrote:
> On Tue, 15 Sep 2020 06:28:30 -0500, Jarkko Sakkinen
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
> > Tested-by: Darren Kenny <darren.kenny@oracle.com>
> > Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
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
> >  arch/x86/kernel/cpu/sgx/ioctl.c               | 220 ++++++++++++++++++
> >  6 files changed, 260 insertions(+)
> >  create mode 100644 arch/x86/include/uapi/asm/sgx.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/ioctl.c
> > 
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > index 2a198838fca9..a89e1c46a25a 100644
> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -323,6 +323,7 @@ Code  Seq#    Include File
> > Comments
> >                                                                       <mailto:tlewis@mindspring.com>
> >  0xA3  90-9F  linux/dtlk.h
> >  0xA4  00-1F  uapi/linux/tee.h
> > Generic TEE subsystem
> > +0xA4  00-1F  uapi/asm/sgx.h
> > <mailto:linux-sgx@vger.kernel.org>
> >  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
> >  0xAB  00-1F  linux/nbd.h
> >  0xAC  00-1F  linux/raw.h
> > diff --git a/arch/x86/include/uapi/asm/sgx.h
> > b/arch/x86/include/uapi/asm/sgx.h
> > new file mode 100644
> > index 000000000000..c75b375f3770
> > --- /dev/null
> > +++ b/arch/x86/include/uapi/asm/sgx.h
> > @@ -0,0 +1,25 @@
> > +/* SPDX-License-Identifier: ((GPL-2.0+ WITH Linux-syscall-note) OR
> > BSD-3-Clause) */
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
> > index f54da5f19c2b..7bdb49dfcca6 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver.c
> > @@ -114,10 +114,22 @@ static unsigned long sgx_get_unmapped_area(struct
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
> > index 000000000000..352a3c461812
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -0,0 +1,220 @@
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
> > +		size = SGX_SSA_GPRS_SIZE + sgx_xsave_size_tbl[i];
> > +
> > +		if (miscselect & SGX_MISC_EXINFO)
> > +			size += SGX_SSA_MISC_EXINFO_SIZE;
> > +
> > +		if (size > size_max)
> > +			size_max = size;
> > +	}
> > +
> > +	return PFN_UP(size_max);
> > +}
> > +
> > +static int sgx_validate_secs(const struct sgx_secs *secs)
> > +{
> > +	u64 max_size = (secs->attributes & SGX_ATTR_MODE64BIT) ?
> > +		       sgx_encl_size_max_64 : sgx_encl_size_max_32;
> > +
> > +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
> > +		return -EINVAL;
> > +
> > +	if (secs->base & (secs->size - 1))
> > +		return -EINVAL;
> > +
> > +	if (secs->miscselect & sgx_misc_reserved_mask ||
> > +	    secs->attributes & sgx_attributes_reserved_mask ||
> > +	    secs->xfrm & sgx_xfrm_reserved_mask)
> > +		return -EINVAL;
> > +
> 
> Attributes should not be enforced against what's available on platform but
> checked and enforced against the mask for enforcement in sigstruct. For
> example an enclave could opt to sign with AVX bit in xfrm, but still be
> loadable on a platform without it if the sigstruct->body.attributes_mask
> does not turn that bit on.
> 
> Suggest to remove the above check,and do following during EINIt in
> sgx_encl_init:
> 
> -       /* Check that the required attributes have been authorized. */
> +       /* Check that the requested attributes have been authorized. */

This is as bad and useless comment as the existing was. In the paragraph
you wrote above you state the things that are useful.

So: I'll take the code change and put the response above here instead
because it is says the right things :-) (maybe with very minor edit)

>         if (encl->secs_attributes & ~encl->allowed_attributes)
>                 return -EACCES;
> 
> +       /* Check that mandatory features are supported. */
> +       if (sigstruct->body.attributes & sigstruct->body.attributes_mask &
> +           sgx_attributes_reserved_mask)
> +               return -EINVAL;
> +       if (sigstruct->body.miscselect & sigstruct->body.misc_mask &
> +           sgx_misc_reserved_mask)
> +               return -EINVAL;
> +       if (sigstruct->body.xfrm & sigstruct->body.xfrm_mask &
> +           sgx_xfrm_reserved_mask)
> +               return -EINVAL;
> +
>         ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
> 
> Haitao

Thanks a lot!

/Jarkko
