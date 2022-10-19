Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF98C4332F
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Oct 2022 19:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiJSTOW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Oct 2022 15:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJSTOS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 19 Oct 2022 15:14:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40341CFC60
        for <linux-sgx@vger.kernel.org>; Wed, 19 Oct 2022 12:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666206854; x=1697742854;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=00NZWSKJypMTFDjbk4E7RYg9qCKXQ8ThPEks/P3y6NA=;
  b=FMlwwC20MyUUk5YNdc5xEGikR0gFRkijIFxmyKBbDxJBqDJo3iz+fIVi
   TnWck5TWCff1+j9ob47Ka0ksVBkNNWfh9y+NXefvLt4kOyx6xz/PfT0ZB
   SB/5YSYbSkP4IFMb5TgnBNX68juGH83bFQ2fzK+yhdVlIeme/4k31X/xh
   p9HdvT/1RCGuVYBytJYO+1CDyb80TS2dTWwHL+ODo8J/dr0AwOQeDcrOc
   3PNpBgaSrUZcJIzQI0sCucBnyU4FKRl9JFht+Dx06YQPL6g2COGubFTaq
   hxXkT8Osdklmbtir2tfgGn5yWpwkFVUWUK3eS6myM3IC+D35xmL9iN3Xk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="286226059"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="286226059"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 12:14:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="874579972"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="874579972"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga006.fm.intel.com with ESMTP; 19 Oct 2022 12:14:14 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH 1/4] x86/sgx: Export sgx_encl_eaug_page
Date:   Wed, 19 Oct 2022 12:14:10 -0700
Message-Id: <20221019191413.48752-2-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019191413.48752-1-haitao.huang@linux.intel.com>
References: <20221019191413.48752-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Change return type so it can be reused later for fops->fadvise

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 46 ++++++++++++++++++++++------------
 arch/x86/kernel/cpu/sgx/encl.h |  3 ++-
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 8bdeae2fc309..c57e60d5a0aa 100644
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
-static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
-				     struct sgx_encl *encl, unsigned long addr)
+int sgx_encl_eaug_page(struct vm_area_struct *vma,
+		       struct sgx_encl *encl, unsigned long addr)
 {
 	vm_fault_t vmret = VM_FAULT_SIGBUS;
 	struct sgx_pageinfo pginfo = {0};
@@ -318,10 +318,10 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
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
@@ -332,21 +332,21 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
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
 
@@ -359,16 +359,20 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
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
@@ -385,10 +389,10 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
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
@@ -401,7 +405,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
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
index a65a952116fd..36059d35e1bc 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -127,5 +127,6 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 					 unsigned long addr);
 struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim);
 void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
-
+int sgx_encl_eaug_page(struct vm_area_struct *vma,
+		       struct sgx_encl *encl, unsigned long addr);
 #endif /* _X86_ENCL_H */
-- 
2.25.1

