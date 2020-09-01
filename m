Return-Path: <SRS0=iwfX=CK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBC0C433E6
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Sep 2020 16:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7242520767
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Sep 2020 16:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgIAQlf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 1 Sep 2020 12:41:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:18936 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729988AbgIAQlX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 1 Sep 2020 12:41:23 -0400
IronPort-SDR: rK38O8rpd8fPOza5NPLDUWJL/vAS6sWQ4FRjqhl80kKpzlgdKSjDrSMf0OfCjFJwFbtfpDlKSK
 AGCQeDulUAMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9731"; a="175253659"
X-IronPort-AV: E=Sophos;i="5.76,379,1592895600"; 
   d="scan'208";a="175253659"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2020 09:41:22 -0700
IronPort-SDR: 097d6bKOysjxAh4dEtJg26RVYocU5CsZgMAqW7MQWKzV+snzWR4BYsX4eGJSDjNIIWeeVh+wKl
 muaH8j8Eutaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,379,1592895600"; 
   d="scan'208";a="477267075"
Received: from hhuan26-mobl1.amr.corp.intel.com ([10.255.33.198])
  by orsmga005.jf.intel.com with ESMTP; 01 Sep 2020 09:41:15 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     x86@kernel.org, linux-sgx@vger.kernel.org,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org,
        "Jethro Beekman" <jethro@fortanix.com>,
        "Chunyang Hui" <sanqian.hcy@antfin.com>,
        "Jordan Hand" <jorhand@linux.microsoft.com>,
        "Nathaniel McCallum" <npmccallum@redhat.com>,
        "Seth Moore" <sethmo@google.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "Suresh Siddha" <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, josh@joshtriplett.org,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v36 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-13-jarkko.sakkinen@linux.intel.com>
Date:   Tue, 01 Sep 2020 11:41:14 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0p9xohs2wjvjmi@hhuan26-mobl1.amr.corp.intel.com>
In-Reply-To: <20200716135303.276442-13-jarkko.sakkinen@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 16 Jul 2020 08:52:51 -0500, Jarkko Sakkinen  
<jarkko.sakkinen@linux.intel.com> wrote:

