Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFF6FA3742
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Oct 2022 19:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbiJ0Tpj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Oct 2022 15:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236656AbiJ0Tph (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 27 Oct 2022 15:45:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C0D543F6
        for <linux-sgx@vger.kernel.org>; Thu, 27 Oct 2022 12:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666899936; x=1698435936;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Jxb3RU4ARZMhWNaPGfblwOp/0pKB/qACpU6xOy06vP4=;
  b=Y58Oeabrl41G4M1EyrcqafT5a9cL67rGP7uqEkYH6Ca1W5JRNzeWjQPu
   3I84lxonDYdlnSc/2WrstIuT9ohFSpTP6iw8FA9YwfBEgrCP9+13r8tZw
   aFtLNjPjssWEJ8D2cX4CQHdHGFYxfGbaKUSJl8Lp9SXBEuc8BwggNH1I3
   TaObWCfM0TRHj+eGFjs+o/XtIL/qefhqnbAVlYOGSgBpPeHuwQrycYO7c
   Hm2ejJmolYMPNwIBcvivfdIxzwvvO0NZKGZQojSkzmiMxJkkIOTGN6r+U
   US/GjjS2IBsmr+kKQEFZP+oY3ktDMyL4B9vI6s6adxcTmVO6jARif346e
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="310021412"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="310021412"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 12:45:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="961753293"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="961753293"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga005.fm.intel.com with ESMTP; 27 Oct 2022 12:45:33 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v2 2/4] x86/sgx: Implement support for MADV_WILLNEED
Date:   Thu, 27 Oct 2022 12:45:30 -0700
Message-Id: <20221027194532.180053-3-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027194532.180053-2-haitao.huang@linux.intel.com>
References: <20221027194532.180053-1-haitao.huang@linux.intel.com>
 <20221027194532.180053-2-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Support madvise(..., MADV_WILLNEED) by adding EPC pages with EAUG in
the newly added fops->fadvise() callback implementation, sgx_fadvise().

Change the return type and values of the sgx_encl_eaug_page function
so that more specific error codes are returned for different treatment
by the page fault handler and the fadvise callback.
On any error, sgx_fadvise() will discontinue further operations
and return as normal. The page fault handler allows a PF retried
by returning VM_FAULT_NOPAGE in handling -EBUSY returned from
sgx_encl_eaug_page.

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c | 81 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.c   | 46 +++++++++++-------
 arch/x86/kernel/cpu/sgx/encl.h   |  4 +-
 3 files changed, 113 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index aa9b8b868867..54b24897605b 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -2,6 +2,7 @@
 /*  Copyright(c) 2016-20 Intel Corporation. */
 
 #include <linux/acpi.h>
+#include <linux/fadvise.h>
 #include <linux/miscdevice.h>
 #include <linux/mman.h>
 #include <linux/security.h>
@@ -9,6 +10,7 @@
 #include <asm/traps.h>
 #include "driver.h"
 #include "encl.h"
+#include "encls.h"
 
 u64 sgx_attributes_reserved_mask;
 u64 sgx_xfrm_reserved_mask = ~0x3;
@@ -97,10 +99,88 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_ops = &sgx_vm_ops;
 	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
 	vma->vm_private_data = encl;
+	/* Anchor vm_pgoff to the enclave base.
+	 * So offset passed back to sgx_fadvise hook
+	 * is relative to the enclave base
+	 */
+	vma->vm_pgoff = (vma->vm_start - encl->base) >> PAGE_SHIFT;
 
 	return 0;
 }
 
