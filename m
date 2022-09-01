Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B53ECAAD4
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Sep 2022 00:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiIAAcL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Aug 2022 20:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbiIAAby (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 31 Aug 2022 20:31:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CAFDFB59
        for <linux-sgx@vger.kernel.org>; Wed, 31 Aug 2022 17:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661992280; x=1693528280;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mTZkCot+NsBAlQ8K9quC89bA9fHu2LN07vqSpgZtuGA=;
  b=ahh7++cFQoTPsXU2u8E6A7ZMVdMGBJLy7FV9Ka5OAYUJsGVm536zFG7+
   Em97hJfqTSjLB/hg30vz8VQhZNRRvXGBzfCBW6vorQ0qDR8KxCpA9ZleP
   lPUPsypo4mRMI2jV8EUN49dvVp38eB0OIGWXsKYkKUEb4qnTT74/ltG7k
   ef2UuCHnDMVaKN/fbgUn2WhsA37JCPqeHEio99ttT+Y2u4bOqiIxCUkCU
   CISbcCar1wJBQGayflhQty22rj/VY/UQPGBqZQEK3xwT7hwQIhDJmcVwP
   8Aq+GDmhdWdWLkbGJ6VMfkcDFZvpP/0yhG9JZdUpReGYBc5TfhAlj3zFp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="275983734"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="275983734"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 17:31:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="940634938"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga005.fm.intel.com with ESMTP; 31 Aug 2022 17:31:13 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v7 1/3] x86/sgx: Rename the owner field of struct sgx_epc_page as encl_owner
Date:   Thu,  1 Sep 2022 08:35:59 +0800
Message-Id: <20220901003601.2048563-2-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901003601.2048563-1-zhiquan1.li@intel.com>
References: <20220901003601.2048563-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In order to avoid unnecessary casting, rename the 'owner' field of
struct sgx_epc_page as 'encl_owner', and update all of references.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>

---
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

