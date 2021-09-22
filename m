Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5F9C433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Sep 2021 18:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A453961211
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Sep 2021 18:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbhIVSXD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 Sep 2021 14:23:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:16951 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237005AbhIVSXB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 22 Sep 2021 14:23:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="309220311"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="309220311"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 11:21:31 -0700
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="474789105"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 11:21:30 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v6 3/7] x86/sgx: Initial poison handling for dirty and free pages
Date:   Wed, 22 Sep 2021 11:21:19 -0700
Message-Id: <20210922182123.200105-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210922182123.200105-1-tony.luck@intel.com>
References: <20210917213836.175138-1-tony.luck@intel.com>
 <20210922182123.200105-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/sgx/main.c | 30 +++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++-
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 72a173b3affa..91be079788ee 100644
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
@@ -626,7 +634,10 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	spin_lock(&node->lock);
 
 	page->owner = NULL;
-	list_add_tail(&page->list, &node->free_page_list);
+	if (page->poison)
+		list_add(&page->list, &sgx_poison_page_list);
+	else
+		list_add_tail(&page->list, &node->free_page_list);
 	sgx_nr_free_pages++;
 
 	spin_unlock(&node->lock);
@@ -656,6 +667,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
 		section->pages[i].flags = 0;
+		section->pages[i].poison = 0;
 		section->pages[i].owner = (void *)-1;
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
@@ -800,8 +812,21 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
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
 
@@ -833,6 +858,9 @@ static int __init sgx_init(void)
 	if (sgx_vepc_init() && ret)
 		goto err_provision;
 
+	dir = debugfs_create_dir("sgx", arch_debugfs_dir);
+	debugfs_create_file("poison_page_list", 0400, dir, NULL, &poison_list_fops);
+
 	return 0;
 
 err_provision:
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index cc624778645f..9ba87bc3da61 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -28,7 +28,8 @@
 
 struct sgx_epc_page {
 	unsigned int section;
-	unsigned int flags;
+	u16 flags;
+	u16 poison;
 	void *owner;
 	struct list_head list;
 };
-- 
2.31.1

