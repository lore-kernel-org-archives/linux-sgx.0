Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A39C468BC
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 07:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66A66206E0
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 07:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbfFJHDO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 03:03:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:3981 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387855AbfFJHDN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 03:03:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 00:03:13 -0700
X-ExtLoop1: 1
Received: from bxing-mobl.amr.corp.intel.com (HELO ubt18m.amr.corp.intel.com) ([10.255.90.159])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jun 2019 00:03:12 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     Cedric Xing <cedric.xing@intel.com>,
        jarkko.sakkinen@linux.intel.com, luto@kernel.org,
        sds@tycho.nsa.gov, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, eparis@parisplace.org, jethro@fortanix.com,
        dave.hansen@intel.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        nhorman@redhat.com, pmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, kai.huang@intel.com,
        rientjes@google.com, william.c.roberts@intel.com,
        philip.b.tricca@intel.com
Subject: [RFC PATCH v1 3/3] LSM/x86/sgx: Call new LSM hooks from SGX subsystem
Date:   Mon, 10 Jun 2019 00:03:06 -0700
Message-Id: <cf7cef1172943c78611001cc06e043654a973023.1560131039.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1560131039.git.cedric.xing@intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <cover.1560131039.git.cedric.xing@intel.com>
In-Reply-To: <cover.1560131039.git.cedric.xing@intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

There are three places LSM hooks are called from within the SGX subsystem.

The first place is to invoke security_file_mprotect() in sgx_mmap() to validate
requested protection. Given the architecture of SGX subsystem, all enclaves
look like file mappings of /dev/sgx/enclave device file, meaning the existing
security_mmap_file() invoked inside vm_mmap_pgoff() cannot provide any
meaningful information to LSM. Based on the idea that mmap(prot) is equivalent
to mmap(PROT_NONE) followed by mprotect(prot), security_file_mprotect() shall
be queried with more specific enclave/page information.

Secondly, security_enclave_load() is invoked upon loading of every enclave
page.

Lastly, security_enclave_init() is invoked before initializing (EINIT) every
enclave.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 72 +++++++++++++++++++++++---
 arch/x86/kernel/cpu/sgx/driver/main.c  | 12 ++++-
 2 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index b186fb7b48d5..a3f22a6f6d2b 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -11,6 +11,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/security.h>
 #include "driver.h"
 
 struct sgx_add_page_req {
@@ -575,6 +576,42 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	return ret;
 }
 
+static int sgx_encl_prepare_page(struct file *filp, unsigned long dst,
+				 unsigned long src, void *buf)
+{
+	struct vm_area_struct *vma;
+	unsigned long prot;
+	int rc = 0;
+
+	if (dst & ~PAGE_SIZE)
+		return -EINVAL;
+
+	down_read(&current->mm->mmap_sem);
+
+	vma = find_vma(current->mm, dst);
+	if (vma && dst >= vma->vm_start)
+		prot = vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
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
+	if (!rc)
+		rc = security_enclave_load(filp, dst, PAGE_SIZE, prot, vma);
+
+	if (!rc && copy_from_user(buf, (void __user *)src, PAGE_SIZE))
+		rc = -EFAULT;
+
+	up_read(&current->mm->mmap_sem);
+
+	return rc;
+}
+
 /**
  * sgx_ioc_enclave_add_page - handler for %SGX_IOC_ENCLAVE_ADD_PAGE
  *
@@ -613,10 +650,9 @@ static long sgx_ioc_enclave_add_page(struct file *filep, unsigned int cmd,
 
 	data = kmap(data_page);
 
-	if (copy_from_user((void *)data, (void __user *)addp->src, PAGE_SIZE)) {
-		ret = -EFAULT;
+	ret = sgx_encl_prepare_page(filep, addp->addr, addp->src, data);
+	if (ret)
 		goto out;
-	}
 
 	ret = sgx_encl_add_page(encl, addp->addr, data, &secinfo, addp->mrmask);
 	if (ret)
@@ -718,6 +754,29 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 	return ret;
 }
 
+static int sgx_encl_prepare_sigstruct(struct file *filp, unsigned long src,
+				      struct sgx_sigstruct *ss)
+{
+	struct vm_area_struct *vma;
+	int rc = 0;
+
+	down_read(&current->mm->mmap_sem);
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
@@ -753,12 +812,9 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
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
index 58ba6153070b..c634df440c16 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -63,14 +63,22 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
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
+	rc = security_file_mprotect(vma, prot, prot);
+	if (!rc) {
+		vma->vm_flags |= prot;
+		kref_get(&encl->refcount);
+	}
 
-	return 0;
+	return rc;
 }
 
 static unsigned long sgx_get_unmapped_area(struct file *file,
-- 
2.17.1

