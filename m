Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704F6C636BD
	for <linux-sgx@archiver.kernel.org>; Sat, 28 Jan 2023 04:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjA1Ezd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Jan 2023 23:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjA1Ezc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 27 Jan 2023 23:55:32 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955E484B6D
        for <linux-sgx@vger.kernel.org>; Fri, 27 Jan 2023 20:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674881731; x=1706417731;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=wlN/uSnSjwjEpS3YvW3a0wz+q6wEfy8nG8PcVPLMdWo=;
  b=alMhStwxmIg0stYNf68IViU/cfkLxsZYzhWWrsHQ+kdR2/qupcGwtRUl
   j8VvyGrhJBx4DEYbtTwWRty33d/YwLffGPqRjwk6RHLTWKF0Jcy3t3H98
   4kVLCQOgKWbgHJ4FGTIw3xjNg0SdyupWiPpkITNCKnLJhuiEg7mjxfd4t
   mTm2oQ2aiiq7lUet6PDyoxMeHF3QmSuX/zf/BQJ0Nw7RrKQ8HjnkbdtBp
   ofuENBCs7G6JsTuVfaWOrP1Kn4AOuC3e7jYmyKmC5VoNJlT/jFbQROF5/
   qSwxDiZOATtiRNVyGaHmZNkHp2Krf9MJxQSfFs/6ptx5np0mtDaG/+WRe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="413484078"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="413484078"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 20:55:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="640942047"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="640942047"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga006.jf.intel.com with ESMTP; 27 Jan 2023 20:55:29 -0800
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v4 3/4] selftests/sgx: add len field for EACCEPT op
Date:   Fri, 27 Jan 2023 20:55:28 -0800
Message-Id: <20230128045529.15749-4-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230128045529.15749-3-haitao.huang@linux.intel.com>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
 <20230128045529.15749-2-haitao.huang@linux.intel.com>
 <20230128045529.15749-3-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

So we can EACCEPT multiple pages inside enclave without EEXIT,
preparing for testing with MADV_WILLNEED for ranges bigger than
a single page.

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
---
 tools/testing/selftests/sgx/defines.h   |  1 +
 tools/testing/selftests/sgx/main.c      | 15 +++++++++++++++
 tools/testing/selftests/sgx/test_encl.c | 18 ++++++++++++------
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/sgx/defines.h b/tools/testing/selftests/sgx/defines.h
index d8587c971941..8578e773d3d8 100644
--- a/tools/testing/selftests/sgx/defines.h
+++ b/tools/testing/selftests/sgx/defines.h
@@ -60,6 +60,7 @@ struct encl_op_eaccept {
 	struct encl_op_header header;
 	uint64_t epc_addr;
 	uint64_t flags;
+	uint64_t len;
 	uint64_t ret;
 };
 
diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index e596b45bc5f8..e457f2d35461 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -493,6 +493,7 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, TIMEOUT_DEFAULT)
 
 	eaccept_op.flags = SGX_SECINFO_TRIM | SGX_SECINFO_MODIFIED;
 	eaccept_op.header.type = ENCL_OP_EACCEPT;
+	eaccept_op.len = PAGE_SIZE;
 
 	TH_LOG("Entering enclave to run EACCEPT for each page of %zd bytes may take a while ...",
 	       heap->size);
@@ -916,6 +917,7 @@ TEST_F(enclave, epcm_permissions)
 	 * EPCM permissions changed from kernel, need to EACCEPT from enclave.
 	 */
 	eaccept_op.epc_addr = data_start;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_REG | SGX_SECINFO_PR;
 	eaccept_op.ret = 0;
 	eaccept_op.header.type = ENCL_OP_EACCEPT;
@@ -1092,6 +1094,7 @@ TEST_F(enclave, augment)
 	self->run.tcs = self->encl.encl_base + PAGE_SIZE;
 
 	eaccept_op.epc_addr = self->encl.encl_base + total_size;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
 	eaccept_op.ret = 0;
 	eaccept_op.header.type = ENCL_OP_EACCEPT;
@@ -1194,6 +1197,7 @@ TEST_F(enclave, augment_via_eaccept)
 	 * without a #PF). All should be transparent to userspace.
 	 */
 	eaccept_op.epc_addr = self->encl.encl_base + total_size;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
 	eaccept_op.ret = 0;
 	eaccept_op.header.type = ENCL_OP_EACCEPT;
@@ -1299,6 +1303,7 @@ TEST_F_TIMEOUT(enclave, augment_via_eaccept_long, TIMEOUT_DEFAULT)
 	 * without a #PF). All should be transparent to userspace.
 	 */
 	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.ret = 0;
 	eaccept_op.header.type = ENCL_OP_EACCEPT;
 
