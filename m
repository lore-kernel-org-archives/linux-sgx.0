Return-Path: <SRS0=YHr7=A3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAE4C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 14:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79763206C1
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 14:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgGPOEH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Jul 2020 10:04:07 -0400
Received: from mga04.intel.com ([192.55.52.120]:27937 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728418AbgGPOEG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 Jul 2020 10:04:06 -0400
IronPort-SDR: OrCtEn9g6LK4RE7pc1QcCyaPLn3zlicujTW5wgSHFRalW+GaKA8WxRC2Mjq98xOxIy4uTGCKyl
 x9TDWUdikRcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="146890385"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="146890385"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 06:56:04 -0700
IronPort-SDR: Mc1cpc6ARCVvNYGc3M5mSF0wp4DUH/aFNNeo8GTgLQP4R0ivfeIc4ZGovbgD+mMskzmPNMJyDJ
 K0yJlszkdb1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="325150482"
Received: from lettner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.212])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2020 06:55:49 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v36 11/24] x86/sgx: Add SGX enclave driver
Date:   Thu, 16 Jul 2020 16:52:50 +0300
Message-Id: <20200716135303.276442-12-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Intel Software Guard eXtensions (SGX) is a set of CPU instructions that can
be used by applications to set aside private regions of code and data. The
code outside the SGX hosted software entity is prevented from accessing the
memory inside the enclave by the CPU. We call these entities enclaves.

Add a driver that provides an ioctl API to construct and run enclaves.
Enclaves are constructed from pages residing in reserved physical memory
areas. The contents of these pages can only be accessed when they are
mapped as part of an enclave, by a hardware thread running inside the
enclave.

The starting state of an enclave consists of a fixed measured set of
pages that are copied to the EPC during the construction process by
using ENCLS leaf functions and Software Enclave Control Structure (SECS)
that defines the enclave properties.

Enclaves are constructed by using ENCLS leaf functions ECREATE, EADD and
EINIT. ECREATE initializes SECS, EADD copies pages from system memory to
the EPC and EINIT checks a given signed measurement and moves the enclave
into a state ready for execution.

An initialized enclave can only be accessed through special Thread Control
Structure (TCS) pages by using ENCLU (ring-3 only) leaf EENTER.  This leaf
function converts a thread into enclave mode and continues the execution in
the offset defined by the TCS provided to EENTER. An enclave is exited
through syscall, exception, interrupts or by explicitly calling another
ENCLU leaf EEXIT.

The mmap() permissions are capped by the contained enclave page
permissions. The mapped areas must also be opaque, i.e. each page address
must contain a page. This logic is implemented in sgx_encl_may_map().

Cc: linux-security-module@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Acked-by: Jethro Beekman <jethro@fortanix.com>
Tested-by: Jethro Beekman <jethro@fortanix.com>
Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
Tested-by: Seth Moore <sethmo@google.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/Makefile |   2 +
 arch/x86/kernel/cpu/sgx/driver.c | 177 ++++++++++++++++
 arch/x86/kernel/cpu/sgx/driver.h |  29 +++
 arch/x86/kernel/cpu/sgx/encl.c   | 333 +++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.h   |  87 ++++++++
 arch/x86/kernel/cpu/sgx/main.c   |  11 +
 6 files changed, 639 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/sgx/driver.c
 create mode 100644 arch/x86/kernel/cpu/sgx/driver.h
 create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
 create mode 100644 arch/x86/kernel/cpu/sgx/encl.h

diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index 79510ce01b3b..3fc451120735 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -1,2 +1,4 @@
 obj-y += \
