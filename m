Return-Path: <SRS0=QGFU=VE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3298C61084
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 23:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5C7B2064B
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 23:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfGGXlr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Jul 2019 19:41:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:62277 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbfGGXlr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Jul 2019 19:41:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jul 2019 16:41:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,464,1557212400"; 
   d="scan'208";a="340295307"
Received: from bxing-mobl.amr.corp.intel.com (HELO ubt18m.amr.corp.intel.com) ([10.251.135.59])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2019 16:41:45 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, cedric.xing@intel.com
Subject: [RFC PATCH v3 1/4] x86/sgx: Add SGX specific LSM hooks
Date:   Sun,  7 Jul 2019 16:41:31 -0700
Message-Id: <3280c19f6f5c718fb17c7463fc9f620cd06a05cc.1562542383.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1562542383.git.cedric.xing@intel.com>
References: <cover.1562542383.git.cedric.xing@intel.com>
In-Reply-To: <cover.1562542383.git.cedric.xing@intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com> <cover.1562542383.git.cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGX enclaves are loaded from pages in regular memory. Given the ability to
create executable pages, the newly added SGX subsystem may present a backdoor
for adversaries to circumvent LSM policies, such as creating an executable
enclave page from a modified regular page that would otherwise not be made
executable as prohibited by LSM. Therefore arises the primary question of
whether an enclave page should be allowed to be created from a given source
page in regular memory.

A related question is whether to grant/deny a mprotect() request on a given
enclave page/range. mprotect() is traditionally covered by
security_file_mprotect() hook, however, enclave pages have a different lifespan
than either MAP_PRIVATE or MAP_SHARED. Particularly, MAP_PRIVATE pages have the
same lifespan as the VMA while MAP_SHARED pages have the same lifespan as the
backing file (on disk), but enclave pages have the lifespan of the enclave’s
file descriptor. For example, enclave pages could be munmap()’ed then mmap()’ed
again without losing contents (like MAP_SHARED), but all enclave pages will be
lost once its file descriptor has been closed (like MAP_PRIVATE). That said,
LSM modules need some new data structure for tracking protections of enclave
pages/ranges so that they can make proper decisions at mmap()/mprotect()
syscalls.

The last question, which is orthogonal to the 2 above, is whether or not to
allow a given enclave to launch/run. Enclave pages are not visible to the rest
of the system, so to some extent offer a better place for malicious software to
hide. Thus, it is sometimes desirable to whitelist/blacklist enclaves by their
measurements, signing public keys, or image files.

To address the questions above, 2 new LSM hooks are added for enclaves.
  · security_enclave_load() – This hook allows LSM to decide whether or not to
    allow instantiation of a range of enclave pages using the specified VMA. It
    is invoked when a range of enclave pages is about to be loaded. It serves 3
    purposes: 1) indicate to LSM that the file struct in subject is an enclave;
    2) allow LSM to decide whether or not to instantiate those pages and 3)
    allow LSM to initialize internal data structures for tracking
    origins/protections of those pages.
  · security_enclave_init() – This hook allows whitelisting/blacklisting or
    performing whatever checks deemed appropriate before an enclave is allowed
    to run. An LSM module may opt to use the file backing the SIGSTRUCT as a
    proxy to dictate allowed protections for anonymous pages.

mprotect() of enclave pages continue to be governed by
security_file_mprotect(), with the expectation that LSM is able to distinguish
between regular and enclave pages inside the hook. For mmap(), the SGX
subsystem is expected to invoke security_file_mprotect() explicitly to check
protections against the requested protections for existing enclave pages.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 include/linux/lsm_hooks.h | 27 +++++++++++++++++++++++++++
 include/linux/security.h  | 23 +++++++++++++++++++++++
 security/security.c       | 17 +++++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 47f58cfb6a19..9d9e44200683 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1446,6 +1446,22 @@
  * @bpf_prog_free_security:
  *	Clean up the security information stored inside bpf prog.
  *
