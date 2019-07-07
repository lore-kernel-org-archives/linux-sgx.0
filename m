Return-Path: <SRS0=QGFU=VE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09764C61085
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 23:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D69B12064B
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 23:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfGGXlt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Jul 2019 19:41:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:62279 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727671AbfGGXls (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Jul 2019 19:41:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jul 2019 16:41:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,464,1557212400"; 
   d="scan'208";a="340295316"
Received: from bxing-mobl.amr.corp.intel.com (HELO ubt18m.amr.corp.intel.com) ([10.251.135.59])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2019 16:41:47 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, cedric.xing@intel.com
Subject: [RFC PATCH v3 4/4] x86/sgx: Implement SGX specific hooks in SELinux
Date:   Sun,  7 Jul 2019 16:41:34 -0700
Message-Id: <3a9efc8d3c27490dbcfe802ce3facddd62f47872.1562542383.git.cedric.xing@intel.com>
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

This patch governs enclave page protections in a similar way to how current
SELinux governs protections for regular memory pages. In summary:
  · All pages are allowed PROT_READ/PROT_WRITE upon request.
  · For pages that are EADD’ed, PROT_EXEC will be granted initially if
    PROT_EXEC could also be granted to the VMA containing the source pages, or
    if the calling process has ENCLAVE_EXECANON permission. Afterwards,
    PROT_EXEC will be removed once PROT_WRITE is requested/granted, and could
    be granted again if the backing file has EXECMOD or the calling process has
    PROCMEM. For anonymous pages, backing file is considered to be the file
    containing SIGSTRUCT.
  · For pages that are EAUG’ed, they are considered modified initially so
    PROT_EXEC will not be granted unless the file containing SIGSTRUCT has
    EXECMOD, or the calling process has EXECMEM.

Besides, launch control is implemented as EXECUTE permission on the SIGSTRUCT
file. That is,
  · SIGSTRUCT file has EXECUTE – Enclave is allowed to launch. But this is
    granted only if the enclosing VMA has the same content as the disk file
    (i.e. vma->anon_vma == NULL).
  · SIGSTRUCT file has EXECMOD – All anonymous enclave pages are allowed
    PROT_EXEC.

In all cases, simultaneous WX requires EXECMEM on the calling process.

Implementation wise, 2 bits are associated with every EMA by SELinux.
  · sourced – Set if EMA is loaded from some memory page (i.e. EADD’ed),
    cleared otherwise. When cleared, the backing file is considered to be the
    file containing SIGSTRUCT.
  · modified – Set if EMA has ever been mapped writable, as result of
    mmap()/mprotect() syscalls. When set, FILE__EXECMOD is required on the
    backing file for the range to be executable.

Both bits are initialized at selinux_enclave_load() and checked in
selinux_file_mprotect(). SGX subsystem is expected to invoke
security_file_mprotect() upon mmap() to not bypass the check. mmap() shall be
treated as mprotect() from PROT_NONE to the requested protection.

selinux_enclave_init() determines if an enclave is allowed to launch, using the
criteria described earlier. This implementation does NOT accept SIGSTRUCT in
anonymous memory. The backing file is also cached in struct
file_security_struct and will serve as the base for decisions for anonymous
pages.

There’s one new process permission – PROCESS2__ENCLAVE_EXECANON introduced by
this patch. It is equivalent to FILE__EXECUTE for all enclave pages loaded from
anonymous mappings.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 security/selinux/hooks.c            | 236 +++++++++++++++++++++++++++-
 security/selinux/include/classmap.h |   3 +-
 security/selinux/include/objsec.h   |   7 +
 3 files changed, 243 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 94de51628fdc..c7fe1d47654d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3499,6 +3499,13 @@ static int selinux_file_alloc_security(struct file *file)
 	return file_alloc_security(file);
 }
 
