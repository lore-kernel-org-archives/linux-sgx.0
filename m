Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC91C4332F
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Apr 2022 11:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244846AbiDULIe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Apr 2022 07:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388859AbiDULHz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Apr 2022 07:07:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889A6FFD
        for <linux-sgx@vger.kernel.org>; Thu, 21 Apr 2022 04:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650539094; x=1682075094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=j4UJUF70NSk0RzWaLoZTcW+T+o/dWb4AKAXSlaYPkuQ=;
  b=lsUg5cC+WfNCfslyGJAismCdT7yu6/isx24TPxxeqnjaZNTeeceQlKFq
   SbHhKISt6LeChayQQonkx7W/2IhRzy7PXrxEubq7yMP2gt2D09Vd+RudL
   OzQBf2ewHkfATGunABoKTtH1uhq830QsTmZjdrLAOPZROLE6Jx0AQQU6g
   Qs/XYbTU5Jw0WrjgtplNTHYaNRmj+OGp8ApvlYzQ3NhUNTYsQlFbwQIYl
   mJY45D3fLA2i3+6XbJ0nSLCcAaxaaeBXspFMLdq6qPH1zngztZLhfD4cG
   NLq/5XyUXS4sB7QVLYlBG8/dWrdql2SZrI4fVKDm/H/Pcm1oO7VDpzcPb
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244893400"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="244893400"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:04:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="703039147"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 21 Apr 2022 04:04:27 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@intel.com, yang.zhong@intel.com
Subject: [PATCH v4 4/9] x86/sgx: Save the size of each EPC section
Date:   Thu, 21 Apr 2022 19:03:21 +0800
Message-Id: <20220421110326.856-5-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220421110326.856-1-cathy.zhang@intel.com>
References: <20220421110326.856-1-cathy.zhang@intel.com>
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
index 10360f06c0df..031c1402cd7e 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -665,6 +665,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	}
 
 	section->phys_addr = phys_addr;
+	section->size = size;
 	xa_store_range(&sgx_epc_address_space, section->phys_addr,
 		       phys_addr + size - 1, section, GFP_KERNEL);
 
-- 
2.17.1

