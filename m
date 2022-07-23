Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134BEC43334
	for <linux-sgx@archiver.kernel.org>; Sat, 23 Jul 2022 12:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiGWMTA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 23 Jul 2022 08:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGWMS7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 23 Jul 2022 08:18:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE318AE50
        for <linux-sgx@vger.kernel.org>; Sat, 23 Jul 2022 05:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658578738; x=1690114738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4wAq9W1SZtCZ/oWfGvGii6y7hMKlFuvtDNM/25r3Axc=;
  b=mJiFx1Tpg44quc/6y+W3T/5ibFDgRlFAn9hy+LMozticvqNafvI1vNZE
   tNPZKNS7xphiiU3BHnX8dGlhV+wHo/kwXEIhdVdTunJHNolIEG1+I9EhK
   ZUaHH5hW/XnZFiyNu+viBD2XHRzGTp6omzmMfOWYS3E9/ayeEMao+QDSm
   q8Hmx/kWLb2A95wI6TPcMgFzEh1Ft7cNqEPPziWkNJrnIAj1b0qBe3Z77
   5icP2634Sq2c15FCNuT3dqvO4jwDxcP1i1lM7er2ZUYh1F8jBirMMz/Vj
   rL5K0Ob+s6sWsQvPLE3lEf3kD1VJgpUMJR+5To2rPRh9wrKwfvSeIoF7J
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="351461303"
X-IronPort-AV: E=Sophos;i="5.93,188,1654585200"; 
   d="scan'208";a="351461303"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 05:18:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,188,1654585200"; 
   d="scan'208";a="596215045"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2022 05:18:55 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v6 1/3] x86/sgx: Rename the owner field of struct sgx_epc_page as encl_owner
Date:   Sat, 23 Jul 2022 20:23:41 +0800
Message-Id: <20220723122343.598783-2-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220723122343.598783-1-zhiquan1.li@intel.com>
References: <20220723122343.598783-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In order to describe the purpose of 'owner' field more exactly,
rename the 'owner' field of struct sgx_epc_page as 'encl_owner',
and update all of references.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 20 ++++++++++----------
 arch/x86/kernel/cpu/sgx/sgx.h  |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 5acd4c54d904..6b5c3633cb8e 100644
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
@@ -555,7 +555,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 	for ( ; ; ) {
 		page = __sgx_alloc_epc_page();
 		if (!IS_ERR(page)) {
-			page->owner = owner;
+			page->encl_owner = owner;
 			break;
 		}
 
@@ -598,7 +598,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 
 	spin_lock(&node->lock);
 
-	page->owner = NULL;
+	page->encl_owner = NULL;
 	if (page->poison)
 		list_add(&page->list, &node->sgx_poison_page_list);
 	else
@@ -633,7 +633,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
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

