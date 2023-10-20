Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FF4C001DF
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Oct 2023 02:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjJTCyO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Oct 2023 22:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjJTCyN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 19 Oct 2023 22:54:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D8D12D;
        Thu, 19 Oct 2023 19:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697770452; x=1729306452;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RXhp1Hl5RWG+OnaMKvb2ezAsWUrT+9Ror9EiMI4G8cM=;
  b=KJfWRZyfW5J70d47nXvqDyjd4fiXnbdUzSAJfzPf/hu6rnDxJyEEjEDY
   bYCXEdSykjBPQyUxMsLMmk6ZaVglqHTmbki4Z6TM0iF3xzBRRGTBpa+G5
   8geS6uoCoVLT9DEtpmw5aOrt1PYRJRGg4EFtjMB2Y+PPVCpaLXffhcOoi
   N69Z1KEtnI6dCNuVYzU5E/TOnlbUqM+gBZ3T/6KaT+u71m/Ta7Vn5ojkO
   uaJ1uRws+k06Qz5uOLvr1FGAGdjxwZ1pB5HLUNn/VviNBzK0KEeyOLLd7
   ZAON2ZXlmPa4HPGRPzfTU1SLpR04CawJZa90TKjHqnqPbIZf58uC56Lao
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="366651771"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="366651771"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 19:54:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="786636737"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="786636737"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga008.jf.intel.com with ESMTP; 19 Oct 2023 19:54:11 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     jarkko@kernel.org, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     reinette.chatre@intel.com, kai.huang@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] x86/sgx: Return VM_FAULT_SIGBUS for EPC exhaustion
Date:   Thu, 19 Oct 2023 19:53:53 -0700
Message-Id: <20231020025353.29691-1-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In the EAUG on page fault path, VM_FAULT_OOM is returned when the
Enclave Page Cache (EPC) runs out. This may trigger unneeded OOM kill
that will not free any EPCs. Return VM_FAULT_SIGBUS instead.

Fixes: 5a90d2c3f5ef ("x86/sgx: Support adding of pages to an initialized enclave")
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 279148e72459..d13b7e4ad0f5 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -322,7 +322,7 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
  * ENCLS[EAUG] instruction.
  *
  * Returns: Appropriate vm_fault_t: VM_FAULT_NOPAGE when PTE was installed
- * successfully, VM_FAULT_SIGBUS or VM_FAULT_OOM as error otherwise.
+ * successfully, VM_FAULT_SIGBUS as error otherwise.
  */
 static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 				     struct sgx_encl *encl, unsigned long addr)
@@ -348,7 +348,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	secinfo_flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X;
 	encl_page = sgx_encl_page_alloc(encl, addr - encl->base, secinfo_flags);
 	if (IS_ERR(encl_page))
-		return VM_FAULT_OOM;
+		return VM_FAULT_SIGBUS;
 
 	mutex_lock(&encl->lock);
 
-- 
2.25.1

