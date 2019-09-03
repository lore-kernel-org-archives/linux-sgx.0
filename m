Return-Path: <SRS0=NgZr=W6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9C8C3A5A2
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 14:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5887D23431
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 14:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbfICO2e (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:28:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:34192 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729701AbfICO2d (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 3 Sep 2019 10:28:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 07:28:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="189825963"
Received: from vkuppusa-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.39.67])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Sep 2019 07:28:26 -0700
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
        cedric.xing@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v22 10/24] x86/sgx: Add sgx_einit() for wrapping ENCLS[EINIT]
Date:   Tue,  3 Sep 2019 17:26:41 +0300
Message-Id: <20190903142655.21943-11-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
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
 arch/x86/kernel/cpu/sgx/main.c | 51 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h  |  2 ++
 2 files changed, 53 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 6b4727df72ca..d3ed742e90fe 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -17,6 +17,9 @@ EXPORT_SYMBOL_GPL(sgx_epc_sections);
 
 int sgx_nr_epc_sections;
 
+/* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
+static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
+
 static struct sgx_epc_page *sgx_section_get_page(
 	struct sgx_epc_section *section)
 {
@@ -106,6 +109,54 @@ void sgx_free_page(struct sgx_epc_page *page)
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
index 210510a28ce0..41d4130c33a2 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -67,5 +67,7 @@ int sgx_page_reclaimer_init(void);
 struct sgx_epc_page *sgx_alloc_page(void);
 int __sgx_free_page(struct sgx_epc_page *page);
 void sgx_free_page(struct sgx_epc_page *page);
+int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
+	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
 
 #endif /* _X86_SGX_H */
-- 
2.20.1

