Return-Path: <SRS0=ya8l=ZV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5544C43215
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Nov 2019 23:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83B7724249
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Nov 2019 23:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfK2XOD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Nov 2019 18:14:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:60529 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbfK2XOD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 29 Nov 2019 18:14:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Nov 2019 15:14:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,259,1571727600"; 
   d="scan'208";a="384193694"
Received: from gamanzi-mobl4.ger.corp.intel.com (HELO localhost) ([10.252.3.126])
  by orsmga005.jf.intel.com with ESMTP; 29 Nov 2019 15:13:53 -0800
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
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v24 02/24] x86/cpufeatures: x86/msr: Add Intel SGX hardware bits
Date:   Sat, 30 Nov 2019 01:13:04 +0200
Message-Id: <20191129231326.18076-3-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
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
 arch/x86/include/asm/cpufeatures.h       | 23 +++++++++++++++++------
 arch/x86/include/asm/disabled-features.h | 14 ++++++++++++--
 arch/x86/include/asm/msr-index.h         |  1 +
 arch/x86/kernel/cpu/scattered.c          |  2 ++
 tools/arch/x86/include/asm/cpufeatures.h | 21 +++++++++++++++------
 5 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 0652d3eed9bd..0872fec45534 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -221,12 +221,22 @@
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
 #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
 
-/* Virtualization flags: Linux defined, word 8 */
-#define X86_FEATURE_TPR_SHADOW		( 8*32+ 0) /* Intel TPR Shadow */
-#define X86_FEATURE_VNMI		( 8*32+ 1) /* Intel Virtual NMI */
-#define X86_FEATURE_FLEXPRIORITY	( 8*32+ 2) /* Intel FlexPriority */
-#define X86_FEATURE_EPT			( 8*32+ 3) /* Intel Extended Page Table */
-#define X86_FEATURE_VPID		( 8*32+ 4) /* Intel Virtual Processor ID */
+/*
+ * Scattered Intel features: Linux defined, word 8.
+ *
+ * Note that the bit location of the SGX features is meaningful as KVM expects
+ * the Linux defined bit to match the Intel defined bit, e.g. X86_FEATURE_SGX1
+ * must remain at bit 0, SGX2 at bit 1, etc...
+ */
+#define X86_FEATURE_SGX1		( 8*32+ 0) /* SGX1 leaf functions */
+#define X86_FEATURE_SGX2		( 8*32+ 1) /* SGX2 leaf functions */
+/* Bits [0:7] are reserved for SGX */
+
+#define X86_FEATURE_TPR_SHADOW		( 8*32+ 8) /* Intel TPR Shadow */
+#define X86_FEATURE_VNMI		( 8*32+ 9) /* Intel Virtual NMI */
+#define X86_FEATURE_FLEXPRIORITY	( 8*32+10) /* Intel FlexPriority */
+#define X86_FEATURE_EPT			( 8*32+11) /* Intel Extended Page Table */
+#define X86_FEATURE_VPID		( 8*32+12) /* Intel Virtual Processor ID */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
@@ -237,6 +247,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
 #define X86_FEATURE_TSC_ADJUST		( 9*32+ 1) /* TSC adjustment MSR 0x3B */
+#define X86_FEATURE_SGX			( 9*32+ 2) /* Software Guard Extensions */
 #define X86_FEATURE_BMI1		( 9*32+ 3) /* 1st group bit manipulation extensions */
 #define X86_FEATURE_HLE			( 9*32+ 4) /* Hardware Lock Elision */
 #define X86_FEATURE_AVX2		( 9*32+ 5) /* AVX2 instructions */
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index a5ea841cc6d2..926f9dc4d75a 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -34,12 +34,16 @@
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
+# define DISABLE_SGX1		(1<<(X86_FEATURE_SGX1 & 31))
+# define DISABLE_SGX2		(1<<(X86_FEATURE_SGX2 & 31))
 #endif /* CONFIG_X86_64 */
 
 #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
@@ -62,6 +66,12 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
+#ifdef CONFIG_INTEL_SGX
+# define DISABLE_SGX_CORE	0
+#else
+# define DISABLE_SGX_CORE	(1 << (X86_FEATURE_SGX & 31))
+#endif
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -73,8 +83,8 @@
 #define DISABLED_MASK5	0
 #define DISABLED_MASK6	0
 #define DISABLED_MASK7	(DISABLE_PTI)
-#define DISABLED_MASK8	0
-#define DISABLED_MASK9	(DISABLE_MPX|DISABLE_SMAP)
+#define DISABLED_MASK8	(DISABLE_SGX1|DISABLE_SGX2)
+#define DISABLED_MASK9	(DISABLE_MPX|DISABLE_SMAP|DISABLE_SGX_CORE)
 #define DISABLED_MASK10	0
 #define DISABLED_MASK11	0
 #define DISABLED_MASK12	0
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 20ce682a2540..975a957a791a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -551,6 +551,7 @@
 #define FEATURE_CONTROL_LOCKED				(1<<0)
 #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
 #define FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX	(1<<2)
+#define FEATURE_CONTROL_SGX_ENABLE			(1<<18)
 #define FEATURE_CONTROL_LMCE				(1<<20)
 
 #define MSR_IA32_APICBASE		0x0000001b
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index adf9b71386ef..9aea45c0b494 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -35,6 +35,8 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CDP_L3,		CPUID_ECX,  2, 0x00000010, 1 },
 	{ X86_FEATURE_CDP_L2,		CPUID_ECX,  2, 0x00000010, 2 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  3, 0x00000010, 0 },
+	{ X86_FEATURE_SGX1,             CPUID_EAX,  0, 0x00000012, 0 },
+	{ X86_FEATURE_SGX2,             CPUID_EAX,  1, 0x00000012, 0 },
 	{ X86_FEATURE_HW_PSTATE,	CPUID_EDX,  7, 0x80000007, 0 },
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 0652d3eed9bd..ed691ada4244 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -221,12 +221,21 @@
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
 #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
 
-/* Virtualization flags: Linux defined, word 8 */
-#define X86_FEATURE_TPR_SHADOW		( 8*32+ 0) /* Intel TPR Shadow */
-#define X86_FEATURE_VNMI		( 8*32+ 1) /* Intel Virtual NMI */
-#define X86_FEATURE_FLEXPRIORITY	( 8*32+ 2) /* Intel FlexPriority */
-#define X86_FEATURE_EPT			( 8*32+ 3) /* Intel Extended Page Table */
-#define X86_FEATURE_VPID		( 8*32+ 4) /* Intel Virtual Processor ID */
+/*
+ * Scattered Intel features: Linux defined, word 8.
+ *
+ * Note that the bit numbers of the SGX features are meaningful as KVM expects
+ * the Linux defined bit to match the Intel defined bit, e.g. X86_FEATURE_SGX1
+ * must remain at bit 0, SGX2 at bit 1, etc...
+ */
+#define X86_FEATURE_SGX1		( 8*32+ 0) /* SGX1 leaf functions */
+#define X86_FEATURE_SGX2		( 8*32+ 1) /* SGX2 leaf functions */
+
+#define X86_FEATURE_TPR_SHADOW		( 8*32+ 8) /* Intel TPR Shadow */
+#define X86_FEATURE_VNMI		( 8*32+ 9) /* Intel Virtual NMI */
+#define X86_FEATURE_FLEXPRIORITY	( 8*32+10) /* Intel FlexPriority */
+#define X86_FEATURE_EPT			( 8*32+11) /* Intel Extended Page Table */
+#define X86_FEATURE_VPID		( 8*32+12) /* Intel Virtual Processor ID */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
-- 
2.20.1

