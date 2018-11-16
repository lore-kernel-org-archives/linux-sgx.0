Return-Path: <SRS0=Qwf+=N3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402A7C43441
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 01:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE5FA2146D
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 01:07:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE5FA2146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbeKPLRf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Nov 2018 06:17:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:51252 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbeKPLRf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Nov 2018 06:17:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2018 17:07:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,238,1539673200"; 
   d="scan'208";a="280385992"
Received: from sfhansen-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.254.82])
  by fmsmga005.fm.intel.com with ESMTP; 15 Nov 2018 17:07:11 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Pu Wen <puwen@hygon.cn>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH v17 15/23] x86/sgx: Enumerate and track EPC sections
Date:   Fri, 16 Nov 2018 03:01:22 +0200
Message-Id: <20181116010412.23967-16-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Enumerate Enclave Page Cache (EPC) sections via CPUID and add the data
structures necessary to track EPC pages so that they can be allocated,
freed and managed.  As a system may have multiple EPC sections, invoke
CPUID on SGX sub-leafs until an invalid leaf is encountered.

On NUMA systems, a node can have at most one bank. A bank can be at
most part of two nodes.  SGX supports both nodes with a single memory
controller and also sub-cluster nodes with severals memory controllers
on a single die.

For simplicity, support a maximum of eight EPC sections.  Current
client hardware supports only a single section, while upcoming server
hardware will support at most eight sections.  Bounding the number of
sections also allows the section ID to be embedded along with a page's
offset in a single unsigned long, enabling easy retrieval of both the
VA and PA for a given page.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
---
 arch/x86/Kconfig                |  17 ++++
 arch/x86/include/asm/sgx.h      |  58 +++++++++++++
 arch/x86/kernel/cpu/Makefile    |   1 +
 arch/x86/kernel/cpu/intel_sgx.c | 146 ++++++++++++++++++++++++++++++++
 4 files changed, 222 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/intel_sgx.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9d734f3c8234..4c3a325351ce 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1919,6 +1919,23 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
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
index 3d5ba1d23dfb..efe3e213e582 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -2,9 +2,67 @@
 #ifndef _ASM_X86_SGX_H
 #define _ASM_X86_SGX_H
 
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/rwsem.h>
+#include <linux/types.h>
 #include <asm/asm.h>
 #include <asm/sgx_arch.h>
 
