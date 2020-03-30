Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF0DC2D0F2
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 18:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C821A20780
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 18:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgC3SIP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 14:08:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:35626 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbgC3SIP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 14:08:15 -0400
IronPort-SDR: 3fz1VLfKIOoDZxdOk9QVE1J9hCJR/6ZBvnPrT/WxZl+TNx8Bt9OzgCsPmm+pOcEMiE0/hSGn9g
 /KDu/mqOrMrg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 11:08:14 -0700
IronPort-SDR: lDQVM8SlBywNH5psP9jS5lwjKbvI5wgGYoMXsE+akxTMEnVhqjn6NkzQM8zijkTKRNuWNeycNz
 NbUGeHzeDUgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="283721719"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 30 Mar 2020 11:08:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 v2 5/5] selftests/sgx: Add selftest to invoke __vsgx_enter_enclave() from C
Date:   Mon, 30 Mar 2020 11:08:11 -0700
Message-Id: <20200330180811.31381-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330180811.31381-1-sean.j.christopherson@intel.com>
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
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
 tools/testing/selftests/sgx/main.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index f6bb40f22884..5394b2f6af8e 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -19,7 +19,7 @@
 #include "main.h"
 
 static const uint64_t MAGIC = 0x1122334455667788ULL;
-void *eenter;
+vdso_sgx_enter_enclave_t eenter;
 
 struct vdso_symtab {
 	Elf64_Sym *elf_symtab;
@@ -173,15 +173,27 @@ int main(int argc, char *argv[], char *envp[])
 
 	sgx_call_vdso((void *)&MAGIC, &result, 0, EENTER, NULL, NULL,
 		      (void *)encl.encl_base, &exception, NULL);
-	if (result != MAGIC)
+	if (result != MAGIC) {
+		printf("FAIL: sgx_call_vdso(), expected: 0x%lx, got: 0x%lx\n",
+		       MAGIC, result);
 		goto err;
+	}
+
+	/* Invoke the vDSO directly. */
+	result = 0;
+	eenter((unsigned long)&MAGIC, (unsigned long)&result, 0, EENTER, 0, 0,
+	       (void *)encl.encl_base, &exception, NULL);
+	if (result != MAGIC) {
+		printf("FAIL: eenter(), expected: 0x%lx, got: 0x%lx\n",
+		       MAGIC, result);
+		goto err;
+	}
 
 	printf("SUCCESS\n");
 	encl_delete(&encl);
 	exit(0);
 
 err:
-	printf("FAILURE\n");
 	encl_delete(&encl);
 	exit(1);
 }
-- 
2.24.1

