Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6350BC433EF
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Apr 2022 14:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245438AbiDAO0S (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241890AbiDAO0R (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Apr 2022 10:26:17 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4364C1168D0
        for <linux-sgx@vger.kernel.org>; Fri,  1 Apr 2022 07:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648823068; x=1680359068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=OABL+vNPmI76N669MBfQX2xF2C1qkZswib1x5YU269I=;
  b=TPXEDyaU1Xd53Jx3aq1p9bKjUti66Hu7/wv1SXMrsK1FV/a6OLjRaRTy
   a5F5IC+jzx7FYX7K02rJLVV3mgbpDKUx9S5ZuhP2btI3CxXhZYEK99udi
   NzPkPvP8/U6FtQChWgWtJrnA1HtKOwDyTgNxyI2DFxlmBp3JmhpZpuq78
   9WtyED6b4uNks6A4W/WIToYwTwiseNHMUw7LoPmazffaJR4ua7RXFwf3i
   C67vX8GgHSjE9jViHwZt01+cag+nA2e2FyDpNAhM0WagPkYFUKl9CIF4+
   j7o/z6VAC3ZjMiv2HmDazqoZ7ZULCyqSkY6c8h5LwjPKP+gCqiLfe6UEB
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="240739879"
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="240739879"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 07:24:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="695908348"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 01 Apr 2022 07:24:25 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH v3 04/10] x86/sgx: Keep record for SGX VA and Guest page type
Date:   Fri,  1 Apr 2022 22:24:03 +0800
Message-Id: <20220401142409.26215-5-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220401142409.26215-1-cathy.zhang@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
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
 arch/x86/kernel/cpu/sgx/sgx.h  | 4 ++++
 arch/x86/kernel/cpu/sgx/encl.c | 2 ++
 arch/x86/kernel/cpu/sgx/virt.c | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index f8ed9deac18b..0b036f19cca1 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -28,6 +28,10 @@
 
 /* Pages on free list */
 #define SGX_EPC_PAGE_IS_FREE		BIT(1)
+/* VA page */
+#define SGX_EPC_PAGE_VA			BIT(2)
+/* Pages allocated for KVM guest */
+#define SGX_EPC_PAGE_GUEST		BIT(3)
 
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
index e953816d7c8b..acdf72769a39 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -50,6 +50,8 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
 	if (IS_ERR(epc_page))
 		return PTR_ERR(epc_page);
 
+	epc_page->flags |= SGX_EPC_PAGE_GUEST;
+
 	ret = xa_err(xa_store(&vepc->page_array, index, epc_page, GFP_KERNEL));
 	if (ret)
 		goto err_free;
-- 
2.17.1

