Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F900C32759
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E41C217D7
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389185AbfHHANA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 20:13:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:51237 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388919AbfHHANA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 20:13:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 17:12:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="165519372"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 07 Aug 2019 17:12:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH for_v22 10/11] x86/sgx: Call sgx_encl_grow() with the enclave's lock held
Date:   Wed,  7 Aug 2019 17:12:53 -0700
Message-Id: <20190808001254.11926-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808001254.11926-1-sean.j.christopherson@intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move the taking of the enclave's lock outside of sgx_encl_grow() in
preparation for adding sgx_encl_shrink(), which will decrement the
number of enclave pages and free any allocated VA page.  When freeing
a VA page, the enclave's lock needs to be held for the entire time
between adding the VA page to the enclave's list and freeing the VA
page so as to prevent it from being used by reclaim, e.g. to avoid a
use-after-free scenario.

Because sgx_encl_grow() can temporarily drop encl->lock, calling it
with encl->lock held adds a subtle dependency on the ordering of
checks against encl->flags, e.g. checking for SGX_ENCL_CREATED prior
to calling sgx_encl_grow() could lead to a TOCTOU on ECREATE.  Avoid
this by passing in the disallowed flags to sgx_encl_grow() so that the
the dependency is clear.

Retaking encl->lock in the failure paths is a bit ugly, but the
alternative is to have sgx_encl_grow() drop encl->lock in all failure
paths, which is arguably worse since the caller has to know which
paths do/don't drop the lock.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 39 +++++++++-----------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index fec5e0a346f5..a531cf615f3c 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -22,7 +22,7 @@ struct sgx_add_page_req {
 	struct list_head list;
 };
 
-static int sgx_encl_grow(struct sgx_encl *encl)
+static int sgx_encl_grow(struct sgx_encl *encl, unsigned int disallowed_flags)
 {
 	struct sgx_va_page *va_page;
 	int ret;
@@ -30,30 +30,28 @@ static int sgx_encl_grow(struct sgx_encl *encl)
 	BUILD_BUG_ON(SGX_VA_SLOT_COUNT !=
 		(SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
 
-	mutex_lock(&encl->lock);
-	if (encl->flags & SGX_ENCL_DEAD) {
-		mutex_unlock(&encl->lock);
+	if (encl->flags & disallowed_flags)
 		return -EFAULT;
-	}
 
 	if (!(encl->page_cnt % SGX_VA_SLOT_COUNT)) {
 		mutex_unlock(&encl->lock);
 
 		va_page = kzalloc(sizeof(*va_page), GFP_KERNEL);
-		if (!va_page)
+		if (!va_page) {
+			mutex_lock(&encl->lock);
 			return -ENOMEM;
+		}
+
 		va_page->epc_page = sgx_alloc_va_page();
+		mutex_lock(&encl->lock);
+
 		if (IS_ERR(va_page->epc_page)) {
 			ret = PTR_ERR(va_page->epc_page);
 			kfree(va_page);
 			return ret;
-		}
-
-		mutex_lock(&encl->lock);
-		if (encl->flags & SGX_ENCL_DEAD) {
+		} else if (encl->flags & disallowed_flags) {
 			sgx_free_page(va_page->epc_page);
 			kfree(va_page);
-			mutex_unlock(&encl->lock);
 			return -EFAULT;
 		} else if (encl->page_cnt % SGX_VA_SLOT_COUNT) {
 			sgx_free_page(va_page->epc_page);
@@ -63,7 +61,6 @@ static int sgx_encl_grow(struct sgx_encl *encl)
 		}
 	}
 	encl->page_cnt++;
-	mutex_unlock(&encl->lock);
 	return 0;
 }
 
@@ -269,16 +266,11 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	struct file *backing;
 	long ret;
 
-	ret = sgx_encl_grow(encl);
-	if (ret)
-		return ret;
-
 	mutex_lock(&encl->lock);
 
-	if (encl->flags & SGX_ENCL_CREATED) {
-		ret = -EFAULT;
+	ret = sgx_encl_grow(encl, SGX_ENCL_CREATED | SGX_ENCL_DEAD);
+	if (ret)
 		goto err_out_unlock;
-	}
 
 	ssaframesize = sgx_calc_ssaframesize(secs->miscselect, secs->xfrm);
 	if (sgx_validate_secs(secs, ssaframesize)) {
@@ -514,16 +506,11 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 			return ret;
 	}
 
-	ret = sgx_encl_grow(encl);
-	if (ret)
-		return ret;
-
 	mutex_lock(&encl->lock);
 
-	if (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
-		ret = -EFAULT;
+	ret = sgx_encl_grow(encl, SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD);
+	if (ret)
 		goto err_out_unlock;
-	}
 
 	encl_page = sgx_encl_page_alloc(encl, addr, prot);
 	if (IS_ERR(encl_page)) {
-- 
2.22.0

