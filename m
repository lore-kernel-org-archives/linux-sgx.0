Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5824C433DB
	for <linux-sgx@archiver.kernel.org>; Sun, 21 Feb 2021 02:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CF3564EF2
	for <linux-sgx@archiver.kernel.org>; Sun, 21 Feb 2021 02:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhBUCHe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 20 Feb 2021 21:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229826AbhBUCHd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 20 Feb 2021 21:07:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10FEF64EF2;
        Sun, 21 Feb 2021 02:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613873208;
        bh=Nm+5OkKW4X7QmW/uKwyf/FKGq/9207/TvxjJOKuREHs=;
        h=From:To:Cc:Subject:Date:From;
        b=DIzy17qAEc1Jgi+GT/lBeEN09XCUU26SQpcA1V0+Ex0vhmyg+LuexROdEqgiv5WES
         4Q5WhjfzhvbvK1JJiSCSsCjYQTymmM9mR69KLIsbtN1PI16S+0PR2JEw3WoSASfX7G
         V+gsqX5Yam2RcOGxKVCH3buagX42ONQaus7deE+NxDkJ9Dj75liwwq3eViaecZLeba
         KfxwWT90yfHh3UXyOJq/cX45ZAhZBPnEkZNhZlK2laFzAhuUJ0HmmiMQnYRQU+R6MG
         tLq0bD+wjIQcTzriDy5fcB94CYqKKqzcToep0naronywIX+/FTi7gHfyUHMWWzMLun
         D4cJtfDbC0O5w==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com, dan.j.williams@intel.com,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()
Date:   Sun, 21 Feb 2021 04:06:30 +0200
Message-Id: <20210221020631.171404-1-jarkko@kernel.org>
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
 arch/x86/Kconfig               |  1 +
 arch/x86/kernel/cpu/sgx/main.c | 52 +++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h  |  1 +
 3 files changed, 53 insertions(+), 1 deletion(-)

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
index 8df81a3ed945..21addedc5240 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -18,6 +18,12 @@ static int sgx_nr_epc_sections;
 static struct task_struct *ksgxd_tsk;
 static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
 
+/* Nodes with one or more EPC sections. */
+static nodemask_t sgx_numa_mask;
+
+/* Array of lists of EPC sections for each NUMA node. */
+struct list_head *sgx_numa_nodes;
+
 /*
  * These variables are part of the state of the reclaimer, and must be accessed
  * with sgx_reclaimer_lock acquired.
@@ -473,6 +479,26 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
 	return page;
 }
 
+static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
+{
+	struct sgx_epc_section *section;
+	struct sgx_epc_page *page;
+
+	if (WARN_ON_ONCE(nid < 0 || nid >= MAX_NUMNODES))
+		return NULL;
+
+	if (!node_isset(nid, sgx_numa_mask))
+		return NULL;
+
+	list_for_each_entry(section, &sgx_numa_nodes[nid], section_list) {
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
@@ -485,13 +511,17 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
  */
 struct sgx_epc_page *__sgx_alloc_epc_page(void)
 {
+	int current_nid = numa_node_id();
 	struct sgx_epc_section *section;
 	struct sgx_epc_page *page;
 	int i;
 
+	page = __sgx_alloc_epc_page_from_node(current_nid);
+	if (page)
+		return page;
+
 	for (i = 0; i < sgx_nr_epc_sections; i++) {
 		section = &sgx_epc_sections[i];
-
 		page = __sgx_alloc_epc_page_from_section(section);
 		if (page)
 			return page;
@@ -665,8 +695,12 @@ static bool __init sgx_page_cache_init(void)
 {
 	u32 eax, ebx, ecx, edx, type;
 	u64 pa, size;
+	int nid;
 	int i;
 
+	nodes_clear(sgx_numa_mask);
+	sgx_numa_nodes = kmalloc_array(MAX_NUMNODES, sizeof(*sgx_numa_nodes), GFP_KERNEL);
+
 	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
 		cpuid_count(SGX_CPUID, i + SGX_CPUID_EPC, &eax, &ebx, &ecx, &edx);
 
@@ -690,6 +724,22 @@ static bool __init sgx_page_cache_init(void)
 		}
 
 		sgx_nr_epc_sections++;
+
+		nid = numa_map_to_online_node(phys_to_target_node(pa));
+
+		if (nid == NUMA_NO_NODE) {
+			pr_err(FW_BUG "unable to map EPC section %d to online node.\n", nid);
+			nid = 0;
+		} else if (WARN_ON_ONCE(nid < 0 || nid >= MAX_NUMNODES)) {
+			nid = 0;
+		}
+
+		if (!node_isset(nid, sgx_numa_mask)) {
+			INIT_LIST_HEAD(&sgx_numa_nodes[nid]);
+			node_set(nid, sgx_numa_mask);
+		}
+
+		list_add_tail(&sgx_epc_sections[i].section_list, &sgx_numa_nodes[nid]);
 	}
 
 	if (!sgx_nr_epc_sections) {
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 5fa42d143feb..4bc31bc4bacf 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -45,6 +45,7 @@ struct sgx_epc_section {
 	spinlock_t lock;
 	struct list_head page_list;
 	unsigned long free_cnt;
+	struct list_head section_list;
 
 	/*
 	 * Pages which need EREMOVE run on them before they can be
-- 
2.30.1

