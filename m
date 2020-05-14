Return-Path: <SRS0=4/gY=64=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040BFC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 08:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78C220575
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 08:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgENIBv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 04:01:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:5952 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbgENIBv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 04:01:51 -0400
IronPort-SDR: 4HJGKCOHGaSXwSAZxcEk+3V1LqYRJwe7JhhQ6BkHqdbbU3aPbojoDVEkj2g90tTGycsu7gTIgs
 hWN/Lip9vwEg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 01:01:50 -0700
IronPort-SDR: Zbpbjb/uQKCVyyS3Ddhmx4sr1vxacKPat4AUJHMxiu2meCjb54xPF0LmxLSrT2X2qpZWYWcvI3
 dNcOcXLDCUGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,390,1583222400"; 
   d="scan'208";a="251585456"
Received: from aburovox-mobl.ger.corp.intel.com (HELO localhost) ([10.249.39.145])
  by orsmga007.jf.intel.com with ESMTP; 14 May 2020 01:01:48 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v3] x86/sgx: Hack in idea for allocating from local EPC node when possible
Date:   Thu, 14 May 2020 11:01:44 +0300
Message-Id: <20200514080144.73733-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Allocate EPC from the local node when possible.  There is no new NUMA
enumeration for EPC.  Because EPC is carved out of RAM on bare metal,
the sections are naturally covered by the existing ACPI SRAT entries,
i.e. can be found by querying the kernel's NUMA info.

Keep the per-section tracking to simplify iterating over all sections
and reverse lookups given an EPC page.

Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
v3:
- Replace sgx_epc_numa_node_id() with a simpler sgx_pfn_to_nid()
  function (i.e. no need to convert from pfn's to addresses).
- Get rid of CONFIG_NUMA checks as NUMA helpers should do the
  "right thing".
- Rename sgx_epc_node as sgx_numa_node.
 arch/x86/kernel/cpu/sgx/main.c    | 75 ++++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/sgx/reclaim.c |  6 +--
 arch/x86/kernel/cpu/sgx/sgx.h     |  6 +--
 3 files changed, 71 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 5ce77e554676..a4affa09d130 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -11,7 +11,15 @@
 #include "driver.h"
 #include "encls.h"
 
-struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+struct sgx_numa_node {
+	struct sgx_epc_section sections[SGX_MAX_EPC_SECTIONS];
+	int nr_sections;
+};
+
+static struct sgx_numa_node sgx_numa_nodes[MAX_NUMNODES];
+static int sgx_nr_epc_nodes;
+
+struct sgx_epc_section *sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 int sgx_nr_epc_sections;
 
 static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section)
@@ -28,6 +36,26 @@ static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section
 	return page;
 }
 
