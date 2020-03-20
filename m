Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E8AC4332D
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 06:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D12F20739
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 06:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgCTGHt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Mar 2020 02:07:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:47290 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgCTGHt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Mar 2020 02:07:49 -0400
IronPort-SDR: M+rENNNlf90TTwcNElZh7mm5zJXlh/qz1dHj1RNPeG6F25P6R1sl79waYHAk792Agamz1Aj3lC
 JAk9ge8zK7tw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 23:07:47 -0700
IronPort-SDR: C6hFIkm0zCUM6yyqcwv1d+W5k9PuLTC8+y8QjekKQn69UbnR4lvOr8mbD94H0RPtGMok2SuMG4
 j5zFxELCyU2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="446554674"
Received: from anakash-mobl2.ger.corp.intel.com (HELO localhost) ([10.251.183.74])
  by fmsmga006.fm.intel.com with ESMTP; 19 Mar 2020 23:07:45 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] selftests/x86/sgx: Merge test_sgx and sgxsign
Date:   Fri, 20 Mar 2020 08:07:38 +0200
Message-Id: <20200320060738.2183396-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Sign enclaves on fly in test_sgx instead of using a precompiled
sigstruct. This simplifies both the build process and the test
program.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/x86/sgx/.gitignore    |   2 -
 tools/testing/selftests/x86/sgx/Makefile      |  21 +-
 .../selftests/x86/sgx/{sgx_call.S => call.S}  |   0
 tools/testing/selftests/x86/sgx/defines.h     |   2 +
 tools/testing/selftests/x86/sgx/main.c        |  27 +--
 .../selftests/x86/sgx/{sgx_call.h => main.h}  |   8 +-
 .../selftests/x86/sgx/{sgxsign.c => sign.c}   | 184 ++++++------------
 7 files changed, 72 insertions(+), 172 deletions(-)
 rename tools/testing/selftests/x86/sgx/{sgx_call.S => call.S} (100%)
 rename tools/testing/selftests/x86/sgx/{sgx_call.h => main.h} (60%)
 rename tools/testing/selftests/x86/sgx/{sgxsign.c => sign.c} (66%)

diff --git a/tools/testing/selftests/x86/sgx/.gitignore b/tools/testing/selftests/x86/sgx/.gitignore
index 98eb2d439606..828490670951 100644
--- a/tools/testing/selftests/x86/sgx/.gitignore
+++ b/tools/testing/selftests/x86/sgx/.gitignore
@@ -1,3 +1 @@
-encl.ss
-sgxsign
 test_sgx
diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
index ff0136310c2b..789ebbbfddcb 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/x86/sgx/Makefile
@@ -11,37 +11,32 @@ HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC -z noexecstack
 ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
 
-TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
+TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx $(OUTPUT)/encl.bin
 
 all: $(TEST_CUSTOM_PROGS)
 
-$(OUTPUT)/test_sgx: $(OUTPUT)/main.o $(OUTPUT)/sgx_call.o
-	$(CC) $(HOST_CFLAGS) -o $@ $^
+$(OUTPUT)/test_sgx: $(OUTPUT)/main.o $(OUTPUT)/sign.o $(OUTPUT)/call.o
+	$(CC) $(HOST_CFLAGS) -o $@ $^ -lcrypto
 
 $(OUTPUT)/main.o: main.c
 	$(CC) $(HOST_CFLAGS) -c $< -o $@
 
-$(OUTPUT)/sgx_call.o: sgx_call.S
+$(OUTPUT)/sign.o: sign.c
 	$(CC) $(HOST_CFLAGS) -c $< -o $@
 
