Return-Path: <SRS0=4JBP=XL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6822C49ED7
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 952A8214AF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Sep 2019 04:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfIPEOx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Sep 2019 00:14:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:4080 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPEOx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Sep 2019 00:14:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 21:14:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="387075964"
Received: from diernhof-mobl3.ger.corp.intel.com (HELO localhost) ([10.249.39.128])
  by fmsmga006.fm.intel.com with ESMTP; 15 Sep 2019 21:14:49 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH v2 05/17] x86/sgx: Turn encls_failed() as inline function
Date:   Mon, 16 Sep 2019 07:14:05 +0300
Message-Id: <20190916041417.12533-6-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
References: <20190916041417.12533-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Turn encls_failed() as an inline function. As far as the tracing goes we
issue warning consistently in the call sites, which is enough to catch
the potential issues.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/Makefile |  2 +-
 arch/x86/kernel/cpu/sgx/encls.c  | 24 ------------------------
 arch/x86/kernel/cpu/sgx/encls.h  | 18 +++++++++++++++++-
 3 files changed, 18 insertions(+), 26 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/sgx/encls.c

diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index 379e9c52848e..cfd29c42264b 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -1,5 +1,5 @@
 # core
-obj-y += encl.o encls.o main.o reclaim.o
+obj-y += encl.o main.o reclaim.o
 
 # driver
 obj-y += driver.o ioctl.o
diff --git a/arch/x86/kernel/cpu/sgx/encls.c b/arch/x86/kernel/cpu/sgx/encls.c
deleted file mode 100644
index 1b492c15a2b8..000000000000
--- a/arch/x86/kernel/cpu/sgx/encls.c
+++ /dev/null
@@ -1,24 +0,0 @@
-// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
-// Copyright(c) 2016-19 Intel Corporation.
-
-#include <asm/cpufeature.h>
-#include <asm/traps.h>
-#include "encls.h"
-#include "sgx.h"
-
-/**
- * encls_failed() - Check if an ENCLS leaf function failed
- * @ret:	the return value of an ENCLS leaf function call
- *
- * Check if an ENCLS leaf function failed. This is a condition where the leaf
- * function causes a fault that is not caused by an EPCM conflict.
- *
- * Return: true if there was a fault other than an EPCM conflict
- */
-bool encls_failed(int ret)
-{
-	int epcm_trapnr = boot_cpu_has(X86_FEATURE_SGX2) ?
-			  X86_TRAP_PF : X86_TRAP_GP;
-
-	return encls_faulted(ret) && ENCLS_TRAPNR(ret) != epcm_trapnr;
-}
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 6631afbf2f64..b7e6462e58b8 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -8,6 +8,7 @@
 #include <linux/rwsem.h>
 #include <linux/types.h>
 #include <asm/asm.h>
+#include <asm/traps.h>
 #include "sgx.h"
 
 /**
@@ -66,7 +67,22 @@ static inline bool encls_returned_code(int ret)
 	return !encls_faulted(ret) && ret;
 }
 
-bool encls_failed(int ret);
+/**
+ * encls_failed() - Check if an ENCLS leaf function failed
+ * @ret:	the return value of an ENCLS leaf function call
+ *
+ * Check if an ENCLS leaf function failed. This is a condition where the leaf
+ * function causes a fault that is not caused by an EPCM conflict.
+ *
+ * Return: true if there was a fault other than an EPCM conflict
+ */
+static inline bool encls_failed(int ret)
+{
+	int epcm_trapnr = boot_cpu_has(X86_FEATURE_SGX2) ?
+			  X86_TRAP_PF : X86_TRAP_GP;
+
+	return encls_faulted(ret) && ENCLS_TRAPNR(ret) != epcm_trapnr;
+}
 
 /**
  * __encls_ret_N - encode an ENCLS leaf that returns an error code in EAX
-- 
2.20.1

