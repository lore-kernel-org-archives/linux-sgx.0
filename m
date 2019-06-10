Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33BEC468C4
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 07:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B343A206E0
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 07:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbfFJHDO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 03:03:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:3981 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387851AbfFJHDM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 03:03:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 00:03:12 -0700
X-ExtLoop1: 1
Received: from bxing-mobl.amr.corp.intel.com (HELO ubt18m.amr.corp.intel.com) ([10.255.90.159])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jun 2019 00:03:10 -0700
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
Subject: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in SELinux
Date:   Mon, 10 Jun 2019 00:03:05 -0700
Message-Id: <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
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

In this patch, SELinux maintains two bits per enclave page, namely SGX__EXECUTE
and SGX__EXECMOD.

SGX__EXECUTE is set initially (by selinux_enclave_load) for every enclave page
that was loaded from a potentially executable source page. SGX__EXECMOD is set
for every page that was loaded from a file that has FILE__EXECMOD.

At runtime, on every protection change (resulted in a call to
selinux_file_mprotect), SGX__EXECUTE is cleared for a page if VM_WRITE is
requested, unless SGX__EXECMOD is set.

To track enclave page protection changes, SELinux has been changed in four
different places.

Firstly, storage is required for storing per page SGX__EXECUTE and SGX__EXECMOD
bits. Given every enclave instance is uniquely tied to an open file (i.e.
struct file), the storage is allocated by extending `file_security_struct`.
More precisely, a new field `esec` has been added, initially zero, to point to
the data structure for tracking per page protection. `esec` will be
allocated/initialized at the first invocation of selinux_enclave_load().

Then, selinux_enclave_load() initializes those 2 bits for every new enclave as
described above. One more detail worth noting, is that selinux_enclave_load()
sets SGX__EXECUTE/SGX__EXECMOD for EAUG'ed pages (for upcoming SGX2) only if
the calling process has FILE__EXECMOD on the sigstruct file.

Afterwards, every change on protection will go through selinux_file_mprotect()
so will be noted. Please note that user space could munmap() then mmap() to
work around mprotect(), but that "leak" could be "plugged" by SGX subsystem
calling security_file_mprotect() explicitly whenever new mappings are created.

Finally, the storage for page protection tracking must be freed when the
associated file is closed. Hence a new selinux_file_free_security() has been
added.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 security/selinux/Makefile            |   2 +
 security/selinux/hooks.c             |  77 ++++++-
 security/selinux/include/intel_sgx.h |  18 ++
 security/selinux/include/objsec.h    |   3 +
 security/selinux/intel_sgx.c         | 292 +++++++++++++++++++++++++++
 5 files changed, 391 insertions(+), 1 deletion(-)
 create mode 100644 security/selinux/include/intel_sgx.h
 create mode 100644 security/selinux/intel_sgx.c

diff --git a/security/selinux/Makefile b/security/selinux/Makefile
index ccf950409384..58a05a9639e0 100644
--- a/security/selinux/Makefile
+++ b/security/selinux/Makefile
@@ -14,6 +14,8 @@ selinux-$(CONFIG_SECURITY_NETWORK_XFRM) += xfrm.o
 
 selinux-$(CONFIG_NETLABEL) += netlabel.o
 
+selinux-$(CONFIG_INTEL_SGX) += intel_sgx.o
+
 ccflags-y := -I$(srctree)/security/selinux -I$(srctree)/security/selinux/include
 
 $(addprefix $(obj)/,$(selinux-y)): $(obj)/flask.h
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3ec702cf46ca..17f855871a41 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -103,6 +103,7 @@
 #include "netlabel.h"
 #include "audit.h"
 #include "avc_ss.h"
+#include "intel_sgx.h"
 
 struct selinux_state selinux_state;
 
@@ -3485,6 +3486,11 @@ static int selinux_file_alloc_security(struct file *file)
 	return file_alloc_security(file);
 }
 