+struct sgx_epc_page {
+	unsigned long desc;
+	struct list_head list;
+};
+
+/**
+ * struct sgx_epc_section
+ *
+ * The firmware can define multiple chunks of EPC to the different areas of the
+ * physical memory e.g. for memory areas of the each node. This structure is
+ * used to store EPC pages for one EPC section and virtual memory area where
+ * the pages have been mapped.
+ */
+struct sgx_epc_section {
+	unsigned long pa;
+	void *va;
+	struct sgx_epc_page **pages;
+	unsigned long free_cnt;
+	spinlock_t lock;
+};
+
+#define SGX_MAX_EPC_SECTIONS	8
+
+extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+
+/**
+ * enum sgx_epc_page_desc - bits and masks for an EPC page's descriptor
+ * %SGX_EPC_SECTION_MASK:	SGX allows to have multiple EPC sections in the
+ *				physical memory. The existing and near-future
+ *				hardware defines at most eight sections, hence
+ *				three bits to hold a section.
+ * %SGX_EPC_PAGE_RECLAIMABLE:	The page page is reclaimable. Used when freeing
+ *				a page to know that we also need to remove the
+ *				page from the list of reclaimable pages.
+ */
+enum sgx_epc_page_desc {
+	SGX_EPC_SECTION_MASK			= GENMASK_ULL(3, 0),
+	SGX_EPC_PAGE_RECLAIMABLE		= BIT(4),
+	/* bits 12-63 are reserved for the physical page address of the page */
+};
+
+static inline struct sgx_epc_section *sgx_epc_section(struct sgx_epc_page *page)
+{
+	return &sgx_epc_sections[page->desc & SGX_EPC_SECTION_MASK];
+}
+
+static inline void *sgx_epc_addr(struct sgx_epc_page *page)
+{
+	struct sgx_epc_section *section = sgx_epc_section(page);
+
+	return section->va + (page->desc & PAGE_MASK) - section->pa;
+}
+
 /**
  * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
  *
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 1f5d2291c31e..b496c9360b88 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 obj-$(CONFIG_INTEL_RDT)	+= intel_rdt.o intel_rdt_rdtgroup.o intel_rdt_monitor.o
 obj-$(CONFIG_INTEL_RDT)	+= intel_rdt_ctrlmondata.o intel_rdt_pseudo_lock.o
 CFLAGS_intel_rdt_pseudo_lock.o = -I$(src)
+obj-$(CONFIG_INTEL_SGX_CORE)		+= intel_sgx.o
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
diff --git a/arch/x86/kernel/cpu/intel_sgx.c b/arch/x86/kernel/cpu/intel_sgx.c
new file mode 100644
index 000000000000..bfdf907c5d94
--- /dev/null
+++ b/arch/x86/kernel/cpu/intel_sgx.c
@@ -0,0 +1,146 @@
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
+struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+EXPORT_SYMBOL_GPL(sgx_epc_sections);
+
+static int sgx_nr_epc_sections;
+
+static __init void sgx_free_epc_section(struct sgx_epc_section *section)
+{
+	int i;
+
+	if (section->pages) {
+		for (i = 0; i < section->free_cnt && section->pages[i]; i++)
+			kfree(section->pages[i]);
+		kfree(section->pages);
+	}
+	memunmap(section->va);
+}
+
+static __init int sgx_init_epc_section(u64 addr, u64 size, unsigned long index,
+				       struct sgx_epc_section *section)
+{
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	unsigned long i;
+
+	section->va = memremap(addr, size, MEMREMAP_WB);
+	if (!section->va)
+		return -ENOMEM;
+
+	section->pa = addr;
+	section->free_cnt = nr_pages;
+	spin_lock_init(&section->lock);
+
+	section->pages = kcalloc(nr_pages, sizeof(struct sgx_epc_page *),
+				 GFP_KERNEL);
+	if (!section->pages) {
+		pr_warn("sgx: EPC section allocation failed\n");
+		goto out;
+	}
+
+	for (i = 0; i < nr_pages; i++) {
+		section->pages[i] = kzalloc(sizeof(struct sgx_epc_page),
+					    GFP_KERNEL);
+		if (!section->pages[i])
+			goto out;
+
+		section->pages[i]->desc = (addr + (i << PAGE_SHIFT)) | index;
+	}
+
+	return 0;
+out:
+	sgx_free_epc_section(section);
+	return -ENOMEM;
+}
+
+static __init void sgx_page_cache_teardown(void)
+{
+	int i;
+
+	for (i = 0; i < sgx_nr_epc_sections; i++)
+		sgx_free_epc_section(&sgx_epc_sections[i]);
+}
+
+/**
+ * A section metric is concatenated in a way that @low bits 12-31 define the
+ * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
+ * metric.
+ */
+static inline u64 sgx_calc_section_metric(u64 low, u64 high)
+{
+	return (low & GENMASK_ULL(31, 12)) +
+	       ((high & GENMASK_ULL(19, 0)) << 32);
+}
+
+static __init int sgx_page_cache_init(void)
+{
+	u32 eax, ebx, ecx, edx, type;
+	u64 pa, size;
+	int ret;
+	int i;
+
+	BUILD_BUG_ON(SGX_MAX_EPC_SECTIONS > (SGX_EPC_SECTION_MASK + 1));
+
+	for (i = 0; i < (SGX_MAX_EPC_SECTIONS + 1); i++) {
+		cpuid_count(SGX_CPUID, i + SGX_CPUID_FIRST_VARIABLE_SUB_LEAF,
+			    &eax, &ebx, &ecx, &edx);
+
+		type = eax & SGX_CPUID_SUB_LEAF_TYPE_MASK;
+		if (type == SGX_CPUID_SUB_LEAF_INVALID)
+			break;
+		if (type != SGX_CPUID_SUB_LEAF_EPC_SECTION) {
+			pr_err_once("sgx: Unknown sub-leaf type: %u\n", type);
+			return -ENODEV;
+		}
+		if (i == SGX_MAX_EPC_SECTIONS) {
+			pr_warn("sgx: More than " __stringify(SGX_MAX_EPC_SECTIONS)
+				" EPC sections\n");
+			break;
+		}
+
+		pa = sgx_calc_section_metric(eax, ebx);
+		size = sgx_calc_section_metric(ecx, edx);
+		pr_info("sgx: EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
+
+		ret = sgx_init_epc_section(pa, size, i, &sgx_epc_sections[i]);
+		if (ret) {
+			sgx_page_cache_teardown();
+			return ret;
+		}
+
+		sgx_nr_epc_sections++;
+	}
+
+	if (!sgx_nr_epc_sections) {
+		pr_err("sgx: There are zero EPC sections.\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static __init int sgx_init(void)
+{
+	int ret;
+
+	if (!boot_cpu_has(X86_FEATURE_SGX))
+		return false;
+
+	ret = sgx_page_cache_init();
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+arch_initcall(sgx_init);
-- 
2.19.1

