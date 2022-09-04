Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C370C6FA86
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Sep 2022 07:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbiIDHyT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Sep 2022 03:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiIDHyR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 4 Sep 2022 03:54:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1645B4B4A4;
        Sun,  4 Sep 2022 00:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0AF460E84;
        Sun,  4 Sep 2022 07:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F09C433D6;
        Sun,  4 Sep 2022 07:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662278056;
        bh=pzByMiqnD9Chpi3CjKiZTWDg/fVKmpfXISvNevXinVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7msamQskxHB80VD2y+pNhDX+sdmunZ8uBT8jIE2dK8VzjavhcQ2qTW3KFBkq7JyA
         LrHZKBMAawFaug8ZDk4rGkkf4VHPFQL4SpEKooLmw+Rfvwu0dZ8kUVjigygfmW9NGE
         rJ7eHiuLDEnkBQmUX231VL2ORM6DnpfeCyuT1NvvscL6ombbn5MLcmOK0493eJlAbD
         ocK5zX7rF/+B5gx3GbjNytcgUngk5P6iw3iCbmrIjSAQetH1BNFSIx2HTyK6wE+oFP
         eVcyy85OXWF/nLaFNCs4TK4/X7Rw4StwwZ7jGsv22q51o2jy50ehHQpRuyGj+ZPMC7
         +oo2BddgkzDKA==
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
Subject: [PATCH 2/5] selftests/sgx: Move ENCL_HEAP_SIZE_DEFAULT to main.c
Date:   Sun,  4 Sep 2022 10:53:55 +0300
Message-Id: <20220904075358.7727-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220904075358.7727-1-jarkko@kernel.org>
References: <20220904075358.7727-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move ENCL_HEAP_SIZE_DEFAULT to main.c because all the other constants
are also there, and it is only used locally there.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 tools/testing/selftests/sgx/main.c | 1 +
 tools/testing/selftests/sgx/main.h | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 59cca806eda1..a1850e139c99 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -21,6 +21,7 @@
 #include "../kselftest_harness.h"
 #include "main.h"
 
+static const size_t ENCL_HEAP_SIZE_DEFAULT = PAGE_SIZE;
 static const uint64_t MAGIC = 0x1122334455667788ULL;
 static const uint64_t MAGIC2 = 0x8877665544332211ULL;
 vdso_sgx_enter_enclave_t vdso_sgx_enter_enclave;
diff --git a/tools/testing/selftests/sgx/main.h b/tools/testing/selftests/sgx/main.h
index fc585be97e2f..82b33f8db048 100644
--- a/tools/testing/selftests/sgx/main.h
+++ b/tools/testing/selftests/sgx/main.h
@@ -6,8 +6,6 @@
 #ifndef MAIN_H
 #define MAIN_H
 
-#define ENCL_HEAP_SIZE_DEFAULT	4096
-
 struct encl_segment {
 	void *src;
 	off_t offset;
-- 
2.37.2

