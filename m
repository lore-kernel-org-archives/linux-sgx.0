Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B36C48BEC
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 18:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12C8D20645
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 18:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfF0S42 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 14:56:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:10286 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbfF0S41 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Jun 2019 14:56:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 11:56:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,424,1557212400"; 
   d="scan'208";a="361259291"
Received: from bxing-desk.ccr.corp.intel.com (HELO ubt18.jf.intel.com) ([134.134.148.187])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jun 2019 11:56:26 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, cedric.xing@intel.com
Cc:     casey.schaufler@intel.com, jmorris@namei.org, luto@kernel.org,
        jethro@fortanix.com, greg@enjellic.com, sds@tycho.nsa.gov,
        jarkko.sakkinen@linux.intel.com, sean.j.christopherson@intel.com
Subject: [RFC PATCH v2 2/3] x86/sgx: Call LSM hooks from SGX subsystem/module
Date:   Thu, 27 Jun 2019 11:56:20 -0700
Message-Id: <f6e8be34f7b5a7453b5d3ca36ad69b66f7e65ef2.1561588012.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1561588012.git.cedric.xing@intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
In-Reply-To: <cover.1561588012.git.cedric.xing@intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com> <cover.1561588012.git.cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

It’s straightforward to call new LSM hooks from the SGX subsystem/module. There
are three places where LSM hooks are invoked.
 1) sgx_mmap() invokes security_file_mprotect() to validate requested
    protection. It is necessary because security_mmap_file() invoked by mmap()
    syscall only validates protections against /dev/sgx/enclave file, but not
    against those files from which the pages were loaded from.
 2) security_enclave_load() is invoked upon loading of every enclave page by
    the EADD ioctl. Please note that if pages are EADD’ed in batch, the SGX
    subsystem/module is responsible for dividing pages in trunks so that each
    trunk is loaded from a single VMA.
 3) security_enclave_init() is invoked before initializing (EINIT) every
    enclave.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 80 +++++++++++++++++++++++---
 arch/x86/kernel/cpu/sgx/driver/main.c  | 16 +++++-
 2 files changed, 85 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index b186fb7b48d5..4f5abf9819a7 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 // Copyright(c) 2016-19 Intel Corporation.
 
-#include <asm/mman.h>
+#include <linux/mman.h>
 #include <linux/delay.h>
 #include <linux/file.h>
 #include <linux/hashtable.h>
@@ -11,6 +11,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/security.h>
 #include "driver.h"
 
 struct sgx_add_page_req {
@@ -575,6 +576,46 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	return ret;
 }
 
+static int sgx_encl_prepare_page(struct file *filp, unsigned long dst,
+				 unsigned long src, void *buf)
+{
+	struct vm_area_struct *vma;
+	unsigned long prot;
+	int rc;
+
+	if (dst & ~PAGE_SIZE)
+		return -EINVAL;
+
+	rc = down_read_killable(&current->mm->mmap_sem);
+	if (rc)
+		return rc;
+
+	vma = find_vma(current->mm, dst);
+	if (vma && dst >= vma->vm_start)
+		prot = _calc_vm_trans(vma->vm_flags, VM_READ, PROT_READ) |
+		       _calc_vm_trans(vma->vm_flags, VM_WRITE, PROT_WRITE) |
+		       _calc_vm_trans(vma->vm_flags, VM_EXEC, PROT_EXEC);
+	else
+		prot = 0;
+
+	vma = find_vma(current->mm, src);
+	if (!vma || src < vma->vm_start || src + PAGE_SIZE > vma->vm_end)
+		rc = -EFAULT;
+
+	if (!rc && !(vma->vm_flags & VM_MAYEXEC))
+		rc = -EACCES;
+
+	if (!rc && copy_from_user(buf, (void __user *)src, PAGE_SIZE))
+		rc = -EFAULT;
+
+	if (!rc)
+		rc = security_enclave_load(filp, dst, PAGE_SIZE, prot, vma);
+
+	up_read(&current->mm->mmap_sem);
+
+	return rc;
+}
+
 /**
  * sgx_ioc_enclave_add_page - handler for %SGX_IOC_ENCLAVE_ADD_PAGE
  *
@@ -613,10 +654,9 @@ static long sgx_ioc_enclave_add_page(struct file *filep, unsigned int cmd,
 
 	data = kmap(data_page);
 
-	if (copy_from_user((void *)data, (void __user *)addp->src, PAGE_SIZE)) {
-		ret = -EFAULT;
+	ret = sgx_encl_prepare_page(filep, addp->addr, addp->src, data);
+	if (ret)
 		goto out;
-	}
 
 	ret = sgx_encl_add_page(encl, addp->addr, data, &secinfo, addp->mrmask);
 	if (ret)
@@ -718,6 +758,31 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 	return ret;
 }
 
+static int sgx_encl_prepare_sigstruct(struct file *filp, unsigned long src,
+				      struct sgx_sigstruct *ss)
+{
+	struct vm_area_struct *vma;
+	int rc;
+
+	rc = down_read_killable(&current->mm->mmap_sem);
+	if (rc)
+		return rc;
+
+	vma = find_vma(current->mm, src);
+	if (!vma || src < vma->vm_start || src + sizeof(*ss) > vma->vm_end)
+		rc = -EFAULT;
+
+	if (!rc && copy_from_user(ss, (void __user *)src, sizeof(*ss)))
+		rc = -EFAULT;
+
+	if (!rc)
+		rc = security_enclave_init(filp, ss, vma);
+
+	up_read(&current->mm->mmap_sem);
+
+	return rc;
+}
+
 /**
  * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
  *
@@ -753,12 +818,9 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
 		((unsigned long)sigstruct + PAGE_SIZE / 2);
 	memset(einittoken, 0, sizeof(*einittoken));
 
-	if (copy_from_user(sigstruct, (void __user *)initp->sigstruct,
-			   sizeof(*sigstruct))) {
-		ret = -EFAULT;
+	ret = sgx_encl_prepare_sigstruct(filep, initp->sigstruct, sigstruct);
+	if (ret)
 		goto out;
-	}
-
 
 	ret = sgx_encl_init(encl, sigstruct, einittoken);
 
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index afe844aa81d6..95fe18c37b84 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -63,14 +63,26 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
 static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct sgx_encl *encl = file->private_data;
+	unsigned long prot;
+	int rc;
 
 	vma->vm_ops = &sgx_vm_ops;
 	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
 	vma->vm_private_data = encl;
 
-	kref_get(&encl->refcount);
+	prot = vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
+	vma->vm_flags &= ~prot;
 
-	return 0;
+	prot = _calc_vm_trans(prot, VM_READ, PROT_READ) |
+	       _calc_vm_trans(prot, VM_WRITE, PROT_WRITE) |
+	       _calc_vm_trans(prot, VM_EXEC, PROT_EXEC);
+	rc = security_file_mprotect(vma, prot, prot);
+	if (!rc) {
+		vma->vm_flags |= calc_vm_prot_bits(prot, 0);
+		kref_get(&encl->refcount);
+	}
+
+	return rc;
 }
 
 static unsigned long sgx_get_unmapped_area(struct file *file,
-- 
2.17.1

