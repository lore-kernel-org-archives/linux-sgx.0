Return-Path: <SRS0=vqpH=RW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0C6C43381
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Mar 2019 21:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FBF120850
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Mar 2019 21:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfCSVTx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:19:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:24927 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbfCSVTw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 19 Mar 2019 17:19:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Mar 2019 14:19:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,246,1549958400"; 
   d="scan'208";a="142102917"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Mar 2019 14:19:51 -0700
Date:   Tue, 19 Mar 2019 14:19:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190319211951.GI25575@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Mar 17, 2019 at 11:14:45PM +0200, Jarkko Sakkinen wrote:
> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the enclave is disallowed to access the memory
> inside the enclave by the CPU access control.
> 
> This commit adds the Linux SGX Enclave Driver that provides an ioctl API
> to manage enclaves. The address range for an enclave, commonly referred
> as ELRANGE in the documentation (e.g. Intel SDM), is reserved with
> mmap() against /dev/sgx. After that a set ioctls is used to build
> the enclave to the ELRANGE.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
> Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  Documentation/ioctl/ioctl-number.txt    |   1 +
>  arch/x86/Kconfig                        |  17 +-
>  arch/x86/include/uapi/asm/sgx.h         |  59 ++
>  arch/x86/kernel/cpu/sgx/Makefile        |   5 +-
>  arch/x86/kernel/cpu/sgx/driver/Makefile |   3 +
>  arch/x86/kernel/cpu/sgx/driver/driver.h |  38 ++
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c  | 795 ++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/driver/main.c   | 290 +++++++++
>  arch/x86/kernel/cpu/sgx/encl.c          | 358 +++++++++++
>  arch/x86/kernel/cpu/sgx/encl.h          |  88 +++
>  arch/x86/kernel/cpu/sgx/encls.c         |   1 +
>  arch/x86/kernel/cpu/sgx/main.c          |   3 +
>  arch/x86/kernel/cpu/sgx/sgx.h           |   1 +
>  13 files changed, 1657 insertions(+), 2 deletions(-)
>  create mode 100644 arch/x86/include/uapi/asm/sgx.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver/Makefile
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver/driver.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver/ioctl.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver/main.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.h
> 
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index c9558146ac58..ef2694221cd0 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -312,6 +312,7 @@ Code  Seq#(hex)	Include File		Comments
>  					<mailto:tlewis@mindspring.com>
>  0xA3	90-9F	linux/dtlk.h
>  0xA4	00-1F	uapi/linux/tee.h	Generic TEE subsystem
> +0xA4	00-02	uapi/asm/sgx.h		conflict!
>  0xAA	00-3F	linux/uapi/linux/userfaultfd.h
>  0xAB	00-1F	linux/nbd.h
>  0xAC	00-1F	linux/raw.h
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index dc630208003f..34257b5659cc 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1925,7 +1925,6 @@ config INTEL_SGX
>  	bool "Intel SGX core functionality"
>  	depends on X86_64 && CPU_SUP_INTEL
>  	help
> -

Spurious whitespace change.

>  	Intel(R) SGX is a set of CPU instructions that can be used by
>  	applications to set aside private regions of code and data.  The code
>  	outside the enclave is disallowed to access the memory inside the
> @@ -1940,6 +1939,22 @@ config INTEL_SGX
>  
>  	If unsure, say N.
>  
> +config INTEL_SGX_DRIVER
> +	tristate "Intel(R) SGX Driver"
> +	default n
> +	depends on X86_64 && CPU_SUP_INTEL && INTEL_SGX
> +	select MMU_NOTIFIER
> +	select CRYPTO
> +	select CRYPTO_SHA256
> +	help
> +	This options enables the kernel SGX driver that allows to construct
> +	enclaves to the process memory by using a device node (by default
> +	/dev/sgx) and a set of ioctls. The driver requires that the MSRs
> +	specifying the public key hash for the launch enclave are writable so
> +	that Linux has the full control to run enclaves.
> +
> +	For details, see Documentation/x86/intel_sgx.rst
> +
>  config EFI
>  	bool "EFI runtime service support"
>  	depends on ACPI
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> new file mode 100644
> index 000000000000..aadf9c76e360
> --- /dev/null
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -0,0 +1,59 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +/**
> + * Copyright(c) 2016-18 Intel Corporation.
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
> +#define SGX_IOC_ENCLAVE_ADD_PAGE \
> +	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
> +#define SGX_IOC_ENCLAVE_INIT \
> +	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> +
> +/* IOCTL return values */
> +#define SGX_POWER_LOST_ENCLAVE		0x40000000

