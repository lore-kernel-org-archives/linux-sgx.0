Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C7DC38142
	for <linux-sgx@archiver.kernel.org>; Sat, 28 Jan 2023 04:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbjA1Ezd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Jan 2023 23:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjA1Ezc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 27 Jan 2023 23:55:32 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075C984B6A
        for <linux-sgx@vger.kernel.org>; Fri, 27 Jan 2023 20:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674881730; x=1706417730;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=/jXUBuLz0x9DQCcCRk50uA7HKRI6rgstcQ9z6x5v0hg=;
  b=aNnu2R+zQmYxl2QmNR/ZLlXC9wryUb5Y7w9Tl7h5sWxCsQ2nMg5QOF2l
   te2oW1kA+aXQI1E4hluPsDF4uti6N5jHiVPS1iB1bNOaFpDwv0D1WJP9S
   EsKX48E6YPlBFfl8W57f8PtkAX/ZjI0Umj/14eavLbUiRF/DaAbUpveT1
   6vdEDp1QgoXYwYWQJ4KcqP1sD5uMThzmcQ9nDYeikwihK3ZISRNCQxA7F
   zjlF+ZTTmtZddKnytGmGIHHWvqeV/lWTlQkdnE5jz8udIx7krEqjAu53M
   VgyVtHCYUp0VujkyHBre4VGMATqqQjEqNQGHom49Z+VRS9b5xWBHe9HLq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="413484076"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="413484076"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 20:55:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="640942044"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="640942044"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga006.jf.intel.com with ESMTP; 27 Jan 2023 20:55:29 -0800
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Date:   Fri, 27 Jan 2023 20:55:27 -0800
Message-Id: <20230128045529.15749-3-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230128045529.15749-2-haitao.huang@linux.intel.com>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
 <20230128045529.15749-2-haitao.huang@linux.intel.com>
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
 arch/x86/kernel/cpu/sgx/driver.c | 74 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.c   | 59 ++++++++++++++-----------
 arch/x86/kernel/cpu/sgx/encl.h   |  4 +-
 3 files changed, 111 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index aa9b8b868867..3a88daddc1a1 100644
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
@@ -97,10 +99,81 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_ops = &sgx_vm_ops;
 	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
 	vma->vm_private_data = encl;
+	vma->vm_pgoff = PFN_DOWN(vma->vm_start - encl->base);
 
 	return 0;
 }
 
+/*
+ * Add new pages to the enclave sequentially with ENCLS[EAUG] for the WILLNEED advice.
+ * Only do this to existing VMAs in the same enclave and reject the request otherwise.
+ */
+static int sgx_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
+{
+	struct sgx_encl *encl = file->private_data;
+	unsigned long start = offset + encl->base;
+	struct vm_area_struct *vma = NULL;
+	unsigned long end = start + len;
+	unsigned long pos;
+	int ret = -EINVAL;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SGX2))
+		return -EINVAL;
+	/* Only support WILLNEED */
+	if (advice != POSIX_FADV_WILLNEED)
+		return -EINVAL;
+
+	if (offset + len < offset)
+		return -EINVAL;
+	if (start < encl->base)
+		return -EINVAL;
+	if (end < start)
+		return -EINVAL;
+	if (end > encl->base + encl->size)
+		return -EINVAL;
+
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
+
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
+
+unlock:
+	mmap_read_unlock(current->mm);
+	return ret;
+}
+
 static unsigned long sgx_get_unmapped_area(struct file *file,
 					   unsigned long addr,
 					   unsigned long len,
@@ -133,6 +206,7 @@ static const struct file_operations sgx_encl_fops = {
 	.compat_ioctl		= sgx_compat_ioctl,
 #endif
 	.mmap			= sgx_mmap,
+	.fadvise		= sgx_fadvise,
 	.get_unmapped_area	= sgx_get_unmapped_area,
 };
 
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 0185c5ab48dd..592cfea4c9e4 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -299,20 +299,17 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 }
 
 /**
- * sgx_encl_eaug_page() - Dynamically add page to initialized enclave
- * @vma:	VMA obtained from fault info from where page is accessed
- * @encl:	enclave accessing the page
- * @addr:	address that triggered the page fault
+ * sgx_encl_eaug_page() - Dynamically add an EPC page to initialized enclave
+ * @vma:	the VMA into which the page is to be added
+ * @encl:	the enclave for which the page is to be added
+ * @addr:	the start address of the page to be added
  *
- * When an initialized enclave accesses a page with no backing EPC page
- * on a SGX2 system then the EPC can be added dynamically via the SGX2
- * ENCLS[EAUG] instruction.
- *
- * Returns: Appropriate vm_fault_t: VM_FAULT_NOPAGE when PTE was installed
- * successfully, VM_FAULT_SIGBUS or VM_FAULT_OOM as error otherwise.
+ * Returns: 0 on EAUG success and PTE was installed successfully, -EBUSY for
+ * waiting on reclaimer to free EPC, -ENOMEM for out of RAM, -EFAULT for
+ * all other failures.
  */
-vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
-			      struct sgx_encl *encl, unsigned long addr)
+int sgx_encl_eaug_page(struct vm_area_struct *vma,
+		       struct sgx_encl *encl, unsigned long addr)
 {
 	vm_fault_t vmret = VM_FAULT_SIGBUS;
 	struct sgx_pageinfo pginfo = {0};
@@ -321,10 +318,10 @@ vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
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
@@ -335,21 +332,21 @@ vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
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
 
@@ -362,16 +359,20 @@ vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
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
@@ -388,10 +389,10 @@ vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
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
@@ -404,7 +405,7 @@ vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	mutex_unlock(&encl->lock);
 	kfree(encl_page);
 
-	return vmret;
+	return ret;
 }
 
 static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
@@ -434,8 +435,18 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
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
index 9f19b06c3ae3..e5a507871fa3 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -125,7 +125,7 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 					 unsigned long addr);
 struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim);
 void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
-vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
-			      struct sgx_encl *encl, unsigned long addr);
+int sgx_encl_eaug_page(struct vm_area_struct *vma,
+		       struct sgx_encl *encl, unsigned long addr);
 
 #endif /* _X86_ENCL_H */
-- 
2.25.1

