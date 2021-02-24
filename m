Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABE7C433E6
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Feb 2021 22:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4872064F03
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Feb 2021 22:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbhBXWWQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Feb 2021 17:22:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235102AbhBXWWE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Feb 2021 17:22:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A357364F06;
        Wed, 24 Feb 2021 22:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614205283;
        bh=YG3VyrXyl8Eb+Oob9+bdw2ZZCyfsefsAZCXzh+Opkrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYG51PlVctgai/c/IgvFAdcgPncr+NKDXrwOqmA4n+0vvJud6vLks2zSazUeEK/Fb
         6nSZF5z63yiEGHWj3nZJwdkugDSRrPGSICHm0p9ZVJXML/vKfjzzzC5AArYz8wyfEC
         u3WoQfuw8q/EBWVEaagOwigGl6XWoQmKqj/1Zu2iQc7GSf40VfEVb65CnBYcASBdEs
         dLuTzK8ZGuzrjwnslGotVB0pIRzSi/0iy84jEuaxnmB13C4Inq6PuPLP7+fYR+5QjZ
         Brt02IfqAK5x6PmyJf05TNTJU1xBgoFuO5DFT/RPomHDMKYouyejhn2xTyhLO3o/G/
         8tgRBvuMOoodQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] x86/sgx: Add a version array (VA) structure
Date:   Thu, 25 Feb 2021 00:20:48 +0200
Message-Id: <20210224222049.240754-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210224222049.240754-1-jarkko@kernel.org>
References: <20210224222049.240754-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a data structure representing an arbitrary size EPC version array (VA),
consisting of a vector of VA EPC pages. Introduce sgx_va_get() and
sgx_va_put() for reserving and releasing VA slots in the version array.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/encl.c | 126 ++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/encl.h |  26 ++++---
 arch/x86/kernel/cpu/sgx/main.c |   1 +
 3 files changed, 144 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 42eb879c167a..c8ce3779eaa7 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -265,7 +265,7 @@ static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
 }
 
 static int sgx_encl_debug_read(struct sgx_encl *encl, struct sgx_encl_page *page,
-			       unsigned long addr, void *data)
+				unsigned long addr, void *data)
 {
 	unsigned long offset = addr & ~PAGE_MASK;
 	int ret;
@@ -749,3 +749,127 @@ bool sgx_va_page_full(struct sgx_va_page *va_page)
 
 	return slot == SGX_VA_SLOT_COUNT;
 }
