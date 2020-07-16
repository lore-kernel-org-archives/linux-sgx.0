Return-Path: <SRS0=YHr7=A3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D67C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBCB32082F
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgGPNyk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:54:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:11326 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728777AbgGPNyk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 Jul 2020 09:54:40 -0400
IronPort-SDR: 6uzWk+PBly2hvgFiB8RpPI5czNPukw0CY0JY1d3DcWide1OTqJNbJ8iVdkLD1bpQdGFNGaly7d
 qiaBSeQfxzeg==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="148533959"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="148533959"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 06:54:39 -0700
IronPort-SDR: FhAbqed1WR8mMNAnirPcHNE3QgZ94+2hgjMIrUjJo5LVfmPCGvyHU8t0UIEIVrJW/FrqN5aLIB
 RFvVxkS/CZIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="325150189"
Received: from lettner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.212])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2020 06:54:27 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v36 06/24] x86/cpu/intel: Detect SGX support
Date:   Thu, 16 Jul 2020 16:52:45 +0300
Message-Id: <20200716135303.276442-7-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
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

Acked-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/feat_ctl.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 29a3bedabd06..c3afcd2e4342 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -93,16 +93,35 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
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
+	bool enable_sgx;
 	u64 msr;
 
 	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
 		clear_cpu_cap(c, X86_FEATURE_VMX);
+		clear_sgx_caps();
 		return;
 	}
 
+	/*
+	 * Enable SGX if and only if the kernel supports SGX and Launch Control
+	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
+	 */
+	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
+		     cpu_has(c, X86_FEATURE_SGX1) &&
+		     cpu_has(c, X86_FEATURE_SGX_LC) &&
+		     IS_ENABLED(CONFIG_INTEL_SGX);
+
 	if (msr & FEAT_CTL_LOCKED)
 		goto update_caps;
 
@@ -124,13 +143,16 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
 	}
 
+	if (enable_sgx)
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
@@ -143,4 +165,12 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 		init_vmx_capabilities(c);
 #endif
 	}
+
+update_sgx:
+	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
+	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
+		if (enable_sgx)
+			pr_err_once("SGX disabled by BIOS\n");
+		clear_sgx_caps();
+	}
 }
-- 
2.25.1

