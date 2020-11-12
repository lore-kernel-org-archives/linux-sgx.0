Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5B3C2D0E4
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E300A22201
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:03:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5FnTwOY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgKLWDA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:03:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727633AbgKLWC7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Nov 2020 17:02:59 -0500
Received: from suppilovahvero.lan (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69DA922241;
        Thu, 12 Nov 2020 22:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605218578;
        bh=yVgndefqtR/1td76lmvXOkKFH5pxkUAaxXl2DA3iKBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5FnTwOYB88mzgBFAEDOnnCeGX+u6WKXcm8DKoa8gQcqS+3wFCXmWT8XdwT9AXTI1
         Qerq4fV0dhzXNgwNflzs7/hm+7cNHeFboEvTgy/FTzGiEe2zXhFWe3M9TiodDFbNH7
         fMfeD7MdL0eTCXrAeS2ilIbL/4jCuvu4aE0yDsQ0=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v41 11/24] x86/sgx: Add SGX misc driver interface
Date:   Fri, 13 Nov 2020 00:01:22 +0200
Message-Id: <20201112220135.165028-12-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112220135.165028-1-jarkko@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Intel(R) SGX is new hardware functionality that can be used by applications
to set aside private regions of code and data called enclaves. New hardware
protects enclave code and data from outside access and modification.

Add a driver that presents a device file and ioctl API to build and manage
enclaves.  Subsequent patches will expend the ioctl()’s functionality.

Cc: linux-security-module@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Tested-by: Jethro Beekman <jethro@fortanix.com> # v40
# Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
# Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
Changes from v40:
* Do not check !page in sgx_encl_may_map() while iterating.
* Do not check !vm_private_data in sgx_encl_find(), as the enclave is
  created at VFS open.

