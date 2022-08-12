Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83BDFC00140
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Aug 2022 20:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiHLUNf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Aug 2022 16:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiHLUNe (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 12 Aug 2022 16:13:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEFF6170
        for <linux-sgx@vger.kernel.org>; Fri, 12 Aug 2022 13:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660335212; x=1691871212;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yvBLg2cg7smxzFw9sI15c44LzaHXrBrRCOhjljIsv84=;
  b=JRuklqaXVgZU89wgQNBkAD+5hZsKc4TctEIq6oQFbDmtan5123S9BVHJ
   225JbOcKivGfA61PnSL0RjxatXizuVyYKqWuJpLeq5m2L8SMh5ickZAS8
   msZZfM9VzTyRp760SjQVDnW52YrjGd/tOdZMilRIBTlHC8q5MGc8VDJDg
   1hQ9wGppAwwOob3dfQkHP/bMBjbYJkbrBXX7IdaGWPKlCAQ3wUHhjaNKH
   Ozm2YAjEyc1OAc559S9ZvFKNRZcbZsyibUl00HwOMfNnVusvSiQPcUKQ6
   qhetqzbOKoi2wGrZyUJooM4n03KFOjzu8eF0Xk41MD4PBf9uiEVNY9FFz
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="272073470"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="272073470"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 13:13:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="582216701"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga006.jf.intel.com with ESMTP; 12 Aug 2022 13:13:31 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        reinette.chatre@intel.com, dave.hansen@linux.intel.com
Subject: [PATCH] selftests/sgx: retry the ioctls returned with EAGAIN
Date:   Fri, 12 Aug 2022 13:13:31 -0700
Message-Id: <20220812201331.18791-1-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

For EMODT and EREMOVE ioctls with a large range, kernel
may not finish in one shot and return EAGAIN error code
and count of bytes of EPC pages on that operations are
finished successfully.

Change the unclobbered_vdso_oversubscribed_remove test
to rerun the ioctls in a loop, updating offset and length
using the byte count returned in each iteration.

Signed-off-by: Haitao Huang <haitao.huang@intel.com>
---
 tools/testing/selftests/sgx/main.c | 39 +++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 9820b3809c69..ff66ce2bbcac 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -391,7 +391,7 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
 	unsigned long total_mem;
 	int ret, errno_save;
 	unsigned long addr;
-	unsigned long i;
+	unsigned long i, count;
 
 	/*
 	 * Create enclave with additional heap that is as big as all
@@ -453,16 +453,27 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
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
+		errno_save = ret == -1 ? errno : 0;
+		if (errno_save == EAGAIN) {
+			count += modt_ioc.count;
+			modt_ioc.offset += modt_ioc.count;
+			modt_ioc.length -= modt_ioc.count;
+			modt_ioc.result= 0;
+			modt_ioc.count = 0;
+		} else
+			break;
+	} while(modt_ioc.length != 0);
 
 	EXPECT_EQ(ret, 0);
 	EXPECT_EQ(errno_save, 0);
 	EXPECT_EQ(modt_ioc.result, 0);
-	EXPECT_EQ(modt_ioc.count, heap->size);
+	count += modt_ioc.count;
+	EXPECT_EQ(count, heap->size);
 
 	/* EACCEPT all removed pages. */
 	addr = self->encl.encl_base + heap->offset;
@@ -490,15 +501,25 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
 
 	remove_ioc.offset = heap->offset;
 	remove_ioc.length = heap->size;
-
+	count = 0;
 	TH_LOG("Removing %zd bytes from enclave may take a while ...",
 	       heap->size);
-	ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_REMOVE_PAGES, &remove_ioc);
-	errno_save = ret == -1 ? errno : 0;
+    do {
+		ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_REMOVE_PAGES, &remove_ioc);
+		errno_save = ret == -1 ? errno : 0;
+		if (errno_save == EAGAIN) {
+			count += remove_ioc.count;
+			remove_ioc.offset += remove_ioc.count;
+			remove_ioc.length -= remove_ioc.count;
+			remove_ioc.count = 0;
+		} else
+			break;
+	} while(remove_ioc.length != 0);
 
 	EXPECT_EQ(ret, 0);
 	EXPECT_EQ(errno_save, 0);
-	EXPECT_EQ(remove_ioc.count, heap->size);
+	count += remove_ioc.count;
+	EXPECT_EQ(count, heap->size);
 }
 
 TEST_F(enclave, clobbered_vdso)
-- 
2.25.1

