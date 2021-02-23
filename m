Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221F0C433DB
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Feb 2021 21:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62F064E3F
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Feb 2021 21:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhBWVgk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Feb 2021 16:36:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhBWVgk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Feb 2021 16:36:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD2CF64E3F;
        Tue, 23 Feb 2021 21:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614116159;
        bh=oCn+ICFCTlPqHEoyhjEnI/hVuTOj7gOShWlhL9lsoI0=;
        h=From:To:Cc:Subject:Date:From;
        b=iFigILfrUpzpUi/s+R392IqayNh9foZaY+P0UX7kBA3fVh+Bq1lDfzrZaNKnlB383
         QQpa1ieUKR5a8bG2DQ0OPskN1PvO486PVGsmjZ4l4I/XQHn9UJEaYZ4rtPDHxS5J5x
         ONP2qJO9JXqDOIShJf4g7UrLgG65Y+R+Gs/JAlJGWyvQPP4lChw9q65cEvLFuqimnY
         OpmpLtSipJBDT0f7LqU/ynXgNhKHPeL/jamCujwy+BSVNVrGfEC4JRX0A1zLACksvp
         KGNOVQcTcNqOr7lCN5wlIjv6UbGfv9F1IffJJ5l32+oqzVsANXvJkiAQldcQeFgngY
         gwLCY/T8hVGlg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com, dan.j.williams@intel.com,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()
Date:   Tue, 23 Feb 2021 23:35:41 +0200
Message-Id: <20210223213541.284871-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
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

It does not try to fully address NUMA. For instance, it does not provide
integration to the mempolicy API, but neither does introduce any
bottlenecks to address this later on. Memory allocation is a complex topic,
and thus it's better to start with baby steps.

Solution
========

Use phys_to_target_node() to associate each NUMA node with the EPC sections
contained within its range.

In sgx_alloc_epc_page(), first try to allocate from the NUMA node, where
the CPU is executing. If that fails, fallback to the legacy allocation.

Link: https://lore.kernel.org/lkml/158188326978.894464.217282995221175417.stgit@dwillia2-desk3.amr.corp.intel.com/
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---

v2:
* s/section_list/numa_section_list/
* s/MAX_NUMNODES//num_possible_nodes()/
* Add more verbose inline comments that Dave provided.
* If NUMA mapping fails, print a warning and description of the fallbck.
  The physical address is alredy printed in pr_info(), just before the
  mapping happens.

 arch/x86/Kconfig               |  1 +
 arch/x86/kernel/cpu/sgx/main.c | 57 +++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h  |  1 +
 3 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 21f851179ff0..dcb73a5edf63 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1941,6 +1941,7 @@ config X86_SGX
 	depends on CRYPTO_SHA256=y
 	select SRCU
 	select MMU_NOTIFIER
+	select NUMA_KEEP_MEMINFO if NUMA
 	help
 	  Intel(R) Software Guard eXtensions (SGX) is a set of CPU instructions
 	  that can be used by applications to set aside private regions of code
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8df81a3ed945..8d9eab999c3b 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -18,6 +18,16 @@ static int sgx_nr_epc_sections;
 static struct task_struct *ksgxd_tsk;
 static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
 
+/* Nodes with one or more EPC sections. */
+static nodemask_t sgx_numa_mask;
+
+/*
+ * Array with one list_head for each possible NUMA node.  Each
+ * list contains all the sgx_epc_section's which are on that
+ * node.
+ */
+struct list_head *sgx_numa_nodes;
+
 /*
  * These variables are part of the state of the reclaimer, and must be accessed
  * with sgx_reclaimer_lock acquired.
@@ -473,6 +483,26 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
 	return page;
 }
 
+static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
+{
+	struct sgx_epc_section *section;
+	struct sgx_epc_page *page;
+
+	if (WARN_ON_ONCE(nid < 0 || nid >= num_possible_nodes()))
+		return NULL;
+
+	if (!node_isset(nid, sgx_numa_mask))
+		return NULL;
+
+	list_for_each_entry(section, &sgx_numa_nodes[nid], numa_section_list) {
+		page = __sgx_alloc_epc_page_from_section(section);
+		if (page)
+			return page;
+	}
+
+	return NULL;
+}
+
 /**
  * __sgx_alloc_epc_page() - Allocate an EPC page
  *
@@ -485,13 +515,19 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
  */
 struct sgx_epc_page *__sgx_alloc_epc_page(void)
 {
+	int current_nid = numa_node_id();
 	struct sgx_epc_section *section;
 	struct sgx_epc_page *page;
 	int i;
 
+	/* Try to allocate EPC from the current node, first: */
+	page = __sgx_alloc_epc_page_from_node(current_nid);
+	if (page)
+		return page;
+
+	/* Search all EPC sections, ignoring locality: */
 	for (i = 0; i < sgx_nr_epc_sections; i++) {
 		section = &sgx_epc_sections[i];
-
 		page = __sgx_alloc_epc_page_from_section(section);
 		if (page)
 			return page;
@@ -665,8 +701,12 @@ static bool __init sgx_page_cache_init(void)
 {
 	u32 eax, ebx, ecx, edx, type;
 	u64 pa, size;
+	int nid;
 	int i;
 
+	nodes_clear(sgx_numa_mask);
+	sgx_numa_nodes = kmalloc_array(num_possible_nodes(), sizeof(*sgx_numa_nodes), GFP_KERNEL);
+
 	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
 		cpuid_count(SGX_CPUID, i + SGX_CPUID_EPC, &eax, &ebx, &ecx, &edx);
 
@@ -690,6 +730,21 @@ static bool __init sgx_page_cache_init(void)
 		}
 
 		sgx_nr_epc_sections++;
+
+		nid = numa_map_to_online_node(phys_to_target_node(pa));
+
+		if (nid == NUMA_NO_NODE) {
+			/* The physical address is already printed above. */
+			pr_warn(FW_BUG "Unable to map EPC section to online node. Fallback to the NUMA node 0.\n");
+			nid = 0;
+		}
+
+		if (!node_isset(nid, sgx_numa_mask)) {
+			INIT_LIST_HEAD(&sgx_numa_nodes[nid]);
+			node_set(nid, sgx_numa_mask);
+		}
+
+		list_add_tail(&sgx_epc_sections[i].numa_section_list, &sgx_numa_nodes[nid]);
 	}
 
 	if (!sgx_nr_epc_sections) {
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 5fa42d143feb..2e8a07cf92a6 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -45,6 +45,7 @@ struct sgx_epc_section {
 	spinlock_t lock;
 	struct list_head page_list;
 	unsigned long free_cnt;
+	struct list_head numa_section_list;
 
 	/*
 	 * Pages which need EREMOVE run on them before they can be
-- 
2.30.1

