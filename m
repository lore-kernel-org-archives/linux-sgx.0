Return-Path: <SRS0=httf=UQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65682C31E5F
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 390B820833
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfFQWYu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:24:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:29311 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbfFQWYt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Jun 2019 18:24:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:24:48 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 17 Jun 2019 15:24:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: [RFC PATCH v3 12/12] LSM: x86/sgx: Show line of sight to LSM support SGX2's EAUG
Date:   Mon, 17 Jun 2019 15:24:38 -0700
Message-Id: <20190617222438.2080-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617222438.2080-1-sean.j.christopherson@intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Wire up a theoretical EAUG flag to show that the proposed LSM model is
extensible to SGX2, i.e. that SGX can communicate to LSMs that an EAUG'd
page is being mapped executable, as opposed to having to require
userspace to state that an EAUG'd page *may* be mapped executable in the
future.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/main.c | 10 +++++---
 arch/x86/kernel/cpu/sgx/encl.c        | 33 ++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/encl.h        |  2 ++
 include/linux/lsm_hooks.h             |  2 +-
 include/linux/security.h              |  4 ++--
 security/security.c                   |  4 ++--
 security/selinux/hooks.c              |  4 +++-
 7 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index 816f14194d75..d471f965ede9 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -85,7 +85,8 @@ static int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
  * page is considered to have no RWX permissions, i.e. is inaccessible.
  */
 static unsigned long sgx_allowed_rwx(struct sgx_encl *encl,
-				     struct vm_area_struct *vma)
+				     struct vm_area_struct *vma,
+				     bool *eaug)
 {
 	unsigned long allowed_rwx = VM_READ | VM_WRITE | VM_EXEC;
 	unsigned long idx, idx_start, idx_end;
@@ -109,6 +110,8 @@ static unsigned long sgx_allowed_rwx(struct sgx_encl *encl,
 			allowed_rwx = 0;
 		else
 			allowed_rwx &= page->vm_prot_bits;
+		if (page->vm_prot_bits & SGX_VM_EAUG)
+			*eaug = true;
 		if (!allowed_rwx)
 			break;
 	}
@@ -120,16 +123,17 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct sgx_encl *encl = file->private_data;
 	unsigned long allowed_rwx, prot;
+	bool eaug = false;
 	int ret;
 
-	allowed_rwx = sgx_allowed_rwx(encl, vma);
+	allowed_rwx = sgx_allowed_rwx(encl, vma, &eaug);
 	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC) & ~allowed_rwx)
 		return -EACCES;
 
 	prot = _calc_vm_trans(vma->vm_flags, VM_READ, PROT_READ) |
 	       _calc_vm_trans(vma->vm_flags, VM_WRITE, PROT_WRITE) |
 	       _calc_vm_trans(vma->vm_flags, VM_EXEC, PROT_EXEC);
-	ret = security_enclave_map(prot);
+	ret = security_enclave_map(prot, eaug);
 	if (ret)
 		return ret;
 
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index e061360f253c..8930d02afdc7 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -346,10 +346,41 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
 }
 
 #ifdef CONFIG_SECURITY
+static bool is_eaug_range(struct sgx_encl *encl, unsigned long start,
+			  unsigned long end)
+{
+	unsigned long idx, idx_start, idx_end;
+	struct sgx_encl_page *page;
+
+	/* Enclave is dead or inaccessible. */
+	if (!encl)
+		return false;
+
+	idx_start = PFN_DOWN(start);
+	idx_end = PFN_DOWN(end - 1);
+
+	for (idx = idx_start; idx <= idx_end; ++idx) {
+		/*
+		 * No need to take encl->lock, vm_prot_bits is set prior to
+		 * insertion and never changes, and racing with adding pages is
+		 * a userspace bug.
+		 */
+		rcu_read_lock();
+		page = radix_tree_lookup(&encl->page_tree, idx);
+		rcu_read_unlock();
+
+		/* Non-existent page can only be PROT_NONE, bail early. */
+		if (!page || page->vm_prot_bits & SGX_VM_EAUG)
+			return true;
+	}
+
+	return false;
+}
 static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
 			    unsigned long end, unsigned long prot)
 {
-	return security_enclave_map(prot);
+	return security_enclave_map(prot,
+		is_eaug_range(vma->vm_private_data, start, end));
 }
 #endif
 
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 5cb0f2653d4c..1976866c096a 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -39,6 +39,8 @@ enum sgx_encl_page_desc {
 #define SGX_ENCL_PAGE_VA_OFFSET(encl_page) \
 	((encl_page)->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK)
 
+#define SGX_VM_EAUG	BIT(3)
+
 struct sgx_encl_page {
 	unsigned long desc;
 	unsigned long vm_prot_bits;
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 3bc92c65f287..d7da732cf56e 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1819,7 +1819,7 @@ union security_list_options {
 #endif /* CONFIG_BPF_SYSCALL */
 
 #ifdef CONFIG_INTEL_SGX
-	int (*enclave_map)(unsigned long prot);
+	int (*enclave_map)(unsigned long prot, bool eaug);
 	int (*enclave_load)(struct vm_area_struct *vma, unsigned long prot,
 			    bool measured);
 #endif /* CONFIG_INTEL_SGX */
diff --git a/include/linux/security.h b/include/linux/security.h
index 572ddfc53039..c55e14d776c8 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1831,11 +1831,11 @@ static inline void security_bpf_prog_free(struct bpf_prog_aux *aux)
 
 #ifdef CONFIG_INTEL_SGX
 #ifdef CONFIG_SECURITY
-int security_enclave_map(unsigned long prot);
+int security_enclave_map(unsigned long prot, bool eaug);
 int security_enclave_load(struct vm_area_struct *vma, unsigned long prot,
 			  bool measured);
 #else
-static inline int security_enclave_map(unsigned long prot)
+static inline int security_enclave_map(unsigned long prot, bool eaug)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 00f483beb1cc..f276f05341f2 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2361,9 +2361,9 @@ void security_bpf_prog_free(struct bpf_prog_aux *aux)
 #endif /* CONFIG_BPF_SYSCALL */
 
 #ifdef CONFIG_INTEL_SGX
-int security_enclave_map(unsigned long prot)
+int security_enclave_map(unsigned long prot, bool eaug)
 {
-	return call_int_hook(enclave_map, 0, prot);
+	return call_int_hook(enclave_map, 0, prot, eaug);
 }
 int security_enclave_load(struct vm_area_struct *vma, unsigned long prot,
 			  bool measured)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ea452a416fe1..e3b431b2224a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6733,7 +6733,7 @@ static inline int sgx_has_perm(u32 sid, u32 requested)
 			    SECCLASS_PROCESS2, requested, NULL);
 }
 
-static int selinux_enclave_map(unsigned long prot)
+static int selinux_enclave_map(unsigned long prot, bool eaug)
 {
 	const struct cred *cred = current_cred();
 	u32 sid = cred_sid(cred);
@@ -6743,6 +6743,8 @@ static int selinux_enclave_map(unsigned long prot)
 
 	if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
 		return sgx_has_perm(sid, PROCESS2__SGX_EXECMEM);
+	else if (eaug && (prot & PROT_EXEC))
+		return sgx_has_perm(sid, PROCESS2__SGX_EXECMOD);
 
 	return 0;
 }
-- 
2.21.0