+static void selinux_file_free_security(struct file *file)
+{
+	sgxsec_enclave_free(file);
+}
+
 /*
  * Check whether a task has the ioctl permission and cmd
  * operation to an inode.
@@ -3656,6 +3662,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 				 unsigned long reqprot,
 				 unsigned long prot)
 {
+	int rc;
 	const struct cred *cred = current_cred();
 	u32 sid = cred_sid(cred);
 
@@ -3664,7 +3671,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 
 	if (default_noexec &&
 	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
-		int rc = 0;
+		rc = 0;
 		if (vma->vm_start >= vma->vm_mm->start_brk &&
 		    vma->vm_end <= vma->vm_mm->brk) {
 			rc = avc_has_perm(&selinux_state,
@@ -3691,6 +3698,12 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 			return rc;
 	}
 
+#ifdef CONFIG_INTEL_SGX
+	rc = sgxsec_mprotect(vma, prot);
+	if (rc <= 0)
+		return rc;
+#endif
+
 	return file_map_prot_check(vma->vm_file, prot, vma->vm_flags&VM_SHARED);
 }
 
@@ -6726,6 +6739,62 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
 }
 #endif
 
+#ifdef CONFIG_INTEL_SGX
+
+static int selinux_enclave_load(struct file *encl, unsigned long addr,
+				unsigned long size, unsigned long prot,
+				struct vm_area_struct *source)
+{
+	if (source) {
+		/**
+		 * Adding page from source => EADD request
+		 */
+		int rc = selinux_file_mprotect(source, prot, prot);
+		if (rc)
+			return rc;
+
+		if (!(prot & VM_EXEC) &&
+		    selinux_file_mprotect(source, VM_EXEC, VM_EXEC))
+			prot = 0;
+		else {
+			prot = SGX__EXECUTE;
+			if (source->vm_file &&
+			    !file_has_perm(current_cred(), source->vm_file,
+					   FILE__EXECMOD))
+				prot |= SGX__EXECMOD;
+		}
+		return sgxsec_eadd(encl, addr, size, prot);
+	} else {
+		/**
+		  * Adding page from NULL => EAUG request
+		  */
+		return sgxsec_eaug(encl, addr, size, prot);
+	}
+}
+
+static int selinux_enclave_init(struct file *encl,
+				const struct sgx_sigstruct *sigstruct,
+				struct vm_area_struct *vma)
+{
+	int rc = 0;
+
+	if (!vma)
+		rc = -EINVAL;
+
+	if (!rc && !(vma->vm_flags & VM_EXEC))
+		rc = selinux_file_mprotect(vma, VM_EXEC, VM_EXEC);
+
+	if (!rc) {
+		if (vma->vm_file)
+			rc = file_has_perm(current_cred(), vma->vm_file,
+					   FILE__EXECMOD);
+		rc = sgxsec_einit(encl, sigstruct, !rc);
+	}
+	return rc;
+}
+
+#endif
+
 struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
 	.lbs_cred = sizeof(struct task_security_struct),
 	.lbs_file = sizeof(struct file_security_struct),
@@ -6808,6 +6877,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
+	LSM_HOOK_INIT(file_free_security, selinux_file_free_security),
 	LSM_HOOK_INIT(file_ioctl, selinux_file_ioctl),
 	LSM_HOOK_INIT(mmap_file, selinux_mmap_file),
 	LSM_HOOK_INIT(mmap_addr, selinux_mmap_addr),
