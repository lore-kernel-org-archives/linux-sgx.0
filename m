Return-Path: <SRS0=ol6i=4L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB5EC35666
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Feb 2020 17:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DF712067D
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Feb 2020 17:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgBWR1S (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:27:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:58410 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbgBWR1R (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 23 Feb 2020 12:27:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Feb 2020 09:27:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,476,1574150400"; 
   d="scan'208";a="229650131"
Received: from ajbergin-mobl.ger.corp.intel.com (HELO localhost) ([10.252.23.203])
  by fmsmga007.fm.intel.com with ESMTP; 23 Feb 2020 09:27:09 -0800
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
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v27 08/22] x86/sgx: Add functions to allocate and free EPC pages
Date:   Sun, 23 Feb 2020 19:25:45 +0200
Message-Id: <20200223172559.6912-9-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223172559.6912-1-jarkko.sakkinen@linux.intel.com>
References: <20200223172559.6912-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add functions for allocating page from Enclave Page Cache (EPC). A page is
allocated by going through the EPC sections and returning the first free
page.

When a page is freed, it might have a valid state, which means that the
callee has assigned it to an enclave, which are protected memory ares used
to run code protected from outside access. The page is returned back to the
invalid state with ENCLS[EREMOVE] [1].

[1] Intel SDM: 40.3 INTEL® SGX SYSTEM LEAF FUNCTION REFERENCE

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 60 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++
 2 files changed, 63 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 38424c1e8341..60d82e7537c8 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -13,6 +13,66 @@
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 int sgx_nr_epc_sections;
 
+static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section)
+{
+	struct sgx_epc_page *page;
+
+	if (list_empty(&section->page_list))
+		return NULL;
+
+	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
+	list_del_init(&page->list);
+	return page;
+}
+
+/**
+ * sgx_try_alloc_page() - Allocate an EPC page
+ *
+ * Try to grab a page from the free EPC page list.
+ *
+ * Return:
+ *   a pointer to a &struct sgx_epc_page instance,
+ *   -errno on error
+ */
+struct sgx_epc_page *sgx_try_alloc_page(void)
+{
+	struct sgx_epc_section *section;
+	struct sgx_epc_page *page;
+	int i;
+
+	for (i = 0; i < sgx_nr_epc_sections; i++) {
+		section = &sgx_epc_sections[i];
+		spin_lock(&section->lock);
+		page = __sgx_try_alloc_page(section);
+		spin_unlock(&section->lock);
+
+		if (page)
+			return page;
+	}
+
+	return ERR_PTR(-ENOMEM);
+}
+
+/**
+ * sgx_free_page() - Free an EPC page
+ * @page:	pointer a previously allocated EPC page
+ *
+ * EREMOVE an EPC page and insert it back to the list of free pages.
+ */
+void sgx_free_page(struct sgx_epc_page *page)
+{
+	struct sgx_epc_section *section = sgx_epc_section(page);
+	int ret;
+
+	ret = __eremove(sgx_epc_addr(page));
+	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
+		return;
+
+	spin_lock(&section->lock);
+	list_add_tail(&page->list, &section->page_list);
+	spin_unlock(&section->lock);
+}
+
 static void __init sgx_free_epc_section(struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index aad30980be32..aa85f85412d8 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -67,4 +67,7 @@ extern struct task_struct *ksgxswapd_tsk;
 
 bool __init sgx_page_reclaimer_init(void);
 
+struct sgx_epc_page *sgx_try_alloc_page(void);
+void sgx_free_page(struct sgx_epc_page *page);
+
 #endif /* _X86_SGX_H */
-- 
2.20.1

