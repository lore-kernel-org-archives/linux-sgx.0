Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68ED7C433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 10 May 2022 03:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbiEJDVU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 23:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiEJDVG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 23:21:06 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB2C13F5B
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 20:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652152630; x=1683688630;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ICIJXWmrv+60f70pWneQ0AU7qcHx6sOBLX6B13GWKLY=;
  b=N8R9S5voU8ugCj88V9ODq4aqcgr9EkIIOR5jCoIERRNetD1/AudJEkIv
   9DKGV9mMOt7Id328e/9M7PBCkV1ehM13t/LBQkFV9mHFJ9ejR7OeAZMGr
   2iAp2opHOib4IWWY3iaBokRjet9mHWKQAcyfFd1mKIabmRi8Yv+Jg+xim
   7oiNPpkrEy9uRY3kBQCix/DwVBqT/IclPEr48xx8PHPcM2nGQUk96CLmD
   JtkFcnOef/yNochKirCy7lJkrDv6pSLAN4DhRHXXgM3DWuLxlyo7xtc/l
   YUDctpO4JgtokLr9p3qoYDVqXEvKccCNdn9+lAe9LE0FBtVL+X7OhXggB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="249775633"
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="249775633"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 20:17:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="710818859"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2022 20:17:08 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH 4/4] x86/sgx: Fine grained SGX MCA behavior for normal case
Date:   Tue, 10 May 2022 11:17:58 +0800
Message-Id: <20220510031758.3181525-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When the application accesses a SGX EPC page with memory failure, the
task will receive a SIGBUS signal without any extra info, unless the EPC
page has SGX_EPC_PAGE_IS_VEPC flag. However, in some cases, we only use
SGX in sub-task and we don’t expect the entire task group be killed due
to a SGX EPC page for a sub-task has memory failure.

To fix it, we extend the solution for normal case. That is, the SGX
regular EPC page with memory failure will trigger a SIGBUS signal with
code BUS_MCEERR_AR and additional info, so that the user has opportunity
to make further decision.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 81801ab0009e..b43fb374b5cd 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -710,7 +710,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
 	struct sgx_epc_section *section;
 	struct sgx_numa_node *node;
-	struct sgx_vepc_page *owner;
+	struct sgx_encl_page *owner;
+	unsigned long vaddr;
 	int ret = 0;
 
 	/*
@@ -729,14 +730,17 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	 * enclave is broken.
 	 */
 	if (flags & MF_ACTION_REQUIRED) {
-		/*
-		 * In case the error memory is accessed by VM guest, provide
-		 * extra info for hypervisor to make further decision but not
-		 * simply kill it.
-		 */
-		if (page->flags & SGX_EPC_PAGE_IS_VEPC) {
-			owner = (struct sgx_vepc_page *)page->owner;
-			ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)owner->vaddr,
+		owner = page->owner;
+		if (owner) {
+			/*
+			 * Provide extra info to the task so that it can make further
+			 * decision but not simply kill it.
+			 */
+			if (page->flags & SGX_EPC_PAGE_IS_VEPC)
+				vaddr = ((struct sgx_vepc_page *)owner)->vaddr;
+			else
+				vaddr = owner->desc & PAGE_MASK;
+			ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)vaddr,
 					PAGE_SHIFT);
 			if (ret < 0)
 				pr_err("Memory failure: Error sending signal to %s:%d: %d\n",
-- 
2.25.1

