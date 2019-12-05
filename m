Return-Path: <SRS0=0WoA=Z3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A27C43603
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Dec 2019 10:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A77412464D
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Dec 2019 10:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbfLEKCC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 5 Dec 2019 05:02:02 -0500
Received: from mga05.intel.com ([192.55.52.43]:43804 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbfLEKCC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 5 Dec 2019 05:02:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Dec 2019 02:02:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="214137872"
Received: from jsakkine-mobl1.fi.intel.com (HELO localhost) ([10.237.66.112])
  by orsmga003.jf.intel.com with ESMTP; 05 Dec 2019 02:01:58 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Huang Haitao <haitao.huang@intel.com>
Subject: [PATCH] x86/sgx: Fix double-free when EADD fails
Date:   Thu,  5 Dec 2019 12:01:51 +0200
Message-Id: <20191205100151.18950-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

radix_tree_delete() gets called twice for the same page  when EADD
fails. This commit fixes the issue.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Reported-by: Huang Haitao <haitao.huang@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index ab9e48cd294b..2ff12038a8a4 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -413,13 +413,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 
 	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
 				  src);
-	if (ret) {
-		/* ENCLS failure. */
-		if (ret == -EIO)
-			sgx_encl_destroy(encl);
-
+	if (ret)
 		goto err_out;
-	}
 
 	/*
 	 * Complete the "add" before doing the "extend" so that the "add"
@@ -432,17 +427,12 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 
 	if (flags & SGX_PAGE_MEASURE) {
 		ret = __sgx_encl_extend(encl, epc_page);
-
-		/* ENCLS failure. */
-		if (ret) {
-			sgx_encl_destroy(encl);
-			goto out_unlock;
-		}
+		if (ret)
+			goto err_out;
 	}
 
 	sgx_mark_page_reclaimable(encl_page->epc_page);
 
-out_unlock:
 	mutex_unlock(&encl->lock);
 	up_read(&current->mm->mmap_sem);
 	return ret;
@@ -460,6 +450,13 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	sgx_free_page(epc_page);
 	kfree(encl_page);
 
+	/*
+	 * Destroy enclave on ENCLS failure as this means that EPC has been
+	 * invalidated.
+	 */
+	if (ret == -EIO)
+		sgx_encl_destroy(encl);
+
 	return ret;
 }
 
-- 
2.20.1

