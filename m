Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0822BC468C1
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 07:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2E2D206E0
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 07:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbfFJHDL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 03:03:11 -0400
Received: from mga04.intel.com ([192.55.52.120]:3981 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387582AbfFJHDL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 03:03:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 00:03:10 -0700
X-ExtLoop1: 1
Received: from bxing-mobl.amr.corp.intel.com (HELO ubt18m.amr.corp.intel.com) ([10.255.90.159])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jun 2019 00:03:09 -0700
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
Subject: [RFC PATCH v1 1/3] LSM/x86/sgx: Add SGX specific LSM hooks
Date:   Mon, 10 Jun 2019 00:03:04 -0700
Message-Id: <e32577424bb65dac5187e67b70573c0f336fef3b.1560131039.git.cedric.xing@intel.com>
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

This patch has made two changes to LSM hooks.

The first change is the addition of two new SGX specific LSM hooks.

security_enclave_load() - is called whenever new EPC pages are added to an
enclave, so that an LSM module could initialize internal states for those
pages. An LSM module may track protections ever granted to enclave pages in
order to come to reasonable decisions in security_file_mprotect() hook in
future.

security_enclave_init() - is called when an enclave is about to be intialized
(by EINIT). An LSM module may approve/decline the request by looking into the
SIGSTRUCT, or the file from which the SIGSTRUCT was loaded from.

The second change is to export symbol security_file_mprotect() to make it
available to kernel modules. The SGX module will invoke
security_file_mprotect() to validate protection for the virtual memory range
being mmap()'ed.

Please see include/linux/lsm_hooks.h for more information.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 include/linux/lsm_hooks.h | 33 +++++++++++++++++++++++++++++++++
 include/linux/security.h  | 26 ++++++++++++++++++++++++++
 security/security.c       | 21 +++++++++++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 47f58cfb6a19..ceb18c5c25f3 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1446,6 +1446,27 @@
  * @bpf_prog_free_security:
  *	Clean up the security information stored inside bpf prog.
  *
+ * Security hooks for SGX enclaves
+ *
+ * @enclave_load:
+ *	Check permissions before loading pages into enclaves. Must be called
+ *	with current->mm->mmap_sem locked.
+ *	@encl: file pointer identifying the enclave
+ *	@addr: linear address to which new pages are being added. Must be page
+ *	aligned
+ *	@size: total size of pages being added. Must be integral multiple of
+ *	page size
+ *	@prot: requested protection. Shall be the same protection as the VMA
+ *	covering the target linear range, or 0 if target range not mapped
+ *	@source: the VMA containing the source pages. Shall be NULL if there's
+ *	no source pages (e.g. EAUG)
+ *
+ * @enclave_init:
+ *	Check SIGSTRUCT before initializing (EINIT) enclaves. Must be called
+ *	with current->mm->mmap_sem locked.
+ *	@encl: file pointer identifying the enclave being initialized
+ *	@sigstruct: pointer to sigstruct in kernel memory
+ *	@sigstruct_vma: vma containing the original sigstruct in user space
  */
 union security_list_options {
 	int (*binder_set_context_mgr)(struct task_struct *mgr);
@@ -1807,6 +1828,14 @@ union security_list_options {
 	int (*bpf_prog_alloc_security)(struct bpf_prog_aux *aux);
 	void (*bpf_prog_free_security)(struct bpf_prog_aux *aux);
 #endif /* CONFIG_BPF_SYSCALL */
+#ifdef CONFIG_INTEL_SGX
+	int (*enclave_load)(struct file *encl, unsigned long addr,
+			    unsigned long size, unsigned long prot,
+			    struct vm_area_struct *source);
+	int (*enclave_init)(struct file *encl,
+			    const struct sgx_sigstruct *sigstruct,
+			    struct vm_area_struct *sigstruct_vma);
+#endif /* CONFIG_INTEL_SGX */
 };
 
 struct security_hook_heads {
@@ -2046,6 +2075,10 @@ struct security_hook_heads {
 	struct hlist_head bpf_prog_alloc_security;
 	struct hlist_head bpf_prog_free_security;
 #endif /* CONFIG_BPF_SYSCALL */
+#ifdef CONFIG_INTEL_SGX
+	struct hlist_head enclave_load;
+	struct hlist_head enclave_init;
+#endif /* CONFIG_INTEL_SGX */
 } __randomize_layout;
 
 /*
diff --git a/include/linux/security.h b/include/linux/security.h
index 659071c2e57c..d44655dd06dd 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1829,5 +1829,31 @@ static inline void security_bpf_prog_free(struct bpf_prog_aux *aux)
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_BPF_SYSCALL */
 
+#ifdef CONFIG_INTEL_SGX
+struct sgx_sigstruct;
+#ifdef CONFIG_SECURITY
+extern int security_enclave_load(struct file *encl, unsigned long addr,
+				 unsigned long size, unsigned long prot,
+				 struct vm_area_struct *source);
+extern int security_enclave_init(struct file *encl,
+				 const struct sgx_sigstruct *sigstruct,
+				 struct vm_area_struct *sigstruct_vma);
+#else
+static inline int security_enclave_load(struct file *encl, unsigned long addr,
+					unsigned long size, unsigned long prot,
+					struct vm_area_struct *source)
+{
+	return 0;
+}
+
+static inline int security_enclave_init(struct file *encl,
+					const struct sigstruct *sigstruct,
+					struct vm_area_struct *sigstruct_vma)
+{
+	return 0;
+}
+#endif /* CONFIG_SECURITY */
+#endif /* CONFIG_INTEL_SGX */
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/security/security.c b/security/security.c
index f493db0bf62a..3a5c9847f2c8 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1420,6 +1420,7 @@ int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 {
 	return call_int_hook(file_mprotect, 0, vma, reqprot, prot);
 }
+EXPORT_SYMBOL(security_file_mprotect);
 
 int security_file_lock(struct file *file, unsigned int cmd)
 {
@@ -2355,3 +2356,23 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
 	call_void_hook(bpf_prog_free_security, aux);
 }
 #endif /* CONFIG_BPF_SYSCALL */
+
+#ifdef CONFIG_INTEL_SGX
+
+int security_enclave_load(struct file *encl, unsigned long addr,
+			  unsigned long size, unsigned long prot,
+			  struct vm_area_struct *source)
+{
+	return call_int_hook(enclave_load, 0, encl, addr, size, prot, source);
+}
+EXPORT_SYMBOL(security_enclave_load);
+
+int security_enclave_init(struct file *encl,
+			  const struct sgx_sigstruct *sigstruct,
+			  struct vm_area_struct *sigstruct_vma)
+{
+	return call_int_hook(enclave_init, 0, encl, sigstruct, sigstruct_vma);
+}
+EXPORT_SYMBOL(security_enclave_init);
+
+#endif /* CONFIG_INTEL_SGX */
-- 
2.17.1

