Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8672C32758
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8849E217D7
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387536AbfHHANA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 20:13:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:51237 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730382AbfHHANA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 20:13:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 17:12:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="165519350"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 07 Aug 2019 17:12:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH for_v22 03/11] x86/sgx: Return '0' when sgx_ioc_enclave_set_attribute() succeeds
Date:   Wed,  7 Aug 2019 17:12:46 -0700
Message-Id: <20190808001254.11926-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808001254.11926-1-sean.j.christopherson@intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Ensure the local ret variable is set to zero when being returned via the
success path.

Reported-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 89b3fb81c15b..ebb71eb3323a 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -810,6 +810,7 @@ static long sgx_ioc_enclave_set_attribute(struct file *filep, void __user *arg)
 	}
 
 	encl->allowed_attributes |= SGX_ATTR_PROVISIONKEY;
+	ret = 0;
 
 out:
 	fput(attribute_file);
-- 
2.22.0

