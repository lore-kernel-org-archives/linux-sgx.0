Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3531C07E9C
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Jul 2021 18:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F2CC6193D
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Jul 2021 18:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhGHSRV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Jul 2021 14:17:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:2094 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230139AbhGHSRT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Jul 2021 14:17:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="231327152"
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="231327152"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 11:14:35 -0700
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="482637390"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 11:14:34 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     tony.luck@intel.com
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86/sgx: Track phase and type of SGX EPC pages
Date:   Thu,  8 Jul 2021 11:14:20 -0700
Message-Id: <20210708181423.1312359-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210708181423.1312359-1-tony.luck@intel.com>
References: <20210708181423.1312359-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Memory errors can be reported either synchronously as memory is accessed,
or asynchronously by speculative access or by a memory controller page
scrubber.  The life cycle of an EPC page takes it through:
	dirty -> free -> in-use -> free.

Memory errors are reported using physical addresses. It is a simple
matter to find which sgx_epc_page structure maps a given address.
But then recovery code needs to be able to determine the current use of
the page to take the appropriate recovery action. Within the "in-use"
phase different actions are needed based on how the page is used in
the enclave.

Add new flags bits to describe the phase (with an extra bit for the new
phase of "poisoned"). Drop pages marked as poisoned instead of adding
them to a free list to make sure they are not re-used.

