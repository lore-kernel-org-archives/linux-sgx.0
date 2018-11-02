From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, <andriy.shevchenko@linux.intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Konrad Rzeszutek Wilk
	<konrad.wilk@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>, "Kirill A.
 Shutemov" <kirill.shutemov@linux.intel.com>, David Wang
	<davidwang@zhaoxin.com>, "Levin, Alexander (Sasha Levin)"
	<alexander.levin@verizon.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: [PATCH v15 14/23] x86/cpu/intel: Clear SGX_LC capability if not enabled in FEATURE_CONTROL
Date: Sat, 3 Nov 2018 01:11:13 +0200
Message-ID: <20181102231320.29164-15-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

From: Sean Christopherson <sean.j.christopherson@intel.com>

Like SGX itself, SGX Launch Control must be explicitly enabled via a
flag in IA32_FEATURE_CONTROL.  Clear the SGX_LC capability if Launch
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
---
 arch/x86/kernel/cpu/intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 9bf8fe2c04ac..bc52c52f7025 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -618,6 +618,8 @@ static void detect_sgx(struct cpuinfo_x86 *c)
 		setup_clear_cpu_cap(X86_FEATURE_SGX1);
 		setup_clear_cpu_cap(X86_FEATURE_SGX2);
 	}
+	if (unsupported || !(fc & FEATURE_CONTROL_SGX_LE_WR))
+		setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
 }
 
 static void init_intel_energy_perf(struct cpuinfo_x86 *c)
-- 
2.19.1
