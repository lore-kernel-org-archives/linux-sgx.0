Return-Path: <SRS0=R+G5=WJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FB0C41514
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Aug 2019 01:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5710B206A2
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Aug 2019 01:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfHMBMz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Aug 2019 21:12:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:4461 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbfHMBMy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Aug 2019 21:12:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 18:12:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,379,1559545200"; 
   d="scan'208";a="176062489"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 12 Aug 2019 18:12:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v22 v2 6/8] x86/sgx: Allocate encl_page prior to taking encl->lock
Date:   Mon, 12 Aug 2019 18:12:50 -0700
Message-Id: <20190813011252.4121-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190813011252.4121-1-sean.j.christopherson@intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Refactor sgx_encl_add_page() to allocate the encl_page prior to taking
encl->lock so that the encl_page can be used to allocate its associated
EPC page without having to drop and retake encl->lock.  Removal of the
add page worker will move EPC page allocation to sgx_encl_add_page().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 29 ++++++++++++--------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 55e0fe261b8c..49407ccb26c8 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -518,24 +518,22 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 			return ret;
 	}
 
-	mutex_lock(&encl->lock);
-
-	va_page = sgx_encl_grow(encl, SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD);
-	if (IS_ERR(va_page)) {
-		ret = PTR_ERR(va_page);
-		goto err_out_unlock;
-	}
-
 	encl_page = sgx_encl_page_alloc(encl, addr, prot, page_type);
-	if (IS_ERR(encl_page)) {
-		ret = PTR_ERR(encl_page);
-		goto err_out_shrink;
+	if (IS_ERR(encl_page))
+		return PTR_ERR(encl_page);
+
+	mutex_lock(&encl->lock);
+
+	va_page = sgx_encl_grow(encl, SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD);
+	if (IS_ERR(va_page)) {
+		ret = PTR_ERR(va_page);
+		goto err_out_free;
 	}
 
 	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
 				encl_page);
 	if (ret)
-		goto err_out_free;
+		goto err_out_shrink;
 
 	ret = __sgx_encl_add_page(encl, encl_page, data, secinfo, mrmask);
 	if (ret)
@@ -547,13 +545,12 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 err_out:
 	radix_tree_delete(&encl_page->encl->page_tree,
 			  PFN_DOWN(encl_page->desc));
+err_out_shrink:
+	sgx_encl_shrink(encl, va_page);
+
 err_out_free:
 	kfree(encl_page);
 
-err_out_shrink:
-	sgx_encl_shrink(encl, va_page);
-
-err_out_unlock:
 	mutex_unlock(&encl->lock);
 	return ret;
 }
-- 
2.22.0

