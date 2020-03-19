Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D9BC41620
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FAB42076C
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgCSBLi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 21:11:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:30443 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgCSBLi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 21:11:38 -0400
IronPort-SDR: aGp0qTQICgNXu6BQvP4a4CF10UiLDQD1h+DD1Y8M98rM/sIxbhoOj3tdCJjHp+W7fdJIXG5yri
 fireJ5ODJZ+Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 18:11:35 -0700
IronPort-SDR: 7okiq+RXu8UsQ1TppwEuevfqqfkt9lGnq4qHhhplZvB79Rr26gGnPblUGt5pnipzbXLXDy3xN5
 6sEN6vlnvo4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="324358712"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 18 Mar 2020 18:11:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 8/8] selftests/x86: Add selftest to invoke __vsgx_enter_enclave() from C
Date:   Wed, 18 Mar 2020 18:11:30 -0700
Message-Id: <20200319011130.8556-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319011130.8556-1-sean.j.christopherson@intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a selftest to call __vsgx_enter_enclave() from C.

Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 9b89946a976b..bf64fa857983 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -21,7 +21,7 @@
 #define PAGE_SIZE  4096
 
 static const uint64_t MAGIC = 0x1122334455667788ULL;
-void *eenter;
+vdso_sgx_enter_enclave_t eenter;
 
 struct vdso_symtab {
 	Elf64_Sym *elf_symtab;
@@ -376,5 +376,17 @@ int main(int argc, char *argv[], char *envp[])
 
 	printf("Output: 0x%lx\n", result);
 
+	printf("Input: 0x%lx\n", MAGIC);
+	result = 0;
+
+	/* Invoke the vDSO directly. */
+	eenter((unsigned long)&MAGIC, (unsigned long)&result, 0, 2, 0, 0,
+	       (void *)secs.base, &exception, NULL);
+	if (result != MAGIC) {
+		fprintf(stderr, "0x%lx != 0x%lx\n", result, MAGIC);
+		exit(1);
+	}
+	printf("Output: 0x%lx\n", result);
+
 	exit(0);
 }
-- 
2.24.1

