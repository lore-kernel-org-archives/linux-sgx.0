Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD91C433E0
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Feb 2021 13:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A55564E43
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Feb 2021 13:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhBMN3i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Feb 2021 08:29:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:7913 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229672AbhBMN3h (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Feb 2021 08:29:37 -0500
IronPort-SDR: pQYqVCKAsOG/Vwibii8kNwFxoSTkCcNK2504S0v7ZnhjfIIov+8abCMe/fg4QxpCa6L1bpp/QZ
 IDjcLu8MERVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="182595696"
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="182595696"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:28:52 -0800
IronPort-SDR: gPE7mGMsn3IeGoDBj6klW4wYM4Sv8T77Koug4qFtmzMamg3LMcF+l/aZ4E5wz3FkQ4alEMrB5E
 WSIwFe31RMbw==
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="398365945"
Received: from kshah-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.239])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:28:49 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v5 01/26] x86/cpufeatures: Make SGX_LC feature bit depend on SGX bit
Date:   Sun, 14 Feb 2021 02:28:35 +1300
Message-Id: <8e6a1963b3666215223c247193e5a3e09a8c3698.1613221549.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1613221549.git.kai.huang@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move SGX_LC feature bit to CPUID dependency table to make clearing all
SGX feature bits easier. Also remove clear_sgx_caps() since it is just
a wrapper of setup_clear_cpu_cap(X86_FEATURE_SGX) now.

Suggested-by: Sean Christopherson <seanjc@google.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v4->v5:

 - No code change.

v3->v4:

 - Changed patch order with the patch that introduced new SGX1/SGX2 bits, since
   it is improvement of existing code, per Jarkko.

---
 arch/x86/kernel/cpu/cpuid-deps.c |  1 +
 arch/x86/kernel/cpu/feat_ctl.c   | 12 +++---------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 42af31b64c2c..d40f8e0a54ce 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -72,6 +72,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AVX512_FP16,		X86_FEATURE_AVX512BW  },
 	{ X86_FEATURE_ENQCMD,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_PER_THREAD_MBA,		X86_FEATURE_MBA       },
+	{ X86_FEATURE_SGX_LC,			X86_FEATURE_SGX	      },
 	{}
 };
 
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

