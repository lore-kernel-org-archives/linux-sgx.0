Return-Path: <SRS0=httf=UQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB647C468B0
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82D612085A
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfFQWYt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:24:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:29311 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfFQWYt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
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
Subject: [RFC PATCH v3 11/12] security/apparmor: Add enclave_load() implementation
Date:   Mon, 17 Jun 2019 15:24:37 -0700
Message-Id: <20190617222438.2080-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617222438.2080-1-sean.j.christopherson@intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Require execute permissions when loading an enclave from a file.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 security/apparmor/include/audit.h |  2 ++
 security/apparmor/lsm.c           | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/security/apparmor/include/audit.h b/security/apparmor/include/audit.h
index ee559bc2acb8..84470483e04d 100644
--- a/security/apparmor/include/audit.h
+++ b/security/apparmor/include/audit.h
@@ -107,6 +107,8 @@ enum audit_type {
 #define OP_PROF_LOAD "profile_load"
 #define OP_PROF_RM "profile_remove"
 
+#define OP_ENCL_LOAD "enclave_load"
+
 
 struct apparmor_audit_data {
 	int error;
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 87500bde5a92..2ed1157e1f58 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -517,6 +517,17 @@ static int apparmor_file_mprotect(struct vm_area_struct *vma,
 			   !(vma->vm_flags & VM_SHARED) ? MAP_PRIVATE : 0);
 }
 
+#ifdef CONFIG_INTEL_SGX
+static int apparmor_enclave_load(struct vm_area_struct *vma, unsigned long prot,
+				bool measured)
+{
+	if (!(prot & PROT_EXEC))
+		return 0;
+
+	return common_file_perm(OP_ENCL_LOAD, vma->vm_file, AA_EXEC_MMAP);
+}
+#endif
+
 static int apparmor_sb_mount(const char *dev_name, const struct path *path,
 			     const char *type, unsigned long flags, void *data)
 {
@@ -1243,6 +1254,9 @@ static struct security_hook_list apparmor_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(secid_to_secctx, apparmor_secid_to_secctx),
 	LSM_HOOK_INIT(secctx_to_secid, apparmor_secctx_to_secid),
 	LSM_HOOK_INIT(release_secctx, apparmor_release_secctx),
+#ifdef CONFIG_INTEL_SGX
+	LSM_HOOK_INIT(enclave_load, apparmor_enclave_load),
+#endif
 };
 
 /*
-- 
2.21.0

