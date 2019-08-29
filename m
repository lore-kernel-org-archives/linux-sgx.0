Return-Path: <SRS0=j74F=WZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B22C3A59F
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 22:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D93921874
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 22:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfH2WPX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:15:23 -0400
Received: from mga04.intel.com ([192.55.52.120]:22606 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727912AbfH2WPX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Aug 2019 18:15:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 15:15:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="210701738"
Received: from friedlmi-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.54.26])
  by fmsmga002.fm.intel.com with ESMTP; 29 Aug 2019 15:15:22 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 1/2] selftests/x86: sgxsign: Do not query RSA password
Date:   Fri, 30 Aug 2019 01:15:18 +0300
Message-Id: <20190829221519.13243-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Pass NULL as the value for @cb in PEM_read_RSAPrivateKey() and remove
pem_password_cb().  According to the man page [1], when both @cb and @u
are NULL, a default callback provided by OpenSSL will be used to query
the password. Since our key is not sealed, this is dead functionality.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/x86/sgx/sgxsign.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/sgxsign.c b/tools/testing/selftests/x86/sgx/sgxsign.c
index 0b89823fc703..3d9007af40c9 100644
--- a/tools/testing/selftests/x86/sgx/sgxsign.c
+++ b/tools/testing/selftests/x86/sgx/sgxsign.c
@@ -20,8 +20,6 @@ struct sgx_sigstruct_payload {
 	struct sgx_sigstruct_body body;
 };
 
-static const char *sign_key_pass;
-
 static bool check_crypto_errors(void)
 {
 	int err;
@@ -50,18 +48,6 @@ static void exit_usage(const char *program)
 	exit(1);
 }
 
-static int pem_passwd_cb(char *buf, int size, int rwflag, void *u)
-{
-	if (!sign_key_pass)
-		return -1;
-
-	strncpy(buf, sign_key_pass, size);
-	/* no retry */
-	sign_key_pass = NULL;
-
-	return strlen(buf) >= size ? size - 1 : strlen(buf);
-}
-
 static inline const BIGNUM *get_modulus(RSA *key)
 {
 #if OPENSSL_VERSION_NUMBER < 0x10100000L
@@ -85,7 +71,7 @@ static RSA *load_sign_key(const char *path)
 		return NULL;
 	}
 	key = RSA_new();
-	if (!PEM_read_RSAPrivateKey(f, &key, pem_passwd_cb, NULL))
+	if (!PEM_read_RSAPrivateKey(f, &key, NULL, NULL))
 		return NULL;
 	fclose(f);
 
@@ -455,7 +441,6 @@ int main(int argc, char **argv)
 #endif
 	ss.body.xfrm = 3,
 
-	sign_key_pass = getenv("KBUILD_SGX_SIGN_PIN");
 	program = argv[0];
 
 	do {
-- 
2.20.1

