Return-Path: <SRS0=ABp+=Y5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88ABC010A2
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 11:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACE9821E6F
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 11:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbfKELVH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 5 Nov 2019 06:21:07 -0500
Received: from mga12.intel.com ([192.55.52.136]:63879 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbfKELVH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 5 Nov 2019 06:21:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 03:21:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="200347540"
Received: from zpanjkov-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.3.163])
  by fmsmga008.fm.intel.com with ESMTP; 05 Nov 2019 03:21:06 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH for v24 v2 3/4] x86/sgx: Detach sgx_encl_add_page() from struct sgx_enclave_add_pages
Date:   Tue,  5 Nov 2019 13:20:55 +0200
Message-Id: <20191105112056.21452-3-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105112056.21452-1-jarkko.sakkinen@linux.intel.com>
References: <20191105112056.21452-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Internals should not have direct bindings to the ioctl API. Therefore,
unpack &sgx_enclave_add_pages and pass its fields as separate parameters to
sgx_enclave_add_page(). This will also remove an inconsistency: secinfo is
already passed as a separate parameter whereas other fields are read from
the struct.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 87b2fb62825a..deca49bd4f58 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -360,16 +360,16 @@ static int __sgx_encl_extend(struct sgx_encl *encl,
 	return 0;
 }
 
-static int sgx_encl_add_page(struct sgx_encl *encl,
-			     struct sgx_enclave_add_pages *addp,
-			     struct sgx_secinfo *secinfo)
+static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
+			     unsigned long offset, unsigned long length,
+			     struct sgx_secinfo *secinfo, unsigned long flags)
 {
 	struct sgx_encl_page *encl_page;
 	struct sgx_epc_page *epc_page;
 	struct sgx_va_page *va_page;
 	int ret;
 
-	encl_page = sgx_encl_page_alloc(encl, addp->offset, secinfo->flags);
+	encl_page = sgx_encl_page_alloc(encl, offset, secinfo->flags);
 	if (IS_ERR(encl_page))
 		return PTR_ERR(encl_page);
 
@@ -412,7 +412,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 		goto err_out_unlock;
 
 	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
-				  addp->src);
+				  src);
 	if (ret) {
 		sgx_encl_destroy(encl);
 		goto err_out;
@@ -427,7 +427,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 	encl_page->epc_page = epc_page;
 	encl->secs_child_cnt++;
 
-	if (addp->flags & SGX_PAGE_MEASURE) {
+	if (flags & SGX_PAGE_MEASURE) {
 		ret = __sgx_encl_extend(encl, epc_page);
 
 		/*
@@ -543,7 +543,8 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 		if (need_resched())
 			cond_resched();
 
-		ret = sgx_encl_add_page(encl, &addp, &secinfo);
+		ret = sgx_encl_add_page(encl, addp.src, addp.offset,
+					addp.length, &secinfo, addp.flags);
 		if (ret)
 			break;
 
-- 
2.20.1

