Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C68C3A5A1
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 02:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76F7123405
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 02:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389158AbfHWCKM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 22:10:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:49252 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388508AbfHWCKL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 22:10:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 19:10:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="203623443"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 22 Aug 2019 19:10:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: [PATCH] x86/sgx: Pass userspace source address directly to EADD
Date:   Thu, 22 Aug 2019 19:10:09 -0700
Message-Id: <20190823021009.3880-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Invoke EADD with the userspace source address instead of first copying
the data to a kernel page to avoid the overhead of alloc_page() and
copy_from_user().

Remove all pre-validation of TCS pages.  The source page is no longer
readily available since it's not copied into the kernel, and validating
the TCS essentially requires accessing the entire page since the vast
majority of the TCS is reserved bytes.  Given that userspace can now
cause EADD to fault simply by passing a bad pointer, validating the TCS
to avoid faults on EADD provides little to no value.

Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 148 ++++++-------------------
 1 file changed, 33 insertions(+), 115 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 85e36e530baf..f02b31acd3ad 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -305,71 +305,46 @@ static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
 	return 0;
 }
 
-static bool sgx_validate_offset(struct sgx_encl *encl, unsigned long offset)
-{
-	if (offset & (PAGE_SIZE - 1))
-		return false;
-
-	if (offset >= encl->size)
-		return false;
-
-	return true;
-}
-
-static int sgx_validate_tcs(struct sgx_encl *encl, struct sgx_tcs *tcs)
-{
-	int i;
-
-	if (tcs->flags & SGX_TCS_RESERVED_MASK)
-		return -EINVAL;
-
-	if (tcs->flags & SGX_TCS_DBGOPTIN)
-		return -EINVAL;
-
-	if (!sgx_validate_offset(encl, tcs->ssa_offset))
-		return -EINVAL;
-
-	if (!sgx_validate_offset(encl, tcs->fs_offset))
-		return -EINVAL;
-
-	if (!sgx_validate_offset(encl, tcs->gs_offset))
-		return -EINVAL;
-
-	if ((tcs->fs_limit & 0xFFF) != 0xFFF)
-		return -EINVAL;
-
-	if ((tcs->gs_limit & 0xFFF) != 0xFFF)
-		return -EINVAL;
-
-	for (i = 0; i < SGX_TCS_RESERVED_SIZE; i++)
-		if (tcs->reserved[i])
-			return -EINVAL;
-
-	return 0;
-}
-
 static int __sgx_encl_add_page(struct sgx_encl *encl,
 			       struct sgx_encl_page *encl_page,
 			       struct sgx_epc_page *epc_page,
-			       void *data,
-			       struct sgx_secinfo *secinfo,
-			       unsigned long mrmask)
+			       struct sgx_secinfo *secinfo, unsigned long src,
+			       unsigned long prot, unsigned long mrmask)
 {
 	struct sgx_pageinfo pginfo;
+	struct vm_area_struct *vma;
 	int ret;
 	int i;
 
 	pginfo.secs = (unsigned long)sgx_epc_addr(encl->secs.epc_page);
 	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
 	pginfo.metadata = (unsigned long)secinfo;
-	pginfo.contents = (unsigned long)data;
+	pginfo.contents = src;
 
+	down_read(&current->mm->mmap_sem);
+
+	/* Query vma's VM_MAYEXEC as an indirect path_noexec() check. */
+	if (encl_page->vm_max_prot_bits & VM_EXEC) {
+		vma = find_vma(current->mm, src);
+		if (!vma) {
+			up_read(&current->mm->mmap_sem);
+			return -EFAULT;
+		}
+
+		if (!(vma->vm_flags & VM_MAYEXEC)) {
+			up_read(&current->mm->mmap_sem);
+			return -EACCES;
+		}
+	}
+
+	__uaccess_begin();
 	ret = __eadd(&pginfo, sgx_epc_addr(epc_page));
-	if (ret) {
-		if (encls_failed(ret))
-			ENCLS_WARN(ret, "EADD");
+	__uaccess_end();
+
+	up_read(&current->mm->mmap_sem);
+
+	if (ret)
 		return -EFAULT;
-	}
 
 	for_each_set_bit(i, &mrmask, 16) {
 		ret = __eextend(sgx_epc_addr(encl->secs.epc_page),
@@ -389,9 +364,9 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 	return 0;
 }
 
-static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
-			     void *data, struct sgx_secinfo *secinfo,
-			     unsigned int mrmask, unsigned long prot)
+static int sgx_encl_add_page(struct sgx_encl *encl,
+			     struct sgx_enclave_add_page *addp,
+			     struct sgx_secinfo *secinfo, unsigned long prot)
 {
 	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
 	struct sgx_encl_page *encl_page;
@@ -399,13 +374,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	struct sgx_va_page *va_page;
 	int ret;
 
-	if (page_type == SGX_SECINFO_TCS) {
-		ret = sgx_validate_tcs(encl, data);
-		if (ret)
-			return ret;
-	}
-
-	encl_page = sgx_encl_page_alloc(encl, addr, prot, page_type);
+	encl_page = sgx_encl_page_alloc(encl, addp->addr, prot, page_type);
 	if (IS_ERR(encl_page))
 		return PTR_ERR(encl_page);
 
@@ -428,8 +397,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	if (ret)
 		goto err_out_shrink;
 
-	ret = __sgx_encl_add_page(encl, encl_page, epc_page, data, secinfo,
-				  mrmask);
+	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
+				  addp->src, prot, addp->mrmask);
 	if (ret)
 		goto err_out;
 
@@ -451,36 +420,6 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	return ret;
 }
 
