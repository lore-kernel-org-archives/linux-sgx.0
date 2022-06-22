Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFE2C433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Jun 2022 09:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiFVJhI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 Jun 2022 05:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbiFVJhH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 22 Jun 2022 05:37:07 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA7B35AAD
        for <linux-sgx@vger.kernel.org>; Wed, 22 Jun 2022 02:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655890625; x=1687426625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yhD4nyL4iV+PuCrN/tauAdoGztq7IpEcKdrueIrGy+Q=;
  b=knb/QfP70dljdWYwAJgkloXOQsXfGGXYLahSpUrl5jq4cCSJUAVuO3hT
   84BfaAshnCvwfG0aXIqnRop4UL5oPei3X69H0odPTcjEy/Nr39f5KV9Pd
   iMnv29GC9Axc+2kbp9tkgK/1tfpyjsTDL2NOhqF+/i9t3JyGSQbrlsrmd
   Fk5NZHtP96yE1ucANgqZgircvQ/VIfZhjSGuInE71iUZiWccHtSLyidar
   FhxqYlX6uqbtSbJPE+vxuiHCoWChyJJRhHhvU0goTUaJ3nY+N/Iy2qCQt
   pxHQw8uVJMVbEx7PXUvTv6kFrd+WxJ4K+Q3KRh4Xfo7Hukr9dJ3/foQx7
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="281100622"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="281100622"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 02:37:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="677448881"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2022 02:37:02 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v5 3/3] x86/sgx: Fine grained SGX MCA behavior for normal case
Date:   Wed, 22 Jun 2022 17:37:05 +0800
Message-Id: <20220622093705.2891642-4-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220622093705.2891642-1-zhiquan1.li@intel.com>
References: <20220622093705.2891642-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When the application accesses a SGX EPC page with memory failure, the
task will receive a SIGBUS signal without any extra info, unless the
EPC page has SGX_EPC_PAGE_KVM_GUEST flag. However, in some cases,
we only use SGX in sub-task and we don't expect the entire task group
be killed due to a SGX EPC page for a sub-task has memory failure.

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
No changes since V4.

Changes since V2:
- Adapted the code since struct sgx_vepc_page was discarded.
- Replace EPC page flag SGX_EPC_PAGE_IS_VEPC with
  SGX_EPC_PAGE_KVM_GUEST as they are duplicated.

Changes since V1:
- Add valuable information from Jarkko and Tony the into commit
  message.
---
 arch/x86/kernel/cpu/sgx/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 4507c2302348..7c55dcdb2b7c 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -739,12 +739,15 @@ int arch_memory_failure(unsigned long pfn, int flags)
 		 * decision but not simply kill it. This is quite useful for
 		 * virtualization case.
 		 */
-		if (page->flags & SGX_EPC_PAGE_KVM_GUEST) {
+		if (page->owner) {
 			/*
 			 * The "owner" field is repurposed as the virtual address
 			 * of virtual EPC page.
 			 */
-			vaddr = (unsigned long)page->owner & PAGE_MASK;
+			if (page->flags & SGX_EPC_PAGE_KVM_GUEST)
+				vaddr = (unsigned long)page->owner & PAGE_MASK;
+			else
+				vaddr = (unsigned long)page->owner->desc & PAGE_MASK;
 			ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)vaddr,
 					PAGE_SHIFT);
 			if (ret < 0)
-- 
2.25.1

