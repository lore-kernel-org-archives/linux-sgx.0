Return-Path: <SRS0=ep0c=YV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5999CA9EC2
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Oct 2019 21:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93A45217D6
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Oct 2019 21:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389243AbfJ1VFR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Oct 2019 17:05:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:49912 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389225AbfJ1VFR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Oct 2019 17:05:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Oct 2019 14:05:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,241,1569308400"; 
   d="scan'208";a="224759670"
Received: from shrehore-mobl1.ti.intel.com (HELO localhost) ([10.251.82.5])
  by fmsmga004.fm.intel.com with ESMTP; 28 Oct 2019 14:05:08 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v23 10/24] x86/sgx: Add sgx_einit() for wrapping ENCLS[EINIT]
Date:   Mon, 28 Oct 2019 23:03:10 +0200
Message-Id: <20191028210324.12475-11-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Enclaves are SGX hosted measured and signed software entities. ENCLS[EINIT]
leaf function checks that the enclave has a legit signed measurement and
transforms the enclave to the state ready for execution. The signed
measurement is provided by the caller in the form of SIGSTRUCT data
structure [1].

Wrap ENCLS[EINIT] into sgx_einit(). Set MSR_IA32_SGXLEPUBKEYHASH* MSRs to
match the public key contained in the SIGSTRUCT [2]. This sets Linux to
enforce a policy where the provided public key is as long as the signed
measurement matches the enclave contents in memory.

Add a per-cpu cache to avoid unnecessary reads and write to the MSRs
as they are expensive operations.

[1] Intel SDM: 37.1.3 ENCLAVE SIGNATURE STRUCTURE (SIGSTRUCT)
[2] Intel SDM: 38.1.4 Intel SGX Launch Control Configuration

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/Makefile |  1 +
 arch/x86/kernel/cpu/sgx/encls.c  | 57 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encls.h  |  3 ++
 3 files changed, 61 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/sgx/encls.c

diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index 2dec75916a5e..874492d9e3bd 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -1,3 +1,4 @@
 obj-y += \
+	encls.o \
 	main.o \
 	reclaim.o
diff --git a/arch/x86/kernel/cpu/sgx/encls.c b/arch/x86/kernel/cpu/sgx/encls.c
new file mode 100644
index 000000000000..44291062967a
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/encls.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-19 Intel Corporation.
+
+#include <asm/cpufeature.h>
+#include <asm/traps.h>
+#include "encls.h"
+#include "sgx.h"
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
+ * sgx_einit - initialize an enclave
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
index d6381e4f6eb2..af94bbfe4cf6 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -248,4 +248,7 @@ static inline int __ewb(struct sgx_pageinfo *pginfo, void *addr,
 	return __encls_ret_3(EWB, pginfo, addr, va);
 }
 
+int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
+	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
+
 #endif /* _X86_ENCLS_H */
-- 
2.20.1

