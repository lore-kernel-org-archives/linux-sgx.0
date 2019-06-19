Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 343A9C4646B
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 22:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 157D4215EA
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 22:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbfFSWYR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 18:24:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:40162 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbfFSWYQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 18:24:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 15:24:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,394,1557212400"; 
   d="scan'208";a="150743768"
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
Subject: [RFC PATCH v4 07/12] LSM: x86/sgx: Introduce ->enclave_map() hook for Intel SGX
Date:   Wed, 19 Jun 2019 15:23:56 -0700
Message-Id: <20190619222401.14942-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190619222401.14942-1-sean.j.christopherson@intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

enclave_map() is an SGX specific variant of file_mprotect() and
mmap_file(), and is provided so that LSMs can apply W^X restrictions to
enclaves.

Due to the nature of SGX and its Enclave Page Cache (EPC), all enclave
VMAs are backed by a single file, i.e. /dev/sgx/enclave, that must be
MAP_SHARED.  Furthermore, all enclaves need read, write and execute
VMAs.  As a result, applying W^X restrictions on /dev/sgx/enclave using
existing LSM hooks is for all intents and purposes impossible, e.g.
denying either W or X would deny access to any enclave.

Note, extensive discussion yielded no sane alternative to some form of
SGX specific LSM hook[1].

[1] https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/main.c |  9 ++++++++-
 arch/x86/kernel/cpu/sgx/encl.c        | 12 ++++++++++++
 include/linux/lsm_hooks.h             | 12 ++++++++++++
 include/linux/security.h              | 11 +++++++++++
 security/security.c                   |  7 +++++++
 5 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index dabfe2a7245a..4379a2fb1f82 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -133,13 +133,20 @@ static unsigned long sgx_allowed_rwx(struct sgx_encl *encl,
 static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct sgx_encl *encl = file->private_data;
-	unsigned long allowed_rwx;
+	unsigned long allowed_rwx, prot;
 	int ret;
 
 	allowed_rwx = sgx_allowed_rwx(encl, vma);
 	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC) & ~allowed_rwx)
 		return -EACCES;
 
+	prot = _calc_vm_trans(vma->vm_flags, VM_READ, PROT_READ) |
+	       _calc_vm_trans(vma->vm_flags, VM_WRITE, PROT_WRITE) |
+	       _calc_vm_trans(vma->vm_flags, VM_EXEC, PROT_EXEC);
+	ret = security_enclave_map(prot);
+	if (ret)
+		return ret;
+
 	ret = sgx_encl_mm_add(encl, vma->vm_mm);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index c6436bbd4a68..059d90dcaa27 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -2,6 +2,7 @@
 // Copyright(c) 2016-18 Intel Corporation.
 
 #include <linux/mm.h>
+#include <linux/security.h>
 #include <linux/shmem_fs.h>
 #include <linux/suspend.h>
 #include <linux/sched/mm.h>
@@ -387,9 +388,20 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
 	return ret < 0 ? ret : i;
 }
 
+#ifdef CONFIG_SECURITY
+static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end, unsigned long prot)
+{
+	return security_enclave_map(prot);
+}
+#endif
+
 const struct vm_operations_struct sgx_vm_ops = {
 	.fault = sgx_vma_fault,
 	.access = sgx_vma_access,
+#ifdef CONFIG_SECURITY
+	.may_mprotect = sgx_vma_mprotect,
+#endif
 };
 
 /**
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 47f58cfb6a19..7c1357105e61 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1446,6 +1446,11 @@
  * @bpf_prog_free_security:
  *	Clean up the security information stored inside bpf prog.
  *
+ * Security hooks for Intel SGX enclaves.
+ *
+ * @enclave_map:
+ *	@prot contains the protection that will be applied by the kernel.
+ *	Return 0 if permission is granted.
  */
 union security_list_options {
 	int (*binder_set_context_mgr)(struct task_struct *mgr);
@@ -1807,6 +1812,10 @@ union security_list_options {
 	int (*bpf_prog_alloc_security)(struct bpf_prog_aux *aux);
 	void (*bpf_prog_free_security)(struct bpf_prog_aux *aux);
 #endif /* CONFIG_BPF_SYSCALL */
+
+#ifdef CONFIG_INTEL_SGX
+	int (*enclave_map)(unsigned long prot);
+#endif /* CONFIG_INTEL_SGX */
 };
 
 struct security_hook_heads {
@@ -2046,6 +2055,9 @@ struct security_hook_heads {
 	struct hlist_head bpf_prog_alloc_security;
 	struct hlist_head bpf_prog_free_security;
 #endif /* CONFIG_BPF_SYSCALL */
+#ifdef CONFIG_INTEL_SGX
+	struct hlist_head enclave_map;
+#endif /* CONFIG_INTEL_SGX */
 } __randomize_layout;
 
 /*
diff --git a/include/linux/security.h b/include/linux/security.h
index 659071c2e57c..6a1f54ba6794 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1829,5 +1829,16 @@ static inline void security_bpf_prog_free(struct bpf_prog_aux *aux)
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_BPF_SYSCALL */
 
+#ifdef CONFIG_INTEL_SGX
+#ifdef CONFIG_SECURITY
+int security_enclave_map(unsigned long prot);
+#else
+static inline int security_enclave_map(unsigned long prot)
+{
+	return 0;
+}
+#endif /* CONFIG_SECURITY */
+#endif /* CONFIG_INTEL_SGX */
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/security/security.c b/security/security.c
index 613a5c00e602..03951e08bdfc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2359,3 +2359,10 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
 	call_void_hook(bpf_prog_free_security, aux);
 }
 #endif /* CONFIG_BPF_SYSCALL */
+
+#ifdef CONFIG_INTEL_SGX
+int security_enclave_map(unsigned long prot)
+{
+	return call_int_hook(enclave_map, 0, prot);
+}
+#endif /* CONFIG_INTEL_SGX */
-- 
2.21.0

