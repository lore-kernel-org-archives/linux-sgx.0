Return-Path: <SRS0=VHel=4U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A5FAC3F2D1
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 23:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B267206DB
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 23:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgCCXhz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 3 Mar 2020 18:37:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:53439 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgCCXhz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 3 Mar 2020 18:37:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 15:37:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="229117374"
Received: from kwasilew-mobl.ger.corp.intel.com (HELO localhost) ([10.251.88.57])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2020 15:37:45 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Serge Ayoun <serge.ayoun@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v28 08/22] x86/sgx: Enumerate and track EPC sections
Date:   Wed,  4 Mar 2020 01:35:55 +0200
Message-Id: <20200303233609.713348-9-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Enumerate Enclave Page Cache (EPC) sections via CPUID and add the data
structures necessary to track EPC pages so that they can be allocated,
freed and managed. As a system may have multiple EPC sections, invoke CPUID
on SGX sub-leafs until an invalid leaf is encountered.

For simplicity, support a maximum of eight EPC sections. Existing client
hardware supports only a single section, while upcoming server hardware
will support at most eight sections. Bounding the number of sections also
allows the section ID to be embedded along with a page's offset in a single
unsigned long, enabling easy retrieval of both the VA and PA for a given
page.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/Kconfig                  |  14 +++
 arch/x86/kernel/cpu/Makefile      |   1 +
 arch/x86/kernel/cpu/sgx/Makefile  |   3 +
 arch/x86/kernel/cpu/sgx/main.c    | 151 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/reclaim.c |  82 ++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h     |  70 ++++++++++++++
 6 files changed, 321 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/sgx/Makefile
 create mode 100644 arch/x86/kernel/cpu/sgx/main.c
 create mode 100644 arch/x86/kernel/cpu/sgx/reclaim.c
 create mode 100644 arch/x86/kernel/cpu/sgx/sgx.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index beea77046f9b..8bbb4313fae3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1950,6 +1950,20 @@ config X86_INTEL_TSX_MODE_AUTO
 	  side channel attacks- equals the tsx=auto command line parameter.
 endchoice
 
+config INTEL_SGX
+	bool "Intel SGX"
+	depends on X86_64 && CPU_SUP_INTEL
+	select SRCU
+	select MMU_NOTIFIER
+	help
+	  Intel(R) SGX is a set of CPU instructions that can be used by
+	  applications to set aside private regions of code and data, referred
+	  to as enclaves. An enclave's private memory can only be accessed by
+	  code running within the enclave. Accesses from outside the enclave,
+	  including other enclaves, are disallowed by hardware.
+
+	  If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 7dc4ad68eb41..45534fb81007 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_X86_MCE)			+= mce/
 obj-$(CONFIG_MTRR)			+= mtrr/
 obj-$(CONFIG_MICROCODE)			+= microcode/
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= resctrl/
+obj-$(CONFIG_INTEL_SGX)			+= sgx/
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
 
diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
new file mode 100644
index 000000000000..2dec75916a5e
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -0,0 +1,3 @@
+obj-y += \
+	main.o \
+	reclaim.o
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
new file mode 100644
index 000000000000..38424c1e8341
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -0,0 +1,151 @@
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
+#include "encls.h"
+
+struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+int sgx_nr_epc_sections;
+
+static void __init sgx_free_epc_section(struct sgx_epc_section *section)
+{
+	struct sgx_epc_page *page;
+
+	while (!list_empty(&section->page_list)) {
+		page = list_first_entry(&section->page_list,
+					struct sgx_epc_page, list);
+		list_del(&page->list);
+		kfree(page);
+	}
+
+	while (!list_empty(&section->unsanitized_page_list)) {
+		page = list_first_entry(&section->unsanitized_page_list,
+					struct sgx_epc_page, list);
+		list_del(&page->list);
+		kfree(page);
+	}
+
+	memunmap(section->va);
+}
+
+static bool __init sgx_alloc_epc_section(u64 addr, u64 size,
+					 unsigned long index,
+					 struct sgx_epc_section *section)
+{
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	struct sgx_epc_page *page;
+	unsigned long i;
+
+	section->va = memremap(addr, size, MEMREMAP_WB);
+	if (!section->va)
+		return false;
+
+	section->pa = addr;
+	spin_lock_init(&section->lock);
+	INIT_LIST_HEAD(&section->page_list);
+	INIT_LIST_HEAD(&section->unsanitized_page_list);
+
+	for (i = 0; i < nr_pages; i++) {
+		page = kzalloc(sizeof(*page), GFP_KERNEL);
+		if (!page)
+			goto err_out;
+
+		page->desc = (addr + (i << PAGE_SHIFT)) | index;
+		list_add_tail(&page->list, &section->unsanitized_page_list);
+	}
+
+	return true;
+
+err_out:
+	sgx_free_epc_section(section);
+	return false;
+}
+
+static void __init sgx_page_cache_teardown(void)
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
+static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
+{
+	return (low & GENMASK_ULL(31, 12)) +
+	       ((high & GENMASK_ULL(19, 0)) << 32);
+}
+
+static bool __init sgx_page_cache_init(void)
+{
+	u32 eax, ebx, ecx, edx, type;
+	u64 pa, size;
+	int i;
+
+	for (i = 0; i <= ARRAY_SIZE(sgx_epc_sections); i++) {
+		cpuid_count(SGX_CPUID, i + SGX_CPUID_FIRST_VARIABLE_SUB_LEAF,
+			    &eax, &ebx, &ecx, &edx);
+
+		type = eax & SGX_CPUID_SUB_LEAF_TYPE_MASK;
+		if (type == SGX_CPUID_SUB_LEAF_INVALID)
+			break;
+
+		if (type != SGX_CPUID_SUB_LEAF_EPC_SECTION) {
+			pr_err_once("Unknown EPC section type: %u\n", type);
+			break;
+		}
+
+		if (i == ARRAY_SIZE(sgx_epc_sections)) {
+			pr_warn("No free slot for an EPC section\n");
+			break;
+		}
+
+		pa = sgx_calc_section_metric(eax, ebx);
+		size = sgx_calc_section_metric(ecx, edx);
+
+		pr_info("EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
+
+		if (!sgx_alloc_epc_section(pa, size, i, &sgx_epc_sections[i])) {
+			pr_err("No free memory for an EPC section\n");
+			break;
+		}
+
+		sgx_nr_epc_sections++;
+	}
+
+	if (!sgx_nr_epc_sections) {
+		pr_err("There are zero EPC sections.\n");
+		return false;
+	}
+
+	return true;
+}
+
+static void __init sgx_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_SGX))
+		return;
+
+	if (!sgx_page_cache_init())
+		return;
+
+	if (!sgx_page_reclaimer_init())
+		goto err_page_cache;
+
+	return;
+
+err_page_cache:
+	sgx_page_cache_teardown();
+}
+
+arch_initcall(sgx_init);
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
new file mode 100644
index 000000000000..215371588a25
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-19 Intel Corporation.
+
+#include <linux/freezer.h>
+#include <linux/highmem.h>
+#include <linux/kthread.h>
+#include <linux/pagemap.h>
+#include <linux/ratelimit.h>
+#include <linux/slab.h>
+#include <linux/sched/mm.h>
+#include <linux/sched/signal.h>
+#include "encls.h"
+
+struct task_struct *ksgxswapd_tsk;
+
+static void sgx_sanitize_section(struct sgx_epc_section *section)
+{
+	struct sgx_epc_page *page;
+	LIST_HEAD(secs_list);
+	int ret;
+
+	while (!list_empty(&section->unsanitized_page_list)) {
+		if (kthread_should_stop())
+			return;
+
+		spin_lock(&section->lock);
+
+		page = list_first_entry(&section->unsanitized_page_list,
+					struct sgx_epc_page, list);
+
+		ret = __eremove(sgx_epc_addr(page));
+		if (!ret)
+			list_move(&page->list, &section->page_list);
+		else
+			list_move_tail(&page->list, &secs_list);
+
+		spin_unlock(&section->lock);
+
+		cond_resched();
+	}
+}
+
+static int ksgxswapd(void *p)
+{
+	int i;
+
+	set_freezable();
+
+	/*
+	 * Reset all pages to uninitialized state. Pages could be in initialized
+	 * on kmemexec.
+	 */
+	for (i = 0; i < sgx_nr_epc_sections; i++)
+		sgx_sanitize_section(&sgx_epc_sections[i]);
+
+	/*
+	 * 2nd round for the SECS pages as they cannot be removed when they
+	 * still hold child pages.
+	 */
+	for (i = 0; i < sgx_nr_epc_sections; i++) {
+		sgx_sanitize_section(&sgx_epc_sections[i]);
+
+		/* Should never happen. */
+		if (!list_empty(&sgx_epc_sections[i].unsanitized_page_list))
+			WARN(1, "EPC section %d has unsanitized pages.\n", i);
+	}
+
+	return 0;
+}
+
+bool __init sgx_page_reclaimer_init(void)
+{
+	struct task_struct *tsk;
+
+	tsk = kthread_run(ksgxswapd, NULL, "ksgxswapd");
+	if (IS_ERR(tsk))
+		return false;
+
+	ksgxswapd_tsk = tsk;
+
+	return true;
+}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
new file mode 100644
index 000000000000..aad30980be32
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -0,0 +1,70 @@
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
+#include "arch.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) "sgx: " fmt
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
+	struct list_head unsanitized_page_list;
+	spinlock_t lock;
+};
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
+#define SGX_MAX_EPC_SECTIONS (SGX_EPC_SECTION_MASK + 1)
+
+extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
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
+extern int sgx_nr_epc_sections;
+extern struct task_struct *ksgxswapd_tsk;
+
+bool __init sgx_page_reclaimer_init(void);
+
+#endif /* _X86_SGX_H */
-- 
2.25.0

