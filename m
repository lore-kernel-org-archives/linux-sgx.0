Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E3FDC07CA9
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jul 2023 23:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbjGLXC7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jul 2023 19:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbjGLXCY (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Jul 2023 19:02:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B283D10D4
        for <linux-sgx@vger.kernel.org>; Wed, 12 Jul 2023 16:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202942; x=1720738942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OXXERqdkrcX5B8bwFSXSEPboGeg3NoknJzVG4Ag6www=;
  b=MknnG8AEjKA8EigFKYzr3S+R+Q93x9Wi7HvzYDgXHrPCFeU8cwiOEzxs
   hhphs7NFiL4DvsEP4m7M15F4V00B79FQ3oxN1XArDMjbTMV7KbquvxD9e
   7uCy4kZJDQzh8Tf4sobTC55gEIQpOfyGd3o+K6jTp9b2vUNyTJe7eL3u4
   muKP088dbcYLaZOYpebv3pyjYLuOK6/Bgy1gnChy15AYwgW4FcWz0aAtV
   JYOa86uuJGbDgni6vJQrtMByux1HAzSeTNt0ZxToLdBV4EK+lHrJSd0q8
   LiBlhaVrAmprTbF+IGwcqBMMCwaUSonJPY1VKoOgiuz2cOyqxzq8ORINv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="428774217"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="428774217"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 16:02:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="835338688"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="835338688"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jul 2023 16:02:18 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     jarkko@kernel.org, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org
Cc:     kai.huang@intel.com, reinette.chatre@intel.com
Subject: [PATCH v3 25/28] selftests/sgx: Use encl->encl_size in sigstruct.c
Date:   Wed, 12 Jul 2023 16:01:59 -0700
Message-Id: <20230712230202.47929-26-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712230202.47929-1-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

The final enclave address range (referred as ELRANGE in Intel SDM)
calculation is a reminiscent of signing tool being a separate command-line
utility, and sigstruct being produced during the compilation. Given that
nowadays the sigstruct is calculated on-fly, use the readily calculated
encl->encl_size instead, in order to remove duplicate code.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 tools/testing/selftests/sgx/load.c      | 5 +++--
 tools/testing/selftests/sgx/main.h      | 1 -
 tools/testing/selftests/sgx/sigstruct.c | 8 ++------
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
index 94bdeac1cf04..3b4e2422fb09 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -174,6 +174,7 @@ uint64_t encl_get_entry(struct encl *encl, const char *symbol)
 bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
 {
 	const char device_path[] = "/dev/sgx_enclave";
+	unsigned long contents_size;
 	struct encl_segment *seg;
 	Elf64_Phdr *phdr_tbl;
 	off_t src_offset;
@@ -298,9 +299,9 @@ bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
 	if (seg->src == MAP_FAILED)
 		goto err;
 
-	encl->src_size = encl->segment_tbl[j].offset + encl->segment_tbl[j].size;
+	contents_size = encl->segment_tbl[j].offset + encl->segment_tbl[j].size;
 
-	for (encl->encl_size = 4096; encl->encl_size < encl->src_size; )
+	for (encl->encl_size = 4096; encl->encl_size < contents_size; )
 		encl->encl_size <<= 1;
 
 	return true;
diff --git a/tools/testing/selftests/sgx/main.h b/tools/testing/selftests/sgx/main.h
index 82b33f8db048..9c1bc0d9b43c 100644
--- a/tools/testing/selftests/sgx/main.h
+++ b/tools/testing/selftests/sgx/main.h
@@ -20,7 +20,6 @@ struct encl {
 	void *bin;
 	off_t bin_size;
 	void *src;
-	size_t src_size;
 	size_t encl_size;
 	off_t encl_base;
 	unsigned int nr_segments;
diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
index a07896a46364..9a40c7966eda 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -218,13 +218,9 @@ struct mrecreate {
 } __attribute__((__packed__));
 
 
-static bool mrenclave_ecreate(EVP_MD_CTX *ctx, uint64_t blob_size)
+static bool mrenclave_ecreate(EVP_MD_CTX *ctx, uint64_t encl_size)
 {
 	struct mrecreate mrecreate;
-	uint64_t encl_size;
-
-	for (encl_size = 0x1000; encl_size < blob_size; )
-		encl_size <<= 1;
 
 	memset(&mrecreate, 0, sizeof(mrecreate));
 	mrecreate.tag = MRECREATE;
@@ -349,7 +345,7 @@ bool encl_measure(struct encl *encl)
 	if (!ctx)
 		goto err;
 
-	if (!mrenclave_ecreate(ctx, encl->src_size))
+	if (!mrenclave_ecreate(ctx, encl->encl_size))
 		goto err;
 
 	for (i = 0; i < encl->nr_segments; i++) {
-- 
2.25.1

