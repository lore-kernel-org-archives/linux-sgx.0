Return-Path: <SRS0=PIOK=C3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8526C43463
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 13:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BAA923719
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Sep 2020 13:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgIRNHf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Sep 2020 09:07:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:7740 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbgIRNHe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Sep 2020 09:07:34 -0400
IronPort-SDR: lexhCNUzwKa1eIM3CDRD8m6sS+V79KiFThpEfJ0cSPf6b5yenktbBhc+vqq+Y6CxqWYcw/sHue
 Ig497nlMRa9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="159984946"
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="159984946"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 06:02:34 -0700
IronPort-SDR: xdmrxl6kpdDFzAehcYJC4CQ/u5+k4yOQ9CaO2cPXCYTr0dXuZWgkv7ek+sDCqZROFsKb/7i5xw
 Skp3VrNJdYuQ==
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="452740007"
Received: from dlos-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.48.212])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 06:02:32 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH] x86/sgx: Refine rollback in SGX_IOC_ENCLAVE_ADD_PAGE
Date:   Fri, 18 Sep 2020 16:02:26 +0300
Message-Id: <20200918130226.39530-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Revert back 'count' to struct sgx_enclave_add_pages as in most of the
cases enclave can be recovered. Refine the documentation to better
describe the enclave is persisted.

Move the check for -EIO from sgx_encl_add_page() to
sgx_ioc_enclave_pages() to make it more visible. It was quite
hidden over there.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/uapi/asm/sgx.h | 12 +++++++-----
 arch/x86/kernel/cpu/sgx/ioctl.c | 29 ++++++++++++++---------------
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 1564d7f88597..ec5157b2ff50 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -45,13 +45,15 @@ struct sgx_enclave_create  {
  * @length:	length of the data (multiple of the page size)
  * @secinfo:	address for the SECINFO data
  * @flags:	page control flags
+ * @count:	number of bytes added (multiple of the page size)
  */
 struct sgx_enclave_add_pages {
-	__u64	src;
-	__u64	offset;
-	__u64	length;
-	__u64	secinfo;
-	__u64	flags;
+	__u64 src;
+	__u64 offset;
+	__u64 length;
+	__u64 secinfo;
+	__u64 flags;
+	__u64 count;
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 30de66f4247b..d10179b47daa 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -449,16 +449,6 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	sgx_free_epc_page(epc_page);
 	kfree(encl_page);
 
-	/*
-	 * Destroy enclave on ENCLS failure as this means that EPC has been
-	 * invalidated.
-	 */
-	if (ret == -EIO) {
-		mutex_lock(&encl->lock);
-		sgx_encl_destroy(encl);
-		mutex_unlock(&encl->lock);
-	}
-
 	return ret;
 }
 
@@ -487,12 +477,15 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
  *
  * If ENCLS opcode fails, that effectively means that EPC has been invalidated.
  * When this happens the enclave is destroyed and -EIO is returned to the
- * caller.
+ * caller. In this situation the function destroys the enclave as it cannot
+ * be recovered.
  *
  * Return:
  *   length of the data processed on success,
  *   -EACCES if an executable source page is located in a noexec partition,
- *   -EIO if either ENCLS[EADD] or ENCLS[EEXTEND] fails
+ *   -ENOMEM if the system is out of EPC pages,
+ *   -EINTR if the call was interrupted before any data was processed,
+ *   -EIO if either ENCLS[EADD] or ENCLS[EEXTEND] fails,
  *   -errno otherwise
  */
 static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
@@ -549,10 +542,16 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 			break;
 	}
 
-	if (ret)
-		return ret;
+	addp.count = c;
+
+	/* On EADD or EEXTEND failure, destroy the enclave. */
+	if (ret == -EIO) {
+		mutex_lock(&encl->lock);
+		sgx_encl_destroy(encl);
+		mutex_unlock(&encl->lock);
+	}
 
-	return c;
+	return ret;
 }
 
 static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
-- 
2.25.1

