Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80EB2C04FE2
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jul 2023 23:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjGLXCz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jul 2023 19:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbjGLXCW (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Jul 2023 19:02:22 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2FA19BC
        for <linux-sgx@vger.kernel.org>; Wed, 12 Jul 2023 16:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202939; x=1720738939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BlosA8LgIMDKJmaqT7zZ9u2Mn5b5/FsfDtSPAb1QSLo=;
  b=IeLfLB7OmitdzaB8BUnB1X70FalLp0G12goDBCX8eoWR90qCvV/Zp//r
   PiZSPtqZ5cqvOn2ZSr2uFrZl5FcOyqYpT04Rg6j0lGU/OBrjOGBKPR8E/
   U/8uLvpQ3HkL5qGIwMnppOKsf9d/9JUdceJvN+bZ2wK86vxkCa/jx3/3d
   eqOYZIg8vDePKLDOqK6VmBvvebrbroHw1C4sD6k65EOGiDANVGtgp3AnO
   toq5jGM+jutVxY6uKC8Thfb3St6aPRJf8VTjySTEg5Mx8KAZn6LdUKu5c
   qE/D/IgD1bUd3+GZ9Py5KMMoSOa7tk5ppaB7M3kMJhxDXqOPwvHFAAc4I
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="428774208"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="428774208"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 16:02:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="835338678"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="835338678"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jul 2023 16:02:18 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     jarkko@kernel.org, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org
Cc:     kai.huang@intel.com, reinette.chatre@intel.com
Subject: [PATCH v3 23/28] selftests/sgx: Retry the ioctl()'s returned with EAGAIN
Date:   Wed, 12 Jul 2023 16:01:57 -0700
Message-Id: <20230712230202.47929-24-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712230202.47929-1-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

For EMODT and EREMOVE ioctl()'s with a large range, kernel
may not finish in one shot and return EAGAIN error code
and count of bytes of EPC pages on that operations are
finished successfully.

Change the unclobbered_vdso_oversubscribed_remove test
to rerun the ioctl()'s in a loop, updating offset and length
using the byte count returned in each iteration.

Fixes: 6507cce561b4 ("selftests/sgx: Page removal stress test")
Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 tools/testing/selftests/sgx/main.c | 42 ++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 9820b3809c69..59cca806eda1 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -390,6 +390,7 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
 	struct encl_segment *heap;
 	unsigned long total_mem;
 	int ret, errno_save;
+	unsigned long count;
 	unsigned long addr;
 	unsigned long i;
 
@@ -453,16 +454,30 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
 	modt_ioc.offset = heap->offset;
 	modt_ioc.length = heap->size;
 	modt_ioc.page_type = SGX_PAGE_TYPE_TRIM;
-
+	count = 0;
 	TH_LOG("Changing type of %zd bytes to trimmed may take a while ...",
 	       heap->size);
-	ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_MODIFY_TYPES, &modt_ioc);
-	errno_save = ret == -1 ? errno : 0;
+	do {
+		ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_MODIFY_TYPES, &modt_ioc);
+
+		errno_save = ret == -1 ? errno : 0;
+		if (errno_save != EAGAIN)
+			break;
+
+		EXPECT_EQ(modt_ioc.result, 0);
+
+		count += modt_ioc.count;
+		modt_ioc.offset += modt_ioc.count;
+		modt_ioc.length -= modt_ioc.count;
+		modt_ioc.result = 0;
+		modt_ioc.count = 0;
+	} while (modt_ioc.length != 0);
 
 	EXPECT_EQ(ret, 0);
 	EXPECT_EQ(errno_save, 0);
 	EXPECT_EQ(modt_ioc.result, 0);
-	EXPECT_EQ(modt_ioc.count, heap->size);
+	count += modt_ioc.count;
+	EXPECT_EQ(count, heap->size);
 
 	/* EACCEPT all removed pages. */
 	addr = self->encl.encl_base + heap->offset;
@@ -490,15 +505,26 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
 
 	remove_ioc.offset = heap->offset;
 	remove_ioc.length = heap->size;
-
+	count = 0;
 	TH_LOG("Removing %zd bytes from enclave may take a while ...",
 	       heap->size);
-	ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_REMOVE_PAGES, &remove_ioc);
-	errno_save = ret == -1 ? errno : 0;
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
 
 	EXPECT_EQ(ret, 0);
 	EXPECT_EQ(errno_save, 0);
-	EXPECT_EQ(remove_ioc.count, heap->size);
+	count += remove_ioc.count;
+	EXPECT_EQ(count, heap->size);
 }
 
 TEST_F(enclave, clobbered_vdso)
-- 
2.25.1

