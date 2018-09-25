From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	"Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>, "open
 list:X86 ARCHITECTURE (32-BIT AND        64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v14 12/19] x86/sgx: Add data structures for tracking the EPC pages
Date: Tue, 25 Sep 2018 16:06:49 +0300
Message-ID: <20180925130845.9962-13-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
Sender: <linux-kernel-owner@vger.kernel.org>
Content-Type: text/plain
Return-Path: linux-kernel-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

Add data structures to track Enclave Page Cache (EPC) pages.  EPC is
divided into multiple banks (1-N) of which addresses and sizes can be
enumerated with CPUID by the OS.

On NUMA systems a node can have at most bank. A bank can be at most part of
two nodes. SGX supports both nodes with a single memory controller and also
sub-cluster nodes with severals memory controllers on a single die.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx.h      |  55 +++++++++++++++
 arch/x86/kernel/cpu/intel_sgx.c | 115 ++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index e66e2572011e..468e609147cd 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -5,10 +5,65 @@
 #ifndef _ASM_X86_SGX_H
 #define _ASM_X86_SGX_H
 
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/rwsem.h>
 #include <linux/types.h>
+#include <asm/sgx_arch.h>
+#include <asm/asm.h>
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
+	void __iomem *va;
+	struct sgx_epc_page **pages;
+	unsigned long free_cnt;
+	spinlock_t lock;
+};
 
 extern bool sgx_enabled;
 extern bool sgx_lc_enabled;
+extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+
+/*
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
+static inline void __iomem *sgx_epc_addr(struct sgx_epc_page *page)
+{
+	struct sgx_epc_section *section = sgx_epc_section(page);
+
+	return section->va + (page->desc & PAGE_MASK) - section->pa;
+}
 
 /**
  * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
diff --git a/arch/x86/kernel/cpu/intel_sgx.c b/arch/x86/kernel/cpu/intel_sgx.c
index 138af9b9a39a..b24d6287442d 100644
--- a/arch/x86/kernel/cpu/intel_sgx.c
+++ b/arch/x86/kernel/cpu/intel_sgx.c
@@ -14,10 +14,121 @@ bool sgx_enabled __ro_after_init;
 EXPORT_SYMBOL_GPL(sgx_enabled);
 bool sgx_lc_enabled __ro_after_init;
 EXPORT_SYMBOL_GPL(sgx_lc_enabled);
+struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+EXPORT_SYMBOL_GPL(sgx_epc_sections);
+
+static int sgx_nr_epc_sections;
+
+static __init void sgx_free_epc_section(struct sgx_epc_section *section)
+{
+	int i;
+
+	for (i = 0; i < section->free_cnt && section->pages[i]; i++)
+		kfree(section->pages[i]);
+	kfree(section->pages);
+	iounmap(section->va);
+}
+
+static __init int sgx_init_epc_section(u64 addr, u64 size, unsigned long index,
+				       struct sgx_epc_section *section)
+{
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	unsigned long i;
+
+	section->va = ioremap_cache(addr, size);
+	if (!section->va)
+		return -ENOMEM;
+
+	section->pa = addr;
+	section->free_cnt = nr_pages;
+	spin_lock_init(&section->lock);
+
+	section->pages = kcalloc(nr_pages, sizeof(struct sgx_epc_page *),
+				 GFP_KERNEL);
+	if (!section->pages)
+		goto out;
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
+	u32 eax, ebx, ecx, edx;
+	u32 section_type;
+	u64 pa, size;
+	int ret;
+	int i;
+
+	BUILD_BUG_ON(SGX_MAX_EPC_SECTIONS > (SGX_EPC_SECTION_MASK + 1));
+
+	for (i = 0; i < SGX_MAX_EPC_SECTIONS; i++) {
+		cpuid_count(SGX_CPUID, SGX_CPUID_SECTION + i, &eax, &ebx, &ecx,
+			    &edx);
+		section_type = eax & SGX_CPUID_SECTION_MASK;
+		if (section_type == SGX_CPUID_SECTION_INVALID)
+			break;
+		if (section_type != SGX_CPUID_SECTION_VALID) {
+			pr_err("sgx: Unexpected section type: %u\n",
+			       section_type);
+			return -ENODEV;
+		};
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
 
 static __init int sgx_init(void)
 {
 	unsigned long fc;
+	int ret;
 
 	if (!boot_cpu_has(X86_FEATURE_SGX))
 		return false;
@@ -36,6 +147,10 @@ static __init int sgx_init(void)
 		return false;
 	}
 
+	ret = sgx_page_cache_init();
+	if (ret)
+		return ret;
+
 	sgx_enabled = true;
 	sgx_lc_enabled = !!(fc & FEATURE_CONTROL_SGX_LE_WR);
 	return 0;
-- 
2.17.1
