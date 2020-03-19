Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30BCC43333
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88B512076C
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCSBLh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 21:11:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:30444 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgCSBLh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 21:11:37 -0400
IronPort-SDR: Cy0608T70gX7jlXdSrT7/rqLLS5ZcTeToRfs8CzsIJ/gafc5uhoBMMHOum79AE8yB0BqLjp3CI
 wY1n6+usieAA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 18:11:35 -0700
IronPort-SDR: HxpzM6pecHEK0M+u7tmK3mfqMdkAQPx2Ofs+4GExzE4msQ+lfAZWngzUlYT+AkhIr7FT7mi0Ag
 KmZlcWbvxK/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="324358703"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 18 Mar 2020 18:11:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 5/8] selftests/x86: sgx: Zero out @result before invoking vDSO sub-test
Date:   Wed, 18 Mar 2020 18:11:27 -0700
Message-Id: <20200319011130.8556-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319011130.8556-1-sean.j.christopherson@intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Zero out @result before running the vDSO sub-test, otherwise the vDSO
could fail completely and the selftest would be none the wiser, e.g. it
doesn't explicitly check the return value.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index d97cc3cf0093..c9c37d2bbec8 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -366,6 +366,7 @@ int main(int argc, char *argv[], char *envp[])
 
 	printf("Input: 0x%lx\n", MAGIC);
 
+	result = 0;
 	sgx_call_vdso((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
 		      (void *)secs.base, &exception, NULL);
 	if (result != MAGIC) {
-- 
2.24.1

