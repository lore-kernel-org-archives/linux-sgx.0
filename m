Return-Path: <SRS0=kl42=BQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DB6C433E0
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 20:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0B82221E3
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 20:24:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H2TK/n+A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgHFUY7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 16:24:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59672 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFUY6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Aug 2020 16:24:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076FcZfS082632;
        Thu, 6 Aug 2020 15:42:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=B64yJzEBtX/oVoLcA/dsSb6u04OvEYco5diellQyjMM=;
 b=H2TK/n+AWUJEezajzx6zt6NErBDJWUVjm0T8NkGM290vQBJIVtZQQDuLf5vPy4OSpHXi
 ofkUHJY5/MY/DQhZX/MjsGkO0NfKaQcKuz6P5vIs7qQLcftRe7/PEi0/z+GOtWX2efRT
 EOSjD9/CRPTHOV8SU1cMro7akNyMyg4oRKlG2QBmfUq8uBmAOFMlRm0bH/qDmGk6tqWq
 uACU3vVVz40WKX3GlCoVepII8BwS18fWwDofTBmrMJiZ+uKDKLHKFHqbns5IhEzeDmIH
 8kPw+mwgOTQ7Eyi/VT/zi4qZdIXZF7dFjkoCUV7MMLc1JX1OSHwhNX8LfBAZMk3paymV Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32r6fxks78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 15:42:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076FdNd0013894;
        Thu, 6 Aug 2020 15:40:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32qy8nkv3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 15:40:33 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 076FeRc5002219;
        Thu, 6 Aug 2020 15:40:27 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 08:40:27 -0700
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id 5070FF08196; Thu,  6 Aug 2020 16:40:20 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
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
Subject: Re: [PATCH v36 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
In-Reply-To: <20200716135303.276442-13-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-13-jarkko.sakkinen@linux.intel.com>
Date:   Thu, 06 Aug 2020 16:40:20 +0100
Message-ID: <m2ft8zrdej.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 malwarescore=0
 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 suspectscore=5 spamscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060111
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thursday, 2020-07-16 at 16:52:51 +03, Jarkko Sakkinen wrote:
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

Tested-by: Darren Kenny <darren.kenny@oracle.com>
Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

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
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 59472cd6a11d..35f713e3a267 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -323,6 +323,7 @@ Code  Seq#    Include File                                           Comments
>                                                                       <mailto:tlewis@mindspring.com>
>  0xA3  90-9F  linux/dtlk.h
>  0xA4  00-1F  uapi/linux/tee.h                                        Generic TEE subsystem
> +0xA4  00-1F  uapi/asm/sgx.h                                          Intel SGX subsystem (a legit conflict as TEE and SGX do not co-exist)
>  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
>  0xAB  00-1F  linux/nbd.h
>  0xAC  00-1F  linux/raw.h
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> new file mode 100644
> index 000000000000..3787d278e84b
> --- /dev/null
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */
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
> diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
> index 3fc451120735..91d3dc784a29 100644
> --- a/arch/x86/kernel/cpu/sgx/Makefile
> +++ b/arch/x86/kernel/cpu/sgx/Makefile
> @@ -1,4 +1,5 @@
>  obj-y += \
>  	driver.o \
>  	encl.o \
> +	ioctl.o \
>  	main.o
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index b52520407f5b..5559bc18de41 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -118,10 +118,22 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
>  	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
>  }
>  
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
> diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
> index f7ce40dedc91..e4063923115b 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.h
> +++ b/arch/x86/kernel/cpu/sgx/driver.h
> @@ -9,6 +9,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/sched.h>
>  #include <linux/workqueue.h>
> +#include <uapi/asm/sgx.h>
>  #include "sgx.h"
>  
>  #define SGX_EINIT_SPIN_COUNT	20
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
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
> +		size = SGX_SSA_GPRS_SIZE + sgx_xsave_size_tbl[i];
> +
> +		if (miscselect & SGX_MISC_EXINFO)
> +			size += SGX_SSA_MISC_EXINFO_SIZE;
> +
> +		if (size > size_max)
> +			size_max = size;
> +	}
> +
> +	return PFN_UP(size_max);
> +}
> +
> +static int sgx_validate_secs(const struct sgx_secs *secs)
> +{
> +	u64 max_size = (secs->attributes & SGX_ATTR_MODE64BIT) ?
> +		       sgx_encl_size_max_64 : sgx_encl_size_max_32;
> +
> +	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
> +		return -EINVAL;
> +
> +	if (secs->base & (secs->size - 1))
> +		return -EINVAL;
> +
> +	if (secs->miscselect & sgx_misc_reserved_mask ||
> +	    secs->attributes & sgx_attributes_reserved_mask ||
> +	    secs->xfrm & sgx_xfrm_reserved_mask)
> +		return -EINVAL;
> +
> +	if (secs->size >= max_size)
> +		return -EINVAL;
> +
> +	if (!(secs->xfrm & XFEATURE_MASK_FP) ||
> +	    !(secs->xfrm & XFEATURE_MASK_SSE) ||
> +	    (((secs->xfrm >> XFEATURE_BNDREGS) & 1) !=
> +	     ((secs->xfrm >> XFEATURE_BNDCSR) & 1)))
> +		return -EINVAL;
> +
> +	if (!secs->ssa_frame_size)
> +		return -EINVAL;
> +
> +	if (sgx_calc_ssa_frame_size(secs->miscselect, secs->xfrm) >
> +	    secs->ssa_frame_size)
> +		return -EINVAL;
> +
> +	if (memchr_inv(secs->reserved1, 0, sizeof(secs->reserved1)) ||
> +	    memchr_inv(secs->reserved2, 0, sizeof(secs->reserved2)) ||
> +	    memchr_inv(secs->reserved3, 0, sizeof(secs->reserved3)) ||
> +	    memchr_inv(secs->reserved4, 0, sizeof(secs->reserved4)))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
> +{
> +	unsigned long encl_size = secs->size + PAGE_SIZE;
> +	struct sgx_epc_page *secs_epc;
> +	struct sgx_pageinfo pginfo;
> +	struct sgx_secinfo secinfo;
> +	struct file *backing;
> +	long ret;
> +
> +	if (sgx_validate_secs(secs)) {
> +		pr_debug("invalid SECS\n");
> +		return -EINVAL;
> +	}
> +
> +	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
> +				   VM_NORESERVE);
> +	if (IS_ERR(backing))
> +		return PTR_ERR(backing);
> +
> +	encl->backing = backing;
> +
> +	secs_epc = __sgx_alloc_epc_page();
> +	if (IS_ERR(secs_epc)) {
> +		ret = PTR_ERR(secs_epc);
> +		goto err_out_backing;
> +	}
> +
> +	encl->secs.epc_page = secs_epc;
> +
> +	pginfo.addr = 0;
> +	pginfo.contents = (unsigned long)secs;
> +	pginfo.metadata = (unsigned long)&secinfo;
> +	pginfo.secs = 0;
> +	memset(&secinfo, 0, sizeof(secinfo));
> +
> +	ret = __ecreate((void *)&pginfo, sgx_get_epc_addr(secs_epc));
> +	if (ret) {
> +		pr_debug("ECREATE returned %ld\n", ret);
> +		goto err_out;
> +	}
> +
> +	if (secs->attributes & SGX_ATTR_DEBUG)
> +		atomic_or(SGX_ENCL_DEBUG, &encl->flags);
> +
> +	encl->secs.encl = encl;
> +	encl->secs_attributes = secs->attributes;
> +	encl->allowed_attributes |= SGX_ATTR_ALLOWED_MASK;
> +	encl->base = secs->base;
> +	encl->size = secs->size;
> +	encl->ssaframesize = secs->ssa_frame_size;
> +
> +	/*
> +	 * Set SGX_ENCL_CREATED only after the enclave is fully prepped.  This
> +	 * allows setting and checking enclave creation without having to take
> +	 * encl->lock.
> +	 */
> +	atomic_or(SGX_ENCL_CREATED, &encl->flags);
> +
> +	return 0;
> +
> +err_out:
> +	sgx_free_epc_page(encl->secs.epc_page);
> +	encl->secs.epc_page = NULL;
> +
> +err_out_backing:
> +	fput(encl->backing);
> +	encl->backing = NULL;
> +
> +	return ret;
> +}
> +
> +/**
> + * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
> + * @filep:	open file to /dev/sgx
> + * @arg:	userspace pointer to a struct sgx_enclave_create instance
> + *
> + * Allocate kernel data structures for a new enclave and execute ECREATE after
> + * verifying the correctness of the provided SECS.
> + *
> + * Note, enforcement of restricted and disallowed attributes is deferred until
> + * sgx_ioc_enclave_init(), only the architectural correctness of the SECS is
> + * checked by sgx_ioc_enclave_create().
> + *
> + * Return:
> + *   0 on success,
> + *   -errno otherwise
> + */
> +static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
> +{
> +	struct sgx_enclave_create ecreate;
> +	struct page *secs_page;
> +	struct sgx_secs *secs;
> +	int ret;
> +
> +	if (atomic_read(&encl->flags) & SGX_ENCL_CREATED)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&ecreate, arg, sizeof(ecreate)))
> +		return -EFAULT;
> +
> +	secs_page = alloc_page(GFP_KERNEL);
> +	if (!secs_page)
> +		return -ENOMEM;
> +
> +	secs = kmap(secs_page);
> +	if (copy_from_user(secs, (void __user *)ecreate.src, sizeof(*secs))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	ret = sgx_encl_create(encl, secs);
> +
> +out:
> +	kunmap(secs_page);
> +	__free_page(secs_page);
> +	return ret;
> +}
> +
> +long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> +{
> +	struct sgx_encl *encl = filep->private_data;
> +	int ret, encl_flags;
> +
> +	encl_flags = atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags);
> +	if (encl_flags & SGX_ENCL_IOCTL)
> +		return -EBUSY;
> +
> +	if (encl_flags & SGX_ENCL_DEAD) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	switch (cmd) {
> +	case SGX_IOC_ENCLAVE_CREATE:
> +		ret = sgx_ioc_enclave_create(encl, (void __user *)arg);
> +		break;
> +	default:
> +		ret = -ENOIOCTLCMD;
> +		break;
> +	}
> +
> +out:
> +	atomic_andnot(SGX_ENCL_IOCTL, &encl->flags);
> +	return ret;
> +}
> -- 
> 2.25.1