@@ -6968,6 +7038,11 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
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
diff --git a/security/selinux/include/intel_sgx.h b/security/selinux/include/intel_sgx.h
new file mode 100644
index 000000000000..8f9c6c734921
--- /dev/null
+++ b/security/selinux/include/intel_sgx.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#ifndef _SELINUX_SGXSEC_H_
+#define _SELINUX_SGXSEC_H_
+
+#include <linux/lsm_hooks.h>
+
+#define SGX__EXECUTE	1
+#define SGX__EXECMOD	2
+
+void sgxsec_enclave_free(struct file *);
+int sgxsec_mprotect(struct vm_area_struct *, size_t);
+int sgxsec_eadd(struct file *, size_t, size_t, size_t);
+int sgxsec_eaug(struct file *, size_t, size_t, size_t);
+int sgxsec_einit(struct file *, const struct sgx_sigstruct *, int);
+
+#endif
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 231262d8eac9..0fb4da7e3a8a 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -71,6 +71,9 @@ struct file_security_struct {
 	u32 fown_sid;		/* SID of file owner (for SIGIO) */
 	u32 isid;		/* SID of inode at the time of file open */
 	u32 pseqno;		/* Policy seqno at the time of file open */
+#ifdef CONFIG_INTEL_SGX
+	atomic_long_t esec;
+#endif
 };
 
 struct superblock_security_struct {
diff --git a/security/selinux/intel_sgx.c b/security/selinux/intel_sgx.c
new file mode 100644
index 000000000000..37dacf5c295f
--- /dev/null
+++ b/security/selinux/intel_sgx.c
@@ -0,0 +1,292 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include "objsec.h"
+#include "intel_sgx.h"
+
+struct region {
+	struct list_head	link;
+	size_t			start;
+	size_t			end;
+	size_t			data;
+};
+
+static inline struct region *region_new(void)
+{
+	struct region *n = kzalloc(sizeof(struct region), GFP_KERNEL);
+	if (n)
+		INIT_LIST_HEAD(&n->link);
+	return n;
+}
+
+static inline void region_free(struct region *r)
+{
+	list_del(&r->link);
+	kfree(r);
+}
+
+static struct list_head *
+region_apply_to_range(struct list_head *rgs,
+		      size_t start, size_t end,
+		      struct list_head *(*cb)(struct region *,
+					      size_t, size_t, size_t),
+		      size_t arg)
+{
+	struct region *r, *n;
+
+	list_for_each_entry(r, rgs, link)
+		if (start < r-> end)
+			break;
+
+	if (&r->link == rgs || end <= r->start)
+		return rgs;
+
+	do {
+		struct list_head *ret;
+		n = list_next_entry(r, link);
+		ret = (*cb)(r, start, end, arg);
+		if (ret)
+			return ret;
+		r = n;
+	} while (&r->link != rgs && r->start < end);
+	return &r->link;
+}
+
+static struct list_head *
+region_clear_cb(struct region *r, size_t start, size_t end, size_t arg)
+{
+	if (end < r->end) {
+		if (start > r->start) {
+			struct region *n = region_new();
+			if (unlikely(!n))
+				return ERR_PTR(-ENOMEM);
+
+			n->start = r->start;
+			n->end = start;
+			n->data = r->data;
+			list_add_tail(&n->link, &r->link);
+		}
+		r->start = end;
+		return &r->link;
+	}
+
+	if (start > r->start)
+		r->end = start;
+	else
+		region_free(r);
+	return NULL;
+}
+
+static inline struct list_head *
+region_clear_range(struct list_head *rgs, size_t start, size_t end)
+{
+	return region_apply_to_range(rgs, start, end, region_clear_cb, 0);
+}
+
+static struct list_head *
+region_add_range(struct list_head *rgs, size_t start, size_t end, size_t data)
+{
+	struct region *r, *n;
+
+	n = list_entry(region_clear_range(rgs, start, end), typeof(*n), link);
+	if (unlikely(IS_ERR_VALUE(&n->link)))
+		return &n->link;
+
+	if (&n->link != rgs && end == n->start && data == n->data) {
+		n->start = start;
+		r = n;
+	} else {
+		r = region_new();
+		if (unlikely(!r))
+			return ERR_PTR(-ENOMEM);
+
+		r->start = start;
+		r->end = end;
+		r->data = data;
+		list_add_tail(&r->link, &n->link);
+	}
+
+	n = list_prev_entry(r, link);
+	if (&n->link != rgs && start == n->end && data == n->data) {
+		r->start = n->start;
+		region_free(n);
+	}
+
+	return &r->link;
+}
+
+static inline int
+enclave_add_pages(struct list_head *rgs, size_t start, size_t end, size_t flags)
+{
+	void *p = region_add_range(rgs, start, end, flags);
+	return PTR_ERR_OR_ZERO(p);
+}
+
+static inline int enclave_prot_allowed(size_t prot, size_t flags)
+{
+	return !(prot & VM_EXEC) || (flags & SGX__EXECUTE);
+}
+
+static struct list_head *
+enclave_prot_check_cb(struct region *r, size_t start, size_t end, size_t prot)
+{
+	if (!enclave_prot_allowed(prot, r->data))
+		return ERR_PTR(-EACCES);
+	return NULL;
+}
+
+static struct list_head *
+enclave_prot_set_cb(struct region *r, size_t start, size_t end, size_t prot)
+{
+	BUG_ON(!enclave_prot_allowed(prot, r->data));
+
+	if (!(prot & VM_WRITE) ||
+	    (r->data & SGX__EXECMOD) ||
+	    !(r->data & SGX__EXECUTE))
+		return NULL;
+
+	if (end < r->end) {
+		struct region *n = region_new();
+		if (unlikely(!n))
+			return ERR_PTR(-ENOMEM);
+
+		n->start = end;
+		n->end = r->end;
+		n->data = r->data;
+		r->end = end;
+		list_add(&n->link, &r->link);
+	}
+
+	if (start > r->start) {
+		struct region *n = region_new();
+		if (unlikely(!n))
+			return ERR_PTR(-ENOMEM);
+
+		n->start = r->start;
+		n->end = start;
+		n->data = r->data;
+		r->start = start;
+		list_add_tail(&n->link, &r->link);
+	}
+
+	r->data &= ~SGX__EXECUTE;
+	return NULL;
+}
+
+static inline int
+enclave_mprotect(struct list_head *rgs, size_t start, size_t end, size_t prot)
+{
+	void *ret;
+
+	ret = region_apply_to_range(rgs, start, end,
+				    enclave_prot_check_cb, prot);
+	if (!IS_ERR_VALUE(ret) && (prot & VM_WRITE))
+		ret = region_apply_to_range(rgs, start, end,
+					    enclave_prot_set_cb, prot);
+	return PTR_ERR_OR_ZERO(ret);
+}
+
+struct enclave_sec {
+	struct rw_semaphore	sem;
+	struct list_head	regions;
+	size_t			eaug_perm;
+};
+
+static inline struct enclave_sec *__esec(struct file_security_struct *fsec)
+{
+	return (struct enclave_sec *)atomic_long_read(&fsec->esec);
+}
+
+static struct enclave_sec *encl_esec(struct file *encl)
+{
+	struct file_security_struct *fsec = selinux_file(encl);
+	struct enclave_sec *esec = __esec(fsec);
+
+	if (unlikely(!esec)) {
+		long n;
+
+		esec = kzalloc(sizeof(*esec), GFP_KERNEL);
+		if (!esec)
+			return NULL;
+
+		init_rwsem(&esec->sem);
+		INIT_LIST_HEAD(&esec->regions);
+
+		n = atomic_long_cmpxchg(&fsec->esec, 0, (long)esec);
+		if (n) {
+			kfree(esec);
+			esec = (typeof(esec))n;
+		}
+	}
+
+	return esec;
+}
+
+void sgxsec_enclave_free(struct file *encl)
+{
+	struct enclave_sec *esec = __esec(selinux_file(encl));
+
+	if (esec) {
+		struct region *r, *n;
+
+		BUG_ON(rwsem_is_locked(&esec->sem));
+
+		list_for_each_entry_safe(r, n, &esec->regions, link)
+			region_free(r);
+
+		kfree(esec);
+	}
+}
+
+int sgxsec_mprotect(struct vm_area_struct *vma, size_t prot)
+{
+	struct enclave_sec *esec;
+	int rc;
+
+	if (!vma->vm_file || !(esec = __esec(selinux_file(vma->vm_file)))) {
+		/* Positive return value indicates non-enclave VMA */
+		return 1;
+	}
+
+	down_read(&esec->sem);
+	rc = enclave_mprotect(&esec->regions, vma->vm_start, vma->vm_end, prot);
+	up_read(&esec->sem);
+	return rc;
+}
+
+int sgxsec_eadd(struct file *encl, size_t start, size_t size, size_t perm)
+{
+	struct enclave_sec *esec = encl_esec(encl);
+	int rc;
+
+	if (down_write_killable(&esec->sem))
+		return -EINTR;
+	rc = enclave_add_pages(&esec->regions, start, start + size, perm);
+	up_write(&esec->sem);
+	return rc;
+}
+
+int sgxsec_eaug(struct file *encl, size_t start, size_t size, size_t prot)
+{
+	struct enclave_sec *esec = encl_esec(encl);
+	int rc = -EPERM;
+
+	if (down_write_killable(&esec->sem))
+		return -EINTR;
+	if (enclave_prot_allowed(prot, esec->eaug_perm))
+		rc = enclave_add_pages(&esec->regions, start, start + size,
+				       esec->eaug_perm);
+	up_write(&esec->sem);
+	return rc;
+}
+
+int sgxsec_einit(struct file *encl, const struct sgx_sigstruct *sigstruct, int execmod)
+{
+	struct enclave_sec *esec = encl_esec(encl);
+
+	if (down_write_killable(&esec->sem))
+		return -EINTR;
+	esec->eaug_perm = execmod ? SGX__EXECUTE | SGX__EXECMOD : 0;
+	up_write(&esec->sem);
+	return 0;
+}
-- 
2.17.1

