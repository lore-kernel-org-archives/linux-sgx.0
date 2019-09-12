Return-Path: <SRS0=BaFh=XH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309B6C4CEC7
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Sep 2019 19:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 031412084D
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Sep 2019 19:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfILTiv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Sep 2019 15:38:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:33299 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfILTiv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Sep 2019 15:38:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 12:38:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,498,1559545200"; 
   d="scan'208";a="186228684"
Received: from dscaswel-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.53.44])
  by fmsmga007.fm.intel.com with ESMTP; 12 Sep 2019 12:38:46 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 2/2] x86/sgx: Take sgx_ewb() into use
Date:   Thu, 12 Sep 2019 20:38:09 +0100
Message-Id: <20190912193809.29336-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190912193809.29336-1-jarkko.sakkinen@linux.intel.com>
References: <20190912193809.29336-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Take the first step integrating sgx_ewb() i.e. just fill struct
sgx_ewb_context inside __sgx_encl_ewb() and call sgx_ewb(). The 2nd step
isto move resource binding up to the part where the page is picked up to
the reclaiming process.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index e2b978664f9d..4542d47f48a5 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -225,8 +225,7 @@ static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
 			  unsigned int pt)
 {
 	struct sgx_encl_page *encl_page = epc_page->owner;
-	struct sgx_pageinfo pginfo;
-	unsigned long pcmd_offset;
+	struct sgx_ewb_context ctx;
 	struct page *backing;
 	pgoff_t page_index;
 	pgoff_t pcmd_index;
@@ -243,7 +242,6 @@ static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
 		page_index = SGX_ENCL_PAGE_INDEX(encl_page);
 
 	pcmd_index = sgx_pcmd_index(encl, page_index);
-	pcmd_offset = sgx_pcmd_offset(page_index);
 
 	backing = sgx_encl_get_backing_page(encl, page_index);
 	if (IS_ERR(backing)) {
@@ -257,14 +255,14 @@ static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
 		goto err_pcmd;
 	}
 
-	pginfo.addr = 0;
-	pginfo.contents = (unsigned long)kmap_atomic(backing);
-	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
-	pginfo.secs = 0;
-	ret = __ewb(&pginfo, sgx_epc_addr(epc_page),
-		    sgx_epc_addr(va_page->epc_page) + va_offset);
-	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
-	kunmap_atomic((void *)(unsigned long)pginfo.contents);
+	ctx.page = epc_page;
+	ctx.contents = backing;
+	ctx.pcmd = pcmd;
+	ctx.pcmd_offset = sgx_pcmd_offset(page_index);
+	ctx.version_array = va_page->epc_page;
+	ctx.version_offset = va_offset;
+
+	ret = sgx_ewb(&ctx);
 
 	if (!ret) {
 		set_page_dirty(pcmd);
-- 
2.20.1