IMO we should get rid of SGX_POWER_LOST_ENCLAVE and the SUSPEND flag.

  - Userspace needs to handle -EFAULT cleanly even if we hook into
    suspend/hibernate via sgx_encl_pm_notifier(), e.g. to handle virtual
    machine migration.
  - In the event that suspend is canceled after sgx_encl_pm_notifier()
    runs, we'll have prematurely invalidated the enclave.
  - Invalidating all enclaves could be slow on a system with GBs of EPC,
    i.e. probably not the best thing to do in the suspend path.

Removing SGX_POWER_LOST_ENCLAVE means we can drop all of the pm_notifier()
code, which will likely save us a bit of maintenance down the line.

> +
> +/**
> + * struct sgx_enclave_create - parameter structure for the
> + *                             %SGX_IOC_ENCLAVE_CREATE ioctl
> + * @src:	address for the SECS page data
> + */
> +struct sgx_enclave_create  {
> +	__u64	src;
> +};

...

> diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
> new file mode 100644
> index 000000000000..b736411b5317
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +/**
> + * Copyright(c) 2016-19 Intel Corporation.
> + */
> +#ifndef __ARCH_INTEL_SGX_H__
> +#define __ARCH_INTEL_SGX_H__
> +
> +#include <crypto/hash.h>
> +#include <linux/kref.h>
> +#include <linux/mmu_notifier.h>
> +#include <linux/radix-tree.h>
> +#include <linux/rwsem.h>
> +#include <linux/sched.h>
> +#include <linux/workqueue.h>
> +#include <uapi/asm/sgx.h>
> +#include "../arch.h"
> +#include "../encl.h"
> +#include "../encls.h"
> +#include "../sgx.h"

Yuck.  If we remove the driver specific Makefile then we can eliminate
the "../" prefix here.  E.g. in the main SGX Makefile:

obj-$(CONFIG_INTEL_SGX_DRIVER) += driver/main.o driver/ioctl.o

> +#define SGX_DRV_NR_DEVICES	1
> +#define SGX_EINIT_SPIN_COUNT	20
> +#define SGX_EINIT_SLEEP_COUNT	50
> +#define SGX_EINIT_SLEEP_TIME	20
> +
> +extern struct workqueue_struct *sgx_encl_wq;
> +extern u64 sgx_encl_size_max_32;
> +extern u64 sgx_encl_size_max_64;
> +extern u32 sgx_misc_reserved_mask;
> +extern u64 sgx_attributes_reserved_mask;
> +extern u64 sgx_xfrm_reserved_mask;
> +extern u32 sgx_xsave_size_tbl[64];
> +
> +extern const struct file_operations sgx_fs_provision_fops;
> +
> +long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
> +
> +#endif /* __ARCH_X86_INTEL_SGX_H__ */
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> new file mode 100644
> index 000000000000..4b9a91b53b50
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c

...

