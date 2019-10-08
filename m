Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D948C10F14
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707A2206C2
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbfJHEqS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:8175 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729585AbfJHEqS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566521"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 11/16] selftests/x86/sgx: Sanitize the types for sgx_call()'s input params
Date:   Mon,  7 Oct 2019 21:46:08 -0700
Message-Id: <20191008044613.12350-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Declare the unused registers for sgx_call() a 'long' instead of 'void *'
and add a comment to explain that @rdi and @rsi are declared as 'void *'
only because they're always used to pass pointers.  Since the registers
are pass-through values, 'long' is the more intuitive declaration.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 5b7575a948ba..b7b32cf144f4 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -303,7 +303,8 @@ void load_sigstruct(const char *path, struct sgx_sigstruct *sigstruct)
 	close(fd);
 }
 
-int sgx_call(void *rdi, void *rsi, long rdx, void *rcx, void *r8, void *r9,
+/* Declare RDI and RSI as 'void *', they're always used to pass pointers. */
+int sgx_call(void *rdi, void *rsi, long rdx, long rcx, long r8, long r9,
 	     void *tcs, struct sgx_enclave_exception *ei, void *cb);
 
 int main(int argc, char *argv[], char *envp[])
@@ -336,8 +337,8 @@ int main(int argc, char *argv[], char *envp[])
 
 	encl_build(&secs, bin, bin_size, &sigstruct);
 
-	sgx_call((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
-		 (void *)secs.base, &exception, NULL);
+	sgx_call((void *)&MAGIC, &result, 0, 0, 0, 0, (void *)secs.base,
+		 &exception, NULL);
 
 	ASSERT_EQ(result, MAGIC);
 
-- 
2.22.0

