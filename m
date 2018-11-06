Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD3AC32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 13:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C119E2081D
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 13:52:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C119E2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388191AbeKFXSR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Nov 2018 18:18:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:3357 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388048AbeKFXSQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Nov 2018 18:18:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2018 05:52:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,472,1534834800"; 
   d="scan'208";a="278750631"
Received: from fhoeg-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.66])
  by fmsmga006.fm.intel.com with ESMTP; 06 Nov 2018 05:52:51 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH v16 16/22] x86/sgx: Add functions to allocate and free EPC pages
Date:   Tue,  6 Nov 2018 15:45:55 +0200
Message-Id: <20181106134758.10572-17-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106134555.M06eEqvi9WiKLIFTdLlPkaIe2I6wGlhBQ6grw4H1nH0@z>

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
 arch/x86/include/asm/sgx.h      |  4 ++
 arch/x86/kernel/cpu/intel_sgx.c | 77 +++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index efe3e213e582..372fc378018b 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -307,4 +307,8 @@ static inline int __emodt(struct sgx_secinfo *secinfo, void *addr)
 	return __encls_ret_2(SGX_EMODT, secinfo, addr);
 }
 
+struct sgx_epc_page *sgx_alloc_page(void);
+int __sgx_free_page(struct sgx_epc_page *page);
+void sgx_free_page(struct sgx_epc_page *page);
+
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/intel_sgx.c b/arch/x86/kernel/cpu/intel_sgx.c
index 7587fc7ef9ef..e9a225fa14b7 100644
--- a/arch/x86/kernel/cpu/intel_sgx.c
+++ b/arch/x86/kernel/cpu/intel_sgx.c
@@ -15,6 +15,83 @@ EXPORT_SYMBOL_GPL(sgx_epc_sections);
 
 static int sgx_nr_epc_sections;
 
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
+		if (section->free_cnt) {
+			page = section->pages[section->free_cnt - 1];
+			section->free_cnt--;
+		}
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
+
 static __init void sgx_free_epc_section(struct sgx_epc_section *section)
 {
 	int i;
-- 
2.19.1

