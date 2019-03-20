Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D840BC43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 16:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F6E02146E
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 16:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfCTQYT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 12:24:19 -0400
Received: from mga18.intel.com ([134.134.136.126]:42019 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfCTQYT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 12:24:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 09:23:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="135715117"
Received: from sorenthe-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.203])
  by orsmga003.jf.intel.com with ESMTP; 20 Mar 2019 09:23:37 -0700
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
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v19,RESEND 12/27] x86/sgx: Enumerate and track EPC sections
Date:   Wed, 20 Mar 2019 18:21:04 +0200
Message-Id: <20190320162119.4469-13-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
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
 arch/x86/Kconfig                 |  19 ++++
 arch/x86/kernel/cpu/Makefile     |   1 +
 arch/x86/kernel/cpu/sgx/Makefile |   1 +
 arch/x86/kernel/cpu/sgx/main.c   | 149 +++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h    |  62 +++++++++++++
 5 files changed, 232 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/sgx/Makefile
 create mode 100644 arch/x86/kernel/cpu/sgx/main.c
 create mode 100644 arch/x86/kernel/cpu/sgx/sgx.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c1f9b3cf437c..dc630208003f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1921,6 +1921,25 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+config INTEL_SGX
+	bool "Intel SGX core functionality"
+	depends on X86_64 && CPU_SUP_INTEL
+	help
+
+	Intel(R) SGX is a set of CPU instructions that can be used by
+	applications to set aside private regions of code and data.  The code
+	outside the enclave is disallowed to access the memory inside the
+	enclave by the CPU access control.
+
+	The firmware uses PRMRR registers to reserve an area of physical memory
+	called Enclave Page Cache (EPC). There is a hardware unit in the
+	processor called Memory Encryption Engine. The MEE encrypts and decrypts
+	the EPC pages as they enter and leave the processor package.
+
+	For details, see Documentation/x86/intel_sgx.rst
+
+	If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index cfd24f9f7614..d1163c0fd5d6 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_X86_MCE)			+= mce/
 obj-$(CONFIG_MTRR)			+= mtrr/
 obj-$(CONFIG_MICROCODE)			+= microcode/
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= resctrl/
+obj-$(CONFIG_INTEL_SGX)			+= sgx/
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
 
diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
new file mode 100644
index 000000000000..b666967fd570
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -0,0 +1 @@
+obj-y += main.o
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
new file mode 100644
index 000000000000..18ce4acdd7ef
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -0,0 +1,149 @@
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
+#include "arch.h"
+#include "sgx.h"
+
+struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+EXPORT_SYMBOL_GPL(sgx_epc_sections);
+
+static int sgx_nr_epc_sections;
+
+static void sgx_section_put_page(struct sgx_epc_section *section,
+				 struct sgx_epc_page *page)
+{
+	list_add_tail(&page->list, &section->page_list);
+	section->free_cnt++;
+}
+
+static __init void sgx_free_epc_section(struct sgx_epc_section *section)
+{
+	struct sgx_epc_page *page;
+
+	while (!list_empty(&section->page_list)) {
+		page = list_first_entry(&section->page_list,
+					struct sgx_epc_page, list);
+		list_del(&page->list);
+		kfree(page);
+	}
+	memunmap(section->va);
+}
+
+static __init int sgx_init_epc_section(u64 addr, u64 size, unsigned long index,
+				       struct sgx_epc_section *section)
+{
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	struct sgx_epc_page *page;
+	unsigned long i;
+
+	section->va = memremap(addr, size, MEMREMAP_WB);
+	if (!section->va)
+		return -ENOMEM;
+
+	section->pa = addr;
+	spin_lock_init(&section->lock);
+	INIT_LIST_HEAD(&section->page_list);
+
+	for (i = 0; i < nr_pages; i++) {
+		page = kzalloc(sizeof(*page), GFP_KERNEL);
+		if (!page)
+			goto out;
+		page->desc = (addr + (i << PAGE_SHIFT)) | index;
+		sgx_section_put_page(section, page);
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
+			pr_warn("sgx: More than "
+				__stringify(SGX_MAX_EPC_SECTIONS)
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
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
new file mode 100644
index 000000000000..228e3dae360d
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+#ifndef _X86_SGX_H
+#define _X86_SGX_H
+
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/rwsem.h>
+#include <linux/types.h>
+#include <asm/asm.h>
+#include <uapi/asm/sgx_errno.h>
+
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
+	struct list_head page_list;
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
+ */
+enum sgx_epc_page_desc {
+	SGX_EPC_SECTION_MASK			= GENMASK_ULL(3, 0),
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
+#endif /* _X86_SGX_H */
-- 
2.19.1

