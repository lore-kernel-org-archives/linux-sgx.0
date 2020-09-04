Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5DC8C433E2
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 15:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A59542074D
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 15:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgIDPid (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:38:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:18695 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgIDPic (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 11:38:32 -0400
IronPort-SDR: HunqAupkhOQJs8eBdpXYX5hiwDqsElrLDfS2LAa829TjT14v1s5BWe2nj8sYlq1q/wrM6gU4cO
 pHx6gL2UrnzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="242581981"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="242581981"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 08:38:31 -0700
IronPort-SDR: lhzYd8BGWDjZj5jOy9zaU/PxJ2uWXRJknEQ/dVh32iPBCMviGEKSXSCmESynskoY/JJkqm1ugs
 Wi/COMJjlb0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="302668532"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga006.jf.intel.com with ESMTP; 04 Sep 2020 08:38:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v37] x86/sgx: Properly describe vdso_sgx_enter_enclave_t to fix kdoc warning
Date:   Fri,  4 Sep 2020 08:38:16 -0700
Message-Id: <20200904153816.1281-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Describe the vdso_sgx_enter_enclave_t typedef instead of the backing
__vdso_sgx_enter_enclave() in the kernel-doc comment for the typedef to
fix a kernel-doc warning.

Opportunistically add a missing asterisk to fix a second warning.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/sgx.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index b1d63f90ad64..b3d5ccf5b976 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -145,7 +145,9 @@ struct sgx_enclave_run {
 };
 
 /**
- * __vdso_sgx_enter_enclave() - Enter an SGX enclave
+ * typedef vdso_sgx_enter_enclave_t - Prototype for __vdso_sgx_enter_enclave(),
+ *				      a vDSO function to enter an SGX enclave.
+ *
  * @rdi:	Pass-through value for RDI
  * @rsi:	Pass-through value for RSI
  * @rdx:	Pass-through value for RDX
@@ -177,7 +179,7 @@ struct sgx_enclave_run {
  * never fixed up and are always delivered via standard signals. On synchrously
  * reported exceptions, -EFAULT is returned and details about the exception are
  * recorded in @e, the optional sgx_enclave_exception struct.
-
+ *
  * If an exit handler is provided, the handler will be invoked on synchronous
  * exits from the enclave and for all synchronously reported exceptions. In
  * latter case, @e is filled prior to invoking the handler.
-- 
2.28.0