> +static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
> +			     void *data, struct sgx_secinfo *secinfo,
> +			     unsigned int mrmask)
> +{
> +	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
> +	struct sgx_encl_page *encl_page;
> +	int ret;
> +
> +	if (sgx_validate_secinfo(secinfo))
> +		return -EINVAL;
> +	if (page_type == SGX_SECINFO_TCS) {

Should we validate page_type itself?

> +		ret = sgx_validate_tcs(encl, data);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	mutex_lock(&encl->lock);
> +
> +	if (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	encl_page = sgx_encl_page_alloc(encl, addr);
> +	if (IS_ERR(encl_page)) {
> +		ret = PTR_ERR(encl_page);
> +		goto out;
> +	}
> +
> +	ret = __sgx_encl_add_page(encl, encl_page, data, secinfo, mrmask);
> +	if (ret) {
> +		radix_tree_delete(&encl_page->encl->page_tree,
> +				  PFN_DOWN(encl_page->desc));
> +		kfree(encl_page);
> +	}
> +
> +out:
> +	mutex_unlock(&encl->lock);
> +	return ret;
> +}

...

> +static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
> +			 struct sgx_einittoken *token)
> +{
> +	u64 mrsigner[4];
> +	int ret;
> +	int i;
> +	int j;

These can be on a single line, e.g.: "int ret, i, j;".

> +
> +	/* Check that the required attributes have been authorized. */
> +	if (encl->secs_attributes & ~encl->allowed_attributes)
> +		return -EINVAL;
> +
> +	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
> +	if (ret)
> +		return ret;
> +
> +	flush_work(&encl->work);
> +
> +	mutex_lock(&encl->lock);
> +
> +	if (encl->flags & SGX_ENCL_INITIALIZED)
> +		goto err_out;
> +
> +	if (encl->flags & SGX_ENCL_DEAD) {
> +		ret = -EFAULT;
> +		goto err_out;
> +	}
> +
> +	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
> +		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
> +			ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
> +					mrsigner);
> +			if (ret == SGX_UNMASKED_EVENT)
> +				continue;
> +			else
> +				break;
> +		}
> +
> +		if (ret != SGX_UNMASKED_EVENT)
> +			break;
> +
> +		msleep_interruptible(SGX_EINIT_SLEEP_TIME);
> +
> +		if (signal_pending(current)) {
> +			ret = -ERESTARTSYS;
> +			goto err_out;
> +		}
> +	}
> +
> +	if (encls_faulted(ret)) {
> +		if (encls_failed(ret))
> +			ENCLS_WARN(ret, "EINIT");
> +
> +		sgx_encl_destroy(encl);
> +		ret = -EFAULT;
> +	} else if (encls_returned_code(ret)) {
> +		pr_debug("EINIT returned %d\n", ret);
> +	} else {
> +		encl->flags |= SGX_ENCL_INITIALIZED;
> +	}
> +
> +err_out:
> +	mutex_unlock(&encl->lock);
> +	return ret;
> +}

...

> diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
> new file mode 100644
> index 000000000000..16f36cd0af04
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/driver/main.c
> @@ -0,0 +1,290 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-18 Intel Corporation.
> +
> +#include <linux/acpi.h>
> +#include <linux/cdev.h>
> +#include <linux/mman.h>
> +#include <linux/platform_device.h>
> +#include <linux/security.h>
> +#include <linux/suspend.h>
> +#include <asm/traps.h>
> +#include "driver.h"
> +
> +MODULE_DESCRIPTION("Intel SGX Enclave Driver");
> +MODULE_AUTHOR("Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>");
> +MODULE_LICENSE("Dual BSD/GPL");

...

