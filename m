Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1BBC4360C
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 21:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9083C214E0
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 21:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfJJVnE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 17:43:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:32755 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbfJJVnD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 17:43:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 14:43:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="194145477"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 10 Oct 2019 14:43:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 1/9] x86/sgx: WARN once if an enclave is released with unfreed EPC pages
Date:   Thu, 10 Oct 2019 14:42:53 -0700
Message-Id: <20191010214301.25669-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191010214301.25669-1-sean.j.christopherson@intel.com>
References: <20191010214301.25669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a WARN to detect EPC page leaks when releasing an enclave.  The
release flow uses the common sgx_encl_destroy() helper, which is allowed
to be called while the reclaimer holds references to the enclave's EPC
pages and so can't WARN in the scenario where the SECS is leaked because
it has active child pages.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index c13c3ba3430a..b4d7b2f9609f 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -511,6 +511,7 @@ void sgx_encl_release(struct kref *ref)
 		fput(encl->backing);
 
 	WARN_ONCE(!list_empty(&encl->mm_list), "mm_list non-empty");
+	WARN_ON_ONCE(encl->secs_child_cnt || encl->secs.epc_page);
 
 	kfree(encl);
 }
-- 
2.22.0

