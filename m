Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9F0C433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 10 May 2022 03:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbiEJDU6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 23:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiEJDU4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 23:20:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BBB26FE
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 20:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652152619; x=1683688619;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x2B1yQsCDywYxBD1Y8ouYiSrHNNkIfO2eJFEh0mzgr4=;
  b=IirbapKtvw8nxkB8NeTJ+VI49/Y5NFZcTk8/3AEIkOuJLEVaH07bIphI
   OJBQMCjcQkXGG7TdrMo4dQ8pWotbMi1TnP6VV3UlqIIumz3h8C9f2LBxt
   iSJW0ATg9h8tUKID5kOBJ305ahAn8UkFWXyq66ZyhjB/oeEEu2wBdbd3u
   sDyhdmcn+IALLIwczOpZzhPxhCfnPHKv+bj6CInOHusyDQNzwDPTKFjYN
   QGds/q9cWnod7ToZdRjRZJ98qwWmRZU45CaHD4SgURrE8rjtFw3J1VDkH
   yY1pZ2UHC9biYb8cdXuAUZPD28Z1rldi0VxuwWFnLdoLNUwnexzL9pORc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="269177127"
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="269177127"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 20:16:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="710818644"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2022 20:16:57 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH 3/4] x86/sgx: Fine grained SGX MCA behavior for virtualization
Date:   Tue, 10 May 2022 11:17:48 +0800
Message-Id: <20220510031748.3181459-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When VM guest access a SGX EPC page with memory failure, current
behavior will kill the guest, expected only kill the SGX application
inside it.

To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra
information for hypervisor to inject #MC information to guest, which is
helpful in SGX case.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8e4bc6453d26..81801ab0009e 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -710,6 +710,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
 	struct sgx_epc_section *section;
 	struct sgx_numa_node *node;
+	struct sgx_vepc_page *owner;
+	int ret = 0;
 
 	/*
 	 * mm/memory-failure.c calls this routine for all errors
@@ -726,8 +728,22 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	 * error. The signal may help the task understand why the
 	 * enclave is broken.
 	 */
-	if (flags & MF_ACTION_REQUIRED)
-		force_sig(SIGBUS);
+	if (flags & MF_ACTION_REQUIRED) {
+		/*
+		 * In case the error memory is accessed by VM guest, provide
+		 * extra info for hypervisor to make further decision but not
+		 * simply kill it.
+		 */
+		if (page->flags & SGX_EPC_PAGE_IS_VEPC) {
+			owner = (struct sgx_vepc_page *)page->owner;
+			ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)owner->vaddr,
+					PAGE_SHIFT);
+			if (ret < 0)
+				pr_err("Memory failure: Error sending signal to %s:%d: %d\n",
+					current->comm, current->pid, ret);
+		} else
+			force_sig(SIGBUS);
+	}
 
 	section = &sgx_epc_sections[page->section];
 	node = section->node;
-- 
2.25.1