+static void selinux_file_free_security(struct file *file)
+{
+	long f = atomic_long_read(&selinux_file(file)->encl_ss);
+	if (f)
+		fput((struct file *)f);
+}
+
 /*
  * Check whether a task has the ioctl permission and cmd
  * operation to an inode.
@@ -3666,19 +3673,23 @@ static int selinux_mmap_file(struct file *file, unsigned long reqprot,
 				   (flags & MAP_TYPE) == MAP_SHARED);
 }
 
+#ifdef CONFIG_INTEL_SGX
+static int enclave_mprotect(struct vm_area_struct *, size_t);
+#endif
+
 static int selinux_file_mprotect(struct vm_area_struct *vma,
 				 unsigned long reqprot,
 				 unsigned long prot)
 {
 	const struct cred *cred = current_cred();
 	u32 sid = cred_sid(cred);
+	int rc = 0;
 
 	if (selinux_state.checkreqprot)
 		prot = reqprot;
 
 	if (default_noexec &&
 	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
-		int rc = 0;
 		if (vma->vm_start >= vma->vm_mm->start_brk &&
 		    vma->vm_end <= vma->vm_mm->brk) {
 			rc = avc_has_perm(&selinux_state,
@@ -3705,7 +3716,12 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 			return rc;
 	}
 
-	return file_map_prot_check(vma->vm_file, prot, vma->vm_flags&VM_SHARED);
+	rc = file_map_prot_check(vma->vm_file, prot, vma->vm_flags&VM_SHARED);
+#ifdef CONFIG_INTEL_SGX
+	if (!rc)
+		rc = enclave_mprotect(vma, prot);
+#endif
+	return rc;
 }
 
 static int selinux_file_lock(struct file *file, unsigned int cmd)
@@ -6740,6 +6756,213 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
 }
 #endif
 
+#ifdef CONFIG_INTEL_SGX
+static size_t ema__blob __lsm_ro_after_init;
+
+static inline struct ema_security_struct *selinux_ema(struct ema *ema)
+{
+	return ema_data(ema, ema__blob);
+}
+
+static int ema__chk_X_cb(struct ema *ema, void *a)
+{
+	struct file_security_struct *fsec = selinux_file(a);
+	struct ema_security_struct *esec = selinux_ema(ema);
+	struct file *ess = (struct file *)atomic_long_read(&fsec->encl_ss);
+	int rc;
+
+	if (!esec->sourced) {
+		/* EAUG'ed pages */
+		rc = file_has_perm(current_cred(), ess, FILE__EXECMOD);
+	} else if (!ema->source) {
+		/* EADD'ed anonymous pages */
+		u32 sid = current_sid();
+		rc = avc_has_perm(&selinux_state, sid, sid, SECCLASS_PROCESS2,
+				  PROCESS2__ENCLAVE_EXECANON, NULL);
+		if (rc)
+			rc = avc_has_perm(&selinux_state, sid, sid,
+					  SECCLASS_PROCESS, PROCESS__EXECMEM,
+					  NULL);
+		if (!rc && esec->modified)
+			rc = file_has_perm(current_cred(), ess, FILE__EXECMOD);
+	} else {
+		/* EADD'ed pages from files */
+		u32 av = FILE__EXECUTE;
+		if (esec->modified)
+			av |= FILE__EXECMOD;
+		rc = file_has_perm(current_cred(), ema->source, av);
+	}
+
+	return rc;
+}
+
+static int ema__set_M_cb(struct ema *ema, void *a)
+{
+	selinux_ema(ema)->modified = 1;
+	return 0;
+}
+
+static int enclave_mprotect(struct vm_area_struct *vma, size_t prot)
+{
+	struct ema_map *m;
+	int rc;
+
+	/* is vma an enclave vma ? */
+	if (!vma->vm_file)
+		return 0;
+	m = ema_get_map(vma->vm_file);
+	if (!m)
+		return 0;
+
+	/* WX requires EXECMEM */
+	if ((prot && PROT_WRITE) && (prot & PROT_EXEC)) {
+		rc = avc_has_perm(&selinux_state, current_sid(), current_sid(),
+				  SECCLASS_PROCESS, PROCESS__EXECMEM, NULL);
+		if (rc)
+			return rc;
+	}
+
+	rc = ema_lock_map(m);
+	if (rc)
+		return rc;
+
+	if ((prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC))
+		rc = ema_apply_to_range(m, vma->vm_start, vma->vm_end,
+					ema__chk_X_cb, vma->vm_file);
+	if (!rc && (prot & PROT_WRITE) && !(vma->vm_flags & VM_WRITE))
+		rc = ema_apply_to_range(m, vma->vm_start, vma->vm_end,
+					ema__set_M_cb, NULL);
+
+	ema_unlock_map(m);
+
+	return rc;
+}
+
+static int enclave_load_prot_check(struct file *encl, size_t prot,
+				   struct vm_area_struct *vma)
+{
+	struct file_security_struct *fsec = selinux_file(encl);
+	struct file *ess;
+	const struct cred *cred = current_cred();
+	u32 sid = cred_sid(cred);
+	int rc;
+	int modified = 0;
+
+	/* R/W without X are always allowed */
+	if (!(prot & PROT_EXEC))
+		/* R/W always allowed */
+		return 0;
+
+	if (!vma) {
+		ess = (struct file *)atomic_long_read(&fsec->encl_ss);
+		WARN_ON(!ess);
+		if (unlikely(!ess))
+			return -EPERM;
+
+		/* For EAUG, X is considered self-modifying code */
+		rc = file_has_perm(cred, ess, FILE__EXECMOD);
+	} else if (!vma->vm_file || IS_PRIVATE(file_inode(vma->vm_file))) {
+		/* EADD from anonymous pages requires ENCLAVE_EXECANON */
+		if (!(prot & PROT_WRITE) &&
+		    avc_has_perm(&selinux_state, sid, sid, SECCLASS_PROCESS2,
+				 PROCESS2__ENCLAVE_EXECANON, NULL)) {
+			/* On failure, Trigger EXECMEM check at the end */
+			prot |= PROT_WRITE;
+		}
+		rc = 0;
+	} else {
+		/* EADD from file requires EXECUTE */
+		u32 av = FILE__EXECUTE;
+
+		/* EXECMOD required for modified private mapping */
+		if (vma->anon_vma) {
+			av |= FILE__EXECMOD;
+			modified = 1;
+		}
+
+		rc = file_has_perm(cred, vma->vm_file, av);
+	}
+
+	/* WX requires EXECMEM additionally */
+	if (!rc && (prot & PROT_WRITE))
+		rc = avc_has_perm(&selinux_state, sid, sid, SECCLASS_PROCESS,
+				  PROCESS__EXECMEM, NULL);
+
+	return rc ? rc : modified;
+}
+
+static int ema__set_cb(struct ema *ema, void *a)
+{
+	struct ema_security_struct *esec = selinux_ema(ema);
+	struct ema_security_struct *s = a;
+
+	esec->modified = s->modified;
+	esec->sourced = s->sourced;
+	return 0;
+}
+
+static int selinux_enclave_load(struct file *encl, size_t start, size_t end,
+				size_t flags, struct vm_area_struct *src)
+{
+	struct ema_map *m;
+	size_t prot;
+	int rc;
+
+	m = ema_get_map(encl);
+	WARN_ON(!m);
+	if (unlikely(!m))
+		return -EPERM;
+
+	prot = flags & (PROT_READ | PROT_WRITE | PROT_EXEC);
+
+	/* check if @prot could be granted */
+	rc = enclave_load_prot_check(encl, prot, src);
+
+	/* initialize ema */
+	if (rc >= 0) {
+		struct ema_security_struct esec;
+
+		if ((prot & PROT_WRITE) || rc)
+			esec.modified = 1;
+		if (src)
+			esec.sourced = 1;
+
+		rc = ema_lock_apply_to_range(m, start, end,
+					     ema__set_cb, &esec);
+	}
+
+	/* remove ema on error */
+	if (rc)
+		ema_remove_range(m, start, end);
+
+	return rc;
+}
+
+static int selinux_enclave_init(struct file *encl,
+				struct sgx_sigstruct *sigstruct,
+				struct vm_area_struct *src)
+{
+	struct file_security_struct *fsec = selinux_file(encl);
+	int rc;
+
+	/* Is @src mapped shared, or mapped privately and not modified? */
+	if (!src->vm_file || src->anon_vma)
+		return -EACCES;
+
+	/* EXECUTE grants enclaves permission to launch */
+	rc = file_has_perm(current_cred(), src->vm_file, FILE__EXECUTE);
+	if (rc)
+		return rc;
+
+	/* Store SIGSTRUCT file for future use */
+	if (atomic_long_cmpxchg(&fsec->encl_ss, 0, (long)src->vm_file))
+		return -EEXIST;
+
+	get_file(src->vm_file);
+	return 0;
+}
+#endif
+
 struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
 	.lbs_cred = sizeof(struct task_security_struct),
 	.lbs_file = sizeof(struct file_security_struct),
