Return-Path: <SRS0=FsvD=WO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB98C3A589
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Aug 2019 16:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C9E52087E
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Aug 2019 16:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfHRQoh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 18 Aug 2019 12:44:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:48741 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfHRQoh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 18 Aug 2019 12:44:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Aug 2019 09:44:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,401,1559545200"; 
   d="scan'208";a="179217044"
Received: from hjamouss-mobl.ger.corp.intel.com (HELO localhost) ([10.252.39.36])
  by fmsmga007.fm.intel.com with ESMTP; 18 Aug 2019 09:44:36 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 5/7] selftests/x86/sgx: Fix target in the Makefile
Date:   Sun, 18 Aug 2019 19:44:05 +0300
Message-Id: <20190818164408.31808-6-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190818164408.31808-1-jarkko.sakkinen@linux.intel.com>
References: <20190818164408.31808-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The target should be "all", not "all_64".

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/x86/sgx/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
index 0f1c50c347d7..4310a5b6ecc7 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/x86/sgx/Makefile
@@ -11,7 +11,7 @@ ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
 
 TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
-all_64: $(TEST_CUSTOM_PROGS)
+all: $(TEST_CUSTOM_PROGS)
 
 $(TEST_CUSTOM_PROGS): $(OUTPUT)/main.o $(OUTPUT)/sgx_call.o \
 		      $(OUTPUT)/encl_piggy.o
-- 
2.20.1

