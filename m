Return-Path: <SRS0=tCn0=YJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE28FA372E
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 18:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79AC221A4C
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 18:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394287AbfJPShu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:37:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:22394 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbfJPSht (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 14:37:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 11:37:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="397258420"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 16 Oct 2019 11:37:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 v3 03/12] x86/sgx: Fix EEXTEND error handling
Date:   Wed, 16 Oct 2019 11:37:36 -0700
Message-Id: <20191016183745.8226-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191016183745.8226-1-sean.j.christopherson@intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
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
index 7d1b449bf771..4169ff3c81d8 100644
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
@@ -421,19 +417,24 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
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

