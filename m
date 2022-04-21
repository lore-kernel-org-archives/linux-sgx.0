Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61937C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Apr 2022 11:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbiDULHR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Apr 2022 07:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244846AbiDULHP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Apr 2022 07:07:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC522E69B
        for <linux-sgx@vger.kernel.org>; Thu, 21 Apr 2022 04:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650539064; x=1682075064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=jiVCWZgSM1dkoNH//ZvVQSMpC4RxptWTF3CpbPCxpOU=;
  b=aNMXKGLlrx+wxyTR4FTcbzYQsVnucpZyWcmdVaL8Lr+UDkzJJClY3DS7
   EWzFSednHdVzRHoYIuVxtHqyMOaIQlITWXPWn+vq5Kt0RZfGce/ltkcCQ
   pFZwjbIz5W/dLeB65unsDLpbwKe1gQYNtvNsuvLsoqiSWphVWMyPALp/F
   LRvx8Gv2hyXZbaLQ6SB+P7y+chQcQAOeV5q5fLUVIBXhmt9N+JCMyEIkC
   7UAtGvMFnlAGAobLxjysjbAZnYGTY10pdYA02n7iaUKO6IQLtZA3mg1gy
   Yyoh4TBVr8/LXJGF74+o6dtNy0FfkRoOzCcbKfX9hdOwW4Mmw494/sEoL
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244893336"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="244893336"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:04:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="703039108"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 21 Apr 2022 04:04:18 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@intel.com, yang.zhong@intel.com
Subject: [PATCH v4 1/9] x86/sgx: Introduce mechanism to prevent new initializations of EPC pages
Date:   Thu, 21 Apr 2022 19:03:18 +0800
Message-Id: <20220421110326.856-2-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220421110326.856-1-cathy.zhang@intel.com>
References: <20220421110326.856-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

== Background ==

EUPDATESVN is a new SGX instruction which allows enclave attestation
to include information about updated microcode without a reboot.

The SGX hardware maintains metadata for each enclave page to help
enforce its security guarantees. This includes things like a record
of the enclave to which the page belongs and the type of the page:
SGX metadata like "VA" or "SECS" pages, or regular enclave pages
like those that store user data.

Before an EUPDATESVN operation can be successful, all SGX memory (aka.
EPC) must be marked as "unused" in the SGX hardware metadata (aka,
EPCM). The SGX microcode now maintains a reference count of pages
which are unused to aid in determining when all pages reach the
"unused" state.

Both bare-metal and KVM guest EPC must be made unused. To increase
the chance of a successful EUPDATESVN, the kernel prevents existing
enclaves from creating new, valid pages and prevents new enclave
creation (creating an enclave involves initializing a "SECS" page).

The entire EUPDATESVN process is very slow since it potentially
affects gigabytes of enclave memory. It can potentially take seconds
or minutes to complete. Userspace may encounter -EBUSY errors during
the update and is expected to retry.

== Patch contents ==

Introduce mechanism to prevent new initializations of EPC pages.

Use a flag to indicate when SGX EPC pages are "locked", which means
it's not allowed to allocate new EPC page for use. Check it in all
paths that can initialize an EPC page. Use SRCU to ensure that the
flag is visible across the system before proceeding with an update.

Add checks to all sites that call SGX instructions that can transition
pages from unused to initialized to ensure that the SRCU lock is held.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>

---
Changes since v3:
 - Rename lable "out" as "err" in sgx_ioc_enclave_create, update error
   branch accordingly. (Jarrko Sakkinen)

Changes since v2:
 - Move out the SGX2 related change to remove the dependency.
  (Jarkko Sakkinen, Reinette Chatre).
---
 arch/x86/kernel/cpu/sgx/encls.h |  8 ++++++
 arch/x86/kernel/cpu/sgx/sgx.h   |  3 +++
 arch/x86/kernel/cpu/sgx/encl.c  | 19 +++++++++++++++
 arch/x86/kernel/cpu/sgx/ioctl.c | 43 +++++++++++++++++++++++++++------
 arch/x86/kernel/cpu/sgx/main.c  | 37 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/virt.c  | 20 +++++++++++++++
 6 files changed, 123 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index fa04a73daf9c..60321c5f5718 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -138,6 +138,8 @@ static inline bool encls_failed(int ret)
 
 static inline int __ecreate(struct sgx_pageinfo *pginfo, void *secs)
 {
+	lockdep_assert_held(&sgx_lock_epc_srcu);
+
 	return __encls_2(ECREATE, pginfo, secs);
 }
 