@@ -6822,6 +7045,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
+	LSM_HOOK_INIT(file_free_security, selinux_file_free_security),
 	LSM_HOOK_INIT(file_ioctl, selinux_file_ioctl),
 	LSM_HOOK_INIT(mmap_file, selinux_mmap_file),
 	LSM_HOOK_INIT(mmap_addr, selinux_mmap_addr),
@@ -6982,6 +7206,11 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(bpf_map_free_security, selinux_bpf_map_free),
 	LSM_HOOK_INIT(bpf_prog_free_security, selinux_bpf_prog_free),
 #endif
+
+#ifdef CONFIG_INTEL_SGX
+	LSM_HOOK_INIT(enclave_load, selinux_enclave_load),
+	LSM_HOOK_INIT(enclave_init, selinux_enclave_init),
+#endif
 };
 
 static __init int selinux_init(void)
@@ -7007,6 +7236,9 @@ static __init int selinux_init(void)
 
 	hashtab_cache_init();
 
+#ifdef CONFIG_INTEL_SGX
+	ema__blob = ema_request_blob(sizeof(struct ema_security_struct));
+#endif
 	security_add_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks), "selinux");
 
 	if (avc_add_callback(selinux_netcache_avc_callback, AVC_CALLBACK_RESET))
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 201f7e588a29..0d3161a52577 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -51,7 +51,8 @@ struct security_class_mapping secclass_map[] = {
 	    "execmem", "execstack", "execheap", "setkeycreate",
 	    "setsockcreate", "getrlimit", NULL } },
 	{ "process2",
-	  { "nnp_transition", "nosuid_transition", NULL } },
+	  { "nnp_transition", "nosuid_transition",
+	    "enclave_execanon", NULL } },
 	{ "system",
 	  { "ipc_info", "syslog_read", "syslog_mod",
 	    "syslog_console", "module_request", "module_load", NULL } },
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 91c5395dd20c..8d1ce9c6d6fa 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -23,6 +23,7 @@
 #include <linux/in.h>
 #include <linux/spinlock.h>
 #include <linux/lsm_hooks.h>
+#include <linux/lsm_ema.h>
 #include <linux/msg.h>
 #include <net/net_namespace.h>
 #include "flask.h"
@@ -68,6 +69,7 @@ struct file_security_struct {
 	u32 fown_sid;		/* SID of file owner (for SIGIO) */
 	u32 isid;		/* SID of inode at the time of file open */
 	u32 pseqno;		/* Policy seqno at the time of file open */
+	atomic_long_t encl_ss;	/* Enclave sigstruct file */
 };
 
 struct superblock_security_struct {
@@ -154,6 +156,11 @@ struct bpf_security_struct {
 	u32 sid;  /*SID of bpf obj creater*/
 };
 
+struct ema_security_struct {
+	int modified:1;	/* Set when W is granted */
+	int sourced:1;	/* Set if loaded from source in regular memory */
+};
+
 extern struct lsm_blob_sizes selinux_blob_sizes;
 static inline struct task_security_struct *selinux_cred(const struct cred *cred)
 {
-- 
2.17.1

