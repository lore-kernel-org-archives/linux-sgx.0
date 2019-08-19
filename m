Return-Path: <SRS0=kvvX=WP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16B6C3A5A0
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 15:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 779622082C
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 15:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfHSPZ6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Aug 2019 11:25:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:9895 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfHSPZ6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Aug 2019 11:25:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 08:25:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="180393037"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.125])
  by orsmga003.jf.intel.com with ESMTP; 19 Aug 2019 08:25:56 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christpherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH 2/5] x86/sgx: Use memchr_inv() in sgx_validate_secinfo()
Date:   Mon, 19 Aug 2019 18:25:41 +0300
Message-Id: <20190819152544.7296-3-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Instead of looping through the array of reserved bytes use memchr_inv()
to check the bytes.

Cc: Sean Christopherson <sean.j.christpherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 64d3286f3324..d5f326411df0 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -414,7 +414,6 @@ static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
 {
 	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
 	u64 perm = secinfo->flags & SGX_SECINFO_PERMISSION_MASK;
-	int i;
 
 	if ((secinfo->flags & SGX_SECINFO_RESERVED_MASK) ||
 	    ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R)) ||
@@ -422,9 +421,8 @@ static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
 	     page_type != SGX_SECINFO_REG))
 		return -EINVAL;
 
-	for (i = 0; i < SGX_SECINFO_RESERVED_SIZE; i++)
-		if (secinfo->reserved[i])
-			return -EINVAL;
+	if (memchr_inv(secinfo->reserved, 0, SGX_SECINFO_RESERVED_SIZE))
+		return -EINVAL;
 
 	return 0;
 }
-- 
2.20.1

