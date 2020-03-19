Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90610C4332B
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 20:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EAEE20774
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 20:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgCSUvW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 16:51:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:36668 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgCSUvV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 16:51:21 -0400
IronPort-SDR: u/DGIDRTRvVxOZ7ya6tnbp/2rexaq14ZZSAJrwt/sjoHmhqrUScdkLIhysfGsHQQVZ1Kmf0eU3
 beMgCHOk3gaQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 13:51:21 -0700
IronPort-SDR: spE02TgVxkwnJTAjSav8tVJrmS3TwKfNiQjNG7bD27tyLMHEXL/E2+LmOAOKnA8dy9AoARQN65
 zYQP/oaP41Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,573,1574150400"; 
   d="scan'208";a="418482336"
Received: from oamor-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.182.181])
  by orsmga005.jf.intel.com with ESMTP; 19 Mar 2020 13:51:19 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] x86/vdso: Use named constant for ENCLU leaves
Date:   Thu, 19 Mar 2020 22:51:16 +0200
Message-Id: <20200319205116.124166-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Rather than using magic numbers and a comment, replace the magic
numbers with named constants.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
Already pushed (as is RSA key generation). Just something noted when
going through 2/8 patch.
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 5 +++--
 arch/x86/include/asm/enclu.h             | 8 ++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/enclu.h

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 22a22e0774d8..7c01a629dc7e 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -3,6 +3,7 @@
 #include <linux/linkage.h>
 #include <asm/export.h>
 #include <asm/errno.h>
+#include <asm/enclu.h>
 
 #include "extable.h"
 
@@ -85,9 +86,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 
 .Lenter_enclave:
 	/* EENTER <= leaf <= ERESUME */
-	cmp	$0x2, %eax
+	cmp	EENTER, %eax
 	jb	.Linvalid_leaf
-	cmp	$0x3, %eax
+	cmp	ERESUME, %eax
 	ja	.Linvalid_leaf
 
 	/* Load TCS and AEP */
diff --git a/arch/x86/include/asm/enclu.h b/arch/x86/include/asm/enclu.h
new file mode 100644
index 000000000000..06157b3e9ede
--- /dev/null
+++ b/arch/x86/include/asm/enclu.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_ENCLU_H
+#define _ASM_X86_ENCLU_H
+
+#define EENTER	0x02
+#define ERESUME	0x03
+
+#endif /* _ASM_X86_ENCLU_H */
-- 
2.25.1

