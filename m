Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B014C2BB41
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Aug 2022 07:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiHPH76 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 16 Aug 2022 03:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiHPH7e (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 16 Aug 2022 03:59:34 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605061BC94C
        for <linux-sgx@vger.kernel.org>; Mon, 15 Aug 2022 22:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660627017; x=1692163017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdGUlMZ+4JcCcOmxSBKM2g/x70A1B9KFo2nuO3h4hxA=;
  b=YTJE1HpDtciTch7TDFf+/Vofd2pgD3WXKgkgSYVjWSg/OKOjs5Agk+zg
   TQwq01iOcyl+RFB7ZQbKoyDIR0876jZ3yHX/uwdvaeyzRDIKaDjbATsAG
   mvAcap14sREH6DGqVW6pApgK1vkQyqQLfX1HoTHUjzu6WyHcKEeWRu/52
   HnjtQ8LTn/Oofd1Qxqltawc7dLgdDLs0IKDwV2Eh9P0sagCeJo2PkXqoC
   sic4Ul3PfVnqXd8dmSAyr9Q7LhdYGK+HpNudf1nuXd63tT6WjMuV3QcGs
   cpxsIWIQ/QvDrqSugAFang9bgmrmHS9D8Oh/9kiAb3JinkasttPtOl2R4
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="318119170"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="318119170"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 22:16:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="557560631"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga003.jf.intel.com with ESMTP; 15 Aug 2022 22:16:56 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     jarkko@kernel.org
Cc:     dave.hansen@linux.intel.com, haitao.huang@linux.intel.com,
        linux-sgx@vger.kernel.org, reinette.chatre@intel.com
Subject: [PATCH] selftests/sgx: retry the ioctls returned with EAGAIN
Date:   Mon, 15 Aug 2022 22:16:56 -0700
Message-Id: <20220816051656.3622-1-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YvlPYRvMicz9CPFQ@kernel.org>
References: <YvlPYRvMicz9CPFQ@kernel.org>
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

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 tools/testing/selftests/sgx/main.c | 39 +++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 9820b3809c69..9c8b5868b0f3 100644
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
+			modt_ioc.result = 0;
+			modt_ioc.count = 0;
+		} else
+			break;
+	} while (modt_ioc.length != 0);
 
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
+	do {
+		ret = ioctl(self->encl.fd, SGX_IOC_ENCLAVE_REMOVE_PAGES, &remove_ioc);
+		errno_save = ret == -1 ? errno : 0;
+		if (errno_save == EAGAIN) {
+			count += remove_ioc.count;
+			remove_ioc.offset += remove_ioc.count;
+			remove_ioc.length -= remove_ioc.count;
+			remove_ioc.count = 0;
+		} else
+			break;
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