> +static const struct file_operations sgx_ctrl_fops = {

Why sgx_ctrl_fops instead of e.g. sgx_dev_fops, sgx_device_fops,
sgx_driver_fops, etc...

> +	.owner			= THIS_MODULE,
> +	.unlocked_ioctl		= sgx_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl		= sgx_compat_ioctl,
> +#endif
> +	.mmap			= sgx_mmap,
> +	.get_unmapped_area	= sgx_get_unmapped_area,
> +};
> +
> +static struct bus_type sgx_bus_type = {
> +	.name	= "sgx",
> +};
> +
> +static char *sgx_devnode(struct device *dev, umode_t *mode,
> +			 kuid_t *uid, kgid_t *gid)
> +{
> +	if (mode)
> +		*mode = 0666;
> +	return kasprintf(GFP_KERNEL, "sgx");
> +}
> +
> +static const struct device_type sgx_device_type = {
> +	.name = "sgx",
> +	.devnode = sgx_devnode,
> +};
> +
> +struct sgx_dev_ctx {
> +	struct device ctrl_dev;
> +	struct cdev ctrl_cdev;
> +};
> +
> +static dev_t sgx_devt;
> +
> +static void sgx_dev_release(struct device *dev)
> +{
> +	struct sgx_dev_ctx *ctx = container_of(dev, struct sgx_dev_ctx,
> +					       ctrl_dev);
> +
> +	kfree(ctx);
> +}
> +
> +static struct sgx_dev_ctx *sgx_dev_ctx_alloc(struct device *parent)
> +{
> +	struct sgx_dev_ctx *ctx;
> +	int ret;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return ERR_PTR(-ENOMEM);
> +
> +	device_initialize(&ctx->ctrl_dev);
> +
> +	ctx->ctrl_dev.bus = &sgx_bus_type;
> +	ctx->ctrl_dev.type = &sgx_device_type;
> +	ctx->ctrl_dev.parent = parent;
> +	ctx->ctrl_dev.devt = MKDEV(MAJOR(sgx_devt), 0);
> +	ctx->ctrl_dev.release = sgx_dev_release;
> +
> +	ret = dev_set_name(&ctx->ctrl_dev, "sgx");
> +	if (ret) {
> +		put_device(&ctx->ctrl_dev);
> +		return ERR_PTR(ret);
> +	}
> +
> +	cdev_init(&ctx->ctrl_cdev, &sgx_ctrl_fops);
> +	ctx->ctrl_cdev.owner = THIS_MODULE;
> +
> +	dev_set_drvdata(parent, ctx);
> +
> +	return ctx;
> +}
> +
> +static struct sgx_dev_ctx *sgxm_dev_ctx_alloc(struct device *parent)
> +{
> +	struct sgx_dev_ctx *ctx;
> +	int rc;
> +
> +	ctx = sgx_dev_ctx_alloc(parent);
> +	if (IS_ERR(ctx))
> +		return ctx;
> +
> +	rc = devm_add_action_or_reset(parent, (void (*)(void *))put_device,
> +				      &ctx->ctrl_dev);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	return ctx;
> +}
> +
> +static int sgx_dev_init(struct device *parent)
> +{
> +	struct sgx_dev_ctx *sgx_dev;
> +	unsigned int eax;
> +	unsigned int ebx;
> +	unsigned int ecx;
> +	unsigned int edx;
> +	u64 attr_mask;
> +	u64 xfrm_mask;
> +	int ret;
> +	int i;
> +
> +	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
> +	sgx_misc_reserved_mask = ~ebx | SGX_MISC_RESERVED_MASK;
> +	sgx_encl_size_max_64 = 1ULL << ((edx >> 8) & 0xFF);
> +	sgx_encl_size_max_32 = 1ULL << (edx & 0xFF);
> +
> +	cpuid_count(SGX_CPUID, 1, &eax, &ebx, &ecx, &edx);
> +
> +	attr_mask = (((u64)ebx) << 32) + (u64)eax;
> +	sgx_attributes_reserved_mask = ~attr_mask | SGX_ATTR_RESERVED_MASK;
> +
> +	if (boot_cpu_has(X86_FEATURE_OSXSAVE)) {
> +		xfrm_mask = (((u64)edx) << 32) + (u64)ecx;
> +
> +		for (i = 2; i < 64; i++) {
> +			cpuid_count(0x0D, i, &eax, &ebx, &ecx, &edx);
> +			if ((1 << i) & xfrm_mask)
> +				sgx_xsave_size_tbl[i] = eax + ebx;
> +		}
> +
> +		sgx_xfrm_reserved_mask = ~xfrm_mask;
> +	}
> +
> +	sgx_dev = sgxm_dev_ctx_alloc(parent);
> +	if (IS_ERR(sgx_dev))
> +		return PTR_ERR(sgx_dev);
> +
> +	sgx_encl_wq = alloc_workqueue("sgx-encl-wq",
> +				      WQ_UNBOUND | WQ_FREEZABLE, 1);
> +	if (!sgx_encl_wq)
> +		return -ENOMEM;
> +
> +	ret = cdev_device_add(&sgx_dev->ctrl_cdev, &sgx_dev->ctrl_dev);
> +	if (ret)
> +		goto err_device_add;
> +
> +	return 0;
> +
> +err_device_add:
> +	destroy_workqueue(sgx_encl_wq);
> +	return ret;
> +}
> +
> +static int sgx_drv_probe(struct platform_device *pdev)
> +{
> +	if (!sgx_enabled) {
> +		pr_info("sgx: SGX is not enabled in the core\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
> +		pr_info("sgx: The public key MSRs are not writable\n");
> +		return -ENODEV;
> +	}
> +
> +	return sgx_dev_init(&pdev->dev);
> +}
> +
> +static int sgx_drv_remove(struct platform_device *pdev)
> +{
> +	struct sgx_dev_ctx *ctx = dev_get_drvdata(&pdev->dev);
> +
> +	cdev_device_del(&ctx->ctrl_cdev, &ctx->ctrl_dev);
> +	destroy_workqueue(sgx_encl_wq);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_ACPI
> +static struct acpi_device_id sgx_device_ids[] = {
> +	{"INT0E0C", 0},
> +	{"", 0},
> +};
> +MODULE_DEVICE_TABLE(acpi, sgx_device_ids);
> +#endif
> +
> +static struct platform_driver sgx_drv = {
> +	.probe = sgx_drv_probe,
> +	.remove = sgx_drv_remove,
> +	.driver = {
> +		.name			= "sgx",
> +		.acpi_match_table	= ACPI_PTR(sgx_device_ids),
> +	},
> +};

Utilizing the platform driver is unnecessary, adds complexity and IMO is
flat out wrong given the current direction of implementing SGX as a
full-blooded architectural feature.

  - All hardware information is readily available via CPUID
  - arch_initcall hooks obviates the need for ACPI autoprobe
  - EPC manager assumes it has full control over all EPC, i.e. EPC
    sections are not managed as independent "devices"
  - BIOS will enumerate a single ACPI entry regardless of the number
    of EPC sections, i.e. the ACPI entry is *only* useful for probing
  - Userspace driver matches the EPC device, but doesn't actually
    "own" the EPC

> +
> +static int __init sgx_drv_subsys_init(void)
> +{
> +     int ret;
> +
> +     ret = bus_register(&sgx_bus_type);

Do we really need a bus/class?  Allocating a chrdev region also seems like
overkill.  At this point there is exactly one SGX device, and while there
is a pretty good chance we'll end up with a virtualization specific device
for exposing EPC to guest, there's no guarantee said device will be SGX
specific.  Using a dynamic miscdevice would eliminate a big chunk of code.

> +	if (ret)
> +		return ret;
> +
> +	ret = alloc_chrdev_region(&sgx_devt, 0, SGX_DRV_NR_DEVICES, "sgx");
> +	if (ret < 0) {
> +		bus_unregister(&sgx_bus_type);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void sgx_drv_subsys_exit(void)
> +{
> +	bus_unregister(&sgx_bus_type);
> +	unregister_chrdev_region(sgx_devt, SGX_DRV_NR_DEVICES);
> +}
> +
> +static int __init sgx_drv_init(void)
> +{
> +	int ret;
> +
> +	ret = sgx_drv_subsys_init();
> +	if (ret)
> +		return ret;
> +
> +	ret = platform_driver_register(&sgx_drv);
> +	if (ret)
> +		sgx_drv_subsys_exit();
> +
> +	return ret;
> +}
> +module_init(sgx_drv_init);
> +
> +static void __exit sgx_drv_exit(void)
> +{
> +	platform_driver_unregister(&sgx_drv);
> +	sgx_drv_subsys_exit();
> +}
> +module_exit(sgx_drv_exit);
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> new file mode 100644
> index 000000000000..bd8bcd748976
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -0,0 +1,358 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-18 Intel Corporation.
> +
> +#include <linux/mm.h>
> +#include <linux/shmem_fs.h>
> +#include <linux/suspend.h>
> +#include <linux/sched/mm.h>
> +#include "arch.h"
> +#include "encl.h"
> +#include "sgx.h"
> +
> +static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
> +						unsigned long addr)
> +{
> +	struct sgx_encl_page *entry;
> +
> +	/* If process was forked, VMA is still there but vm_private_data is set
> +	 * to NULL.
> +	 */
> +	if (!encl)
> +		return ERR_PTR(-EFAULT);
> +
> +	if ((encl->flags & SGX_ENCL_DEAD) ||
> +	    !(encl->flags & SGX_ENCL_INITIALIZED))
> +		return ERR_PTR(-EFAULT);
> +
> +	entry = radix_tree_lookup(&encl->page_tree, addr >> PAGE_SHIFT);
> +	if (!entry)
> +		return ERR_PTR(-EFAULT);
> +
> +	/* Page is already resident in the EPC. */
> +	if (entry->epc_page)
> +		return entry;
> +
> +	return ERR_PTR(-EFAULT);
> +}
> +
> +static struct sgx_encl_mm *sgx_encl_get_mm(struct sgx_encl *encl,
> +					   struct mm_struct *mm)
> +{
> +	struct sgx_encl_mm *next_mm = NULL;
> +	struct sgx_encl_mm *prev_mm = NULL;
> +	int iter;
> +
> +	while (true) {
> +		next_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
> +		if (prev_mm) {
> +			mmdrop(prev_mm->mm);
> +			kref_put(&prev_mm->refcount, sgx_encl_release_mm);
> +		}
> +		prev_mm = next_mm;
> +
> +		if (iter == SGX_ENCL_MM_ITER_DONE)
> +			break;
> +
> +		if (iter == SGX_ENCL_MM_ITER_RESTART)
> +			continue;
> +
> +		if (mm == next_mm->mm)
> +			return next_mm;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void sgx_vma_open(struct vm_area_struct *vma)
> +{
> +	struct sgx_encl *encl = vma->vm_private_data;
> +	struct sgx_encl_mm *mm;
> +
> +	if (!encl)
> +		return;
> +
> +	if (encl->flags & SGX_ENCL_DEAD)
> +		goto out;
> +
> +	mm = sgx_encl_get_mm(encl, vma->vm_mm);
> +	if (!mm) {
> +		mm = kzalloc(sizeof(*mm), GFP_KERNEL);
> +		if (!mm) {
> +			encl->flags |= SGX_ENCL_DEAD;

Failure to allocate memory for one user of the enclave shouldn't kill
the enclave, e.g. failing during fork() shouldn't kill the enclave in
the the parent.  And marking an enclave dead without holding its lock
is all kinds of bad.

> +			goto out;
> +		}
> +
> +		spin_lock(&encl->mm_lock);
> +		mm->encl = encl;
> +		mm->mm = vma->vm_mm;
> +		list_add(&mm->list, &encl->mm_list);
> +		kref_init(&mm->refcount);

Not that it truly matters, but list_add() is the only thing that needs
to be protected with the spinlock, everything else can be done ahead of
time.

> +		spin_unlock(&encl->mm_lock);
> +	} else {
> +		mmdrop(mm->mm);
> +	}
> +
> +out:
> +	kref_get(&encl->refcount);
> +}
> +
> +static void sgx_vma_close(struct vm_area_struct *vma)
> +{
> +	struct sgx_encl *encl = vma->vm_private_data;
> +	struct sgx_encl_mm *mm;
> +
> +	if (!encl)
> +		return;
> +
> +	mm = sgx_encl_get_mm(encl, vma->vm_mm);

Isn't this unnecessary?  sgx_vma_open() had to have been called on this
VMA, otherwise we wouldn't be here.

> +	if (mm) {
> +		mmdrop(mm->mm);
> +		kref_put(&mm->refcount, sgx_encl_release_mm);
> +
> +		/* Release kref for the VMA. */
> +		kref_put(&mm->refcount, sgx_encl_release_mm);
> +	}
> +
> +	kref_put(&encl->refcount, sgx_encl_release);
> +}
> +
> +static unsigned int sgx_vma_fault(struct vm_fault *vmf)
> +{
> +	unsigned long addr = (unsigned long)vmf->address;
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct sgx_encl *encl = vma->vm_private_data;
> +	struct sgx_encl_page *entry;
> +	int ret = VM_FAULT_NOPAGE;
> +	struct sgx_encl_mm *mm;
> +	unsigned long pfn;
> +
> +	mm = sgx_encl_get_mm(encl, vma->vm_mm);
> +	if (!mm)
> +		return VM_FAULT_SIGBUS;
> +
> +	mmdrop(mm->mm);
> +	kref_put(&mm->refcount, sgx_encl_release_mm);

Again, is retrieving the sgx_encl_mm necessary?  Isn't it impossible to
get here unless the vma has an reference to the enclave?  I.e. it should
be impossible to fault before open() or after close().

Dropping sgx_encl_get_mm() from both sgx_vma_close() and sgx_vma_fault()
would mean sgx_vma_open() is the only user (as of this patch), i.e. can
open code walking through the list and wouldn't need to confusing
mmdrop().  It'd be even cleaner if we can use an RCU list.

> +
> +	mutex_lock(&encl->lock);
> +
> +	entry = sgx_encl_load_page(encl, addr);
> +	if (IS_ERR(entry)) {
> +		if (unlikely(PTR_ERR(entry) != -EBUSY))
> +			ret = VM_FAULT_SIGBUS;
> +
> +		goto out;
> +	}
> +
> +	if (!follow_pfn(vma, addr, &pfn))
> +		goto out;
> +
> +	ret = vmf_insert_pfn(vma, addr, PFN_DOWN(entry->epc_page->desc));
> +	if (ret != VM_FAULT_NOPAGE) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out;
> +	}
> +
> +out:
> +	mutex_unlock(&encl->lock);
> +	return ret;
> +}
> +
> +const struct vm_operations_struct sgx_vm_ops = {
> +	.close = sgx_vma_close,
> +	.open = sgx_vma_open,
> +	.fault = sgx_vma_fault,
> +};
> +EXPORT_SYMBOL_GPL(sgx_vm_ops);
> +
> +/**
> + * sgx_encl_find - find an enclave
> + * @mm:		mm struct of the current process
> + * @addr:	address in the ELRANGE
> + * @vma:	the resulting VMA
> + *
> + * Find an enclave identified by the given address. Give back a VMA that is
> + * part of the enclave and located in that address. The VMA is given back if it
> + * is a proper enclave VMA even if an &sgx_encl instance does not exist yet
> + * (enclave creation has not been performed).
> + *
> + * Return:
> + *   0 on success,
> + *   -EINVAL if an enclave was not found,
> + *   -ENOENT if the enclave has not been created yet
> + */
> +int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
> +		  struct vm_area_struct **vma)
> +{
> +	struct vm_area_struct *result;
> +	struct sgx_encl *encl;
> +
> +	result = find_vma(mm, addr);
> +	if (!result || result->vm_ops != &sgx_vm_ops || addr < result->vm_start)
> +		return -EINVAL;
> +
> +	encl = result->vm_private_data;
> +	*vma = result;
> +
> +	return encl ? 0 : -ENOENT;
> +}
> +EXPORT_SYMBOL_GPL(sgx_encl_find);
> +
> +/**
> + * sgx_encl_destroy() - destroy enclave resources
> + * @encl:	an &sgx_encl instance
> + */
> +void sgx_encl_destroy(struct sgx_encl *encl)
> +{
> +	struct sgx_encl_page *entry;
> +	struct radix_tree_iter iter;
> +	void **slot;
> +
> +	encl->flags |= SGX_ENCL_DEAD;
> +
> +	radix_tree_for_each_slot(slot, &encl->page_tree, &iter, 0) {
> +		entry = *slot;
> +		if (entry->epc_page) {
> +			if (!__sgx_free_page(entry->epc_page)) {
> +				encl->secs_child_cnt--;
> +				entry->epc_page = NULL;
> +
> +			}
> +
> +			radix_tree_delete(&entry->encl->page_tree,
> +					  PFN_DOWN(entry->desc));
> +		}
> +	}
> +
> +	if (!encl->secs_child_cnt && encl->secs.epc_page) {
> +		sgx_free_page(encl->secs.epc_page);
> +		encl->secs.epc_page = NULL;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(sgx_encl_destroy);
> +
> +/**
> + * sgx_encl_release - Destroy an enclave instance
> + * @kref:	address of a kref inside &sgx_encl
> + *
> + * Used together with kref_put(). Frees all the resources associated with the
> + * enclave and the instance itself.
> + */
> +void sgx_encl_release(struct kref *ref)
> +{
> +	struct sgx_encl *encl = container_of(ref, struct sgx_encl, refcount);
> +	struct sgx_encl_mm *mm;
> +
> +	if (encl->pm_notifier.notifier_call)
> +		unregister_pm_notifier(&encl->pm_notifier);
> +
> +	sgx_encl_destroy(encl);
> +
> +	if (encl->backing)
> +		fput(encl->backing);
> +
> +	/* If sgx_encl_create() fails, can be non-empty */
> +	while (!list_empty(&encl->mm_list)) {
> +		mm = list_first_entry(&encl->mm_list, struct sgx_encl_mm, list);

Any reason for while()+list_first_entry() instead of list_for_each_entry_safe()?

> +		list_del(&mm->list);
> +		kfree(mm);
> +	}
> +
> +	kfree(encl);
> +}
> +EXPORT_SYMBOL_GPL(sgx_encl_release);
> +
> +/**
> + * sgx_encl_get_index() - Convert a page descriptor to a page index
> + * @encl:	an enclave
> + * @page:	an enclave page
> + *
> + * Given an enclave page descriptor, convert it to a page index used to access
> + * backing storage. The backing page for SECS is located after the enclave
> + * pages.
> + */
> +pgoff_t sgx_encl_get_index(struct sgx_encl *encl, struct sgx_encl_page *page)
> +{
> +	if (!PFN_DOWN(page->desc))
> +		return PFN_DOWN(encl->size);
> +
> +	return PFN_DOWN(page->desc - encl->base);
> +}
> +EXPORT_SYMBOL_GPL(sgx_encl_get_index);
> +
> +/**
> + * sgx_encl_encl_get_backing_page() - Pin the backing page
> + * @encl:	an enclave
> + * @index:	page index
> + *
> + * Return: the pinned backing page
> + */
> +struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index)
> +{
> +	struct inode *inode = encl->backing->f_path.dentry->d_inode;
> +	struct address_space *mapping = inode->i_mapping;
> +	gfp_t gfpmask = mapping_gfp_mask(mapping);
> +
> +	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
> +}
> +EXPORT_SYMBOL_GPL(sgx_encl_get_backing_page);
> +
> +/**
> + * sgx_encl_next_mm() - Iterate to the next mm
> + * @encl:	an enclave
> + * @mm:		an mm list entry
> + * @iter:	iterator status
> + *
> + * Return: the enclave mm or NULL
> + */
> +struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
> +				     struct sgx_encl_mm *mm, int *iter)
> +{
> +	struct list_head *entry;
> +
> +	WARN(!encl, "%s: encl is NULL", __func__);
> +	WARN(!iter, "%s: iter is NULL", __func__);
> +
> +	spin_lock(&encl->mm_lock);
> +
> +	entry = mm ? mm->list.next : encl->mm_list.next;
> +	WARN(!entry, "%s: entry is NULL", __func__);

I'm pretty sure we can simply use an RCU list.  Iteration is then simply
list_for_each_entry_rcu() instead of this custom walker.  Peeking into the
future, we don't need perfect accuracy for aging pages, e.g. working with
a stale snapshot is perfectly ok.

Zapping PTEs does need 100% accuracy, but that will be guaranteed via the
SGX_ENCL_PAGE_RECLAIMED flag.  Any mm added to the list after we start
zapping will be rejected by the page fault handler, i.e. won't be able
to reference the page being reclaimed.

> +
> +	if (entry == &encl->mm_list) {
> +		mm = NULL;
> +		*iter = SGX_ENCL_MM_ITER_DONE;
> +		goto out;
> +	}
> +
> +	mm = list_entry(entry, struct sgx_encl_mm, list);
> +
> +	if (!kref_get_unless_zero(&mm->refcount)) {
> +		*iter = SGX_ENCL_MM_ITER_RESTART;
> +		mm = NULL;
> +		goto out;
> +	}
> +
> +	if (!atomic_add_unless(&mm->mm->mm_count, 1, 0)) {
> +		kref_put(&mm->refcount, sgx_encl_release_mm);
> +		mm = NULL;
> +		*iter = SGX_ENCL_MM_ITER_RESTART;
> +		goto out;
> +	}
> +
> +	*iter = SGX_ENCL_MM_ITER_NEXT;
> +
> +out:
> +	spin_unlock(&encl->mm_lock);
> +	return mm;
> +}
> +
> +void sgx_encl_release_mm(struct kref *ref)
> +{
> +	struct sgx_encl_mm *mm =
> +		container_of(ref, struct sgx_encl_mm, refcount);
> +
> +	spin_lock(&mm->encl->mm_lock);
> +	list_del(&mm->list);
> +	spin_unlock(&mm->encl->mm_lock);
> +
> +	kfree(mm);
> +}
