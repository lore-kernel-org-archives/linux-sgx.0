Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCE1C4332F
	for <linux-sgx@archiver.kernel.org>; Mon, 27 Sep 2021 21:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16F4861058
	for <linux-sgx@archiver.kernel.org>; Mon, 27 Sep 2021 21:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237149AbhI0Vgk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 27 Sep 2021 17:36:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:2372 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237050AbhI0Vgk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 27 Sep 2021 17:36:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288227512"
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="288227512"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 14:35:01 -0700
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="561547582"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 14:35:00 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 3/7] x86/sgx: Initial poison handling for dirty and free pages
Date:   Mon, 27 Sep 2021 14:34:48 -0700
Message-Id: <20210927213452.212470-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927213452.212470-1-tony.luck@intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
 <20210927213452.212470-1-tony.luck@intel.com>
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

Add debugfs files /sys/kernel/debug/sgx/poison_page_list so that system
administrators get a list of those pages that have been dropped because
of poison.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 31 ++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 09fa42690ff2..b558c9a80af4 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*  Copyright(c) 2016-20 Intel Corporation. */
 
+#include <linux/debugfs.h>
 #include <linux/file.h>
 #include <linux/freezer.h>
 #include <linux/highmem.h>
@@ -43,6 +44,7 @@ static nodemask_t sgx_numa_mask;
 static struct sgx_numa_node *sgx_numa_nodes;
 
 static LIST_HEAD(sgx_dirty_page_list);
+static LIST_HEAD(sgx_poison_page_list);
 
 /*
  * Reset post-kexec EPC pages to the uninitialized state. The pages are removed
@@ -62,6 +64,12 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
 
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
@@ -626,7 +634,11 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 
 	spin_lock(&node->lock);
 
-	list_add_tail(&page->list, &node->free_page_list);
+	page->owner = NULL;
+	if (page->poison)
+		list_add(&page->list, &sgx_poison_page_list);
+	else
+		list_add_tail(&page->list, &node->free_page_list);
 	sgx_nr_free_pages++;
 	page->flags = 0;
 
@@ -658,6 +670,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 		section->pages[i].section = index;
 		section->pages[i].flags = SGX_EPC_PAGE_IN_USE;
 		section->pages[i].owner = NULL;
+		section->pages[i].poison = 0;
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
 
@@ -801,8 +814,21 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+static int poison_list_show(struct seq_file *m, void *private)
+{
+	struct sgx_epc_page *page;
+
+	list_for_each_entry(page, &sgx_poison_page_list, list)
+		seq_printf(m, "0x%lx\n", sgx_get_epc_phys_addr(page));
+
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(poison_list);
+
 static int __init sgx_init(void)
 {
+	struct dentry *dir;
 	int ret;
 	int i;
 
@@ -834,6 +860,9 @@ static int __init sgx_init(void)
 	if (sgx_vepc_init() && ret)
 		goto err_provision;
 
+	dir = debugfs_create_dir("sgx", arch_debugfs_dir);
+	debugfs_create_file("poison_page_list", 0400, dir, NULL, &poison_list_fops);
+
 	return 0;
 
 err_provision:
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

