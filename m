Return-Path: <SRS0=F+z5=DI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43ABC4727E
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 21:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B74D20759
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Oct 2020 21:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgJAVCT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Oct 2020 17:02:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:26062 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbgJAVCS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Oct 2020 17:02:18 -0400
IronPort-SDR: l/6/7ZUaO1Y74uKzRC09MSmbOM0C1admHEvokPmPEgJSjgyelLVg9KtTgJ3YKVLvWZiBaQEPTt
 3BdqM3+lrN2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="162912760"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="162912760"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 14:02:09 -0700
IronPort-SDR: XWbsbBy2nzVQvZXee7ntK5gNSwqNg89rOAgN/U6+tLdKfdJYzwlYA15JP4tqYQ3PrvtW882A1K
 Ux47MW2Cq1Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="514916951"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga006.fm.intel.com with ESMTP; 01 Oct 2020 14:02:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH] x86/sgx: Update correct attributes variable when allowing provisioning
Date:   Thu,  1 Oct 2020 14:02:08 -0700
Message-Id: <20201001210208.19070-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Set the PROVISIONKEY flag in attributes_mask, a.k.a. the mask of allowed
attributes for the enclave, when the enclave's owner demonstrates access
to /dev/sgx/provision.  Setting the flag in the enclave's attributes
effectively declares intent to access the key, whereas the ioctl()'s
intent is to grant access to the key.

Fixes: 80e062767a37 ("x86/sgx: Add SGX_IOC_ENCLAVE_PROVISION")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index ec38a9416788..16d0c9abafc2 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -763,7 +763,7 @@ static long sgx_ioc_enclave_provision(struct sgx_encl *encl, void __user *arg)
 		goto out;
 	}
 
-	encl->attributes |= SGX_ATTR_PROVISIONKEY;
+	encl->attributes_mask |= SGX_ATTR_PROVISIONKEY;
 	ret = 0;
 
 out:
-- 
2.28.0

