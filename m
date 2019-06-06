Return-Path: <SRS0=qw+Y=UF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336B0C28D18
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 02:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D1B420866
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 02:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfFFCL6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 22:11:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:61631 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfFFCLw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 22:11:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 19:11:50 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 05 Jun 2019 19:11:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: [RFC PATCH v2 4/5] LSM: x86/sgx: Introduce ->enclave_load() hook for Intel SGX
Date:   Wed,  5 Jun 2019 19:11:44 -0700
Message-Id: <20190606021145.12604-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190606021145.12604-1-sean.j.christopherson@intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
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
actual protections being provided.  In other words, LSMs will likely
want to implement different policies for enclave page protections.

Note, extensive discussion yielded no sane alternative to some form of
SGX specific LSM hook[1].

[1] https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 12 ++++++------
 include/linux/lsm_hooks.h              | 13 +++++++++++++
 include/linux/security.h               | 12 ++++++++++++
 security/security.c                    |  7 +++++++
 4 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 44b2d73de7c3..29c0df672250 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -8,6 +8,7 @@
 #include <linux/highmem.h>
 #include <linux/ratelimit.h>
 #include <linux/sched/signal.h>
+#include <linux/security.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
@@ -582,9 +583,6 @@ static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot)
 	struct vm_area_struct *vma;
 	int ret;
 
-	if (!(prot & VM_EXEC))
-		return 0;
-
 	/* Hold mmap_sem across copy_from_user() to avoid a TOCTOU race. */
 	down_read(&current->mm->mmap_sem);
 
@@ -599,15 +597,17 @@ static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot)
 	 * but with some future proofing against other cases that may deny
 	 * execute permissions.
 	 */
-	if (!(vma->vm_flags & VM_MAYEXEC)) {
+	if ((prot & VM_EXEC) && !(vma->vm_flags & VM_MAYEXEC)) {
 		ret = -EACCES;
 		goto out;
 	}
 
+	ret = security_enclave_load(vma, prot);
+	if (ret)
+		goto out;
+
 	if (copy_from_user(dst, (void __user *)src, PAGE_SIZE))
 		ret = -EFAULT;
-	else
-		ret = 0;
 
 out:
 	up_read(&current->mm->mmap_sem);
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 47f58cfb6a19..c6f47a7eef70 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1446,6 +1446,12 @@
  * @bpf_prog_free_security:
  *	Clean up the security information stored inside bpf prog.
  *
+ * Security hooks for Intel SGX enclaves.
+ *
+ * @enclave_load:
+ *	@vma: the source memory region of the enclave page being loaded.
+ *	@prot: the (maximal) protections of the enclave page.
+ *	Return 0 if permission is granted.
  */
 union security_list_options {
 	int (*binder_set_context_mgr)(struct task_struct *mgr);
@@ -1807,6 +1813,10 @@ union security_list_options {
 	int (*bpf_prog_alloc_security)(struct bpf_prog_aux *aux);
 	void (*bpf_prog_free_security)(struct bpf_prog_aux *aux);
 #endif /* CONFIG_BPF_SYSCALL */
+
+#ifdef CONFIG_INTEL_SGX
+	int (*enclave_load)(struct vm_area_struct *vma, unsigned long prot);
+#endif /* CONFIG_INTEL_SGX */
 };
 
 struct security_hook_heads {
@@ -2046,6 +2056,9 @@ struct security_hook_heads {
 	struct hlist_head bpf_prog_alloc_security;
 	struct hlist_head bpf_prog_free_security;
 #endif /* CONFIG_BPF_SYSCALL */
+#ifdef CONFIG_INTEL_SGX
+	struct hlist_head enclave_load;
+#endif /* CONFIG_INTEL_SGX */
 } __randomize_layout;
 
 /*
diff --git a/include/linux/security.h b/include/linux/security.h
index 659071c2e57c..0b6d1eb7368b 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1829,5 +1829,17 @@ static inline void security_bpf_prog_free(struct bpf_prog_aux *aux)
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_BPF_SYSCALL */
 
+#ifdef CONFIG_INTEL_SGX
+#ifdef CONFIG_SECURITY
+int security_enclave_load(struct vm_area_struct *vma, unsigned long prot);
+#else
+static inline int security_enclave_load(struct vm_area_struct *vma,
+					unsigned long prot)
+{
+	return 0;
+}
+#endif /* CONFIG_SECURITY */
+#endif /* CONFIG_INTEL_SGX */
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/security/security.c b/security/security.c
index 613a5c00e602..c6f7f26969b2 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2359,3 +2359,10 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
 	call_void_hook(bpf_prog_free_security, aux);
 }
 #endif /* CONFIG_BPF_SYSCALL */
+
+#ifdef CONFIG_INTEL_SGX
+int security_enclave_load(struct vm_area_struct *vma, unsigned long prot)
+{
+	return call_int_hook(enclave_load, 0, vma, prot);
+}
+#endif /* CONFIG_INTEL_SGX */
-- 
2.21.0

