Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23178C6FA82
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Sep 2022 15:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiIMPo3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 13 Sep 2022 11:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbiIMPnv (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 13 Sep 2022 11:43:51 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEB185AB0
        for <linux-sgx@vger.kernel.org>; Tue, 13 Sep 2022 07:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663080486; x=1694616486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UQLNmPsS2x+ui3aG6cUrioyiNb3naZRwUbp+yGZ6k30=;
  b=JFNcEw9mEGuzZbzCu5UarLf/8jZ1+amenDoi0x81Cno5Uhzc3sEO3y3d
   AxYhKYxoE/l9/JtNLG7xm1tgcdEoYQlAy0pR8YoHT5PnAb/FjKcTQ8LnH
   OOekFljUP97t2a7IjTrrgvyTLMpIfKoIHjQtdSilLkBvLz/FlGIlr4i5V
   3AeUQ6lsTYtwc+4MByPkJqZJ4bdBzMxyYQ2pkM+QMWBrqbG4PrDc/br57
   Jud8w6/qLzrMvyEppxDQume6fcq/+y29fJTgfEJkgfE3LxY2bGkBZ2Eis
   ckhhPjbhEuWtSNxmW+J7CNoy3igEudZ5DPdoMTWyfrIbN+YUo8jx23tz1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="298952181"
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="298952181"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 07:48:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="649680575"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2022 07:47:56 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v8 1/3] x86/sgx: Rename the owner field of struct sgx_epc_page as encl_owner
Date:   Tue, 13 Sep 2022 22:53:28 +0800
Message-Id: <20220913145330.2998212-2-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220913145330.2998212-1-zhiquan1.li@intel.com>
References: <20220913145330.2998212-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In order to send SIGBUS to userspace hypervisor to allow it to
inject #MC to guest, use virtual EPC page's owner to be the userspace
virtual address of the EPC page.  To avoid casting, use a union to
separate the use of owner for SGX driver EPC page and virtual EPC page
in the next step.

To pave the way, rename owner of SGX driver EPC page to 'encl_owner' to
be more specific and update all of references.  There is no functional
change.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Kai Huang <kai.huang@intel.com>

---
Changes since V7:
- Enrich the motivation for renaming in commit message with the
  explanation from Kai.
  Link: https://lore.kernel.org/linux-sgx/YxEyRT2SbfBdYNfm@kernel.org/T/#me02a2ce0f3cc0122e62dac496d89321d1c006807
- Add Acked-by from Jarkko.
- Add Acked-by from Kai Huang.

Changes since V6:
- Revise the commit message suggested by Jarkko.
  Link: https://lore.kernel.org/linux-sgx/20220826160503.1576966-1-zhiquan1.li@intel.com/T/#mb201506ed06932438c82d48915cd4ceae9745bc2
---
 arch/x86/kernel/cpu/sgx/main.c | 20 ++++++++++----------
 arch/x86/kernel/cpu/sgx/sgx.h  |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 515e2a5f25bb..1315c69a733e 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -102,7 +102,7 @@ static void __sgx_sanitize_pages(struct list_head *dirty_page_list)
 
 static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
 {
-	struct sgx_encl_page *page = epc_page->owner;
+	struct sgx_encl_page *page = epc_page->encl_owner;
 	struct sgx_encl *encl = page->encl;
 	struct sgx_encl_mm *encl_mm;
 	bool ret = true;
@@ -134,7 +134,7 @@ static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
 
 static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 {
-	struct sgx_encl_page *page = epc_page->owner;
+	struct sgx_encl_page *page = epc_page->encl_owner;
 	unsigned long addr = page->desc & PAGE_MASK;
 	struct sgx_encl *encl = page->encl;
 	int ret;
@@ -191,7 +191,7 @@ void sgx_ipi_cb(void *info)
 static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 			 struct sgx_backing *backing)
 {
-	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl_page *encl_page = epc_page->encl_owner;
 	struct sgx_encl *encl = encl_page->encl;
 	struct sgx_va_page *va_page;
 	unsigned int va_offset;
@@ -244,7 +244,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 				struct sgx_backing *backing)
 {
-	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl_page *encl_page = epc_page->encl_owner;
 	struct sgx_encl *encl = encl_page->encl;
 	struct sgx_backing secs_backing;
 	int ret;
@@ -306,7 +306,7 @@ static void sgx_reclaim_pages(void)
 		epc_page = list_first_entry(&sgx_active_page_list,
 					    struct sgx_epc_page, list);
 		list_del_init(&epc_page->list);
-		encl_page = epc_page->owner;
+		encl_page = epc_page->encl_owner;
 
 		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0)
 			chunk[cnt++] = epc_page;
@@ -320,7 +320,7 @@ static void sgx_reclaim_pages(void)
 
 	for (i = 0; i < cnt; i++) {
 		epc_page = chunk[i];
-		encl_page = epc_page->owner;
+		encl_page = epc_page->encl_owner;
 
 		if (!sgx_reclaimer_age(epc_page))
 			goto skip;
@@ -359,7 +359,7 @@ static void sgx_reclaim_pages(void)
 		if (!epc_page)
 			continue;
 
-		encl_page = epc_page->owner;
+		encl_page = epc_page->encl_owner;
 		sgx_reclaimer_write(epc_page, &backing[i]);
 
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
@@ -560,7 +560,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 	for ( ; ; ) {
 		page = __sgx_alloc_epc_page();
 		if (!IS_ERR(page)) {
-			page->owner = owner;
+			page->encl_owner = owner;
 			break;
 		}
 
@@ -603,7 +603,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 
 	spin_lock(&node->lock);
 
-	page->owner = NULL;
+	page->encl_owner = NULL;
 	if (page->poison)
 		list_add(&page->list, &node->sgx_poison_page_list);
 	else
@@ -638,7 +638,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
 		section->pages[i].flags = 0;
-		section->pages[i].owner = NULL;
+		section->pages[i].encl_owner = NULL;
 		section->pages[i].poison = 0;
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 0f2020653fba..4d88abccd12e 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -33,7 +33,7 @@ struct sgx_epc_page {
 	unsigned int section;
 	u16 flags;
 	u16 poison;
-	struct sgx_encl_page *owner;
+	struct sgx_encl_page *encl_owner;
 	struct list_head list;
 };
 
-- 
2.25.1

