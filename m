Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF29C433FF
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB818217D7
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389044AbfHHANA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 20:13:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:51237 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730459AbfHHANA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 20:13:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 17:12:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="165519345"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 07 Aug 2019 17:12:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH for_v22 01/11] x86/sgx: Fix an SECS collision with enclave page at VA=0
Date:   Wed,  7 Aug 2019 17:12:44 -0700
Message-Id: <20190808001254.11926-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808001254.11926-1-sean.j.christopherson@intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Detect the SECS in paging related flows by explicitly checking the page
against the enclave's SECS page.  Assuming a page with VA=0 is the SECS
will break enclaves that actually use VA=0, which is extremely unlikely
but theoretically possible.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 909af9a664f0..6da1c36a01e6 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -12,10 +12,14 @@
 #include "encls.h"
 #include "sgx.h"
 
+static bool sgx_encl_is_secs(struct sgx_encl *encl, struct sgx_encl_page *page)
+{
+	return page == &encl->secs;
+}
+
 static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 			   struct sgx_epc_page *epc_page)
 {
-	unsigned long addr = SGX_ENCL_PAGE_ADDR(encl_page);
 	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
 	struct sgx_encl *encl = encl_page->encl;
 	pgoff_t page_index = sgx_encl_get_index(encl, encl_page);
@@ -38,11 +42,11 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 		goto err_pcmd;
 	}
 
-	pginfo.addr = addr;
+	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
 	pginfo.contents = (unsigned long)kmap_atomic(backing);
 	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
-	pginfo.secs = addr ? (unsigned long)sgx_epc_addr(encl->secs.epc_page) :
-		      0;
+	pginfo.secs = sgx_encl_is_secs(encl, encl_page) ? 0 :
+			(unsigned long)sgx_epc_addr(encl->secs.epc_page);
 
 	ret = __eldu(&pginfo, sgx_epc_addr(epc_page),
 		     sgx_epc_addr(encl_page->va_page->epc_page) + va_offset);
@@ -546,7 +550,7 @@ void sgx_encl_release(struct kref *ref)
  */
 pgoff_t sgx_encl_get_index(struct sgx_encl *encl, struct sgx_encl_page *page)
 {
-	if (!PFN_DOWN(page->desc))
+	if (sgx_encl_is_secs(encl, page))
 		return PFN_DOWN(encl->size);
 
 	return PFN_DOWN(page->desc - encl->base);
-- 
2.22.0

