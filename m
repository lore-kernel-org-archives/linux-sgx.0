Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39638C43217
	for <linux-sgx@archiver.kernel.org>; Fri, 20 May 2022 10:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbiETKll (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 May 2022 06:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348284AbiETKl0 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 20 May 2022 06:41:26 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBD619C0C
        for <linux-sgx@vger.kernel.org>; Fri, 20 May 2022 03:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653043284; x=1684579284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=aW0RR081c5kUUEof/cMnR2mUMvlHpmn6uxiXuK29TUU=;
  b=hAb0ySQi3PD0sS8z0mALl3Je/cpUkovy+DiVp33dLFVR+cX5lP281Mwn
   e8fpXffwCoA6jNXdQ2uJhtdqTxPcAl6kzgUa4cMQH+qYCgqkHC2nyf37F
   vv2hGXfqwNIuFvqobrlaCjTPcufFKyUtFEiBDLCB1c33TbzLnnItZWQ+k
   2zmpcF14A8UIN5j8sCnrxqxiEO3fGD6y+xGPVTu6h81BiQ46YFw9LRkSn
   UKeUkvet+X4v4UjWgemyM37oglRiPiHohKPFgDZFt+W/egbgXo4r0G9Yr
   JmyYrO90W+eYMPCoKtqI91Lr/JHKcPzNo0ZDFIf2DcsPfcaihKfAOode5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="271387016"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="271387016"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 03:41:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="715471069"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 20 May 2022 03:41:21 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH v5 9/9] x86/sgx: Call ENCLS[EUPDATESVN] during SGX initialization
Date:   Fri, 20 May 2022 18:39:04 +0800
Message-Id: <20220520103904.1216-10-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220520103904.1216-1-cathy.zhang@intel.com>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
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
Changes since v3:
 - Rename as sgx_update_cpusvn_intel().

Changes since v1:
 - Update accordingly for update_cpusvn_intel() return *void*.
---
 arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 0f541d01e561..aea6b237fda0 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -423,6 +423,7 @@ static bool sgx_should_reclaim(unsigned long watermark)
 	       !list_empty(&sgx_active_page_list);
 }
 
+void sgx_update_cpusvn_intel(void);
 static int ksgxd(void *p)
 {
 	int srcu_idx;
@@ -437,7 +438,14 @@ static int ksgxd(void *p)
 	__sgx_sanitize_pages(&sgx_dirty_page_list);
 
 	/* sanity check: */
-	WARN_ON(!list_empty(&sgx_dirty_page_list));
+	if (!WARN_ON(!list_empty(&sgx_dirty_page_list))) {
+		/*
+		 * Do SVN update for kexec(). It should complete without error, for
+		 * all EPC pages are unused at this point.
+		 */
+		if (cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN)
+			sgx_update_cpusvn_intel();
+	}
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
-- 
2.17.1

