Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065D9FA3742
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Oct 2022 19:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbiJ0Tpk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Oct 2022 15:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236660AbiJ0Tpi (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 27 Oct 2022 15:45:38 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C84366869
        for <linux-sgx@vger.kernel.org>; Thu, 27 Oct 2022 12:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666899937; x=1698435937;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=U/iSupQd/iALKhWtingvKOvxMzE6VmW0vA3EATo7ydU=;
  b=I1Sx4u5uvH0G7SyESzhvL9ZJCdmEFM/SGK8Mf2PnMnCrYE/tcSZA37E5
   ywmP+5X5vhsIEQ3cAqQU0RE/zQc0u6N3KNkb2PoO/mQFXgjTeMiQ2qPCk
   os8PdTE/OEKiN+sF/lusZQuECuQ8ccdotesiakEoUTGIaxyKCu6orSD7i
   2qSoo18soiLp6EQV+tIcSYksiTciOgTyuAODqpp+eXcMeTwOOYErBh5aS
   ZGFS4byb2P+cJNXE4TBj6jZ9tYbUPX68oUOriLjPzfpz+oymUUvpDTSuU
   umYTWgCZiyxLyuDIGIT3UOwKLXuvDKbnkxKx7Fp2DOwmVH/58l/tJ9o5c
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="310021414"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="310021414"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 12:45:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="961753296"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="961753296"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga005.fm.intel.com with ESMTP; 27 Oct 2022 12:45:33 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v2 3/4] selftests/sgx: add len field for EACCEPT op
Date:   Thu, 27 Oct 2022 12:45:31 -0700
Message-Id: <20221027194532.180053-4-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027194532.180053-3-haitao.huang@linux.intel.com>
References: <20221027194532.180053-1-haitao.huang@linux.intel.com>
 <20221027194532.180053-2-haitao.huang@linux.intel.com>
 <20221027194532.180053-3-haitao.huang@linux.intel.com>
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

