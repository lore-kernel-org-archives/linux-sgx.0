Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE90C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F38582190A
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403906AbeLUXOZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 18:14:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:13668 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730803AbeLUXOZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 18:14:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 15:14:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120338514"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 15:14:18 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v18 15/25] x86/sgx: Add functions to allocate and free EPC pages
Date:   Sat, 22 Dec 2018 01:11:44 +0200
Message-Id: <20181221231154.6120-16-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

At this time there is no support for reclaiming pages prior to the
owner explicitly freeing the page.  As for freeing pages, because
freeing a page is expected to succeed in the vast majority of cases
and because most call sites will not be equipped to handle failure,
provide a variant for freeing a page that warns on failure, e.g. due
to ENCLS[EREMOVE] failing.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx.h     |  4 ++
 arch/x86/kernel/cpu/sgx/main.c | 88 ++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index a37bc3650253..40caaac58747 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -303,4 +303,8 @@ static inline int __emodt(struct sgx_secinfo *secinfo, void *addr)
 	return __encls_ret_2(SGX_EMODT, secinfo, addr);
 }
 
+struct sgx_epc_page *sgx_alloc_page(void);
+int __sgx_free_page(struct sgx_epc_page *page);
+void sgx_free_page(struct sgx_epc_page *page);
+
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index cd5090ca00e5..0c74dcace908 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -22,6 +22,94 @@ static void sgx_section_put_page(struct sgx_epc_section *section,
 	section->free_cnt++;
 }
 
+static struct sgx_epc_page *sgx_section_get_page(
+	struct sgx_epc_section *section)
+{
+	struct sgx_epc_page *page;
+
+	if (!section->free_cnt)
+		return NULL;
+
+	page = list_first_entry(&section->page_list,
+				struct sgx_epc_page, list);
+	list_del_init(&page->list);
+	section->free_cnt--;
+	return page;
+}
+
+/**
+ * sgx_alloc_page - Allocate an EPC page
+ *
+ * Try to grab a page from the free EPC page list.
+ *
+ * Return:
+ *   a pointer to a &struct sgx_epc_page instance,
+ *   -errno on error
+ */
+struct sgx_epc_page *sgx_alloc_page(void)
+{
+	struct sgx_epc_section *section;
+	struct sgx_epc_page *page;
+	int i;
+
+	for (i = 0; i < sgx_nr_epc_sections; i++) {
+		section = &sgx_epc_sections[i];
+		spin_lock(&section->lock);
+		page = sgx_section_get_page(section);
+		spin_unlock(&section->lock);
+
+		if (page)
+			return page;
+	}
+
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(sgx_alloc_page);
+
+/**
+ * __sgx_free_page - Free an EPC page
+ * @page:	pointer a previously allocated EPC page
+ *
+ * EREMOVE an EPC page and insert it back to the list of free pages.
+ *
+ * Return:
+ *   0 on success
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
+	sgx_section_put_page(section, page);
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
+ * EREMOVE an EPC page and insert it back to the list of free pages, and WARN
+ * if EREMOVE fails.  For use when the call site cannot (or chooses not to)
+ * handle failure, i.e. the page is leaked on failure.
+ */
+void sgx_free_page(struct sgx_epc_page *page)
+{
+	int ret;
+
+	ret = __sgx_free_page(page);
+	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
+}
+EXPORT_SYMBOL_GPL(sgx_free_page);
+
 static __init void sgx_free_epc_section(struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
-- 
2.19.1

