Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583D9C3A59E
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 01:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3148822DD3
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 01:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbfHVBgR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 21:36:17 -0400
Received: from mga07.intel.com ([134.134.136.100]:27552 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728188AbfHVBgR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 21:36:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 18:36:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,414,1559545200"; 
   d="scan'208";a="330211292"
Received: from soegtrop-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.52.79])
  by orsmga004.jf.intel.com with ESMTP; 21 Aug 2019 18:36:14 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] x86/sgx: Remove INTEL_SGX_DRIVER
Date:   Thu, 22 Aug 2019 04:36:08 +0300
Message-Id: <20190822013608.4927-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

As there are the SGX driver is the only SGX core user, remove
INTEL_SGX_DRIVER config flag for now. When there are >= 2 in-kernel
users, we can consider adding it back and make INTEL_SGX config depend
on disjunction of its clients config flags.

Reported-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/Kconfig                        | 14 --------------
 arch/x86/kernel/cpu/sgx/Makefile        |  2 +-
 arch/x86/kernel/cpu/sgx/driver/Makefile |  4 +---
 arch/x86/kernel/cpu/sgx/main.c          |  8 +++-----
 4 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f53cfc8d03e8..eac03f448b59 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1948,20 +1948,6 @@ config INTEL_SGX
 
 	  If unsure, say N.
 
-config INTEL_SGX_DRIVER
-	bool "Intel(R) SGX Driver"
-	depends on X86_64 && CPU_SUP_INTEL && INTEL_SGX
-	select CRYPTO
-	select CRYPTO_SHA256
-	---help---
-	  This options enables the kernel SGX driver that allows to construct
-	  enclaves to the process memory by using a device node (by default
-	  /dev/sgx) and a set of ioctls. The driver requires that the MSRs
-	  specifying the public key hash for the launch enclave are writable so
-	  that Linux has the full control to run enclaves.
-
-	  If unsure, say N.
-
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index e5d1e862969c..debde5345355 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -1,2 +1,2 @@
 obj-y += encl.o encls.o main.o reclaim.o
-obj-$(CONFIG_INTEL_SGX_DRIVER) += driver/
+obj-y += driver/
diff --git a/arch/x86/kernel/cpu/sgx/driver/Makefile b/arch/x86/kernel/cpu/sgx/driver/Makefile
index 01ebbbb06a47..9fd98c6ee61c 100644
--- a/arch/x86/kernel/cpu/sgx/driver/Makefile
+++ b/arch/x86/kernel/cpu/sgx/driver/Makefile
@@ -1,3 +1 @@
-obj-$(CONFIG_INTEL_SGX_DRIVER) += sgx.o
-sgx-$(CONFIG_INTEL_SGX_DRIVER) += ioctl.o
-sgx-$(CONFIG_INTEL_SGX_DRIVER) += main.o
+obj-y = ioctl.o main.o
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index e919e9ba5292..f790a03571c5 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -344,11 +344,9 @@ static __init int sgx_init(void)
 	if (ret)
 		goto err_page_cache;
 
-	if (IS_ENABLED(CONFIG_INTEL_SGX_DRIVER)) {
-		ret = sgx_drv_init();
-		if (ret)
-			goto err_kthread;
-	}
+	ret = sgx_drv_init();
+	if (ret)
+		goto err_kthread;
 
 	return 0;
 
-- 
2.20.1

