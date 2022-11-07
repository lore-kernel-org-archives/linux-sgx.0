Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619AEC4321E
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Nov 2022 22:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiKGWCY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Nov 2022 17:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbiKGWCP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Nov 2022 17:02:15 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ABA1147D
        for <linux-sgx@vger.kernel.org>; Mon,  7 Nov 2022 14:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667858534; x=1699394534;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=KWnJFJGkfA7A5GGsnzDAK63MfJBiJ4YYGRMcSk6UlFk=;
  b=V1Zlk5x8jhz0m3D0erI+DZxQeZzXKsuXtEWb+ismYtFbH1h5mW95jM9a
   jgfFhiAekjU8ZSPP/7Tln9MN+0DbTqgyuIJobB0/IduEx/Ur/IfxM13Pm
   u1QzwumTmi3/cwJoGc1cdBdZSQXTK/JZ4L/jlgeHLB7rvzNgvAMheaW9g
   yop50qe/6f6cbdb1I693riED12Vocshy+og070/B2j3aU3+t3Fa222Y/L
   zUOa654gWsC7ZGUx/69CAY2qBXFregtsiy3hpfKcHpikMULAUqQAOjkNA
   ZUcKxcuvIFySPjxYbx1jMdnph/rXzS+OhrPxwHAVCH0Hj3T53NzzKvV1W
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="308158030"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="308158030"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:02:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="630643332"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="630643332"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga007.jf.intel.com with ESMTP; 07 Nov 2022 14:02:12 -0800
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v3 4/4] selftests/sgx: Add test for madvise(..., WILLNEED)
Date:   Mon,  7 Nov 2022 14:02:12 -0800
Message-Id: <20221107220212.257422-5-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107220212.257422-4-haitao.huang@linux.intel.com>
References: <20221107220212.257422-1-haitao.huang@linux.intel.com>
 <20221107220212.257422-2-haitao.huang@linux.intel.com>
 <20221107220212.257422-3-haitao.huang@linux.intel.com>
 <20221107220212.257422-4-haitao.huang@linux.intel.com>
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

