Return-Path: <SRS0=RGqr=3Y=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB480C3524F
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Feb 2020 06:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BEE620674
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Feb 2020 06:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgBDGG1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Feb 2020 01:06:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:25500 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgBDGG1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Feb 2020 01:06:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 22:06:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="249242284"
Received: from ncouniha-mobl6.ger.corp.intel.com (HELO localhost) ([10.252.20.163])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2020 22:06:21 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v25 06/21] x86/cpu/intel: Detect SGX supprt
Date:   Tue,  4 Feb 2020 08:05:30 +0200
Message-Id: <20200204060545.31729-7-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Configure SGX as part of feature control MSR initialization and update
the associated X86_FEATURE flags accordingly.  Because the kernel will
require the LE hash MSRs to be writable when running native enclaves,
disable X86_FEATURE_SGX (and all derivatives) if SGX Launch Control is
not (or cannot) be fully enabled via feature control MSR.

The check is done for every CPU, not just BSP, in order to verify that
MSR_IA32_FEATURE_CONTROL is correctly configured on all CPUs. The other
parts of the kernel, like the enclave driver, expect the same
configuration from all CPUs.

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
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/feat_ctl.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

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
-- 
2.20.1

