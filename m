Return-Path: <SRS0=2cS5=U2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA19CC48BEE
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 18:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5DDF20645
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Jun 2019 18:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfF0S42 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Jun 2019 14:56:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:10284 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfF0S42 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Jun 2019 14:56:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 11:56:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,424,1557212400"; 
   d="scan'208";a="361259296"
Received: from bxing-desk.ccr.corp.intel.com (HELO ubt18.jf.intel.com) ([134.134.148.187])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jun 2019 11:56:26 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, cedric.xing@intel.com
Cc:     casey.schaufler@intel.com, jmorris@namei.org, luto@kernel.org,
        jethro@fortanix.com, greg@enjellic.com, sds@tycho.nsa.gov,
        jarkko.sakkinen@linux.intel.com, sean.j.christopherson@intel.com
Subject: [RFC PATCH v2 3/3] x86/sgx: Implement SGX specific hooks in SELinux
Date:   Thu, 27 Jun 2019 11:56:21 -0700
Message-Id: <87e835cafc0ad8965ff801859c91ed088fbd67b6.1561588012.git.cedric.xing@intel.com>
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

This patch governs enclave page protections in a similar way to how current
SELinux governs protections for regular memory pages. In summary:
  - All pages are allowed PROT_READ/PROT_WRITE upon request.
  - For pages that are EADD’ed, PROT_EXEC will be granted initially if
    PROT_EXEC could also be granted to the VMA containing the source pages.
    Afterwards, PROT_EXEC will be removed once PROT_WRITE is requested/granted,
    and could be granted again if the backing file has EXECMOD or the calling
    process has PROCMEM. For anonymous pages, backing file is considered to be
    the file containing SIGSTRUCT.
  - For pages that are EAUG’ed, they are considered modified initially so
    PROT_EXEC will not be granted unless the file containing SIGSTRUCT has
    EXECMOD, or the calling process has EXECMEM.

Besides, launch control is implemented as EXECUTE permission on the SIGSTRUCT
file. That is,
  - SIGSTRUCT file has EXECUTE – Enclave is allowed to launch. But this is
    granted only if the enclosing VMA has the same content as the disk file
    (i.e. vma->anon_vma == NULL).
  - SIGSTRUCT file has EXECMOD – All anonymous enclave pages are allowed
    PROT_EXEC.

In all cases, simultaneous WX requires EXECMEM on the calling process.

Implementation wise, 3 bits are associated with every EMA by SELinux.
  - sourced – Set if EMA is loaded from a file, cleared otherwise.
  - execute – Set if EMA is potentially executable, cleared when EMA has once
    been mapped writable, as result of mmap()/mprotect() syscalls. A page is
    executable if this bit is set AND its backing file or the file containing
    SIGSTRUCT (for anonymous pages) has EXECUTE. This bit will be cleared upon
    PROT_WRITE granted to the EMA.
  - execmod – Set if the backing file or the file containing SIGSTRUCT (for
    anonymous pages) has EXECMOD. A page is executable if this bit is set.

All those 3 bits are initialized at selinux_enclave_load() and checked in
selinux_file_mprotect(). SGX subsystem is expected to invoke
security_file_mprotect() upon mmap() to not bypass the check. mmap() shall be
treated as mprotect() from PROT_NONE to the requested protection.

selinux_enclave_init() determines if an enclave is allowed to launch, using the
criteria described earlier. This implementation does NOT accept SIGSTRUCT in
anonymous memory. The backing file is also cached in struct
file_security_struct and will serve as the base for decisions for anonymous
pages.

