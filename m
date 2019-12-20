Return-Path: <SRS0=2o92=2K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CE3C43603
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Dec 2019 22:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D59A0206DA
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Dec 2019 22:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfLTWzD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:55:03 -0500
Received: from mga03.intel.com ([134.134.136.65]:34039 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfLTWzD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Dec 2019 17:55:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 14:55:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,337,1571727600"; 
   d="scan'208";a="366508440"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 20 Dec 2019 14:55:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25 2/4] x86/sgx: Add missing linux/bits.h include in sgx/arch.h
Date:   Fri, 20 Dec 2019 14:54:59 -0800
Message-Id: <20191220225501.23476-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220225501.23476-1-sean.j.christopherson@intel.com>
References: <20191220225501.23476-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Include linux/bits.h for its defitions of BIT() and GENMASK*().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/arch.h            |  1 +
 tools/testing/selftests/x86/sgx/defines.h | 22 ----------------------
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/kernel/cpu/sgx/arch.h
index 7a5d24b4d1bb..dbd652be9b53 100644
--- a/arch/x86/kernel/cpu/sgx/arch.h
+++ b/arch/x86/kernel/cpu/sgx/arch.h
@@ -8,6 +8,7 @@
 #ifndef _ASM_X86_SGX_ARCH_H
 #define _ASM_X86_SGX_ARCH_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 
 #define SGX_CPUID				0x12
diff --git a/tools/testing/selftests/x86/sgx/defines.h b/tools/testing/selftests/x86/sgx/defines.h
index 1e67f2f29f42..87264f85cb9f 100644
--- a/tools/testing/selftests/x86/sgx/defines.h
+++ b/tools/testing/selftests/x86/sgx/defines.h
@@ -8,31 +8,9 @@
 
 #include <stdint.h>
 
-typedef uint8_t u8;
-typedef uint16_t u16;
-typedef uint32_t u32;
-typedef uint64_t u64;
-
 #define __aligned(x) __attribute__((__aligned__(x)))
 #define __packed __attribute__((packed))
 
-/* Derived from asm-generic/bitsperlong.h. */
-#if __x86_64__
-#define BITS_PER_LONG 64
-#else
-#define BITS_PER_LONG 32
-#endif
-#define BITS_PER_LONG_LONG 64
-
-/* Taken from linux/bits.h. */
-#define BIT(nr)	(1UL << (nr))
-#define BIT_ULL(nr) (1ULL << (nr))
-#define GENMASK(h, l) \
-	(((~0UL) - (1UL << (l)) + 1) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
-#define GENMASK_ULL(h, l) \
-	(((~0ULL) - (1ULL << (l)) + 1) & \
-	 (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))
-
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
 
-- 
2.24.1

