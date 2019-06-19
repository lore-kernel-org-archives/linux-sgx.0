Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01D6C4646C
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 22:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91EAA215EA
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 22:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbfFSWYV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 18:24:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:40155 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730796AbfFSWYR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 18:24:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 15:24:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,394,1557212400"; 
   d="scan'208";a="150743774"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga007.jf.intel.com with ESMTP; 19 Jun 2019 15:24:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: [RFC PATCH v4 09/12] LSM: x86/sgx: Introduce ->enclave_load() hook for Intel SGX
Date:   Wed, 19 Jun 2019 15:23:58 -0700
Message-Id: <20190619222401.14942-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190619222401.14942-1-sean.j.christopherson@intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

enclave_load() is roughly analogous to the existing file_mprotect().

Due to the nature of SGX and its Enclave Page Cache (EPC), all enclave
VMAs are backed by a single file, i.e. /dev/sgx/enclave, that must be
MAP_SHARED.  Furthermore, all enclaves need read, write and execute
VMAs.  As a result, the existing/standard call to file_mprotect() does
not provide any meaningful security for enclaves since an LSM can only
deny/grant access to the EPC as a whole.

security_enclave_load() is called when SGX is first loading an enclave
page, i.e. copying a page from normal memory into the EPC.  Although
the prototype for enclave_load() is similar to file_mprotect(), e.g.
SGX could theoretically use file_mprotect() and set reqprot=prot, a
separate hook is desirable as the semantics of an enclave's protection
bits are different than those of vmas, e.g. an enclave page tracks the
maximal set of protections, whereas file_mprotect() operates on the
actual protections being provided.  Enclaves also have unique security
properties, e.g. measured code, that LSMs may want to consider.  In
other words, LSMs will likely want to implement different policies for
enclave page protections.

Note, extensive discussion yielded no sane alternative to some form of
SGX specific LSM hook[1].

[1] https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 32 ++++++++++++++------------
 include/linux/lsm_hooks.h              |  8 +++++++
 include/linux/security.h               |  7 ++++++
 security/security.c                    |  5 ++++
 4 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 1fca70a36ce3..ae1b4d69441c 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -9,6 +9,7 @@
 #include <linux/highmem.h>
 #include <linux/ratelimit.h>
 #include <linux/sched/signal.h>
+#include <linux/security.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
@@ -564,7 +565,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	return ret;
 }
 
-static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot)
+static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot,
+			      u16 mrmask)
 {
 	struct vm_area_struct *vma;
 	int ret;
@@ -572,24 +574,24 @@ static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot)
 	/* Hold mmap_sem across copy_from_user() to avoid a TOCTOU race. */
 	down_read(&current->mm->mmap_sem);
 
+	vma = find_vma(current->mm, src);
+	if (!vma) {
+		ret = -EFAULT;
+		goto out;
+	}
+
 	/* Query vma's VM_MAYEXEC as an indirect path_noexec() check. */
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
+	if ((prot & PROT_EXEC) && !(vma->vm_flags & VM_MAYEXEC)) {
+		ret = -EACCES;
+		goto out;
 	}
 
+	ret = security_enclave_load(vma, prot, mrmask == 0xffff);
+	if (ret)
+		goto out;
+
 	if (copy_from_user(dst, (void __user *)src, PAGE_SIZE))
 		ret = -EFAULT;
-	else
-		ret = 0;
 
 out:
 	up_read(&current->mm->mmap_sem);
@@ -639,7 +641,7 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 
 	prot = addp.prot & (PROT_READ | PROT_WRITE | PROT_EXEC);
 
-	ret = sgx_encl_page_copy(data, addp.src, prot);
+	ret = sgx_encl_page_copy(data, addp.src, prot, addp.mrmask);
 	if (ret)
 		goto out;
 
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 7c1357105e61..3bc92c65f287 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1451,6 +1451,11 @@
  * @enclave_map:
  *	@prot contains the protection that will be applied by the kernel.
  *	Return 0 if permission is granted.
+ *
+ * @enclave_load:
+ *	@vma: the source memory region of the enclave page being loaded.
+ *	@prot: the (maximal) protections of the enclave page.
+ *	Return 0 if permission is granted.
  */
 union security_list_options {
 	int (*binder_set_context_mgr)(struct task_struct *mgr);
@@ -1815,6 +1820,8 @@ union security_list_options {
 
 #ifdef CONFIG_INTEL_SGX
 	int (*enclave_map)(unsigned long prot);
+	int (*enclave_load)(struct vm_area_struct *vma, unsigned long prot,
+			    bool measured);
 #endif /* CONFIG_INTEL_SGX */
 };
 
@@ -2057,6 +2064,7 @@ struct security_hook_heads {
 #endif /* CONFIG_BPF_SYSCALL */
 #ifdef CONFIG_INTEL_SGX
 	struct hlist_head enclave_map;
+	struct hlist_head enclave_load;
 #endif /* CONFIG_INTEL_SGX */
 } __randomize_layout;
 
diff --git a/include/linux/security.h b/include/linux/security.h
index 6a1f54ba6794..572ddfc53039 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1832,11 +1832,18 @@ static inline void security_bpf_prog_free(struct bpf_prog_aux *aux)
 #ifdef CONFIG_INTEL_SGX
 #ifdef CONFIG_SECURITY
 int security_enclave_map(unsigned long prot);
+int security_enclave_load(struct vm_area_struct *vma, unsigned long prot,
+			  bool measured);
 #else
 static inline int security_enclave_map(unsigned long prot)
 {
 	return 0;
 }
+static inline int security_enclave_load(struct vm_area_struct *vma,
+					unsigned long prot, bool measured)
+{
+	return 0;
+}
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_INTEL_SGX */
 
diff --git a/security/security.c b/security/security.c
index 03951e08bdfc..00f483beb1cc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2365,4 +2365,9 @@ int security_enclave_map(unsigned long prot)
 {
 	return call_int_hook(enclave_map, 0, prot);
 }
+int security_enclave_load(struct vm_area_struct *vma, unsigned long prot,
+			  bool measured)
+{
+	return call_int_hook(enclave_load, 0, vma, prot, measured);
+}
 #endif /* CONFIG_INTEL_SGX */
-- 
2.21.0

