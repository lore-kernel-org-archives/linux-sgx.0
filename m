Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6231EC433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 27 Sep 2021 21:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B156113D
	for <linux-sgx@archiver.kernel.org>; Mon, 27 Sep 2021 21:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbhI0Vgk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 27 Sep 2021 17:36:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:2372 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236743AbhI0Vgj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 27 Sep 2021 17:36:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288227510"
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="288227510"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 14:35:01 -0700
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="561547569"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 14:35:00 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 1/7] x86/sgx: Add new sgx_epc_page flag bit to mark in-use pages
Date:   Mon, 27 Sep 2021 14:34:46 -0700
Message-Id: <20210927213452.212470-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927213452.212470-1-tony.luck@intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
 <20210927213452.212470-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGX EPC pages go through the following life cycle:

        DIRTY ---> FREE ---> IN-USE --\
                    ^                 |
                    \-----------------/

Recovery action for poison for a DIRTY or FREE page is simple. Just
make sure never to allocate the page. IN-USE pages need some extra
handling.

Add a new flag bit SGX_EPC_PAGE_IN_USE that is set when a page
is allocated and cleared when the page is freed.

Notes:

1) These transitions are made while holding the node->lock so that
   future code that checks the flags while holding the node->lock
   can be sure that if the SGX_EPC_PAGE_IN_USE bit is set, then the
   page is on the free list.

2) Initially while the pages are on the dirty list the
   SGX_EPC_PAGE_IN_USE bit is set.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 4 +++-
 arch/x86/kernel/cpu/sgx/sgx.h  | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de02bbcc..d18988a46c13 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -472,6 +472,7 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
 	page = list_first_entry(&node->free_page_list, struct sgx_epc_page, list);
 	list_del_init(&page->list);
 	sgx_nr_free_pages--;
+	page->flags = SGX_EPC_PAGE_IN_USE;
 
 	spin_unlock(&node->lock);
 
@@ -626,6 +627,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 
 	list_add_tail(&page->list, &node->free_page_list);
 	sgx_nr_free_pages++;
+	page->flags = 0;
 
 	spin_unlock(&node->lock);
 }
@@ -651,7 +653,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
-		section->pages[i].flags = 0;
+		section->pages[i].flags = SGX_EPC_PAGE_IN_USE;
 		section->pages[i].owner = NULL;
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 4628acec0009..f9202d3d6278 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -26,6 +26,9 @@
 /* Pages, which are being tracked by the page reclaimer. */
 #define SGX_EPC_PAGE_RECLAIMER_TRACKED	BIT(0)
 
+/* Allocated pages */
+#define SGX_EPC_PAGE_IN_USE		BIT(1)
+
 struct sgx_epc_page {
 	unsigned int section;
 	unsigned int flags;
-- 
2.31.1

