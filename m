Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76788C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Apr 2022 11:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbiDULIe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Apr 2022 07:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388734AbiDULHg (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Apr 2022 07:07:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A561E2F03B
        for <linux-sgx@vger.kernel.org>; Thu, 21 Apr 2022 04:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650539076; x=1682075076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=lzF76dr5OyhgznlKi7kBwEA0d9lnZNetuc+LqiEoC00=;
  b=Y7TmFABYrHbf7K7vkjBPbSl7/d8gGI/h0w4eBgZ3e0oobgeqv7uvtd37
   unPvSYDcbjnhbWLvpIlWVZjQKSJwzfmwBCcshQzKGWYw9wngEs9CF5YR/
   nBrUpvwdrLbBlTAtkAsWmf6dGinOzCAKaDlJNVd1JNvaG/ObNekRHg8Rn
   iWFHBWeEQIcUIDq9pz4Qn4aswDTKmQo44G8K15fMkD3QfRtRGiPbkJOze
   /Hq3RKeghGLXNTV3LT9qu9fUSouvYDvJT4+KUDx2U8/rXL1zCsCT9ldiJ
   QnFnROKv5fZQjAulkmmlXUglZF7bfdaRHsXLJttm+7iv6Ihh6eIBQ9cA9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244893370"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="244893370"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:04:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="703039124"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 21 Apr 2022 04:04:21 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@intel.com, yang.zhong@intel.com
Subject: [PATCH v4 2/9] x86/sgx: Save enclave pointer for VA page
Date:   Thu, 21 Apr 2022 19:03:19 +0800
Message-Id: <20220421110326.856-3-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220421110326.856-1-cathy.zhang@intel.com>
References: <20220421110326.856-1-cathy.zhang@intel.com>
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
Changes since v3:
 - Squash patch "x86/sgx: Provide VA page non-NULL owner" and
   "x86/sgx: Save enclave pointer for VA page". Update commit log.
   (Suggested by Jarkko Sakkinen)
---
 arch/x86/kernel/cpu/sgx/encl.h  | 4 ++--
 arch/x86/kernel/cpu/sgx/sgx.h   | 2 +-
 arch/x86/kernel/cpu/sgx/encl.c  | 5 +++--
 arch/x86/kernel/cpu/sgx/ioctl.c | 3 ++-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 7cdc351bc273..59fbd4ed5c64 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -76,6 +76,7 @@ struct sgx_va_page {
 	struct sgx_epc_page *epc_page;
 	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
 	struct list_head list;
+	struct sgx_encl *encl;
 };
 
 struct sgx_backing {
@@ -112,8 +113,7 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
-
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
index 68c8d65a8dee..c0725111cc25 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -753,6 +753,7 @@ int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 
 /**
  * sgx_alloc_va_page() - Allocate a Version Array (VA) page
+ * @va_page:	struct sgx_va_page connected to this VA page
  *
  * Allocate a free EPC page and convert it to a Version Array (VA) page.
  *
@@ -760,12 +761,12 @@ int sgx_encl_test_and_clear_young(struct mm_struct *mm,
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
index a4df72f715d7..b77343eb2d49 100644
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

