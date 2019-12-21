Return-Path: <SRS0=9G3N=2L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B281EC43603
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D8F52070C
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfLUAuz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Dec 2019 19:50:55 -0500
Received: from mga17.intel.com ([192.55.52.151]:57300 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfLUAuz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Dec 2019 19:50:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 16:50:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,337,1571727600"; 
   d="scan'208";a="391028389"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 20 Dec 2019 16:50:54 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25] x86/sgx: Move the intermediate EINIT helper into the driver
Date:   Fri, 20 Dec 2019 16:50:53 -0800
Message-Id: <20191221005053.27620-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move sgx_einit() into the driver code, along with the LE hash MSR
management.  Providing sgx_einit() in the common SGX code was a bit
premature.  The thought was that the native SGX driver and KVM would
be able to use a common EINIT helper, but that may or may not hold
true depending on how KVM's implementation shakes out.  For example,
KVM may want to pass user pointers directly to EINIT in order to
avoid copying large amounts of data to in-kernel temp structures.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I hedged a bit in the changelog, but I'm 99% confident KVM support will
use a different implementation for EINIT.  Figure moving the code is worth
doing in the initial series since it eliminates encls.c.  My thought is
that the KVM series can move just the sgx_lepubkeyhash_cache code into
main.c so it can be shared with virtual EPC code.

 arch/x86/kernel/cpu/sgx/Makefile |  1 -
 arch/x86/kernel/cpu/sgx/encls.c  | 57 --------------------------------
 arch/x86/kernel/cpu/sgx/encls.h  |  3 --
 arch/x86/kernel/cpu/sgx/ioctl.c  | 37 +++++++++++++++++++++
 4 files changed, 37 insertions(+), 61 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/sgx/encls.c

diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index 3ddcdabab081..f8d32da3a67a 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -1,7 +1,6 @@
 obj-y += \
 	driver.o \
 	encl.o \
-	encls.o \
 	ioctl.o \
 	main.o \
 	reclaim.o
diff --git a/arch/x86/kernel/cpu/sgx/encls.c b/arch/x86/kernel/cpu/sgx/encls.c
deleted file mode 100644
index 44291062967a..000000000000
--- a/arch/x86/kernel/cpu/sgx/encls.c
+++ /dev/null
@@ -1,57 +0,0 @@
-// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
-// Copyright(c) 2016-19 Intel Corporation.
-
-#include <asm/cpufeature.h>
-#include <asm/traps.h>
-#include "encls.h"
-#include "sgx.h"
-
-/* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
-static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
-
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
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index af94bbfe4cf6..d6381e4f6eb2 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -248,7 +248,4 @@ static inline int __ewb(struct sgx_pageinfo *pginfo, void *addr,
 	return __encls_ret_3(EWB, pginfo, addr, va);
 }
 
-int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
-	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
-
 #endif /* _X86_ENCLS_H */
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 5c9e6e161698..f5812a834329 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -16,6 +16,9 @@
 #include "encl.h"
 #include "encls.h"
 
+/* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
+static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
+
 static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 {
 	struct sgx_va_page *va_page = NULL;
@@ -578,6 +581,40 @@ static int sgx_get_key_hash(const void *modulus, void *hash)
 	return ret;
 }
 
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
+static int sgx_einit(struct sgx_sigstruct *sigstruct,
+		     struct sgx_einittoken *token,
+		     struct sgx_epc_page *secs, u64 *lepubkeyhash)
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
+
 static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 			 struct sgx_einittoken *token)
 {
-- 
2.24.1

