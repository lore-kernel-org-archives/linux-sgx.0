Return-Path: <SRS0=rDpG=ST=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA54DC10F12
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Apr 2019 10:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 999F72173C
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Apr 2019 10:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbfDQKlk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:41:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:33525 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729522AbfDQKlk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 17 Apr 2019 06:41:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 03:41:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,361,1549958400"; 
   d="scan'208";a="132120080"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by orsmga007.jf.intel.com with ESMTP; 17 Apr 2019 03:41:31 -0700
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
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v20 15/28] x86/sgx: Add the Linux SGX Enclave Driver
Date:   Wed, 17 Apr 2019 13:39:25 +0300
Message-Id: <20190417103938.7762-16-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
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
 arch/x86/Kconfig                        |  15 +
 arch/x86/include/uapi/asm/sgx.h         |  57 ++
 arch/x86/kernel/cpu/sgx/Makefile        |   3 +-
 arch/x86/kernel/cpu/sgx/driver/Makefile |   3 +
 arch/x86/kernel/cpu/sgx/driver/driver.h |  38 ++
 arch/x86/kernel/cpu/sgx/driver/ioctl.c  | 750 ++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/driver/main.c   | 358 +++++++++++
 arch/x86/kernel/cpu/sgx/encl.c          | 349 +++++++++++
 arch/x86/kernel/cpu/sgx/encl.h          |  98 ++++
 arch/x86/kernel/cpu/sgx/encls.c         |   1 +
 arch/x86/kernel/cpu/sgx/main.c          |   3 +
 arch/x86/kernel/cpu/sgx/sgx.h           |   1 +
 13 files changed, 1676 insertions(+), 1 deletion(-)
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
index 5d90a20621cb..adea370b331f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1933,6 +1933,21 @@ config INTEL_SGX
 
 	  If unsure, say N.
 