-$(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf $(OUTPUT)/sgxsign
+$(OUTPUT)/call.o: call.S
+	$(CC) $(HOST_CFLAGS) -c $< -o $@
+
+$(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf
 	$(OBJCOPY) -O binary $< $@
 
 $(OUTPUT)/encl.elf: encl.lds encl.c encl_bootstrap.S
 	$(CC) $(ENCL_CFLAGS) -T $^ -o $@
 
-$(OUTPUT)/encl.ss: $(OUTPUT)/encl.bin
-	$(OUTPUT)/sgxsign $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
-
-$(OUTPUT)/sgxsign: sgxsign.c
-	$(CC) $(INCLUDES) -o $@ $< -lcrypto
-
 EXTRA_CLEAN := \
 	$(OUTPUT)/encl.bin \
 	$(OUTPUT)/encl.elf \
-	$(OUTPUT)/encl.ss \
 	$(OUTPUT)/sgx_call.o \
-	$(OUTPUT)/sgxsign \
 	$(OUTPUT)/test_sgx \
 	$(OUTPUT)/test_sgx.o \
 
diff --git a/tools/testing/selftests/x86/sgx/sgx_call.S b/tools/testing/selftests/x86/sgx/call.S
similarity index 100%
rename from tools/testing/selftests/x86/sgx/sgx_call.S
rename to tools/testing/selftests/x86/sgx/call.S
diff --git a/tools/testing/selftests/x86/sgx/defines.h b/tools/testing/selftests/x86/sgx/defines.h
index 87264f85cb9f..0f91175088f6 100644
--- a/tools/testing/selftests/x86/sgx/defines.h
+++ b/tools/testing/selftests/x86/sgx/defines.h
@@ -8,6 +8,8 @@
 
 #include <stdint.h>
 
+#define PAGE_SIZE 4096
+
 #define __aligned(x) __attribute__((__aligned__(x)))
 #define __packed __attribute__((packed))
 
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 5a6f5c0656c1..af16dd6f4b92 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -16,9 +16,7 @@
 #include <sys/time.h>
 #include <sys/types.h>
 #include "defines.h"
-#include "sgx_call.h"
-
-#define PAGE_SIZE  4096
+#include "main.h"
 
 static const uint64_t MAGIC = 0x1122334455667788ULL;
 void *eenter;
@@ -298,27 +296,6 @@ bool encl_data_map(const char *path, void **bin, off_t *bin_size)
 	return false;
 }
 
-bool load_sigstruct(const char *path, void *sigstruct)
-{
-	int fd;
-
-	fd = open(path, O_RDONLY);
-	if (fd == -1)  {
-		fprintf(stderr, "open() %s failed, errno=%d.\n", path, errno);
-		return false;
-	}
-
-	if (read(fd, sigstruct, sizeof(struct sgx_sigstruct)) !=
-	    sizeof(struct sgx_sigstruct)) {
-		fprintf(stderr, "read() %s failed, errno=%d.\n", path, errno);
-		close(fd);
-		return false;
-	}
-
-	close(fd);
-	return true;
-}
-
 int main(int argc, char *argv[], char *envp[])
 {
 	struct sgx_enclave_exception exception;
@@ -334,7 +311,7 @@ int main(int argc, char *argv[], char *envp[])
 	if (!encl_data_map("encl.bin", &bin, &bin_size))
 		exit(1);
 
-	if (!load_sigstruct("encl.ss", &sigstruct))
+	if (!encl_create_sigstruct(bin, bin_size, &sigstruct))
 		exit(1);
 
 	if (!encl_build(&secs, bin, bin_size, &sigstruct))
diff --git a/tools/testing/selftests/x86/sgx/sgx_call.h b/tools/testing/selftests/x86/sgx/main.h
similarity index 60%
rename from tools/testing/selftests/x86/sgx/sgx_call.h
rename to tools/testing/selftests/x86/sgx/main.h
index 133f7f18c3df..5de6cd492adc 100644
--- a/tools/testing/selftests/x86/sgx/sgx_call.h
+++ b/tools/testing/selftests/x86/sgx/main.h
@@ -3,10 +3,12 @@
  * Copyright(c) 2016-19 Intel Corporation.
  */
 
-#ifndef SGX_CALL_H
-#define SGX_CALL_H
+#ifndef MAIN_H
+#define MAIN_H
 
+bool encl_create_sigstruct(const void *bin, unsigned long size,
+			   struct sgx_sigstruct *sigstruct);
 int sgx_call_vdso(void *rdi, void *rsi, long rdx, void *rcx, void *r8, void *r9,
 		  void *tcs, struct sgx_enclave_exception *ei, void *cb);
 
-#endif /* SGX_CALL_H */
+#endif /* MAIN_H */
diff --git a/tools/testing/selftests/x86/sgx/sgxsign.c b/tools/testing/selftests/x86/sgx/sign.c
similarity index 66%
rename from tools/testing/selftests/x86/sgx/sgxsign.c
rename to tools/testing/selftests/x86/sgx/sign.c
index 97771a2e8cb0..459bf2ddf106 100644
--- a/tools/testing/selftests/x86/sgx/sgxsign.c
+++ b/tools/testing/selftests/x86/sgx/sign.c
@@ -41,13 +41,6 @@ static bool check_crypto_errors(void)
 	return had_errors;
 }
 
-static void exit_usage(const char *program)
-{
-	fprintf(stderr,
-		"Usage: %s/sign-le <key> <enclave> <sigstruct>\n", program);
-	exit(1);
-}
-
 static inline const BIGNUM *get_modulus(RSA *key)
 {
 #if OPENSSL_VERSION_NUMBER < 0x10100000L
@@ -192,7 +185,8 @@ struct mreextend {
 	uint8_t reserved[48];
 } __attribute__((__packed__));
 
-static bool mrenclave_eextend(EVP_MD_CTX *ctx, uint64_t offset, uint8_t *data)
+static bool mrenclave_eextend(EVP_MD_CTX *ctx, uint64_t offset,
+			      const uint8_t *data)
 {
 	struct mreextend mreextend;
 	int i;
@@ -221,52 +215,26 @@ static bool mrenclave_eextend(EVP_MD_CTX *ctx, uint64_t offset, uint8_t *data)
 	return true;
 }
 
-/**
- * measure_encl - measure enclave
- * @path: path to the enclave
- * @mrenclave: measurement
- *
- * Calculates MRENCLAVE. Assumes that the very first page is a TCS page and
- * following pages are regular pages. Does not measure the contents of the
- * enclave as the signing tool is used at the moment only for the launch
- * enclave, which is pass-through (everything gets a token).
- */
-static bool measure_encl(const char *path, uint8_t *mrenclave)
+static bool encl_measure(const void *bin, unsigned long size,
+			 uint8_t *mrenclave)
 {
-	FILE *file;
-	struct stat sb;
 	EVP_MD_CTX *ctx;
-	uint64_t flags;
 	uint64_t offset;
-	uint8_t data[0x1000];
-	int rc;
+	uint64_t flags;
 
 	ctx = EVP_MD_CTX_create();
 	if (!ctx)
-		return false;
-
-	file = fopen(path, "rb");
-	if (!file) {
-		perror("fopen");
-		EVP_MD_CTX_destroy(ctx);
-		return false;
-	}
-
-	rc = stat(path, &sb);
-	if (rc) {
-		perror("stat");
-		goto out;
-	}
+		goto err;
 
-	if (!sb.st_size || sb.st_size & 0xfff) {
-		fprintf(stderr, "Invalid blob size %lu\n", sb.st_size);
-		goto out;
+	if (!size || size & 0xfff) {
+		fprintf(stderr, "Invalid blob size %lu\n", size);
+		goto err;
 	}
 
-	if (!mrenclave_ecreate(ctx, sb.st_size))
-		goto out;
+	if (!mrenclave_ecreate(ctx, size))
+		goto err;
 
-	for (offset = 0; offset < sb.st_size; offset += 0x1000) {
+	for (offset = 0; offset < size; offset += PAGE_SIZE) {
 		if (!offset)
 			flags = SGX_SECINFO_TCS;
 		else
@@ -274,42 +242,25 @@ static bool measure_encl(const char *path, uint8_t *mrenclave)
 				SGX_SECINFO_W | SGX_SECINFO_X;
 
 		if (!mrenclave_eadd(ctx, offset, flags))
-			goto out;
+			goto err;
 
-		rc = fread(data, 1, 0x1000, file);
-		if (!rc)
-			break;
-		if (rc < 0x1000)
-			goto out;
-
-		if (!mrenclave_eextend(ctx, offset, data))
-			goto out;
+		if (!mrenclave_eextend(ctx, offset, bin + offset))
+			goto err;
 	}
 
 	if (!mrenclave_commit(ctx, mrenclave))
-		goto out;
+		goto err;
 
-	fclose(file);
 	EVP_MD_CTX_destroy(ctx);
 	return true;
-out:
-	fclose(file);
+
+err:
 	EVP_MD_CTX_destroy(ctx);
 	return false;
 }
 
-/**
- * sign_encl - sign enclave
- * @sigstruct: pointer to SIGSTRUCT
- * @key: 3072-bit RSA key
- * @signature: byte array for the signature
- *
- * Calculates EMSA-PKCSv1.5 signature for the given SIGSTRUCT. The result is
- * stored in big-endian format so that it can be further passed to OpenSSL
- * libcrypto functions.
- */
-static bool sign_encl(const struct sgx_sigstruct *sigstruct, RSA *key,
-		      uint8_t *signature)
+static bool encl_sign_sigstruct(const struct sgx_sigstruct *sigstruct,
+				RSA *key, uint8_t *signature)
 {
 	struct sgx_sigstruct_payload payload;
 	unsigned int siglen;
@@ -409,78 +360,53 @@ static bool calc_q1q2(const uint8_t *s, const uint8_t *m, uint8_t *q1,
 	return false;
 }
 
-static bool save_sigstruct(const struct sgx_sigstruct *sigstruct,
-			   const char *path)
-{
-	FILE *f = fopen(path, "wb");
-
-	if (!f) {
-		fprintf(stderr, "Unable to open %s\n", path);
-		return false;
-	}
-
-	fwrite(sigstruct, sizeof(*sigstruct), 1, f);
-	fclose(f);
-	return true;
-}
-
-int main(int argc, char **argv)
+bool encl_create_sigstruct(const void *bin, unsigned long size,
+			   struct sgx_sigstruct *sigstruct)
 {
 	uint64_t header1[2] = {0x000000E100000006, 0x0000000000010000};
 	uint64_t header2[2] = {0x0000006000000101, 0x0000000100000060};
-	struct sgx_sigstruct ss;
-	const char *program;
-	RSA *sign_key;
-	int opt;
-
-	memset(&ss, 0, sizeof(ss));
-	ss.header.header1[0] = header1[0];
-	ss.header.header1[1] = header1[1];
-	ss.header.header2[0] = header2[0];
-	ss.header.header2[1] = header2[1];
-	ss.exponent = 3;
-
-#ifndef CONFIG_EINITTOKENKEY
-	ss.body.attributes = SGX_ATTR_MODE64BIT;
-#else
-	ss.body.attributes = SGX_ATTR_MODE64BIT | SGX_ATTR_EINITTOKENKEY;
-#endif
-	ss.body.xfrm = 3,
+	RSA *key = NULL;
 
-	program = argv[0];
+	memset(sigstruct, 0, sizeof(*sigstruct));
 
-	if (argc < 3)
-		exit_usage(program);
+	sigstruct->header.header1[0] = header1[0];
+	sigstruct->header.header1[1] = header1[1];
+	sigstruct->header.header2[0] = header2[0];
+	sigstruct->header.header2[1] = header2[1];
+	sigstruct->exponent = 3;
+	sigstruct->body.attributes = SGX_ATTR_MODE64BIT;
+	sigstruct->body.xfrm = 3;
 
-	/* sanity check only */
+	/* sanity check */
 	if (check_crypto_errors())
-		exit(1);
+		goto err;
 
-	sign_key = gen_sign_key();
-	if (!sign_key)
-		goto out;
+	key = gen_sign_key();
+	if (!key)
+		goto err;
 
-	BN_bn2bin(get_modulus(sign_key), ss.modulus);
+	BN_bn2bin(get_modulus(key), sigstruct->modulus);
 
-	if (!measure_encl(argv[1], ss.body.mrenclave))
-		goto out;
+	if (!encl_measure(bin, size, sigstruct->body.mrenclave))
+		goto err;
 
-	if (!sign_encl(&ss, sign_key, ss.signature))
-		goto out;
+	if (!encl_sign_sigstruct(sigstruct, key, sigstruct->signature))
+		goto err;
 
-	if (!calc_q1q2(ss.signature, ss.modulus, ss.q1, ss.q2))
-		goto out;
+	if (!calc_q1q2(sigstruct->signature, sigstruct->modulus, sigstruct->q1,
+		       sigstruct->q2))
+		goto err;
 
-	/* convert to little endian */
-	reverse_bytes(ss.signature, SGX_MODULUS_SIZE);
-	reverse_bytes(ss.modulus, SGX_MODULUS_SIZE);
-	reverse_bytes(ss.q1, SGX_MODULUS_SIZE);
-	reverse_bytes(ss.q2, SGX_MODULUS_SIZE);
+	/* BE -> LE */
+	reverse_bytes(sigstruct->signature, SGX_MODULUS_SIZE);
+	reverse_bytes(sigstruct->modulus, SGX_MODULUS_SIZE);
+	reverse_bytes(sigstruct->q1, SGX_MODULUS_SIZE);
+	reverse_bytes(sigstruct->q2, SGX_MODULUS_SIZE);
 
-	if (!save_sigstruct(&ss, argv[2]))
-		goto out;
-	exit(0);
-out:
-	check_crypto_errors();
-	exit(1);
+	RSA_free(key);
+	return true;
+
+err:
+	RSA_free(key);
+	return false;
 }
-- 
2.25.1

