Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CAAC433FE
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Nov 2022 22:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiKGWCY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Nov 2022 17:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbiKGWCP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Nov 2022 17:02:15 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B43637E
        for <linux-sgx@vger.kernel.org>; Mon,  7 Nov 2022 14:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667858534; x=1699394534;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=U/iSupQd/iALKhWtingvKOvxMzE6VmW0vA3EATo7ydU=;
  b=f1BaRoVZlPjy1fDY2fUAO834ycSkR3DvfP6Z+1ZmPv8eIbgMUt4tosrr
   jhTnOM0jYXb19995wslIL2hqiScpR1+AgG4gzX/FvWdANiPtFSbVoFbL1
   b5SHo1j6EQ9x+HaKfs3GWHqIexU7mDn49ssJYwzwhhbKBn9SZIwp8SauY
   Jm0JoFO6d+bK4E6zcZqxUNEkZZuCYdonkONIPGINOnfJzE6Uvt5UuFtAr
   xruQucGh0S0vcz0ZZpLk5corzuJ2Qy3ZFFWI0uK+LcpfNJkN5HpPHTrMf
   CpL9VUtgZPOz/ZdPfx8fU7Qi+CjCHW5ZkJxB+AEr2hSJcBvpW0nCYJwpB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="308158027"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="308158027"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:02:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="630643328"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="630643328"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga007.jf.intel.com with ESMTP; 07 Nov 2022 14:02:12 -0800
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v3 3/4] selftests/sgx: add len field for EACCEPT op
Date:   Mon,  7 Nov 2022 14:02:11 -0800
Message-Id: <20221107220212.257422-4-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107220212.257422-3-haitao.huang@linux.intel.com>
References: <20221107220212.257422-1-haitao.huang@linux.intel.com>
 <20221107220212.257422-2-haitao.huang@linux.intel.com>
 <20221107220212.257422-3-haitao.huang@linux.intel.com>
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

