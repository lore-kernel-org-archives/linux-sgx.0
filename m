Received: from mga05.intel.com ([192.55.52.43]:44601 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S2388191AbeKFXPj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 6
 Nov 2018 18:15:39 -0500
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<andriy.shevchenko@linux.intel.com>, <tglx@linutronix.de>,
	<kai.svahn@intel.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	"David Woodhouse" <dwmw@amazon.co.uk>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, David Wang <davidwang@zhaoxin.com>,
	"Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>, Jia Zhang
	<qianyue.zj@alibaba-inc.com>, "open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)" <linux-kernel@vger.kernel.org>
Subject: [PATCH v16 06/22] x86/cpu/intel: Detect SGX support and update caps appropriately
Date: Tue, 6 Nov 2018 15:45:45 +0200
Message-ID: <20181106134758.10572-7-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
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
(impossible on bare metal, theoretically possible in a VM if the VMM is
doing something weird).

Like SGX itself, SGX Launch Control must be explicitly enabled via a
flag in IA32_FEATURE_CONTROL. Clear the SGX_LC capability if Launch
Control is not fully enabled (or obviously if SGX itself is disabled).

Note that clearing X86_FEATURE_SGX_LC creates a bit of a conundrum
regarding the SGXLEPUBKEYHASH MSRs, as it may be desirable to read the
MSRs even if they are not writable, e.g. to query the configured key,
but clearing the capability leaves no breadcrum for discerning whether
or not the MSRs exist.  But, such usage will be rare (KVM is the only
known case at this time) and not performance critical, so it's not
unreasonable to require the use of rdmsr_safe().  Clearing the cap bit
eliminates the need for an additional flag to track whether or not
Launch Control is truly enabled, which is what we care about the vast
majority of the time.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index fc3c07fe7df5..8a20a193d399 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -596,6 +596,40 @@ static void detect_tme(struct cpuinfo_x86 *c)
 	c->x86_phys_bits -= keyid_bits;
 }
 
+static void detect_sgx(struct cpuinfo_x86 *c)
+{
+	unsigned long long fc;
+
+	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
+	if (!(fc & FEATURE_CONTROL_LOCKED)) {
+		pr_err_once("sgx: IA32_FEATURE_CONTROL MSR is not locked\n");
+		goto out_unsupported;
+	}
+
+	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
+		pr_err_once("sgx: not enabled in IA32_FEATURE_CONTROL MSR\n");
+		goto out_unsupported;
+	}
+
+	if (!cpu_has(c, X86_FEATURE_SGX1)) {
+		pr_err_once("sgx: SGX1 instruction set not supported\n");
+		goto out_unsupported;
+	}
+
+	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
+		pr_info_once("sgx: launch control MSRs are not writable\n");
+		goto out_msrs_rdonly;
+	}
+
+	return;
+out_unsupported:
+	setup_clear_cpu_cap(X86_FEATURE_SGX);
+	setup_clear_cpu_cap(X86_FEATURE_SGX1);
+	setup_clear_cpu_cap(X86_FEATURE_SGX2);
+out_msrs_rdonly:
+	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
+}
+
 static void init_intel_energy_perf(struct cpuinfo_x86 *c)
 {
 	u64 epb;
@@ -763,6 +797,9 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_TME))
 		detect_tme(c);
 
+	if (cpu_has(c, X86_FEATURE_SGX))
+		detect_sgx(c);
+
 	init_intel_energy_perf(c);
 
 	init_intel_misc_features(c);
-- 
2.19.1
