Return-Path: <SRS0=RnOm=7L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD140C433E5
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE5412073B
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgE2RyN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 May 2020 13:54:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:51592 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbgE2RyN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 29 May 2020 13:54:13 -0400
IronPort-SDR: jRCJmU2qO7sviZXULxoV996sVLReRtT5+0LNPi5YbD2py4QIF6dIRRu1EVKcOQGR+8nUFdHTbo
 zG2A+Gzl3UFQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:54:09 -0700
IronPort-SDR: u+wC8a5T5Zh/zsfQMRMaUdA9fQXjp4j+RtJTu+bHI9l7Zadlj+gFqc8v+A3jp6jFWbgzWNV2wJ
 G/UjrJehCzXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="271292330"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 29 May 2020 10:54:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v31 4/6] x86/sgx: Replace "grab" with "alloc" in VA page helper
Date:   Fri, 29 May 2020 10:54:05 -0700
Message-Id: <20200529175407.2109-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200529175407.2109-1-sean.j.christopherson@intel.com>
References: <20200529175407.2109-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Rename sgx_grab_va_page() to sgx_alloc_va_page() to align with
sgx_alloc_epc_page() as well as sgx_free_epc_page(); the latter is used
directly when freeing the VA page, i.e. the names should be consistent.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c  | 6 +++---
 arch/x86/kernel/cpu/sgx/encl.h  | 2 +-
 arch/x86/kernel/cpu/sgx/ioctl.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index e9d72f05a1f12..df4ae76dd83f6 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -686,15 +686,15 @@ struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
 }
 
 /**
- * sgx_grab_va_page() - Grab a Version Array (VA) page
+ * sgx_alloc_va_page() - Allocate a Version Array (VA) page
  *
- * Grab a free EPC page instance and convert it to a Version Array (VA) page.
+ * Allocate a free EPC page and convert it to a Version Array (VA) page.
  *
  * Return:
  *   a VA page,
  *   -errno otherwise
  */
-struct sgx_epc_page *sgx_grab_va_page(void)
+struct sgx_epc_page *sgx_alloc_va_page(void)
 {
 	struct sgx_epc_page *epc_page;
 	int ret;
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 625ad44a83215..f0f72e5912445 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -120,7 +120,7 @@ int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
 					    unsigned long addr);
 
-struct sgx_epc_page *sgx_grab_va_page(void);
+struct sgx_epc_page *sgx_alloc_va_page(void);
 unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
 void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
 bool sgx_va_page_full(struct sgx_va_page *va_page);
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index f7232a5343262..4f70cb8144ffd 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -32,7 +32,7 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 		if (!va_page)
 			return ERR_PTR(-ENOMEM);
 
-		va_page->epc_page = sgx_grab_va_page();
+		va_page->epc_page = sgx_alloc_va_page();
 		if (IS_ERR(va_page->epc_page)) {
 			err = ERR_CAST(va_page->epc_page);
 			kfree(va_page);
-- 
2.26.0

