Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A5CC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Apr 2022 11:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388694AbiDULIh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Apr 2022 07:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388837AbiDULHy (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Apr 2022 07:07:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737812E6B9
        for <linux-sgx@vger.kernel.org>; Thu, 21 Apr 2022 04:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650539088; x=1682075088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=ZtEw984FSyt7Mg/5qmNCm9wpwSTesJEyrJihUI/RwSo=;
  b=CvZZsUXdlHAKkCNkLeuKQJCvBOs8cof11lU1m4NCjW0RYACsVWV9uCFn
   dzDNJCP3SlzW/XVJd3wNpGTPfLywheXf/bkdPjAi6ZMzRRhJSW/0cv9zu
   h98RPo5mEN5dSam7f91MAjt27uwktSCMCROnWNqTgGZaXz5vQCab00xOk
   4OwnmEsSFrtyUvGP57KBZfSSkQXWYDASXw+xQJnKR/qJWbART9T4AQrRJ
   ZWS0pFe6y54zmsD6dKg+TxFjdojVbnuPabUtVWdoQmrdIBRUwSu0h5UuG
   qNUmJ0476pHNF8tKuQ6WfaZmjlKCX3X/XHHQ6ProqIAY5WNo2sGd9j20T
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244893389"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="244893389"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:04:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="703039133"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 21 Apr 2022 04:04:24 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@intel.com, yang.zhong@intel.com
Subject: [PATCH v4 3/9] x86/sgx: Keep record for SGX VA and Guest page type
Date:   Thu, 21 Apr 2022 19:03:20 +0800
Message-Id: <20220421110326.856-4-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220421110326.856-1-cathy.zhang@intel.com>
References: <20220421110326.856-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Regular enclave EPC pages have sgx_encl_page as their owner, but
SGX VA page and KVM guest EPC page are maintained by different
owner structures.

SGX CPUSVN update requires to know the EPC page owner's status
and then decide how to handle the page.

Keep a record of page type for SGX VA and KVM guest page while
the other EPC pages already have their type tracked, so that
CPUSVN update can get EPC page's owner by type and handle it then.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>

---
Changes since v3:
 - Rename SGX_EPC_PAGE_GUEST as SGX_EPC_PAGE_KVM_GUEST. (Suggested by
   Jarkko, Sakkinen)
---
 arch/x86/kernel/cpu/sgx/sgx.h  | 4 ++++
 arch/x86/kernel/cpu/sgx/encl.c | 2 ++
 arch/x86/kernel/cpu/sgx/virt.c | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index f8ed9deac18b..4ad0e5396eef 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -28,6 +28,10 @@
 
 /* Pages on free list */
 #define SGX_EPC_PAGE_IS_FREE		BIT(1)
+/* VA page */
+#define SGX_EPC_PAGE_VA			BIT(2)
+/* Pages allocated for KVM guest */
+#define SGX_EPC_PAGE_KVM_GUEST		BIT(3)
 
 struct sgx_epc_page {
 	unsigned int section;
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index c0725111cc25..a01a72637e2e 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -777,6 +777,8 @@ struct sgx_epc_page *sgx_alloc_va_page(struct sgx_va_page *va_page)
 		return ERR_PTR(-EFAULT);
 	}
 
+	epc_page->flags |= SGX_EPC_PAGE_VA;
+
 	return epc_page;
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index e953816d7c8b..104487b72fb8 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -50,6 +50,8 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
 	if (IS_ERR(epc_page))
 		return PTR_ERR(epc_page);
 
+	epc_page->flags |= SGX_EPC_PAGE_KVM_GUEST;
+
 	ret = xa_err(xa_store(&vepc->page_array, index, epc_page, GFP_KERNEL));
 	if (ret)
 		goto err_free;
-- 
2.17.1

