Return-Path: <SRS0=VoGi=VL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB671C73C66
	for <linux-sgx@archiver.kernel.org>; Sun, 14 Jul 2019 14:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C57A52063F
	for <linux-sgx@archiver.kernel.org>; Sun, 14 Jul 2019 14:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfGNOcU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 14 Jul 2019 10:32:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:55007 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbfGNOcU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 14 Jul 2019 10:32:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jul 2019 07:32:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,490,1557212400"; 
   d="scan'208";a="194260874"
Received: from hgenzken-mobl.ger.corp.intel.com (HELO localhost) ([10.249.35.131])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jul 2019 07:32:18 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] x86/sgx: Return 0 when !CONFIG_INTEL_SGX_DRIVER
Date:   Sun, 14 Jul 2019 17:32:12 +0300
Message-Id: <20190714143212.971-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When the config option is not enabled the initialization is always
succesful.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
This was the reason why I got the -ENODEV error with my BuildRoot image.
The config option was not enabled but took some time realize as I was
kind of getting an error code from the driver initialization. Finally
when I used ftrace with 'sgx*' I knew what was going on.
 arch/x86/kernel/cpu/sgx/driver/driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
index da60839b133a..aafa64a4f481 100644
--- a/arch/x86/kernel/cpu/sgx/driver/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -37,7 +37,7 @@ int sgx_drv_init(void);
 #else
 static inline int sgx_drv_init(void)
 {
-	return -ENODEV;
+	return 0;
 }
 #endif
 
-- 
2.20.1

