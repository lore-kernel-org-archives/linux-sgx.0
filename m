Return-Path: <SRS0=j74F=WZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D259C3A59F
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 22:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F10E12166E
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 22:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfH2WJh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:09:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:17298 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbfH2WJh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Aug 2019 18:09:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 15:09:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="210700449"
Received: from friedlmi-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.54.26])
  by fmsmga002.fm.intel.com with ESMTP; 29 Aug 2019 15:09:36 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 2/2] selftests/x86/sgx: Read encl.bin and encl.ss from the file system
Date:   Fri, 30 Aug 2019 01:09:24 +0300
Message-Id: <20190829220924.12692-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829220924.12692-1-jarkko.sakkinen@linux.intel.com>
References: <20190829220924.12692-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Do not link encl.bin and encl.ss to the test application binary. Linking
data files directly to the ELF are legacy from in-kernel LE
implementation.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/x86/sgx/Makefile     |  14 +--
 tools/testing/selftests/x86/sgx/encl_piggy.S |  19 ----
 tools/testing/selftests/x86/sgx/main.c       | 101 +++++++++++++++----
 3 files changed, 88 insertions(+), 46 deletions(-)
 delete mode 100644 tools/testing/selftests/x86/sgx/encl_piggy.S

diff --git a/tools/testing/selftests/x86/sgx/Makefile b/tools/testing/selftests/x86/sgx/Makefile
index 4310a5b6ecc7..44805ed43413 100644
--- a/tools/testing/selftests/x86/sgx/Makefile
+++ b/tools/testing/selftests/x86/sgx/Makefile
@@ -10,11 +10,11 @@ HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC -z noexecstack
 ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
 
-TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
+TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx $(OUTPUT)/encl.bin
+
 all: $(TEST_CUSTOM_PROGS)
 
-$(TEST_CUSTOM_PROGS): $(OUTPUT)/main.o $(OUTPUT)/sgx_call.o \
-		      $(OUTPUT)/encl_piggy.o
+$(OUTPUT)/test_sgx: $(OUTPUT)/main.o $(OUTPUT)/sgx_call.o
 	$(CC) $(HOST_CFLAGS) -o $@ $^
 
 $(OUTPUT)/main.o: main.c
@@ -23,24 +23,18 @@ $(OUTPUT)/main.o: main.c
 $(OUTPUT)/sgx_call.o: sgx_call.S
 	$(CC) $(HOST_CFLAGS) -c $< -o $@
 
-$(OUTPUT)/encl_piggy.o: $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
-	$(CC) $(HOST_CFLAGS) -I$(OUTPUT) -c encl_piggy.S -o $@
-
 $(OUTPUT)/encl.bin: $(OUTPUT)/encl.elf $(OUTPUT)/sgxsign
 	$(OBJCOPY) -O binary $< $@
+	$(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
 
 $(OUTPUT)/encl.elf: encl.lds encl.c encl_bootstrap.S
 	$(CC) $(ENCL_CFLAGS) -T $^ -o $@
 
-$(OUTPUT)/encl.ss: $(OUTPUT)/encl.bin  $(OUTPUT)/sgxsign
-	$(OUTPUT)/sgxsign signing_key.pem $(OUTPUT)/encl.bin $(OUTPUT)/encl.ss
-
 $(OUTPUT)/sgxsign: sgxsign.c
 	$(CC) -o $@ $< -lcrypto
 
 EXTRA_CLEAN := \
 	$(OUTPUT)/encl.bin \
-	$(OUTPUT)/encl_piggy.o \
 	$(OUTPUT)/encl.elf \
 	$(OUTPUT)/encl.ss \
 	$(OUTPUT)/sgx_call.o \
diff --git a/tools/testing/selftests/x86/sgx/encl_piggy.S b/tools/testing/selftests/x86/sgx/encl_piggy.S
deleted file mode 100644
index a7f6447abbba..000000000000
--- a/tools/testing/selftests/x86/sgx/encl_piggy.S
+++ /dev/null
@@ -1,19 +0,0 @@
-/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
-/*
- * Copyright(c) 2016-18 Intel Corporation.
- */
-
-	.section ".rodata", "a"
-	.balign 4096
-
-encl_bin:
-	.globl encl_bin
-	.incbin	"encl.bin"
-encl_bin_end:
-	.globl encl_bin_end
-
-encl_ss:
-	.globl encl_ss
-	.incbin	"encl.ss"
-encl_ss_end:
-	.globl encl_ss_end
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 68a22ef3f05c..2160bcd0ccd9 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -14,6 +14,7 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/time.h>
+#include <sys/types.h>
 #include "encl_piggy.h"
 #include "defines.h"
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
@@ -189,7 +190,8 @@ static bool encl_add_page(int dev_fd, unsigned long addr, void *data,
 	return true;
 }
 
-static bool encl_load(struct sgx_secs *secs, unsigned long bin_size)
+static bool encl_build(struct sgx_secs *secs, void *bin,
+		       unsigned long bin_size, struct sgx_sigstruct *sigstruct)
 {
 	struct sgx_enclave_init ioc;
 	uint64_t offset;
@@ -215,11 +217,11 @@ static bool encl_load(struct sgx_secs *secs, unsigned long bin_size)
 				SGX_SECINFO_W | SGX_SECINFO_X;
 
 		if (!encl_add_page(dev_fd, secs->base + offset,
-				   encl_bin + offset, flags))
+				   bin + offset, flags))
 			goto out_map;
 	}
 
