Return-Path: <SRS0=2BWz=ZL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C68EC432C0
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Nov 2019 18:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8677223E4
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Nov 2019 18:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfKSSlm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Nov 2019 13:41:42 -0500
Received: from mga14.intel.com ([192.55.52.115]:22030 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbfKSSlm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 19 Nov 2019 13:41:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 10:41:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,219,1571727600"; 
   d="scan'208";a="209502608"
Received: from mthoma4-mobl.ger.corp.intel.com (HELO localhost) ([10.251.82.166])
  by orsmga006.jf.intel.com with ESMTP; 19 Nov 2019 10:41:40 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH for v24 v3 1/4] x86/sgx: %SGX_IOC_ENCLAVE_ADD_PAGES: Return -EIO when ENCLS fails
Date:   Tue, 19 Nov 2019 20:41:34 +0200
Message-Id: <20191119184137.16004-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use a common error code for all ENCLS failures so they can be easily
recognized from user space code.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index bbdc24d50169..2d6f7b8cc429 100644
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
 
@@ -496,10 +496,9 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
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

