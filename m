Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E69C5519F
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E900422227
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ityVixk+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgKLWCr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:02:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727633AbgKLWCq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Nov 2020 17:02:46 -0500
Received: from suppilovahvero.lan (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D813A22246;
        Thu, 12 Nov 2020 22:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605218565;
        bh=C3z26/BwZTBylkxi3CkpNoxIGz4D3IOIGLA5Db/CwfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ityVixk+RnaXvYGALjt+RY+rXY6uXSV3Z0yoLltodktLCRmUovibpR7gwdvVzxwy1
         qzjXxPhQH3Gnv3zJV1fU6dRt6SYPo+6pednEwsjRMYAXz3EtJohHrF/EmCWYyfsZ2T
         AyKeIs1nlrbXq7tlmgxynL+TbR8KqChpxOJAbAys=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v41 09/24] x86/sgx: Add SGX page allocator functions
Date:   Fri, 13 Nov 2020 00:01:20 +0200
Message-Id: <20201112220135.165028-10-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112220135.165028-1-jarkko@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The previous patch initialized a simple SGX page allocator.  Add functions
for runtime allocation and free.

This allocator and its algorithms are as simple as it gets.  They do a
linear search across all EPC sections and find the first free page.  They
are not NUMA aware and only hand out individual pages.  The SGX hardware
does not support large pages, so something more complicated like a buddy
allocator is unwarranted.

The free function (sgx_free_epc_page()) implicitly calls ENCLS[EREMOVE],
which returns the page to the uninitialized state.  This ensures that the
page is ready for use at the next allocation.

Acked-by: Jethro Beekman <jethro@fortanix.com> # v40
# Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
# Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 65 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++
 2 files changed, 68 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 187a237eec38..2e53afc288a4 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -85,6 +85,71 @@ static bool __init sgx_page_reclaimer_init(void)
 	return true;
 }
 
+static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_section *section)
+{
+	struct sgx_epc_page *page;
+
+	spin_lock(&section->lock);
+
+	if (list_empty(&section->page_list)) {
+		spin_unlock(&section->lock);
+		return NULL;
+	}
+
+	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
+	list_del_init(&page->list);
+
+	spin_unlock(&section->lock);
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
+
+		page = __sgx_alloc_epc_page_from_section(section);
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
+	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
+	int ret;
+
+	ret = __eremove(sgx_get_epc_virt_addr(page));
+	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
+		return;
+
+	spin_lock(&section->lock);
+	list_add_tail(&page->list, &section->page_list);
+	spin_unlock(&section->lock);
+}
+
 static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 					 unsigned long index,
 					 struct sgx_epc_section *section)
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 02afa84dd8fd..bd9dcb1ffcfa 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -57,4 +57,7 @@ static inline void *sgx_get_epc_virt_addr(struct sgx_epc_page *page)
 	return section->virt_addr + index * PAGE_SIZE;
 }
 
+struct sgx_epc_page *__sgx_alloc_epc_page(void);
+void sgx_free_epc_page(struct sgx_epc_page *page);
+
 #endif /* _X86_SGX_H */
-- 
2.27.0

