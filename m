Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E9DC4332F
	for <linux-sgx@archiver.kernel.org>; Fri, 20 May 2022 10:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbiETKlx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 May 2022 06:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348249AbiETKlF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 20 May 2022 06:41:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790CC120BB
        for <linux-sgx@vger.kernel.org>; Fri, 20 May 2022 03:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653043264; x=1684579264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=6izFkFfb2fBj4Q/DNT6/g/FmJnK01Aa1Rs2UyAwQJX0=;
  b=llbddS1a1dQLFt7ofAYedn1iej7/TranCx6OE5f9CA4Np4wNXss2HOcZ
   M2Fu+rPYqQfcQcGkc5MVrD+7yDtwc2XOk1x54kRSvEoxR52G9B00ZyCBD
   5n+qKf0nYeYxakG03R5gsDMf+bgUeLGicdTGOv+F7YQOAdrQHvedKwyk9
   q9TVvBHF1g7qbtZoijeRa8HobEHdSCsEUhb1aF1F1h//mK/4uFjykOzwc
   iIuA3TdMRptQBjYdmqDl7KsJTg4M9l/sHOJhPe1M/ybbxljoYArBYcZyJ
   GI9QHtWyzXu2hEHfZ5tpeScuWT5ki5oq8rB64fADXifT2//uHMmpXff7M
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="271386930"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="271386930"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 03:41:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="715470987"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 20 May 2022 03:41:01 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH v5 2/9] x86/sgx: Save enclave pointer for VA page
Date:   Fri, 20 May 2022 18:38:57 +0800
Message-Id: <20220520103904.1216-3-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220520103904.1216-1-cathy.zhang@intel.com>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Tearing down all enclaves is required by SGX SVN update, which
involves running the ENCLS[EREMOVE] instruction on every EPC
page. This (tearing down all enclaves) should be coordinated
with any enclaves that may be in the process of existing and thus
already be running ENCLS[EREMOVE] as part of enclave release.

In support of this coordination, it is required to know which enclave
owns each in-use EPC page. It is already possible to locate the
owning enclave of SECS and regular pages but not for VA pages.

Make the following changes for VA pages' location:
1) Make epc->owner type-agnostic by changing its type to 'void *'. So,
   besides "struct sgx_encl_page", it can have other types, like
   "struct sgx_va_page".
2) Save the enclave pointer for each VA page to support locating its
   owning enclave.

Note: to track 2T EPC memory, this scheme of tracking will use
additional 8M memory.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>

---
Changes since v4:
 - Add back the blank line removed unintenitonally in encl.h.
   (Jarkko Sakkinen)

Changes since v3:
 - Squash patch "x86/sgx: Provide VA page non-NULL owner" and
   "x86/sgx: Save enclave pointer for VA page". Update commit log.
   (Suggested by Jarkko Sakkinen)
---
 arch/x86/kernel/cpu/sgx/encl.h  | 3 ++-
 arch/x86/kernel/cpu/sgx/sgx.h   | 2 +-
 arch/x86/kernel/cpu/sgx/encl.c  | 5 +++--
 arch/x86/kernel/cpu/sgx/ioctl.c | 3 ++-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 7311bc40bd1b..52e0a3e52598 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -76,6 +76,7 @@ struct sgx_va_page {
 	struct sgx_epc_page *epc_page;
 	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
 	struct list_head list;
+	struct sgx_encl *encl;
 };
 
 struct sgx_backing {
@@ -113,7 +114,7 @@ void sgx_encl_put_backing(struct sgx_backing *backing);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
 
-struct sgx_epc_page *sgx_alloc_va_page(void);
+struct sgx_epc_page *sgx_alloc_va_page(struct sgx_va_page *va_page);
 unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
 void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
 bool sgx_va_page_full(struct sgx_va_page *va_page);
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index d7a1490d90bb..f8ed9deac18b 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -33,7 +33,7 @@ struct sgx_epc_page {
 	unsigned int section;
 	u16 flags;
 	u16 poison;
-	struct sgx_encl_page *owner;
+	void *owner;
 	struct list_head list;
 };
 
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 39f7f5dc09fd..08f39fa03a39 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -888,6 +888,7 @@ int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 
 /**
  * sgx_alloc_va_page() - Allocate a Version Array (VA) page
+ * @va_page:	struct sgx_va_page connected to this VA page
  *
  * Allocate a free EPC page and convert it to a Version Array (VA) page.
  *
@@ -895,12 +896,12 @@ int sgx_encl_test_and_clear_young(struct mm_struct *mm,
  *   a VA page,
  *   -errno otherwise
  */
-struct sgx_epc_page *sgx_alloc_va_page(void)
+struct sgx_epc_page *sgx_alloc_va_page(struct sgx_va_page *va_page)
 {
 	struct sgx_epc_page *epc_page;
 	int ret;
 
-	epc_page = sgx_alloc_epc_page(NULL, true);
+	epc_page = sgx_alloc_epc_page(va_page, true);
 	if (IS_ERR(epc_page))
 		return ERR_CAST(epc_page);
 
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index d62720ed1728..939008c63a84 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -30,7 +30,8 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 		if (!va_page)
 			return ERR_PTR(-ENOMEM);
 
-		va_page->epc_page = sgx_alloc_va_page();
+		va_page->encl = encl;
+		va_page->epc_page = sgx_alloc_va_page(va_page);
 		if (IS_ERR(va_page->epc_page)) {
 			err = ERR_CAST(va_page->epc_page);
 			kfree(va_page);
-- 
2.17.1

