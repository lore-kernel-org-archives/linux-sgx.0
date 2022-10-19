Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D71AC43217
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Oct 2022 19:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiJSTOX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Oct 2022 15:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiJSTOS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 19 Oct 2022 15:14:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EDA1C712E
        for <linux-sgx@vger.kernel.org>; Wed, 19 Oct 2022 12:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666206855; x=1697742855;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=l0niIdzphR8AMTo2kfm6hvWbE8bEM/6edK/h826JwuE=;
  b=E2Cq/yiVnv3Ywg++XcPEpSrv+DgXfaWC6wN6aCLh71afozCNTYYYLLgE
   Xcg/SWCY/AjEgCGqJt0WThQ4g1/fDZjiiWCVrWtAvorDaE+LWIQQqIljP
   SquPOO3vInpiOHHK9UKZzpreD5N2UEcceqip2zJKGoVKlXzfXVm4rQfhh
   5CKEg6GbxlyPcLdTQLo0RAPEAvnJIpPg1Cl47dYbaUeLGReYk4gcLuZLr
   GQmoPw+U+JV1iXHn0uiaFSIR5Llc5xjjdnJFWlwjr7Sk576JUsiAKTbb9
   KU5wpHOA/Ucm5DL2UpTLPxmxvNZBMNqu/dMwXrYKuOC9/D6DTQ+K1aNIR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="286226061"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="286226061"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 12:14:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="874579978"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="874579978"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga006.fm.intel.com with ESMTP; 19 Oct 2022 12:14:14 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH 2/4] x86/sgx: Implement support for MADV_WILLNEED
Date:   Wed, 19 Oct 2022 12:14:11 -0700
Message-Id: <20221019191413.48752-3-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019191413.48752-2-haitao.huang@linux.intel.com>
References: <20221019191413.48752-1-haitao.huang@linux.intel.com>
 <20221019191413.48752-2-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add support for madvise(..., MADV_WILLNEED) by adding
pages with EAUG. Implement fops->fadvise() callback to
achieve this behaviour.

Note this is only done with best effort possible. If any
errors encountered or EPC is under swapping, the operation
will stop and return as normal.

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c | 81 ++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

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
 
-- 
2.25.1

