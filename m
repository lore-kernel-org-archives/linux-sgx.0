Received: from mga11.intel.com ([192.55.52.93]:22699 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1727165AbeIYTVA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 25
 Sep 2018 15:21:00 -0400
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
Subject: [PATCH v14 13/19] x86/sgx: Enclave Page Cache (EPC) memory manager
Date: Tue, 25 Sep 2018 16:06:50 +0300
Message-ID: <20180925130845.9962-14-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Content-Type: text/plain
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

Add a Enclave Page Cache (EPC) memory manager that can be used to
allocate and free EPC pages.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx.h      |  7 ++-
 arch/x86/kernel/cpu/intel_sgx.c | 86 +++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 468e609147cd..6ea5a6dbd36d 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -14,6 +14,7 @@
 
 struct sgx_epc_page {
 	unsigned long desc;
+	void *owner;
 	struct list_head list;
 };
 
@@ -65,7 +66,7 @@ static inline void __iomem *sgx_epc_addr(struct sgx_epc_page *page)
 	return section->va + (page->desc & PAGE_MASK) - section->pa;
 }
 
-/**
+/*
  * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
  *
  * ENCLS has its own (positive value) error codes and also generates
@@ -309,4 +310,8 @@ static inline int __emodt(struct sgx_secinfo *secinfo, void __iomem *addr)
 	return __encls_ret_2(SGX_EMODT, secinfo, addr);
 }
 
+struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
+int __sgx_free_page(struct sgx_epc_page *page);
+void sgx_free_page(struct sgx_epc_page *page);
+
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/intel_sgx.c b/arch/x86/kernel/cpu/intel_sgx.c
index b24d6287442d..ef30d6730859 100644
--- a/arch/x86/kernel/cpu/intel_sgx.c
+++ b/arch/x86/kernel/cpu/intel_sgx.c
@@ -19,6 +19,92 @@ EXPORT_SYMBOL_GPL(sgx_epc_sections);
 
 static int sgx_nr_epc_sections;
 
+/**
+ * sgx_alloc_page - Allocate an EPC page
+ * @owner:	the owner of the EPC page
+ * @reclaim:	wait and reclaim pages up until we get one
+ *
+ * Try to grab a page from the free EPC page list. If there is a free page
+ * available, it is returned to the caller. The @reclaim parameter hints
+ * the EPC memory manager to swap pages when required.
+ *
+ * Return:
+ *   a pointer to a &struct sgx_epc_page instace,
+ *   -errno on error
+ */
+struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
+{
+	struct sgx_epc_section *section;
+	struct sgx_epc_page *page;
+	int i;
+
+	for (i = 0; i < sgx_nr_epc_sections; i++) {
+		section = &sgx_epc_sections[i];
+		spin_lock(&section->lock);
+		if (section->free_cnt) {
+			page = section->pages[section->free_cnt - 1];
+			section->free_cnt--;
+		}
+		spin_unlock(&section->lock);
+
+		if (page) {
+			page->owner = owner;
+			return page;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(sgx_alloc_page);
+
+/**
+ * __sgx_free_page - Free an EPC page
+ * @page:	pointer a previously allocated EPC page
+ *
+ * Invaldate an EPC page and insert it back to the list of free pages.
+ *
+ * Return:
+ *   0 on success
+ *   -EBUSY if the page cannot be removed from the active list
+ *   SGX error code if EREMOVE fails
+ */
+int __sgx_free_page(struct sgx_epc_page *page)
+{
+	struct sgx_epc_section *section = sgx_epc_section(page);
+	int ret;
+
+	ret = __eremove(sgx_epc_addr(page));
+	if (ret)
+		return ret;
+
+	spin_lock(&section->lock);
+	section->pages[section->free_cnt++] = page;
+	spin_unlock(&section->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__sgx_free_page);
+
+/**
+ * sgx_free_page - Free an EPC page and WARN on failure
+ * @page:	pointer to a previously allocated EPC page
+ *
+ * EREMOVE an EPC page and insert it back to the list of free pages.
+ * If the page is reclaimable, deletes it from the active page list.
+ * WARN on any failure.  For use when the call site cannot (or chooses
+ * not to) handle failure, i.e. the page is leaked on failure.
+ */
+void sgx_free_page(struct sgx_epc_page *page)
+{
+	int ret;
+
+	ret = __sgx_free_page(page);
+	WARN(ret < 0, "sgx: cannot free page, reclaim in-progress");
+	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
+}
+EXPORT_SYMBOL_GPL(sgx_free_page);
+
+
 static __init void sgx_free_epc_section(struct sgx_epc_section *section)
 {
 	int i;
-- 
2.17.1
