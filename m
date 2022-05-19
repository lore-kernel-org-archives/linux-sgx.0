Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C51C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 19 May 2022 03:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiESDLi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 May 2022 23:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiESDKz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 18 May 2022 23:10:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E34EE20
        for <linux-sgx@vger.kernel.org>; Wed, 18 May 2022 20:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652929853; x=1684465853;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t6cB38s5iIp/ZWT/5zDoeGEbvxlOCZzwKYo5Gqfcdxk=;
  b=myoO2aUu9roc0/d5rvStEkvniVcQ0JxRJvZ5r7b8OToisUm+gWak87PA
   nnk58Xyv7VmQsa2GnHcNCEsxb6jBsxN6Vf2g857CXajCsTuzIRdc1eUh9
   kvXOrlJcev7+NXn4VKPNBdIuR7654E2bjnvCxFyKMxbrM29m1Sb3THdwZ
   HGWuXai5bkQAaIF9jjdadD/vAXpAg2Yxi5sbj789WSU6UBDsoeA0Rmdl3
   Z7e7/h3oS3s2wJfE347JVx08ZEXYLjBseyNGbkhOAmL4lz9D7sfqPX2bB
   PaiQFKzw5AxuWoKRcaVQfLt82I1r9wGskQVtAzxB2IJOfrq9zKuW63YZi
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="272121692"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="272121692"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 20:10:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="569928771"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by orsmga007.jf.intel.com with ESMTP; 18 May 2022 20:10:50 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        kai.huang@intel.com, fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v2 2/4] x86/sgx: add struct sgx_vepc_page to manage EPC pages for vepc
Date:   Thu, 19 May 2022 11:11:37 +0800
Message-Id: <20220519031137.245767-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Current SGX data structures are insufficient to track the EPC pages for
vepc. For example, if we want to retrieve the virtual address of an EPC
page allocated to an enclave on host, we can find this info from its
owner, the 'desc' field of struct sgx_encl_page. However, if the EPC
page is allocated to a KVM guest, this is not available, as their owner
is a shared vepc.

So, we introduce struct sgx_vepc_page which can be the owner of EPC
pages for vepc and saves the useful info of EPC pages for vepc, like
struct sgx_encl_page.

Canonical memory failure collects victim tasks by iterating all the
tasks one by one and use reverse mapping to get victim tasks' virtual
address.

This is not necessary for SGX - as one EPC page can be mapped to ONE
enclave only. So, this 1:1 mapping enforcement allows us to find task
virtual address with physical address directly. Even though an enclave
has been shared by multiple processes, the virtual address is the same.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
---
Changes since V1:
- Add documentation suggested by Jarkko.
- Revise the commit message.
---
 arch/x86/kernel/cpu/sgx/sgx.h  | 15 +++++++++++++++
 arch/x86/kernel/cpu/sgx/virt.c | 24 +++++++++++++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index ad3b455ed0da..9a4292168389 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -28,6 +28,8 @@
 
 /* Pages on free list */
 #define SGX_EPC_PAGE_IS_FREE		BIT(1)
+/* Pages is used by VM guest */
+#define SGX_EPC_PAGE_IS_VEPC		BIT(2)
 
 struct sgx_epc_page {
 	unsigned int section;
@@ -114,4 +116,17 @@ struct sgx_vepc {
 	struct mutex lock;
 };
 
+/**
+ * struct sgx_vepc_page - SGX virtual EPC page structure
+ * @vaddr:		the virtual address when the EPC page was mapped
+ * @vepc:		the owner of the virtual EPC page
+ *
+ * When a virtual EPC page is allocated to guest, we use this structure
+ * to track the associated information on host, like struct sgx_encl_page.
+ */
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

