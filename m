Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24C4C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 16:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2A312146E
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 16:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfCTQYY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 12:24:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:33791 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfCTQYY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 12:24:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 09:24:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="135715336"
Received: from sorenthe-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.203])
  by orsmga003.jf.intel.com with ESMTP; 20 Mar 2019 09:24:14 -0700
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
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v19,RESEND 15/27] x86/sgx: Add sgx_einit() for initializing enclaves
Date:   Wed, 20 Mar 2019 18:21:07 +0200
Message-Id: <20190320162119.4469-16-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a helper function to perform ENCLS(EINIT) with the correct LE
hash MSR values.  ENCLS[EINIT] initializes an enclave, verifying the
enclave's measurement and preparing it for execution, i.e. the enclave
cannot be run until it has been initialized.  The measurement aspect
of EINIT references the MSR_IA32_SGXLEPUBKEYHASH* MSRs, with the CPU
comparing CPU compares the key (technically its hash) used to sign the
enclave[1] with the key hash stored in the MSRs, and will reject EINIT
if the keys do not match.

A per-cpu cache is used to avoid writing the MSRs as writing the MSRs
is extraordinarily expensive, e.g. 300-400 cycles per MSR.  Because
the cache may become stale, force update the MSRs and retry EINIT if
the first EINIT fails due to an "invalid token".  An invalid token
error does not necessarily mean the MSRs need to be updated, but the
cost of an unnecessary write is minimal relative to the cost of EINIT
itself.

[1] For EINIT's purposes, the effective signer of the enclave may be
    the enclave's owner, or a separate Launch Enclave that has created
    an EINIT token for the target enclave.  When using an EINIT token,
    the key used to sign the token must match the MSRs in order for
    EINIT to succeed.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 51 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h  |  2 ++
 2 files changed, 53 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index f88c8d86c2a8..e966f96837c7 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -17,6 +17,9 @@ EXPORT_SYMBOL_GPL(sgx_epc_sections);
 
 static int sgx_nr_epc_sections;
 
+/* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
+static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
+
 static void sgx_section_put_page(struct sgx_epc_section *section,
 				 struct sgx_epc_page *page)
 {
@@ -112,6 +115,54 @@ void sgx_free_page(struct sgx_epc_page *page)
 }
 EXPORT_SYMBOL_GPL(sgx_free_page);
 
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
+EXPORT_SYMBOL(sgx_einit);
+
 static __init void sgx_free_epc_section(struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 86b4c74b6089..f90d02fbbbbd 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -62,5 +62,7 @@ static inline void *sgx_epc_addr(struct sgx_epc_page *page)
 struct sgx_epc_page *sgx_alloc_page(void);
 int __sgx_free_page(struct sgx_epc_page *page);
 void sgx_free_page(struct sgx_epc_page *page);
+int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
+	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
 
 #endif /* _X86_SGX_H */
-- 
2.19.1

