Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F588C3A5A4
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 19:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60AD22186A
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 19:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbfH0T1W (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Aug 2019 15:27:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:33016 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730963AbfH0T1V (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Aug 2019 15:27:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 12:27:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="180318620"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2019 12:27:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH v2 5/5] x86/sgx: Destroy the enclave if EEXTEND fails
Date:   Tue, 27 Aug 2019 12:27:17 -0700
Message-Id: <20190827192717.27312-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827192717.27312-1-sean.j.christopherson@intel.com>
References: <20190827192717.27312-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Mark an enclave as dead and release its resources if EEXTEND fails, as
the driver cannot gracefully unwind from EEXTEND failure and does not
provide userspace enough information to restart the ioctl.  Allowing
EEXTEND to be restarted is not a requirement as EEXTEND can only fail in
the event of a kernel or hardware bug.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 7f605fb7e0f4..03428a404878 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -348,6 +348,7 @@ static int __sgx_encl_extend(struct sgx_encl *encl,
 		if (ret) {
 			if (encls_failed(ret))
 				ENCLS_WARN(ret, "EEXTEND");
+			sgx_encl_destroy(encl);
 			return -EFAULT;
 		}
 	}
-- 
2.22.0

