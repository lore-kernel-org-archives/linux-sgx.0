Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F73C15521
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Mar 2021 00:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD58564F97
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Mar 2021 00:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240354AbhCDAtY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:49:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377930AbhCCPFP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 3 Mar 2021 10:05:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAE6664EE1;
        Wed,  3 Mar 2021 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614783838;
        bh=1TQwL7i+C+Ykj3EZaItYeEh6Eb4hhLbKnyOdnj0pVr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HW1H83bGkrj9yuExE+YUU/1c0gs58J8m6yLlRdQ+Lyv34iTMtK1TQuQCz1kKtNGi5
         CfgKhpmrhdiABxpgtwX8XjVEqHXCMA7xYNAdyNksnGa5+2L8oPFKlUfE2bbmKSeBca
         JhAdBVPPHh+AtfKwqvsUi80E1urbfAWD+MGBrwulZq77b0afmUwn0Ji3Zo/eTP/FAV
         FqROoW9wCfa44CrHRYjQ1HC0zgREz8ZfWNneyUYF2JOBzwKn0TSznwgGc7AhEGmhVr
         wHN8w9IIIHZ8p6yjG+5UC2+RM+vdu/X8NK4VOxMZHumT0OMp3ZlTu6WtrA2IlxDTJm
         08ABvOnlX1TWw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()
Date:   Wed,  3 Mar 2021 17:03:23 +0200
Message-Id: <20210303150323.433207-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210303150323.433207-1-jarkko@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Background
==========

EPC section is covered by one or more SRAT entries that are associated with
one and only one PXM (NUMA node). The motivation behind this patch is to
provide basic elements of building allocation scheme based on this premise.

Solution
========

Use phys_to_target_node() to associate each NUMA node with the EPC
sections contained within its range. In sgx_alloc_epc_page(), first try
to allocate from the NUMA node, where the CPU is executing. If that
fails, fallback to the legacy allocation.

Link: https://lore.kernel.org/lkml/158188326978.894464.217282995221175417.stgit@dwillia2-desk3.amr.corp.intel.com/
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/Kconfig               |  1 +
 arch/x86/kernel/cpu/sgx/main.c | 84 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h  |  9 ++++
 3 files changed, 94 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a5f6a3013138..7eb1e96cfe8a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1940,6 +1940,7 @@ config X86_SGX
 	depends on CRYPTO_SHA256=y
 	select SRCU
 	select MMU_NOTIFIER
+	select NUMA_KEEP_MEMINFO if NUMA
 	help
 	  Intel(R) Software Guard eXtensions (SGX) is a set of CPU instructions
 	  that can be used by applications to set aside private regions of code
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 58474480f5be..62cc0e1f0728 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -25,6 +25,23 @@ static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 /* The free page list lock protected variables prepend the lock. */
 static unsigned long sgx_nr_free_pages;
 static LIST_HEAD(sgx_free_page_list);
