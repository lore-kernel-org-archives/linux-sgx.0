Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03960ECE599
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 23:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD3F32190F
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 23:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfJJXVL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 19:21:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:34956 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbfJJXVL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 19:21:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 16:21:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="207300640"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 10 Oct 2019 16:21:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 v2 7/9] x86/sgx: Use the post-reclaim variant of __sgx_free_page()
Date:   Thu, 10 Oct 2019 16:21:06 -0700
Message-Id: <20191010232108.27075-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191010232108.27075-1-sean.j.christopherson@intel.com>
References: <20191010232108.27075-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use __sgx_free_page() in all locations where the EPC page is supposed to
be unreclaimable so that a WARN fires if the page is unexpectedly marked
for reclaim.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c    | 8 ++++----
 arch/x86/kernel/cpu/sgx/ioctl.c   | 6 +++---
 arch/x86/kernel/cpu/sgx/reclaim.c | 4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index c1d2df186b2d..1fa990d48ee2 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -73,7 +73,7 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
 
 	ret = __sgx_encl_eldu(encl_page, epc_page, secs_page);
 	if (ret) {
-		sgx_free_page(epc_page);
+		__sgx_free_page(epc_page);
 		return ERR_PTR(ret);
 	}
 
@@ -485,7 +485,7 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 	}
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
-		sgx_free_page(encl->secs.epc_page);
+		__sgx_free_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
 
@@ -498,7 +498,7 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
-		sgx_free_page(va_page->epc_page);
+		__sgx_free_page(va_page->epc_page);
 		kfree(va_page);
 	}
 }
@@ -693,7 +693,7 @@ struct sgx_epc_page *sgx_alloc_va_page(void)
 	ret = __epa(sgx_epc_addr(epc_page));
 	if (ret) {
 		WARN_ONCE(1, "EPA returned %d (0x%x)", ret, ret);
-		sgx_free_page(epc_page);
+		__sgx_free_page(epc_page);
 		return ERR_PTR(-EFAULT);
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index eeed919ed3e2..7a6bc3bf8f8c 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -47,7 +47,7 @@ static void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
 	encl->page_cnt--;
 
 	if (va_page) {
-		sgx_free_page(va_page->epc_page);
+		__sgx_free_page(va_page->epc_page);
 		list_del(&va_page->list);
 		kfree(va_page);
 	}
@@ -220,7 +220,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	return 0;
 
 err_out:
-	sgx_free_page(encl->secs.epc_page);
+	__sgx_free_page(encl->secs.epc_page);
 	encl->secs.epc_page = NULL;
 
 err_out_backing:
@@ -441,7 +441,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 	up_read(&current->mm->mmap_sem);
 
 err_out_free:
-	sgx_free_page(epc_page);
+	__sgx_free_page(epc_page);
 	kfree(encl_page);
 
 	return ret;
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 8143c9a20894..3f183dd0e653 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -323,7 +323,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 
 	if (!encl->secs_child_cnt) {
 		if (atomic_read(&encl->flags) & SGX_ENCL_DEAD) {
-			sgx_free_page(encl->secs.epc_page);
+			__sgx_free_page(encl->secs.epc_page);
 			encl->secs.epc_page = NULL;
 		} else if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) {
 			ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
@@ -331,7 +331,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 			if (!ret) {
 				sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
 
-				sgx_free_page(encl->secs.epc_page);
+				__sgx_free_page(encl->secs.epc_page);
 				encl->secs.epc_page = NULL;
 			}
 
-- 
2.22.0

