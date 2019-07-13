Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D73CC31E40
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F13F20863
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfGMRJo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 13:09:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:34039 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbfGMRJn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 13:09:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jul 2019 10:09:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,487,1557212400"; 
   d="scan'208";a="341981210"
Received: from hbriegel-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.48])
  by orsmga005.jf.intel.com with ESMTP; 13 Jul 2019 10:09:33 -0700
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
Subject: [PATCH v21 08/28] x86/cpu/intel: Detect SGX support and update caps appropriately
Date:   Sat, 13 Jul 2019 20:07:44 +0300
Message-Id: <20190713170804.2340-9-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Similar to other large Intel features such as VMX and TXT, SGX must be
explicitly enabled in IA32_FEATURE_CONTROL MSR to be truly usable.
Clear all SGX related capabilities if SGX is not fully enabled in
IA32_FEATURE_CONTROL or if the SGX1 instruction set isn't supported
(impossible on bare metal, theoretically possible in a VM if the VMM is
doing something weird).

Like SGX itself, SGX Launch Control must be explicitly enabled via a
flag in IA32_FEATURE_CONTROL. Clear the SGX_LC capability if Launch
Control is not fully enabled (or obviously if SGX itself is disabled).

Note that clearing X86_FEATURE_SGX_LC creates a bit of a conundrum
regarding the SGXLEPUBKEYHASH MSRs, as it may be desirable to read the
MSRs even if they are not writable, e.g. to query the configured key,
but clearing the capability leaves no breadcrum for discerning whether
or not the MSRs exist.  But, such usage will be rare (KVM is the only
known case at this time) and not performance critical, so it's not
unreasonable to require the use of rdmsr_safe().  Clearing the cap bit
eliminates the need for an additional flag to track whether or not
Launch Control is truly enabled, which is what we care about the vast
majority of the time.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c | 71 +++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8d6d92ebeb54..1503b251d10f 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -623,6 +623,72 @@ static void detect_tme(struct cpuinfo_x86 *c)
 	c->x86_phys_bits -= keyid_bits;
 }
 
+static void __maybe_unused detect_sgx(struct cpuinfo_x86 *c)
+{
+	unsigned long long fc;
+
+	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
+	if (!(fc & FEATURE_CONTROL_LOCKED)) {
+		pr_err_once("sgx: The feature control MSR is not locked\n");
+		goto err_unsupported;
+	}
+
+	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
+		pr_err_once("sgx: SGX is not enabled in IA32_FEATURE_CONTROL MSR\n");
+		goto err_unsupported;
+	}
+
+	if (!cpu_has(c, X86_FEATURE_SGX1)) {
+		pr_err_once("sgx: SGX1 instruction set is not supported\n");
+		goto err_unsupported;
+	}
+
+	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
+		pr_info_once("sgx: The launch control MSRs are not writable\n");
+		goto err_msrs_rdonly;
+	}
+
+	return;
+
+err_unsupported:
+	setup_clear_cpu_cap(X86_FEATURE_SGX);
+	setup_clear_cpu_cap(X86_FEATURE_SGX1);
+	setup_clear_cpu_cap(X86_FEATURE_SGX2);
+
+err_msrs_rdonly:
+	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
+}
+
+static void init_intel_energy_perf(struct cpuinfo_x86 *c)
+{
+	u64 epb;
+
+	/*
+	 * Initialize MSR_IA32_ENERGY_PERF_BIAS if not already initialized.
+	 * (x86_energy_perf_policy(8) is available to change it at run-time.)
+	 */
+	if (!cpu_has(c, X86_FEATURE_EPB))
+		return;
+
+	rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
+	if ((epb & 0xF) != ENERGY_PERF_BIAS_PERFORMANCE)
+		return;
+
+	pr_warn_once("ENERGY_PERF_BIAS: Set to 'normal', was 'performance'\n");
+	pr_warn_once("ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)\n");
+	epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
+	wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
+}
+
+static void intel_bsp_resume(struct cpuinfo_x86 *c)
+{
+	/*
+	 * MSR_IA32_ENERGY_PERF_BIAS is lost across suspend/resume,
+	 * so reinitialize it properly like during bootup:
+	 */
+	init_intel_energy_perf(c);
+}
+
 static void init_cpuid_fault(struct cpuinfo_x86 *c)
 {
 	u64 msr;
@@ -760,6 +826,11 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_TME))
 		detect_tme(c);
 
+	if (IS_ENABLED(CONFIG_INTEL_SGX) && cpu_has(c, X86_FEATURE_SGX))
+		detect_sgx(c);
+
+	init_intel_energy_perf(c);
+
 	init_intel_misc_features(c);
 }
 
-- 
2.20.1

