Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8F0ECE597
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 23:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA7521920
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 23:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfJJXVL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 19:21:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:34955 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbfJJXVL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 19:21:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 16:21:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="207300637"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 10 Oct 2019 16:21:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 v2 6/9] x86/sgx: Split second half of sgx_free_page() to a separate helper
Date:   Thu, 10 Oct 2019 16:21:05 -0700
Message-Id: <20191010232108.27075-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191010232108.27075-1-sean.j.christopherson@intel.com>
References: <20191010232108.27075-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move the post-reclaim half of sgx_free_page() to a standalone helper so
that it can be used in flows where the page is known to be
non-reclaimable.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 44 ++++++++++++++++++++++++++--------
 arch/x86/kernel/cpu/sgx/sgx.h  |  1 +
 2 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 84a44251387b..e22cdbb431a3 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -103,6 +103,39 @@ struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
 	return entry;
 }
 
+
+/**
+ * __sgx_free_page() - Free an EPC page
+ * @page:	pointer a previously allocated EPC page
+ *
+ * EREMOVE an EPC page and insert it back to the list of free pages. The page
+ * must not be reclaimable.
+ */
+void __sgx_free_page(struct sgx_epc_page *page)
+{
+	struct sgx_epc_section *section;
+	int ret;
+
+	/*
+	 * Don't take sgx_active_page_list_lock when asserting the page isn't
+	 * reclaimable, missing a WARN in the very rare case is preferable to
+	 * unnecessarily taking a global lock in the common case.
+	 */
+	WARN_ON_ONCE(page->desc & SGX_EPC_PAGE_RECLAIMABLE);
+
+	ret = __eremove(sgx_epc_addr(page));
+	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
+		return;
+
+	section = sgx_epc_section(page);
+
+	spin_lock(&section->lock);
+	list_add_tail(&page->list, &section->page_list);
+	sgx_nr_free_pages++;
+	spin_unlock(&section->lock);
+
+}
+
 /**
  * sgx_free_page() - Free an EPC page
  * @page:	pointer a previously allocated EPC page
@@ -116,9 +149,6 @@ struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
  */
 int sgx_free_page(struct sgx_epc_page *page)
 {
-	struct sgx_epc_section *section = sgx_epc_section(page);
-	int ret;
-
 	/*
 	 * Remove the page from the active list if necessary.  If the page
 	 * is actively being reclaimed, i.e. RECLAIMABLE is set but the
@@ -136,13 +166,7 @@ int sgx_free_page(struct sgx_epc_page *page)
 	}
 	spin_unlock(&sgx_active_page_list_lock);
 
-	ret = __eremove(sgx_epc_addr(page));
-	WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret);
-
-	spin_lock(&section->lock);
-	list_add_tail(&page->list, &section->page_list);
-	sgx_nr_free_pages++;
-	spin_unlock(&section->lock);
+	__sgx_free_page(page);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 160a3c996ef6..87e375e8c25e 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -85,6 +85,7 @@ void sgx_reclaim_pages(void);
 
 struct sgx_epc_page *sgx_try_alloc_page(void);
 struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
+void __sgx_free_page(struct sgx_epc_page *page);
 int sgx_free_page(struct sgx_epc_page *page);
 
 #endif /* _X86_SGX_H */
-- 
2.22.0

