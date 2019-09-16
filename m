Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C2BC49ED7
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98F7920873
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfIPEO6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:14:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:4080 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEO6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:14:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:14:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387075977"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:14:54 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v2 06/17] x86/sgx: Move sgx_einit() to encls.c
Date:   Mon, 16 Sep 2019 07:14:06 +0300
Message-Id: <20190916041417.12533-7-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move sgx_einit() to encls.c as it is essentially a global wrapper for
EINIT somewhat independent of the code using it. It does not have any
binding with the code in main.c.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/Makefile |  2 +-
 arch/x86/kernel/cpu/sgx/encls.c  | 56 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encls.h  |  3 ++
 arch/x86/kernel/cpu/sgx/main.c   | 50 ----------------------------
 arch/x86/kernel/cpu/sgx/sgx.h    |  2 --
 5 files changed, 60 insertions(+), 53 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/sgx/encls.c

diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index cfd29c42264b..379e9c52848e 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -1,5 +1,5 @@
 # core
-obj-y += encl.o main.o reclaim.o
+obj-y += encl.o encls.o main.o reclaim.o
 
 # driver
 obj-y += driver.o ioctl.o
diff --git a/arch/x86/kernel/cpu/sgx/encls.c b/arch/x86/kernel/cpu/sgx/encls.c
new file mode 100644
index 000000000000..cda09cf8b927
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/encls.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-19 Intel Corporation.
+
+#include <linux/highmem.h>
+#include <asm/cpufeature.h>
+#include "encls.h"
+
+/* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
+static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
+
+static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
+{
+	u64 *cache;
+	int i;
+
+	cache = per_cpu(sgx_lepubkeyhash_cache, smp_processor_id());
+	for (i = 0; i < 4; i++) {
+		if (enforce || (lepubkeyhash[i] != cache[i])) {
+			wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
+			cache[i] = lepubkeyhash[i];
+		}
+	}
+}
+
+/**
+ * sgx_einit() - Initialize an enclave
+ * @sigstruct:		a pointer a SIGSTRUCT
+ * @token:		a pointer an EINITTOKEN (optional)
+ * @secs:		a pointer a SECS
+ * @lepubkeyhash:	the desired value for IA32_SGXLEPUBKEYHASHx MSRs
+ *
+ * Execute ENCLS[EINIT], writing the IA32_SGXLEPUBKEYHASHx MSRs according
+ * to @lepubkeyhash (if possible and necessary).
+ *
+ * Return:
+ *   0 on success,
+ *   -errno or SGX error on failure
+ */
+int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
+	      struct sgx_epc_page *secs, u64 *lepubkeyhash)
+{
+	int ret;
+
+	if (!boot_cpu_has(X86_FEATURE_SGX_LC))
+		return __einit(sigstruct, token, sgx_epc_addr(secs));
+
+	preempt_disable();
+	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
+	ret = __einit(sigstruct, token, sgx_epc_addr(secs));
+	if (ret == SGX_INVALID_EINITTOKEN) {
+		sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);
+		ret = __einit(sigstruct, token, sgx_epc_addr(secs));
+	}
+	preempt_enable();
+	return ret;
+}
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index b7e6462e58b8..e3713337c187 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -257,4 +257,7 @@ static inline int __emodt(struct sgx_secinfo *secinfo, void *addr)
 	return __encls_ret_2(SGX_EMODT, secinfo, addr);
 }
 
+int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
+	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
+
 #endif /* _X86_ENCLS_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c58ab5f28669..4c03e5f33414 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -15,9 +15,6 @@
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 int sgx_nr_epc_sections;
 
-/* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
-static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
-
 static struct sgx_epc_page *sgx_section_try_take_page(
 	struct sgx_epc_section *section)
 {
@@ -162,53 +159,6 @@ void sgx_free_page(struct sgx_epc_page *page)
 	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
 }
 
-static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
-{
-	u64 *cache;
-	int i;
-
-	cache = per_cpu(sgx_lepubkeyhash_cache, smp_processor_id());
-	for (i = 0; i < 4; i++) {
-		if (enforce || (lepubkeyhash[i] != cache[i])) {
-			wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
-			cache[i] = lepubkeyhash[i];
-		}
-	}
-}
-
-/**
- * sgx_einit - initialize an enclave
- * @sigstruct:		a pointer a SIGSTRUCT
- * @token:		a pointer an EINITTOKEN (optional)
- * @secs:		a pointer a SECS
- * @lepubkeyhash:	the desired value for IA32_SGXLEPUBKEYHASHx MSRs
- *
- * Execute ENCLS[EINIT], writing the IA32_SGXLEPUBKEYHASHx MSRs according
- * to @lepubkeyhash (if possible and necessary).
- *
- * Return:
- *   0 on success,
- *   -errno or SGX error on failure
- */
-int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
-	      struct sgx_epc_page *secs, u64 *lepubkeyhash)
-{
-	int ret;
-
-	if (!boot_cpu_has(X86_FEATURE_SGX_LC))
-		return __einit(sigstruct, token, sgx_epc_addr(secs));
-
-	preempt_disable();
-	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
-	ret = __einit(sigstruct, token, sgx_epc_addr(secs));
-	if (ret == SGX_INVALID_EINITTOKEN) {
-		sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);
-		ret = __einit(sigstruct, token, sgx_epc_addr(secs));
-	}
-	preempt_enable();
-	return ret;
-}
-
 static __init void sgx_free_epc_section(struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index bc6a644af2b5..9b08690262b5 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -85,7 +85,5 @@ void sgx_reclaim_pages(void);
 struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
 int __sgx_free_page(struct sgx_epc_page *page);
 void sgx_free_page(struct sgx_epc_page *page);
-int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
-	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
 
 #endif /* _X86_SGX_H */
-- 
2.20.1

