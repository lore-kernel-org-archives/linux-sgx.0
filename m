Return-Path: <SRS0=Np89=7O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373C0C433DF
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 07:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15DB620734
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 07:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgFAHx3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Jun 2020 03:53:29 -0400
Received: from mga17.intel.com ([192.55.52.151]:59177 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgFAHx3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Jun 2020 03:53:29 -0400
IronPort-SDR: eoEuwJtN74dKKLg7Sx/4b41jO/zcVanicD2OZLhVrDsbk6PGPiFPL1/J6TIhypSpsPiAlD81Be
 KJkZWxhuy+8A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2020 00:53:29 -0700
IronPort-SDR: qpoeWV5pyWWzeIe+ENsy2yXvSSEWv5qu5yR5OgR7V0+GYvn43Gw2nt77vC59x4MwlWqmmPZGXC
 UOkFj5njH+jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,460,1583222400"; 
   d="scan'208";a="311879613"
Received: from yhanin-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.43.17])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Jun 2020 00:53:23 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v32 09/21] x86/sgx: Add __sgx_alloc_epc_page() and sgx_free_epc_page()
Date:   Mon,  1 Jun 2020 10:52:06 +0300
Message-Id: <20200601075218.65618-10-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
References: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add __sgx_alloc_epc_page(), which iterates through EPC sections and borrows
a page structure that is not used by anyone else. When a page is no longer
needed it must be released with sgx_free_epc_page(). This function
implicitly calls ENCLS[EREMOVE], which will return the page to the
uninitialized state (i.e. not required from caller part).

Acked-by: Jethro Beekman <jethro@fortanix.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 61 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++
 2 files changed, 64 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c5831e3db14a..b776d249289f 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -83,6 +83,67 @@ static bool __init sgx_page_reclaimer_init(void)
 	return true;
 }
 
+static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_section *section)
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
+ * __sgx_alloc_epc_page() - Allocate an EPC page
+ *
+ * Iterate through EPC sections and borrow a free EPC page to the caller. When a
+ * page is no longer needed it must be released with sgx_free_epc_page().
+ *
+ * Return:
+ *   an EPC page,
+ *   -errno on error
+ */
+struct sgx_epc_page *__sgx_alloc_epc_page(void)
+{
+	struct sgx_epc_section *section;
+	struct sgx_epc_page *page;
+	int i;
+
+	for (i = 0; i < sgx_nr_epc_sections; i++) {
+		section = &sgx_epc_sections[i];
+		spin_lock(&section->lock);
+		page = __sgx_alloc_epc_page_from_section(section);
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
+ * sgx_free_epc_page() - Free an EPC page
+ * @page:	an EPC page
+ *
+ * Call EREMOVE for an EPC page and insert it back to the list of free pages.
+ */
+void sgx_free_epc_page(struct sgx_epc_page *page)
+{
+	struct sgx_epc_section *section = sgx_get_epc_section(page);
+	int ret;
+
+	ret = __eremove(sgx_get_epc_addr(page));
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
index 6508bfefd6d9..aae6bfb3bc8a 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -50,4 +50,7 @@ static inline void *sgx_get_epc_addr(struct sgx_epc_page *page)
 	return section->va + (page->desc & PAGE_MASK) - section->pa;
 }
 
+struct sgx_epc_page *__sgx_alloc_epc_page(void);
+void sgx_free_epc_page(struct sgx_epc_page *page);
+
 #endif /* _X86_SGX_H */
-- 
2.25.1

