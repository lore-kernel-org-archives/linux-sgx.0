Return-Path: <SRS0=BaFh=XH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67024C4CEC6
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Sep 2019 19:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 421B920856
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Sep 2019 19:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfILTrf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Sep 2019 15:47:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:22341 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbfILTrf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Sep 2019 15:47:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 12:47:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="336682868"
Received: from dscaswel-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.53.44])
  by orsmga004.jf.intel.com with ESMTP; 12 Sep 2019 12:47:31 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RESEND 01/11] selftest/x86/sgx: Remove encl_piggy.h
Date:   Thu, 12 Sep 2019 20:47:10 +0100
Message-Id: <20190912194720.7107-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190912194720.7107-1-jarkko.sakkinen@linux.intel.com>
References: <20190912194720.7107-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When encl.bin and encl.ss where detached from the test_sgx ELF binary this
file should have been removed. Take care of that.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/x86/sgx/encl_piggy.h | 14 --------------
 tools/testing/selftests/x86/sgx/main.c       |  1 -
 2 files changed, 15 deletions(-)
 delete mode 100644 tools/testing/selftests/x86/sgx/encl_piggy.h

diff --git a/tools/testing/selftests/x86/sgx/encl_piggy.h b/tools/testing/selftests/x86/sgx/encl_piggy.h
deleted file mode 100644
index ee8224f8cc8d..000000000000
--- a/tools/testing/selftests/x86/sgx/encl_piggy.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
-/*
- * Copyright(c) 2016-18 Intel Corporation.
- */
-
-#ifndef ENCL_PIGGY_H
-#define ENCL_PIGGY_H
-
-extern unsigned char encl_bin[];
-extern unsigned char encl_bin_end[];
-extern unsigned char encl_ss[];
-extern unsigned char encl_ss_end[];
-
-#endif /* ENCL_PIGGY_H */
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 2160bcd0ccd9..f78ff458b0dd 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -15,7 +15,6 @@
 #include <sys/stat.h>
 #include <sys/time.h>
 #include <sys/types.h>
-#include "encl_piggy.h"
 #include "defines.h"
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
-- 
2.20.1

