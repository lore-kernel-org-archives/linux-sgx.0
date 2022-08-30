Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1EBECAAD2
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Aug 2022 03:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiH3DN0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Aug 2022 23:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiH3DNB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 29 Aug 2022 23:13:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E379D138;
        Mon, 29 Aug 2022 20:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D4BAB815FA;
        Tue, 30 Aug 2022 03:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD47CC433D6;
        Tue, 30 Aug 2022 03:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661829163;
        bh=C/+xtlXXwsMTeMK+jpQctMYjONpKuO/3M4dkoPh3nQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhO7e6uPhw1hnde2EoG1e47OW3QPCi1R4k/bGy5Dm3v4nuMeukIp0OmDo7HFk1+Xe
         FLpCGzi7DC+biAhQpPW8C5JGdNmZUodvJGRv4+a4u8GawddIWCW9pbwWGDMItO0jcB
         dnUQJCfywDkU+xWWvt9DG7kuVgc9TBFJ8XAtrf9GyN5BZW2G/tlYreVdMEfdDAZPmY
         tRkYNc2bqmv+mdpo95hCTqOCjV7pNTLxbEYkake3rZqXy8QPpfp4LHXMivZnfSbqXv
         4IHImuhjCL83vjlQ73PPN96B8PvuCdIIUGVG+Apg/pVjCivfccJrRQlVtU1eRJ883L
         Zardddkkk/lmA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 5/6] selftests/sgx: retry the ioctls returned with EAGAIN
Date:   Tue, 30 Aug 2022 06:12:05 +0300
Message-Id: <20220830031206.13449-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220830031206.13449-1-jarkko@kernel.org>
References: <20220830031206.13449-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Haitao Huang <haitao.huang@linux.intel.com>

For EMODT and EREMOVE ioctls with a large range, kernel
may not finish in one shot and return EAGAIN error code
and count of bytes of EPC pages on that operations are
finished successfully.

Change the unclobbered_vdso_oversubscribed_remove test
to rerun the ioctls in a loop, updating offset and length
using the byte count returned in each iteration.

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 tools/testing/selftests/sgx/main.c | 39 +++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 867e98502120..3268d8b01b0b 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -399,7 +399,7 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
 	unsigned long total_mem;
 	int ret, errno_save;
 	unsigned long addr;
-	unsigned long i;
+	unsigned long i, count;
 
 	/*
 	 * Create enclave with additional heap that is as big as all
@@ -461,16 +461,27 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
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
@@ -498,15 +509,25 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscribed_remove, 900)
 
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
2.37.2

