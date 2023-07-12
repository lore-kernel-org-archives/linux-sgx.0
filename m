Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEBDC18E1B
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jul 2023 23:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbjGLXDB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jul 2023 19:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbjGLXCZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Jul 2023 19:02:25 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6251FF1
        for <linux-sgx@vger.kernel.org>; Wed, 12 Jul 2023 16:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202944; x=1720738944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0CP9JDzehyPQihGy+5+A9A4mUUF2hbLE64v9/cJetwI=;
  b=IU7SrZVNt0M0w4ucndmArlN8nKkKQGTWyJM6AowEhwxGEsGXnBKtpN0b
   7uGv/4MIjPU6xnrycrYvRYzPxNsm0gLPY83+92Vo+2cE6sSSlINTqKmB5
   scyVDIkL6sxknYkRkMKxP/oCADcDE5v1N+StzgD+speBLJ3pN8YkyX5ix
   o5GU0fBWYcLAsP7cPqGUDsOxSu10euQdPsdiTx6dp+hJCm0Zf0UVvbS3B
   5oXV3I9nuicRZNRsa5hdu2zWUo6jeSN8+FWZ0kkVNzIEG6eMTqDvS0LE8
   yxH2HbJ46VwYglX5trFtuGFcTSNws/Ag3pLizbHW3NzSRqbN/nVqCueJi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="428774224"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="428774224"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 16:02:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="835338695"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="835338695"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jul 2023 16:02:19 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     jarkko@kernel.org, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org
Cc:     kai.huang@intel.com, reinette.chatre@intel.com,
        Vijay Dhanraj <vijay.dhanraj@intel.com>
Subject: [PATCH v3 27/28] selftests/sgx: Add SGX selftest augment_via_eaccept_long
Date:   Wed, 12 Jul 2023 16:02:01 -0700
Message-Id: <20230712230202.47929-28-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712230202.47929-1-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Vijay Dhanraj <vijay.dhanraj@intel.com>

Add a new test case which is same as augment_via_eaccept but adds a
larger number of EPC pages to stress test EAUG via EACCEPT.

Signed-off-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 tools/testing/selftests/sgx/main.c | 112 ++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 78c3b913ce10..e596b45bc5f8 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -22,8 +22,10 @@
 #include "main.h"
 
 static const size_t ENCL_HEAP_SIZE_DEFAULT = PAGE_SIZE;
+static const unsigned long TIMEOUT_DEFAULT = 900;
 static const uint64_t MAGIC = 0x1122334455667788ULL;
 static const uint64_t MAGIC2 = 0x8877665544332211ULL;
