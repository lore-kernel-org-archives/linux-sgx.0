Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD46DC10F00
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Jul 2023 23:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbjGLXC4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Jul 2023 19:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbjGLXCY (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Jul 2023 19:02:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AC7173F
        for <linux-sgx@vger.kernel.org>; Wed, 12 Jul 2023 16:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202942; x=1720738942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q4gty4KnkzlTu/tEIXQfM3BOIA+htBulOuBIz/ogzts=;
  b=a1DL9+/QN9pYhUT8X6ih45Q8G+r99J03nRgTMHkcSDU6NhBV4PrIH9dd
   zjVBeYxijNGgf8OJr7mj6jsjY0wOoXTUN9tJKKcW4Jxpa2s+harbGO65f
   +kBwc2vghHQnrwb1I/TJPoVBBr4s/Y/hRsRj2gJNVgZn1GtZ0cmUbmqYK
   6ooKn87xaTyA7TY55QRUu9CvLoB9d8CgqXaH1WLeEncaT8ZqQjLoITa6r
   I294kNvdtRH7x+4wZXk+XD2SezlDGKYV1i/MnYYW0XFxSsHBCFKAXKXZb
   eHEKCLXKcO/HNk/GL3K5+lZa6xZyvMBTcc5Bn1Om36KsakVtr9fW4IBLM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="428774212"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="428774212"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 16:02:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="835338681"
X-IronPort-AV: E=Sophos;i="6.01,200,1684825200"; 
   d="scan'208";a="835338681"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jul 2023 16:02:18 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     jarkko@kernel.org, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org
Cc:     kai.huang@intel.com, reinette.chatre@intel.com
Subject: [PATCH v3 24/28] selftests/sgx: Move ENCL_HEAP_SIZE_DEFAULT to main.c
Date:   Wed, 12 Jul 2023 16:01:58 -0700
Message-Id: <20230712230202.47929-25-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712230202.47929-1-haitao.huang@linux.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

Move ENCL_HEAP_SIZE_DEFAULT to main.c because all the other constants
are also there, and it is only used locally there.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
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
2.25.1

