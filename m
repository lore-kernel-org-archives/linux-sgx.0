Return-Path: <SRS0=7vij=YC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75AADECE58E
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F94021835
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfJIEmo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Oct 2019 00:42:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:6367 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbfJIEmo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Oct 2019 00:42:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 21:42:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="218504416"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 08 Oct 2019 21:42:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 2/7] selftests/x86/sgx: Update test to account for ADD_PAGE change
Date:   Tue,  8 Oct 2019 21:42:36 -0700
Message-Id: <20191009044241.3591-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191009044241.3591-1-sean.j.christopherson@intel.com>
References: <20191009044241.3591-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Update the SGX selftest to pass the target offset instead of the full
address when adding pages to an enclave.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index f78ff458b0dd..7cffc16c02e0 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -164,7 +164,7 @@ static bool encl_create(int dev_fd, unsigned long bin_size,
 	return true;
 }
 
-static bool encl_add_page(int dev_fd, unsigned long addr, void *data,
+static bool encl_add_page(int dev_fd, unsigned long offset, void *data,
 			  uint64_t flags)
 {
 	struct sgx_enclave_add_page ioc;
@@ -176,7 +176,7 @@ static bool encl_add_page(int dev_fd, unsigned long addr, void *data,
 
 	ioc.secinfo = (unsigned long)&secinfo;
 	ioc.mrmask = 0xFFFF;
-	ioc.addr = addr;
+	ioc.offset = offset;
 	ioc.src = (uint64_t)data;
 	memset(ioc.reserved, 0, sizeof(ioc.reserved));
 
@@ -215,8 +215,7 @@ static bool encl_build(struct sgx_secs *secs, void *bin,
 			flags = SGX_SECINFO_REG | SGX_SECINFO_R |
 				SGX_SECINFO_W | SGX_SECINFO_X;
 
-		if (!encl_add_page(dev_fd, secs->base + offset,
-				   bin + offset, flags))
+		if (!encl_add_page(dev_fd, offset, bin + offset, flags))
 			goto out_map;
 	}
 
-- 
2.22.0

