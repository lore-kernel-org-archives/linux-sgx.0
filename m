Return-Path: <SRS0=ABp+=Y5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9284DC010A3
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 11:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65B7B206BA
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 11:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbfKELVC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 5 Nov 2019 06:21:02 -0500
Received: from mga18.intel.com ([134.134.136.126]:19450 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730668AbfKELVC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 5 Nov 2019 06:21:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 03:21:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="403319590"
Received: from zpanjkov-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.3.163])
  by fmsmga006.fm.intel.com with ESMTP; 05 Nov 2019 03:20:59 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH for v24 v2 1/4] x86/sgx: Destroy enclave if EADD fails
Date:   Tue,  5 Nov 2019 13:20:53 +0200
Message-Id: <20191105112056.21452-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

__sgx_encl_add_page() can only fail in the case of EPCM conflict at least
in non-artificial situations. Also, it consistent semantics in rollback is
something to pursue for. Thus, destroy enclave when the EADD fails as we do
when EEXTEND fails already.

In the cases it is sane to return -EIO. From this the caller can deduce
the failure and knows that the enclave was destroyed. The previous
-EFAULT could happen in numerous situations.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index d53aee5a64c1..289af607f634 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -338,7 +338,7 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 	kunmap_atomic((void *)pginfo.contents);
 	put_page(src_page);
 
-	return ret ? -EFAULT : 0;
+	return ret ? -EIO : 0;
 }
 
 static int __sgx_encl_extend(struct sgx_encl *encl,
@@ -353,7 +353,7 @@ static int __sgx_encl_extend(struct sgx_encl *encl,
 		if (ret) {
 			if (encls_failed(ret))
 				ENCLS_WARN(ret, "EEXTEND");
-			return -EFAULT;
+			return -EIO;
 		}
 	}
 
@@ -413,8 +413,10 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 
 	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
 				  addp->src);
-	if (ret)
+	if (ret) {
+		sgx_encl_destroy(encl);
 		goto err_out;
+	}
 
 	/*
 	 * Complete the "add" before doing the "extend" so that the "add"
@@ -498,10 +500,9 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
  *
  * Return:
  *   0 on success,
- *   -EINVAL if any input param or the SECINFO contains invalid data,
  *   -EACCES if an executable source page is located in a noexec partition,
- *   -ENOMEM if any memory allocation, including EPC, fails,
- *   -ERESTARTSYS if a pending signal is recognized
+ *   -EIO if either ENCLS[EADD] or ENCLS[EEXTEND] fails
+ *   -errno otherwise
  */
 static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 {
-- 
2.20.1

