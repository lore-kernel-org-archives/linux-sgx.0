Return-Path: <SRS0=4/gY=64=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5215C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 04:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBD0C206C0
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 04:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbgENEvs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 00:51:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:6895 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgENEvs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 00:51:48 -0400
IronPort-SDR: eVuliKuMloNoFfD1379NRRW8qGXSJc/Bd4P4i3nxkeh6kYHmDDSKiSNBx27NXFsl/n8KAD/uPa
 6aU8iR2U/guA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 21:51:47 -0700
IronPort-SDR: wVFq7idDWlKG3Lw1rKaae7LL956a0sqmxF9g+moWcEy+8l2140r43XZPNOE9lXMFLwopXkAEqm
 G+Oyr/0Q1RAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,390,1583222400"; 
   d="scan'208";a="464189858"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 13 May 2020 21:51:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH] x86/sgx: Hack in idea for allocating from local EPC node when possible
Date:   Wed, 13 May 2020 21:51:44 -0700
Message-Id: <20200514045144.2031-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Allocate EPC from the local node when possible.  Sort EPC sections so
that their index into sgx_epc_sections corresponds with their NUMA node
ID, allowing the NUMA lookup to run in O(1) time.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I'm only sending this for completeness, v2 will follow shortly.  v2 is
less hacky and properly handles the scenario of multiple EPC sections in a
single NUMA node.

 arch/x86/kernel/cpu/sgx/main.c | 57 +++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 5ce77e5546766..2aa83e701d3c5 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -12,6 +12,7 @@
 #include "encls.h"
 
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+struct sgx_epc_section __initdata unsorted_epc_sections[SGX_MAX_EPC_SECTIONS];
 int sgx_nr_epc_sections;
 
 static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section)
@@ -43,6 +44,19 @@ struct sgx_epc_page *sgx_try_alloc_page(void)
 	struct sgx_epc_page *page;
 	int i;
 
+#ifdef CONFIG_NUMA
+	i = numa_node_id();
+
+	if (i < sgx_nr_epc_sections) {
+		section = &sgx_epc_sections[i];
+		spin_lock(&section->lock);
+		page = __sgx_try_alloc_page(section);
+		spin_unlock(&section->lock);
+		if (page)
+			return page;
+	}
+#endif
+
 	for (i = 0; i < sgx_nr_epc_sections; i++) {
 		section = &sgx_epc_sections[i];
 		spin_lock(&section->lock);
@@ -195,6 +209,39 @@ static void __init sgx_page_cache_teardown(void)
 		sgx_free_epc_section(&sgx_epc_sections[i]);
 }
 
+static void __init sgx_page_cache_sort(struct sgx_epc_section *sorted,
+				       struct sgx_epc_section *unsorted,
+				       int nr_sections)
+{
+	struct sgx_epc_section *section;
+	unsigned long start, end;
+	pg_data_t *pgdat;
+	int i, nid;
+
+	for (i = 0; i < nr_sections; i++) {
+		section = &unsorted[i];
+		for (nid = 0; nid < nr_node_ids; nid++) {
+			pgdat = NODE_DATA(nid);
+			start = pgdat->node_start_pfn << PAGE_SHIFT;
+			end = start + (pgdat->node_spanned_pages << PAGE_SHIFT);
+
+			if (section->pa >= start && section->pa < end)
+				break;
+		}
+		if (nid >= nr_node_ids || nid >= nr_sections ||
+		    sorted[nid].free_cnt) {
+			for (nid = nr_sections - 1; nid > 0; nid--) {
+				if (!sorted[nid].free_cnt)
+					break;
+			}
+			if (WARN_ON(nid < 0))
+				return;
+		}
+		memcpy(&sorted[nid], &unsorted[i],
+		       sizeof(struct sgx_epc_section));
+	}
+}
+
 /**
  * A section metric is concatenated in a way that @low bits 12-31 define the
  * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
@@ -235,7 +282,8 @@ static bool __init sgx_page_cache_init(void)
 
 		pr_info("EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
 
-		if (!sgx_alloc_epc_section(pa, size, i, &sgx_epc_sections[i])) {
+		if (!sgx_alloc_epc_section(pa, size, i,
+					   &unsorted_epc_sections[i])) {
 			pr_err("No free memory for an EPC section\n");
 			break;
 		}
@@ -248,6 +296,13 @@ static bool __init sgx_page_cache_init(void)
 		return false;
 	}
 
+	if (nr_node_ids > 1)
+		sgx_page_cache_sort(sgx_epc_sections, unsorted_epc_sections,
+				    sgx_nr_epc_sections);
+	else
+		memcpy(sgx_epc_section, unsorted_epc_sections,
+		       sizeof(struct sgx_epc_section) * sgx_nr_epc_sections);
+
 	return true;
 }
 
-- 
2.26.0

