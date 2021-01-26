Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43491C433E6
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Jan 2021 16:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B93722DFB
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Jan 2021 16:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404380AbhAZQOu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Jan 2021 11:14:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:57475 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391143AbhAZJbY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Jan 2021 04:31:24 -0500
IronPort-SDR: iiBNJch5V0RimiRpwn16U86V6kcOesJ64LGYHMnPyrqcGQdt4wJi1vQzLw+Lq7CsEa56dTn+ES
 YHHpjGANCIxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="166973517"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="166973517"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:30:39 -0800
IronPort-SDR: FcJvZ3Seil5gspx6o2CE0Fy3eNIMMhtc6cvvgI12wVH+p05Wbn9B/Yoj8IJNbm+rPRZkLhEekR
 JdeTC7I8HMvw==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="577747488"
Received: from ravivisw-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.124.51])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:30:36 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 02/27] x86/cpufeatures: Make SGX_LC feature bit depend on SGX bit
Date:   Tue, 26 Jan 2021 22:30:17 +1300
Message-Id: <bdca25f260a895fcc39b2fb59e1155102a210aa0.1611634586.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611634586.git.kai.huang@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move SGX_LC feature bit to CPUID dependency table as well, along with
new added SGX1 and SGX2 bit, to make clearing all SGX feature bits
easier. Also remove clear_sgx_caps() since it is just a wrapper of
setup_clear_cpu_cap(X86_FEATURE_SGX) now.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/cpuid-deps.c |  1 +
 arch/x86/kernel/cpu/feat_ctl.c   | 12 +++---------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 5cf965580dd4..defda61f372d 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -72,6 +72,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AVX512_FP16,		X86_FEATURE_AVX512BW  },
 	{ X86_FEATURE_ENQCMD,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_PER_THREAD_MBA,		X86_FEATURE_MBA       },
+	{ X86_FEATURE_SGX_LC,			X86_FEATURE_SGX	      },
 	{ X86_FEATURE_SGX1,			X86_FEATURE_SGX       },
 	{ X86_FEATURE_SGX2,			X86_FEATURE_SGX1      },
 	{}
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 3b1b01f2b248..27533a6e04fa 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -93,15 +93,9 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
 }
 #endif /* CONFIG_X86_VMX_FEATURE_NAMES */
 
-static void clear_sgx_caps(void)
-{
-	setup_clear_cpu_cap(X86_FEATURE_SGX);
-	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
-}
-
 static int __init nosgx(char *str)
 {
-	clear_sgx_caps();
+	setup_clear_cpu_cap(X86_FEATURE_SGX);
 
 	return 0;
 }
@@ -116,7 +110,7 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 
 	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
 		clear_cpu_cap(c, X86_FEATURE_VMX);
-		clear_sgx_caps();
+		clear_cpu_cap(c, X86_FEATURE_SGX);
 		return;
 	}
 
@@ -177,6 +171,6 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
 		if (enable_sgx)
 			pr_err_once("SGX disabled by BIOS\n");
-		clear_sgx_caps();
+		clear_cpu_cap(c, X86_FEATURE_SGX);
 	}
 }
-- 
2.29.2

