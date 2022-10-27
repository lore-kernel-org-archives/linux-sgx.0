Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F0CECAAA1
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Oct 2022 19:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiJ0Tpk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Oct 2022 15:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236662AbiJ0Tpi (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 27 Oct 2022 15:45:38 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C3269F74
        for <linux-sgx@vger.kernel.org>; Thu, 27 Oct 2022 12:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666899937; x=1698435937;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=KWnJFJGkfA7A5GGsnzDAK63MfJBiJ4YYGRMcSk6UlFk=;
  b=awGlgXQA4NUZnatxmeyG4QK9LuWgSC+XfBL0tNGDPKRjtyhXL7NlgFOc
   PqbpUXdTvT+eAgKWjo8CcjE/+cW+yWeGnpatMpREc+Bj+mNne8Y6ZgOSH
   7Ju+ppKJEvFOOiN6xDbJMciCT56TEYLQQVxEMDtDWS+D1lg2J/ydYvsnD
   8yvtNxwlGTBsyaijHAQHG12kEUzAe8+09OdQS6EItwxBAFFMCCYD29W2Y
   redirKHbj7/lKIE5QtBWLyylPDbT44Bi/HaYlegUshj/+3RLXvtHz/ZCm
   uaDNE4MIXEgT5DfUrLnmC6eG620gT3s2kQsRJw2lYmxvNkYvsdmmomSLh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="310021416"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="310021416"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 12:45:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="961753299"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="961753299"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga005.fm.intel.com with ESMTP; 27 Oct 2022 12:45:33 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v2 4/4] selftests/sgx: Add test for madvise(..., WILLNEED)
Date:   Thu, 27 Oct 2022 12:45:32 -0700
Message-Id: <20221027194532.180053-5-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027194532.180053-4-haitao.huang@linux.intel.com>
References: <20221027194532.180053-1-haitao.huang@linux.intel.com>
 <20221027194532.180053-2-haitao.huang@linux.intel.com>
 <20221027194532.180053-3-haitao.huang@linux.intel.com>
 <20221027194532.180053-4-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Measure and compare run time for EAUG'ing different number
of EPC pages with/without madvise(..., WILLNEED) call.

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
---
 tools/testing/selftests/sgx/main.c | 167 +++++++++++++++++++++++++++++
 1 file changed, 167 insertions(+)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 48976bb7bd79..7b5f6705716d 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -10,6 +10,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <string.h>
+#include <time.h>
 #include <unistd.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
@@ -1358,6 +1359,172 @@ TEST_F_TIMEOUT(enclave, augment_via_eaccept_long, TIMEOUT_DEFAULT)
 	munmap(addr, ENCL_DYNAMIC_SIZE_LONG);
 }
 