+
+/**
+ * sgx_va_init() - Initialize a version array (VA)
+ * @va:		A version array.
+ *
+ * Initialize the data structure to be ready for sgx_va_get() and sgx_va_put()
+ * operations. The given buffer must be zero initialized.
+ */
+void sgx_va_init(struct sgx_va *va)
+{
+	xa_init(&va->page_array);
+	mutex_init(&va->lock);
+}
+
+/**
+ * sgx_va_destroy() - Destroy a version array (VA)
+ * @va:		A version array.
+ *
+ * Release all the resources reserved by the version array.
+ */
+void sgx_va_destroy(struct sgx_va *va)
+{
+	struct sgx_va_page *entry;
+	unsigned long index;
+
+	/* Delete the VA pages. */
+	xa_for_each(&va->page_array, index, entry) {
+		sgx_free_epc_page(entry->epc_page);
+		kfree(entry);
+	}
+
+	/* Delete the page array structure contents.*/
+	xa_destroy(&va->page_array);
+}
+
+/**
+ * sgx_va_get() - Reserve a slot from a version array (VA)
+ * @va:		A version array.
+ * @index:	The slot index.
+ *
+ * Reserve an arbitrary slot from a version array given by the slot index.
+ *
+ * Return:
+ * - A VA page:		On success.
+ * - ERR_PTR(-errno):	On failure.
+ */
+struct sgx_va_page *sgx_va_get(struct sgx_va *va, int index)
+{
+	int sub_index = index & (SGX_VA_SLOT_COUNT - 1);
+	int page_index = index / SGX_VA_SLOT_COUNT;
+	struct sgx_va_page *page;
+	int ret;
+
+	mutex_lock(&va->lock);
+
+	page = xa_load(&va->page_array, page_index);
+	if (page)
+		goto out;
+
+	page = sgx_alloc_va_page();
+	if (!page) {
+		page = ERR_PTR(-ENOMEM);
+		goto err_lock;
+	}
+
+	ret = xa_insert(&va->page_array, page_index, page, GFP_KERNEL);
+	if (ret) {
+		page = ERR_PTR(ret);
+		goto err_va_page;
+	}
+
+out:
+	WARN_ONCE(test_bit(sub_index, page->slots),
+		  "page_index = %d, sub_index = %d\n", page_index, sub_index);
+
+	set_bit(sub_index, page->slots);
+
+	mutex_unlock(&va->lock);
+
+	return page;
+
+err_va_page:
+	sgx_free_epc_page(page->epc_page);
+	kfree(page);
+
+err_lock:
+	mutex_unlock(&va->lock);
+
+	return page;
+}
+
+/*
+ * sgx_va_put() - Release a slot back to a version array (VA)
+ * @va:		A version array.
+ * @index:	The slot index.
+ *
+ * Release a slot back to a version array (VA). Free the VA page, which contained
+ * the slot, if it becomes empty.
+ */
+void sgx_va_put(struct sgx_va *va, int index)
+{
+	int sub_index = index & (SGX_VA_SLOT_COUNT - 1);
+	int page_index = index / SGX_VA_SLOT_COUNT;
+	struct sgx_va_page *page;
+
+	mutex_lock(&va->lock);
+
+	page = xa_load(&va->page_array, page_index);
+
+	WARN_ONCE(!test_bit(sub_index, page->slots),
+		  "page_index = %d, sub_index = %d\n", page_index, sub_index);
+
+	clear_bit(sub_index, page->slots);
+
+	if (find_first_zero_bit(page->slots, SGX_VA_SLOT_COUNT) == SGX_VA_SLOT_COUNT) {
+		xa_erase(&va->page_array, page_index);
+
+		/* Free the VA page. */
+		sgx_free_epc_page(page->epc_page);
+		kfree(page);
+	}
+
+	mutex_unlock(&va->lock);
+}
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 315e87fcc142..806cf3ff7391 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -19,6 +19,19 @@
 #include <linux/xarray.h>
 #include "sgx.h"
 
+#define SGX_VA_SLOT_COUNT 512
+
+struct sgx_va_page {
+	struct sgx_epc_page *epc_page;
+	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
+	struct list_head list;
+};
+
+struct sgx_va {
+	struct xarray page_array;
+	struct mutex lock;
+};
+
 /* 'desc' bits holding the offset in the VA (version array) page. */
 #define SGX_ENCL_PAGE_VA_OFFSET_MASK	GENMASK_ULL(11, 3)
 
@@ -69,14 +82,6 @@ struct sgx_encl {
 	struct srcu_struct srcu;
 };
 
-#define SGX_VA_SLOT_COUNT 512
-
-struct sgx_va_page {
-	struct sgx_epc_page *epc_page;
-	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
-	struct list_head list;
-};
-
 struct sgx_backing {
 	pgoff_t page_index;
 	struct page *contents;
@@ -116,4 +121,9 @@ unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
 void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
 bool sgx_va_page_full(struct sgx_va_page *va_page);
 
+void sgx_va_init(struct sgx_va *va);
+void sgx_va_destroy(struct sgx_va *va);
+struct sgx_va_page *sgx_va_get(struct sgx_va *va, int index);
+void sgx_va_put(struct sgx_va *va, int index);
+
 #endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8df81a3ed945..26dfe6aecd72 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -617,6 +617,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	spin_unlock(&section->lock);
 }
 
+
 static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 					 unsigned long index,
 					 struct sgx_epc_section *section)
-- 
2.30.1

