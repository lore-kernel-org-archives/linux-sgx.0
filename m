Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE44C433E2
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E1FE2087C
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgIDKpK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 06:45:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:43129 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729930AbgIDKpI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 06:45:08 -0400
IronPort-SDR: 1Kwc4IS2aK1DPBCLDRmXrjSHeaAzDpDyLeztbcH6Kq5ktR20clag1DbarQO4nf2Urq4gVBL3Fe
 GOfZVthAurvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="145455665"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="145455665"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 03:44:48 -0700
IronPort-SDR: j6V9h0q5JsEAI5wVIUanZvP93KyIithFJ3yOClMFTrqkymzo0GOlVAiN9aPygO3bngxleSCyHH
 +4sAyPMsr6xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="283026289"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga007.fm.intel.com with ESMTP; 04 Sep 2020 03:44:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v37 5/6] selftests/sgx: Sanity check the return value of the vDSO call
Date:   Fri,  4 Sep 2020 03:44:36 -0700
Message-Id: <20200904104437.29555-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904104437.29555-1-sean.j.christopherson@intel.com>
References: <20200904104437.29555-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Assert that the vDSO call returns 0 and that the exit reason is always
due to EEXIT.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/sgx/main.c | 35 +++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 17f36e590fbd2..158ea9e2b6d3a 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -123,6 +123,24 @@ static Elf64_Sym *vdso_symtab_get(struct vdso_symtab *symtab, const char *name)
 	return NULL;
 }
 
+int check_result(struct sgx_enclave_run *run, int ret, uint64_t result,
+		 const char *test)
+{
+	if (ret) {
+		printf("FAIL: %s() returned: %d\n", test, ret);
+		return ret;
+	} else if (run->exit_reason != SGX_SYNCHRONOUS_EXIT) {
+		printf("FAIL: %s() exit reason, expected: %u, got: %u\n",
+		       test, SGX_SYNCHRONOUS_EXIT, run->exit_reason);
+		return -EIO;
+	} else if (result != MAGIC) {
+		printf("FAIL: %s(), expected: 0x%lx, got: 0x%lx\n",
+		       test, MAGIC, result);
+		return -EIO;
+	}
+	return 0;
+}
+
 int main(int argc, char *argv[], char *envp[])
 {
 	struct sgx_enclave_run run;
@@ -132,6 +150,7 @@ int main(int argc, char *argv[], char *envp[])
 	struct encl encl;
 	unsigned int i;
 	void *addr;
+	int ret;
 
 	if (!encl_load("test_encl.elf", &encl))
 		goto err;
@@ -172,21 +191,17 @@ int main(int argc, char *argv[], char *envp[])
 
 	eenter = addr + eenter_sym->st_value;
 
-	sgx_call_vdso((void *)&MAGIC, &result, 0, EENTER, NULL, NULL, &run);
-	if (result != MAGIC) {
-		printf("FAIL: sgx_call_vdso(), expected: 0x%lx, got: 0x%lx\n",
-		       MAGIC, result);
+	ret = sgx_call_vdso((void *)&MAGIC, &result, 0, EENTER, NULL, NULL, &run);
+	if (check_result(&run, ret, result, "sgx_call_vdso"))
 		goto err;
-	}
+
 
 	/* Invoke the vDSO directly. */
 	result = 0;
-	eenter((unsigned long)&MAGIC, (unsigned long)&result, 0, EENTER, 0, 0, &run);
-	if (result != MAGIC) {
-		printf("FAIL: eenter(), expected: 0x%lx, got: 0x%lx\n",
-		       MAGIC, result);
+	ret = eenter((unsigned long)&MAGIC, (unsigned long)&result, 0, EENTER,
+		     0, 0, &run);
+	if (check_result(&run, ret, result, "eenter"))
 		goto err;
-	}
 
 	printf("SUCCESS\n");
 	encl_delete(&encl);
-- 
2.28.0

