Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D29C4332F
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Nov 2022 22:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiKGWCW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Nov 2022 17:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiKGWCO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Nov 2022 17:02:14 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08925F5B8
        for <linux-sgx@vger.kernel.org>; Mon,  7 Nov 2022 14:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667858532; x=1699394532;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=lgTT7BDsaUBFlfZ/Oh/Ams3LDTP00GBbNl8HQA6L+sI=;
  b=Oh4WvkqG1eJwBAKS2VfTJTiX25pIKMc7AwWdrU1Pr6Kn7pk5R7pvTn/E
   R1y4Q3ua1K18d/2SYL1NL219BtfZf9q++1nI4NxrFPKferQXeUAyiyp4k
   LXU1XiH9tPS+lQneBArttBYPhyEgbwQJR2NHU0m0ibVcfoFFAopxDPJQt
   8i9oPOsqTsKqoWBx+HdVM8ymwNneCTltcQsdAR0ZTbKiDYoDmFngxwgXF
   6L7Ef9v6ZVqJUEQPzKEW5W15iewKsLjljbnqaHLWiQVRPlN9idl0N1kJc
   2T8e5W3prWlxXCO6RLdDLzJYDsMeDO6pO/mS165fDIToYTKQI6198piY3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="308158023"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="308158023"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:02:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="630643321"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="630643321"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga007.jf.intel.com with ESMTP; 07 Nov 2022 14:02:12 -0800
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v3 1/4] x86/sgx: Export sgx_encl_eaug_page
Date:   Mon,  7 Nov 2022 14:02:09 -0800
Message-Id: <20221107220212.257422-2-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107220212.257422-1-haitao.huang@linux.intel.com>
References: <20221107220212.257422-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This function will be called by both the page fault handler
and the fops->fadvise callback.

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 4 ++--
 arch/x86/kernel/cpu/sgx/encl.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 8bdeae2fc309..1abc5e7f2660 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -308,8 +308,8 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
  * Returns: Appropriate vm_fault_t: VM_FAULT_NOPAGE when PTE was installed
  * successfully, VM_FAULT_SIGBUS or VM_FAULT_OOM as error otherwise.
  */
-static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
-				     struct sgx_encl *encl, unsigned long addr)
+vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
+			      struct sgx_encl *encl, unsigned long addr)
 {
 	vm_fault_t vmret = VM_FAULT_SIGBUS;
 	struct sgx_pageinfo pginfo = {0};
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index a65a952116fd..557d4abb13fc 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -127,5 +127,7 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 					 unsigned long addr);
 struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim);
 void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
+vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
+			      struct sgx_encl *encl, unsigned long addr);
 
 #endif /* _X86_ENCL_H */
-- 
2.25.1

