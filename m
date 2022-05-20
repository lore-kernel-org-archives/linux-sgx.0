Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E679C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 20 May 2022 10:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236494AbiETKln (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 May 2022 06:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348251AbiETKlL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 20 May 2022 06:41:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA60ADE94
        for <linux-sgx@vger.kernel.org>; Fri, 20 May 2022 03:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653043269; x=1684579269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=qNttnh5/AWLaPyPpO2/Vo+FexWHtoZ1yMyE1c4BsNQ4=;
  b=gm0UasxWD+mlfCxnRyt8jz5vIlwCVYdafU18e6EHsfZflMJqrkbcKVTk
   uCeT7fBS+u/7pNJmJ+LB6gKr4CSMJzqmtP7ofWDoZfYJ7BAu7HumoAhlc
   m8OYeryc+pZQdRm8u9XI/7wdijwPGxY0OXeo5eZpTxCI2ZytTcUJKzn9A
   BX7KXEWnmoGpxZrHqgLjkcg33ny7J2FOXD2iF5Cd8q7qMyeqhh8sfSLGC
   nD8Jymj2qZyUEqc528vO39IcwHiDcw1uLRFcRbiXBglsGH0dUcW64ERDR
   KFdsG5dSoOml5TzCFCyZqUfyyEiOsyr2ag9hLGbTI/cYvJ7lRKnzbcrag
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="271386953"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="271386953"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 03:41:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="715471010"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 20 May 2022 03:41:07 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH v5 4/9] x86/sgx: Save the size of each EPC section
Date:   Fri, 20 May 2022 18:38:59 +0800
Message-Id: <20220520103904.1216-5-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220520103904.1216-1-cathy.zhang@intel.com>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGX CPUSVN update process should check all EPC pages to ensure they are
marked as unused. For EPC pages are stored in EPC sections, it's
required to save the size of each section, as the indicator for the end
of each section's traversing to unuse EPC pages.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>

---
Changes since v3:
 - Update commit log to explain clearly why record the size. (Suggested
   by Jarkko Sakkinen)
---
 arch/x86/kernel/cpu/sgx/sgx.h  | 1 +
 arch/x86/kernel/cpu/sgx/main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 4ad0e5396eef..775477e0b8af 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -63,6 +63,7 @@ struct sgx_epc_section {
 	void *virt_addr;
 	struct sgx_epc_page *pages;
 	struct sgx_numa_node *node;
+	u64 size;
 };
 
 extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ec2775652a50..5fbad67d529f 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -662,6 +662,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	}
 
 	section->phys_addr = phys_addr;
+	section->size = size;
 	xa_store_range(&sgx_epc_address_space, section->phys_addr,
 		       phys_addr + size - 1, section, GFP_KERNEL);
 
-- 
2.17.1

