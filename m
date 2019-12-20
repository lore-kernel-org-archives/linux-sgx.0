Return-Path: <SRS0=2o92=2K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5F3C43603
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Dec 2019 23:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 878F520866
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Dec 2019 23:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbfLTXIc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Dec 2019 18:08:32 -0500
Received: from mga07.intel.com ([134.134.136.100]:5252 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbfLTXIc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Dec 2019 18:08:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 15:08:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,337,1571727600"; 
   d="scan'208";a="222575368"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 20 Dec 2019 15:08:31 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25] x86/sgx: Move SGX sub-feature bits to their own word
Date:   Fri, 20 Dec 2019 15:08:29 -0800
Message-Id: <20191220230829.24047-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

As requested by Boris, move the CPUID 0x12 features to their own word in
cpufeatures.

This can be squashed cleanly with commit c3eac55d3882 ("x86/cpufeatures:
x86/msr: Add Intel SGX hardware bits"), replacing paragraph

  Remap CPUID.(EAX=12H, ECX=0) bits to the Linux fake CPUID 8 in order to
  conserve some space. Keep the bit positions intact because KVM requires
  this. Reserve bits 0-7 for SGX in order to maintain this invariant also
  when new SGX specific feature bits get added.

with

  Add the SGX sub-features in a new word even though only two bits will be
  used in the immediate future.  KVM support for SGX is expected in the
  not-too-distant future, and having a dedicated feature word allows KVM
  to include SGX sub-features in its reserve-cpuid lookup table, e.g. to
  easily query guest CPUID capabilities.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/cpufeature.h        |  5 +++--
 arch/x86/include/asm/cpufeatures.h       | 28 ++++++++++--------------
 arch/x86/include/asm/disabled-features.h | 12 +++++-----
 arch/x86/include/asm/required-features.h |  2 +-
 arch/x86/kernel/cpu/common.c             |  4 ++++
 arch/x86/kernel/cpu/scattered.c          |  2 --
 tools/arch/x86/include/asm/cpufeatures.h | 28 ++++++++++--------------
 7 files changed, 38 insertions(+), 43 deletions(-)

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
index 71ccc14511f9..421cd5e0a76a 100644
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
@@ -221,22 +221,12 @@
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
 #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
 
-/*
- * Scattered Intel features: Linux defined, word 8.
- *
- * Note that the bit location of the SGX features is meaningful as KVM expects
- * the Linux defined bit to match the Intel defined bit, e.g. X86_FEATURE_SGX1
- * must remain at bit 0, SGX2 at bit 1, etc...
- */
-#define X86_FEATURE_SGX1		( 8*32+ 0) /* SGX1 leaf functions */
-#define X86_FEATURE_SGX2		( 8*32+ 1) /* SGX2 leaf functions */
-/* Bits [0:7] are reserved for SGX */
-
-#define X86_FEATURE_TPR_SHADOW		( 8*32+ 8) /* Intel TPR Shadow */
-#define X86_FEATURE_VNMI		( 8*32+ 9) /* Intel Virtual NMI */
-#define X86_FEATURE_FLEXPRIORITY	( 8*32+10) /* Intel FlexPriority */
-#define X86_FEATURE_EPT			( 8*32+11) /* Intel Extended Page Table */
-#define X86_FEATURE_VPID		( 8*32+12) /* Intel Virtual Processor ID */
+/* Virtualization flags: Linux defined, word 8 */
+#define X86_FEATURE_TPR_SHADOW		( 8*32+ 0) /* Intel TPR Shadow */
+#define X86_FEATURE_VNMI		( 8*32+ 1) /* Intel Virtual NMI */
+#define X86_FEATURE_FLEXPRIORITY	( 8*32+ 2) /* Intel FlexPriority */
+#define X86_FEATURE_EPT			( 8*32+ 3) /* Intel Extended Page Table */
+#define X86_FEATURE_VPID		( 8*32+ 4) /* Intel Virtual Processor ID */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
@@ -378,6 +368,10 @@
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
index 926f9dc4d75a..c4c6d6908597 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -44,7 +44,8 @@
 # define DISABLE_PCID		(1<<(X86_FEATURE_PCID & 31))
 # define DISABLE_SGX1		(1<<(X86_FEATURE_SGX1 & 31))
 # define DISABLE_SGX2		(1<<(X86_FEATURE_SGX2 & 31))
-#endif /* CONFIG_X86_64 */
+ #endif /* CONFIG_X86_64 */
+
 
 #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
 # define DISABLE_PKU		0
@@ -67,9 +68,9 @@
 #endif
 
 #ifdef CONFIG_INTEL_SGX
-# define DISABLE_SGX_CORE	0
+# define DISABLE_SGX_CORE      0
 #else
-# define DISABLE_SGX_CORE	(1 << (X86_FEATURE_SGX & 31))
+# define DISABLE_SGX_CORE      (1 << (X86_FEATURE_SGX & 31))
 #endif
 
 /*
@@ -83,7 +84,7 @@
 #define DISABLED_MASK5	0
 #define DISABLED_MASK6	0
 #define DISABLED_MASK7	(DISABLE_PTI)
-#define DISABLED_MASK8	(DISABLE_SGX1|DISABLE_SGX2)
+#define DISABLED_MASK8	0
 #define DISABLED_MASK9	(DISABLE_MPX|DISABLE_SMAP|DISABLE_SGX_CORE)
 #define DISABLED_MASK10	0
 #define DISABLED_MASK11	0
@@ -94,6 +95,7 @@
 #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
-#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define DISABLED_MASK19	(DISABLE_SGX1|DISABLE_SGX2)
+#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
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
index 9ae7d1bcd4f4..dcc1df88b289 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -933,6 +933,10 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[CPUID_D_1_EAX] = eax;
 	}
 
+	/* Additional Intel-defined SGX flags: level 0x00000012 */
+	if (c->cpuid_level >= 0x00000012)
+		c->x86_capability[CPUID_12_EAX] = cpuid_eax(0x00000012);
+
 	/* AMD-defined flags: level 0x80000001 */
 	eax = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = eax;
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 9aea45c0b494..adf9b71386ef 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -35,8 +35,6 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CDP_L3,		CPUID_ECX,  2, 0x00000010, 1 },
 	{ X86_FEATURE_CDP_L2,		CPUID_ECX,  2, 0x00000010, 2 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  3, 0x00000010, 0 },
