Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5285FC433F5
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Apr 2022 14:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346817AbiDAO0c (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346822AbiDAO0b (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Apr 2022 10:26:31 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F69C11CF73
        for <linux-sgx@vger.kernel.org>; Fri,  1 Apr 2022 07:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648823082; x=1680359082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=T+hPy5K8MWlAG6yHiHd9+gI34P/tcc20T14oNHvLIhY=;
  b=Im7q0TO5LSBv+UgVLEt+SDR4G+QAFqf/S+yHMtPWfp7Ze5T2qGUI1e/v
   1LKl75uzT5YFG8SxkZg+s9V02noIulqt/IWgBO6Nm0XLMdiB5SSyIss8y
   1ze7xZpld6JdRGjF/L2RKdDohasPhhvMpsvTczcAZ5Z1Esx+xY9h/pxu8
   DqvH/mArRV/ya4NFEd3FFbT+ohB5tfW41iBo08iscWAQaGNDWYtQkRlUF
   f4GAR/TNLeGR5xnqmdoTWLSwy5XM+5iVJ1Ppa3a8Pw/kF3eThsaFZik71
   ilDJ40AogEpFJkZSqexfZpkt/GXWCotYFkraeoj/hv4RQmw6Q+zFL/EUP
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="240739929"
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="240739929"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 07:24:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="695908419"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 01 Apr 2022 07:24:40 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH v3 10/10] x86/sgx: Call ENCLS[EUPDATESVN] during SGX initialization
Date:   Fri,  1 Apr 2022 22:24:09 +0800
Message-Id: <20220401142409.26215-11-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220401142409.26215-1-cathy.zhang@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
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
Changes since v1:
 - Update accordingly for update_cpusvn_intel() return *void*.
---
 arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 20800c543110..48eb10f6c6fc 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -426,6 +426,7 @@ static bool sgx_should_reclaim(unsigned long watermark)
 	       !list_empty(&sgx_active_page_list);
 }
 
+void update_cpusvn_intel(void);
 static int ksgxd(void *p)
 {
 	int srcu_idx;
@@ -440,7 +441,14 @@ static int ksgxd(void *p)
 	__sgx_sanitize_pages(&sgx_dirty_page_list);
 
 	/* sanity check: */
-	WARN_ON(!list_empty(&sgx_dirty_page_list));
+	if (!WARN_ON(!list_empty(&sgx_dirty_page_list))) {
+		/*
+		 * Do SVN update for kexec(). It should complete without error, for
+		 * all EPC pages are unused at this point.
+		 */
+		if (cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN)
+			update_cpusvn_intel();
+	}
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
-- 
2.17.1

