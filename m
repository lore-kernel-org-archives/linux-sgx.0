Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7ECAC433FE
	for <linux-sgx@archiver.kernel.org>; Thu, 19 May 2022 03:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiESDLj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 May 2022 23:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbiESDLW (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 18 May 2022 23:11:22 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4251C105
        for <linux-sgx@vger.kernel.org>; Wed, 18 May 2022 20:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652929881; x=1684465881;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IwUe7K8IADSFPx3HQK9bTZltCwGoweUn89x9PPB3w7I=;
  b=Zqq2/jrXn0dcHuNQ7sHQtARb7ogsO+cc7T7UBe6gxppjLbp0JB8eiVk/
   u17zxmM+ZUk6VgXK9KOchY1dy5yFpzv900O4NFfx1moDTP9aec47Z/fKA
   sSb8UfC8EL789HbGwdcg4XcxuE+M7Rw0M4HNfydPTsVlX7c7dO3K/gWK8
   rJlDsuPtYK/lHLIbru5B+yemAN6ErCQky6J1hPSMV4KUkIaon6hCNDFN1
   7dUbHX9atz9/DaG6mfAzICiaBoFq3mUWpQcVHvHlMwik/3GqfRaGPI2NB
   0tOTBxVv8RZ94o573BWuNT6md/YDVf7RwAEMYnJM+RlGm0uDNAxO3mTOT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="297293524"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="297293524"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 20:11:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="569928883"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by orsmga007.jf.intel.com with ESMTP; 18 May 2022 20:11:18 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        kai.huang@intel.com, fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v2 4/4] x86/sgx: Fine grained SGX MCA behavior for normal case
Date:   Thu, 19 May 2022 11:12:05 +0800
Message-Id: <20220519031205.245901-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When the application accesses a SGX EPC page with memory failure, the
task will receive a SIGBUS signal without any extra info, unless the EPC
page has SGX_EPC_PAGE_IS_VEPC flag. However, in some cases, we only use
SGX in sub-task and we don't expect the entire task group be killed due
to a SGX EPC page for a sub-task has memory failure.

To fix it, we extend the solution for normal case. That is, the SGX
regular EPC page with memory failure will trigger a SIGBUS signal with
code BUS_MCEERR_AR and additional info, so that the user has opportunity
to make further decision.

Suppose an enclave is shared by multiple processes, when an enclave page
triggers a machine check, the enclave will be disabled so that it
couldn't be entered again. Killing other processes with the same enclave
mapped would perhaps be overkill, but they are going to find that the
enclave is "dead" next time they try to use it. Thanks for Jarkko's head
up and Tony's clarification on this point.

Our intension is to provide additional info so that the application has
more choices. Current behavior looks gently, and we don't want to change
it.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
---
Changes since V1:
- Add valuable information from Jarkko and Tony the into commit message.
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

