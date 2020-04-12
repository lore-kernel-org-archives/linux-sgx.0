Return-Path: <SRS0=D2+C=54=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C019CC2BA2B
	for <linux-sgx@archiver.kernel.org>; Sun, 12 Apr 2020 14:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96FB3206E9
	for <linux-sgx@archiver.kernel.org>; Sun, 12 Apr 2020 14:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgDLOUL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 12 Apr 2020 10:20:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:38326 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgDLOUL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 12 Apr 2020 10:20:11 -0400
IronPort-SDR: 1KsKLGKbNCFfS9KguAvIrXLJUxVGkNjVP69Gs8kTqy2di6LZJ/fiMoKs2cjTv6c73rasyZlBvY
 jCmYj0YDlLzQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2020 07:20:11 -0700
IronPort-SDR: WrFdd3tDpbIx4URzIMljfL+Bp9G0Ua+OjLmYPEJUPkeVP/QvlMvO9mZPnt/VD8U6zlUoOlKSOF
 JWKDNwkDGn0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,374,1580803200"; 
   d="scan'208";a="243337719"
Received: from apresura-mobl.ger.corp.intel.com (HELO localhost) ([10.252.61.246])
  by fmsmga007.fm.intel.com with ESMTP; 12 Apr 2020 07:20:10 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nikita Sobolev <Nikita.Sobolev@synopsys.com>
Subject: [PATCH] Revert "Kernel selftests: tpm2: check for tpm support"
Date:   Sun, 12 Apr 2020 17:20:05 +0300
Message-Id: <20200412142005.71348-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This reverts commit b32694cd0724d4ceca2c62cc7c3d3a8d1ffa11fc.

The original comment was neither reviewed nor tested. Thus, this the
*only* possible action to take.

Cc: Nikita Sobolev <Nikita.Sobolev@synopsys.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/tpm2/test_smoke.sh | 13 ++-----------
 tools/testing/selftests/tpm2/test_space.sh |  9 +--------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/tpm2/test_smoke.sh b/tools/testing/selftests/tpm2/test_smoke.sh
index b630c7b5950a..8155c2ea7ccb 100755
--- a/tools/testing/selftests/tpm2/test_smoke.sh
+++ b/tools/testing/selftests/tpm2/test_smoke.sh
@@ -1,17 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
-self.flags = flags
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
-
-if [ -f /dev/tpm0 ] ; then
-	python -m unittest -v tpm2_tests.SmokeTest
-	python -m unittest -v tpm2_tests.AsyncTest
-else
-	exit $ksft_skip
-fi
+python -m unittest -v tpm2_tests.SmokeTest
+python -m unittest -v tpm2_tests.AsyncTest
 
 CLEAR_CMD=$(which tpm2_clear)
 if [ -n $CLEAR_CMD ]; then
diff --git a/tools/testing/selftests/tpm2/test_space.sh b/tools/testing/selftests/tpm2/test_space.sh
index 180b469c53b4..a6f5e346635e 100755
--- a/tools/testing/selftests/tpm2/test_space.sh
+++ b/tools/testing/selftests/tpm2/test_space.sh
@@ -1,11 +1,4 @@
 #!/bin/bash
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
-if [ -f /dev/tpmrm0 ] ; then
-	python -m unittest -v tpm2_tests.SpaceTest
-else
-	exit $ksft_skip
-fi
+python -m unittest -v tpm2_tests.SpaceTest
-- 
2.25.1

