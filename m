Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF5DC4361B
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Dec 2020 13:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF8B23109
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Dec 2020 13:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgLPNv0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Dec 2020 08:51:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgLPNv0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Dec 2020 08:51:26 -0500
From:   Jarkko Sakkinen <jarkko@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH RFC] x86/sgx: Add trivial NUMA allocation
Date:   Wed, 16 Dec 2020 15:50:31 +0200
Message-Id: <20201216135031.21518-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Create a pointer array for each NUMA node with the references to the
contained EPC sections. Use this in __sgx_alloc_epc_page() to knock the
current NUMA node before the others.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 66 +++++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c519fc5f6948..0da510763c47 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -13,6 +13,13 @@
 #include "encl.h"
 #include "encls.h"
 
+struct sgx_numa_node {
+	struct sgx_epc_section *sections[SGX_MAX_EPC_SECTIONS];
+	int nr_sections;
+};
+
+static struct sgx_numa_node sgx_numa_nodes[MAX_NUMNODES];
+static int sgx_nr_numa_nodes;
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 static int sgx_nr_epc_sections;
 static struct task_struct *ksgxd_tsk;
@@ -473,6 +480,25 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
 	return page;
 }
 
+static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
+{
+	struct sgx_numa_node *node = &sgx_numa_nodes[nid];
+	struct sgx_epc_section *section;
+	struct sgx_epc_page *page;
+	int i;
+
+	for (i = 0; i < node->nr_sections; i++) {
+		section = node->sections[i];
+
+		page = __sgx_alloc_epc_page_from_section(section);
+		if (page)
+			return page;
+	}
+
+	return NULL;
+}
+
+
 /**
  * __sgx_alloc_epc_page() - Allocate an EPC page
  *
@@ -485,14 +511,19 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
  */
 struct sgx_epc_page *__sgx_alloc_epc_page(void)
 {
-	struct sgx_epc_section *section;
 	struct sgx_epc_page *page;
+	int nid = numa_node_id();
 	int i;
 
-	for (i = 0; i < sgx_nr_epc_sections; i++) {
-		section = &sgx_epc_sections[i];
+	page = __sgx_alloc_epc_page_from_node(nid);
+	if (page)
+		return page;
 
-		page = __sgx_alloc_epc_page_from_section(section);
+	for (i = 0; i < sgx_nr_numa_nodes; i++) {
+		if (i == nid)
+			continue;
+
+		page = __sgx_alloc_epc_page_from_node(i);
 		if (page)
 			return page;
 	}
@@ -661,11 +692,28 @@ static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
 	       ((high & GENMASK_ULL(19, 0)) << 32);
 }
 
+static int __init sgx_pfn_to_nid(unsigned long pfn)
+{
+	pg_data_t *pgdat;
+	int nid;
+
+	for (nid = 0; nid < nr_node_ids; nid++) {
+		pgdat = NODE_DATA(nid);
+
+		if (pfn >= pgdat->node_start_pfn &&
+		    pfn < (pgdat->node_start_pfn + pgdat->node_spanned_pages))
+			return nid;
+	}
+
+	return 0;
+}
+
 static bool __init sgx_page_cache_init(void)
 {
 	u32 eax, ebx, ecx, edx, type;
+	struct sgx_numa_node *node;
 	u64 pa, size;
-	int i;
+	int i, nid;
 
 	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
 		cpuid_count(SGX_CPUID, i + SGX_CPUID_EPC, &eax, &ebx, &ecx, &edx);
@@ -690,6 +738,14 @@ static bool __init sgx_page_cache_init(void)
 		}
 
 		sgx_nr_epc_sections++;
+
+		nid = sgx_pfn_to_nid(PFN_DOWN(pa));
+		node = &sgx_numa_nodes[nid];
+
+		node->sections[node->nr_sections] = &sgx_epc_sections[i];
+		node->nr_sections++;
+
+		sgx_nr_numa_nodes = max(sgx_nr_numa_nodes, nid + 1);
 	}
 
 	if (!sgx_nr_epc_sections) {
-- 
2.27.0

