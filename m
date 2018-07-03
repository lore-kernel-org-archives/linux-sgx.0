From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Kai Huang <kai.huang@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Borislav
 Petkov" <bp@suse.de>, David Woodhouse <dwmw@amazon.co.uk>, "Konrad Rzeszutek
 Wilk" <konrad.wilk@oracle.com>, Janakarajan Natarajan
	<Janakarajan.Natarajan@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v12 02/13] x86/sgx: add SGX definitions to cpufeature
Date: Tue, 3 Jul 2018 21:19:47 +0300
Message-ID: <20180703182118.15024-3-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

From: Kai Huang <kai.huang@linux.intel.com>

Added X86_FEATURE_SGX and X86_FEATURE_SGX_LC definitions that define the
bits CPUID level 7 bits for determining whether the CPU supports SGX and
launch configuration other than the Intel proprietary key. If this the
case, IA32_SGXLEPUBKEYHASHn MSRs (0 < n < 4) are available for defining the
root key for enclaves.

Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index fb00a2fca990..54d5269e1b86 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -234,6 +234,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
 #define X86_FEATURE_TSC_ADJUST		( 9*32+ 1) /* TSC adjustment MSR 0x3B */
+#define X86_FEATURE_SGX			( 9*32+ 2) /* Software Guard Extensions */
 #define X86_FEATURE_BMI1		( 9*32+ 3) /* 1st group bit manipulation extensions */
 #define X86_FEATURE_HLE			( 9*32+ 4) /* Hardware Lock Elision */
 #define X86_FEATURE_AVX2		( 9*32+ 5) /* AVX2 instructions */
@@ -327,6 +328,7 @@
 #define X86_FEATURE_LA57		(16*32+16) /* 5-level page tables */
 #define X86_FEATURE_RDPID		(16*32+22) /* RDPID instruction */
 #define X86_FEATURE_CLDEMOTE		(16*32+25) /* CLDEMOTE instruction */
+#define X86_FEATURE_SGX_LC		(16*32+30) /* supports SGX launch configuration */
 
 /* AMD-defined CPU features, CPUID level 0x80000007 (EBX), word 17 */
 #define X86_FEATURE_OVERFLOW_RECOV	(17*32+ 0) /* MCA overflow recovery support */
-- 
2.17.1
