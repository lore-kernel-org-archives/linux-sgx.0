Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6924C433E2
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C612207DE
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:48:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="TYnuXUfW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgIPAsT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgIOLm1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Sep 2020 07:42:27 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0D5C061355;
        Tue, 15 Sep 2020 04:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VQfxU9etoAX9NoRDjTZJvNO+0WR8I6R02xxEqCNX2jQ=; b=TYnuXUfWzBNVLURQrzQ4lK+ETl
        I4ACWixky0SnpkOUNl73/byCpB+Rig7ecHuROjeifjq1F/baQ8kjVXY3FNHy3j1DEzUIeHArTuJlO
        jllru1SjhIQru5bRjRg9LRrk2CZfV3s22+jcgz1veSP8g6P6nPUB3v5v9touZ/IfwLErys9fo8HJu
        Cc+1wBzHJgIR3Njl47L6LRPzln2o0+wB1knMAkFLIgrYDJ/Z5ILHnpVowEuGiwS40PVzcasky4ZWB
        Wj3iMIMiSO0xluFHwIYw+BjGKWVBzCiJxLGhhcFr4s65kiW+vLT8jiEXEOTY/yYFRUgABKWacFasT
        pgg7GoTQ==;
Received: from 83-245-197-237.elisa-laajakaista.fi ([83.245.197.237] helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jarkko.sakkinen@linux.intel.com>)
        id 1kI8mB-0005vH-Ap; Tue, 15 Sep 2020 14:05:31 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v38 09/24] x86/sgx: Add __sgx_alloc_epc_page() and sgx_free_epc_page()
Date:   Tue, 15 Sep 2020 14:05:07 +0300
Message-Id: <20200915110522.893152-10-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
References: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 83.245.197.237
X-SA-Exim-Mail-From: jarkko.sakkinen@linux.intel.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
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
Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 62 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++
 2 files changed, 65 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c5831e3db14a..97c6895fb6c9 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -83,6 +83,68 @@ static bool __init sgx_page_reclaimer_init(void)
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
+
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
index dff4f5f16d09..fce756c3434b 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -49,4 +49,7 @@ static inline void *sgx_get_epc_addr(struct sgx_epc_page *page)
 	return section->va + (page->desc & PAGE_MASK) - section->pa;
 }
 
+struct sgx_epc_page *__sgx_alloc_epc_page(void);
+void sgx_free_epc_page(struct sgx_epc_page *page);
+
 #endif /* _X86_SGX_H */
-- 
2.25.1

