From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, <andriy.shevchenko@linux.intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "Konrad Rzeszutek
 Wilk" <konrad.wilk@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Fenghua Yu <fenghua.yu@intel.com>, Arnaldo Carvalho de Melo
	<acme@redhat.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v15 03/23] x86/cpufeatures: Add SGX sub-features (as Linux-defined bits)
Date: Sat, 3 Nov 2018 01:11:02 +0200
Message-ID: <20181102231320.29164-4-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

From: Sean Christopherson <sean.j.christopherson@intel.com>

CPUID_12_EAX is an Intel-defined feature bits leaf dedicated for SGX
that enumerates the SGX instruction sets that are supported by the
CPU, e.g. SGX1, SGX2, etc...  Because Linux currently only cares about
two bits (SGX1 and SGX2) and there are currently only four documented
bits in total, relocate the bits to Linux-defined word 8 to conserve
space.

But, keep the bit positions identical between the Intel-defined value
and the Linux-defined value, e.g. keep SGX1 at bit 0.  This allows KVM
to use its existing code for probing guest CPUID bits using Linux's
X86_FEATURE_* definitions.  To do so, shift around some existing bits
to effectively reserve bits 0-7 of word 8 for SGX sub-features.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/cpufeatures.h       | 21 +++++++++++++++------
 arch/x86/kernel/cpu/scattered.c          |  2 ++
 tools/arch/x86/include/asm/cpufeatures.h | 21 +++++++++++++++------
 3 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 22271752fd1e..1b8dea9a06cb 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -222,12 +222,21 @@
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
+
+#define X86_FEATURE_TPR_SHADOW		( 8*32+ 8) /* Intel TPR Shadow */
+#define X86_FEATURE_VNMI		( 8*32+ 9) /* Intel Virtual NMI */
+#define X86_FEATURE_FLEXPRIORITY	( 8*32+10) /* Intel FlexPriority */
+#define X86_FEATURE_EPT			( 8*32+11) /* Intel Extended Page Table */
+#define X86_FEATURE_VPID		( 8*32+12) /* Intel Virtual Processor ID */
 
 #define X86_FEATURE_VMMCALL		( 8*32+15) /* Prefer VMMCALL to VMCALL */
 #define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 772c219b6889..f7f0970b8f89 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -26,6 +26,8 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CDP_L3,		CPUID_ECX,  2, 0x00000010, 1 },
 	{ X86_FEATURE_CDP_L2,		CPUID_ECX,  2, 0x00000010, 2 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  3, 0x00000010, 0 },
+	{ X86_FEATURE_SGX1,             CPUID_EAX,  0, 0x00000012, 0 },
+	{ X86_FEATURE_SGX2,             CPUID_EAX,  1, 0x00000012, 0 },
 	{ X86_FEATURE_HW_PSTATE,	CPUID_EDX,  7, 0x80000007, 0 },
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 89a048c2faec..9cc7628b9845 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -222,12 +222,21 @@
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
2.19.1