@@ -148,6 +150,8 @@ static inline int __eextend(void *secs, void *addr)
 
 static inline int __eadd(struct sgx_pageinfo *pginfo, void *addr)
 {
+	lockdep_assert_held(&sgx_lock_epc_srcu);
+
 	return __encls_2(EADD, pginfo, addr);
 }
 
@@ -179,6 +183,8 @@ static inline int __etrack(void *addr)
 static inline int __eldu(struct sgx_pageinfo *pginfo, void *addr,
 			 void *va)
 {
+	lockdep_assert_held(&sgx_lock_epc_srcu);
+
 	return __encls_ret_3(ELDU, pginfo, addr, va);
 }
 
@@ -191,6 +197,8 @@ static inline int __epa(void *addr)
 {
 	unsigned long rbx = SGX_PAGE_TYPE_VA;
 
+	lockdep_assert_held(&sgx_lock_epc_srcu);
+
 	return __encls_2(EPA, rbx, addr);
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index b30cee4de903..d7a1490d90bb 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -103,4 +103,7 @@ static inline int __init sgx_vepc_init(void)
 
 void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
 
+extern struct srcu_struct sgx_lock_epc_srcu;
+bool sgx_epc_is_locked(void);
+
 #endif /* _X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 02ff9ac83985..68c8d65a8dee 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -142,6 +142,7 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
 	unsigned long phys_addr;
 	struct sgx_encl *encl;
 	vm_fault_t ret;
+	int srcu_idx;
 
 	encl = vma->vm_private_data;
 
@@ -153,11 +154,18 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
 	if (unlikely(!encl))
 		return VM_FAULT_SIGBUS;
 
+	srcu_idx = srcu_read_lock(&sgx_lock_epc_srcu);
+	if (sgx_epc_is_locked()) {
+		srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
+		return VM_FAULT_SIGBUS;
+	}
+
 	mutex_lock(&encl->lock);
 
 	entry = sgx_encl_load_page(encl, addr, vma->vm_flags);
 	if (IS_ERR(entry)) {
 		mutex_unlock(&encl->lock);
+		srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
 
 		if (PTR_ERR(entry) == -EBUSY)
 			return VM_FAULT_NOPAGE;
@@ -170,12 +178,14 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
 	ret = vmf_insert_pfn(vma, addr, PFN_DOWN(phys_addr));
 	if (ret != VM_FAULT_NOPAGE) {
 		mutex_unlock(&encl->lock);
+		srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
 
 		return VM_FAULT_SIGBUS;
 	}
 
 	sgx_encl_test_and_clear_young(vma->vm_mm, entry);
 	mutex_unlock(&encl->lock);
+	srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
 
 	return VM_FAULT_NOPAGE;
 }
@@ -323,6 +333,7 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
 	struct sgx_encl_page *entry = NULL;
 	char data[sizeof(unsigned long)];
 	unsigned long align;
+	int srcu_idx;
 	int offset;
 	int cnt;
 	int ret = 0;
@@ -339,8 +350,15 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
 		return -EFAULT;
 
 	for (i = 0; i < len; i += cnt) {
+		srcu_idx = srcu_read_lock(&sgx_lock_epc_srcu);
+		if (sgx_epc_is_locked()) {
+			ret = -EBUSY;
+			goto out;
+		}
+
 		entry = sgx_encl_reserve_page(encl, (addr + i) & PAGE_MASK,
 					      vma->vm_flags);
+
 		if (IS_ERR(entry)) {
 			ret = PTR_ERR(entry);
 			break;
@@ -366,6 +384,7 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
 
 out:
 		mutex_unlock(&encl->lock);
+		srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
 
 		if (ret)
 			break;
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index b3c2e8d58142..a4df72f715d7 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -147,24 +147,42 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
 {
 	struct sgx_enclave_create create_arg;
+	int srcu_idx;
 	void *secs;
 	int ret;
 
-	if (test_bit(SGX_ENCL_CREATED, &encl->flags))
-		return -EINVAL;
+	if (test_bit(SGX_ENCL_CREATED, &encl->flags)) {
+		ret = -EINVAL;
+		goto err;
+	}
 
-	if (copy_from_user(&create_arg, arg, sizeof(create_arg)))
-		return -EFAULT;
+	if (copy_from_user(&create_arg, arg, sizeof(create_arg))) {
+		ret = -EFAULT;
+		goto err;
+	}
 
 	secs = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!secs)
-		return -ENOMEM;
+	if (!secs) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	if (copy_from_user(secs, (void __user *)create_arg.src, PAGE_SIZE))
 		ret = -EFAULT;
-	else
+	else {
+		srcu_idx = srcu_read_lock(&sgx_lock_epc_srcu);
+		if (sgx_epc_is_locked()) {
+			srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
+			ret = -EBUSY;
+			goto err;
+		}
+
 		ret = sgx_encl_create(encl, secs);
 
+		srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
+	}
+
+err:
 	kfree(secs);
 	return ret;
 }
@@ -418,6 +436,7 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	struct sgx_enclave_add_pages add_arg;
 	struct sgx_secinfo secinfo;
 	unsigned long c;
+	int srcu_idx;
 	int ret;
 
 	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
@@ -455,8 +474,18 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 		if (need_resched())
 			cond_resched();
 
+		srcu_idx = srcu_read_lock(&sgx_lock_epc_srcu);
+		if (sgx_epc_is_locked()) {
+			ret = -EBUSY;
+			srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
+			break;
+		}
+
 		ret = sgx_encl_add_page(encl, add_arg.src + c, add_arg.offset + c,
 					&secinfo, add_arg.flags);
+
+		srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
+
 		if (ret)
 			break;
 	}
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b3aba1e1274c..10360f06c0df 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -23,6 +23,17 @@ static int sgx_nr_epc_sections;
 static struct task_struct *ksgxd_tsk;
 static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
 static DEFINE_XARRAY(sgx_epc_address_space);
+/*
+ * The flag sgx_epc_locked prevents any new SGX flows that
+ * may attempt to allocate a new EPC page.
+ */
+static bool __rcu sgx_epc_locked;
+/*
+ * By synchronizing around sgx_epc_locked SRCU ensures that any executing
+ * SGX flows have completed before proceeding with an SVN update. New SGX flows
+ * will be prevented from starting during an SVN update.
+ */
+DEFINE_SRCU(sgx_lock_epc_srcu);
 
 /*
  * These variables are part of the state of the reclaimer, and must be accessed
@@ -407,6 +418,8 @@ static bool sgx_should_reclaim(unsigned long watermark)
 
 static int ksgxd(void *p)
 {
+	int srcu_idx;
+
 	set_freezable();
 
 	/*
@@ -427,9 +440,15 @@ static int ksgxd(void *p)
 				     kthread_should_stop() ||
 				     sgx_should_reclaim(SGX_NR_HIGH_PAGES));
 
+		srcu_idx = srcu_read_lock(&sgx_lock_epc_srcu);
+		if (sgx_epc_is_locked())
+			goto maybe_resched;
+
 		if (sgx_should_reclaim(SGX_NR_HIGH_PAGES))
 			sgx_reclaim_pages();
 
+maybe_resched:
+		srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
 		cond_resched();
 	}
 
@@ -972,3 +991,21 @@ static int __init sgx_init(void)
 }
 
 device_initcall(sgx_init);
+
+static void sgx_lock_epc(void)
+{
+	sgx_epc_locked = true;
+	synchronize_srcu(&sgx_lock_epc_srcu);
+}
+
+static void sgx_unlock_epc(void)
+{
+	sgx_epc_locked = false;
+	synchronize_srcu(&sgx_lock_epc_srcu);
+}
+
+bool sgx_epc_is_locked(void)
+{
+	lockdep_assert_held(&sgx_lock_epc_srcu);
+	return sgx_epc_locked;
+}
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 6a77a14eee38..e953816d7c8b 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -75,10 +75,21 @@ static vm_fault_t sgx_vepc_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct sgx_vepc *vepc = vma->vm_private_data;
+	int srcu_idx;
 	int ret;
 
 	mutex_lock(&vepc->lock);
+	srcu_idx = srcu_read_lock(&sgx_lock_epc_srcu);
+
+	if (sgx_epc_is_locked()) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	ret = __sgx_vepc_fault(vepc, vma, vmf->address);
+
+out_unlock:
+	srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
 	mutex_unlock(&vepc->lock);
 
 	if (!ret)
@@ -331,6 +342,7 @@ int __init sgx_vepc_init(void)
 int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
 		     int *trapnr)
 {
+	int srcu_idx;
 	int ret;
 
 	/*
@@ -347,6 +359,12 @@ int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
 	if (WARN_ON_ONCE(!access_ok(secs, PAGE_SIZE)))
 		return -EINVAL;
 
+	srcu_idx = srcu_read_lock(&sgx_lock_epc_srcu);
+	if (sgx_epc_is_locked()) {
+		srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
+		return -EBUSY;
+	}
+
 	__uaccess_begin();
 	ret = __ecreate(pageinfo, (void *)secs);
 	__uaccess_end();
@@ -356,6 +374,8 @@ int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
 		return -EFAULT;
 	}
 
+	srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
+
 	/* ECREATE doesn't return an error code, it faults or succeeds. */
 	WARN_ON_ONCE(ret);
 	return 0;
-- 
2.17.1