-static int sgx_encl_page_import_user(void *dst, unsigned long src,
-				     unsigned long prot)
-{
-	struct vm_area_struct *vma;
-	int ret = 0;
-
-	down_read(&current->mm->mmap_sem);
-
-	/* Query vma's VM_MAYEXEC as an indirect path_noexec() check. */
-	if (prot & PROT_EXEC) {
-		vma = find_vma(current->mm, src);
-		if (!vma) {
-			ret = -EFAULT;
-			goto out;
-		}
-
-		if (!(vma->vm_flags & VM_MAYEXEC)) {
-			ret = -EACCES;
-			goto out;
-		}
-	}
-
-	if (copy_from_user(dst, (void __user *)src, PAGE_SIZE))
-		ret = -EFAULT;
-
-out:
-	up_read(&current->mm->mmap_sem);
-	return ret;
-}
-
 /**
  * sgx_ioc_enclave_add_page - handler for %SGX_IOC_ENCLAVE_ADD_PAGE
  *
@@ -502,10 +441,7 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 	struct sgx_encl *encl = filep->private_data;
 	struct sgx_enclave_add_page addp;
 	struct sgx_secinfo secinfo;
-	struct page *data_page;
 	unsigned long prot;
-	void *data;
-	int ret;
 
 	if (!(encl->flags & SGX_ENCL_CREATED))
 		return -EINVAL;
@@ -527,12 +463,6 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 	if (sgx_validate_secinfo(&secinfo))
 		return -EINVAL;
 
-	data_page = alloc_page(GFP_HIGHUSER);
-	if (!data_page)
-		return -ENOMEM;
-
-	data = kmap(data_page);
-
 	/* Set prot bits matching to the SECINFO permissions. */
 	prot = _calc_vm_trans(secinfo.flags, SGX_SECINFO_R, PROT_READ)  |
 	       _calc_vm_trans(secinfo.flags, SGX_SECINFO_W, PROT_WRITE) |
@@ -546,19 +476,7 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
 		prot |= PROT_READ | PROT_WRITE;
 
-	ret = sgx_encl_page_import_user(data, addp.src, prot);
-	if (ret)
-		goto out;
-
-	ret = sgx_encl_add_page(encl, addp.addr, data, &secinfo, addp.mrmask,
-				prot);
-	if (ret)
-		goto out;
-
-out:
-	kunmap(data_page);
-	__free_page(data_page);
-	return ret;
+	return sgx_encl_add_page(encl, &addp, &secinfo, prot);
 }
 
 static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
-- 
2.22.0

