Return-Path: <SRS0=g3U3=T7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF588C04AB6
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A36CE25725
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfEaXcj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 31 May 2019 19:32:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:59347 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbfEaXci (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 31 May 2019 19:32:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 16:32:31 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 31 May 2019 16:32:31 -0700
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
Subject: [RFC PATCH 8/9] LSM: x86/sgx: Introduce ->enclave_load() hook for Intel SGX
Date:   Fri, 31 May 2019 16:31:58 -0700
Message-Id: <20190531233159.30992-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531233159.30992-1-sean.j.christopherson@intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
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
VMAs.  As a result, file_mprotect() does not provide any meaningful
security for enclaves since an LSM can only deny/grant access to the
EPC as a whole.

security_enclave_load() is called when SGX is first loading an enclave
page, i.e. copying a page from normal memory into the EPC.  The notable
difference from file_mprotect() is the allowed_prot parameter, which
is essentially an SGX-specific version of a VMA's MAY_{READ,WRITE,EXEC}
flags.  The purpose of allowed_prot is to enable checks such as
SELinux's FILE__EXECMOD permission without having to track and update
VMAs across multiple mm structs, i.e. SGX can ensure userspace doesn't
overstep its bounds simply by restricting an enclave VMA's protections
by vetting what is maximally allowed during build time.

An alternative to the allowed_prot approach would be to use an enclave's
SIGSTRUCT (a smallish structure that can uniquely identify an enclave)
as a proxy for the enclave.  For example, SGX could take and hold a
reference to the file containing the SIGSTRUCT (if it's in a file) and
call security_enclave_load() during mprotect().  While the SIGSTRUCT
approach would provide better precision, the actual value added was
deemed to be negligible.  On the other hand, pinning a file for the
lifetime of the enclave is ugly, and essentially caching LSM policies
in each page's allowed_prot avoids having to make an extra LSM upcall
during mprotect().

Note, extensive discussion yielded no sane alternative to some form of
SGX specific LSM hook[1].

[1] https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 14 +++++++++-----
 include/linux/lsm_hooks.h              | 16 ++++++++++++++++
 include/linux/security.h               |  2 ++
 security/security.c                    |  8 ++++++++
 4 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 5f71be7cbb01..260417ecbcff 100644
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
@@ -580,21 +581,24 @@ static int sgx_encl_page_protect(unsigned long src, unsigned long prot,
 				 unsigned long *allowed_prot)
 {
 	struct vm_area_struct *vma;
+	int ret = 0;
 
-	if (!(*allowed_prot & VM_EXEC))
+	if (!(*allowed_prot & VM_EXEC) && !IS_ENABLED(CONFIG_SECURITY))
 		goto do_check;
 
 	down_read(&current->mm->mmap_sem);
 	vma = find_vma(current->mm, src);
 	if (!vma || (vma->vm_file && path_noexec(&vma->vm_file->f_path)))
 		*allowed_prot &= ~VM_EXEC;
+#ifdef CONFIG_SECURITY
+	ret = security_enclave_load(vma, prot, allowed_prot);
+#endif
 	up_read(&current->mm->mmap_sem);
 
 do_check:
-	if (prot & ~*allowed_prot)
-		return -EACCES;
-
-	return 0;
+	if (!ret && (prot & ~*allowed_prot))
+		ret = -EACCES;
+	return ret;
 }
 
 static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 47f58cfb6a19..0562775424a0 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1446,6 +1446,14 @@
  * @bpf_prog_free_security:
  *	Clean up the security information stored inside bpf prog.
  *
+ * Security hooks for Intel SGX enclaves.
+ *
+ * @enclave_load:
+ *	On success, returns 0 and optionally adjusts @allowed_prot
+ *	@vma: the source memory region of the enclave page being loaded.
+ *	@prot: the initial protection of the enclave page.
+ *	@allowed_prot: the maximum protections of the enclave page.
+ *	Return 0 if permission is granted.
  */
 union security_list_options {
 	int (*binder_set_context_mgr)(struct task_struct *mgr);
@@ -1807,6 +1815,11 @@ union security_list_options {
 	int (*bpf_prog_alloc_security)(struct bpf_prog_aux *aux);
 	void (*bpf_prog_free_security)(struct bpf_prog_aux *aux);
 #endif /* CONFIG_BPF_SYSCALL */
+
+#ifdef CONFIG_INTEL_SGX
+	int (*enclave_load)(struct vm_area_struct *vma, unsigned long prot,
+			    unsigned long *allowed_prot);
+#endif /* CONFIG_INTEL_SGX */
 };
 
 struct security_hook_heads {
@@ -2046,6 +2059,9 @@ struct security_hook_heads {
 	struct hlist_head bpf_prog_alloc_security;
 	struct hlist_head bpf_prog_free_security;
 #endif /* CONFIG_BPF_SYSCALL */
+#ifdef CONFIG_INTEL_SGX
+	struct hlist_head enclave_load;
+#endif /* CONFIG_INTEL_SGX */
 } __randomize_layout;
 
 /*
diff --git a/include/linux/security.h b/include/linux/security.h
index 659071c2e57c..2f7925eeef7e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -392,6 +392,8 @@ void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
+int security_enclave_load(struct vm_area_struct *vma, unsigned long prot,
+			  unsigned long *allowed_prot);
 #else /* CONFIG_SECURITY */
 
 static inline int call_lsm_notifier(enum lsm_event event, void *data)
diff --git a/security/security.c b/security/security.c
index 613a5c00e602..07ed6763571e 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2359,3 +2359,11 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
 	call_void_hook(bpf_prog_free_security, aux);
 }
 #endif /* CONFIG_BPF_SYSCALL */
+
+#ifdef CONFIG_INTEL_SGX
+int security_enclave_load(struct vm_area_struct *vma, unsigned long prot,
+			  unsigned long *allowed_prot)
+{
+	return call_int_hook(enclave_load, 0, vma, prot, allowed_prot);
+}
+#endif /* CONFIG_INTEL_SGX */
-- 
2.21.0

