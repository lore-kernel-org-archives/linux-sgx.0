Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F38C4332B
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 02:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B2E220768
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 02:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgCSCdN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 22:33:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:27174 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgCSCdM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 22:33:12 -0400
IronPort-SDR: ikgIoSe4jsTwtGwcL8qq6eMDFOY0k/64hLCB5iakKE74GUaU9fEe/2OqI30puFT4FxnrgXLT6p
 UvUSbC7suQaA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 19:33:11 -0700
IronPort-SDR: 4N7pNrgasTarlCfr4qrPRmmdBY1syaNhqrnAuJLkpi9oe5jSA949fSMOI874K78uG0h8568kYt
 XggjZXBarFsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="236812063"
Received: from cblaim-mobl.ger.corp.intel.com (HELO localhost) ([10.252.54.64])
  by fmsmga007.fm.intel.com with ESMTP; 18 Mar 2020 19:33:08 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] selftests/x86: Generate an RSA key on fly
Date:   Thu, 19 Mar 2020 04:33:06 +0200
Message-Id: <20200319023306.6875-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Modify the signing tool to generate an RSA key on fly because that is
require for the selftest.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
Tested only for compilation.
 tools/testing/selftests/x86/sgx/Makefile      |  2 +-
 tools/testing/selftests/x86/sgx/sgxsign.c     | 55 ++++++++-----------
 .../testing/selftests/x86/sgx/signing_key.pem | 39 -------------
 3 files changed, 25 insertions(+), 71 deletions(-)
 delete mode 100644 tools/testing/selftests/x86/sgx/signing_key.pem

diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
index f838700029e2..ff0136310c2b 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/x86/sgx/Makefile
@@ -31,7 +31,7 @@ $(OUTPUT)/encl.elf: encl.lds encl.c encl_bootstrap.S
 	$(CC) $(ENCL_CFLAGS) -T $^ -o $@
 
 $(OUTPUT)/encl.ss: $(OUTPUT)/encl.bin
-	$(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
+	$(OUTPUT)/sgxsign $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
 
 $(OUTPUT)/sgxsign: sgxsign.c
 	$(CC) $(INCLUDES) -o $@ $< -lcrypto
diff --git a/tools/testing/selftests/x86/sgx/sgxsign.c b/tools/testing/selftests/x86/sgx/sgxsign.c
index 3d9007af40c9..8d62437186ed 100644
--- a/tools/testing/selftests/x86/sgx/sgxsign.c
+++ b/tools/testing/selftests/x86/sgx/sgxsign.c
@@ -60,29 +60,35 @@ static inline const BIGNUM *get_modulus(RSA *key)
 #endif
 }
 
-static RSA *load_sign_key(const char *path)
+static RSA *gen_sign_key(void)
 {
-	FILE *f;
+	BIGNUM *e;
 	RSA *key;
+	int ret;
 
-	f = fopen(path, "rb");
-	if (!f) {
-		fprintf(stderr, "Unable to open %s\n", path);
-		return NULL;
-	}
+	e = BN_new();
 	key = RSA_new();
-	if (!PEM_read_RSAPrivateKey(f, &key, NULL, NULL))
-		return NULL;
-	fclose(f);
 
-	if (BN_num_bytes(get_modulus(key)) != SGX_MODULUS_SIZE) {
-		fprintf(stderr, "Invalid key size %d\n",
-			BN_num_bytes(get_modulus(key)));
-		RSA_free(key);
-		return NULL;
-	}
+	if (!e || !key)
+		goto err;
+
+	ret = BN_set_word(e, RSA_F4);
+	if (ret != 1)
+		goto err;
+
+	ret = RSA_generate_key_ex(key, 3072, e, NULL);
+	if (ret != 1)
+		goto err;
+
+	BN_free(e);
 
 	return key;
+
+err:
+	RSA_free(key);
+	BN_free(e);
+
+	return NULL;
 }
 
 static void reverse_bytes(void *data, int length)
@@ -424,8 +430,8 @@ int main(int argc, char **argv)
 	uint64_t header2[2] = {0x0000006000000101, 0x0000000100000060};
 	struct sgx_sigstruct ss;
 	const char *program;
-	int opt;
 	RSA *sign_key;
+	int opt;
 
 	memset(&ss, 0, sizeof(ss));
 	ss.header.header1[0] = header1[0];
@@ -443,19 +449,6 @@ int main(int argc, char **argv)
 
 	program = argv[0];
 
-	do {
-		opt = getopt(argc, argv, "");
-		switch (opt) {
-		case -1:
-			break;
-		default:
-			exit_usage(program);
-		}
-	} while (opt != -1);
-
-	argc -= optind;
-	argv += optind;
-
 	if (argc < 3)
 		exit_usage(program);
 
@@ -463,7 +456,7 @@ int main(int argc, char **argv)
 	if (check_crypto_errors())
 		exit(1);
 
-	sign_key = load_sign_key(argv[0]);
+	sign_key = gen_sign_key();
 	if (!sign_key)
 		goto out;
 
diff --git a/tools/testing/selftests/x86/sgx/signing_key.pem b/tools/testing/selftests/x86/sgx/signing_key.pem
deleted file mode 100644
index d76f21f19187..000000000000
--- a/tools/testing/selftests/x86/sgx/signing_key.pem
+++ /dev/null
@@ -1,39 +0,0 @@
------BEGIN RSA PRIVATE KEY-----
-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
------END RSA PRIVATE KEY-----
-- 
2.25.1

