Return-Path: <SRS0=L1tv=Y4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BE0CA9EB5
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 20:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 687E72084D
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 20:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbfKDUCQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:02:16 -0500
Received: from mga17.intel.com ([192.55.52.151]:48552 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbfKDUCQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Nov 2019 15:02:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 12:02:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="213645747"
Received: from rczubala-mobl.ger.corp.intel.com (HELO localhost) ([10.252.7.245])
  by orsmga002.jf.intel.com with ESMTP; 04 Nov 2019 12:02:13 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH for v24 2/3] x86/sgx: Destroy enclave if EADD fails
Date:   Mon,  4 Nov 2019 22:01:40 +0200
Message-Id: <20191104200141.5385-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191104200141.5385-1-jarkko.sakkinen@linux.intel.com>
References: <20191104200141.5385-1-jarkko.sakkinen@linux.intel.com>
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

