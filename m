Return-Path: <SRS0=WfLj=WR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FB2C3A59E
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Aug 2019 23:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EE862339E
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Aug 2019 23:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfHUX3L (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 19:29:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:20495 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbfHUX3L (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 19:29:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 16:29:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,414,1559545200"; 
   d="scan'208";a="354095483"
Received: from soegtrop-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.52.79])
  by orsmga005.jf.intel.com with ESMTP; 21 Aug 2019 16:29:08 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 1/2] x86/sgx: Remove duplicate check for entry->epc_page in sgx_encl_load_page()
Date:   Thu, 22 Aug 2019 02:29:01 +0300
Message-Id: <20190821232902.29476-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190821232902.29476-1-jarkko.sakkinen@linux.intel.com>
References: <20190821232902.29476-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The existence of the page is checked first hand for legit race
conditions (either two or more concurrent threads running the #PF
handler or the reclaimer has taken over the page):

/* Page is already resident in the EPC. */
if (entry->epc_page) {
	if (entry->desc & SGX_ENCL_PAGE_RECLAIMED)
		return ERR_PTR(-EBUSY);

	return entry;
}

After that the existence is a checked as a condition for ELDU.

This commit removes the redundant check.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index a20d498e9dcd..d6397f7ef3b8 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -123,7 +123,7 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 			return ERR_CAST(epc_page);
 	}
 
-	epc_page = entry->epc_page ? entry->epc_page : sgx_encl_eldu(entry);
+	epc_page = sgx_encl_eldu(entry);
 	if (IS_ERR(epc_page))
 		return ERR_CAST(epc_page);
 
-- 
2.20.1

