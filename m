Received: from mga03.intel.com ([134.134.136.65]:2203 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726705AbeKCIYA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Sat, 3
 Nov 2018 04:24:00 -0400
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, <andriy.shevchenko@linux.intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "Konrad Rzeszutek
 Wilk" <konrad.wilk@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>, "David
 Wang" <davidwang@zhaoxin.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, "Levin, Alexander (Sasha Levin)"
	<alexander.levin@verizon.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND        64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v15 05/23] x86/cpu/intel: Detect SGX support and update caps appropriately
Date: Sat, 3 Nov 2018 01:11:04 +0200
Message-ID: <20181102231320.29164-6-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Content-Type: text/plain
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

From: Sean Christopherson <sean.j.christopherson@intel.com>

Similar to other large Intel features such as VMX and TXT, SGX must be
explicitly enabled in IA32_FEATURE_CONTROL MSR to be truly usable.
Clear all SGX related capabilities if SGX is not fully enabled in
IA32_FEATURE_CONTROL or if the SGX1 instruction set isn't supported
(impossible on bare metal, theoretically possible in a VM if the VMM
is doing something weird).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index fc3c07fe7df5..9bf8fe2c04ac 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -596,6 +596,30 @@ static void detect_tme(struct cpuinfo_x86 *c)
 	c->x86_phys_bits -= keyid_bits;
 }
 
+static void detect_sgx(struct cpuinfo_x86 *c)
+{
+	bool unsupported = false;
+	unsigned long long fc;
+
+	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
+	if (!(fc & FEATURE_CONTROL_LOCKED)) {
+		pr_err_once("sgx: IA32_FEATURE_CONTROL MSR is not locked\n");
+		unsupported = true;
+	} else if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
+		pr_err_once("sgx: not enabled in IA32_FEATURE_CONTROL MSR\n");
+		unsupported = true;
+	} else if (!cpu_has(c, X86_FEATURE_SGX1)) {
+		pr_err_once("sgx: SGX1 instruction set not supported\n");
+		unsupported = true;
+	}
+
+	if (unsupported) {
+		setup_clear_cpu_cap(X86_FEATURE_SGX);
+		setup_clear_cpu_cap(X86_FEATURE_SGX1);
+		setup_clear_cpu_cap(X86_FEATURE_SGX2);
+	}
+}
+
 static void init_intel_energy_perf(struct cpuinfo_x86 *c)
 {
 	u64 epb;
@@ -763,6 +787,9 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_TME))
 		detect_tme(c);
 
+	if (cpu_has(c, X86_FEATURE_SGX))
+		detect_sgx(c);
+
 	init_intel_energy_perf(c);
 
 	init_intel_misc_features(c);
-- 
2.19.1
