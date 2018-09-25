From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Reinette
 Chatre <reinette.chatre@intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND        64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v14 10/19] x86/sgx: Detect Intel SGX
Date: Tue, 25 Sep 2018 16:06:47 +0300
Message-ID: <20180925130845.9962-11-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
Sender: <linux-kernel-owner@vger.kernel.org>
Content-Type: text/plain
Return-Path: linux-kernel-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

From: Sean Christopherson <sean.j.christopherson@intel.com>

Intel(R) SGX is a set of CPU instructions that can be used by applications
to set aside private regions of code and data. The code outside the enclave
is disallowed to access the memory inside the enclave by the CPU access
control.

Add a check for SGX to arch/x86 and a new config option, INTEL_SGX_CORE.
Expose a boolean variable 'sgx_enabled' to query whether or not the SGX
support is available.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/Kconfig                | 17 +++++++++++++
 arch/x86/include/asm/sgx.h      | 13 ++++++++++
 arch/x86/kernel/cpu/Makefile    |  1 +
 arch/x86/kernel/cpu/intel_sgx.c | 44 +++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+)
 create mode 100644 arch/x86/include/asm/sgx.h
 create mode 100644 arch/x86/kernel/cpu/intel_sgx.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1a0be022f91d..b47e1a144409 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1913,6 +1913,23 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+config INTEL_SGX_CORE
+	bool "Intel SGX core functionality"
+	depends on X86_64 && CPU_SUP_INTEL
+	help
+	Intel Software Guard eXtensions (SGX) CPU feature that allows ring 3
+	applications to create enclaves: private regions of memory that are
+	architecturally protected from unauthorized access and/or modification.
+
+	This option enables kernel recognition of SGX, high-level management
+	of the Enclave Page Cache (EPC), tracking and writing of SGX Launch
+	Enclave Hash MSRs, and allows for virtualization of SGX via KVM. By
+	itself, this option does not provide SGX support to userspace.
+
+	For details, see Documentation/x86/intel_sgx.rst
+
+	If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
new file mode 100644
index 000000000000..f4f82f0453a9
--- /dev/null
+++ b/arch/x86/include/asm/sgx.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+/**
+ * Copyright(c) 2016-18 Intel Corporation.
+ */
+#ifndef _ASM_X86_SGX_H
+#define _ASM_X86_SGX_H
+
+#include <linux/types.h>
+
+extern bool sgx_enabled;
+extern bool sgx_lc_enabled;
+
+#endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 347137e80bf5..71876f2b35fc 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 obj-$(CONFIG_INTEL_RDT)	+= intel_rdt.o intel_rdt_rdtgroup.o intel_rdt_monitor.o
 obj-$(CONFIG_INTEL_RDT)	+= intel_rdt_ctrlmondata.o intel_rdt_pseudo_lock.o
 CFLAGS_intel_rdt_pseudo_lock.o = -I$(src)
+obj-$(CONFIG_INTEL_SGX_CORE)		+= intel_sgx.o
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
diff --git a/arch/x86/kernel/cpu/intel_sgx.c b/arch/x86/kernel/cpu/intel_sgx.c
new file mode 100644
index 000000000000..138af9b9a39a
--- /dev/null
+++ b/arch/x86/kernel/cpu/intel_sgx.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-17 Intel Corporation.
+
+#include <linux/freezer.h>
+#include <linux/highmem.h>
+#include <linux/kthread.h>
+#include <linux/pagemap.h>
+#include <linux/ratelimit.h>
+#include <linux/sched/signal.h>
+#include <linux/slab.h>
+#include <asm/sgx.h>
+
+bool sgx_enabled __ro_after_init;
+EXPORT_SYMBOL_GPL(sgx_enabled);
+bool sgx_lc_enabled __ro_after_init;
+EXPORT_SYMBOL_GPL(sgx_lc_enabled);
+
+static __init int sgx_init(void)
+{
+	unsigned long fc;
+
+	if (!boot_cpu_has(X86_FEATURE_SGX))
+		return false;
+
+	if (!boot_cpu_has(X86_FEATURE_SGX1))
+		return false;
+
+	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
+	if (!(fc & FEATURE_CONTROL_LOCKED)) {
+		pr_err("sgx: IA32_FEATURE_CONTROL MSR not locked\n");
+		return false;
+	}
+
+	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
+		pr_info("sgx: disabled by the firmware\n");
+		return false;
+	}
+
+	sgx_enabled = true;
+	sgx_lc_enabled = !!(fc & FEATURE_CONTROL_SGX_LE_WR);
+	return 0;
+}
+
+arch_initcall(sgx_init);
-- 
2.17.1
