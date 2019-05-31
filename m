Return-Path: <SRS0=g3U3=T7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8C7C28CC4
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B2D62593D
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfEaXcj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 31 May 2019 19:32:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:59345 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfEaXci (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
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
Subject: [RFC PATCH 9/9] security/selinux: Add enclave_load() implementation
Date:   Fri, 31 May 2019 16:31:59 -0700
Message-Id: <20190531233159.30992-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531233159.30992-1-sean.j.christopherson@intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
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

The basic concept is to require appropriate execute permissions on the
source of the enclave for pages that are requesting PROT_EXEC, e.g. if
an enclave page is being loaded from a regular file, require
FILE__EXECUTE and/or FILE__EXECMOND, and if it's coming from an
anonymous/private mapping, require PROCESS__EXECMEM since the process
is essentially executing from the mapping, albeit in a roundabout way.

Note, FILE__READ and FILE__WRITE are intentionally not required even if
the source page is backed by a regular file.  Writes to the enclave page
are contained to the EPC, i.e. never hit the original file, and read
permissions have already been vetted (or the VMA doesn't have PROT_READ,
in which case loading the page into the enclave will fail).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 security/selinux/hooks.c | 85 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3ec702cf46ca..f436a055dda7 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6726,6 +6726,87 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
 }
 #endif
 
+#ifdef CONFIG_INTEL_SGX
+int selinux_enclave_load(struct vm_area_struct *vma, unsigned long prot,
+			 unsigned long *allowed_prot)
+{
+	const struct cred *cred = current_cred();
+	u32 sid = cred_sid(cred);
+	int rc;
+
+	/* SGX is supported only in 64-bit kernels. */
+	WARN_ON_ONCE(!default_noexec);
+
+	/*
+	 * SGX is responsible for checking @prot vs @allowed_prot, and SELinux
+	 * only cares about execute related permissions for enclaves.
+	 */
+	if (!(*allowed_prot & PROT_EXEC))
+		return 0;
+
+	/*
+	 * Loading an executable enclave page from a VMA that is not executable
+	 * itself requires EXECUTE permissions on the source file, or if there
+	 * is no regular source file, EXECMEM since the page is being loaded
+	 * from a non-executable anonymous mapping.
+	 */
+	if (!(vma->vm_flags & VM_EXEC)) {
+		if (vma->vm_file && !IS_PRIVATE(file_inode(vma->vm_file)))
+			rc = file_has_perm(cred, vma->vm_file, FILE__EXECUTE);
+		else
+			rc = avc_has_perm(&selinux_state,
+					  sid, sid, SECCLASS_PROCESS,
+					  PROCESS__EXECMEM, NULL);
+
+		/*
+		 * Reject the load if the enclave *needs* the page to be
+		 * executable, otherwise prevent it from becoming executable.
+		 */
+		if (rc) {
+			if (prot & PROT_EXEC)
+				return rc;
+
+			*allowed_prot &= ~PROT_EXEC;
+		}
+	}
+
+	/*
+	 * An enclave page that may do RW->RX or W+X requires EXECMOD (backed
+	 * by a regular file) or EXECMEM (loaded from an anonymous mapping).
+	 * Note, this hybrid EXECMOD and EXECMEM behavior is intentional and
+	 * reflects the nature of enclaves and the EPC, e.g. EPC is effectively
+	 * a non-persistent shared file, but each enclave is a private domain
+	 * within that shared file, so delegate to the source of the enclave.
+	 */
+	if ((*allowed_prot & PROT_EXEC) && (*allowed_prot & PROT_WRITE)) {
+		if (vma->vm_file && !IS_PRIVATE(file_inode(vma->vm_file)))
+			rc = file_has_perm(cred, vma->vm_file, FILE__EXECMOD);
+		else
+			rc = avc_has_perm(&selinux_state,
+					  sid, sid, SECCLASS_PROCESS,
+					  PROCESS__EXECMEM, NULL);
+		/*
+		 * Clear ALLOW_EXEC instead of ALLOWED_WRITE if permissions are
+		 * lacking and @prot has neither PROT_WRITE or PROT_EXEC.  If
+		 * userspace wanted RX they would have requested RX, and due to
+		 * lack of permissions they can never get RW->RX, i.e. the only
+		 * useful transition is R->RW.
+		 */
+		if (rc) {
+			if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
+				return rc;
+
+			if (prot & PROT_EXEC)
+				*allowed_prot &= ~PROT_WRITE;
+			else
+				*allowed_prot &= ~PROT_EXEC;
+		}
+	}
+
+	return 0;
+}
+#endif
+
 struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
 	.lbs_cred = sizeof(struct task_security_struct),
 	.lbs_file = sizeof(struct file_security_struct),
@@ -6968,6 +7049,10 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(bpf_map_free_security, selinux_bpf_map_free),
 	LSM_HOOK_INIT(bpf_prog_free_security, selinux_bpf_prog_free),
 #endif
+
+#ifdef CONFIG_INTEL_SGX
+	LSM_HOOK_INIT(enclave_load, selinux_enclave_load),
+#endif
 };
 
 static __init int selinux_init(void)
-- 
2.21.0

