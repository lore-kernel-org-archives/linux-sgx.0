Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D0AC10F1A
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jul 2023 23:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbjGLXDA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jul 2023 19:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbjGLXCZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Jul 2023 19:02:25 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECC21FF0
        for <linux-sgx@vger.kernel.org>; Wed, 12 Jul 2023 16:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202944; x=1720738944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=46ckTDantMB8b1uKZy3zEmgvjMXfvJYmOeHty6ka8tE=;
  b=S2rKw5kNRMJf82q6KYuTXARjFKhKEgrXsftrWYqhsEzfhjlrvsckwEdZ
   pe2aX2PAz/be0TKDpmd2oQ/kID3K1fKtpxYq47xD5pXEgy67W5eDtFfHP
   aIst/IfSXb8PF9YJlSnid2ukI2IKVBCPTQBCqkqbagt7LU37khAoeY5KD
   JS49mFTtsRh6vWyILeeyPqLPYEZnTsys+1q69Si9+cy0ymKnuVF1+igtM
   q2bVbhQgDOdnQ/ARjvDm8C0o2MnXReqD8xh1FEQad6WUjgRJtKOllclnm
   3+wRfpjUYs1Mnq6SrMrKLWorogdN90xhnu2099Csyq88m9il9CVrfi02u
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="428774222"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="428774222"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 16:02:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="835338691"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="835338691"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jul 2023 16:02:18 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     jarkko@kernel.org, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org
Cc:     kai.huang@intel.com, reinette.chatre@intel.com
Subject: [PATCH v3 26/28] selftests/sgx: Include the dynamic heap size to the ELRANGE calculation
Date:   Wed, 12 Jul 2023 16:02:00 -0700
Message-Id: <20230712230202.47929-27-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712230202.47929-1-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

When calculating ELRANGE, i.e. the address range defined for an enclave,
and represented by encl->encl_size, also dynamic memory should be taken
into account. Implement setup_test_encl_dynamic() with dynamic_size
parameter for the dynamic heap size, and use it in 'augment_via_eaccept'
and 'augment' tests.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 tools/testing/selftests/sgx/load.c |  5 +++--
 tools/testing/selftests/sgx/main.c | 22 +++++++++++++++-------
 tools/testing/selftests/sgx/main.h |  3 ++-
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
index 3b4e2422fb09..963a5c6bbbdc 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -171,7 +171,8 @@ uint64_t encl_get_entry(struct encl *encl, const char *symbol)
 	return 0;
 }
 
-bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
+bool encl_load(const char *path, struct encl *encl, unsigned long heap_size,
+	       unsigned long dynamic_size)
 {
 	const char device_path[] = "/dev/sgx_enclave";
 	unsigned long contents_size;
@@ -299,7 +300,7 @@ bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
 	if (seg->src == MAP_FAILED)
 		goto err;
 
-	contents_size = encl->segment_tbl[j].offset + encl->segment_tbl[j].size;
+	contents_size = encl->segment_tbl[j].offset + encl->segment_tbl[j].size + dynamic_size;
 
 	for (encl->encl_size = 4096; encl->encl_size < contents_size; )
 		encl->encl_size <<= 1;
diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index a1850e139c99..78c3b913ce10 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -173,8 +173,8 @@ FIXTURE(enclave) {
 	struct sgx_enclave_run run;
 };
 
-static bool setup_test_encl(unsigned long heap_size, struct encl *encl,
-			    struct __test_metadata *_metadata)
+static bool setup_test_encl_dynamic(unsigned long heap_size, unsigned long dynamic_size,
+				    struct encl *encl, struct __test_metadata *_metadata)
 {
 	Elf64_Sym *sgx_enter_enclave_sym = NULL;
 	struct vdso_symtab symtab;
@@ -184,7 +184,7 @@ static bool setup_test_encl(unsigned long heap_size, struct encl *encl,
 	unsigned int i;
 	void *addr;
 
-	if (!encl_load("test_encl.elf", encl, heap_size)) {
+	if (!encl_load("test_encl.elf", encl, heap_size, dynamic_size)) {
 		encl_delete(encl);
 		TH_LOG("Failed to load the test enclave.");
 		return false;
@@ -251,6 +251,12 @@ static bool setup_test_encl(unsigned long heap_size, struct encl *encl,
 	return false;
 }
 
+static bool setup_test_encl(unsigned long heap_size, struct encl *encl,
+			    struct __test_metadata *_metadata)
+{
+	return setup_test_encl_dynamic(heap_size, 0, encl, _metadata);
+}
+
 FIXTURE_SETUP(enclave)
 {
 }
@@ -1013,7 +1019,8 @@ TEST_F(enclave, augment)
 	if (!sgx2_supported())
 		SKIP(return, "SGX2 not supported");
 
-	ASSERT_TRUE(setup_test_encl(ENCL_HEAP_SIZE_DEFAULT, &self->encl, _metadata));
+	ASSERT_TRUE(setup_test_encl_dynamic(ENCL_HEAP_SIZE_DEFAULT, PAGE_SIZE, &self->encl,
+					    _metadata));
 
 	memset(&self->run, 0, sizeof(self->run));
 	self->run.tcs = self->encl.encl_base;
@@ -1143,7 +1150,8 @@ TEST_F(enclave, augment_via_eaccept)
 	if (!sgx2_supported())
 		SKIP(return, "SGX2 not supported");
 
-	ASSERT_TRUE(setup_test_encl(ENCL_HEAP_SIZE_DEFAULT, &self->encl, _metadata));
+	ASSERT_TRUE(setup_test_encl_dynamic(ENCL_HEAP_SIZE_DEFAULT, PAGE_SIZE, &self->encl,
+					    _metadata));
 
 	memset(&self->run, 0, sizeof(self->run));
 	self->run.tcs = self->encl.encl_base;
@@ -1264,8 +1272,8 @@ TEST_F(enclave, tcs_create)
 	int errno_save;
 	int ret, i;
 
-	ASSERT_TRUE(setup_test_encl(ENCL_HEAP_SIZE_DEFAULT, &self->encl,
-				    _metadata));
+	ASSERT_TRUE(setup_test_encl_dynamic(ENCL_HEAP_SIZE_DEFAULT, 3 * PAGE_SIZE, &self->encl,
+					    _metadata));
 
 	memset(&self->run, 0, sizeof(self->run));
 	self->run.tcs = self->encl.encl_base;
diff --git a/tools/testing/selftests/sgx/main.h b/tools/testing/selftests/sgx/main.h
index 9c1bc0d9b43c..8f77ce56ad09 100644
--- a/tools/testing/selftests/sgx/main.h
+++ b/tools/testing/selftests/sgx/main.h
@@ -32,7 +32,8 @@ extern unsigned char sign_key[];
 extern unsigned char sign_key_end[];
 
 void encl_delete(struct encl *ctx);
-bool encl_load(const char *path, struct encl *encl, unsigned long heap_size);
+bool encl_load(const char *path, struct encl *encl, unsigned long heap_size,
+	       unsigned long dynamic_size);
 bool encl_measure(struct encl *encl);
 bool encl_build(struct encl *encl);
 uint64_t encl_get_entry(struct encl *encl, const char *symbol);
-- 
2.25.1

