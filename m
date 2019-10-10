Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554AEECE596
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 23:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31A80214E0
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 23:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfJJXVL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 19:21:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:34955 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbfJJXVK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 19:21:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 16:21:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="207300631"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 10 Oct 2019 16:21:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 v2 4/9] x86/sgx: WARN on any non-zero return from __eremove()
Date:   Thu, 10 Oct 2019 16:21:03 -0700
Message-Id: <20191010232108.27075-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191010232108.27075-1-sean.j.christopherson@intel.com>
References: <20191010232108.27075-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

WARN on any non-zero return from __eremove() to make it clear that any
kind of failure is unexpected.  Technically, warning on negative values
is unnecessary as the ENCLS helpers return SGX error codes, which are
currently all postive.  But, the more precise check might be
misinterpreted as implying the negative values are expected/ok.

Note, prior to a recent change, warning only on positive values was
necessary to avoid a redundant double-WARN as the WARN resided outside
of what is now sgx_free_page() and so could consume -EBUSY.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 2b540abbb61f..5170d4ba1096 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -137,7 +137,7 @@ int sgx_free_page(struct sgx_epc_page *page)
 	spin_unlock(&sgx_active_page_list_lock);
 
 	ret = __eremove(sgx_epc_addr(page));
-	WARN(ret > 0, "EREMOVE returned %d (0x%x)", ret, ret);
+	WARN(ret, "EREMOVE returned %d (0x%x)", ret, ret);
 
 	spin_lock(&section->lock);
 	list_add_tail(&page->list, &section->page_list);
-- 
2.22.0