Changes from v39:
* Rename /dev/sgx/enclave as /dev/sgx_enclave.
* In the page fault handler, do not check for SGX_ENCL_DEAD. This allows
  to do forensics to the memory of debug enclaves.

 arch/x86/kernel/cpu/sgx/Makefile |   2 +
 arch/x86/kernel/cpu/sgx/driver.c | 112 ++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/driver.h |  16 ++++
 arch/x86/kernel/cpu/sgx/encl.c   | 146 +++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.h   |  60 +++++++++++++
 arch/x86/kernel/cpu/sgx/main.c   |  12 ++-
 6 files changed, 347 insertions(+), 1 deletion(-)
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
index 000000000000..248213dea78e
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Copyright(c) 2016-20 Intel Corporation. */
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
+static int sgx_open(struct inode *inode, struct file *file)
+{
+	struct sgx_encl *encl;
+
+	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
+	if (!encl)
+		return -ENOMEM;
+
+	xa_init(&encl->page_array);
+	mutex_init(&encl->lock);
+
+	file->private_data = encl;
+
+	return 0;
+}
+
+static int sgx_release(struct inode *inode, struct file *file)
+{
+	struct sgx_encl *encl = file->private_data;
+	struct sgx_encl_page *entry;
+	unsigned long index;
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
+
+	/* Detect EPC page leak's. */
+	WARN_ON_ONCE(encl->secs_child_cnt);
+	WARN_ON_ONCE(encl->secs.epc_page);
+
+	kfree(encl);
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
+	if ((flags & MAP_TYPE) == MAP_PRIVATE)
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
+	.name = "sgx_enclave",
+	.nodename = "sgx_enclave",
+	.fops = &sgx_encl_fops,
+};
+
+int __init sgx_drv_init(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
+		return -ENODEV;
+
+	return misc_register(&sgx_dev_enclave);
+}
diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
new file mode 100644
index 000000000000..cda9c43b7543
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+int sgx_drv_init(void);
+
+#endif /* __ARCH_X86_SGX_DRIVER_H__ */
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
new file mode 100644
index 000000000000..848b17a3a028
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Copyright(c) 2016-20 Intel Corporation. */
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
+						unsigned long addr,
+						unsigned long vm_flags)
+{
+	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
+	struct sgx_encl_page *entry;
+
+	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
+	if (!entry)
+		return ERR_PTR(-EFAULT);
+
+	/*
+	 * Verify that the faulted page has equal or higher build time
+	 * permissions than the VMA permissions (i.e. the subset of {VM_READ,
+	 * VM_WRITE, VM_EXECUTE} in vma->vm_flags).
+	 */
+	if ((entry->vm_max_prot_bits & vm_prot_bits) != vm_prot_bits)
+		return ERR_PTR(-EFAULT);
+
+	/* No page found. */
+	if (!entry->epc_page)
+		return ERR_PTR(-EFAULT);
+
+	/* Entry successfully located. */
+	return entry;
+}
+
+static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
+{
+	unsigned long addr = (unsigned long)vmf->address;
+	struct vm_area_struct *vma = vmf->vma;
+	struct sgx_encl_page *entry;
+	unsigned long phys_addr;
+	struct sgx_encl *encl;
+	vm_fault_t ret;
+
+	encl = vma->vm_private_data;
+
+	mutex_lock(&encl->lock);
+
+	entry = sgx_encl_load_page(encl, addr, vma->vm_flags);
+	if (IS_ERR(entry)) {
+		mutex_unlock(&encl->lock);
+
+		return VM_FAULT_SIGBUS;
+	}
+
+	phys_addr = sgx_get_epc_phys_addr(entry->epc_page);
+
+	ret = vmf_insert_pfn(vma, addr, PFN_DOWN(phys_addr));
+	if (ret != VM_FAULT_NOPAGE) {
+		mutex_unlock(&encl->lock);
+
+		return VM_FAULT_SIGBUS;
+	}
+
+	mutex_unlock(&encl->lock);
+
+	return VM_FAULT_NOPAGE;
+}
+
+/**
+ * sgx_encl_may_map() - Check if a requested VMA mapping is allowed
+ * @encl:		an enclave pointer
+ * @start:		lower bound of the address range, inclusive
+ * @end:		upper bound of the address range, exclusive
+ * @vm_flags:		VMA flags
+ *
+ * Iterate through the enclave pages contained within [@start, @end) to verify
+ * that the permissions requested by a subset of {VM_READ, VM_WRITE, VM_EXEC}
+ * does not contain any permissions that are not contained in the build time
+ * permissions of any of the enclave pages within the given address range.
+ *
+ * An enclave creator must declare the strongest permissions that will be
+ * needed for each enclave page  This ensures that mappings  have the identical
+ * or weaker permissions that the earlier declared permissions.
+ *
+ * Return: 0 on success, -EACCES otherwise
+ */
+int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
+		     unsigned long end, unsigned long vm_flags)
+{
+	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
+	struct sgx_encl_page *page;
+	unsigned long count = 0;
+	int ret = 0;
+
+	XA_STATE(xas, &encl->page_array, PFN_DOWN(start));
+
+	/*
+	 * Disallow READ_IMPLIES_EXEC tasks as their VMA permissions might
+	 * conflict with the enclave page permissions.
+	 */
+	if (current->personality & READ_IMPLIES_EXEC)
+		return -EACCES;
+
+	mutex_lock(&encl->lock);
+	xas_lock(&xas);
+	xas_for_each(&xas, page, PFN_DOWN(end - 1)) {
+		if (~page->vm_max_prot_bits & vm_prot_bits) {
+			ret = -EACCES;
+			break;
+		}
+
+		/* Reschedule on every XA_CHECK_SCHED iteration. */
+		if (!(++count % XA_CHECK_SCHED)) {
+			xas_pause(&xas);
+			xas_unlock(&xas);
+			mutex_unlock(&encl->lock);
+
+			cond_resched();
+
+			mutex_lock(&encl->lock);
+			xas_lock(&xas);
+		}
+	}
+	xas_unlock(&xas);
+	mutex_unlock(&encl->lock);
+
+	return ret;
+}
+
+static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end, unsigned long newflags)
+{
+	return sgx_encl_may_map(vma->vm_private_data, start, end, newflags);
+}
+
+const struct vm_operations_struct sgx_vm_ops = {
+	.fault = sgx_vma_fault,
+	.mprotect = sgx_vma_mprotect,
+};
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
new file mode 100644
index 000000000000..b7e02eab5868
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/**
+ * Copyright(c) 2016-20 Intel Corporation.
+ *
+ * Contains the software defined data structures for enclaves.
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
+struct sgx_encl_page {
+	unsigned long desc;
+	unsigned long vm_max_prot_bits;
+	struct sgx_epc_page *epc_page;
+	struct sgx_encl *encl;
+};
+
+struct sgx_encl {
+	unsigned long base;
+	unsigned long size;
+	unsigned int page_cnt;
+	unsigned int secs_child_cnt;
+	struct mutex lock;
+	struct xarray page_array;
+	struct sgx_encl_page secs;
+};
+
+extern const struct vm_operations_struct sgx_vm_ops;
+
+static inline int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
+				struct vm_area_struct **vma)
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
+	return 0;
+}
+
+int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
+		     unsigned long end, unsigned long vm_flags);
+
+#endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 2e53afc288a4..38f2e80cc31a 100644
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
@@ -232,9 +234,10 @@ static bool __init sgx_page_cache_init(void)
 
 static void __init sgx_init(void)
 {
+	int ret;
 	int i;
 
-	if (!boot_cpu_has(X86_FEATURE_SGX))
+	if (!cpu_feature_enabled(X86_FEATURE_SGX))
 		return;
 
 	if (!sgx_page_cache_init())
@@ -243,8 +246,15 @@ static void __init sgx_init(void)
 	if (!sgx_page_reclaimer_init())
 		goto err_page_cache;
 
+	ret = sgx_drv_init();
+	if (ret)
+		goto err_kthread;
+
 	return;
 
+err_kthread:
+	kthread_stop(ksgxd_tsk);
+
 err_page_cache:
 	for (i = 0; i < sgx_nr_epc_sections; i++) {
 		vfree(sgx_epc_sections[i].pages);
-- 
2.27.0