+static int eaccept_range(struct _test_data_enclave *self, void *addr,
+			 unsigned long size, uint64_t flags,
+						struct __test_metadata *_metadata)
+{
+	struct encl_op_eaccept eaccept_op;
+
+	self->run.exception_vector = 0;
+	self->run.exception_error_code = 0;
+	self->run.exception_addr = 0;
+
+	/*
+	 * Run EACCEPT on every page to trigger the #PF->EAUG->EACCEPT(again
+	 * without a #PF). All should be transparent to userspace.
+	 */
+	eaccept_op.flags = flags;
+	eaccept_op.ret = 0;
+	eaccept_op.header.type = ENCL_OP_EACCEPT;
+	eaccept_op.len = size;
+	eaccept_op.epc_addr = (uint64_t)(addr);
+
+	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
+
+	EXPECT_EQ(self->run.exception_vector, 0);
+	EXPECT_EQ(self->run.exception_error_code, 0);
+	EXPECT_EQ(self->run.exception_addr, 0);
+	ASSERT_EQ(eaccept_op.ret, 0);
+	ASSERT_EQ(self->run.function, EEXIT);
+
+	return 0;
+}
+
+static int trim_remove_range(struct _test_data_enclave *self, void *addr,
+			     unsigned long size, struct __test_metadata *_metadata)
+{
+	int ret, errno_save;
+	struct sgx_enclave_remove_pages remove_ioc;
+	struct sgx_enclave_modify_types modt_ioc;
+	unsigned long offset;
+	unsigned long count;
+
+	if ((uint64_t)addr <= self->encl.encl_base)
+		return -1;
+	offset = (uint64_t)addr - self->encl.encl_base;
+
+	memset(&modt_ioc, 0, sizeof(modt_ioc));
+	modt_ioc.offset = offset;
+	modt_ioc.length = size;
+	modt_ioc.page_type = SGX_PAGE_TYPE_TRIM;
+	count = 0;
+	do {
+		ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_MODIFY_TYPES, &modt_ioc);
+
+		errno_save = ret == -1 ? errno : 0;
+		if (errno_save != EAGAIN)
+			break;
+		EXPECT_EQ(modt_ioc.result, 0);
+
+		count += modt_ioc.count;
+		modt_ioc.offset += modt_ioc.count;
+		modt_ioc.length -= modt_ioc.count;
+		modt_ioc.result = 0;
+		modt_ioc.count = 0;
+	} while (modt_ioc.length != 0);
+
+	EXPECT_EQ(ret, 0);
+	EXPECT_EQ(errno_save, 0);
+	EXPECT_EQ(modt_ioc.result, 0);
+	count += modt_ioc.count;
+	EXPECT_EQ(count, size);
+
+	EXPECT_EQ(eaccept_range(self, addr, size,
+				SGX_SECINFO_TRIM | SGX_SECINFO_MODIFIED,
+				   _metadata), 0);
+
+	/* Complete page removal. */
+	memset(&remove_ioc, 0, sizeof(remove_ioc));
+	remove_ioc.offset = offset;
+	remove_ioc.length = size;
+	count = 0;
+	do {
+		ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_REMOVE_PAGES, &remove_ioc);
+
+		errno_save = ret == -1 ? errno : 0;
+		if (errno_save != EAGAIN)
+			break;
+
+		count += remove_ioc.count;
+		remove_ioc.offset += remove_ioc.count;
+		remove_ioc.length -= remove_ioc.count;
+		remove_ioc.count = 0;
+	} while (remove_ioc.length != 0);
+
+	EXPECT_EQ(ret, 0);
+	EXPECT_EQ(errno_save, 0);
+	count += remove_ioc.count;
+	EXPECT_EQ(count, size);
+
+	return 0;
+}
+
+/*
+ * Compare performance with and without madvise call before EACCEPT'ing
+ * different size of regions.
+ */
+TEST_F_TIMEOUT(enclave, augment_via_madvise, TIMEOUT_DEFAULT)
+{
+	unsigned long advise_size = PAGE_SIZE;
+	unsigned long max_advise_size = get_total_epc_mem() * 3UL;
+	int speed_up_percent;
+	clock_t start;
+	double time_used1, time_used2;
+	size_t total_size = 0;
+	unsigned long i;
+	void *addr;
+
+	if (!sgx2_supported())
+		SKIP(return, "SGX2 not supported");
+
+	ASSERT_TRUE(setup_test_encl_dynamic(ENCL_HEAP_SIZE_DEFAULT,
+					    max_advise_size, &self->encl, _metadata));
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
+	for (i = 1; i < 52 && advise_size < max_advise_size; i++) {
+		addr = mmap((void *)self->encl.encl_base + total_size, advise_size,
+			    PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED,
+					self->encl.fd, 0);
+		EXPECT_NE(addr, MAP_FAILED);
+
+		start = clock();
+		EXPECT_EQ(eaccept_range(self, addr, advise_size,
+					SGX_SECINFO_R | SGX_SECINFO_W
+								| SGX_SECINFO_REG
+								| SGX_SECINFO_PENDING,
+								_metadata), 0);
+		time_used1 = (double)clock() - start;
+
+		EXPECT_EQ(trim_remove_range(self, addr, advise_size, _metadata), 0);
+
+		start = clock();
+		EXPECT_EQ(madvise(addr, advise_size, MADV_WILLNEED), 0);
+		EXPECT_EQ(eaccept_range(self, addr, advise_size,
+					SGX_SECINFO_R | SGX_SECINFO_W
+								| SGX_SECINFO_REG
+								| SGX_SECINFO_PENDING,
+								_metadata), 0);
+		time_used2 = (double)clock() - start;
+
+		speed_up_percent = (int)((time_used1 - time_used2) / time_used1 * 100);
+		TH_LOG("madvise speed up for eaug'ing %10ld pages: %d%%",
+		       advise_size / PAGE_SIZE, speed_up_percent);
+		EXPECT_GE(speed_up_percent, 0);
+		EXPECT_EQ(trim_remove_range(self, addr, advise_size, _metadata), 0);
+	    munmap(addr, advise_size);
+		advise_size = (advise_size << 1UL);
+	}
+	encl_delete(&self->encl);
+}
+
 /*
  * SGX2 page type modification test in two phases:
  * Phase 1:
-- 
2.25.1

