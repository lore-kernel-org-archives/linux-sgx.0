Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E75C10F14
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 22:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C132B218AC
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 22:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfJJWzj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 18:55:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:20137 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfJJWzj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 18:55:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 15:55:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="197400454"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 10 Oct 2019 15:55:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 3/4] x86/sgx: Fix EEXTEND error handling
Date:   Thu, 10 Oct 2019 15:55:29 -0700
Message-Id: <20191010225530.26400-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191010225530.26400-1-sean.j.christopherson@intel.com>
References: <20191010225530.26400-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Rework EEXTEND error handling to fix issues related to destroying the
enclave in response to EEXTEND failure.  At the time of EEXTEND, the
page is already visibile in the sense that it has been added to the
radix tree, and therefore will be processed by sgx_encl_destroy().  This
means the "add" part needs to be fully completed prior to invoking
sgx_encl_destroy() in order to avoid consuming half-baked state.

Move sgx_encl_destroy() to the call site of __sgx_encl_extend() so that
it is somewhat more obvious why the add needs to complete before doing
EEXTEND.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 61a2a7b6677e..fd4117f18564 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -351,18 +351,14 @@ static int __sgx_encl_extend(struct sgx_encl *encl,
 	for_each_set_bit(i, &mrmask, 16) {
 		ret = __eextend(sgx_epc_addr(encl->secs.epc_page),
 				sgx_epc_addr(epc_page) + (i * 0x100));
-		if (ret)
-			goto err_out;
+		if (ret) {
+			if (encls_failed(ret))
+				ENCLS_WARN(ret, "EEXTEND");
+			return -EFAULT;
+		}
 	}
 
 	return 0;
-
-err_out:
-	if (encls_failed(ret))
-		ENCLS_WARN(ret, "EEXTEND");
-
-	sgx_encl_destroy(encl);
-	return -EFAULT;
 }
 
 static int sgx_encl_add_page(struct sgx_encl *encl,
@@ -415,19 +411,24 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 	if (ret)
 		goto err_out;
 
-	ret = __sgx_encl_extend(encl, epc_page, addp->mrmask);
-	if (ret)
-		goto err_out;
-
+	/*
+	 * Complete the "add" before doing the "extend" so that the "add"
+	 * isn't in a half-baked state in the extremely unlikely scenario the
+	 * the enclave will be destroyed in response to EEXTEND failure.
+	 */
 	encl_page->encl = encl;
 	encl_page->epc_page = epc_page;
 	encl->secs_child_cnt++;
 
-	sgx_mark_page_reclaimable(encl_page->epc_page);
+	ret = __sgx_encl_extend(encl, epc_page, addp->mrmask);
+	if (ret)
+		sgx_encl_destroy(encl);
+	else
+		sgx_mark_page_reclaimable(encl_page->epc_page);
 
 	mutex_unlock(&encl->lock);
 	up_read(&current->mm->mmap_sem);
-	return 0;
+	return ret;
 
 err_out:
 	radix_tree_delete(&encl_page->encl->page_tree,
-- 
2.22.0

