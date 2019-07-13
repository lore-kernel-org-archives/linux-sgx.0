Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF27C71142
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72C862064A
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfGMRLR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 13:11:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:30411 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbfGMRLR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 13:11:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jul 2019 10:11:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,487,1557212400"; 
   d="scan'208";a="341981436"
Received: from hbriegel-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.48])
  by orsmga005.jf.intel.com with ESMTP; 13 Jul 2019 10:11:04 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v21 16/28] x86/sgx: Add the Linux SGX Enclave Driver
Date:   Sat, 13 Jul 2019 20:07:52 +0300
Message-Id: <20190713170804.2340-17-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
can be used by applications to set aside private regions of code and
data. The code outside the enclave is disallowed to access the memory
inside the enclave by the CPU access control.

This commit adds the Linux SGX Enclave Driver that provides an ioctl API
to manage enclaves. The address range for an enclave, commonly referred
as ELRANGE in the documentation (e.g. Intel SDM), is reserved with
mmap() against /dev/sgx/enclave. After that a set ioctls is used to
build the enclave to the ELRANGE.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 Documentation/ioctl/ioctl-number.txt    |   1 +
 arch/x86/Kconfig                        |  16 +
 arch/x86/include/uapi/asm/sgx.h         |  55 ++
 arch/x86/kernel/cpu/sgx/Makefile        |   3 +-
 arch/x86/kernel/cpu/sgx/driver/Makefile |   3 +
 arch/x86/kernel/cpu/sgx/driver/driver.h |  44 ++
 arch/x86/kernel/cpu/sgx/driver/ioctl.c  | 734 ++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/driver/main.c   | 264 +++++++++
 arch/x86/kernel/cpu/sgx/encl.c          | 362 ++++++++++++
 arch/x86/kernel/cpu/sgx/encl.h          | 100 ++++
 arch/x86/kernel/cpu/sgx/main.c          |  25 +-
 arch/x86/kernel/cpu/sgx/reclaim.c       |   2 +-
 arch/x86/kernel/cpu/sgx/sgx.h           |   1 +
 13 files changed, 1598 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/include/uapi/asm/sgx.h
 create mode 100644 arch/x86/kernel/cpu/sgx/driver/Makefile
 create mode 100644 arch/x86/kernel/cpu/sgx/driver/driver.h
 create mode 100644 arch/x86/kernel/cpu/sgx/driver/ioctl.c
 create mode 100644 arch/x86/kernel/cpu/sgx/driver/main.c
 create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
 create mode 100644 arch/x86/kernel/cpu/sgx/encl.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index c9558146ac58..ef2694221cd0 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -312,6 +312,7 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:tlewis@mindspring.com>
 0xA3	90-9F	linux/dtlk.h
 0xA4	00-1F	uapi/linux/tee.h	Generic TEE subsystem
+0xA4	00-02	uapi/asm/sgx.h		conflict!
 0xAA	00-3F	linux/uapi/linux/userfaultfd.h
 0xAB	00-1F	linux/nbd.h
 0xAC	00-1F	linux/raw.h
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 815328adf561..74ccb1bdea16 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1936,6 +1936,8 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 config INTEL_SGX
 	bool "Intel SGX core functionality"
 	depends on X86_64 && CPU_SUP_INTEL
+	select SRCU
+	select MMU_NOTIFIER
 	---help---
 	  Intel(R) SGX is a set of CPU instructions that can be used by
 	  applications to set aside private regions of code and data, referred
@@ -1945,6 +1947,20 @@ config INTEL_SGX
 
 	  If unsure, say N.
 