> Add an ioctl that performs ENCLS[ECREATE], which creates SGX Enclave
> Control Structure for the enclave. SECS contains attributes about the
> enclave that are used by the hardware and cannot be directly accessed by
> software, as SECS resides in the EPC.
>
> One essential field in SECS is a field that stores the SHA256 of the
> measured enclave pages. This field, MRENCLAVE, is initialized by the
> ECREATE instruction and updated by every EADD and EEXTEND operation.
> Finally, EINIT locks down the value.
>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Tested-by: Jethro Beekman <jethro@fortanix.com>
> Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
> Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
> Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
> Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
> Tested-by: Seth Moore <sethmo@google.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
>  arch/x86/include/uapi/asm/sgx.h               |  25 ++
>  arch/x86/kernel/cpu/sgx/Makefile              |   1 +
>  arch/x86/kernel/cpu/sgx/driver.c              |  12 +
>  arch/x86/kernel/cpu/sgx/driver.h              |   1 +
>  arch/x86/kernel/cpu/sgx/ioctl.c               | 226 ++++++++++++++++++
>  6 files changed, 266 insertions(+)
>  create mode 100644 arch/x86/include/uapi/asm/sgx.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/ioctl.c
>
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst  
> b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 59472cd6a11d..35f713e3a267 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -323,6 +323,7 @@ Code  Seq#    Include  
> File                                           Comments
>                                                                       <mailto:tlewis@mindspring.com>
>  0xA3  90-9F  linux/dtlk.h
>  0xA4  00-1F  uapi/linux/tee.h                                         
> Generic TEE subsystem
> +0xA4  00-1F  uapi/asm/sgx.h                                           
> Intel SGX subsystem (a legit conflict as TEE and SGX do not co-exist)
>  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
>  0xAB  00-1F  linux/nbd.h
>  0xAC  00-1F  linux/raw.h
> diff --git a/arch/x86/include/uapi/asm/sgx.h  
> b/arch/x86/include/uapi/asm/sgx.h
> new file mode 100644
> index 000000000000..3787d278e84b
> --- /dev/null
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH  
> Linux-syscall-note */
> +/*
> + * Copyright(c) 2016-19 Intel Corporation.
> + */
> +#ifndef _UAPI_ASM_X86_SGX_H
> +#define _UAPI_ASM_X86_SGX_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +#define SGX_MAGIC 0xA4
> +
> +#define SGX_IOC_ENCLAVE_CREATE \
> +	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
> +
> +/**
> + * struct sgx_enclave_create - parameter structure for the
> + *                             %SGX_IOC_ENCLAVE_CREATE ioctl
> + * @src:	address for the SECS page data
> + */
> +struct sgx_enclave_create  {
> +	__u64	src;
> +};
> +
> +#endif /* _UAPI_ASM_X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/Makefile  
> b/arch/x86/kernel/cpu/sgx/Makefile
> index 3fc451120735..91d3dc784a29 100644
> --- a/arch/x86/kernel/cpu/sgx/Makefile
> +++ b/arch/x86/kernel/cpu/sgx/Makefile
> @@ -1,4 +1,5 @@
>  obj-y += \
>  	driver.o \
>  	encl.o \
> +	ioctl.o \
>  	main.o
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c  
> b/arch/x86/kernel/cpu/sgx/driver.c
> index b52520407f5b..5559bc18de41 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -118,10 +118,22 @@ static unsigned long sgx_get_unmapped_area(struct  
> file *file,
>  	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
>  }
> +#ifdef CONFIG_COMPAT
> +static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
> +			      unsigned long arg)
> +{
> +	return sgx_ioctl(filep, cmd, arg);
> +}
> +#endif
> +
>  static const struct file_operations sgx_encl_fops = {
>  	.owner			= THIS_MODULE,
>  	.open			= sgx_open,
>  	.release		= sgx_release,
> +	.unlocked_ioctl		= sgx_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl		= sgx_compat_ioctl,
> +#endif
>  	.mmap			= sgx_mmap,
>  	.get_unmapped_area	= sgx_get_unmapped_area,
>  };
> diff --git a/arch/x86/kernel/cpu/sgx/driver.h  
> b/arch/x86/kernel/cpu/sgx/driver.h
> index f7ce40dedc91..e4063923115b 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.h
> +++ b/arch/x86/kernel/cpu/sgx/driver.h
> @@ -9,6 +9,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/sched.h>
>  #include <linux/workqueue.h>
> +#include <uapi/asm/sgx.h>
>  #include "sgx.h"
> #define SGX_EINIT_SPIN_COUNT	20
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c  
> b/arch/x86/kernel/cpu/sgx/ioctl.c
> new file mode 100644
> index 000000000000..7981c411b05a
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -0,0 +1,226 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-19 Intel Corporation.
> +
> +#include <asm/mman.h>
> +#include <linux/mman.h>
> +#include <linux/delay.h>
> +#include <linux/file.h>
> +#include <linux/hashtable.h>
> +#include <linux/highmem.h>
> +#include <linux/ratelimit.h>
> +#include <linux/sched/signal.h>
> +#include <linux/shmem_fs.h>
> +#include <linux/slab.h>
> +#include <linux/suspend.h>
> +#include "driver.h"
> +#include "encl.h"
> +#include "encls.h"
> +
> +static u32 sgx_calc_ssa_frame_size(u32 miscselect, u64 xfrm)
> +{
> +	u32 size_max = PAGE_SIZE;
> +	u32 size;
> +	int i;
> +
> +	for (i = 2; i < 64; i++) {
> +		if (!((1 << i) & xfrm))
> +			continue;
> +

Potential overflow for signed integer shift. Originally spotted and fixed  
in OOT from Colin I. K.: https://github.com/intel/linux-sgx-driver/pull/16

Thanks
Haitao
