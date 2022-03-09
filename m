Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC58FC433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 10:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiCIKl3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 05:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiCIKl2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 05:41:28 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAE137BF6
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 02:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646822430; x=1678358430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=TRsu0k6qJfQAJscm5EyiR33+jFQ2ZrQG7ziBnk9opcE=;
  b=lVnmmB43q08h6anWjMZWlJg5ztM4IcWEaHynlRgHTStbuTaweXAsx1ih
   TZ4COGdsMpztdSGejCOCeH4DrD5lxBzq59HXAstDN7nEL9O7p1BTKF+1+
   f0IrY26OQraIMy3fHa6piMnt3Fs22POzOcpfgAdrysHHHRWJasXOIsgMt
   Ow2lvpwnVsYJqTWUU8c1lAsQj5yZjyG9i4bOKw1M5oq1CoLPPo92JdVqu
   xrRK6yDcsHbey8HEYeHUNhEmG9KYowiRRcQfSCvIJrYpAv0xnhXDQm8dS
   Mh2ZvzWc+kgc0XiNtEaDbUH24fhRTVkY5sz5rPEtK84SPQUIDV/I0dvsx
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="341373563"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="341373563"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 02:40:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="547582896"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2022 02:40:28 -0800
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     dave.hansen@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH 05/11] x86/sgx: Save the size of each EPC section
Date:   Wed,  9 Mar 2022 18:40:44 +0800
Message-Id: <20220309104050.18207-6-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220309104050.18207-1-cathy.zhang@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
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
index 1dd06899a64c..8fa0f9c64a13 100644
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
index 99c86b77ca8f..c9331f6ba034 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -636,6 +636,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	}
 
 	section->phys_addr = phys_addr;
+	section->size = size;
 	xa_store_range(&sgx_epc_address_space, section->phys_addr,
 		       phys_addr + size - 1, section, GFP_KERNEL);
 
-- 
2.17.1

