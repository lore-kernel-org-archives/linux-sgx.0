Return-Path: <SRS0=VWPK=5I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B59C54FCE
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Mar 2020 03:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73F972070A
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Mar 2020 03:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCWDqs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 22 Mar 2020 23:46:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:64502 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgCWDqs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 22 Mar 2020 23:46:48 -0400
IronPort-SDR: psqOtkBAQHq16EBKN/4pPZ8svhUpUagNUUXE1plj5i4EFfyeMKPS2HAftTZF//LOQC2U5D9jl1
 MOt1w8oZTHgg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 20:46:47 -0700
IronPort-SDR: e6Bg+NUy5u/sJhyIOJx5VBIzCyH32251CZlotStnpzwqmxhfSO/2WJJn7ngTcrnMd7fJXEwPzZ
 h1bwnC4zqHSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,295,1580803200"; 
   d="scan'208";a="239288271"
Received: from nspindel-mobl.ger.corp.intel.com (HELO localhost) ([10.214.214.10])
  by fmsmga008.fm.intel.com with ESMTP; 22 Mar 2020 20:46:45 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 3/5] selftests/sgx: Move EINIT out of encl_build()
Date:   Mon, 23 Mar 2020 05:46:32 +0200
Message-Id: <20200323034634.4157-3-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323034634.4157-1-jarkko.sakkinen@linux.intel.com>
References: <20200323034634.4157-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Take EINIT out of encl_build() and move SIGSTRUCT generation and EINIT
right after the encl_build() call. No reason to intertie them as they are
fully independent tasks (i.e. could be even done in parallel).

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/sgx/main.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index f39b783c8def..995423565c83 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -195,11 +195,9 @@ static bool encl_add_pages(int dev_fd, unsigned long offset, void *data,
 	(SGX_SECINFO_REG | SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X)
 
 static bool encl_build(int encl_fd, struct sgx_secs *secs, void *bin,
-		       unsigned long bin_size, struct sgx_sigstruct *sigstruct)
+		       unsigned long bin_size)
 {
-	struct sgx_enclave_init ioc;
 	void *addr;
-	int rc;
 
 	if (!encl_add_pages(encl_fd, 0, bin, PAGE_SIZE, SGX_SECINFO_TCS))
 		return false;
@@ -208,13 +206,6 @@ static bool encl_build(int encl_fd, struct sgx_secs *secs, void *bin,
 			    bin_size - PAGE_SIZE, SGX_REG_PAGE_FLAGS))
 		return false;
 
-	ioc.sigstruct = (uint64_t)sigstruct;
-	rc = ioctl(encl_fd, SGX_IOC_ENCLAVE_INIT, &ioc);
-	if (rc) {
-		fprintf(stderr, "EINIT failed rc=%d\n", rc);
-		return false;
-	}
-
 	addr = mmap((void *)secs->base, PAGE_SIZE, PROT_READ | PROT_WRITE,
 		    MAP_SHARED | MAP_FIXED, encl_fd, 0);
 	if (addr == MAP_FAILED) {
@@ -311,11 +302,13 @@ int main(int argc, char *argv[], char *envp[])
 {
 	struct sgx_enclave_exception exception;
 	struct sgx_sigstruct sigstruct;
+	struct sgx_enclave_init ioc;
 	struct vdso_symtab symtab;
 	Elf64_Sym *eenter_sym;
 	uint64_t result = 0;
 	struct context ctx;
 	void *addr;
+	int ret;
 
 	context_init(&ctx);
 
@@ -328,15 +321,21 @@ int main(int argc, char *argv[], char *envp[])
 	if (!encl_data_map("encl.bin", &ctx.bin, &ctx.bin_size))
 		goto err;
 
-	if (!encl_create_sigstruct(ctx.bin, ctx.bin_size, &sigstruct))
+	if (!encl_create(ctx.encl_fd, ctx.bin_size, &ctx.secs))
 		goto err;
 
-	if (!encl_create(ctx.encl_fd, ctx.bin_size, &ctx.secs))
+	if (!encl_build(ctx.encl_fd, &ctx.secs, ctx.bin, ctx.bin_size))
+		goto err;
+
+	if (!encl_create_sigstruct(ctx.bin, ctx.bin_size, &sigstruct))
 		goto err;
 
-	if (!encl_build(ctx.encl_fd, &ctx.secs, ctx.bin, ctx.bin_size,
-			&sigstruct))
+	ioc.sigstruct = (uint64_t)&sigstruct;
+	ret = ioctl(ctx.encl_fd, SGX_IOC_ENCLAVE_INIT, &ioc);
+	if (ret) {
+		fprintf(stderr, "EINIT failed ret=%d, errno=%d\n", ret, errno);
 		goto err;
+	}
 
 	memset(&exception, 0, sizeof(exception));
 
-- 
2.25.1