+config INTEL_SGX_DRIVER
+	bool "Intel(R) SGX Driver"
+	depends on X86_64 && CPU_SUP_INTEL && INTEL_SGX
+	select CRYPTO
+	select CRYPTO_SHA256
+	---help---
+	  This options enables the kernel SGX driver that allows to construct
+	  enclaves to the process memory by using a device node (by default
+	  /dev/sgx) and a set of ioctls. The driver requires that the MSRs
+	  specifying the public key hash for the launch enclave are writable so
+	  that Linux has the full control to run enclaves.
+
+	  If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
new file mode 100644
index 000000000000..37d6770a654b
--- /dev/null
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+/*
+ * Copyright(c) 2016-18 Intel Corporation.
+ */
+#ifndef _UAPI_ASM_X86_SGX_H
+#define _UAPI_ASM_X86_SGX_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define SGX_MAGIC 0xA4
+
+#define SGX_IOC_ENCLAVE_CREATE \
+	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
+#define SGX_IOC_ENCLAVE_ADD_PAGE \
+	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
+#define SGX_IOC_ENCLAVE_INIT \
+	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
+
+/**
+ * struct sgx_enclave_create - parameter structure for the
+ *                             %SGX_IOC_ENCLAVE_CREATE ioctl
+ * @src:	address for the SECS page data
+ */
+struct sgx_enclave_create  {
+	__u64	src;
+};
+
+/**
+ * struct sgx_enclave_add_page - parameter structure for the
+ *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
+ * @addr:	address within the ELRANGE
+ * @src:	address for the page data
+ * @secinfo:	address for the SECINFO data
+ * @mrmask:	bitmask for the measured 256 byte chunks
+ * @reserved:	reserved for future use
+ */
+struct sgx_enclave_add_page {
+	__u64	addr;
+	__u64	src;
+	__u64	secinfo;
+	__u16	mrmask;
+	__u8	reserved[6];
+};
+
+/**
+ * struct sgx_enclave_init - parameter structure for the
+ *                           %SGX_IOC_ENCLAVE_INIT ioctl
+ * @sigstruct:	address for the SIGSTRUCT data
+ */
+struct sgx_enclave_init {
+	__u64 sigstruct;
+};
+
+#endif /* _UAPI_ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index fa930e292110..e5d1e862969c 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -1 +1,2 @@
-obj-y += encls.o main.o reclaim.o
+obj-y += encl.o encls.o main.o reclaim.o
+obj-$(CONFIG_INTEL_SGX_DRIVER) += driver/
diff --git a/arch/x86/kernel/cpu/sgx/driver/Makefile b/arch/x86/kernel/cpu/sgx/driver/Makefile
new file mode 100644
index 000000000000..01ebbbb06a47
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_INTEL_SGX_DRIVER) += sgx.o
+sgx-$(CONFIG_INTEL_SGX_DRIVER) += ioctl.o
+sgx-$(CONFIG_INTEL_SGX_DRIVER) += main.o
diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
new file mode 100644
index 000000000000..52f41426434b
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+#ifndef __ARCH_SGX_DRIVER_H__
+#define __ARCH_SGX_DRIVER_H__
+
+#include <crypto/hash.h>
+#include <linux/kref.h>
+#include <linux/mmu_notifier.h>
+#include <linux/radix-tree.h>
+#include <linux/rwsem.h>
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+#include <uapi/asm/sgx.h>
+#include "../arch.h"
+#include "../encl.h"
+#include "../encls.h"
+#include "../sgx.h"
+
+#define SGX_DRV_NR_DEVICES	2
+#define SGX_EINIT_SPIN_COUNT	20
+#define SGX_EINIT_SLEEP_COUNT	50
+#define SGX_EINIT_SLEEP_TIME	20
+
+extern struct workqueue_struct *sgx_encl_wq;
+extern u64 sgx_encl_size_max_32;
+extern u64 sgx_encl_size_max_64;
+extern u32 sgx_misc_reserved_mask;
+extern u64 sgx_attributes_reserved_mask;
+extern u64 sgx_xfrm_reserved_mask;
+extern u32 sgx_xsave_size_tbl[64];
+
+extern const struct file_operations sgx_fs_provision_fops;
+
+long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
+
+#ifdef CONFIG_INTEL_SGX_DRIVER
+int sgx_drv_init(void);
+#else
+static inline int sgx_drv_init(void)
+{
+	return -ENODEV;
+}
+#endif
+
+#endif /* __ARCH_X86_SGX_DRIVER_H__ */
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
new file mode 100644
index 000000000000..1cbebcd3f397
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -0,0 +1,734 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-19 Intel Corporation.
+
+#include <asm/mman.h>
+#include <linux/mman.h>
+#include <linux/delay.h>
+#include <linux/file.h>
+#include <linux/hashtable.h>
+#include <linux/highmem.h>
+#include <linux/ratelimit.h>
+#include <linux/sched/signal.h>
+#include <linux/shmem_fs.h>
+#include <linux/slab.h>
+#include <linux/suspend.h>
+#include "driver.h"
+
+struct sgx_add_page_req {
+	struct sgx_encl *encl;
+	struct sgx_encl_page *encl_page;
+	struct sgx_secinfo secinfo;
+	unsigned long mrmask;
+	struct list_head list;
+};
+
+static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
+				     struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = req->encl_page;
+	struct sgx_encl *encl = req->encl;
+	unsigned long page_index = sgx_encl_get_index(encl, encl_page);
+	struct sgx_secinfo secinfo;
+	struct sgx_pageinfo pginfo;
+	struct page *backing;
+	unsigned long addr;
+	int ret;
+	int i;
+
+	if (encl->flags &  SGX_ENCL_DEAD)
+		return false;
+
+	addr = SGX_ENCL_PAGE_ADDR(encl_page);
+
+	backing = sgx_encl_get_backing_page(encl, page_index);
+	if (IS_ERR(backing))
+		return false;
+
+	/*
+	 * The SECINFO field must be 64-byte aligned, copy it to a local
+	 * variable that is guaranteed to be aligned as req->secinfo may
+	 * or may not be 64-byte aligned, e.g. req may have been allocated
+	 * via kzalloc which is not aware of __aligned attributes.
+	 */
+	memcpy(&secinfo, &req->secinfo, sizeof(secinfo));
+
+	pginfo.secs = (unsigned long)sgx_epc_addr(encl->secs.epc_page);
+	pginfo.addr = addr;
+	pginfo.metadata = (unsigned long)&secinfo;
+	pginfo.contents = (unsigned long)kmap_atomic(backing);
+	ret = __eadd(&pginfo, sgx_epc_addr(epc_page));
+	kunmap_atomic((void *)(unsigned long)pginfo.contents);
+
+	put_page(backing);
+
+	if (ret) {
+		if (encls_failed(ret))
+			ENCLS_WARN(ret, "EADD");
+		return false;
+	}
+
+	for_each_set_bit(i, &req->mrmask, 16) {
+		ret = __eextend(sgx_epc_addr(encl->secs.epc_page),
+				sgx_epc_addr(epc_page) + (i * 0x100));
+		if (ret) {
+			if (encls_failed(ret))
+				ENCLS_WARN(ret, "EEXTEND");
+			return false;
+		}
+	}
+
+	encl_page->encl = encl;
+	encl_page->epc_page = epc_page;
+	encl->secs_child_cnt++;
+
+	return true;
+}
+
+static void sgx_add_page_worker(struct work_struct *work)
+{
+	struct sgx_add_page_req *req;
+	bool skip_rest = false;
+	bool is_empty = false;
+	struct sgx_encl *encl;
+	struct sgx_epc_page *epc_page;
+
+	encl = container_of(work, struct sgx_encl, work);
+
+	do {
+		schedule();
+
+		mutex_lock(&encl->lock);
+		if (encl->flags & SGX_ENCL_DEAD)
+			skip_rest = true;
+
+		req = list_first_entry(&encl->add_page_reqs,
+				       struct sgx_add_page_req, list);
+		list_del(&req->list);
+		is_empty = list_empty(&encl->add_page_reqs);
+		mutex_unlock(&encl->lock);
+
+		if (skip_rest)
+			goto next;
+
+		epc_page = sgx_alloc_page();
+
+		mutex_lock(&encl->lock);
+
+		if (IS_ERR(epc_page)) {
+			sgx_encl_destroy(encl);
+			skip_rest = true;
+		} else if (!sgx_process_add_page_req(req, epc_page)) {
+			sgx_free_page(epc_page);
+			sgx_encl_destroy(encl);
+			skip_rest = true;
+		}
+
+		mutex_unlock(&encl->lock);
+
+next:
+		kfree(req);
+	} while (!is_empty);
+}
+
+static u32 sgx_calc_ssaframesize(u32 miscselect, u64 xfrm)
+{
+	u32 size_max = PAGE_SIZE;
+	u32 size;
+	int i;
+
+	for (i = 2; i < 64; i++) {
+		if (!((1 << i) & xfrm))
+			continue;
+
+		size = SGX_SSA_GPRS_SIZE + sgx_xsave_size_tbl[i];
+		if (miscselect & SGX_MISC_EXINFO)
+			size += SGX_SSA_MISC_EXINFO_SIZE;
+
+		if (size > size_max)
+			size_max = size;
+	}
+
+	return PFN_UP(size_max);
+}
+
+static int sgx_validate_secs(const struct sgx_secs *secs,
+			     unsigned long ssaframesize)
+{
+	if (secs->size < (2 * PAGE_SIZE) || !is_power_of_2(secs->size))
+		return -EINVAL;
+
+	if (secs->base & (secs->size - 1))
+		return -EINVAL;
+
+	if (secs->miscselect & sgx_misc_reserved_mask ||
+	    secs->attributes & sgx_attributes_reserved_mask ||
+	    secs->xfrm & sgx_xfrm_reserved_mask)
+		return -EINVAL;
+
+	if (secs->attributes & SGX_ATTR_MODE64BIT) {
+		if (secs->size > sgx_encl_size_max_64)
+			return -EINVAL;
+	} else if (secs->size > sgx_encl_size_max_32)
+		return -EINVAL;
+
+	if (!(secs->xfrm & XFEATURE_MASK_FP) ||
+	    !(secs->xfrm & XFEATURE_MASK_SSE) ||
+	    (((secs->xfrm >> XFEATURE_BNDREGS) & 1) !=
+	     ((secs->xfrm >> XFEATURE_BNDCSR) & 1)))
+		return -EINVAL;
+
+	if (!secs->ssa_frame_size || ssaframesize > secs->ssa_frame_size)
+		return -EINVAL;
+
+	if (memchr_inv(secs->reserved1, 0, SGX_SECS_RESERVED1_SIZE) ||
+	    memchr_inv(secs->reserved2, 0, SGX_SECS_RESERVED2_SIZE) ||
+	    memchr_inv(secs->reserved3, 0, SGX_SECS_RESERVED3_SIZE) ||
+	    memchr_inv(secs->reserved4, 0, SGX_SECS_RESERVED4_SIZE))
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
+						 unsigned long addr,
+						 unsigned long prot)
+{
+	struct sgx_encl_page *encl_page;
+	int ret;
+
+	if (radix_tree_lookup(&encl->page_tree, PFN_DOWN(addr)))
+		return ERR_PTR(-EEXIST);
+	encl_page = kzalloc(sizeof(*encl_page), GFP_KERNEL);
+	if (!encl_page)
+		return ERR_PTR(-ENOMEM);
+	encl_page->desc = addr;
+	encl_page->encl = encl;
+	encl_page->vm_prot_bits = calc_vm_prot_bits(prot, 0);
+	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
+				encl_page);
+	if (ret) {
+		kfree(encl_page);
+		return ERR_PTR(ret);
+	}
+	return encl_page;
+}
+
+static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
+{
+	unsigned long encl_size = secs->size + PAGE_SIZE;
+	struct sgx_epc_page *secs_epc;
+	unsigned long ssaframesize;
+	struct sgx_pageinfo pginfo;
+	struct sgx_secinfo secinfo;
+	struct file *backing;
+	long ret;
+
+	mutex_lock(&encl->lock);
+
+	if (encl->flags & SGX_ENCL_CREATED) {
+		ret = -EFAULT;
+		goto err_out;
+	}
+
+	ssaframesize = sgx_calc_ssaframesize(secs->miscselect, secs->xfrm);
+	if (sgx_validate_secs(secs, ssaframesize)) {
+		ret = -EINVAL;
+		goto err_out;
+	}
+
+	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
+				   VM_NORESERVE);
+	if (IS_ERR(backing)) {
+		ret = PTR_ERR(backing);
+		goto err_out;
+	}
+
+	encl->backing = backing;
+
+	INIT_WORK(&encl->work, sgx_add_page_worker);
+
+	secs_epc = sgx_alloc_page();
+	if (IS_ERR(secs_epc)) {
+		ret = PTR_ERR(secs_epc);
+		goto err_out;
+	}
+
+	encl->secs.epc_page = secs_epc;
+
+	pginfo.addr = 0;
+	pginfo.contents = (unsigned long)secs;
+	pginfo.metadata = (unsigned long)&secinfo;
+	pginfo.secs = 0;
+	memset(&secinfo, 0, sizeof(secinfo));
+
+	ret = __ecreate((void *)&pginfo, sgx_epc_addr(secs_epc));
+	if (ret) {
+		pr_debug("ECREATE returned %ld\n", ret);
+		goto err_out;
+	}
+
+	if (secs->attributes & SGX_ATTR_DEBUG)
+		encl->flags |= SGX_ENCL_DEBUG;
+
+	encl->secs.encl = encl;
+	encl->secs_attributes = secs->attributes;
+	encl->allowed_attributes = SGX_ATTR_ALLOWED_MASK;
+	encl->base = secs->base;
+	encl->size = secs->size;
+	encl->ssaframesize = secs->ssa_frame_size;
+	encl->flags |= SGX_ENCL_CREATED;
+
+	mutex_unlock(&encl->lock);
+	return 0;
+
+err_out:
+	if (encl->secs.epc_page) {
+		sgx_free_page(encl->secs.epc_page);
+		encl->secs.epc_page = NULL;
+	}
+
+	if (encl->backing) {
+		fput(encl->backing);
+		encl->backing = NULL;
+	}
+
+	mutex_unlock(&encl->lock);
+	return ret;
+}
+
+/**
+ * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
+ * @filep:	open file to /dev/sgx
+ * @arg:	userspace pointer to a struct sgx_enclave_create instance
+ *
+ * Allocate kernel data structures for a new enclave and execute ECREATE after
+ * verifying the correctness of the provided SECS.
+ *
+ * Note, enforcement of restricted and disallowed attributes is deferred until
+ * sgx_ioc_enclave_init(), only the architectural correctness of the SECS is
+ * checked by sgx_ioc_enclave_create().
+ *
+ * Return:
+ *   0 on success,
+ *   -errno otherwise
+ */
+static long sgx_ioc_enclave_create(struct file *filep, void __user *arg)
+{
+	struct sgx_encl *encl = filep->private_data;
+	struct sgx_enclave_create ecreate;
+	struct page *secs_page;
+	struct sgx_secs *secs;
+	int ret;
+
+	if (copy_from_user(&ecreate, arg, sizeof(ecreate)))
+		return -EFAULT;
+
+	secs_page = alloc_page(GFP_HIGHUSER);
+	if (!secs_page)
+		return -ENOMEM;
+
+	secs = kmap(secs_page);
+	if (copy_from_user(secs, (void __user *)ecreate.src, sizeof(*secs))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = sgx_encl_create(encl, secs);
+
+out:
+	kunmap(secs_page);
+	__free_page(secs_page);
+	return ret;
+}
+
+static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
+{
+	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
+	u64 perm = secinfo->flags & SGX_SECINFO_PERMISSION_MASK;
+	int i;
+
+	if ((secinfo->flags & SGX_SECINFO_RESERVED_MASK) ||
+	    ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R)) ||
+	    (page_type != SGX_SECINFO_TCS && page_type != SGX_SECINFO_TRIM &&
+	     page_type != SGX_SECINFO_REG))
+		return -EINVAL;
+
+	for (i = 0; i < SGX_SECINFO_RESERVED_SIZE; i++)
+		if (secinfo->reserved[i])
+			return -EINVAL;
+
+	return 0;
+}
+
+static bool sgx_validate_offset(struct sgx_encl *encl, unsigned long offset)
+{
+	if (offset & (PAGE_SIZE - 1))
+		return false;
+
+	if (offset >= encl->size)
+		return false;
+
+	return true;
+}
+
+static int sgx_validate_tcs(struct sgx_encl *encl, struct sgx_tcs *tcs)
+{
+	int i;
+
+	if (tcs->flags & SGX_TCS_RESERVED_MASK)
+		return -EINVAL;
+
+	if (tcs->flags & SGX_TCS_DBGOPTIN)
+		return -EINVAL;
+
+	if (!sgx_validate_offset(encl, tcs->ssa_offset))
+		return -EINVAL;
+
+	if (!sgx_validate_offset(encl, tcs->fs_offset))
+		return -EINVAL;
+
+	if (!sgx_validate_offset(encl, tcs->gs_offset))
+		return -EINVAL;
+
+	if ((tcs->fs_limit & 0xFFF) != 0xFFF)
+		return -EINVAL;
+
+	if ((tcs->gs_limit & 0xFFF) != 0xFFF)
+		return -EINVAL;
+
+	for (i = 0; i < SGX_TCS_RESERVED_SIZE; i++)
+		if (tcs->reserved[i])
+			return -EINVAL;
+
+	return 0;
+}
+
+static int __sgx_encl_add_page(struct sgx_encl *encl,
+			       struct sgx_encl_page *encl_page,
+			       void *data,
+			       struct sgx_secinfo *secinfo,
+			       unsigned int mrmask)
+{
+	unsigned long page_index = sgx_encl_get_index(encl, encl_page);
+	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
+	struct sgx_add_page_req *req = NULL;
+	struct page *backing;
+	void *backing_ptr;
+	int empty;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	backing = sgx_encl_get_backing_page(encl, page_index);
+	if (IS_ERR(backing)) {
+		kfree(req);
+		return PTR_ERR(backing);
+	}
+
+	backing_ptr = kmap(backing);
+	memcpy(backing_ptr, data, PAGE_SIZE);
+	kunmap(backing);
+	if (page_type == SGX_SECINFO_TCS)
+		encl_page->desc |= SGX_ENCL_PAGE_TCS;
+	memcpy(&req->secinfo, secinfo, sizeof(*secinfo));
+	req->encl = encl;
+	req->encl_page = encl_page;
+	req->mrmask = mrmask;
+	empty = list_empty(&encl->add_page_reqs);
+	list_add_tail(&req->list, &encl->add_page_reqs);
+	if (empty)
+		queue_work(sgx_encl_wq, &encl->work);
+	set_page_dirty(backing);
+	put_page(backing);
+	return 0;
+}
+
+static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
+			     void *data, struct sgx_secinfo *secinfo,
+			     unsigned int mrmask, unsigned long prot)
+{
+	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
+	struct sgx_encl_page *encl_page;
+	int ret;
+
+	if (sgx_validate_secinfo(secinfo))
+		return -EINVAL;
+	if (page_type == SGX_SECINFO_TCS) {
+		ret = sgx_validate_tcs(encl, data);
+		if (ret)
+			return ret;
+	}
+
+	mutex_lock(&encl->lock);
+
+	if (!(encl->flags & SGX_ENCL_CREATED) ||
+	    (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	encl_page = sgx_encl_page_alloc(encl, addr, prot);
+	if (IS_ERR(encl_page)) {
+		ret = PTR_ERR(encl_page);
+		goto out;
+	}
+
+	ret = __sgx_encl_add_page(encl, encl_page, data, secinfo, mrmask);
+	if (ret) {
+		radix_tree_delete(&encl_page->encl->page_tree,
+				  PFN_DOWN(encl_page->desc));
+		kfree(encl_page);
+	}
+
+out:
+	mutex_unlock(&encl->lock);
+	return ret;
+}
+
+static int sgx_encl_page_import_user(void *dst, unsigned long src,
+				     unsigned long prot)
+{
+	struct vm_area_struct *vma;
+	int ret = 0;
+
+	down_read(&current->mm->mmap_sem);
+
+	/* Query vma's VM_MAYEXEC as an indirect path_noexec() check. */
+	if (prot & PROT_EXEC) {
+		vma = find_vma(current->mm, src);
+		if (!vma) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (!(vma->vm_flags & VM_MAYEXEC)) {
+			ret = -EACCES;
+			goto out;
+		}
+	}
+
+	if (copy_from_user(dst, (void __user *)src, PAGE_SIZE))
+		ret = -EFAULT;
+
+out:
+	up_read(&current->mm->mmap_sem);
+	return ret;
+}
+
+/**
+ * sgx_ioc_enclave_add_page - handler for %SGX_IOC_ENCLAVE_ADD_PAGE
+ *
+ * @filep:	open file to /dev/sgx
+ * @arg:	a user pointer to a struct sgx_enclave_add_page instance
+ *
+ * Add a page to an uninitialized enclave (EADD), and optionally extend the
+ * enclave's measurement with the contents of the page (EEXTEND). Adding is done
+ * asynchronously. A success only indicates that the page has been added to a
+ * work queue.
+ *
+ * Return:
+ *   0 on success,
+ *   -EINVAL if other than RWX protection bits have been set
+ *   -EACCES if the source page is located in a noexec partition
+ *   -errno otherwise
+ */
+static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
+{
+	struct sgx_encl *encl = filep->private_data;
+	struct sgx_enclave_add_page addp;
+	struct sgx_secinfo secinfo;
+	struct page *data_page;
+	unsigned long prot;
+	void *data;
+	int ret;
+
+	if (copy_from_user(&addp, arg, sizeof(addp)))
+		return -EFAULT;
+
+	if (copy_from_user(&secinfo, (void __user *)addp.secinfo,
+			   sizeof(secinfo)))
+		return -EFAULT;
+
+	data_page = alloc_page(GFP_HIGHUSER);
+	if (!data_page)
+		return -ENOMEM;
+
+	data = kmap(data_page);
+
+	prot = _calc_vm_trans(secinfo.flags, SGX_SECINFO_R, PROT_READ)  |
+	       _calc_vm_trans(secinfo.flags, SGX_SECINFO_W, PROT_WRITE) |
+	       _calc_vm_trans(secinfo.flags, SGX_SECINFO_X, PROT_EXEC);
+
+	/* TCS pages need to be RW in the PTEs, but can be 0 in the EPCM. */
+	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
+		prot |= PROT_READ | PROT_WRITE;
+
+	ret = sgx_encl_page_import_user(data, addp.src, prot);
+	if (ret)
+		goto out;
+
+	ret = sgx_encl_add_page(encl, addp.addr, data, &secinfo, addp.mrmask,
+				prot);
+	if (ret)
+		goto out;
+
+out:
+	kunmap(data_page);
+	__free_page(data_page);
+	return ret;
+}
+
+static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
+			      void *hash)
+{
+	SHASH_DESC_ON_STACK(shash, tfm);
+
+	shash->tfm = tfm;
+
+	return crypto_shash_digest(shash, modulus, SGX_MODULUS_SIZE, hash);
+}
+
+static int sgx_get_key_hash(const void *modulus, void *hash)
+{
+	struct crypto_shash *tfm;
+	int ret;
+
+	tfm = crypto_alloc_shash("sha256", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	ret = __sgx_get_key_hash(tfm, modulus, hash);
+
+	crypto_free_shash(tfm);
+	return ret;
+}
+
+static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
+			 struct sgx_einittoken *token)
+{
+	u64 mrsigner[4];
+	int ret;
+	int i;
+	int j;
+
+	/* Check that the required attributes have been authorized. */
+	if (encl->secs_attributes & ~encl->allowed_attributes)
+		return -EINVAL;
+
+	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
+	if (ret)
+		return ret;
+
+	flush_work(&encl->work);
+
+	mutex_lock(&encl->lock);
+
+	if (!(encl->flags & SGX_ENCL_CREATED) ||
+	    (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD))) {
+		ret = -EFAULT;
+		goto err_out;
+	}
+
+	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
+		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
+			ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
+					mrsigner);
+			if (ret == SGX_UNMASKED_EVENT)
+				continue;
+			else
+				break;
+		}
+
+		if (ret != SGX_UNMASKED_EVENT)
+			break;
+
+		msleep_interruptible(SGX_EINIT_SLEEP_TIME);
+
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			goto err_out;
+		}
+	}
+
+	if (encls_faulted(ret)) {
+		if (encls_failed(ret))
+			ENCLS_WARN(ret, "EINIT");
+
+		sgx_encl_destroy(encl);
+		ret = -EFAULT;
+	} else if (encls_returned_code(ret)) {
+		pr_debug("EINIT returned %d\n", ret);
+	} else {
+		encl->flags |= SGX_ENCL_INITIALIZED;
+	}
+
+err_out:
+	mutex_unlock(&encl->lock);
+	return ret;
+}
+
+/**
+ * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
+ *
+ * @filep:	open file to /dev/sgx
+ * @arg:	userspace pointer to a struct sgx_enclave_init instance
+ *
+ * Flush any outstanding enqueued EADD operations and perform EINIT.  The
+ * Launch Enclave Public Key Hash MSRs are rewritten as necessary to match
+ * the enclave's MRSIGNER, which is caculated from the provided sigstruct.
+ *
+ * Return:
+ *   0 on success,
+ *   SGX error code on EINIT failure,
+ *   -errno otherwise
+ */
+static long sgx_ioc_enclave_init(struct file *filep, void __user *arg)
+{
+	struct sgx_encl *encl = filep->private_data;
+	struct sgx_einittoken *einittoken;
+	struct sgx_sigstruct *sigstruct;
+	struct sgx_enclave_init einit;
+	struct page *initp_page;
+	int ret;
+
+	if (copy_from_user(&einit, arg, sizeof(einit)))
+		return -EFAULT;
+
+	initp_page = alloc_page(GFP_HIGHUSER);
+	if (!initp_page)
+		return -ENOMEM;
+
+	sigstruct = kmap(initp_page);
+	einittoken = (struct sgx_einittoken *)
+		((unsigned long)sigstruct + PAGE_SIZE / 2);
+	memset(einittoken, 0, sizeof(*einittoken));
+
+	if (copy_from_user(sigstruct, (void __user *)einit.sigstruct,
+			   sizeof(*sigstruct))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = sgx_encl_init(encl, sigstruct, einittoken);
+
+out:
+	kunmap(initp_page);
+	__free_page(initp_page);
+	return ret;
+}
+
+
+long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case SGX_IOC_ENCLAVE_CREATE:
+		return sgx_ioc_enclave_create(filep, (void __user *)arg);
+	case SGX_IOC_ENCLAVE_ADD_PAGE:
+		return sgx_ioc_enclave_add_page(filep, (void __user *)arg);
+	case SGX_IOC_ENCLAVE_INIT:
+		return sgx_ioc_enclave_init(filep, (void __user *)arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
new file mode 100644
index 000000000000..1ccc160020d1
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include <linux/acpi.h>
+#include <linux/cdev.h>
+#include <linux/mman.h>
+#include <linux/platform_device.h>
+#include <linux/security.h>
+#include <linux/suspend.h>
+#include <asm/traps.h>
+#include "driver.h"
+
+MODULE_DESCRIPTION("Intel SGX Enclave Driver");
+MODULE_AUTHOR("Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>");
+MODULE_LICENSE("Dual BSD/GPL");
+
+struct workqueue_struct *sgx_encl_wq;
+u64 sgx_encl_size_max_32;
+u64 sgx_encl_size_max_64;
+u32 sgx_misc_reserved_mask;
+u64 sgx_attributes_reserved_mask;
+u64 sgx_xfrm_reserved_mask = ~0x3;
+u32 sgx_xsave_size_tbl[64];
+
+static int sgx_open(struct inode *inode, struct file *file)
+{
+	struct sgx_encl *encl;
+	int ret;
+
+	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
+	if (!encl)
+		return -ENOMEM;
+
+	kref_init(&encl->refcount);
+	INIT_LIST_HEAD(&encl->add_page_reqs);
+	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
+	mutex_init(&encl->lock);
+	INIT_LIST_HEAD(&encl->mm_list);
+	spin_lock_init(&encl->mm_lock);
+
+	ret = init_srcu_struct(&encl->srcu);
+	if (ret) {
+		kfree(encl);
+		return ret;
+	}
+
+	file->private_data = encl;
+
+	return 0;
+}
+
+static int sgx_release(struct inode *inode, struct file *file)
+{
+	struct sgx_encl *encl = file->private_data;
+	struct sgx_encl_mm *encl_mm;
+
+	for ( ; ; )  {
+		spin_lock(&encl->mm_lock);
+
+		if (list_empty(&encl->mm_list)) {
+			encl_mm = NULL;
+		} else {
+			encl_mm = list_first_entry(&encl->mm_list,
+						   struct sgx_encl_mm, list);
+			list_del_rcu(&encl_mm->list);
+		}
+
+		spin_unlock(&encl->mm_lock);
+
+		/* The list is empty, ready to go. */
+		if (!encl_mm)
+			break;
+
+		synchronize_srcu(&encl->srcu);
+		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
+		kfree(encl_mm);
+	};
+
+	mutex_lock(&encl->lock);
+	encl->flags |= SGX_ENCL_DEAD;
+	mutex_unlock(&encl->lock);
+
+	if (encl->work.func)
+		flush_work(&encl->work);
+
+	kref_put(&encl->refcount, sgx_encl_release);
+	return 0;
+}
+
+#ifdef CONFIG_COMPAT
+static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
+			      unsigned long arg)
+{
+	return sgx_ioctl(filep, cmd, arg);
+}
+#endif
+
+static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct sgx_encl *encl = file->private_data;
+	int ret;
+
+	ret = sgx_encl_may_map(encl, vma->vm_start, vma->vm_end,
+			       vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC));
+	if (ret)
+		return ret;
+
+	ret = sgx_encl_mm_add(encl, vma->vm_mm);
+	if (ret)
+		return ret;
+
+	vma->vm_ops = &sgx_vm_ops;
+	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
+	vma->vm_private_data = encl;
+
+	return 0;
+}
+
+static unsigned long sgx_get_unmapped_area(struct file *file,
+					   unsigned long addr,
+					   unsigned long len,
+					   unsigned long pgoff,
+					   unsigned long flags)
+{
+	if (flags & MAP_PRIVATE)
+		return -EINVAL;
+
+	if (flags & MAP_FIXED)
+		return addr;
+
+	if (len < 2 * PAGE_SIZE || len & (len - 1))
+		return -EINVAL;
+
+	addr = current->mm->get_unmapped_area(file, addr, 2 * len, pgoff,
+					      flags);
+	if (IS_ERR_VALUE(addr))
+		return addr;
+
+	addr = (addr + (len - 1)) & ~(len - 1);
+
+	return addr;
+}
+
+static const struct file_operations sgx_encl_fops = {
+	.owner			= THIS_MODULE,
+	.open			= sgx_open,
+	.release		= sgx_release,
+	.unlocked_ioctl		= sgx_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= sgx_compat_ioctl,
+#endif
+	.mmap			= sgx_mmap,
+	.get_unmapped_area	= sgx_get_unmapped_area,
+};
+
+static struct bus_type sgx_bus_type = {
+	.name	= "sgx",
+};
+
+static struct device sgx_encl_dev;
+static struct cdev sgx_encl_cdev;
+static dev_t sgx_devt;
+
+static void sgx_dev_release(struct device *dev)
+{
+}
+
+static __init int sgx_dev_init(const char *name, struct device *dev,
+			       struct cdev *cdev,
+			       const struct file_operations *fops, int minor)
+{
+	int ret;
+
+	device_initialize(dev);
+
+	dev->bus = &sgx_bus_type;
+	dev->devt = MKDEV(MAJOR(sgx_devt), minor);
+	dev->release = sgx_dev_release;
+
+	ret = dev_set_name(dev, name);
+	if (ret) {
+		put_device(dev);
+		return ret;
+	}
+
+	cdev_init(cdev, fops);
+	cdev->owner = THIS_MODULE;
+	return 0;
+}
+
+int __init sgx_drv_init(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	u64 attr_mask, xfrm_mask;
+	int ret;
+	int i;
+
+	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
+		pr_info("sgx: The public key MSRs are not writable\n");
+		return -ENODEV;
+	}
+
+	ret = bus_register(&sgx_bus_type);
+	if (ret)
+		return ret;
+
+	ret = alloc_chrdev_region(&sgx_devt, 0, SGX_DRV_NR_DEVICES, "sgx");
+	if (ret < 0)
+		goto err_bus;
+
+	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
+	sgx_misc_reserved_mask = ~ebx | SGX_MISC_RESERVED_MASK;
+	sgx_encl_size_max_64 = 1ULL << ((edx >> 8) & 0xFF);
+	sgx_encl_size_max_32 = 1ULL << (edx & 0xFF);
+
+	cpuid_count(SGX_CPUID, 1, &eax, &ebx, &ecx, &edx);
+
+	attr_mask = (((u64)ebx) << 32) + (u64)eax;
+	sgx_attributes_reserved_mask = ~attr_mask | SGX_ATTR_RESERVED_MASK;
+
+	if (boot_cpu_has(X86_FEATURE_OSXSAVE)) {
+		xfrm_mask = (((u64)edx) << 32) + (u64)ecx;
+
+		for (i = 2; i < 64; i++) {
+			cpuid_count(0x0D, i, &eax, &ebx, &ecx, &edx);
+			if ((1 << i) & xfrm_mask)
+				sgx_xsave_size_tbl[i] = eax + ebx;
+		}
+
+		sgx_xfrm_reserved_mask = ~xfrm_mask;
+	}
+
+	ret = sgx_dev_init("sgx/enclave", &sgx_encl_dev, &sgx_encl_cdev,
+			   &sgx_encl_fops, 0);
+	if (ret)
+		goto err_chrdev_region;
+
+	sgx_encl_wq = alloc_workqueue("sgx-encl-wq",
+				      WQ_UNBOUND | WQ_FREEZABLE, 1);
+	if (!sgx_encl_wq) {
+		ret = -ENOMEM;
+		goto err_encl_dev;
+	}
+
+	ret = cdev_device_add(&sgx_encl_cdev, &sgx_encl_dev);
+	if (ret)
+		goto err_encl_wq;
+
+	return 0;
+
+err_encl_wq:
+	destroy_workqueue(sgx_encl_wq);
+
+err_encl_dev:
+	put_device(&sgx_encl_dev);
+
+err_chrdev_region:
+	unregister_chrdev_region(sgx_devt, SGX_DRV_NR_DEVICES);
+
+err_bus:
+	bus_unregister(&sgx_bus_type);
+
+	return ret;
+}
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
new file mode 100644
index 000000000000..1a2f2a500634
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -0,0 +1,362 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include <linux/lockdep.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/shmem_fs.h>
+#include <linux/suspend.h>
+#include <linux/sched/mm.h>
+#include "arch.h"
+#include "encl.h"
+#include "sgx.h"
+
+static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
+						unsigned long addr)
+{
+	struct sgx_encl_page *entry;
+
+	/* If process was forked, VMA is still there but vm_private_data is set
+	 * to NULL.
+	 */
+	if (!encl)
+		return ERR_PTR(-EFAULT);
+
+	if ((encl->flags & SGX_ENCL_DEAD) ||
+	    !(encl->flags & SGX_ENCL_INITIALIZED))
+		return ERR_PTR(-EFAULT);
+
+	entry = radix_tree_lookup(&encl->page_tree, addr >> PAGE_SHIFT);
+	if (!entry)
+		return ERR_PTR(-EFAULT);
+
+	/* Page is already resident in the EPC. */
+	if (entry->epc_page)
+		return entry;
+
+	return ERR_PTR(-EFAULT);
+}
+
+static void sgx_encl_mm_release_deferred(struct rcu_head *rcu)
+{
+	struct sgx_encl_mm *encl_mm =
+		container_of(rcu, struct sgx_encl_mm, rcu);
+
+	kfree(encl_mm);
+}
+
+static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
+				     struct mm_struct *mm)
+{
+	struct sgx_encl_mm *encl_mm =
+		container_of(mn, struct sgx_encl_mm, mmu_notifier);
+	struct sgx_encl_mm *tmp = NULL;
+
+	/*
+	 * The enclave itself can remove encl_mm.  Note, objects can't be moved
+	 * off an RCU protected list, but deletion is ok.
+	 */
+	spin_lock(&encl_mm->encl->mm_lock);
+	list_for_each_entry(tmp, &encl_mm->encl->mm_list, list) {
+		if (tmp == encl_mm) {
+			list_del_rcu(&encl_mm->list);
+			break;
+		}
+	}
+	spin_unlock(&encl_mm->encl->mm_lock);
+
+	if (tmp == encl_mm) {
+		synchronize_srcu(&encl_mm->encl->srcu);
+
+		/*
+		 * Delay freeing encl_mm until after mmu_notifier synchronizes
+		 * its SRCU to ensure encl_mm cannot be dereferenced.
+		 */
+		mmu_notifier_unregister_no_release(mn, mm);
+		mmu_notifier_call_srcu(&encl_mm->rcu,
+				       &sgx_encl_mm_release_deferred);
+	}
+}
+
+static const struct mmu_notifier_ops sgx_mmu_notifier_ops = {
+	.release		= sgx_mmu_notifier_release,
+};
+
+static struct sgx_encl_mm *sgx_encl_find_mm(struct sgx_encl *encl,
+					    struct mm_struct *mm)
+{
+	struct sgx_encl_mm *encl_mm = NULL;
+	struct sgx_encl_mm *tmp;
+	int idx;
+
+	idx = srcu_read_lock(&encl->srcu);
+
+	list_for_each_entry_rcu(tmp, &encl->mm_list, list) {
+		if (tmp->mm == mm) {
+			encl_mm = tmp;
+			break;
+		}
+	}
+
+	srcu_read_unlock(&encl->srcu, idx);
+
+	return encl_mm;
+}
+
+int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
+{
+	struct sgx_encl_mm *encl_mm;
+	int ret;
+
+	if (encl->flags & SGX_ENCL_DEAD)
+		return -EINVAL;
+
+	/*
+	 * mm_structs are kept on mm_list until the mm or the enclave dies,
+	 * i.e. once an mm is off the list, it's gone for good, therefore it's
+	 * impossible to get a false positive on @mm due to a stale mm_list.
+	 */
+	if (sgx_encl_find_mm(encl, mm))
+		return 0;
+
+	encl_mm = kzalloc(sizeof(*encl_mm), GFP_KERNEL);
+	if (!encl_mm)
+		return -ENOMEM;
+
+	encl_mm->encl = encl;
+	encl_mm->mm = mm;
+	encl_mm->mmu_notifier.ops = &sgx_mmu_notifier_ops;
+
+	ret = __mmu_notifier_register(&encl_mm->mmu_notifier, mm);
+	if (ret) {
+		kfree(encl_mm);
+		return ret;
+	}
+
+	spin_lock(&encl->mm_lock);
+	list_add_rcu(&encl_mm->list, &encl->mm_list);
+	spin_unlock(&encl->mm_lock);
+
+	synchronize_srcu(&encl->srcu);
+
+	return 0;
+}
+
+static void sgx_vma_open(struct vm_area_struct *vma)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+
+	if (!encl)
+		return;
+
+	if (sgx_encl_mm_add(encl, vma->vm_mm))
+		vma->vm_private_data = NULL;
+}
+
+static unsigned int sgx_vma_fault(struct vm_fault *vmf)
+{
+	unsigned long addr = (unsigned long)vmf->address;
+	struct vm_area_struct *vma = vmf->vma;
+	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_encl_page *entry;
+	int ret = VM_FAULT_NOPAGE;
+	unsigned long pfn;
+
+	if (!encl)
+		return VM_FAULT_SIGBUS;
+
+	mutex_lock(&encl->lock);
+
+	entry = sgx_encl_load_page(encl, addr);
+	if (IS_ERR(entry)) {
+		if (unlikely(PTR_ERR(entry) != -EBUSY))
+			ret = VM_FAULT_SIGBUS;
+
+		goto out;
+	}
+
+	if (!follow_pfn(vma, addr, &pfn))
+		goto out;
+
+	ret = vmf_insert_pfn(vma, addr, PFN_DOWN(entry->epc_page->desc));
+	if (ret != VM_FAULT_NOPAGE) {
+		ret = VM_FAULT_SIGBUS;
+		goto out;
+	}
+
+out:
+	mutex_unlock(&encl->lock);
+	return ret;
+}
+
+/**
+ * sgx_encl_may_map() - Check if a requested VMA mapping is allowed
+ * @encl:		an enclave
+ * @start:		lower bound of the address range, inclusive
+ * @end:		upper bound of the address range, exclusive
+ * @vm_prot_bits:	requested protections of the address range
+ *
+ * Iterate through the enclave pages contained within [@start, @end) to verify
+ * the permissions requested by @vm_prot_bits do not exceed that of any enclave
+ * page to be mapped.  Page addresses that do not have an associated enclave
+ * page are interpreted to zero permissions.
+ *
+ * Return:
+ *   0 on success,
+ *   -EACCES if VMA permissions exceed enclave page permissions
+ */
+int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
+		     unsigned long end, unsigned long vm_prot_bits)
+{
+	unsigned long idx, idx_start, idx_end;
+	struct sgx_encl_page *page;
+
+	/* PROT_NONE always succeeds. */
+	if (!vm_prot_bits)
+		return 0;
+
+	idx_start = PFN_DOWN(start);
+	idx_end = PFN_DOWN(end - 1);
+
+	for (idx = idx_start; idx <= idx_end; ++idx) {
+		mutex_lock(&encl->lock);
+		page = radix_tree_lookup(&encl->page_tree, idx);
+		mutex_unlock(&encl->lock);
+
+		if (!page || (~page->vm_prot_bits & vm_prot_bits))
+			return -EACCES;
+	}
+
+	return 0;
+}
+
+static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end, unsigned long prot)
+{
+	return sgx_encl_may_map(vma->vm_private_data, start, end,
+				calc_vm_prot_bits(prot, 0));
+}
+
+const struct vm_operations_struct sgx_vm_ops = {
+	.open = sgx_vma_open,
+	.fault = sgx_vma_fault,
+	.may_mprotect = sgx_vma_mprotect,
+};
+
+/**
+ * sgx_encl_find - find an enclave
+ * @mm:		mm struct of the current process
+ * @addr:	address in the ELRANGE
+ * @vma:	the resulting VMA
+ *
+ * Find an enclave identified by the given address. Give back a VMA that is
+ * part of the enclave and located in that address. The VMA is given back if it
+ * is a proper enclave VMA even if an &sgx_encl instance does not exist yet
+ * (enclave creation has not been performed).
+ *
+ * Return:
+ *   0 on success,
+ *   -EINVAL if an enclave was not found,
+ *   -ENOENT if the enclave has not been created yet
+ */
+int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
+		  struct vm_area_struct **vma)
+{
+	struct vm_area_struct *result;
+	struct sgx_encl *encl;
+
+	result = find_vma(mm, addr);
+	if (!result || result->vm_ops != &sgx_vm_ops || addr < result->vm_start)
+		return -EINVAL;
+
+	encl = result->vm_private_data;
+	*vma = result;
+
+	return encl ? 0 : -ENOENT;
+}
+
+/**
+ * sgx_encl_destroy() - destroy enclave resources
+ * @encl:	an &sgx_encl instance
+ */
+void sgx_encl_destroy(struct sgx_encl *encl)
+{
+	struct sgx_encl_page *entry;
+	struct radix_tree_iter iter;
+	void **slot;
+
+	encl->flags |= SGX_ENCL_DEAD;
+
+	radix_tree_for_each_slot(slot, &encl->page_tree, &iter, 0) {
+		entry = *slot;
+		if (entry->epc_page) {
+			if (!__sgx_free_page(entry->epc_page)) {
+				encl->secs_child_cnt--;
+				entry->epc_page = NULL;
+
+			}
+
+			radix_tree_delete(&entry->encl->page_tree,
+					  PFN_DOWN(entry->desc));
+		}
+	}
+
+	if (!encl->secs_child_cnt && encl->secs.epc_page) {
+		sgx_free_page(encl->secs.epc_page);
+		encl->secs.epc_page = NULL;
+	}
+}
+
+/**
+ * sgx_encl_release - Destroy an enclave instance
+ * @kref:	address of a kref inside &sgx_encl
+ *
+ * Used together with kref_put(). Frees all the resources associated with the
+ * enclave and the instance itself.
+ */
+void sgx_encl_release(struct kref *ref)
+{
+	struct sgx_encl *encl = container_of(ref, struct sgx_encl, refcount);
+
+	sgx_encl_destroy(encl);
+
+	if (encl->backing)
+		fput(encl->backing);
+
+	WARN_ONCE(!list_empty(&encl->mm_list), "sgx: mm_list non-empty");
+
+	kfree(encl);
+}
+
+/**
+ * sgx_encl_get_index() - Convert a page descriptor to a page index
+ * @encl:	an enclave
+ * @page:	an enclave page
+ *
+ * Given an enclave page descriptor, convert it to a page index used to access
+ * backing storage. The backing page for SECS is located after the enclave
+ * pages.
+ */
+pgoff_t sgx_encl_get_index(struct sgx_encl *encl, struct sgx_encl_page *page)
+{
+	if (!PFN_DOWN(page->desc))
+		return PFN_DOWN(encl->size);
+
+	return PFN_DOWN(page->desc - encl->base);
+}
+
+/**
+ * sgx_encl_encl_get_backing_page() - Pin the backing page
+ * @encl:	an enclave
+ * @index:	page index
+ *
+ * Return: the pinned backing page
+ */
+struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index)
+{
+	struct inode *inode = encl->backing->f_path.dentry->d_inode;
+	struct address_space *mapping = inode->i_mapping;
+	gfp_t gfpmask = mapping_gfp_mask(mapping);
+
+	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
+}
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
new file mode 100644
index 000000000000..3a186e56f54a
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+/**
+ * Copyright(c) 2016-19 Intel Corporation.
+ */
+#ifndef _X86_ENCL_H
+#define _X86_ENCL_H
+
+#include <linux/cpumask.h>
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/mm_types.h>
+#include <linux/mmu_notifier.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/radix-tree.h>
+#include <linux/srcu.h>
+#include <linux/workqueue.h>
+
+/**
+ * enum sgx_encl_page_desc - defines bits for an enclave page's descriptor
+ * %SGX_ENCL_PAGE_TCS:			The page is a TCS page.
+ * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
+ *
+ * The page address for SECS is zero and is used by the subsystem to recognize
+ * the SECS page.
+ */
+enum sgx_encl_page_desc {
+	SGX_ENCL_PAGE_TCS		= BIT(0),
+	/* Bits 11:3 are available when the page is not swapped. */
+	SGX_ENCL_PAGE_ADDR_MASK		= PAGE_MASK,
+};
+
+#define SGX_ENCL_PAGE_ADDR(encl_page) \
+	((encl_page)->desc & SGX_ENCL_PAGE_ADDR_MASK)
+#define SGX_ENCL_PAGE_VA_OFFSET(encl_page) \
+	((encl_page)->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK)
+
+struct sgx_encl_page {
+	unsigned long desc;
+	unsigned long vm_prot_bits;
+	struct sgx_epc_page *epc_page;
+	struct sgx_encl *encl;
+};
+
+enum sgx_encl_flags {
+	SGX_ENCL_CREATED	= BIT(0),
+	SGX_ENCL_INITIALIZED	= BIT(1),
+	SGX_ENCL_DEBUG		= BIT(2),
+	SGX_ENCL_DEAD		= BIT(3),
+};
+
+struct sgx_encl_mm {
+	struct sgx_encl *encl;
+	struct mm_struct *mm;
+	struct list_head list;
+	struct mmu_notifier mmu_notifier;
+	struct rcu_head rcu;
+};
+
+struct sgx_encl {
+	unsigned int flags;
+	u64 secs_attributes;
+	u64 allowed_attributes;
+	unsigned int page_cnt;
+	unsigned int secs_child_cnt;
+	struct mutex lock;
+	struct list_head mm_list;
+	spinlock_t mm_lock;
+	struct file *backing;
+	struct kref refcount;
+	struct srcu_struct srcu;
+	unsigned long base;
+	unsigned long size;
+	unsigned long ssaframesize;
+	struct radix_tree_root page_tree;
+	struct list_head add_page_reqs;
+	struct work_struct work;
+	struct sgx_encl_page secs;
+	cpumask_t cpumask;
+};
+
+extern const struct vm_operations_struct sgx_vm_ops;
+
+enum sgx_encl_mm_iter {
+	SGX_ENCL_MM_ITER_DONE		= 0,
+	SGX_ENCL_MM_ITER_NEXT		= 1,
+	SGX_ENCL_MM_ITER_RESTART	= 2,
+};
+
+int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
+		  struct vm_area_struct **vma);
+void sgx_encl_destroy(struct sgx_encl *encl);
+void sgx_encl_release(struct kref *ref);
+pgoff_t sgx_encl_get_index(struct sgx_encl *encl, struct sgx_encl_page *page);
+struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index);
+int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
+
+int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
+		     unsigned long end, unsigned long vm_prot_bits);
+#endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index d3ed742e90fe..9d5871f3f5dd 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -8,13 +8,12 @@
 #include <linux/ratelimit.h>
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
+#include "driver/driver.h"
 #include "arch.h"
 #include "encls.h"
 #include "sgx.h"
 
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
-EXPORT_SYMBOL_GPL(sgx_epc_sections);
-
 int sgx_nr_epc_sections;
 
 /* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
@@ -62,7 +61,6 @@ struct sgx_epc_page *sgx_alloc_page(void)
 
 	return ERR_PTR(-ENOMEM);
 }
-EXPORT_SYMBOL_GPL(sgx_alloc_page);
 
 /**
  * __sgx_free_page - Free an EPC page
@@ -90,7 +88,6 @@ int __sgx_free_page(struct sgx_epc_page *page)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__sgx_free_page);
 
 /**
  * sgx_free_page - Free an EPC page and WARN on failure
@@ -107,7 +104,6 @@ void sgx_free_page(struct sgx_epc_page *page)
 	ret = __sgx_free_page(page);
 	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
 }
-EXPORT_SYMBOL_GPL(sgx_free_page);
 
 static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
 {
@@ -155,7 +151,6 @@ int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
 	preempt_enable();
 	return ret;
 }
-EXPORT_SYMBOL(sgx_einit);
 
 static __init void sgx_free_epc_section(struct sgx_epc_section *section)
 {
@@ -288,12 +283,22 @@ static __init int sgx_init(void)
 		return ret;
 
 	ret = sgx_page_reclaimer_init();
-	if (ret) {
-		sgx_page_cache_teardown();
-		return ret;
-	}
+	if (ret)
+		goto err_page_cache;
+
+	ret = sgx_drv_init();
+	if (ret)
+		goto err_kthread;
 
 	return 0;
+
+err_kthread:
+	kthread_stop(ksgxswapd_tsk);
+
+err_page_cache:
+	sgx_page_cache_teardown();
+
+	return ret;
 }
 
 arch_initcall(sgx_init);
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 042769f03be9..62a9233330f9 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -12,7 +12,7 @@
 #include "encls.h"
 #include "sgx.h"
 
-static struct task_struct *ksgxswapd_tsk;
+struct task_struct *ksgxswapd_tsk;
 
 static void sgx_sanitize_section(struct sgx_epc_section *section)
 {
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 41d4130c33a2..fa37da4c7b63 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -61,6 +61,7 @@ static inline void *sgx_epc_addr(struct sgx_epc_page *page)
 }
 
 extern int sgx_nr_epc_sections;
+extern struct task_struct *ksgxswapd_tsk;
 
 int sgx_page_reclaimer_init(void);
 
-- 
2.20.1

