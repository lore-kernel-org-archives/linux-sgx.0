From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	"Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	"David Woodhouse" <dwmw@amazon.co.uk>, David Wang <davidwang@zhaoxin.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "Levin, Alexander
 (Sasha Levin)" <alexander.levin@verizon.com>, Jia Zhang
	<qianyue.zj@alibaba-inc.com>, "open list:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: [PATCH v14 04/19] x86/cpufeatures: Add SGX feature bits
Date: Tue, 25 Sep 2018 16:06:41 +0300
Message-ID: <20180925130845.9962-5-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add SGX feature bits as part of the Linux defined leaf 8, which
currently contains virtualization flags.  There are currently four
documented SGX feature bits, with more expected in the not-too-distant
future.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h |  8 +++++-
 arch/x86/kernel/cpu/intel.c        | 40 ++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 7bb647f57d42..d6f4abe6d0b0 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -233,6 +233,12 @@
 #define X86_FEATURE_XENPV		( 8*32+16) /* "" Xen paravirtual guest */
 #define X86_FEATURE_EPT_AD		( 8*32+17) /* Intel Extended Page Table access-dirty bit */
 
+/* SGX flags: Linux defined, word 8 */
+#define X86_FEATURE_SGX1		( 8*32+24) /* SGX1 leaf functions */
+#define X86_FEATURE_SGX2		( 8*32+25) /* SGX2 leaf functions */
+#define X86_FEATURE_SGX_ENCLV		( 8*32+26) /* SGX ENCLV instruction, leafs E[INC|DEC]VIRTCHILD, ESETCONTEXT */
+#define X86_FEATURE_SGX_ENCLS_C		( 8*32+27) /* SGX ENCLS leafs ERDINFO, ETRACK, ELDBC and ELDUC */
+
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
 #define X86_FEATURE_TSC_ADJUST		( 9*32+ 1) /* TSC adjustment MSR 0x3B */
@@ -332,7 +338,7 @@
 #define X86_FEATURE_LA57		(16*32+16) /* 5-level page tables */
 #define X86_FEATURE_RDPID		(16*32+22) /* RDPID instruction */
 #define X86_FEATURE_CLDEMOTE		(16*32+25) /* CLDEMOTE instruction */
-#define X86_FEATURE_SGX_LC		(16*32+30) /* supports SGX launch configuration */
+#define X86_FEATURE_SGX_LC		(16*32+30) /* supports SGX launch control */
 
 /* AMD-defined CPU features, CPUID level 0x80000007 (EBX), word 17 */
 #define X86_FEATURE_OVERFLOW_RECOV	(17*32+ 0) /* MCA overflow recovery support */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index fc3c07fe7df5..fcf188d5f9df 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -19,6 +19,7 @@
 #include <asm/microcode_intel.h>
 #include <asm/hwcap2.h>
 #include <asm/elf.h>
+#include <asm/sgx_arch.h>
 
 #ifdef CONFIG_X86_64
 #include <linux/topology.h>
@@ -512,6 +513,42 @@ static void detect_vmx_virtcap(struct cpuinfo_x86 *c)
 	}
 }
 
+static void detect_sgx(struct cpuinfo_x86 *c)
+{
+#define _X86_FEATURE_SGX1		BIT(0)
+#define _X86_FEATURE_SGX2		BIT(1)
+#define _X86_FEATURE_SGX_ENCLV		BIT(5)
+#define _X86_FEATURE_SGX_ENCLS_C	BIT(6)
+
+	unsigned int eax;
+
+	clear_cpu_cap(c, X86_FEATURE_SGX1);
+	clear_cpu_cap(c, X86_FEATURE_SGX2);
+	clear_cpu_cap(c, X86_FEATURE_SGX_ENCLV);
+	clear_cpu_cap(c, X86_FEATURE_SGX_ENCLS_C);
+
+	if (c->cpuid_level < SGX_CPUID) {
+		pr_err_once("x86/sgx: cannot enumerate CPUID leaf (0x%x)\n",
+			    SGX_CPUID);
+		clear_cpu_cap(c, X86_FEATURE_SGX);
+		return;
+	}
+
+	eax = cpuid_eax(SGX_CPUID);
+
+	if (eax & _X86_FEATURE_SGX1)
+		set_cpu_cap(c, X86_FEATURE_SGX1);
+
+	if (eax & _X86_FEATURE_SGX2)
+		set_cpu_cap(c, X86_FEATURE_SGX2);
+
+	if (eax & _X86_FEATURE_SGX_ENCLV)
+		set_cpu_cap(c, X86_FEATURE_SGX_ENCLV);
+
+	if (eax & _X86_FEATURE_SGX_ENCLS_C)
+		set_cpu_cap(c, X86_FEATURE_SGX_ENCLS_C);
+}
+
 #define MSR_IA32_TME_ACTIVATE		0x982
 
 /* Helpers to access TME_ACTIVATE MSR */
@@ -760,6 +797,9 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
 
+	if (cpu_has(c, X86_FEATURE_SGX))
+		detect_sgx(c);
+
 	if (cpu_has(c, X86_FEATURE_TME))
 		detect_tme(c);
 
-- 
2.17.1