+/*
+ * Add new pages to the enclave sequentially with ENCLS[EAUG] for the WILLNEED advice.
+ * Only do this to existing VMAs in the same enclave and reject the request.
+ * Returns:	0 if EAUG done with best effort, -EINVAL if any sub-range given
+ * is not in the enclave, or enclave is not initialized..
+ */
+static int sgx_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
+{
+	struct sgx_encl *encl = file->private_data;
+	unsigned long start, end, pos;
+	int ret = -EINVAL;
+	struct vm_area_struct *vma = NULL;
+
+	/* Only support WILLNEED */
+	if (advice != POSIX_FADV_WILLNEED)
+		return -EINVAL;
+	if (!encl)
+		return -EINVAL;
+	if (!cpu_feature_enabled(X86_FEATURE_SGX2))
+		return -EINVAL;
+
+	if (offset + len < offset)
+		return -EINVAL;
+	if (encl->base + offset < encl->base)
+		return -EINVAL;
+	start  = offset + encl->base;
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+	if (end > encl->base + encl->size)
+		return -EINVAL;
+
+	/* EAUG works only for initialized enclaves. */
+	if (!test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
+		return -EINVAL;
+
+	mmap_read_lock(current->mm);
+
+	vma = find_vma(current->mm, start);
+	if (!vma)
+		goto unlock;
+	if (vma->vm_private_data != encl)
+		goto unlock;
+
+	pos = start;
+	if (pos < vma->vm_start || end > vma->vm_end) {
+		/* Don't allow any gaps */
+		goto unlock;
+	}
+	/* Here: vm_start <= pos < end <= vm_end */
+	while (pos < end) {
+		if (xa_load(&encl->page_array, PFN_DOWN(pos)))
+			continue;
+		if (signal_pending(current)) {
+			if (pos == start)
+				ret = -ERESTARTSYS;
+			else
+				ret = -EINTR;
+			goto unlock;
+		}
+		ret = sgx_encl_eaug_page(vma, encl, pos);
+		/* It's OK to not finish */
+		if (ret)
+			break;
+		pos = pos + PAGE_SIZE;
+		cond_resched();
+	}
+	ret = 0;
+unlock:
+	mmap_read_unlock(current->mm);
+	return ret;
+}
+
 static unsigned long sgx_get_unmapped_area(struct file *file,
 					   unsigned long addr,
 					   unsigned long len,
@@ -133,6 +213,7 @@ static const struct file_operations sgx_encl_fops = {
 	.compat_ioctl		= sgx_compat_ioctl,
 #endif
 	.mmap			= sgx_mmap,
+	.fadvise		= sgx_fadvise,
 	.get_unmapped_area	= sgx_get_unmapped_area,
 };
 
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 1abc5e7f2660..c57e60d5a0aa 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -305,11 +305,11 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
  * on a SGX2 system then the EPC can be added dynamically via the SGX2
  * ENCLS[EAUG] instruction.
  *
- * Returns: Appropriate vm_fault_t: VM_FAULT_NOPAGE when PTE was installed
- * successfully, VM_FAULT_SIGBUS or VM_FAULT_OOM as error otherwise.
+ * Returns: 0 when PTE was installed successfully, -EBUSY for waiting on
+ * reclaimer to free EPC, -ENOMEM for out of RAM, -EFAULT as error otherwise.
  */
-vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
-			      struct sgx_encl *encl, unsigned long addr)
+int sgx_encl_eaug_page(struct vm_area_struct *vma,
+		       struct sgx_encl *encl, unsigned long addr)
 {
 	vm_fault_t vmret = VM_FAULT_SIGBUS;
 	struct sgx_pageinfo pginfo = {0};
@@ -318,10 +318,10 @@ vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	struct sgx_va_page *va_page;
 	unsigned long phys_addr;
 	u64 secinfo_flags;
-	int ret;
+	int ret = -EFAULT;
 
 	if (!test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
-		return VM_FAULT_SIGBUS;
+		return -EFAULT;
 
 	/*
 	 * Ignore internal permission checking for dynamically added pages.
@@ -332,21 +332,21 @@ vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	secinfo_flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X;
 	encl_page = sgx_encl_page_alloc(encl, addr - encl->base, secinfo_flags);
 	if (IS_ERR(encl_page))
-		return VM_FAULT_OOM;
+		return -ENOMEM;
 
 	mutex_lock(&encl->lock);
 
 	epc_page = sgx_alloc_epc_page(encl_page, false);
 	if (IS_ERR(epc_page)) {
 		if (PTR_ERR(epc_page) == -EBUSY)
-			vmret =  VM_FAULT_NOPAGE;
+			ret =  -EBUSY;
 		goto err_out_unlock;
 	}
 
 	va_page = sgx_encl_grow(encl, false);
 	if (IS_ERR(va_page)) {
 		if (PTR_ERR(va_page) == -EBUSY)
-			vmret = VM_FAULT_NOPAGE;
+			ret = -EBUSY;
 		goto err_out_epc;
 	}
 
@@ -359,16 +359,20 @@ vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	 * If ret == -EBUSY then page was created in another flow while
 	 * running without encl->lock
 	 */
-	if (ret)
+	if (ret) {
+		ret = -EFAULT;
 		goto err_out_shrink;
+	}
 
 	pginfo.secs = (unsigned long)sgx_get_epc_virt_addr(encl->secs.epc_page);
 	pginfo.addr = encl_page->desc & PAGE_MASK;
 	pginfo.metadata = 0;
 
 	ret = __eaug(&pginfo, sgx_get_epc_virt_addr(epc_page));
-	if (ret)
+	if (ret) {
+		ret = -EFAULT;
 		goto err_out;
+	}
 
 	encl_page->encl = encl;
 	encl_page->epc_page = epc_page;
@@ -385,10 +389,10 @@ vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	vmret = vmf_insert_pfn(vma, addr, PFN_DOWN(phys_addr));
 	if (vmret != VM_FAULT_NOPAGE) {
 		mutex_unlock(&encl->lock);
-		return VM_FAULT_SIGBUS;
+		return -EFAULT;
 	}
 	mutex_unlock(&encl->lock);
-	return VM_FAULT_NOPAGE;
+	return 0;
 
 err_out:
 	xa_erase(&encl->page_array, PFN_DOWN(encl_page->desc));
@@ -401,7 +405,7 @@ vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	mutex_unlock(&encl->lock);
 	kfree(encl_page);
 
-	return vmret;
+	return ret;
 }
 
 static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
@@ -431,8 +435,18 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
 	 * enclave that will be checked for right away.
 	 */
 	if (cpu_feature_enabled(X86_FEATURE_SGX2) &&
-	    (!xa_load(&encl->page_array, PFN_DOWN(addr))))
-		return sgx_encl_eaug_page(vma, encl, addr);
+	    (!xa_load(&encl->page_array, PFN_DOWN(addr)))) {
+		switch (sgx_encl_eaug_page(vma, encl, addr)) {
+		case 0:
+		case -EBUSY:
+			return VM_FAULT_NOPAGE;
+		case -ENOMEM:
+			return VM_FAULT_OOM;
+		case -EFAULT:
+		default:
+			return VM_FAULT_SIGBUS;
+		}
+	}
 
 	mutex_lock(&encl->lock);
 
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 500437981161..36059d35e1bc 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -127,6 +127,6 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 					 unsigned long addr);
 struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim);
 void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
-vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
-			      struct sgx_encl *encl, unsigned long addr)
+int sgx_encl_eaug_page(struct vm_area_struct *vma,
+		       struct sgx_encl *encl, unsigned long addr);
 #endif /* _X86_ENCL_H */
-- 
2.25.1

