Return-Path: <SRS0=Mf4r=CX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA7BC43461
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Sep 2020 16:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D02F620719
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Sep 2020 16:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgINQzr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Sep 2020 12:55:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:56663 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgINQsl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Sep 2020 12:48:41 -0400
IronPort-SDR: 08k3SYL/WK59UR63CrI02biJImv7W0OwbVQ7ekpfBJrOrPHWTW/9bOV3Xyu8RzXfPcKAlr8wQA
 V8xpVf0DQXEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160042313"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="160042313"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:48:16 -0700
IronPort-SDR: XdL0NgjpLuufygeHgWNjWxVEI9Ld4lKwibNbZn7UJirEi6s6XRp0No/DC038c6d4t5Ig2Dgo1H
 XbhlFDoOOoIQ==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="287677312"
Received: from daser-mobl.ger.corp.intel.com (HELO localhost) ([10.252.38.230])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 09:48:09 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v37 01/24] x86/cpufeatures: x86/msr: Add Intel SGX hardware bits
Date:   Mon, 14 Sep 2020 19:48:05 +0300
Message-Id: <20200914164805.6167-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add X86_FEATURE_SGX from CPUID.(EAX=7, ECX=1), which informs whether the
CPU has SGX.

Add X86_FEATURE_SGX1 and X86_FEATURE_SGX2 from CPUID.(EAX=12H, ECX=0),
which describe the level of SGX support available [1].

Add IA32_FEATURE_CONTROL.SGX_ENABLE. BIOS can use this bit to opt-in SGX
before locking the feature control MSR [2].

[1] Intel SDM: 36.7.2 Intel® SGX Resource Enumeration Leaves
[2] Intel SDM: 36.7.1 Intel® SGX Opt-In Configuration

Reviewed-by: Borislav Petkov <bp@alien8.de>
Acked-by: Jethro Beekman <jethro@fortanix.com>
Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h        |  5 +++--
 arch/x86/include/asm/cpufeatures.h       |  7 ++++++-
 arch/x86/include/asm/disabled-features.h | 18 +++++++++++++++---
 arch/x86/include/asm/msr-index.h         |  1 +
 arch/x86/include/asm/required-features.h |  2 +-
 arch/x86/kernel/cpu/common.c             |  4 ++++
 6 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 59bf91c57aa8..efbdba5170a3 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -30,6 +30,7 @@ enum cpuid_leafs
 	CPUID_7_ECX,
 	CPUID_8000_0007_EBX,
 	CPUID_7_EDX,
+	CPUID_12_EAX,
 };
 
 #ifdef CONFIG_X86_FEATURE_NAMES
@@ -89,7 +90,7 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
 	   REQUIRED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
 
 #define DISABLED_MASK_BIT_SET(feature_bit)				\
 	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
@@ -112,7 +113,7 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
 	   DISABLED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
 
 #define cpu_has(c, bit)							\
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 2901d5df4366..159b635159c0 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -13,7 +13,7 @@
 /*
  * Defines x86 CPU feature bits
  */
-#define NCAPINTS			19	   /* N 32-bit words worth of info */
+#define NCAPINTS			20	   /* N 32-bit words worth of info */
 #define NBUGINTS			1	   /* N 32-bit bug flags */
 
 /*
@@ -240,6 +240,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
 #define X86_FEATURE_TSC_ADJUST		( 9*32+ 1) /* TSC adjustment MSR 0x3B */
+#define X86_FEATURE_SGX			( 9*32+ 2) /* Software Guard Extensions */
 #define X86_FEATURE_BMI1		( 9*32+ 3) /* 1st group bit manipulation extensions */
 #define X86_FEATURE_HLE			( 9*32+ 4) /* Hardware Lock Elision */
 #define X86_FEATURE_AVX2		( 9*32+ 5) /* AVX2 instructions */
@@ -377,6 +378,10 @@
 #define X86_FEATURE_CORE_CAPABILITIES	(18*32+30) /* "" IA32_CORE_CAPABILITIES MSR */
 #define X86_FEATURE_SPEC_CTRL_SSBD	(18*32+31) /* "" Speculative Store Bypass Disable */
 
+/* Intel-defined SGX features, CPUID level 0x00000012:0 (EAX), word 19 */
+#define X86_FEATURE_SGX1		(19*32+ 0) /* SGX1 leaf functions */
+#define X86_FEATURE_SGX2		(19*32+ 1) /* SGX2 leaf functions */
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 4ea8584682f9..dbe534d5153f 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -28,13 +28,18 @@
 # define DISABLE_CYRIX_ARR	(1<<(X86_FEATURE_CYRIX_ARR & 31))
 # define DISABLE_CENTAUR_MCR	(1<<(X86_FEATURE_CENTAUR_MCR & 31))
 # define DISABLE_PCID		0
+# define DISABLE_SGX1		0
+# define DISABLE_SGX2		0
 #else
 # define DISABLE_VME		0
 # define DISABLE_K6_MTRR	0
 # define DISABLE_CYRIX_ARR	0
 # define DISABLE_CENTAUR_MCR	0
 # define DISABLE_PCID		(1<<(X86_FEATURE_PCID & 31))
-#endif /* CONFIG_X86_64 */
+# define DISABLE_SGX1		(1<<(X86_FEATURE_SGX1 & 31))
+# define DISABLE_SGX2		(1<<(X86_FEATURE_SGX2 & 31))
+ #endif /* CONFIG_X86_64 */
+
 
 #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
 # define DISABLE_PKU		0
@@ -56,6 +61,12 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
+#ifdef CONFIG_INTEL_SGX
+# define DISABLE_SGX	0
+#else
+# define DISABLE_SGX	(1 << (X86_FEATURE_SGX & 31))
+#endif
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -68,7 +79,7 @@
 #define DISABLED_MASK6	0
 #define DISABLED_MASK7	(DISABLE_PTI)
 #define DISABLED_MASK8	0
-#define DISABLED_MASK9	(DISABLE_SMAP)
+#define DISABLED_MASK9	(DISABLE_SMAP|DISABLE_SGX)
 #define DISABLED_MASK10	0
 #define DISABLED_MASK11	0
 #define DISABLED_MASK12	0
@@ -78,6 +89,7 @@
 #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
-#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define DISABLED_MASK19	(DISABLE_SGX1|DISABLE_SGX2)
+#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 2859ee4f39a8..c0b04f020162 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -602,6 +602,7 @@
 #define FEAT_CTL_LOCKED				BIT(0)
 #define FEAT_CTL_VMX_ENABLED_INSIDE_SMX		BIT(1)
 #define FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX	BIT(2)
+#define FEAT_CTL_SGX_ENABLED			BIT(18)
 #define FEAT_CTL_LMCE_ENABLED			BIT(20)
 
 #define MSR_IA32_TSC_ADJUST             0x0000003b
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index 6847d85400a8..039e58be2fe6 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -101,6 +101,6 @@
 #define REQUIRED_MASK16	0
 #define REQUIRED_MASK17	0
 #define REQUIRED_MASK18	0
-#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c5d6f17d9b9d..ccd9a11d5d1a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -931,6 +931,10 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[CPUID_D_1_EAX] = eax;
 	}
 
+	/* Additional Intel-defined SGX flags: level 0x00000012 */
+	if (c->cpuid_level >= 0x00000012)
+		c->x86_capability[CPUID_12_EAX] = cpuid_eax(0x00000012);
+
 	/* AMD-defined flags: level 0x80000001 */
 	eax = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = eax;
-- 
2.25.1