@@ -1451,6 +1456,7 @@ TEST_F(enclave, tcs_create)
 	 */
 
 	eaccept_op.epc_addr = (unsigned long)stack_end;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
 	eaccept_op.ret = 0;
 	eaccept_op.header.type = ENCL_OP_EACCEPT;
@@ -1471,6 +1477,7 @@ TEST_F(enclave, tcs_create)
 	EXPECT_EQ(eaccept_op.ret, 0);
 
 	eaccept_op.epc_addr = (unsigned long)ssa;
+	eaccept_op.len = PAGE_SIZE;
 
 	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
 
@@ -1481,6 +1488,7 @@ TEST_F(enclave, tcs_create)
 	EXPECT_EQ(eaccept_op.ret, 0);
 
 	eaccept_op.epc_addr = (unsigned long)tcs;
+	eaccept_op.len = PAGE_SIZE;
 
 	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
 
@@ -1533,6 +1541,7 @@ TEST_F(enclave, tcs_create)
 
 	/* EACCEPT new TCS page from enclave. */
 	eaccept_op.epc_addr = (unsigned long)tcs;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.flags = SGX_SECINFO_TCS | SGX_SECINFO_MODIFIED;
 	eaccept_op.ret = 0;
 	eaccept_op.header.type = ENCL_OP_EACCEPT;
@@ -1601,6 +1610,7 @@ TEST_F(enclave, tcs_create)
 	self->run.tcs = self->encl.encl_base;
 
 	eaccept_op.epc_addr = (unsigned long)stack_end;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.flags = SGX_SECINFO_TRIM | SGX_SECINFO_MODIFIED;
 	eaccept_op.ret = 0;
 	eaccept_op.header.type = ENCL_OP_EACCEPT;
@@ -1614,6 +1624,7 @@ TEST_F(enclave, tcs_create)
 	EXPECT_EQ(eaccept_op.ret, 0);
 
 	eaccept_op.epc_addr = (unsigned long)tcs;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.ret = 0;
 
 	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
@@ -1625,6 +1636,7 @@ TEST_F(enclave, tcs_create)
 	EXPECT_EQ(eaccept_op.ret, 0);
 
 	eaccept_op.epc_addr = (unsigned long)ssa;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.ret = 0;
 
 	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
@@ -1653,6 +1665,7 @@ TEST_F(enclave, tcs_create)
 	 * trigger dynamic add of regular page at that location.
 	 */
 	eaccept_op.epc_addr = (unsigned long)tcs;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
 	eaccept_op.ret = 0;
 	eaccept_op.header.type = ENCL_OP_EACCEPT;
@@ -2022,6 +2035,7 @@ TEST_F(enclave, remove_added_page_invalid_access_after_eaccept)
 	EXPECT_EQ(ioc.count, 4096);
 
 	eaccept_op.epc_addr = (unsigned long)data_start;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.ret = 0;
 	eaccept_op.flags = SGX_SECINFO_TRIM | SGX_SECINFO_MODIFIED;
 	eaccept_op.header.type = ENCL_OP_EACCEPT;
@@ -2112,6 +2126,7 @@ TEST_F(enclave, remove_untouched_page)
 	 */
 
 	eaccept_op.epc_addr = data_start;
+	eaccept_op.len = PAGE_SIZE;
 	eaccept_op.flags = SGX_SECINFO_TRIM | SGX_SECINFO_MODIFIED;
 	eaccept_op.ret = 0;
 	eaccept_op.header.type = ENCL_OP_EACCEPT;
diff --git a/tools/testing/selftests/sgx/test_encl.c b/tools/testing/selftests/sgx/test_encl.c
index c0d6397295e3..439f1adbd357 100644
--- a/tools/testing/selftests/sgx/test_encl.c
+++ b/tools/testing/selftests/sgx/test_encl.c
@@ -37,12 +37,18 @@ static void do_encl_eaccept(void *_op)
 	int rax;
 
 	secinfo.flags = op->flags;
-
-	asm volatile(".byte 0x0f, 0x01, 0xd7"
-				: "=a" (rax)
-				: "a" (EACCEPT),
-				  "b" (&secinfo),
-				  "c" (op->epc_addr));
+	for (uint64_t addr = op->epc_addr;
+			addr < op->epc_addr + op->len; addr += 4096) {
+		asm volatile(".byte 0x0f, 0x01, 0xd7"
+					: "=a" (rax)
+					: "a" (EACCEPT),
+					  "b" (&secinfo),
+					  "c" (addr));
+		if (rax) {
+			op->ret = rax;
+			return;
+		}
+	}
 
 	op->ret = rax;
 }
-- 
2.25.1

