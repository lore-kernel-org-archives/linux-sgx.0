Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341FBC3A5A6
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 19:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 144112186A
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 19:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbfH0T1V (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Aug 2019 15:27:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:33016 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729626AbfH0T1V (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Aug 2019 15:27:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 12:27:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="180318613"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2019 12:27:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH v2 3/5] x86/sgx: Take encl->lock inside of mm->mmap_sem for EADD
Date:   Tue, 27 Aug 2019 12:27:15 -0700
Message-Id: <20190827192717.27312-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827192717.27312-1-sean.j.christopherson@intel.com>
References: <20190827192717.27312-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Reverse the order in which encl->lock and mm->mmap_sem are taken during
ENCLAVE_ADD_PAGE so as to adhere to SGX's lock ordering requirements.

Refactor EEXTEND and the final bookeeping out of __sgx_encl_add_page()
so that mm->mmap_sem can be dropped after EADD without spreading the
lock/unlock across multiple functions.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 55 ++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 1ce8e3021a5c..a0ffbbb0dad1 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -307,43 +307,40 @@ static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
 static int __sgx_encl_add_page(struct sgx_encl *encl,
 			       struct sgx_encl_page *encl_page,
 			       struct sgx_epc_page *epc_page,
-			       struct sgx_secinfo *secinfo, unsigned long src,
-			       unsigned long mrmask)
+			       struct sgx_secinfo *secinfo, unsigned long src)
 {
 	struct sgx_pageinfo pginfo;
 	struct vm_area_struct *vma;
 	int ret;
-	int i;
 
 	pginfo.secs = (unsigned long)sgx_epc_addr(encl->secs.epc_page);
 	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
 	pginfo.metadata = (unsigned long)secinfo;
 	pginfo.contents = src;
 
-	down_read(&current->mm->mmap_sem);
-
 	/* Query vma's VM_MAYEXEC as an indirect path_noexec() check. */
 	if (encl_page->vm_max_prot_bits & VM_EXEC) {
 		vma = find_vma(current->mm, src);
-		if (!vma) {
-			up_read(&current->mm->mmap_sem);
+		if (!vma)
 			return -EFAULT;
-		}
 
-		if (!(vma->vm_flags & VM_MAYEXEC)) {
-			up_read(&current->mm->mmap_sem);
+		if (!(vma->vm_flags & VM_MAYEXEC))
 			return -EACCES;
-		}
 	}
 
 	__uaccess_begin();
 	ret = __eadd(&pginfo, sgx_epc_addr(epc_page));
 	__uaccess_end();
 
-	up_read(&current->mm->mmap_sem);
+	return ret ? -EFAULT : 0;
+}
 
-	if (ret)
-		return -EFAULT;
+static int __sgx_encl_extend(struct sgx_encl *encl,
+			     struct sgx_epc_page *epc_page,
+			     unsigned long mrmask)
+{
+	int ret;
+	int i;
 
 	for_each_set_bit(i, &mrmask, 16) {
 		ret = __eextend(sgx_epc_addr(encl->secs.epc_page),
@@ -354,12 +351,6 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 			return -EFAULT;
 		}
 	}
-
-	encl_page->encl = encl;
-	encl_page->epc_page = epc_page;
-	encl->secs_child_cnt++;
-	sgx_mark_page_reclaimable(encl_page->epc_page);
-
 	return 0;
 }
 
@@ -388,19 +379,39 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 		goto err_out_free;
 	}
 
+	down_read(&current->mm->mmap_sem);
+
 	mutex_lock(&encl->lock);
 
+	/*
+	 * Insert prior to EADD in case of OOM.  EADD modifies MRENCLAVE, i.e.
+	 * can't be gracefully unwound, while failure on EADD/EXTEND is limited
+	 * to userspace errors (or kernel/hardware bugs).
+	 */
 	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
 				encl_page);
-	if (ret)
+	if (ret) {
+		up_read(&current->mm->mmap_sem);
 		goto err_out_shrink;
+	}
 
 	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
-				  addp->src, addp->mrmask);
+				  addp->src);
+	up_read(&current->mm->mmap_sem);
+
+	if (ret)
+		goto err_out;
+
+	ret = __sgx_encl_extend(encl, epc_page, addp->mrmask);
 	if (ret)
 		goto err_out;
 
+	encl_page->encl = encl;
+	encl_page->epc_page = epc_page;
+	encl->secs_child_cnt++;
+	sgx_mark_page_reclaimable(encl_page->epc_page);
 	mutex_unlock(&encl->lock);
+
 	return 0;
 
 err_out:
-- 
2.22.0

