Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A0EC433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 10:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiCIKlh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 05:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiCIKlh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 05:41:37 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71FDE1B
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 02:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646822438; x=1678358438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=0c7C83VT4yAjMSxjYt5NdZyagXYk1dNWz4oboMUV63M=;
  b=Nqs7UHtkd76fyiOnfr2FUj97QeoL3EapGPTl5+4wGGuwNLVtLqc9U1l2
   UReyboKNP+L6XnmouIPQjCBz7cyj9FTSvJSY84EWg6MdTxy32oMumHlc0
   JaH1urT9v1MCMXeYXjfXTGwNk7uK06I7FO8jU/Xc+QmRFnjkQ1CBbe8bl
   4sTBVqjQLTatMfUl5Z08UJASgNqThSMtFHW43W5HSeL4vvCr1v6Vl8OL2
   GQc/0cFNwICeqiilVlVbGcH6L1OdNgygI1Dsob60Nxuz6verh0Dp+PZ3W
   ATOcfEHmf3Ga1oybN7gx/KIAGotuFXjjYk4pSqXFXH5IKuQPX9X7E1oWF
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="341373603"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="341373603"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 02:40:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="547582951"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2022 02:40:37 -0800
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     dave.hansen@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH 10/11] x86/sgx: Call ENCLS[EUPDATESVN] during SGX initialization
Date:   Wed,  9 Mar 2022 18:40:49 +0800
Message-Id: <20220309104050.18207-11-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220309104050.18207-1-cathy.zhang@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

A snapshot of the processor microcode SVN is taken each boot cycle at
the time when Intel SGX is first used. This results in microcode
updates being loadable at any time, fixing microcode issues. However,
if system boot up through kexec() from error recovery, no hardware
reset happens, any SGX leaf execution during boot up is not assumed
as the first use in such case, and no snapshot of SVN is taken. So,
it's necessary to call ENCLS[EUPDATESVN] to update SVN automatically,
rather than waiting for the admin to do it when he/she is even not
aware of that.

Call ENCLS[EUPDATESVN] after sanitizing pages will increase the chance
of success, for it requires that EPC is empty.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 431a19e0ea41..95d43d7423ec 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -397,8 +397,10 @@ void sgx_direct_reclaim(void)
 		sgx_reclaim_pages();
 }
 
+int update_cpusvn_intel(void);
 static int ksgxd(void *p)
 {
+	int ret;
 	int srcu_idx;
 
 	set_freezable();
@@ -411,7 +413,16 @@ static int ksgxd(void *p)
 	__sgx_sanitize_pages(&sgx_dirty_page_list);
 
 	/* sanity check: */
-	WARN_ON(!list_empty(&sgx_dirty_page_list));
+	if (!WARN_ON(!list_empty(&sgx_dirty_page_list))) {
+		/*
+		 * Do SVN update for kexec(). It should complete without error, for
+		 * all EPC pages are unused at this point.
+		 */
+		if (cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN) {
+			ret = update_cpusvn_intel();
+			WARN_ON(ret && (ret != SGX_NO_UPDATE));
+		}
+	}
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
-- 
2.17.1

