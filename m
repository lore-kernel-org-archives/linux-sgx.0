Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D13C742A5
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 04:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B73B3217D6
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 04:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfGLEGl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Jul 2019 00:06:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:7116 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbfGLEGl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 12 Jul 2019 00:06:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 21:06:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,481,1557212400"; 
   d="scan'208";a="160275168"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by orsmga008.jf.intel.com with ESMTP; 11 Jul 2019 21:06:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v21] x86/sgx: Provide stub for sgx_drv_init when driver is disabled
Date:   Thu, 11 Jul 2019 21:06:39 -0700
Message-Id: <20190712040639.18037-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The core SGX code expects sgx_drv_init() to always be available, provide
a stub to handle CONFIG_INTEL_SGX_DRIVER=n.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/driver.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
index c71570a9cd01..211d5112623e 100644
--- a/arch/x86/kernel/cpu/sgx/driver/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -34,6 +34,14 @@ extern u32 sgx_xsave_size_tbl[64];
 extern const struct file_operations sgx_provision_fops;
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
+
+#ifdef CONFIG_INTEL_SGX_DRIVER
 int sgx_drv_init(void);
+#else
+static inline int sgx_drv_init(void)
+{
+	return -ENODEV;
+}
+#endif
 
 #endif /* __ARCH_X86_INTEL_SGX_H__ */
-- 
2.22.0

