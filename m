Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2C2C43334
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jun 2022 06:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiFHGBA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236075AbiFHFuE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Jun 2022 01:50:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E530A1D1048
        for <linux-sgx@vger.kernel.org>; Tue,  7 Jun 2022 20:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654658815; x=1686194815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QcQvD5XXOCw1M3uSji8Ul6jYWHA8sqYGaqMLrLAuiic=;
  b=U1+g3uEM2HafEkxenbS6TgcVlV6OrbBLdlAWV9Vl6AIExlO9EEypAm2M
   Lu1FF/Crt0ZtjsprrI1udd33zBeyEHBT0Bkyyv2GvTKgowtORSq+bVwFt
   BuUjPgn5/PfCzzLnHZzqSyaSf4yii216ywUi1r0Y+tBiMxvL3Eget+Vi4
   KiThwLPrRYOLQjZHJQ+BDf8kksghJawE26auxHYoT18uFJjMPDNV5NSOr
   IAHZmix+zxk2VtT9YGJgSRUqTkm/LUC+PpXjMW0YCG5naQ8MoAdNxF4C5
   /uWraVoLiKQhcKzaq9eLWmn52K0rijN/AnJqAMoeJksgwTHkc6dIOS5DF
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="302142952"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="302142952"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 20:26:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="670325111"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jun 2022 20:26:53 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v4 3/3] x86/sgx: Fine grained SGX MCA behavior for normal case
Date:   Wed,  8 Jun 2022 11:26:54 +0800
Message-Id: <20220608032654.1764936-4-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220608032654.1764936-1-zhiquan1.li@intel.com>
References: <20220608032654.1764936-1-zhiquan1.li@intel.com>
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
No changes since V3.

Changes since V2:
- Adapted the code since struct sgx_vepc_page was discarded.
- Replace EPC page flag SGX_EPC_PAGE_IS_VEPC with
  SGX_EPC_PAGE_KVM_GUEST as they are duplicated.

Changes since V1:
- Add valuable information from Jarkko and Tony the into commit
  message.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index faca7f73b06d..69a2a29c8957 100644
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