+static struct sgx_epc_page *sgx_try_alloc_page_node(int nid)
+{
+	struct sgx_numa_node *node = &sgx_numa_nodes[nid];
+	struct sgx_epc_section *section;
+	struct sgx_epc_page *page;
+	int i;
+
+	for (i = 0; i < node->nr_sections; i++) {
+		section = &node->sections[i];
+		spin_lock(&section->lock);
+		page = __sgx_try_alloc_page(section);
+		spin_unlock(&section->lock);
+
+		if (page)
+			return page;
+	}
+
+	return NULL;
+}
+
 /**
  * sgx_try_alloc_page() - Allocate an EPC page
  *
@@ -39,16 +67,19 @@ static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section
  */
 struct sgx_epc_page *sgx_try_alloc_page(void)
 {
-	struct sgx_epc_section *section;
 	struct sgx_epc_page *page;
+	int nid = numa_node_id();
 	int i;
 
-	for (i = 0; i < sgx_nr_epc_sections; i++) {
-		section = &sgx_epc_sections[i];
-		spin_lock(&section->lock);
-		page = __sgx_try_alloc_page(section);
-		spin_unlock(&section->lock);
+	page = sgx_try_alloc_page_node(nid);
+	if (page)
+		return page;
+
+	for (i = 0; i < sgx_nr_epc_nodes; i++) {
+		if (i == nid)
+			continue;
 
+		page = sgx_try_alloc_page_node(i);
 		if (page)
 			return page;
 	}
@@ -192,7 +223,23 @@ static void __init sgx_page_cache_teardown(void)
 	int i;
 
 	for (i = 0; i < sgx_nr_epc_sections; i++)
-		sgx_free_epc_section(&sgx_epc_sections[i]);
+		sgx_free_epc_section(sgx_epc_sections[i]);
+}
+
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
 }
 
 /**
@@ -209,8 +256,9 @@ static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
 static bool __init sgx_page_cache_init(void)
 {
 	u32 eax, ebx, ecx, edx, type;
+	struct sgx_numa_node *node;
+	int i, j, nid;
 	u64 pa, size;
-	int i;
 
 	for (i = 0; i <= ARRAY_SIZE(sgx_epc_sections); i++) {
 		cpuid_count(SGX_CPUID, i + SGX_CPUID_FIRST_VARIABLE_SUB_LEAF,
@@ -235,11 +283,18 @@ static bool __init sgx_page_cache_init(void)
 
 		pr_info("EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
 
-		if (!sgx_alloc_epc_section(pa, size, i, &sgx_epc_sections[i])) {
+		nid = sgx_pfn_to_nid(PFN_DOWN(pa));
+		node = &sgx_numa_nodes[nid];
+		j = node->nr_sections++;
+
+		if (!sgx_alloc_epc_section(pa, size, i, &node->sections[j])) {
 			pr_err("No free memory for an EPC section\n");
+			node->nr_sections--;
 			break;
 		}
 
+		sgx_nr_epc_nodes = max(sgx_nr_epc_nodes, nid + 1);
+		sgx_epc_sections[i] = &node->sections[j];
 		sgx_nr_epc_sections++;
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index fb521f314fb7..16707d6f06b2 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -56,17 +56,17 @@ static int ksgxswapd(void *p)
 	 * on kmemexec.
 	 */
 	for (i = 0; i < sgx_nr_epc_sections; i++)
-		sgx_sanitize_section(&sgx_epc_sections[i]);
+		sgx_sanitize_section(sgx_epc_sections[i]);
 
 	/*
 	 * 2nd round for the SECS pages as they cannot be removed when they
 	 * still hold child pages.
 	 */
 	for (i = 0; i < sgx_nr_epc_sections; i++) {
-		sgx_sanitize_section(&sgx_epc_sections[i]);
+		sgx_sanitize_section(sgx_epc_sections[i]);
 
 		/* Should never happen. */
-		if (!list_empty(&sgx_epc_sections[i].unsanitized_page_list))
+		if (!list_empty(&sgx_epc_sections[i]->unsanitized_page_list))
 			WARN(1, "EPC section %d has unsanitized pages.\n", i);
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 0c481e6f2c95..c0a2ccf593f5 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -55,11 +55,11 @@ enum sgx_epc_page_desc {
 
 #define SGX_MAX_EPC_SECTIONS (SGX_EPC_SECTION_MASK + 1)
 
-extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+extern struct sgx_epc_section *sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 
 static inline struct sgx_epc_section *sgx_epc_section(struct sgx_epc_page *page)
 {
-	return &sgx_epc_sections[page->desc & SGX_EPC_SECTION_MASK];
+	return sgx_epc_sections[page->desc & SGX_EPC_SECTION_MASK];
 }
 
 static inline void *sgx_epc_addr(struct sgx_epc_page *page)
@@ -85,7 +85,7 @@ static inline unsigned long sgx_nr_free_pages(void)
 	int i;
 
 	for (i = 0; i < sgx_nr_epc_sections; i++)
-		cnt += sgx_epc_sections[i].free_cnt;
+		cnt += sgx_epc_sections[i]->free_cnt;
 
 	return cnt;
 }
-- 
2.25.1

