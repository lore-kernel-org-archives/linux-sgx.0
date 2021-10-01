Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70DEC4332F
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 16:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEC6D61AD0
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 16:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355236AbhJAQtR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Oct 2021 12:49:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:19801 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354807AbhJAQtQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 1 Oct 2021 12:49:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="222290386"
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="222290386"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 09:47:31 -0700
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="540357494"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 09:47:31 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 3/7] x86/sgx: Initial poison handling for dirty and free pages
Date:   Fri,  1 Oct 2021 09:47:20 -0700
Message-Id: <20211001164724.220532-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001164724.220532-1-tony.luck@intel.com>
References: <20210927213452.212470-1-tony.luck@intel.com>
 <20211001164724.220532-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

A memory controller patrol scrubber can report poison in a page
that isn't currently being used.

Add "poison" field in the sgx_epc_page that can be set for an
sgx_epc_page. Check for it:
1) When sanitizing dirty pages
2) When freeing epc pages

Poison is a new field separated from flags to avoid having to make
all updates to flags atomic, or integrate poison state changes into
some other locking scheme to protect flags.

In both cases place the poisoned page on a list of poisoned epc pages
to make sure it will not be reallocated.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 14 +++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 09fa42690ff2..653bace26100 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -43,6 +43,7 @@ static nodemask_t sgx_numa_mask;
 static struct sgx_numa_node *sgx_numa_nodes;
 
 static LIST_HEAD(sgx_dirty_page_list);
+static LIST_HEAD(sgx_poison_page_list);
 
 /*
  * Reset post-kexec EPC pages to the uninitialized state. The pages are removed
@@ -62,6 +63,12 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
 
 		page = list_first_entry(dirty_page_list, struct sgx_epc_page, list);
 
+		if (page->poison) {
+			list_del(&page->list);
+			list_add(&page->list, &sgx_poison_page_list);
+			continue;
+		}
+
 		ret = __eremove(sgx_get_epc_virt_addr(page));
 		if (!ret) {
 			/*
@@ -626,7 +633,11 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 
 	spin_lock(&node->lock);
 
-	list_add_tail(&page->list, &node->free_page_list);
+	page->owner = NULL;
+	if (page->poison)
+		list_add(&page->list, &sgx_poison_page_list);
+	else
+		list_add_tail(&page->list, &node->free_page_list);
 	sgx_nr_free_pages++;
 	page->flags = 0;
 
@@ -658,6 +669,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 		section->pages[i].section = index;
 		section->pages[i].flags = SGX_EPC_PAGE_IN_USE;
 		section->pages[i].owner = NULL;
+		section->pages[i].poison = 0;
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index f9202d3d6278..a990a4c9a00f 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -31,7 +31,8 @@
 
 struct sgx_epc_page {
 	unsigned int section;
-	unsigned int flags;
+	u16 flags;
+	u16 poison;
 	struct sgx_encl_page *owner;
 	struct list_head list;
 };
-- 
2.31.1

