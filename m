Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CD9C71142
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9EB220850
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfGMRKm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 13:10:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:24667 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbfGMRKm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 13:10:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jul 2019 10:10:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,487,1557212400"; 
   d="scan'208";a="341981368"
Received: from hbriegel-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.48])
  by orsmga005.jf.intel.com with ESMTP; 13 Jul 2019 10:10:31 -0700
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
        cedric.xing@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v21 13/28] x86/sgx: Add functions to allocate and free EPC pages
Date:   Sat, 13 Jul 2019 20:07:49 +0300
Message-Id: <20190713170804.2340-14-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
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
 arch/x86/kernel/cpu/sgx/main.c | 90 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h  |  4 ++
 2 files changed, 94 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index e2317f6e4374..6b4727df72ca 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -9,6 +9,7 @@
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include "arch.h"
+#include "encls.h"
 #include "sgx.h"
 
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
@@ -16,6 +17,95 @@ EXPORT_SYMBOL_GPL(sgx_epc_sections);
 
 int sgx_nr_epc_sections;
 
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
+	list_add_tail(&page->list, &section->page_list);
+	section->free_cnt++;
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
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 3009ec816339..210510a28ce0 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -64,4 +64,8 @@ extern int sgx_nr_epc_sections;
 
 int sgx_page_reclaimer_init(void);
 
+struct sgx_epc_page *sgx_alloc_page(void);
+int __sgx_free_page(struct sgx_epc_page *page);
+void sgx_free_page(struct sgx_epc_page *page);
+
 #endif /* _X86_SGX_H */
-- 
2.20.1

