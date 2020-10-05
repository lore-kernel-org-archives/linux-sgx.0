Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D74C4363C
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 02:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B9B2074F
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 02:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgJECIY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 22:08:24 -0400
Received: from mga12.intel.com ([192.55.52.136]:45010 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgJECIY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Oct 2020 22:08:24 -0400
IronPort-SDR: aV7mv+cyos+Yw5qUrwAuYOiNP9Hm0O85l3/bw0xNilzMxbEcu+/hqxA9gDaT8RLNUwxRGabrUo
 ZRCTLTuow3Qg==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="142709688"
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="142709688"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 19:08:24 -0700
IronPort-SDR: T69wrxK7q5klMP/AV1YCXhUhavGIbSeBb+DcZBPRt6tf9hEsBO+Te3DX91qDm72hkoTz8Hltt7
 WIe3y6Sr0lEQ==
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="522969587"
Received: from sidorovd-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.48.68])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 19:08:22 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH] x86/sgx: Remove checks for platform limits from sgx_validate_secs()
Date:   Mon,  5 Oct 2020 05:08:19 +0300
Message-Id: <20201005020819.124724-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove from sgx_validate_secs():

	if (secs->miscselect & sgx_misc_reserved_mask ||
	    secs->attributes & sgx_attributes_reserved_mask ||
	    secs->xfrm & sgx_xfrm_reserved_mask)
		return -EINVAL;

SECS can surpass the platform limits because it's the SIGSTRUCT that
defines the limits that are used at run-time.

What SECS does is that it defines the overall limits that must apply for
any platform, i.e.  SECS limits and platform limits are orthogonal. They
are not dependent.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Jethro Beekman <jethro@fortanix.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 6b3cc8483008..008752cb54f0 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -86,11 +86,6 @@ static int sgx_validate_secs(const struct sgx_secs *secs)
 	if (secs->base & (secs->size - 1))
 		return -EINVAL;
 
-	if (secs->miscselect & sgx_misc_reserved_mask ||
-	    secs->attributes & sgx_attributes_reserved_mask ||
-	    secs->xfrm & sgx_xfrm_reserved_mask)
-		return -EINVAL;
-
 	if (secs->size > max_size)
 		return -EINVAL;
 
-- 
2.25.1