+
 vdso_sgx_enter_enclave_t vdso_sgx_enter_enclave;
 
 /*
@@ -387,7 +389,7 @@ TEST_F(enclave, unclobbered_vdso_oversubscribed)
 	EXPECT_EQ(self->run.user_data, 0);
 }
 
-TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
+TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, TIMEOUT_DEFAULT)
 {
 	struct sgx_enclave_remove_pages remove_ioc;
 	struct sgx_enclave_modify_types modt_ioc;
@@ -1245,6 +1247,114 @@ TEST_F(enclave, augment_via_eaccept)
 	munmap(addr, PAGE_SIZE);
 }
 
+/*
+ * Test for the addition of large number of pages to an initialized enclave via
+ * a pre-emptive run of EACCEPT on every page to be added.
+ */
+TEST_F_TIMEOUT(enclave, augment_via_eaccept_long, TIMEOUT_DEFAULT)
+{
+	/*
+	 * The dynamic heap size was chosen based on a bug report:
+	 * Message-ID:
+	 * <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
+	 */
+	static const unsigned long DYNAMIC_HEAP_SIZE = 0x200000L * PAGE_SIZE;
+	struct encl_op_get_from_addr get_addr_op;
+	struct encl_op_put_to_addr put_addr_op;
+	struct encl_op_eaccept eaccept_op;
+	size_t total_size = 0;
+	unsigned long i;
+	void *addr;
+
+	if (!sgx2_supported())
+		SKIP(return, "SGX2 not supported");
+
+	ASSERT_TRUE(setup_test_encl_dynamic(ENCL_HEAP_SIZE_DEFAULT, DYNAMIC_HEAP_SIZE,
+					    &self->encl, _metadata));
+
+	memset(&self->run, 0, sizeof(self->run));
+	self->run.tcs = self->encl.encl_base;
+
+	for (i = 0; i < self->encl.nr_segments; i++) {
+		struct encl_segment *seg = &self->encl.segment_tbl[i];
+
+		total_size += seg->size;
+	}
+
+	/*
+	 * mmap() every page at end of existing enclave to be used for
+	 * EDMM.
+	 */
+	addr = mmap((void *)self->encl.encl_base + total_size, DYNAMIC_HEAP_SIZE,
+		    PROT_READ | PROT_WRITE | PROT_EXEC, MAP_SHARED | MAP_FIXED,
+		    self->encl.fd, 0);
+	EXPECT_NE(addr, MAP_FAILED);
+
+	self->run.exception_vector = 0;
+	self->run.exception_error_code = 0;
+	self->run.exception_addr = 0;
+
+	/*
+	 * Run EACCEPT on every page to trigger the #PF->EAUG->EACCEPT(again
+	 * without a #PF). All should be transparent to userspace.
+	 */
+	eaccept_op.flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SGX_SECINFO_PENDING;
+	eaccept_op.ret = 0;
+	eaccept_op.header.type = ENCL_OP_EACCEPT;
+
+	for (i = 0; i < DYNAMIC_HEAP_SIZE; i += PAGE_SIZE) {
+		eaccept_op.epc_addr = (uint64_t)(addr + i);
+
+		EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
+		if (self->run.exception_vector == 14 &&
+		    self->run.exception_error_code == 4 &&
+		    self->run.exception_addr == self->encl.encl_base) {
+			munmap(addr, DYNAMIC_HEAP_SIZE);
+			SKIP(return, "Kernel does not support adding pages to initialized enclave");
+		}
+
+		EXPECT_EQ(self->run.exception_vector, 0);
+		EXPECT_EQ(self->run.exception_error_code, 0);
+		EXPECT_EQ(self->run.exception_addr, 0);
+		ASSERT_EQ(eaccept_op.ret, 0);
+		ASSERT_EQ(self->run.function, EEXIT);
+	}
+
+	/*
+	 * Pool of pages were successfully added to enclave. Perform sanity
+	 * check on first page of the pool only to ensure data can be written
+	 * to and read from a dynamically added enclave page.
+	 */
+	put_addr_op.value = MAGIC;
+	put_addr_op.addr = (unsigned long)addr;
+	put_addr_op.header.type = ENCL_OP_PUT_TO_ADDRESS;
+
+	EXPECT_EQ(ENCL_CALL(&put_addr_op, &self->run, true), 0);
+
+	EXPECT_EEXIT(&self->run);
+	EXPECT_EQ(self->run.exception_vector, 0);
+	EXPECT_EQ(self->run.exception_error_code, 0);
+	EXPECT_EQ(self->run.exception_addr, 0);
+
+	/*
+	 * Read memory from newly added page that was just written to,
+	 * confirming that data previously written (MAGIC) is present.
+	 */
+	get_addr_op.value = 0;
+	get_addr_op.addr = (unsigned long)addr;
+	get_addr_op.header.type = ENCL_OP_GET_FROM_ADDRESS;
+
+	EXPECT_EQ(ENCL_CALL(&get_addr_op, &self->run, true), 0);
+
+	EXPECT_EQ(get_addr_op.value, MAGIC);
+	EXPECT_EEXIT(&self->run);
+	EXPECT_EQ(self->run.exception_vector, 0);
+	EXPECT_EQ(self->run.exception_error_code, 0);
+	EXPECT_EQ(self->run.exception_addr, 0);
+
+	munmap(addr, DYNAMIC_HEAP_SIZE);
+}
+
 /*
  * SGX2 page type modification test in two phases:
  * Phase 1:
-- 
2.25.1