+
+/* Nodes with one or more EPC sections. */
+static nodemask_t sgx_numa_mask;
+
+/*
+ * Array with one list_head for each possible NUMA node.  Each
+ * list contains all the sgx_epc_section's which are on that
+ * node.
+ */
+static struct sgx_numa_node *sgx_numa_nodes;
+
+/*
+ * sgx_free_epc_page() uses this to find out the correct struct sgx_numa_node,
+ * to put the page in.
+ */
+static int sgx_section_to_numa_node_id[SGX_MAX_EPC_SECTIONS];
+
 static DEFINE_SPINLOCK(sgx_free_page_list_lock);
 
 /*
@@ -434,6 +451,36 @@ static bool __init sgx_page_reclaimer_init(struct list_head *laundry)
 	return true;
 }
 
+static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
+{
+	struct sgx_epc_page *page = NULL;
+	struct sgx_numa_node *sgx_node;
+
+	if (WARN_ON_ONCE(nid < 0 || nid >= num_possible_nodes()))
+		return NULL;
+
+	if (!node_isset(nid, sgx_numa_mask))
+		return NULL;
+
+	sgx_node = &sgx_numa_nodes[nid];
+
+	spin_lock(&sgx_free_page_list_lock);
+
+	if (list_empty(&sgx_node->free_page_list)) {
+		spin_unlock(&sgx_free_page_list_lock);
+		return NULL;
+	}
+
+	page = list_first_entry(&sgx_node->free_page_list, struct sgx_epc_page, numa_list);
+	list_del_init(&page->numa_list);
+	list_del_init(&page->list);
+	sgx_nr_free_pages--;
+
+	spin_unlock(&sgx_free_page_list_lock);
+
+	return page;
+}
+
 /**
  * __sgx_alloc_epc_page() - Allocate an EPC page
  *
@@ -446,8 +493,14 @@ static bool __init sgx_page_reclaimer_init(struct list_head *laundry)
  */
 struct sgx_epc_page *__sgx_alloc_epc_page(void)
 {
+	int current_nid = numa_node_id();
 	struct sgx_epc_page *page;
 
+	/* Try to allocate EPC from the current node, first: */
+	page = __sgx_alloc_epc_page_from_node(current_nid);
+	if (page)
+		return page;
+
 	spin_lock(&sgx_free_page_list_lock);
 
 	if (list_empty(&sgx_free_page_list)) {
@@ -456,6 +509,7 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 	}
 
 	page = list_first_entry(&sgx_free_page_list, struct sgx_epc_page, list);
+	list_del_init(&page->numa_list);
 	list_del_init(&page->list);
 	sgx_nr_free_pages--;
 
@@ -566,6 +620,8 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
  */
 void sgx_free_epc_page(struct sgx_epc_page *page)
 {
+	int nid = sgx_section_to_numa_node_id[page->section];
+	struct sgx_numa_node *sgx_node = &sgx_numa_nodes[nid];
 	int ret;
 
 	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
@@ -575,7 +631,15 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 		return;
 
 	spin_lock(&sgx_free_page_list_lock);
+
+	/*   Enable NUMA local allocation in sgx_alloc_epc_page(). */
+	if (!node_isset(nid, sgx_numa_mask)) {
+		INIT_LIST_HEAD(&sgx_node->free_page_list);
+		node_set(nid, sgx_numa_mask);
+	}
+
 	list_add_tail(&page->list, &sgx_free_page_list);
+	list_add_tail(&page->numa_list, &sgx_node->free_page_list);
 	sgx_nr_free_pages++;
 	spin_unlock(&sgx_free_page_list_lock);
 }
@@ -626,8 +690,28 @@ static bool __init sgx_page_cache_init(struct list_head *laundry)
 {
 	u32 eax, ebx, ecx, edx, type;
 	u64 pa, size;
+	int nid;
 	int i;
 
+	nodes_clear(sgx_numa_mask);
+	sgx_numa_nodes = kmalloc_array(num_possible_nodes(), sizeof(*sgx_numa_nodes), GFP_KERNEL);
+
+	/*
+	 * Create NUMA node lookup table for sgx_free_epc_page() as the very
+	 * first step, as it is used to populate the free list's during the
+	 * initialization.
+	 */
+	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
+		nid = numa_map_to_online_node(phys_to_target_node(pa));
+		if (nid == NUMA_NO_NODE) {
+			/* The physical address is already printed above. */
+			pr_warn(FW_BUG "Unable to map EPC section to online node. Fallback to the NUMA node 0.\n");
+			nid = 0;
+		}
+
+		sgx_section_to_numa_node_id[i] = nid;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
 		cpuid_count(SGX_CPUID, i + SGX_CPUID_EPC, &eax, &ebx, &ecx, &edx);
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 41ca045a574a..3a3c07fc0c8e 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -27,6 +27,7 @@ struct sgx_epc_page {
 	unsigned int flags;
 	struct sgx_encl_page *owner;
 	struct list_head list;
+	struct list_head numa_list;
 };
 
 /*
@@ -43,6 +44,14 @@ struct sgx_epc_section {
 
 extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 
+/*
+ * Contains the tracking data for NUMA nodes having EPC pages. Most importantly,
+ * the free page list local to the node is stored here.
+ */
+struct sgx_numa_node {
+	struct list_head free_page_list;
+};
+
 static inline unsigned long sgx_get_epc_phys_addr(struct sgx_epc_page *page)
 {
 	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
-- 
2.30.1

