From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<andriy.shevchenko@linux.intel.com>, <tglx@linutronix.de>,
	<kai.svahn@intel.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>, David Woodhouse
	<dwmw@amazon.co.uk>, Matt Turner <mattst88@gmail.com>, "open list:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: [PATCH v16 04/22] x86/msr: Add IA32_FEATURE_CONTROL.SGX_ENABLE definition
Date: Tue, 6 Nov 2018 15:45:43 +0200
Message-ID: <20181106134758.10572-5-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a new IA32_FEATURE_CONTROL bit, SGX_ENABLE, which must be set in
order to execute SGX instructions, i.e. ENCL{S,U,V}.  The existence of
the bit is enumerated by CPUID as X86_FEATURE_SGX.  Like all other
flags in IA32_FEATURE_CONTROL, the MSR must be locked for SGX_ENABLE
to take effect.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4731f0cf97c5..2837f65ac817 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -486,6 +486,7 @@
 #define FEATURE_CONTROL_LOCKED				(1<<0)
 #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
 #define FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX	(1<<2)
+#define FEATURE_CONTROL_SGX_ENABLE			(1<<18)
 #define FEATURE_CONTROL_LMCE				(1<<20)
 
 #define MSR_IA32_APICBASE		0x0000001b
-- 
2.19.1