+config INTEL_SGX_DRIVER
+	tristate "Intel(R) SGX Driver"
+	default n
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
index 000000000000..7bf627ac4958
--- /dev/null
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -0,0 +1,57 @@
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
+/* IOCTL return values */
+#define SGX_POWER_LOST_ENCLAVE		0x40000000
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
+ */
+struct sgx_enclave_add_page {
+	__u64	addr;
+	__u64	src;
+	__u64	secinfo;
+	__u16	mrmask;
+} __attribute__((__packed__));
+
+
+/**
+ * struct sgx_enclave_init - parameter structure for the
+ *                           %SGX_IOC_ENCLAVE_INIT ioctl
+ * @sigstruct:	address for the SIGSTRUCT data
+ */
+struct sgx_enclave_init {
+	__u64	sigstruct;
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
index 000000000000..507712eb0a68
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+/**
+ * Copyright(c) 2016-19 Intel Corporation.
+ */
+#ifndef __ARCH_INTEL_SGX_H__
+#define __ARCH_INTEL_SGX_H__
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
+#endif /* __ARCH_X86_INTEL_SGX_H__ */
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
new file mode 100644
index 000000000000..f88226518b21
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -0,0 +1,750 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-19 Intel Corporation.
+
+#include <asm/mman.h>
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
+	if (encl->flags & (SGX_ENCL_SUSPEND | SGX_ENCL_DEAD))
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
+	} while (!kref_put(&encl->refcount, sgx_encl_release) && !is_empty);
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
+						 unsigned long addr)
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
+	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
+				encl_page);
+	if (ret) {
+		kfree(encl_page);
+		return ERR_PTR(ret);
+	}
+	return encl_page;
+}
+
+static int sgx_encl_pm_notifier(struct notifier_block *nb,
+				unsigned long action, void *data)
+{
+	struct sgx_encl *encl = container_of(nb, struct sgx_encl, pm_notifier);
+
+	if (action != PM_SUSPEND_PREPARE && action != PM_HIBERNATION_PREPARE)
+		return NOTIFY_DONE;
+
+	mutex_lock(&encl->lock);
+	sgx_encl_destroy(encl);
+	encl->flags |= SGX_ENCL_SUSPEND;
+	mutex_unlock(&encl->lock);
+	flush_work(&encl->work);
+	return NOTIFY_DONE;
+}
+
+static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
+{
+	unsigned long encl_size = secs->size + PAGE_SIZE;
+	struct sgx_epc_page *secs_epc;
+	struct sgx_encl_mm *encl_mm;
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
+	encl_mm = sgx_encl_mm_add(encl, current->mm);
+	if (IS_ERR(encl_mm)) {
+		ret = PTR_ERR(encl_mm);
+		goto err_out;
+	}
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
+	encl->pm_notifier.notifier_call = &sgx_encl_pm_notifier;
+	ret = register_pm_notifier(&encl->pm_notifier);
+	if (ret) {
+		encl->pm_notifier.notifier_call = NULL;
+		goto err_out;
+	}
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
+	if (!list_empty(&encl->mm_list)) {
+		encl_mm = list_first_entry(&encl->mm_list, struct sgx_encl_mm,
+					   list);
+		list_del(&encl_mm->list);
+		kfree(encl_mm);
+	}
+
+	mutex_unlock(&encl->lock);
+	return ret;
+}
+
+/**
+ * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
+ * @filep:	open file to /dev/sgx
+ * @cmd:	the command value
+ * @arg:	pointer to an &sgx_enclave_create instance
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
+static long sgx_ioc_enclave_create(struct file *filep, unsigned int cmd,
+				   unsigned long arg)
+{
+	struct sgx_enclave_create *createp = (struct sgx_enclave_create *)arg;
+	struct sgx_encl *encl = filep->private_data;
+	struct page *secs_page;
+	struct sgx_secs *secs;
+	int ret;
+
+	secs_page = alloc_page(GFP_HIGHUSER);
+	if (!secs_page)
+		return -ENOMEM;
+
+	secs = kmap(secs_page);
+	if (copy_from_user(secs, (void __user *)createp->src, sizeof(*secs))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
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
+	kref_get(&encl->refcount);
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
+			     unsigned int mrmask)
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
+	encl_page = sgx_encl_page_alloc(encl, addr);
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
+/**
+ * sgx_ioc_enclave_add_page - handler for %SGX_IOC_ENCLAVE_ADD_PAGE
+ *
+ * @filep:	open file to /dev/sgx
+ * @cmd:	the command value
+ * @arg:	pointer to an &sgx_enclave_add_page instance
+ *
+ * Add a page to an uninitialized enclave (EADD), and optionally extend the
+ * enclave's measurement with the contents of the page (EEXTEND).  EADD and
+ * EEXTEND are done asynchronously via worker threads.  A successful
+ * sgx_ioc_enclave_add_page() only indicates the page has been added to the
+ * work queue, it does not guarantee adding the page to the enclave will
+ * succeed.
+ *
+ * Return:
+ *   0 on success,
+ *   -errno otherwise
+ */
+static long sgx_ioc_enclave_add_page(struct file *filep, unsigned int cmd,
+				     unsigned long arg)
+{
+	struct sgx_enclave_add_page *addp = (void *)arg;
+	struct sgx_encl *encl = filep->private_data;
+	struct sgx_secinfo secinfo;
+	struct page *data_page;
+	void *data;
+	int ret;
+
+	if (copy_from_user(&secinfo, (void __user *)addp->secinfo,
+			   sizeof(secinfo)))
+		return -EFAULT;
+
+	data_page = alloc_page(GFP_HIGHUSER);
+	if (!data_page)
+		return -ENOMEM;
+
+	data = kmap(data_page);
+
+	if (copy_from_user((void *)data, (void __user *)addp->src, PAGE_SIZE)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = sgx_encl_add_page(encl, addp->addr, data, &secinfo, addp->mrmask);
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
+	shash->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
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
+ * @cmd:	the command value
+ * @arg:	pointer to an &sgx_enclave_init instance
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
+static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
+				 unsigned long arg)
+{
+	struct sgx_enclave_init *initp = (struct sgx_enclave_init *)arg;
+	struct sgx_encl *encl = filep->private_data;
+	struct sgx_einittoken *einittoken;
+	struct sgx_sigstruct *sigstruct;
+	struct page *initp_page;
+	int ret;
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
+	if (copy_from_user(sigstruct, (void __user *)initp->sigstruct,
+			   sizeof(*sigstruct))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+
+	ret = sgx_encl_init(encl, sigstruct, einittoken);
+
+out:
+	kunmap(initp_page);
+	__free_page(initp_page);
+	return ret;
+}
+
+typedef long (*sgx_ioc_t)(struct file *filep, unsigned int cmd,
+			  unsigned long arg);
+
+long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	char data[256];
+	sgx_ioc_t handler = NULL;
+	long ret;
+
+	switch (cmd) {
+	case SGX_IOC_ENCLAVE_CREATE:
+		handler = sgx_ioc_enclave_create;
+		break;
+	case SGX_IOC_ENCLAVE_ADD_PAGE:
+		handler = sgx_ioc_enclave_add_page;
+		break;
+	case SGX_IOC_ENCLAVE_INIT:
+		handler = sgx_ioc_enclave_init;
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	if (copy_from_user(data, (void __user *)arg, _IOC_SIZE(cmd)))
+		return -EFAULT;
+
+	ret = handler(filep, cmd, (unsigned long)((void *)data));
+	if (!ret && (cmd & IOC_OUT)) {
+		if (copy_to_user((void __user *)arg, data, _IOC_SIZE(cmd)))
+			return -EFAULT;
+	}
+
+	return ret;
+}
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
new file mode 100644
index 000000000000..d371add399cd
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -0,0 +1,358 @@
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
+	file->private_data = encl;
+
+	return 0;
+}
+
+static int sgx_release(struct inode *inode, struct file *file)
+{
+	struct sgx_encl *encl = file->private_data;
+
+	kref_put(&encl->refcount, sgx_encl_release);
+
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
+
+	vma->vm_ops = &sgx_vm_ops;
+	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
+	vma->vm_private_data = encl;
+
+	kref_get(&encl->refcount);
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
+	if (len < 2 * PAGE_SIZE || len & (len - 1) || flags & MAP_PRIVATE)
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
+static const struct file_operations sgx_provision_fops = {
+	.owner			= THIS_MODULE,
+};
+
+static struct bus_type sgx_bus_type = {
+	.name	= "sgx",
+};
+
+struct sgx_dev_ctx {
+	struct device encl_dev;
+	struct cdev encl_cdev;
+	struct device provision_dev;
+	struct cdev provision_cdev;
+	struct kref refcount;
+};
+
+static dev_t sgx_devt;
+
+static void sgx_dev_ctx_free(struct kref *ref)
+{
+	struct sgx_dev_ctx *ctx = container_of(ref, struct sgx_dev_ctx,
+					       refcount);
+
+	kfree(ctx);
+}
+
+static void sgx_dev_release(struct device *dev)
+{
+	struct sgx_dev_ctx *ctx = container_of(dev, struct sgx_dev_ctx,
+					       encl_dev);
+
+	kref_put(&ctx->refcount, sgx_dev_ctx_free);
+}
+
+static int sgx_dev_populate(const char *name, struct device *dev,
+			    struct cdev *cdev, struct device *parent,
+			    const struct file_operations *fops,
+			    int minor)
+{
+	int ret;
+
+	device_initialize(dev);
+
+	dev->bus = &sgx_bus_type;
+	dev->parent = parent;
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
+static struct sgx_dev_ctx *sgx_dev_ctx_alloc(struct device *parent)
+{
+	struct sgx_dev_ctx *ctx;
+	int ret;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&ctx->refcount);
+	kref_get(&ctx->refcount);
+
+	ret = sgx_dev_populate("sgx/enclave", &ctx->encl_dev, &ctx->encl_cdev,
+			       parent, &sgx_encl_fops, 0);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = sgx_dev_populate("sgx/provision", &ctx->provision_dev,
+			       &ctx->provision_cdev, parent,
+			       &sgx_provision_fops, 1);
+	if (ret) {
+		put_device(&ctx->encl_dev);
+		return ERR_PTR(ret);
+	}
+
+	dev_set_drvdata(parent, ctx);
+
+	return ctx;
+}
+
+static struct sgx_dev_ctx *sgxm_dev_ctx_alloc(struct device *parent)
+{
+	struct sgx_dev_ctx *ctx;
+	int rc;
+
+	ctx = sgx_dev_ctx_alloc(parent);
+	if (IS_ERR(ctx))
+		return ctx;
+
+	rc = devm_add_action_or_reset(parent, (void (*)(void *))put_device,
+				      &ctx->encl_dev);
+	if (rc)
+		return ERR_PTR(rc);
+
+	rc = devm_add_action_or_reset(parent, (void (*)(void *))put_device,
+				      &ctx->provision_dev);
+	if (rc)
+		return ERR_PTR(rc);
+
+	return ctx;
+}
+
+static int sgx_dev_init(struct device *parent)
+{
+	struct sgx_dev_ctx *sgx_dev;
+	unsigned int eax;
+	unsigned int ebx;
+	unsigned int ecx;
+	unsigned int edx;
+	u64 attr_mask;
+	u64 xfrm_mask;
+	int ret;
+	int i;
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
+	sgx_dev = sgxm_dev_ctx_alloc(parent);
+	if (IS_ERR(sgx_dev))
+		return PTR_ERR(sgx_dev);
+
+	sgx_encl_wq = alloc_workqueue("sgx-encl-wq",
+				      WQ_UNBOUND | WQ_FREEZABLE, 1);
+	if (!sgx_encl_wq)
+		return -ENOMEM;
+
+	ret = cdev_device_add(&sgx_dev->encl_cdev, &sgx_dev->encl_dev);
+	if (ret)
+		goto err_encl_dev_add;
+
+	return 0;
+
+err_encl_dev_add:
+	destroy_workqueue(sgx_encl_wq);
+
+	return ret;
+}
+
+static int sgx_drv_probe(struct platform_device *pdev)
+{
+	if (!sgx_enabled) {
+		pr_info("sgx: SGX is not enabled in the core\n");
+		return -ENODEV;
+	}
+
+	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
+		pr_info("sgx: The public key MSRs are not writable\n");
+		return -ENODEV;
+	}
+
+	return sgx_dev_init(&pdev->dev);
+}
+
+static int sgx_drv_remove(struct platform_device *pdev)
+{
+	struct sgx_dev_ctx *ctx = dev_get_drvdata(&pdev->dev);
+
+	cdev_device_del(&ctx->encl_cdev, &ctx->encl_dev);
+	destroy_workqueue(sgx_encl_wq);
+
+	return 0;
+}
+
+#ifdef CONFIG_ACPI
+static struct acpi_device_id sgx_device_ids[] = {
+	{"INT0E0C", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, sgx_device_ids);
+#endif
+
+static struct platform_driver sgx_drv = {
+	.probe = sgx_drv_probe,
+	.remove = sgx_drv_remove,
+	.driver = {
+		.name			= "sgx",
+		.acpi_match_table	= ACPI_PTR(sgx_device_ids),
+	},
+};
+
+static int __init sgx_drv_subsys_init(void)
+{
+	int ret;
+
+	ret = bus_register(&sgx_bus_type);
+	if (ret)
+		return ret;
+
+	ret = alloc_chrdev_region(&sgx_devt, 0, SGX_DRV_NR_DEVICES, "sgx");
+	if (ret < 0) {
+		bus_unregister(&sgx_bus_type);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void sgx_drv_subsys_exit(void)
+{
+	bus_unregister(&sgx_bus_type);
+	unregister_chrdev_region(sgx_devt, SGX_DRV_NR_DEVICES);
+}
+
+static int __init sgx_drv_init(void)
+{
+	int ret;
+
+	ret = sgx_drv_subsys_init();
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&sgx_drv);
+	if (ret)
+		sgx_drv_subsys_exit();
+
+	return ret;
+}
+module_init(sgx_drv_init);
+
+static void __exit sgx_drv_exit(void)
+{
+	platform_driver_unregister(&sgx_drv);
+	sgx_drv_subsys_exit();
+}
+module_exit(sgx_drv_exit);
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
new file mode 100644
index 000000000000..cc3bd4a4d82b
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -0,0 +1,349 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include <linux/mm.h>
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
+struct sgx_encl_mm *sgx_encl_mm_add(struct sgx_encl *encl,
+				    struct mm_struct *mm)
+{
+	struct sgx_encl_mm *encl_mm;
+
+	encl_mm = kzalloc(sizeof(*encl_mm), GFP_KERNEL);
+	if (!encl_mm)
+		return ERR_PTR(-ENOMEM);
+
+	encl_mm->encl = encl;
+	encl_mm->mm = mm;
+	kref_init(&encl_mm->refcount);
+
+	spin_lock(&encl->mm_lock);
+	list_add(&encl_mm->list, &encl->mm_list);
+	spin_unlock(&encl->mm_lock);
+
+	return encl_mm;
+}
+EXPORT_SYMBOL_GPL(sgx_encl_mm_add);
+
+void sgx_encl_mm_release(struct kref *ref)
+{
+	struct sgx_encl_mm *encl_mm =
+		container_of(ref, struct sgx_encl_mm, refcount);
+
+	spin_lock(&encl_mm->encl->mm_lock);
+	list_del(&encl_mm->list);
+	spin_unlock(&encl_mm->encl->mm_lock);
+
+	kfree(encl_mm);
+}
+
+static struct sgx_encl_mm *sgx_encl_get_mm(struct sgx_encl *encl,
+					   struct mm_struct *mm)
+{
+	struct sgx_encl_mm *encl_mm = NULL;
+	struct sgx_encl_mm *prev_mm = NULL;
+	int iter;
+
+	while (true) {
+		encl_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
+		if (prev_mm)
+			kref_put(&prev_mm->refcount, sgx_encl_mm_release);
+		prev_mm = encl_mm;
+
+		if (iter == SGX_ENCL_MM_ITER_DONE)
+			break;
+
+		if (iter == SGX_ENCL_MM_ITER_RESTART)
+			continue;
+
+		if (mm == encl_mm->mm)
+			return encl_mm;
+	}
+
+	return NULL;
+}
+
+static void sgx_vma_open(struct vm_area_struct *vma)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_encl_mm *encl_mm;
+
+	if (!encl)
+		return;
+
+	if (encl->flags & SGX_ENCL_DEAD)
+		goto error;
+
+	encl_mm = sgx_encl_get_mm(encl, vma->vm_mm);
+	if (!encl_mm) {
+		encl_mm = sgx_encl_mm_add(encl, vma->vm_mm);
+		if (IS_ERR(encl_mm))
+			goto error;
+	}
+
+	kref_get(&encl->refcount);
+	return;
+
+error:
+	vma->vm_private_data = NULL;
+}
+
+static void sgx_vma_close(struct vm_area_struct *vma)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_encl_mm *encl_mm;
+
+	if (!encl)
+		return;
+
+	encl_mm = sgx_encl_get_mm(encl, vma->vm_mm);
+	if (encl_mm) {
+		kref_put(&encl_mm->refcount, sgx_encl_mm_release);
+
+		/* Release kref for the VMA. */
+		kref_put(&encl_mm->refcount, sgx_encl_mm_release);
+	}
+
+	kref_put(&encl->refcount, sgx_encl_release);
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
+const struct vm_operations_struct sgx_vm_ops = {
+	.close = sgx_vma_close,
+	.open = sgx_vma_open,
+	.fault = sgx_vma_fault,
+};
+EXPORT_SYMBOL_GPL(sgx_vm_ops);
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
+EXPORT_SYMBOL_GPL(sgx_encl_find);
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
+EXPORT_SYMBOL_GPL(sgx_encl_destroy);
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
+	struct sgx_encl_mm *encl_mm;
+
+	if (encl->pm_notifier.notifier_call)
+		unregister_pm_notifier(&encl->pm_notifier);
+
+	sgx_encl_destroy(encl);
+
+	if (encl->backing)
+		fput(encl->backing);
+
+	WARN(!list_empty(&encl->mm_list), "sgx: mm_list non-empty");
+
+	kfree(encl);
+}
+EXPORT_SYMBOL_GPL(sgx_encl_release);
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
+EXPORT_SYMBOL_GPL(sgx_encl_get_index);
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
+EXPORT_SYMBOL_GPL(sgx_encl_get_backing_page);
+
+/**
+ * sgx_encl_next_mm() - Iterate to the next mm
+ * @encl:	an enclave
+ * @mm:		an mm list entry
+ * @iter:	iterator status
+ *
+ * Return: the enclave mm or NULL
+ */
+struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
+				     struct sgx_encl_mm *encl_mm, int *iter)
+{
+	struct list_head *entry;
+
+	WARN(!encl, "%s: encl is NULL", __func__);
+	WARN(!iter, "%s: iter is NULL", __func__);
+
+	spin_lock(&encl->mm_lock);
+
+	entry = encl_mm ? encl_mm->list.next : encl->mm_list.next;
+	WARN(!entry, "%s: entry is NULL", __func__);
+
+	if (entry == &encl->mm_list) {
+		spin_unlock(&encl->mm_lock);
+		*iter = SGX_ENCL_MM_ITER_DONE;
+		return NULL;
+	}
+
+	encl_mm = list_entry(entry, struct sgx_encl_mm, list);
+
+	if (!kref_get_unless_zero(&encl_mm->refcount)) {
+		spin_unlock(&encl->mm_lock);
+		*iter = SGX_ENCL_MM_ITER_RESTART;
+		return NULL;
+	}
+
+	spin_unlock(&encl->mm_lock);
+	*iter = SGX_ENCL_MM_ITER_NEXT;
+	return encl_mm;
+}
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
new file mode 100644
index 000000000000..1f96991839ad
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -0,0 +1,98 @@
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
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/radix-tree.h>
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
+	struct sgx_epc_page *epc_page;
+	struct sgx_encl *encl;
+};
+
+enum sgx_encl_flags {
+	SGX_ENCL_CREATED	= BIT(0),
+	SGX_ENCL_INITIALIZED	= BIT(1),
+	SGX_ENCL_DEBUG		= BIT(2),
+	SGX_ENCL_SUSPEND	= BIT(3),
+	SGX_ENCL_DEAD		= BIT(4),
+};
+
+struct sgx_encl_mm {
+	struct sgx_encl *encl;
+	struct mm_struct *mm;
+	struct kref refcount;
+	struct list_head list;
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
+	unsigned long base;
+	unsigned long size;
+	unsigned long ssaframesize;
+	struct radix_tree_root page_tree;
+	struct list_head add_page_reqs;
+	struct work_struct work;
+	struct sgx_encl_page secs;
+	struct notifier_block pm_notifier;
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
+struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
+				     struct sgx_encl_mm *encl_mm, int *iter);
+struct sgx_encl_mm *sgx_encl_mm_add(struct sgx_encl *encl,
+				    struct mm_struct *mm);
+void sgx_encl_mm_release(struct kref *ref);
+
+#endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/encls.c b/arch/x86/kernel/cpu/sgx/encls.c
index 5045f1365e07..698cc526bfbf 100644
--- a/arch/x86/kernel/cpu/sgx/encls.c
+++ b/arch/x86/kernel/cpu/sgx/encls.c
@@ -19,3 +19,4 @@ bool encls_failed(int ret)
 
 	return encls_faulted(ret) && ENCLS_TRAPNR(ret) != epcm_trapnr;
 }
+EXPORT_SYMBOL_GPL(encls_failed);
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index d3ed742e90fe..d911a1038712 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -14,6 +14,8 @@
 
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 EXPORT_SYMBOL_GPL(sgx_epc_sections);
+bool sgx_enabled;
+EXPORT_SYMBOL_GPL(sgx_enabled);
 
 int sgx_nr_epc_sections;
 
@@ -293,6 +295,7 @@ static __init int sgx_init(void)
 		return ret;
 	}
 
+	sgx_enabled = true;
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 41d4130c33a2..62a574ed230a 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -35,6 +35,7 @@ struct sgx_epc_section {
 #define SGX_MAX_EPC_SECTIONS	8
 
 extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+extern bool sgx_enabled;
 
 /**
  * enum sgx_epc_page_desc - bits and masks for an EPC page's descriptor
-- 
2.19.1

