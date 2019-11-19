Return-Path: <SRS0=2BWz=ZL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064C9C432C0
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Nov 2019 18:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8531223E4
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Nov 2019 18:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKSSlq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Nov 2019 13:41:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:54713 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbfKSSlq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 19 Nov 2019 13:41:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 10:41:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,219,1571727600"; 
   d="scan'208";a="357191651"
Received: from mthoma4-mobl.ger.corp.intel.com (HELO localhost) ([10.251.82.166])
  by orsmga004.jf.intel.com with ESMTP; 19 Nov 2019 10:41:43 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH for v24 v3 2/4] x86/sgx: %SGX_IOC_ENCLAVE_ADD_PAGES: Destroy enclave when ENCLS fails
Date:   Tue, 19 Nov 2019 20:41:35 +0200
Message-Id: <20191119184137.16004-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191119184137.16004-1-jarkko.sakkinen@linux.intel.com>
References: <20191119184137.16004-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Destroy enclave on ENCLS[EADD] failure in order to get consistent
behavior when any ENCLS fails in this ioctl.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 2d6f7b8cc429..a2b411a8236d 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -413,8 +413,13 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 
 	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
 				  addp->src);
-	if (ret)
+	if (ret) {
+		/* ENCLS failure. */
+		if (ret == -EIO)
+			sgx_encl_destroy(encl);
+
 		goto err_out;
+	}
 
 	/*
 	 * Complete the "add" before doing the "extend" so that the "add"
@@ -428,10 +433,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 	if (addp->flags & SGX_PAGE_MEASURE) {
 		ret = __sgx_encl_extend(encl, epc_page);
 
-		/*
-		 * Destroy the enclave if EEXTEND fails, EADD can't be undone.
-		 * Note, destroy() also frees the resources for the added page.
-		 */
+		/* ENCLS failure. */
 		if (ret) {
 			sgx_encl_destroy(encl);
 			goto out_unlock;
@@ -494,6 +496,10 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
  * re-invoke SGX_IOC_ENCLAVE_ADD_PAGES using the same struct in response to an
  * ERESTARTSYS error.
  *
+ * If ENCLS opcode fails, that effectively means that EPC has been invalidated.
+ * When this happens the enclave is destroyed and -EIO is returned to the
+ * caller.
+ *
  * Return:
  *   0 on success,
  *   -EACCES if an executable source page is located in a noexec partition,
-- 
2.20.1

