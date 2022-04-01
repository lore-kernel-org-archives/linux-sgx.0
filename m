Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0DAC4332F
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Apr 2022 14:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbiDAO0N (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241890AbiDAO0M (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Apr 2022 10:26:12 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DE910E57A
        for <linux-sgx@vger.kernel.org>; Fri,  1 Apr 2022 07:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648823063; x=1680359063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Iifm94nrkrUn95r/4dwRoNZdpOmvhO/J9wedzDILcKw=;
  b=kj10YgY1ptjRjeMyE/meBD18GKIvKdJA9JVtUYWuUq77x1UDcS32nsMv
   pi7nfAbE0PS4gYeImYitsHm+tmfh9XsuN/D6p88QFfYgCobIdWwuVIg6S
   O/iidWGbvDykGogxZfUTB9/78SP6nOuSfRC4ccoY2+QxLKOurh9WvTIRX
   8tHDTCAdfrYE9ksxFCr8s78+hpt4V0yhl3qNmYYB0w9FZjv94+RUY3+nu
   8PMw3KC6zIlTGR0JjN0efqGg1tkwmoqMd91PAXaI1PoCOOZdJQCifU3jU
   oDla1CXA4FbtXS7dZzkIIhIgYnLcdgKeCrufcLpZlLc68h7DOGbRrFbiw
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="240739867"
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="240739867"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 07:24:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="695908334"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 01 Apr 2022 07:24:20 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH v3 02/10] x86/sgx: Provide VA page non-NULL owner
Date:   Fri,  1 Apr 2022 22:24:01 +0800
Message-Id: <20220401142409.26215-3-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220401142409.26215-1-cathy.zhang@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Provide non-NULL owner for VA page, which tells that the EPC page is
allocated for use.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.h  | 3 +--
 arch/x86/kernel/cpu/sgx/sgx.h   | 2 +-
 arch/x86/kernel/cpu/sgx/encl.c  | 5 +++--
 arch/x86/kernel/cpu/sgx/ioctl.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 7cdc351bc273..0c8571fc30cf 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -112,8 +112,7 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
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
index 00668e50848d..f0ce96bd462a 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -30,7 +30,7 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 		if (!va_page)
 			return ERR_PTR(-ENOMEM);
 
-		va_page->epc_page = sgx_alloc_va_page();
+		va_page->epc_page = sgx_alloc_va_page(va_page);
 		if (IS_ERR(va_page->epc_page)) {
 			err = ERR_CAST(va_page->epc_page);
 			kfree(va_page);
-- 
2.17.1

