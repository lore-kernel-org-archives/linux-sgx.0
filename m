Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6A1C742A8
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 04:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11A3C20644
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 04:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfGLEM5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Jul 2019 00:12:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:56041 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfGLEM5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 12 Jul 2019 00:12:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 21:12:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,481,1557212400"; 
   d="scan'208";a="171446322"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by orsmga006.jf.intel.com with ESMTP; 11 Jul 2019 21:12:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v21] x86/sgx: Return error from driver init if launch control isn't supported
Date:   Thu, 11 Jul 2019 21:12:55 -0700
Message-Id: <20190712041255.29219-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Return an error when the driver fails to load, otherwise the core SGX
code will unnecessarily consume resources, e.g. tracking EPC and running
its kthread.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index 2d1943c13879..f4a2ef26fcbf 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -195,7 +195,7 @@ int sgx_drv_init(void)
 
 	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
 		pr_info("sgx: The public key MSRs are not writable\n");
-		return 0;
+		return -ENODEV;
 	}
 
 	ret = bus_register(&sgx_bus_type);
-- 
2.22.0

