Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C13C31E4B
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1C2E20673
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbfFMQmr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:42:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:12201 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfFMQmq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 12:42:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 09:42:46 -0700
X-ExtLoop1: 1
Received: from gengelha-mobl.ger.corp.intel.com (HELO localhost) ([10.249.32.179])
  by orsmga003.jf.intel.com with ESMTP; 13 Jun 2019 09:42:43 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH RFC] x86/sgx: Check that the address is within ELRANGE
Date:   Thu, 13 Jun 2019 19:42:40 +0300
Message-Id: <20190613164240.31326-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In sgx_encl_page_alloc() check that the given address within the
ELRANGE. Return -EINVAL if not.

Reported-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index d17c60dca114..9d3fc770b4d9 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -240,19 +240,26 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 	struct sgx_encl_page *encl_page;
 	int ret;
 
+	if (addr < encl->base || addr > (encl->base + encl->size))
+		return ERR_PTR(-EINVAL);
+
 	if (radix_tree_lookup(&encl->page_tree, PFN_DOWN(addr)))
 		return ERR_PTR(-EEXIST);
+
 	encl_page = kzalloc(sizeof(*encl_page), GFP_KERNEL);
 	if (!encl_page)
 		return ERR_PTR(-ENOMEM);
+
 	encl_page->desc = addr;
 	encl_page->encl = encl;
+
 	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
 				encl_page);
 	if (ret) {
 		kfree(encl_page);
 		return ERR_PTR(ret);
 	}
+
 	return encl_page;
 }
 
-- 
2.20.1