There are NO new process/file permissions introduced in this patch. The
intention here is to ensure existing SELinux tools will work with enclaves
seamlessly by treating them the same way as regular shared objects.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 security/selinux/hooks.c          | 229 ++++++++++++++++++++++++++++--
 security/selinux/include/objsec.h |  24 ++++
 2 files changed, 245 insertions(+), 8 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 94de51628fdc..cea4db780eb8 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1663,10 +1663,9 @@ static int cred_has_capability(const struct cred *cred,
 /* Check whether a task has a particular permission to an inode.
    The 'adp' parameter is optional and allows other audit
    data to be passed (e.g. the dentry). */
-static int inode_has_perm(const struct cred *cred,
-			  struct inode *inode,
-			  u32 perms,
-			  struct common_audit_data *adp)
+static inline int inode_has_perm_audit(int audit, const struct cred *cred,
+				       struct inode *inode, u32 perms,
+				       struct common_audit_data *adp)
 {
 	struct inode_security_struct *isec;
 	u32 sid;
@@ -1679,8 +1678,22 @@ static int inode_has_perm(const struct cred *cred,
 	sid = cred_sid(cred);
 	isec = selinux_inode(inode);
 
-	return avc_has_perm(&selinux_state,
-			    sid, isec->sid, isec->sclass, perms, adp);
+	if (audit)
+		return avc_has_perm(&selinux_state, sid, isec->sid,
+				    isec->sclass, perms, adp);
+	else {
+		struct av_decision avd;
+		return avc_has_perm_noaudit(&selinux_state, sid, isec->sid,
+					    isec->sclass, perms, 0, &avd);
+	}
+}
+
+static int inode_has_perm(const struct cred *cred,
+			  struct inode *inode,
+			  u32 perms,
+			  struct common_audit_data *adp)
+{
+	return inode_has_perm_audit(1, cred, inode, perms, adp);
 }
 
 /* Same as inode_has_perm, but pass explicit audit data containing
@@ -3499,6 +3512,13 @@ static int selinux_file_alloc_security(struct file *file)
 	return file_alloc_security(file);
 }
 
+static void selinux_file_free_security(struct file *file)
+{
+	long f = atomic_long_read(&selinux_file(file)->enclave_proxy_file);
+	if (f)
+		fput((struct file *)f);
+}
+
 /*
  * Check whether a task has the ioctl permission and cmd
  * operation to an inode.
@@ -3666,19 +3686,23 @@ static int selinux_mmap_file(struct file *file, unsigned long reqprot,
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
@@ -3705,7 +3729,12 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
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
@@ -6740,12 +6769,190 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
 }
 #endif
 
+#ifdef CONFIG_INTEL_SGX
+struct ema__mprot_cb_params {
+	struct file	*encl;
+	size_t		curprot;
+	size_t		reqprot;
+};
+
+static inline struct file *ema__get_source(struct lsm_ema *ema,
+					   struct file *encl)
+{
+	if (!selinux_ema(ema)->sourced) {
+		struct file_security_struct *fsec = selinux_file(encl);
+		return (void *)atomic_long_read(&fsec->enclave_proxy_file);
+	}
+
+	return ema->source;
+}
+
+static int ema__chk_X_cb(struct lsm_ema *ema, void *a)
+{
+	const struct ema__mprot_cb_params *parm = a;
+	struct ema_security_struct *esec = selinux_ema(ema);
+	struct file *src;
+	int rc;
+
+	if (esec->execmod)
+		/* EXECMOD grants X on all cases */
+		return 0;
+
+	src = ema__get_source(ema, parm->encl);
+	if (src) {
+		if (esec->execute)
+			/* Unmodified range requires FILE__EXECUTE */
+			rc = file_has_perm(current_cred(), src,
+					   FILE__EXECUTE);
+		else {
+			/* Modified range requires FILE__EXECMOD */
+			rc = file_has_perm(current_cred(), src,
+					   FILE__EXECUTE | FILE__EXECMOD);
+			/* Cache FILE__EXECMOD to avoid checking it again */
+			esec->execmod = !rc;
+		}
+	} else
+		rc = esec->execute ? 0 : -EACCES;
+	return rc;
+}
+
+static int ema__clr_X_cb(struct lsm_ema *ema, void *a)
+{
+	selinux_ema(ema)->execute = 0;
+	return 0;
+}
+
+static int enclave_mprotect(struct vm_area_struct *vma, size_t prot)
+{
+	struct lsm_ema_map *map;
+	int rc;
+
+	if (!vma->vm_file)
+		return 0;
+
+	map = lsm_get_ema_map(vma->vm_file);
+	if (!map)
+		/* Not an enclave */
+		return 0;
+
+	if ((prot & VM_WRITE) && (prot && VM_EXEC)) {
+		/* EXECMEM is necessary, and will be checked later */
+		rc = -1;
+	} else {
+		struct ema__mprot_cb_params parm;
+
+		parm.encl = vma->vm_file;
+		parm.curprot = vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
+		parm.reqprot = calc_vm_prot_bits(prot, 0);
+
+		rc = lsm_lock_ema(map);
+		if (!rc)
+			return rc;
+
+		/* Checks are necessary only if X is being requested */
+		if (prot & VM_EXEC)
+			rc = lsm_for_each_ema(map, vma->vm_start, vma->vm_end,
+					      ema__chk_X_cb, &parm);
+		/* Clear X if W is granted */
+		if (!rc && (prot & VM_WRITE))
+			rc = lsm_for_each_ema(map, vma->vm_start, vma->vm_end,
+					      ema__clr_X_cb, &parm);
+		lsm_unlock_ema(map);
+	}
+
+	/* EXECMEM is the last resort if X is being requested */
+	if (rc && (prot & VM_EXEC)) {
+		/* No need to update selinux_ema(ema)->execute here because it
+		 * doesn't matter anyway when EXECMEM is present
+		 */
+		rc = avc_has_perm(&selinux_state, current_sid(), current_sid(),
+				  SECCLASS_PROCESS, PROCESS__EXECMEM, NULL);
+	}
+	return rc;
+}
+
+static int selinux_enclave_load(struct file *encl, struct lsm_ema *ema,
+				size_t flags, struct vm_area_struct *src)
+{
+	size_t prot = flags & (PROT_READ | PROT_WRITE | PROT_EXEC);
+	struct ema_security_struct *esec;
+	const struct cred *cred = current_cred();
+	u32 sid = cred_sid(cred);
+	int rc;
+
+	/* check if @prot could be granted */
+	rc = 0;
+	if (src) {
+		/* EADD */
+		if (calc_vm_prot_bits(prot, 0) & ~src->vm_flags)
+			rc = selinux_file_mprotect(src, prot, prot);
+	} else if (prot & PROT_EXEC) {
+		/* EAUG implies RW, so RWX here requires EXECMEM */
+		rc = avc_has_perm(&selinux_state, sid, sid,
+				  SECCLASS_PROCESS, PROCESS__EXECMEM, NULL);
+	}
+	if (rc)
+		return rc;
+
+	/* Initialize ema_security_struct now that @prot has been approved */
+	esec = selinux_ema(ema);
+	/* Is @src backed by a file? */
+	if (src && src->vm_file)
+		esec->sourced = 1;
+	/* Is @src mapped shared, or mapped privately and not modified? */
+	if ((esec->sourced && !src->anon_vma) || (prot & PROT_EXEC))
+		esec->execute = 1;
+	/* If the backing file is NOT kept opened, cache FILE__EXECUTE now! No
+	 * audit log will be generated */
+	if (esec->execute && esec->sourced && !ema->source &&
+	    inode_has_perm_audit(0, cred, file_inode(src->vm_file),
+				 FILE__EXECUTE, NULL))
+		esec->execute = 0;
+	/* If the backing file is NOT kept opened, cache FILE__EXECMOD now! No
+	 * audit log will be generated */
+	if (esec->sourced && !ema->source &&
+	    !inode_has_perm_audit(0, cred, file_inode(src->vm_file),
+				  FILE__EXECUTE | FILE__EXECMOD, NULL))
+		esec->execmod = 1;
+
+	return 0;
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
+	/* FILE__EXECUTE grants enclaves permission to launch */
+	rc = file_has_perm(current_cred(), src->vm_file, FILE__EXECUTE);
+	if (rc)
+		return rc;
+
+	/* SIGSTRUCT file is also used to determine permissions for pages not
+	 * backed by any files */
+	if (atomic_long_cmpxchg(&fsec->enclave_proxy_file, 0,
+				(long)src->vm_file))
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
 	.lbs_inode = sizeof(struct inode_security_struct),
 	.lbs_ipc = sizeof(struct ipc_security_struct),
 	.lbs_msg_msg = sizeof(struct msg_security_struct),
+	.lbs_ema_data = sizeof(struct ema_security_struct) *
+			IS_ENABLED(CONFIG_INTEL_SGX),
 };
 
 static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
@@ -6822,6 +7029,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
+	LSM_HOOK_INIT(file_free_security, selinux_file_free_security),
 	LSM_HOOK_INIT(file_ioctl, selinux_file_ioctl),
 	LSM_HOOK_INIT(mmap_file, selinux_mmap_file),
 	LSM_HOOK_INIT(mmap_addr, selinux_mmap_addr),
@@ -6982,6 +7190,11 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
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
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 91c5395dd20c..e58324997e8b 100644
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
+	atomic_long_t enclave_proxy_file;
 };
 
 struct superblock_security_struct {
@@ -154,6 +156,23 @@ struct bpf_security_struct {
 	u32 sid;  /*SID of bpf obj creater*/
 };
 
+struct ema_security_struct {
+	/* (@execute && FILE__EXECUTE) grants X.
+	 * FILE__EXECUTE is determined at mprotect() but if backing file is NOT
+	 * kept open, FILE__EXECUTE will be determined at enclave_load() hook
+	 */
+	int execute:1;
+	/* (@execmod || FILE__EXECMOD) grants W->X.
+	 * FILE__EXECMOD is determined at mprotect() but if backing file is NOT
+	 * kept open, FILE__EXECMOD will be determined at enclave_load() hook
+	 */
+	int execmod:1;
+	/* @sourced is set if an enclave range is loaded (EADD'ed) from a file,
+	 * cleared otherwise (i.e. EAUG'ed or EADD'ed from anonymous memory
+	 */
+	int sourced:1;
+};
+
 extern struct lsm_blob_sizes selinux_blob_sizes;
 static inline struct task_security_struct *selinux_cred(const struct cred *cred)
 {
@@ -185,4 +204,9 @@ static inline struct ipc_security_struct *selinux_ipc(
 	return ipc->security + selinux_blob_sizes.lbs_ipc;
 }
 
+static inline struct ema_security_struct *selinux_ema(struct lsm_ema *ema)
+{
+	return (void *)lsm_ema_data(ema, selinux_blob_sizes);
+}
+
 #endif /* _SELINUX_OBJSEC_H_ */
-- 
2.17.1