+ * @enclave_load:
+ *	Decide if a range of pages shall be allowed to be loaded into an
+ *	enclave
+ *
+ *	@encl points to the file identifying the target enclave
+ *	@start target range starting address
+ *	@end target range ending address
+ *	@flags contains protections being requested for the target range
+ *	@source points to the VMA containing the source pages to be loaded
+ *
+ * @enclave_init:
+ *	Decide if an enclave shall be allowed to launch
+ *
+ *	@encl points to the file identifying the target enclave being launched
+ *	@sigstruct contains a copy of the SIGSTRUCT in kernel memory
+ *	@source points to the VMA backing SIGSTRUCT in user memory
  */
 union security_list_options {
 	int (*binder_set_context_mgr)(struct task_struct *mgr);
@@ -1807,6 +1823,13 @@ union security_list_options {
 	int (*bpf_prog_alloc_security)(struct bpf_prog_aux *aux);
 	void (*bpf_prog_free_security)(struct bpf_prog_aux *aux);
 #endif /* CONFIG_BPF_SYSCALL */
+
+#ifdef CONFIG_INTEL_SGX
+	int (*enclave_load)(struct file *encl, size_t start, size_t end,
+			    size_t flags, struct vm_area_struct *source);
+	int (*enclave_init)(struct file *encl, struct sgx_sigstruct *sigstruct,
+			    struct vm_area_struct *source);
+#endif
 };
 
 struct security_hook_heads {
@@ -2046,6 +2069,10 @@ struct security_hook_heads {
 	struct hlist_head bpf_prog_alloc_security;
 	struct hlist_head bpf_prog_free_security;
 #endif /* CONFIG_BPF_SYSCALL */
+#ifdef CONFIG_INTEL_SGX
+	struct hlist_head enclave_load;
+	struct hlist_head enclave_init;
+#endif
 } __randomize_layout;
 
 /*
diff --git a/include/linux/security.h b/include/linux/security.h
index 659071c2e57c..52c200810004 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1829,5 +1829,28 @@ static inline void security_bpf_prog_free(struct bpf_prog_aux *aux)
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_BPF_SYSCALL */
 
+#ifdef CONFIG_INTEL_SGX
+struct sgx_sigstruct;
+#ifdef CONFIG_SECURITY
+int security_enclave_load(struct file *encl, size_t start, size_t end,
+			  size_t flags, struct vm_area_struct *source);
+int security_enclave_init(struct file *encl, struct sgx_sigstruct *sigstruct,
+			  struct vm_area_struct *source);
+#else
+static inline int security_enclave_load(struct file *encl, size_t start,
+					size_t end, struct vm_area_struct *src)
+{
+	return 0;
+}
+
+static inline int security_enclave_init(struct file *encl,
+					struct sgx_sigstruct *sigstruct,
+					struct vm_area_struct *src)
+{
+	return 0;
+}
+#endif /* CONFIG_SECURITY */
+#endif /* CONFIG_INTEL_SGX */
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/security/security.c b/security/security.c
index f493db0bf62a..72c10f5e4f95 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1420,6 +1420,7 @@ int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 {
 	return call_int_hook(file_mprotect, 0, vma, reqprot, prot);
 }
+EXPORT_SYMBOL(security_file_mprotect);
 
 int security_file_lock(struct file *file, unsigned int cmd)
 {
@@ -2355,3 +2356,19 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
 	call_void_hook(bpf_prog_free_security, aux);
 }
 #endif /* CONFIG_BPF_SYSCALL */
+
+#ifdef CONFIG_INTEL_SGX
+int security_enclave_load(struct file *encl, size_t start, size_t end,
+			  size_t flags, struct vm_area_struct *src)
+{
+	return call_int_hook(enclave_load, 0, encl, start, end, flags, src);
+}
+EXPORT_SYMBOL(security_enclave_load);
+
+int security_enclave_init(struct file *encl, struct sgx_sigstruct *sigstruct,
+			  struct vm_area_struct *src)
+{
+	return call_int_hook(enclave_init, 0, encl, sigstruct, src);
+}
+EXPORT_SYMBOL(security_enclave_init);
+#endif /* CONFIG_INTEL_SGX */
-- 
2.17.1

