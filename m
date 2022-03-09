Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDCCC4332F
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 10:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiCIKl1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 05:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiCIKl1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 05:41:27 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B551437BF6
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 02:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646822428; x=1678358428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=bG75tiB7pTL3Zxa5XwwH6wgiRtXblx45pRj+5lOZYEo=;
  b=bfnkWspN/FCDBLb0QKhC0BCLgrnyxOVFhTefzQnbai3wwnVMBhhecCBL
   UvjPJYBqROuEtykVaf6NJ2nv7uty/NhormmDsIYnqQOAuDTZU56ToujV/
   W2+XuJNeSFSjo2u1a17GFIaH2hF9i1BFDzMS8KAyGdbuMg+E4VEVOlxDj
   dMTexKKxSDEMggbRIjTgrKBeCxPMgt6qhriOFJf6rtncFrienFTgnkvAi
   kSXXmw1AN4pSxYKemSAUe2FQa5xf5yuE7B7QJzF5HVauq5H/yxoz4FPiC
   M5z7VxkIBjrgbBQC6JaVbGYOkjpl6W6Az5f4cOEbfaRTKimRknvbA4MOS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="341373556"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="341373556"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 02:40:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="547582879"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2022 02:40:27 -0800
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     dave.hansen@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH 04/11] x86/sgx: Keep record for SGX VA and Guest page type
Date:   Wed,  9 Mar 2022 18:40:43 +0800
Message-Id: <20220309104050.18207-5-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220309104050.18207-1-cathy.zhang@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
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
index e627c42a6eec..1dd06899a64c 100644
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
index e08c59a049d3..a78428aa4465 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -1014,6 +1014,8 @@ struct sgx_epc_page *sgx_alloc_va_page(struct sgx_va_page *va_page)
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

