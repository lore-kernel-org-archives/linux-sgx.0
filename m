Return-Path: <SRS0=btYB=YX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5A8CA9EC5
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Oct 2019 10:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D108D20663
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Oct 2019 10:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfJ3Kvj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Oct 2019 06:51:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:39472 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbfJ3Kvj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Oct 2019 06:51:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 03:51:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,247,1569308400"; 
   d="scan'208";a="193930355"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 30 Oct 2019 03:51:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v24] x86/sgx: Mark all regular and TCS pages as reclaimable
Date:   Wed, 30 Oct 2019 03:51:38 -0700
Message-Id: <20191030105138.13509-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Mark all EADDed pages as reclaimable, not just those that are measured.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 5b82670bb79a..5b28a9c0cb68 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -427,12 +427,20 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 
 	if (addp->flags & SGX_PAGE_MEASURE) {
 		ret = __sgx_encl_extend(encl, epc_page);
-		if (ret)
+
+		/*
+		 * Destroy the enclave if EEXTEND fails, EADD can't be undone.
+		 * Note, destroy() also frees the resources for the added page.
+		 */
+		if (ret) {
 			sgx_encl_destroy(encl);
-		else
-			sgx_mark_page_reclaimable(encl_page->epc_page);
+			goto out_unlock;
+		}
 	}
 
+	sgx_mark_page_reclaimable(encl_page->epc_page);
+
+out_unlock:
 	mutex_unlock(&encl->lock);
 	up_read(&current->mm->mmap_sem);
 	return ret;
-- 
2.22.0

