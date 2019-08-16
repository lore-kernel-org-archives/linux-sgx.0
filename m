Return-Path: <SRS0=vX2d=WM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27AA1C3A59F
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 17:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F35F32171F
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 17:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfHPRYY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Aug 2019 13:24:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:22122 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727500AbfHPRYY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Aug 2019 13:24:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 10:24:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,394,1559545200"; 
   d="scan'208";a="261170160"
Received: from ppiatekx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.39.24])
  by orsmga001.jf.intel.com with ESMTP; 16 Aug 2019 10:24:15 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 6/6] selftests/x86: Revert SGX changes
Date:   Fri, 16 Aug 2019 20:23:47 +0300
Message-Id: <20190816172347.32561-7-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816172347.32561-1-jarkko.sakkinen@linux.intel.com>
References: <20190816172347.32561-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The SGX changes are incorrect in the makefile but the more important
reason to revert the SGX changes is that we can split the binding
to a separate commit in our main patch set.

There is a design choice to be made whether to bound the selftest by
recursing from the x86 makefile or alternatively have it added to
TARGETS (i.e. TARGET += "x86/sgx"). Thus, the change that implements
the binding must a be a separate commit.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/x86/Makefile | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index a1831406fd01..fa07d526fe39 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -1,7 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-
-SUBDIRS_64 := sgx
-
 all:
 
 include ../lib.mk
@@ -71,13 +68,6 @@ all_32: $(BINARIES_32)
 
 all_64: $(BINARIES_64)
 
-all_64: $(SUBDIRS_64)
-	@for DIR in $(SUBDIRS_64); do			\
-		BUILD_TARGET=$(OUTPUT)/$$DIR;		\
-		mkdir $$BUILD_TARGET  -p;		\
-		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;	\
-	done
-
 EXTRA_CLEAN := $(BINARIES_32) $(BINARIES_64)
 
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
-- 
2.20.1