-	ioc.sigstruct = (uint64_t)&encl_ss;
+	ioc.sigstruct = (uint64_t)sigstruct;
 	rc = ioctl(dev_fd, SGX_IOC_ENCLAVE_INIT, &ioc);
 	if (rc) {
 		printf("EINIT failed rc=%d\n", rc);
@@ -241,7 +243,6 @@ static bool encl_load(struct sgx_secs *secs, unsigned long bin_size)
 		return false;
 	}
 
-
 	close(dev_fd);
 	return true;
 out_map:
@@ -251,20 +252,95 @@ static bool encl_load(struct sgx_secs *secs, unsigned long bin_size)
 	return false;
 }
 
+bool get_file_size(const char *path, off_t *bin_size)
+{
+	struct stat sb;
+	int ret;
+
+	ret = stat(path, &sb);
+	if (ret) {
+		perror("stat");
+		return false;
+	}
+
+	if (!sb.st_size || sb.st_size & 0xfff) {
+		fprintf(stderr, "Invalid blob size %lu\n", sb.st_size);
+		return false;
+	}
+
+	*bin_size = sb.st_size;
+	return true;
+}
+
+bool encl_data_map(const char *path, void **bin, off_t *bin_size)
+{
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)  {
+		fprintf(stderr, "open() %s failed, errno=%d.\n", path, errno);
+		return false;
+	}
+
+	if (!get_file_size(path, bin_size))
+		goto err_out;
+
+	*bin = mmap(NULL, *bin_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (*bin == MAP_FAILED) {
+		fprintf(stderr, "mmap() %s failed, errno=%d.\n", path, errno);
+		goto err_out;
+	}
+
+	close(fd);
+	return true;
+
+err_out:
+	close(fd);
+	return false;
+}
+
+bool load_sigstruct(const char *path, void *sigstruct)
+{
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)  {
+		fprintf(stderr, "open() %s failed, errno=%d.\n", path, errno);
+		return false;
+	}
+
+	if (read(fd, sigstruct, sizeof(struct sgx_sigstruct)) !=
+	    sizeof(struct sgx_sigstruct)) {
+		fprintf(stderr, "read() %s failed, errno=%d.\n", path, errno);
+		close(fd);
+		return false;
+	}
+
+	close(fd);
+	return true;
+}
+
 int sgx_call(void *rdi, void *rsi, long rdx, void *rcx, void *r8, void *r9,
 	     void *tcs, struct sgx_enclave_exception *ei, void *cb);
 
 int main(int argc, char *argv[], char *envp[])
 {
-	unsigned long bin_size = encl_bin_end - encl_bin;
-	unsigned long ss_size = encl_ss_end - encl_ss;
 	struct sgx_enclave_exception exception;
-	Elf64_Sym *eenter_sym;
+	struct sgx_sigstruct sigstruct;
 	struct vdso_symtab symtab;
+	Elf64_Sym *eenter_sym;
 	struct sgx_secs secs;
 	uint64_t result = 0;
+	off_t bin_size;
+	void *bin;
 	void *addr;
 
+	if (!encl_data_map("encl.bin", &bin, &bin_size))
+		exit(1);
+
+	if (!load_sigstruct("encl.ss", &sigstruct))
+		exit(1);
+
 	memset(&exception, 0, sizeof(exception));
 
 	addr = vdso_get_base_addr(envp);
@@ -279,16 +355,7 @@ int main(int argc, char *argv[], char *envp[])
 		exit(1);
 	eenter = addr + eenter_sym->st_value;
 
-	printf("Binary size %lu (0x%lx), SIGSTRUCT size %lu\n", bin_size,
-	       bin_size, ss_size);
-	if (ss_size != sizeof(struct sgx_sigstruct)) {
-		fprintf(stderr, "The size of SIGSTRUCT should be %lu\n",
-			sizeof(struct sgx_sigstruct));
-		exit(1);
-	}
-
-	printf("Loading the enclave.\n");
-	if (!encl_load(&secs, bin_size))
+	if (!encl_build(&secs, bin, bin_size, &sigstruct))
 		exit(1);
 
 	printf("Input: 0x%lx\n", MAGIC);
-- 
2.20.1

