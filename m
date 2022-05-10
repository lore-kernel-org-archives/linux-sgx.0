Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B860CC433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 10 May 2022 03:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbiEJDUq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 23:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbiEJDUp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 23:20:45 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71F315828
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 20:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652152609; x=1683688609;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=neg7NnNv/yzAlXlRwTKteKAwzitNLa0sNEHhaQb3tnY=;
  b=S5c6v7mxdytuSUjwalvdI8j4ZBB2iK2QmzULO9bT4ubV/FRBeZPZ9HfO
   lI5nlIjMGsyPHAmr5SEoawLL0wvrzpVo0xNH3dIa3GrHfbvslqwEXNF17
   crb8kx65yu6TpJc3jngyDmVmpbbrHGk3mlruX84PYIhIM8hxDDhtOYHgf
   O/c1L+EeQgw1Wra0FsAZYThVjFwGmKZGXwg8CCLDAv10tZE9rkpdINw9t
   Ic/Ndmi05ymDIwaXgCriNNbSAhElTkWYM0GWRkA+sWpuugfgyAbGSnRiw
   l7Ule9qkrnO2z55LyXEERWy47Ud9wL8QpaBPag2mZ3ZjB2Dcks/GTjQJB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="249144641"
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="249144641"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 20:16:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="710818585"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2022 20:16:47 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH 2/4] x86/sgx: add struct sgx_vepc_page to manage EPC pages for vepc
Date:   Tue, 10 May 2022 11:17:37 +0800
Message-Id: <20220510031737.3181410-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Current SGX data structures are insufficient to track the EPC pages for
vepc. For example, if we want to retrieve the virtual address of an EPC
page allocated to an enclave on host, we can find this info from its
owner, the ‘desc’ field of struct sgx_encl_page. However, if the EPC
page is allocated to a KVM guest, this is not available, as their owner
is a shared vepc.

So, we introduce struct sgx_vepc_page which can be the owner of EPC
pages for vepc and saves the useful info of EPC pages for vepc, like
struct sgx_encl_page.

Canonical memory failure collects victim tasks by iterating all the
tasks one by one and use reverse mapping to get victim tasks’ virtual
address.

This is not necessary for SGX - as one EPC page can be mapped to ONE
enclave only. So, this 1:1 mapping enforcement allows us to find task
virtual address with physical address directly.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
---
 arch/x86/kernel/cpu/sgx/sgx.h  |  7 +++++++
 arch/x86/kernel/cpu/sgx/virt.c | 24 +++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 83ff8c3e81cf..cc01d992453a 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -28,6 +28,8 @@
 
 /* Pages on free list */
 #define SGX_EPC_PAGE_IS_FREE		BIT(1)
+/* Pages is used by VM guest */
+#define SGX_EPC_PAGE_IS_VEPC		BIT(2)
 
 struct sgx_epc_page {
 	unsigned int section;
@@ -106,4 +108,9 @@ struct sgx_vepc {
 	struct mutex lock;
 };
 
+struct sgx_vepc_page {
+	unsigned long vaddr;
+	struct sgx_vepc *vepc;
+};
+
 #endif /* _X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index c9c8638b5dc4..d7945a47ced8 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -29,6 +29,7 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
 			    struct vm_area_struct *vma, unsigned long addr)
 {
 	struct sgx_epc_page *epc_page;
+	struct sgx_vepc_page *owner;
 	unsigned long index, pfn;
 	int ret;
 
@@ -41,13 +42,22 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
 	if (epc_page)
 		return 0;
 
-	epc_page = sgx_alloc_epc_page(vepc, false);
-	if (IS_ERR(epc_page))
-		return PTR_ERR(epc_page);
+	owner = kzalloc(sizeof(*owner), GFP_KERNEL);
+	if (!owner)
+		return -ENOMEM;
+	owner->vepc = vepc;
+	owner->vaddr = addr & PAGE_MASK;
+
+	epc_page = sgx_alloc_epc_page(owner, false);
+	if (IS_ERR(epc_page)) {
+		ret = PTR_ERR(epc_page);
+		goto err_free_owner;
+	}
+	epc_page->flags = SGX_EPC_PAGE_IS_VEPC;
 
 	ret = xa_err(xa_store(&vepc->page_array, index, epc_page, GFP_KERNEL));
 	if (ret)
-		goto err_free;
+		goto err_free_page;
 
 	pfn = PFN_DOWN(sgx_get_epc_phys_addr(epc_page));
 
@@ -61,8 +71,10 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
 
 err_delete:
 	xa_erase(&vepc->page_array, index);
-err_free:
+err_free_page:
 	sgx_free_epc_page(epc_page);
+err_free_owner:
+	kfree(owner);
 	return ret;
 }
 
@@ -122,6 +134,7 @@ static int sgx_vepc_remove_page(struct sgx_epc_page *epc_page)
 
 static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
 {
+	struct sgx_vepc_page *owner = (struct sgx_vepc_page *)epc_page->owner;
 	int ret = sgx_vepc_remove_page(epc_page);
 	if (ret) {
 		/*
@@ -141,6 +154,7 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
 		return ret;
 	}
 
+	kfree(owner);
 	sgx_free_epc_page(epc_page);
 	return 0;
 }
-- 
2.25.1

