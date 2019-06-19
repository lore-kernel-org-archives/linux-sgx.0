Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526FDC48BE1
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 22:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3146C215EA
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 22:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbfFSWYS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 18:24:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:40157 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730752AbfFSWYR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 18:24:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 15:24:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,394,1557212400"; 
   d="scan'208";a="150743777"
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
Subject: [RFC PATCH v4 10/12] security/selinux: Add enclave_load() implementation
Date:   Wed, 19 Jun 2019 15:23:59 -0700
Message-Id: <20190619222401.14942-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190619222401.14942-1-sean.j.christopherson@intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The goal of selinux_enclave_load() is to provide a facsimile of the
existing selinux_file_mprotect() and file_map_prot_check() policies,
but tailored to the unique properties of SGX.

For example, an enclave page is technically backed by a MAP_SHARED file,
but the "file" is essentially shared memory that is never persisted
anywhere and also requires execute permissions (for some pages).

Enclaves are also less priveleged than normal user code, e.g. SYSCALL
instructions #UD if attempted in an enclave.  For this reason, add SGX
specific permissions instead of reusing existing permissions such as
FILE__EXECUTE so that policies can allow running code in an enclave, or
allow dynamically loading code in an enclave without having to grant the
same capability to normal user code outside of the enclave.

Intended use of each permission:

  - SGX_EXECDIRTY: dynamically load code within the enclave itself
  - SGX_EXECUNMR: load unmeasured code into the enclave, e.g. Graphene
  - SGX_EXECANON: load code from anonymous memory (likely Graphene)
  - SGX_EXECUTE: load an enclave from a file, i.e. normal behavior

Note, equivalents to FILE__READ and FILE__WRITE are intentionally never
required.  Writes to the enclave page are contained to the EPC, i.e.
never hit the original file, and read permissions have already been
vetted (or the VMA doesn't have PROT_READ, in which case loading the
page into the enclave will fail).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 security/selinux/hooks.c            | 55 +++++++++++++++++++++++++++--
 security/selinux/include/classmap.h |  5 +--
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index fc239e541b62..8a431168e454 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6727,6 +6727,12 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
 #endif
 
 #ifdef CONFIG_INTEL_SGX
+static inline int sgx_has_perm(u32 sid, u32 requested)
+{
+	return avc_has_perm(&selinux_state, sid, sid,
+			    SECCLASS_PROCESS2, requested, NULL);
+}
+
 static int selinux_enclave_map(unsigned long prot)
 {
 	const struct cred *cred = current_cred();
@@ -6736,11 +6742,53 @@ static int selinux_enclave_map(unsigned long prot)
 	WARN_ON_ONCE(!default_noexec);
 
 	if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
-		return avc_has_perm(&selinux_state, sid, sid,
-				    SECCLASS_PROCESS2, PROCESS2__SGX_MAPWX,
-				    NULL);
+		return sgx_has_perm(sid, PROCESS2__SGX_MAPWX);
+
 	return 0;
 }
+
+static int selinux_enclave_load(struct vm_area_struct *vma, unsigned long prot,
+				bool measured)
+{
+	const struct cred *cred = current_cred();
+	u32 sid = cred_sid(cred);
+	int ret;
+
+	/* SGX is supported only in 64-bit kernels. */
+	WARN_ON_ONCE(!default_noexec);
+
+	/* Only executable enclave pages are restricted in any way. */
+	if (!(prot & PROT_EXEC))
+		return 0;
+
+	/*
+	 * WX at load time only requires EXECDIRTY, e.g. to allow W->X.  Actual
+	 * WX mappings require MAPWX (see selinux_enclave_map()).
+	 */
+	if (prot & PROT_WRITE) {
+		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECDIRTY);
+		if (ret)
+			goto out;
+	}
+	if (!measured) {
+		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECUNMR);
+		if (ret)
+			goto out;
+	}
+
+	if (!vma->vm_file || IS_PRIVATE(file_inode(vma->vm_file)) ||
+	    vma->anon_vma)
+		/*
+		 * Loading enclave code from an anonymous mapping or from a
+		 * modified private file mapping.
+		 */
+		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECANON);
+	else
+		/* Loading from a shared or unmodified private file mapping. */
+		ret = file_has_perm(cred, vma->vm_file, FILE__SGX_EXECUTE);
+out:
+	return ret;
+}
 #endif
 
 struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
@@ -6988,6 +7036,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 
 #ifdef CONFIG_INTEL_SGX
 	LSM_HOOK_INIT(enclave_map, selinux_enclave_map),
+	LSM_HOOK_INIT(enclave_load, selinux_enclave_load),
 #endif
 };
 
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index cfd91e879bdf..baa1757be46a 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -7,7 +7,7 @@
 
 #define COMMON_FILE_PERMS COMMON_FILE_SOCK_PERMS, "unlink", "link", \
     "rename", "execute", "quotaon", "mounton", "audit_access", \
-    "open", "execmod"
+    "open", "execmod", "sgx_execute"
 
 #define COMMON_SOCK_PERMS COMMON_FILE_SOCK_PERMS, "bind", "connect", \
     "listen", "accept", "getopt", "setopt", "shutdown", "recvfrom",  \
@@ -52,7 +52,8 @@ struct security_class_mapping secclass_map[] = {
 	    "setsockcreate", "getrlimit", NULL } },
 	{ "process2",
 	  { "nnp_transition", "nosuid_transition",
-	    "sgx_mapwx", NULL } },
+	    "sgx_mapwx", "sgx_execdirty", "sgx_execanon", "sgx_execunmr",
+	    NULL } },
 	{ "system",
 	  { "ipc_info", "syslog_read", "syslog_mod",
 	    "syslog_console", "module_request", "module_load", NULL } },
-- 
2.21.0

