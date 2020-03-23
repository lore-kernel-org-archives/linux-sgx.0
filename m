Return-Path: <SRS0=VWPK=5I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FA7C54FCE
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Mar 2020 03:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76A752070A
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Mar 2020 03:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgCWDq6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 22 Mar 2020 23:46:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:2455 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgCWDq6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 22 Mar 2020 23:46:58 -0400
IronPort-SDR: OD9dUkswZyH8Zk1P53Z+NCBVIHY4eg9rFvqlaYWwQst073wApsCPaHuyscgvyclwNyRNIctpAy
 eMtiyppzS9Tw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 20:46:57 -0700
IronPort-SDR: 0ayM39Y5ZsVg4b8ELB0f0ViF7VjU8mUr19A1kLAx019qJOqdsoqGgT1rvGRHkHSjqCVzsJUkGP
 qaHjIwUkUOzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,295,1580803200"; 
   d="scan'208";a="239288332"
Received: from nspindel-mobl.ger.corp.intel.com (HELO localhost) ([10.214.214.10])
  by fmsmga008.fm.intel.com with ESMTP; 22 Mar 2020 20:46:54 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 5/5] selftests/sgx: Load encl.elf directly in the test program
Date:   Mon, 23 Mar 2020 05:46:34 +0200
Message-Id: <20200323034634.4157-5-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323034634.4157-1-jarkko.sakkinen@linux.intel.com>
References: <20200323034634.4157-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

To make test program more realistic and robust, load the test enclave
directly from encl.elf.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/sgx/Makefile  | 11 +++---
 tools/testing/selftests/sgx/defines.h |  1 +
 tools/testing/selftests/sgx/main.c    | 48 ++++++++++++++++++++-------
 3 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
index d9c3b3a1983b..48a2cda6c34d 100644
--- a/tools/testing/selftests/sgx/Makefile
+++ b/tools/testing/selftests/sgx/Makefile
@@ -16,7 +16,7 @@ HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC -z noexecstack
 ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
 
-TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx $(OUTPUT)/encl.bin
+TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx $(OUTPUT)/encl.elf
 
 ifeq ($(CAN_BUILD_X86_64), 1)
 all: $(TEST_CUSTOM_PROGS)
@@ -34,16 +34,13 @@ $(OUTPUT)/sign.o: sign.c
 $(OUTPUT)/call.o: call.S
 	$(CC) $(HOST_CFLAGS) -c $< -o $@
 
-$(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf
-	$(OBJCOPY) -O binary $< $@
-
 $(OUTPUT)/encl.elf: encl.lds encl.c encl_bootstrap.S
 	$(CC) $(ENCL_CFLAGS) -T $^ -o $@
 
 EXTRA_CLEAN := \
-	$(OUTPUT)/encl.bin \
 	$(OUTPUT)/encl.elf \
-	$(OUTPUT)/sgx_call.o \
+	$(OUTPUT)/call.o \
+	$(OUTPUT)/main.o \
+	$(OUTPUT)/sign.o \
 	$(OUTPUT)/test_sgx \
 	$(OUTPUT)/test_sgx.o \
-
diff --git a/tools/testing/selftests/sgx/defines.h b/tools/testing/selftests/sgx/defines.h
index 8f4d17cf8cee..1802cace7527 100644
--- a/tools/testing/selftests/sgx/defines.h
+++ b/tools/testing/selftests/sgx/defines.h
@@ -9,6 +9,7 @@
 #include <stdint.h>
 
 #define PAGE_SIZE 4096
+#define PAGE_MASK (~(PAGE_SIZE - 1))
 
 #define __aligned(x) __attribute__((__aligned__(x)))
 #define __packed __attribute__((packed))
diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index a78e64159313..a0a37d85714b 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -223,11 +223,6 @@ bool get_file_size(const char *path, off_t *bin_size)
 		return false;
 	}
 
-	if (!sb.st_size || sb.st_size & 0xfff) {
-		fprintf(stderr, "Invalid blob size %lu\n", sb.st_size);
-		return false;
-	}
-
 	*bin_size = sb.st_size;
 	return true;
 }
@@ -291,12 +286,17 @@ int main(int argc, char *argv[], char *envp[])
 	struct sgx_enclave_exception exception;
 	struct sgx_sigstruct sigstruct;
 	struct sgx_enclave_init ioc;
+	Elf64_Phdr *phdr, *phdr_tbl;
+	unsigned long start_offset;
 	struct vdso_symtab symtab;
+	unsigned long encl_size;
 	Elf64_Sym *eenter_sym;
 	uint64_t result = 0;
 	struct context ctx;
+	Elf64_Ehdr *ehdr;
 	void *addr;
 	int ret;
+	int i;
 
 	context_init(&ctx);
 
@@ -306,25 +306,49 @@ int main(int argc, char *argv[], char *envp[])
 		goto err;
 	}
 
-	if (!encl_data_map("encl.bin", &ctx.bin, &ctx.bin_size))
+	if (!encl_data_map("encl.elf", &ctx.bin, &ctx.bin_size))
 		goto err;
 
-	if (!encl_create(ctx.encl_fd, ctx.bin_size, &ctx.secs))
+	ehdr = ctx.bin;
+	phdr_tbl = ctx.bin + ehdr->e_phoff;
+	start_offset = 0;
+	encl_size = 0;
+
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		unsigned long offset, size;
+
+		phdr = &phdr_tbl[i];
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		offset = phdr->p_offset & PAGE_MASK;
+		if (!start_offset)
+			start_offset = offset;
+
+		size = (offset - start_offset + phdr->p_filesz +
+			PAGE_SIZE - 1) & PAGE_MASK;
+		if (size > encl_size)
+			encl_size = size;
+	}
+
+	if (!encl_create(ctx.encl_fd, encl_size, &ctx.secs))
 		goto err;
 
 	/* TCS */
-	if (!encl_build_segment(ctx.encl_fd, &ctx.secs, ctx.bin, 0, PAGE_SIZE,
-				SGX_SECINFO_TCS, PROT_READ | PROT_WRITE))
+	if (!encl_build_segment(ctx.encl_fd, &ctx.secs, ctx.bin + start_offset,
+				0, PAGE_SIZE, SGX_SECINFO_TCS,
+				PROT_READ | PROT_WRITE))
 		goto err;
 
-	if (!encl_build_segment(ctx.encl_fd, &ctx.secs, ctx.bin, PAGE_SIZE,
-				ctx.bin_size - PAGE_SIZE,
+	if (!encl_build_segment(ctx.encl_fd, &ctx.secs, ctx.bin + start_offset,
+				PAGE_SIZE, encl_size - PAGE_SIZE,
 				SGX_SECINFO_REG | SGX_SECINFO_R |
 				SGX_SECINFO_W | SGX_SECINFO_X,
 				PROT_READ | PROT_WRITE | PROT_EXEC))
 		goto err;
 
-	if (!encl_create_sigstruct(ctx.bin, ctx.bin_size, &sigstruct))
+	if (!encl_create_sigstruct(ctx.bin + start_offset, encl_size,
+				   &sigstruct))
 		goto err;
 
 	ioc.sigstruct = (uint64_t)&sigstruct;
-- 
2.25.1