Add a type field to struct epc_page for how an in-use page has been
allocated. Re-use "enum sgx_page_type" for this type, with a couple
of additions for s/w types.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/sgx.h      |  6 ++++++
 arch/x86/kernel/cpu/sgx/encl.c  |  4 ++--
 arch/x86/kernel/cpu/sgx/ioctl.c |  4 ++--
 arch/x86/kernel/cpu/sgx/main.c  | 21 +++++++++++++++++++--
 arch/x86/kernel/cpu/sgx/sgx.h   | 14 ++++++++++++--
 arch/x86/kernel/cpu/sgx/virt.c  |  2 +-
 6 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 9c31e0ebc55b..9619a6d77a83 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -216,6 +216,8 @@ struct sgx_pageinfo {
  * %SGX_PAGE_TYPE_REG:	a regular page
  * %SGX_PAGE_TYPE_VA:	a VA page
  * %SGX_PAGE_TYPE_TRIM:	a page in trimmed state
+ *
+ * Also used to track current use of &struct sgx_epc_page
  */
 enum sgx_page_type {
 	SGX_PAGE_TYPE_SECS,
@@ -223,6 +225,10 @@ enum sgx_page_type {
 	SGX_PAGE_TYPE_REG,
 	SGX_PAGE_TYPE_VA,
 	SGX_PAGE_TYPE_TRIM,
+
+	/* sgx_epc_page.type */
+	SGX_PAGE_TYPE_FREE = 100,
+	SGX_PAGE_TYPE_KVM = 101,
 };
 
 #define SGX_NR_PAGE_TYPES	5
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 3be203297988..abf6e1a704c0 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -72,7 +72,7 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	struct sgx_epc_page *epc_page;
 	int ret;
 
-	epc_page = sgx_alloc_epc_page(encl_page, false);
+	epc_page = sgx_alloc_epc_page(encl_page, SGX_PAGE_TYPE_REG, false);
 	if (IS_ERR(epc_page))
 		return epc_page;
 
@@ -679,7 +679,7 @@ struct sgx_epc_page *sgx_alloc_va_page(void)
 	struct sgx_epc_page *epc_page;
 	int ret;
 
-	epc_page = sgx_alloc_epc_page(NULL, true);
+	epc_page = sgx_alloc_epc_page(NULL,  SGX_PAGE_TYPE_VA, true);
 	if (IS_ERR(epc_page))
 		return ERR_CAST(epc_page);
 
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 83df20e3e633..a74ae00194cc 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -83,7 +83,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 
 	encl->backing = backing;
 
-	secs_epc = sgx_alloc_epc_page(&encl->secs, true);
+	secs_epc = sgx_alloc_epc_page(&encl->secs, SGX_PAGE_TYPE_SECS, true);
 	if (IS_ERR(secs_epc)) {
 		ret = PTR_ERR(secs_epc);
 		goto err_out_backing;
@@ -300,7 +300,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	if (IS_ERR(encl_page))
 		return PTR_ERR(encl_page);
 
-	epc_page = sgx_alloc_epc_page(encl_page, true);
+	epc_page = sgx_alloc_epc_page(encl_page, SGX_PAGE_TYPE_REG, true);
 	if (IS_ERR(epc_page)) {
 		kfree(encl_page);
 		return PTR_ERR(epc_page);
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de02bbcc..643df87b3e01 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -401,7 +401,12 @@ static void sgx_reclaim_pages(void)
 		section = &sgx_epc_sections[epc_page->section];
 		node = section->node;
 
+		/* drop poison pages instead of adding to free list */
+		if (epc_page->flags & SGX_EPC_PAGE_POISON)
+			continue;
+
 		spin_lock(&node->lock);
+		epc_page->flags = SGX_EPC_PAGE_FREE;
 		list_add_tail(&epc_page->list, &node->free_page_list);
 		sgx_nr_free_pages++;
 		spin_unlock(&node->lock);
@@ -560,6 +565,7 @@ int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
 /**
  * sgx_alloc_epc_page() - Allocate an EPC page
  * @owner:	the owner of the EPC page
+ * @type:	type of page being allocated
  * @reclaim:	reclaim pages if necessary
  *
  * Iterate through EPC sections and borrow a free EPC page to the caller. When a
@@ -574,7 +580,7 @@ int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
  *   an EPC page,
  *   -errno on error
  */
-struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
+struct sgx_epc_page *sgx_alloc_epc_page(void *owner, enum sgx_page_type type, bool reclaim)
 {
 	struct sgx_epc_page *page;
 
@@ -582,6 +588,8 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 		page = __sgx_alloc_epc_page();
 		if (!IS_ERR(page)) {
 			page->owner = owner;
+			page->type = type;
+			page->flags = 0;
 			break;
 		}
 
@@ -616,14 +624,22 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
  * responsibility to make sure that the page is in uninitialized state. In other
  * words, do EREMOVE, EWB or whatever operation is necessary before calling
  * this function.
+ *
+ * Note that if the page has been tagged as poisoned, it is simply
+ * dropped on the floor instead of added to the free list to make
+ * sure we do not re-use it.
  */
 void sgx_free_epc_page(struct sgx_epc_page *page)
 {
 	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
 	struct sgx_numa_node *node = section->node;
 
+	if (page->flags & SGX_EPC_PAGE_POISON)
+		return;
+
 	spin_lock(&node->lock);
 
+	page->flags = SGX_EPC_PAGE_FREE;
 	list_add_tail(&page->list, &node->free_page_list);
 	sgx_nr_free_pages++;
 
@@ -651,7 +667,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
-		section->pages[i].flags = 0;
+		section->pages[i].flags = SGX_EPC_PAGE_DIRTY;
+		section->pages[i].type = SGX_PAGE_TYPE_FREE;
 		section->pages[i].owner = NULL;
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 4628acec0009..e43d3c27eb96 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -26,9 +26,19 @@
 /* Pages, which are being tracked by the page reclaimer. */
 #define SGX_EPC_PAGE_RECLAIMER_TRACKED	BIT(0)
 
+/* Pages, on the "sgx_dirty_page_list" */
+#define SGX_EPC_PAGE_DIRTY		BIT(1)
+
+/* Pages, on one of the node free lists */
+#define SGX_EPC_PAGE_FREE		BIT(2)
+
+/* Pages, with h/w poison errors */
+#define SGX_EPC_PAGE_POISON		BIT(3)
+
 struct sgx_epc_page {
 	unsigned int section;
-	unsigned int flags;
+	u16 flags;
+	u16 type;
 	struct sgx_encl_page *owner;
 	struct list_head list;
 };
@@ -82,7 +92,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page);
 
 void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
 int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
-struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
+struct sgx_epc_page *sgx_alloc_epc_page(void *owner, enum sgx_page_type type, bool reclaim);
 
 #ifdef CONFIG_X86_SGX_KVM
 int __init sgx_vepc_init(void);
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 64511c4a5200..044dd92ebd63 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -46,7 +46,7 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
 	if (epc_page)
 		return 0;
 
-	epc_page = sgx_alloc_epc_page(vepc, false);
+	epc_page = sgx_alloc_epc_page(vepc, SGX_PAGE_TYPE_KVM, false);
 	if (IS_ERR(epc_page))
 		return PTR_ERR(epc_page);
 
-- 
2.29.2