-	{ X86_FEATURE_SGX1,             CPUID_EAX,  0, 0x00000012, 0 },
-	{ X86_FEATURE_SGX2,             CPUID_EAX,  1, 0x00000012, 0 },
 	{ X86_FEATURE_HW_PSTATE,	CPUID_EDX,  7, 0x80000007, 0 },
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index ed691ada4244..a27a977ed2f8 100644
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
@@ -221,21 +221,12 @@
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
 #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
 
-/*
- * Scattered Intel features: Linux defined, word 8.
- *
- * Note that the bit numbers of the SGX features are meaningful as KVM expects
- * the Linux defined bit to match the Intel defined bit, e.g. X86_FEATURE_SGX1
- * must remain at bit 0, SGX2 at bit 1, etc...
- */
-#define X86_FEATURE_SGX1		( 8*32+ 0) /* SGX1 leaf functions */
-#define X86_FEATURE_SGX2		( 8*32+ 1) /* SGX2 leaf functions */
-
-#define X86_FEATURE_TPR_SHADOW		( 8*32+ 8) /* Intel TPR Shadow */
-#define X86_FEATURE_VNMI		( 8*32+ 9) /* Intel Virtual NMI */
-#define X86_FEATURE_FLEXPRIORITY	( 8*32+10) /* Intel FlexPriority */
-#define X86_FEATURE_EPT			( 8*32+11) /* Intel Extended Page Table */
-#define X86_FEATURE_VPID		( 8*32+12) /* Intel Virtual Processor ID */
+/* Virtualization flags: Linux defined, word 8 */
+#define X86_FEATURE_TPR_SHADOW		( 8*32+ 0) /* Intel TPR Shadow */
+#define X86_FEATURE_VNMI		( 8*32+ 1) /* Intel Virtual NMI */
+#define X86_FEATURE_FLEXPRIORITY	( 8*32+ 2) /* Intel FlexPriority */
+#define X86_FEATURE_EPT			( 8*32+ 3) /* Intel Extended Page Table */
+#define X86_FEATURE_VPID		( 8*32+ 4) /* Intel Virtual Processor ID */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
@@ -246,6 +237,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
 #define X86_FEATURE_TSC_ADJUST		( 9*32+ 1) /* TSC adjustment MSR 0x3B */
+#define X86_FEATURE_SGX			( 9*32+ 2) /* Software Guard Extensions */
 #define X86_FEATURE_BMI1		( 9*32+ 3) /* 1st group bit manipulation extensions */
 #define X86_FEATURE_HLE			( 9*32+ 4) /* Hardware Lock Elision */
 #define X86_FEATURE_AVX2		( 9*32+ 5) /* AVX2 instructions */
@@ -375,6 +367,10 @@
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
2.24.1