+	driver.o \
+	encl.o \
 	main.o
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
new file mode 100644
index 000000000000..b52520407f5b
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include <linux/acpi.h>
+#include <linux/miscdevice.h>
+#include <linux/mman.h>
+#include <linux/security.h>
+#include <linux/suspend.h>
+#include <asm/traps.h>
+#include "driver.h"
+#include "encl.h"
+
+MODULE_DESCRIPTION("Intel SGX Enclave Driver");
+MODULE_AUTHOR("Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>");
+MODULE_LICENSE("Dual BSD/GPL");
+
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
+	atomic_set(&encl->flags, 0);
+	kref_init(&encl->refcount);
+	xa_init(&encl->page_array);
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
+	}
+
+	mutex_lock(&encl->lock);
+	atomic_or(SGX_ENCL_DEAD, &encl->flags);
+	mutex_unlock(&encl->lock);
+
+	kref_put(&encl->refcount, sgx_encl_release);
+	return 0;
+}
+
+static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct sgx_encl *encl = file->private_data;
+	int ret;
+
+	ret = sgx_encl_may_map(encl, vma->vm_start, vma->vm_end, vma->vm_flags);
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
+	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
+}
+
+static const struct file_operations sgx_encl_fops = {
+	.owner			= THIS_MODULE,
+	.open			= sgx_open,
+	.release		= sgx_release,
+	.mmap			= sgx_mmap,
+	.get_unmapped_area	= sgx_get_unmapped_area,
+};
+
+static struct miscdevice sgx_dev_enclave = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "enclave",
+	.nodename = "sgx/enclave",
+	.fops = &sgx_encl_fops,
+};
+
+int __init sgx_drv_init(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	u64 attr_mask, xfrm_mask;
+	int ret;
+	int i;
+
+	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
+		pr_info("The public key MSRs are not writable.\n");
+		return -ENODEV;
+	}
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
+	ret = misc_register(&sgx_dev_enclave);
+	if (ret) {
+		pr_err("Creating /dev/sgx/enclave failed with %d.\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
new file mode 100644
index 000000000000..f7ce40dedc91
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver.h
@@ -0,0 +1,29 @@
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
+#include "sgx.h"
+
+#define SGX_EINIT_SPIN_COUNT	20
+#define SGX_EINIT_SLEEP_COUNT	50
+#define SGX_EINIT_SLEEP_TIME	20
+
+extern u64 sgx_encl_size_max_32;
+extern u64 sgx_encl_size_max_64;
+extern u32 sgx_misc_reserved_mask;
+extern u64 sgx_attributes_reserved_mask;
+extern u64 sgx_xfrm_reserved_mask;
+extern u32 sgx_xsave_size_tbl[64];
+
+long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
+
+int sgx_drv_init(void);
+
+#endif /* __ARCH_X86_SGX_DRIVER_H__ */
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
new file mode 100644
index 000000000000..af5df6bc58f3
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -0,0 +1,333 @@
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
+#include "encls.h"
+#include "sgx.h"
+
+static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
+						unsigned long addr)
+{
+	struct sgx_encl_page *entry;
+	unsigned int flags;
+
+	/* If process was forked, VMA is still there but vm_private_data is set
+	 * to NULL.
+	 */
+	if (!encl)
+		return ERR_PTR(-EFAULT);
+
+	flags = atomic_read(&encl->flags);
+
+	if ((flags & SGX_ENCL_DEAD) || !(flags & SGX_ENCL_INITIALIZED))
+		return ERR_PTR(-EFAULT);
+
+	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
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
+		mmu_notifier_put(mn);
+	}
+}
+
+static void sgx_mmu_notifier_free(struct mmu_notifier *mn)
+{
+	struct sgx_encl_mm *encl_mm =
+		container_of(mn, struct sgx_encl_mm, mmu_notifier);
+
+	kfree(encl_mm);
+}
+
+static const struct mmu_notifier_ops sgx_mmu_notifier_ops = {
+	.release		= sgx_mmu_notifier_release,
+	.free_notifier		= sgx_mmu_notifier_free,
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
+	/* mm_list can be accessed only by a single thread at a time. */
+	mmap_assert_write_locked(mm);
+
+	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD)
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
+ * page to be mapped.
+ *
+ * Return:
+ *   0 on success,
+ *   -EACCES if VMA permissions exceed enclave page permissions
+ */
+int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
+		     unsigned long end, unsigned long vm_flags)
+{
+	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
+	unsigned long idx_start = PFN_DOWN(start);
+	unsigned long idx_end = PFN_DOWN(end - 1);
+	struct sgx_encl_page *page;
+	XA_STATE(xas, &encl->page_array, idx_start);
+
+	/*
+	 * Disallow RIE tasks as their VMA permissions might conflict with the
+	 * enclave page permissions.
+	 */
+	if (!!(current->personality & READ_IMPLIES_EXEC))
+		return -EACCES;
+
+	xas_for_each(&xas, page, idx_end)
+		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
+			return -EACCES;
+
+	return 0;
+}
+
+static int sgx_vma_mprotect(struct vm_area_struct *vma,
+			    struct vm_area_struct **pprev, unsigned long start,
+			    unsigned long end, unsigned long newflags)
+{
+	int ret;
+
+	ret = sgx_encl_may_map(vma->vm_private_data, start, end, newflags);
+	if (ret)
+		return ret;
+
+	return mprotect_fixup(vma, pprev, start, end, newflags);
+}
+
+const struct vm_operations_struct sgx_vm_ops = {
+	.open = sgx_vma_open,
+	.fault = sgx_vma_fault,
+	.mprotect = sgx_vma_mprotect,
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
+	unsigned long index;
+
+	atomic_or(SGX_ENCL_DEAD, &encl->flags);
+
+	xa_for_each(&encl->page_array, index, entry) {
+		if (entry->epc_page) {
+			sgx_free_epc_page(entry->epc_page);
+			encl->secs_child_cnt--;
+			entry->epc_page = NULL;
+		}
+
+		kfree(entry);
+	}
+
+	xa_destroy(&encl->page_array);
+
+	if (!encl->secs_child_cnt && encl->secs.epc_page) {
+		sgx_free_epc_page(encl->secs.epc_page);
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
+	cleanup_srcu_struct(&encl->srcu);
+
+	WARN_ON_ONCE(!list_empty(&encl->mm_list));
+
+	/* Detect EPC page leak's. */
+	WARN_ON_ONCE(encl->secs_child_cnt);
+	WARN_ON_ONCE(encl->secs.epc_page);
+
+	kfree(encl);
+}
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
new file mode 100644
index 000000000000..74ad6c4da783
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -0,0 +1,87 @@
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
+#include <linux/srcu.h>
+#include <linux/workqueue.h>
+#include <linux/xarray.h>
+#include "sgx.h"
+
+/**
+ * enum sgx_encl_page_desc - defines bits for an enclave page's descriptor
+ * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
+ *
+ * The page address for SECS is zero and is used by the subsystem to recognize
+ * the SECS page.
+ */
+enum sgx_encl_page_desc {
+	/* Bits 11:3 are available when the page is not swapped. */
+	SGX_ENCL_PAGE_ADDR_MASK		= PAGE_MASK,
+};
+
+#define SGX_ENCL_PAGE_ADDR(page) \
+	((page)->desc & SGX_ENCL_PAGE_ADDR_MASK)
+
+struct sgx_encl_page {
+	unsigned long desc;
+	unsigned long vm_max_prot_bits;
+	struct sgx_epc_page *epc_page;
+	struct sgx_encl *encl;
+};
+
+enum sgx_encl_flags {
+	SGX_ENCL_CREATED	= BIT(0),
+	SGX_ENCL_INITIALIZED	= BIT(1),
+	SGX_ENCL_DEBUG		= BIT(2),
+	SGX_ENCL_DEAD		= BIT(3),
+	SGX_ENCL_IOCTL		= BIT(4),
+};
+
+struct sgx_encl_mm {
+	struct sgx_encl *encl;
+	struct mm_struct *mm;
+	struct list_head list;
+	struct mmu_notifier mmu_notifier;
+};
+
+struct sgx_encl {
+	atomic_t flags;
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
+	struct xarray page_array;
+	struct sgx_encl_page secs;
+	cpumask_t cpumask;
+};
+
+extern const struct vm_operations_struct sgx_vm_ops;
+
+int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
+		  struct vm_area_struct **vma);
+void sgx_encl_destroy(struct sgx_encl *encl);
+void sgx_encl_release(struct kref *ref);
+int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
+int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
+		     unsigned long end, unsigned long vm_flags);
+
+#endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 97c6895fb6c9..4137254fb29e 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -9,6 +9,8 @@
 #include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
+#include "driver.h"
+#include "encl.h"
 #include "encls.h"
 
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
@@ -260,6 +262,8 @@ static bool __init sgx_page_cache_init(void)
 
 static void __init sgx_init(void)
 {
+	int ret;
+
 	if (!boot_cpu_has(X86_FEATURE_SGX))
 		return;
 
@@ -269,8 +273,15 @@ static void __init sgx_init(void)
 	if (!sgx_page_reclaimer_init())
 		goto err_page_cache;
 
+	ret = sgx_drv_init();
+	if (ret)
+		goto err_kthread;
+
 	return;
 
+err_kthread:
+	kthread_stop(ksgxswapd_tsk);
+
 err_page_cache:
 	sgx_page_cache_teardown();
 }
-- 
2.25.1

