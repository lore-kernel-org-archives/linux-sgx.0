Return-Path: <SRS0=gA9u=YE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80C2C4360C
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8593A2190F
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbfJKAlC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 20:41:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:44340 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbfJKAlC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 20:41:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 17:41:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,282,1566889200"; 
   d="scan'208";a="198543001"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 10 Oct 2019 17:41:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 5/5] selftests/x86/sgx: Update the callbacks function parameters
Date:   Thu, 10 Oct 2019 17:40:59 -0700
Message-Id: <20191011004059.28581-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191011004059.28581-1-sean.j.christopherson@intel.com>
References: <20191011004059.28581-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Swap @ursp and @ret in the exit handler callbacks to match a recent
kernel change.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index f46e5c8fdac4..b84ffbf6e1e2 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -331,8 +331,8 @@ static void test_vdso_no_exit_handler(struct sgx_secs *secs)
 	ASSERT_EQ(exception.leaf, ENCLU_EENTER);
 }
 
-static int __used __basic_exit_handler(long rdi, long rsi, long rdx, int ret,
-				       long r8, long r9, void *tcs, long ursp,
+static int __used __basic_exit_handler(long rdi, long rsi, long rdx, long ursp,
+				       long r8, long r9, void *tcs, int ret,
 				       struct sgx_enclave_exception *e)
 {
 	TEST_ASSERT(!(r9 & 0xf), "Pre-CALL RSP not 16-byte aligned: %lx\n", r9);
@@ -355,8 +355,8 @@ static void __used basic_exit_handler_trampoline(void)
 
 static int nr_page_faults;
 
-static int mprotect_exit_handler(long rdi, long rsi, long rdx, int ret,
-				 long r8, long r9, void *tcs, long ursp,
+static int mprotect_exit_handler(long rdi, long rsi, long rdx, long ursp,
+				 long r8, long r9, void *tcs, int ret,
 				 struct sgx_enclave_exception *e)
 {
 	int prot, rc;
-- 
2.22.0

