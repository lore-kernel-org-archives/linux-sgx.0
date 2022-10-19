Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C579DC43219
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Oct 2022 19:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJSTOW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Oct 2022 15:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiJSTOS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 19 Oct 2022 15:14:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D781D374E
        for <linux-sgx@vger.kernel.org>; Wed, 19 Oct 2022 12:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666206855; x=1697742855;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=U/iSupQd/iALKhWtingvKOvxMzE6VmW0vA3EATo7ydU=;
  b=jRT4EXTeYYjbF+yf8wSa0DLS3PnV5M68GvDdbX/s2BiyHUXXvUyYZhb7
   AJeyaTzeqwX7HX1NS4feyu8I57M8Xsr0Ihzb7aNDJs2GHcDxAcGCiXUGP
   Hyl6zwfHWMoQT7v6V/ZOql2r6cm8KKh2Ij3+rFmc4eREj8xaQfm5vzjG8
   Qs3SLqd2lsfm2c9x4P65qx0g4HljwuAC8VYrn4iAoWEtt0+eV1wQJXR5/
   Omp2aYh69pHv4+fg1cWQ7vP7msziLNfDADD6HLw6EVI/jqjgib1XFDFKN
   M7xeXq0iSZjEpyOsQFSjjZ+b9vPb2XzMBpuaJCwob7t1u04yvG/vdfXBL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="286226064"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="286226064"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 12:14:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="874579984"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="874579984"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga006.fm.intel.com with ESMTP; 19 Oct 2022 12:14:14 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH 3/4] selftests/sgx: add len field for EACCEPT op
Date:   Wed, 19 Oct 2022 12:14:12 -0700
Message-Id: <20221019191413.48752-4-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019191413.48752-3-haitao.huang@linux.intel.com>
References: <20221019191413.48752-1-haitao.huang@linux.intel.com>
 <20221019191413.48752-2-haitao.huang@linux.intel.com>
 <20221019191413.48752-3-haitao.huang@linux.intel.com>
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
 tools/testing/selftests/sgx/test_encl.c | 20 ++++++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

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
 
diff --git a/tools/testing/selftests/sgx/test_encl.c b/tools/testing/selftests/sgx/test_encl.c
index c0d6397295e3..fc797385200b 100644
--- a/tools/testing/selftests/sgx/test_encl.c
+++ b/tools/testing/selftests/sgx/test_encl.c
@@ -35,14 +35,22 @@ static void do_encl_eaccept(void *_op)
 	struct sgx_secinfo secinfo __aligned(sizeof(struct sgx_secinfo)) = {0};
 	struct encl_op_eaccept *op = _op;
 	int rax;
+	if (op->len == 0)
+		op->len = 4096;
 
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

