Return-Path: <SRS0=VWPK=5I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38E3C54FCE
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Mar 2020 03:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4BB42070A
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Mar 2020 03:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgCWDqo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 22 Mar 2020 23:46:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:64502 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgCWDqo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 22 Mar 2020 23:46:44 -0400
IronPort-SDR: uEBse+yv3PHW5Fcpt4CGMd7LLnxMrPpwk1kpWcJGWZ3BWSYpN3DJJpqxHQQbmIY2eGCd1Gql2a
 S5vTgwSEu75w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 20:46:43 -0700
IronPort-SDR: 6GClWPwgQ5nvsF6N0MqTcQVJ3wB0u+Y48efiDooj/eloHJeSCFmi81vytsPfCz6eO1rCtY07yI
 1HFr8vFyi3Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,295,1580803200"; 
   d="scan'208";a="239288251"
Received: from nspindel-mobl.ger.corp.intel.com (HELO localhost) ([10.214.214.10])
  by fmsmga008.fm.intel.com with ESMTP; 22 Mar 2020 20:46:41 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 2/5] selftests/sgx: Manage encl_fd in the main function
Date:   Mon, 23 Mar 2020 05:46:31 +0200
Message-Id: <20200323034634.4157-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323034634.4157-1-jarkko.sakkinen@linux.intel.com>
References: <20200323034634.4157-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In order to consolidate the enclave resource management to a single place,
consolidate the enclave management to the main function.  Introduce a
struct context to track the resources that are allocated by the test
program.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/sgx/main.c | 116 ++++++++++++++++++-----------
 1 file changed, 72 insertions(+), 44 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index af16dd6f4b92..f39b783c8def 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -194,39 +194,29 @@ static bool encl_add_pages(int dev_fd, unsigned long offset, void *data,
 #define SGX_REG_PAGE_FLAGS \
 	(SGX_SECINFO_REG | SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X)
 
-static bool encl_build(struct sgx_secs *secs, void *bin,
+static bool encl_build(int encl_fd, struct sgx_secs *secs, void *bin,
 		       unsigned long bin_size, struct sgx_sigstruct *sigstruct)
 {
 	struct sgx_enclave_init ioc;
 	void *addr;
-	int dev_fd;
 	int rc;
 
-	dev_fd = open("/dev/sgx/enclave", O_RDWR);
-	if (dev_fd < 0) {
-		fprintf(stderr, "Unable to open /dev/sgx\n");
+	if (!encl_add_pages(encl_fd, 0, bin, PAGE_SIZE, SGX_SECINFO_TCS))
 		return false;
-	}
-
-	if (!encl_create(dev_fd, bin_size, secs))
-		goto out_dev_fd;
 
-	if (!encl_add_pages(dev_fd, 0, bin, PAGE_SIZE, SGX_SECINFO_TCS))
-		goto out_dev_fd;
-
-	if (!encl_add_pages(dev_fd, PAGE_SIZE, bin + PAGE_SIZE,
+	if (!encl_add_pages(encl_fd, PAGE_SIZE, bin + PAGE_SIZE,
 			    bin_size - PAGE_SIZE, SGX_REG_PAGE_FLAGS))
-		goto out_dev_fd;
+		return false;
 
 	ioc.sigstruct = (uint64_t)sigstruct;
-	rc = ioctl(dev_fd, SGX_IOC_ENCLAVE_INIT, &ioc);
+	rc = ioctl(encl_fd, SGX_IOC_ENCLAVE_INIT, &ioc);
 	if (rc) {
-		printf("EINIT failed rc=%d\n", rc);
-		goto out_map;
+		fprintf(stderr, "EINIT failed rc=%d\n", rc);
+		return false;
 	}
 
 	addr = mmap((void *)secs->base, PAGE_SIZE, PROT_READ | PROT_WRITE,
-		    MAP_SHARED | MAP_FIXED, dev_fd, 0);
+		    MAP_SHARED | MAP_FIXED, encl_fd, 0);
 	if (addr == MAP_FAILED) {
 		fprintf(stderr, "mmap() failed on TCS, errno=%d.\n", errno);
 		return false;
@@ -234,19 +224,13 @@ static bool encl_build(struct sgx_secs *secs, void *bin,
 
 	addr = mmap((void *)(secs->base + PAGE_SIZE), bin_size - PAGE_SIZE,
 		    PROT_READ | PROT_WRITE | PROT_EXEC,
-		    MAP_SHARED | MAP_FIXED, dev_fd, 0);
+		    MAP_SHARED | MAP_FIXED, encl_fd, 0);
 	if (addr == MAP_FAILED) {
 		fprintf(stderr, "mmap() failed, errno=%d.\n", errno);
 		return false;
 	}
 
-	close(dev_fd);
 	return true;
-out_map:
-	munmap((void *)secs->base, secs->size);
-out_dev_fd:
-	close(dev_fd);
-	return false;
 }
 
 bool get_file_size(const char *path, off_t *bin_size)
@@ -271,6 +255,7 @@ bool get_file_size(const char *path, off_t *bin_size)
 
 bool encl_data_map(const char *path, void **bin, off_t *bin_size)
 {
+	off_t tmp_bin_size;
 	int fd;
 
 	fd = open(path, O_RDONLY);
@@ -279,15 +264,17 @@ bool encl_data_map(const char *path, void **bin, off_t *bin_size)
 		return false;
 	}
 
-	if (!get_file_size(path, bin_size))
+	if (!get_file_size(path, &tmp_bin_size))
 		goto err_out;
 
-	*bin = mmap(NULL, *bin_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	*bin = mmap(NULL, tmp_bin_size, PROT_READ, MAP_PRIVATE, fd, 0);
 	if (*bin == MAP_FAILED) {
 		fprintf(stderr, "mmap() %s failed, errno=%d.\n", path, errno);
 		goto err_out;
 	}
 
+	*bin_size = tmp_bin_size;
+
 	close(fd);
 	return true;
 
@@ -296,48 +283,89 @@ bool encl_data_map(const char *path, void **bin, off_t *bin_size)
 	return false;
 }
 
+struct context {
+	void *bin;
+	off_t bin_size;
+	int encl_fd;
+	struct sgx_secs secs;
+};
+
+static void context_init(struct context *ctx)
+{
+	memset(&ctx, 0, sizeof(ctx));
+}
+
+static void context_delete(struct context *ctx)
+{
+	if (ctx->secs.base)
+		munmap((void *)ctx->secs.base, ctx->secs.size);
+
+	if (ctx->bin)
+		munmap(ctx->bin, ctx->bin_size);
+
+	if (ctx->encl_fd)
+		close(ctx->encl_fd);
+}
+
 int main(int argc, char *argv[], char *envp[])
 {
 	struct sgx_enclave_exception exception;
 	struct sgx_sigstruct sigstruct;
 	struct vdso_symtab symtab;
 	Elf64_Sym *eenter_sym;
-	struct sgx_secs secs;
 	uint64_t result = 0;
-	off_t bin_size;
+	struct context ctx;
 	void *addr;
-	void *bin;
 
-	if (!encl_data_map("encl.bin", &bin, &bin_size))
-		exit(1);
+	context_init(&ctx);
 
-	if (!encl_create_sigstruct(bin, bin_size, &sigstruct))
-		exit(1);
+	ctx.encl_fd = open("/dev/sgx/enclave", O_RDWR);
+	if (ctx.encl_fd < 0) {
+		fprintf(stderr, "Unable to open /dev/sgx\n");
+		goto err;
+	}
 
-	if (!encl_build(&secs, bin, bin_size, &sigstruct))
-		exit(1);
+	if (!encl_data_map("encl.bin", &ctx.bin, &ctx.bin_size))
+		goto err;
+
+	if (!encl_create_sigstruct(ctx.bin, ctx.bin_size, &sigstruct))
+		goto err;
+
+	if (!encl_create(ctx.encl_fd, ctx.bin_size, &ctx.secs))
+		goto err;
+
+	if (!encl_build(ctx.encl_fd, &ctx.secs, ctx.bin, ctx.bin_size,
+			&sigstruct))
+		goto err;
 
 	memset(&exception, 0, sizeof(exception));
 
 	addr = vdso_get_base_addr(envp);
 	if (!addr)
-		exit(1);
+		goto err;
 
 	if (!vdso_get_symtab(addr, &symtab))
-		exit(1);
+		goto err;
 
 	eenter_sym = vdso_symtab_get(&symtab, "__vdso_sgx_enter_enclave");
 	if (!eenter_sym)
-		exit(1);
+		goto err;
+
 	eenter = addr + eenter_sym->st_value;
 
 	sgx_call_vdso((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
-		      (void *)secs.base, &exception, NULL);
-	if (result != MAGIC) {
-		fprintf(stderr, "FAILURE\n");
-		exit(1);
-	}
+		      (void *)ctx.secs.base, &exception, NULL);
+	if (result != MAGIC)
+		goto err;
 
 	printf("SUCCESS\n");
+
+	context_delete(&ctx);
 	exit(0);
+
+err:
+	printf("FAILURE\n");
+
+	context_delete(&ctx);
+	exit(1);
 }
-- 
2.25.1

