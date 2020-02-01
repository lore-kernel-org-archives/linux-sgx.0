Return-Path: <SRS0=7EJM=3V=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB3EC33CB7
	for <linux-sgx@archiver.kernel.org>; Sat,  1 Feb 2020 17:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6109D20679
	for <linux-sgx@archiver.kernel.org>; Sat,  1 Feb 2020 17:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgBARtn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 1 Feb 2020 12:49:43 -0500
Received: from mga17.intel.com ([192.55.52.151]:64397 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbgBARtn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 1 Feb 2020 12:49:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 09:49:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="429034038"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2020 09:49:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25 3/3] x86/cpu: Configure SGX support when initializing feature control MSR
Date:   Sat,  1 Feb 2020 09:49:40 -0800
Message-Id: <20200201174940.20984-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201174940.20984-1-sean.j.christopherson@intel.com>
References: <20200201174940.20984-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Configure SGX as part of feature control MSR initialization and update
the associated X86_FEATURE flags accordingly.  Because the kernel will
require the LE hash MSRs to be writable when running native enclaves,
disable X86_FEATURE_SGX (and all derivatives) if SGX Launch Control is
not (or cannot) be fully enabled via feature control MSR.

Note, unlike VMX, clear the X86_FEATURE_SGX* flags for all CPUs if any
CPU lacks SGX support as the kernel expects SGX to be available on all
CPUs.  X86_FEATURE_VMX is intentionally cleared only for the current CPU
so that KVM can provide additional information if KVM fails to load,
e.g. print which CPU doesn't support VMX.  KVM/VMX requires additional
per-CPU enabling, e.g. to set CR4.VMXE and do VMXON, and so already has
the necessary infrastructure to do per-CPU checks.  SGX on the other
hand doesn't require additional enabling, so clearing the feature flags
on all CPUs means the SGX subsystem doesn't need to manually do support
checks on a per-CPU basis.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

This reverts commit 4249f9b240b7, i.e. is a drop-in replacement.
Fixes: 4249f9b240b7 ("x86/cpu/intel: Detect SGX supprt")

 arch/x86/kernel/cpu/feat_ctl.c | 29 ++++++++++++++++++++++++-
 arch/x86/kernel/cpu/intel.c    | 39 ----------------------------------
 2 files changed, 28 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 0268185bef94..b16b71a6da74 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -92,6 +92,14 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
 }
 #endif /* CONFIG_X86_VMX_FEATURE_NAMES */
 
+static void clear_sgx_caps(void)
+{
+	setup_clear_cpu_cap(X86_FEATURE_SGX);
+	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
+	setup_clear_cpu_cap(X86_FEATURE_SGX1);
+	setup_clear_cpu_cap(X86_FEATURE_SGX2);
+}
+
 void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 {
 	bool tboot = tboot_enabled();
@@ -99,6 +107,7 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 
 	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
 		clear_cpu_cap(c, X86_FEATURE_VMX);
+		clear_sgx_caps();
 		return;
 	}
 
@@ -123,13 +132,21 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
 	}
 
+	/*
+	 * Enable SGX if and only if the kernel supports SGX and Launch Control
+	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
+	 */
+	if (cpu_has(c, X86_FEATURE_SGX) && cpu_has(c, X86_FEATURE_SGX_LC) &&
+	    IS_ENABLED(CONFIG_INTEL_SGX))
+		msr |= FEAT_CTL_SGX_ENABLED | FEAT_CTL_SGX_LC_ENABLED;
+
 	wrmsrl(MSR_IA32_FEAT_CTL, msr);
 
 update_caps:
 	set_cpu_cap(c, X86_FEATURE_MSR_IA32_FEAT_CTL);
 
 	if (!cpu_has(c, X86_FEATURE_VMX))
-		return;
+		goto update_sgx;
 
 	if ( (tboot && !(msr & FEAT_CTL_VMX_ENABLED_INSIDE_SMX)) ||
 	    (!tboot && !(msr & FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX))) {
@@ -142,4 +159,14 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 		init_vmx_capabilities(c);
 #endif
 	}
+
+update_sgx:
+	if (!cpu_has(c, X86_FEATURE_SGX) || !cpu_has(c, X86_FEATURE_SGX_LC)) {
+		clear_sgx_caps();
+	} else if (!(msr & FEAT_CTL_SGX_ENABLED) ||
+		   !(msr & FEAT_CTL_SGX_LC_ENABLED)) {
+		if (IS_ENABLED(CONFIG_INTEL_SGX))
+			pr_err_once("SGX disabled by BIOS\n");
+		clear_sgx_caps();
+	}
 }
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index cab0940784a7..be82cd5841c3 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -542,40 +542,6 @@ static void detect_tme(struct cpuinfo_x86 *c)
 	c->x86_phys_bits -= keyid_bits;
 }
 
-static void __maybe_unused detect_sgx(struct cpuinfo_x86 *c)
-{
-	unsigned long long fc;
-
-	rdmsrl(MSR_IA32_FEAT_CTL, fc);
-	if (!(fc & FEATURE_CONTROL_LOCKED)) {
-		pr_err_once("sgx: The feature control MSR is not locked\n");
-		goto err_unsupported;
-	}
-
-	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
-		pr_err_once("sgx: SGX is not enabled in IA32_FEATURE_CONTROL MSR\n");
-		goto err_unsupported;
-	}
-
-	if (!cpu_has(c, X86_FEATURE_SGX1)) {
-		pr_err_once("sgx: SGX1 instruction set is not supported\n");
-		goto err_unsupported;
-	}
-
-	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
-		pr_info_once("sgx: The launch control MSRs are not writable\n");
-		goto err_unsupported;
-	}
-
-	return;
-
-err_unsupported:
-	setup_clear_cpu_cap(X86_FEATURE_SGX);
-	setup_clear_cpu_cap(X86_FEATURE_SGX1);
-	setup_clear_cpu_cap(X86_FEATURE_SGX2);
-	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
-}
-
 static void init_cpuid_fault(struct cpuinfo_x86 *c)
 {
 	u64 msr;
@@ -712,11 +678,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_TME))
 		detect_tme(c);
 
-#ifdef CONFIG_INTEL_SGX
-	if (cpu_has(c, X86_FEATURE_SGX))
-		detect_sgx(c);
-#endif
-
 	init_intel_misc_features(c);
 
 	if (tsx_ctrl_state == TSX_CTRL_ENABLE)
-- 
2.24.1

