Return-Path: <SRS0=ol6i=4L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB18C35666
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Feb 2020 17:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ACF0208C3
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Feb 2020 17:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgBWR0S (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:26:18 -0500
Received: from mga04.intel.com ([192.55.52.120]:37611 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgBWR0S (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 23 Feb 2020 12:26:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Feb 2020 09:26:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,476,1574150400"; 
   d="scan'208";a="229649985"
Received: from ajbergin-mobl.ger.corp.intel.com (HELO localhost) ([10.252.23.203])
  by fmsmga007.fm.intel.com with ESMTP; 23 Feb 2020 09:26:11 -0800
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
Subject: [PATCH v27 01/22] x86/cpufeatures: x86/msr: Add Intel SGX hardware bits
Date:   Sun, 23 Feb 2020 19:25:38 +0200
Message-Id: <20200223172559.6912-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223172559.6912-1-jarkko.sakkinen@linux.intel.com>
References: <20200223172559.6912-1-jarkko.sakkinen@linux.intel.com>
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

Remap CPUID.(EAX=12H, ECX=0) bits to the Linux fake CPUID 8 in order to
conserve some space. Keep the bit positions intact because KVM requires
this. Reserve bits 0-7 for SGX in order to maintain this invariant also
when new SGX specific feature bits get added.

Add IA32_FEATURE_CONTROL_SGX_ENABLE. BIOS can use this bit to opt-in SGX
before locking the feature control MSR [2].

[1] Intel SDM: 36.7.2 Intel® SGX Resource Enumeration Leaves
[2] Intel SDM: 36.7.1 Intel® SGX Opt-In Configuration

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
 tools/arch/x86/include/asm/cpufeatures.h |  7 ++++++-
 7 files changed, 36 insertions(+), 8 deletions(-)

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
index f3327cb56edf..42ae9fb06987 100644
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
@@ -238,6 +238,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
 #define X86_FEATURE_TSC_ADJUST		( 9*32+ 1) /* TSC adjustment MSR 0x3B */
+#define X86_FEATURE_SGX			( 9*32+ 2) /* Software Guard Extensions */
 #define X86_FEATURE_BMI1		( 9*32+ 3) /* 1st group bit manipulation extensions */
 #define X86_FEATURE_HLE			( 9*32+ 4) /* Hardware Lock Elision */
 #define X86_FEATURE_AVX2		( 9*32+ 5) /* AVX2 instructions */
@@ -369,6 +370,10 @@
 #define X86_FEATURE_ARCH_CAPABILITIES	(18*32+29) /* IA32_ARCH_CAPABILITIES MSR (Intel) */
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
index ebe1685e92dd..a5e580097c95 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -564,6 +564,7 @@
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
index 52c9bfbbdb2a..db0c676b2eb0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -915,6 +915,10 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[CPUID_D_1_EAX] = eax;
 	}
 
+	/* Additional Intel-defined SGX flags: level 0x00000012 */
+	if (c->cpuid_level >= 0x00000012)
+		c->x86_capability[CPUID_12_EAX] = cpuid_eax(0x00000012);
+
 	/* AMD-defined flags: level 0x80000001 */
 	eax = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = eax;
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index e9b62498fe75..91f3f37d08bc 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -13,7 +13,7 @@
 /*
  * Defines x86 CPU feature bits
  */
-#define NCAPINTS			19	   /* N 32-bit words worth of info */
+#define NCAPINTS			20	   /* N 32-bit words worth of info */
 #define NBUGINTS			1	   /* N 32-bit bug flags */
 
 /*
@@ -237,6 +237,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
 #define X86_FEATURE_TSC_ADJUST		( 9*32+ 1) /* TSC adjustment MSR 0x3B */
+#define X86_FEATURE_SGX			( 9*32+ 2) /* Software Guard Extensions */
 #define X86_FEATURE_BMI1		( 9*32+ 3) /* 1st group bit manipulation extensions */
 #define X86_FEATURE_HLE			( 9*32+ 4) /* Hardware Lock Elision */
 #define X86_FEATURE_AVX2		( 9*32+ 5) /* AVX2 instructions */
@@ -367,6 +368,10 @@
 #define X86_FEATURE_ARCH_CAPABILITIES	(18*32+29) /* IA32_ARCH_CAPABILITIES MSR (Intel) */
 #define X86_FEATURE_SPEC_CTRL_SSBD	(18*32+31) /* "" Speculative Store Bypass Disable */
 
+/* Intel-defined SGX features, CPUID level 0x00000012:0 (EAX), word 19 */
+#define X86_FEATURE_SGX1		(19*32+ 0) /* SGX1 leaf functions */
+#define X86_FEATURE_SGX2		(19*32+ 1) /* SGX2 leaf functions */
+
 /*
  * BUG word(s)
  */
-- 
2.20.1

