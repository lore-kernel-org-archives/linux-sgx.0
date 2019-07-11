Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61D1C73C66
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 17:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9871D20872
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 17:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfGKR6i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 13:58:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:31596 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728355AbfGKR6i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 13:58:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 10:58:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="168093193"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jul 2019 10:58:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v21] x86/sgx: Annotate SGX driver init functions with __init
Date:   Thu, 11 Jul 2019 10:58:36 -0700
Message-Id: <20190711175836.16120-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The SGX driver can no longer be built as a loadable module, ergo its
initialization functions are only called during actual init.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/driver.h | 2 +-
 arch/x86/kernel/cpu/sgx/driver/main.c   | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
index c71570a9cd01..8af7c38dddd0 100644
--- a/arch/x86/kernel/cpu/sgx/driver/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -34,6 +34,6 @@ extern u32 sgx_xsave_size_tbl[64];
 extern const struct file_operations sgx_provision_fops;
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
-int sgx_drv_init(void);
+int __init sgx_drv_init(void);
 
 #endif /* __ARCH_X86_INTEL_SGX_H__ */
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index c7fc32e26105..da6d849d3cb4 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -198,10 +198,9 @@ static void sgx_dev_release(struct device *dev)
 {
 }
 
-static int sgx_dev_init(const char *name, struct device *dev,
-			struct cdev *cdev,
-			const struct file_operations *fops,
-			int minor)
+static __init int sgx_dev_init(const char *name, struct device *dev,
+			       struct cdev *cdev,
+			       const struct file_operations *fops, int minor)
 {
 	int ret;
 
@@ -222,7 +221,7 @@ static int sgx_dev_init(const char *name, struct device *dev,
 	return 0;
 }
 
-int sgx_drv_init(void)
+int __init sgx_drv_init(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 	u64 attr_mask, xfrm_mask;
-- 
2.22.0

