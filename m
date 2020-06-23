Return-Path: <SRS0=69V/=AE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AF7C433E0
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Jun 2020 04:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D98206A5
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Jun 2020 04:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgFWEjk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Jun 2020 00:39:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:41152 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgFWEjj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Jun 2020 00:39:39 -0400
IronPort-SDR: LA9W6Pmf0agpRXoRmmxduEjlwvS4L1+H2RiPkByfvFOFJcBfcNYjLjdJhp6oCFlJNfyheRJ4T/
 w75uLGy9dfbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="209154818"
X-IronPort-AV: E=Sophos;i="5.75,269,1589266800"; 
   d="scan'208";a="209154818"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 21:39:38 -0700
IronPort-SDR: 6WcWwqblazNjBrPLlhbKXh7kdfXRC5atlTydEX/cFmh5lA/NRrAs+9ARxnH4fDEdzVzmk+1Fls
 YVjR2KAb6j9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,269,1589266800"; 
   d="scan'208";a="275222562"
Received: from jczajka-mobl.ger.corp.intel.com (HELO localhost) ([10.249.40.133])
  by orsmga003.jf.intel.com with ESMTP; 22 Jun 2020 21:39:34 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     kai.svahn@intel.com, bruce.schlobohm@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH RFC] x86/sgx: Allocate form local NUMA node first
Date:   Tue, 23 Jun 2020 07:39:31 +0300
Message-Id: <20200623043931.157156-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Create a pointer array for each NUMA node with the references to the
contained EPC sections. Use this in __sgx_alloc_epc_page() to knock the
current NUMA node before the others.

Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 70 ++++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 3594d37d545f..c9b47cf87730 100644
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
 static struct task_struct *ksgxswapd_tsk;
@@ -502,6 +509,27 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
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
+		spin_lock(&section->lock);
+		page = __sgx_alloc_epc_page_from_section(section);
+		spin_unlock(&section->lock);
+
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
@@ -514,16 +542,19 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
  */
 struct sgx_epc_page *__sgx_alloc_epc_page(void)
 {
-	struct sgx_epc_section *section;
 	struct sgx_epc_page *page;
+	int nid = numa_node_id();
 	int i;
 
-	for (i = 0; i < sgx_nr_epc_sections; i++) {
-		section = &sgx_epc_sections[i];
-		spin_lock(&section->lock);
-		page = __sgx_alloc_epc_page_from_section(section);
-		spin_unlock(&section->lock);
+	page = __sgx_alloc_epc_page_from_node(nid);
+	if (page)
+		return page;
 
+	for (i = 0; i < sgx_nr_numa_nodes; i++) {
+		if (i == nid)
+			continue;
+
+		page = __sgx_alloc_epc_page_from_node(i);
 		if (page)
 			return page;
 	}
@@ -684,11 +715,28 @@ static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
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
 		cpuid_count(SGX_CPUID, i + SGX_CPUID_FIRST_VARIABLE_SUB_LEAF,
@@ -714,6 +762,14 @@ static bool __init sgx_page_cache_init(void)
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
2.25.1

