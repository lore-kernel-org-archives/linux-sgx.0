Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C635EC43217
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Apr 2022 14:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346814AbiDAO0U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346813AbiDAO0T (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Apr 2022 10:26:19 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6591179A7
        for <linux-sgx@vger.kernel.org>; Fri,  1 Apr 2022 07:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648823070; x=1680359070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=WN/krY8rJ7X5+9TGOsMytyTsU1nkS4gKTLDejKKaG3M=;
  b=hf8ofM3SERkswtycOaIO2PfJe6E/gCSfWzTVz352HhkSTY4xqUtFYs6C
   O7RRPLEZkiM9grD5DXWFbPZFCJEXIDsOG64tdxvaGPinfeR11c3ddiLjA
   gvsgnVLgKsIPIoGowMhmvrA+WrhTuN4FT91vjWXJuOBLHeT8fRnZdl4bL
   XEGgMSGZNJFoJGilv6C1Lrp54l23rHrfFndivehjoLQc7N2vfElfBRNgI
   qCAly6SJYReiwc84m/WsDPK2P3SoohbFxCLvvxxm7BO0/DQs365+Pui6Z
   kmOBOw6tGwo5+W9ysYf+kT3MkYv81EHiDjMxGacfeOQlVmhbU1Xy1xVs3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="240739889"
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="240739889"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 07:24:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="695908362"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 01 Apr 2022 07:24:27 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH v3 05/10] x86/sgx: Save the size of each EPC section
Date:   Fri,  1 Apr 2022 22:24:04 +0800
Message-Id: <20220401142409.26215-6-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220401142409.26215-1-cathy.zhang@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

For SGX CPUSVN update process will check all EPC pages in each
section to ensure they will be marked as unused, it requires to
know the size of each EPC section to end the loop.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
---
 arch/x86/kernel/cpu/sgx/sgx.h  | 1 +
 arch/x86/kernel/cpu/sgx/main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 0b036f19cca1..45ba6fcabfda 100644
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

