Return-Path: <SRS0=4/gY=64=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE31CC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 05:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B493206D4
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 05:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgENFKi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 01:10:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:3671 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgENFKi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 01:10:38 -0400
IronPort-SDR: aPhfIeXr37X6Zfkc/UCH2+vRw9W2Ldrcyj/MoDMXa6oFD3lrlxHti8Hn+hWX3g2akZVBSbPe9h
 QlPptA1LH+hw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 22:10:37 -0700
IronPort-SDR: AK+ULam2esXpnkPyWUmThZRoX6cSKNF6A0X8D3AIn2J28Aer/YWtDPOAqW6zOSEVf70CS8Npci
 7eiqc+aR+Grg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,390,1583222400"; 
   d="scan'208";a="298592454"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 13 May 2020 22:10:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH v2] x86/sgx: Hack in idea for allocating from local EPC node when possible
Date:   Wed, 13 May 2020 22:10:36 -0700
Message-Id: <20200514051036.14552-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Allocate EPC from the local node when possible.  There is no new NUMA
enumeration for EPC.  Because EPC is carved out of RAM on bare metal,
the sections are naturally covered by the existing ACPI SRAT entries,
i.e. can be found by querying the kernel's NUMA info.

Keep the per-section tracking to simplify iterating over all sections
and reverse lookups given an EPC page.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I like this version a lot more.  Far less clever and doesn't assume
anything about number of EPC sections vs. NUMA nodes.

As before, compile tested only.

For folks (especially non-Intel people) who may be confused, this is a
less-than-an-RFC patch to frame in an idea for adding basic NUMA awareness
for EPC sections without (yet) supporting full mempolicy stuff.

 arch/x86/kernel/cpu/sgx/main.c    | 95 +++++++++++++++++++++++++------
 arch/x86/kernel/cpu/sgx/reclaim.c |  6 +-
 arch/x86/kernel/cpu/sgx/sgx.h     |  6 +-
 3 files changed, 84 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 5ce77e5546766..3128b4fa5ff4f 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -11,7 +11,15 @@
 #include "driver.h"
 #include "encls.h"
 
-struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+struct sgx_epc_node {
+	struct sgx_epc_section sections[SGX_MAX_EPC_SECTIONS];
+	int nr_sections;
+};
+
+static struct sgx_epc_node sgx_epc_nodes[MAX_NUMNODES];
+static int sgx_nr_epc_nodes;
+
+struct sgx_epc_section *sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 int sgx_nr_epc_sections;
 
 static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section)
@@ -28,23 +36,15 @@ static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section
 	return page;
 }
 
-/**
- * sgx_try_alloc_page() - Allocate an EPC page
- *
- * Try to grab a page from the free EPC page list.
- *
- * Return:
- *   a pointer to a &struct sgx_epc_page instance,
- *   -errno on error
- */
-struct sgx_epc_page *sgx_try_alloc_page(void)
+static struct sgx_epc_page *sgx_try_alloc_page_node(int nid)
 {
+	struct sgx_epc_node *node = &sgx_epc_nodes[nid];
 	struct sgx_epc_section *section;
 	struct sgx_epc_page *page;
 	int i;
 
-	for (i = 0; i < sgx_nr_epc_sections; i++) {
-		section = &sgx_epc_sections[i];
+	for (i = 0; i < node->nr_sections; i++) {
+		section = &node->sections[i];
 		spin_lock(&section->lock);
 		page = __sgx_try_alloc_page(section);
 		spin_unlock(&section->lock);
@@ -53,6 +53,41 @@ struct sgx_epc_page *sgx_try_alloc_page(void)
 			return page;
 	}
 
+	return NULL;
+}
+
+/**
+ * sgx_try_alloc_page() - Allocate an EPC page
+ *
+ * Try to grab a page from the free EPC page list.
+ *
+ * Return:
+ *   a pointer to a &struct sgx_epc_page instance,
+ *   -errno on error
+ */
+struct sgx_epc_page *sgx_try_alloc_page(void)
+{
+	struct sgx_epc_page *page;
+	int nid = numa_node_id();
+#ifdef CONFIG_NUMA
+	int i;
+#endif
+
+	page = sgx_try_alloc_page_node(nid);
+	if (page)
+		return page;
+
+#ifdef CONFIG_NUMA
+	for (i = 0; i < sgx_nr_epc_nodes; i++) {
+		if (i == nid)
+			continue;
+
+		page = sgx_try_alloc_page_node(i);
+		if (page)
+			return page;
+	}
+#endif
+
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -192,7 +227,26 @@ static void __init sgx_page_cache_teardown(void)
 	int i;
 
 	for (i = 0; i < sgx_nr_epc_sections; i++)
-		sgx_free_epc_section(&sgx_epc_sections[i]);
+		sgx_free_epc_section(sgx_epc_sections[i]);
+}
+
+static int __init sgx_epc_numa_node_id(unsigned long epc_pa)
+{
+#ifdef CONFIG_NUMA
+	unsigned long start, end;
+	pg_data_t *pgdat;
+	int nid;
+
+	for (nid = 0; nid < nr_node_ids; nid++) {
+		pgdat = NODE_DATA(nid);
+		start = pgdat->node_start_pfn << PAGE_SHIFT;
+		end = start + (pgdat->node_spanned_pages << PAGE_SHIFT);
+
+		if (epc_pa >= start && epc_pa < end)
+			return nid;
+	}
+#endif
+	return 0;
 }
 
 /**
@@ -209,8 +263,9 @@ static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
 static bool __init sgx_page_cache_init(void)
 {
 	u32 eax, ebx, ecx, edx, type;
+	struct sgx_epc_node *node;
+	int i, j, nid;
 	u64 pa, size;
-	int i;
 
 	for (i = 0; i <= ARRAY_SIZE(sgx_epc_sections); i++) {
 		cpuid_count(SGX_CPUID, i + SGX_CPUID_FIRST_VARIABLE_SUB_LEAF,
@@ -235,11 +290,17 @@ static bool __init sgx_page_cache_init(void)
 
 		pr_info("EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
 
-		if (!sgx_alloc_epc_section(pa, size, i, &sgx_epc_sections[i])) {
+		nid = sgx_epc_numa_node_id(pa);
+		node = &sgx_epc_nodes[nid];
+		j = node->nr_sections++;
+
+		if (!sgx_alloc_epc_section(pa, size, i, &node->sections[j])) {
 			pr_err("No free memory for an EPC section\n");
+			node->nr_sections--;
 			break;
 		}
-
+		sgx_nr_epc_nodes = max(sgx_nr_epc_nodes, nid + 1);
+		sgx_epc_sections[i] = &node->sections[j];
 		sgx_nr_epc_sections++;
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index fb521f314fb7a..16707d6f06b2f 100644
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
index 0c481e6f2c95e..c0a2ccf593f52 100644
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
2.26.0

