Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59212C41514
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3717E217D7
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388919AbfHHANB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 20:13:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:51242 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388917AbfHHANA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 20:13:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 17:12:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="165519368"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 07 Aug 2019 17:12:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH for_v22 09/11] x86/sgx: Refactor error handling for user of sgx_encl_grow()
Date:   Wed,  7 Aug 2019 17:12:52 -0700
Message-Id: <20190808001254.11926-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808001254.11926-1-sean.j.christopherson@intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Refactor sgx_encl_add_page() and sgx_encl_create() to prepare for
changes to sgx_encl_grow() that will introduce additional error paths.
Neither approach scales well as is, and it'll help readability for both
flows to use similar style error handling.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 40 ++++++++++++++------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 18f6925ab2ed..fec5e0a346f5 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -283,14 +283,14 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	ssaframesize = sgx_calc_ssaframesize(secs->miscselect, secs->xfrm);
 	if (sgx_validate_secs(secs, ssaframesize)) {
 		ret = -EINVAL;
-		goto err_out;
+		goto err_out_unlock;
 	}
 
 	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
 				   VM_NORESERVE);
 	if (IS_ERR(backing)) {
 		ret = PTR_ERR(backing);
-		goto err_out;
+		goto err_out_unlock;
 	}
 
 	encl->backing = backing;
@@ -300,7 +300,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	secs_epc = sgx_alloc_page(&encl->secs, true);
 	if (IS_ERR(secs_epc)) {
 		ret = PTR_ERR(secs_epc);
-		goto err_out;
+		goto err_out_backing;
 	}
 
 	encl->secs.epc_page = secs_epc;
@@ -338,15 +338,12 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	return 0;
 
 err_out:
-	if (encl->secs.epc_page) {
-		sgx_free_page(encl->secs.epc_page);
-		encl->secs.epc_page = NULL;
-	}
+	sgx_free_page(encl->secs.epc_page);
+	encl->secs.epc_page = NULL;
 
-	if (encl->backing) {
-		fput(encl->backing);
-		encl->backing = NULL;
-	}
+err_out_backing:
+	fput(encl->backing);
+	encl->backing = NULL;
 
 err_out_unlock:
 	mutex_unlock(&encl->lock);
@@ -525,23 +522,28 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 
 	if (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
 		ret = -EFAULT;
-		goto out;
+		goto err_out_unlock;
 	}
 
 	encl_page = sgx_encl_page_alloc(encl, addr, prot);
 	if (IS_ERR(encl_page)) {
 		ret = PTR_ERR(encl_page);
-		goto out;
+		goto err_out_unlock;
 	}
 
 	ret = __sgx_encl_add_page(encl, encl_page, data, secinfo, mrmask);
-	if (ret) {
-		radix_tree_delete(&encl_page->encl->page_tree,
-				  PFN_DOWN(encl_page->desc));
-		kfree(encl_page);
-	}
+	if (ret)
+		goto err_out;
 
-out:
+	mutex_unlock(&encl->lock);
+	return 0;
+
+err_out:
+	radix_tree_delete(&encl_page->encl->page_tree,
+			  PFN_DOWN(encl_page->desc));
+	kfree(encl_page);
+
+err_out_unlock:
 	mutex_unlock(&encl->lock);
 	return ret;
 }
-- 
2.22.0

