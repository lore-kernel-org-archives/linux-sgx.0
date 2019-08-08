Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2BFC32757
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BC35217D7
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388917AbfHHANB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 20:13:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:51237 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389045AbfHHANB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 20:13:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 17:12:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="165519376"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 07 Aug 2019 17:12:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH for_v22 11/11] x86/sgx: Shrink the enclave if ECREATE/EADD fails
Date:   Wed,  7 Aug 2019 17:12:54 -0700
Message-Id: <20190808001254.11926-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808001254.11926-1-sean.j.christopherson@intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add sgx_encl_shrink() to pair with sgx_encl_grow() and use it to adjust
the VA page count when ECREATE or EADD fails.  Return the allocated VA
page from sgx_encl_grow() so that it can be freed during shrink.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 55 +++++++++++++++++++-------
 1 file changed, 40 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index a531cf615f3c..173a405d59a5 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -22,16 +22,17 @@ struct sgx_add_page_req {
 	struct list_head list;
 };
 
-static int sgx_encl_grow(struct sgx_encl *encl, unsigned int disallowed_flags)
+static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl,
+					 unsigned int disallowed_flags)
 {
-	struct sgx_va_page *va_page;
-	int ret;
+	struct sgx_va_page *va_page = NULL;
+	void *err;
 
 	BUILD_BUG_ON(SGX_VA_SLOT_COUNT !=
 		(SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
 
 	if (encl->flags & disallowed_flags)
-		return -EFAULT;
+		return ERR_PTR(-EFAULT);
 
 	if (!(encl->page_cnt % SGX_VA_SLOT_COUNT)) {
 		mutex_unlock(&encl->lock);
@@ -46,22 +47,34 @@ static int sgx_encl_grow(struct sgx_encl *encl, unsigned int disallowed_flags)
 		mutex_lock(&encl->lock);
 
 		if (IS_ERR(va_page->epc_page)) {
-			ret = PTR_ERR(va_page->epc_page);
+			err = ERR_CAST(va_page->epc_page);
 			kfree(va_page);
-			return ret;
+			return err;
 		} else if (encl->flags & disallowed_flags) {
 			sgx_free_page(va_page->epc_page);
 			kfree(va_page);
-			return -EFAULT;
+			return ERR_PTR(-EFAULT);
 		} else if (encl->page_cnt % SGX_VA_SLOT_COUNT) {
 			sgx_free_page(va_page->epc_page);
 			kfree(va_page);
+			va_page = NULL;
 		} else {
 			list_add(&va_page->list, &encl->va_pages);
 		}
 	}
 	encl->page_cnt++;
-	return 0;
+	return va_page;
+}
+
+static void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
+{
+	encl->page_cnt--;
+
+	if (va_page) {
+		sgx_free_page(va_page->epc_page);
+		list_del(&va_page->list);
+		kfree(va_page);
+	}
 }
 
 static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
@@ -260,6 +273,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 {
 	unsigned long encl_size = secs->size + PAGE_SIZE;
 	struct sgx_epc_page *secs_epc;
+	struct sgx_va_page *va_page;
 	unsigned long ssaframesize;
 	struct sgx_pageinfo pginfo;
 	struct sgx_secinfo secinfo;
@@ -268,21 +282,23 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 
 	mutex_lock(&encl->lock);
 
-	ret = sgx_encl_grow(encl, SGX_ENCL_CREATED | SGX_ENCL_DEAD);
-	if (ret)
+	va_page = sgx_encl_grow(encl, SGX_ENCL_CREATED | SGX_ENCL_DEAD);
+	if (IS_ERR(va_page)) {
+		ret = PTR_ERR(va_page);
 		goto err_out_unlock;
+	}
 
 	ssaframesize = sgx_calc_ssaframesize(secs->miscselect, secs->xfrm);
 	if (sgx_validate_secs(secs, ssaframesize)) {
 		ret = -EINVAL;
-		goto err_out_unlock;
+		goto err_out_shrink;
 	}
 
 	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
 				   VM_NORESERVE);
 	if (IS_ERR(backing)) {
 		ret = PTR_ERR(backing);
-		goto err_out_unlock;
+		goto err_out_shrink;
 	}
 
 	encl->backing = backing;
@@ -337,6 +353,9 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	fput(encl->backing);
 	encl->backing = NULL;
 
+err_out_shrink:
+	sgx_encl_shrink(encl, va_page);
+
 err_out_unlock:
 	mutex_unlock(&encl->lock);
 	return ret;
@@ -496,6 +515,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 {
 	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
 	struct sgx_encl_page *encl_page;
+	struct sgx_va_page *va_page;
 	int ret;
 
 	if (sgx_validate_secinfo(secinfo))
@@ -508,14 +528,16 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 
 	mutex_lock(&encl->lock);
 
-	ret = sgx_encl_grow(encl, SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD);
-	if (ret)
+	va_page = sgx_encl_grow(encl, SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD);
+	if (IS_ERR(va_page)) {
+		ret = PTR_ERR(va_page);
 		goto err_out_unlock;
+	}
 
 	encl_page = sgx_encl_page_alloc(encl, addr, prot);
 	if (IS_ERR(encl_page)) {
 		ret = PTR_ERR(encl_page);
-		goto err_out_unlock;
+		goto err_out_shrink;
 	}
 
 	ret = __sgx_encl_add_page(encl, encl_page, data, secinfo, mrmask);
@@ -530,6 +552,9 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 			  PFN_DOWN(encl_page->desc));
 	kfree(encl_page);
 
+err_out_shrink:
+	sgx_encl_shrink(encl, va_page);
+
 err_out_unlock:
 	mutex_unlock(&encl->lock);
 	return ret;
-- 
2.22.0

