Return-Path: <SRS0=2o92=2K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3A8C2D0C8
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Dec 2019 22:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 639BB206DA
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Dec 2019 22:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfLTWzE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:55:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:34039 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbfLTWzE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Dec 2019 17:55:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 14:55:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,337,1571727600"; 
   d="scan'208";a="366508439"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 20 Dec 2019 14:55:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25 1/4] selftests/x86: Fix INCLUDES definition in SGX Makefile
Date:   Fri, 20 Dec 2019 14:54:58 -0800
Message-Id: <20191220225501.23476-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220225501.23476-1-sean.j.christopherson@intel.com>
References: <20191220225501.23476-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Define INCLUDES to reference the top-level tools/include when building
SGX selftests in preparation of adding a missing linux/bits.h include
in sgx/arch.h.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
index a09ef5f965dc..f838700029e2 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/x86/sgx/Makefile
@@ -6,6 +6,7 @@ ifndef OBJCOPY
 OBJCOPY := $(CROSS_COMPILE)objcopy
 endif
 
+INCLUDES := -I$(top_srcdir)/tools/include
 HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC -z noexecstack
 ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
@@ -33,7 +34,7 @@ $(OUTPUT)/encl.ss: $(OUTPUT)/encl.bin
 	$(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
 
 $(OUTPUT)/sgxsign: sgxsign.c
-	$(CC) -o $@ $< -lcrypto
+	$(CC) $(INCLUDES) -o $@ $< -lcrypto
 
 EXTRA_CLEAN := \
 	$(OUTPUT)/encl.bin \
-- 
2.24.1

