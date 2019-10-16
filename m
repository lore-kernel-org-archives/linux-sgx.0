Return-Path: <SRS0=tCn0=YJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C970FA372A
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 18:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBBCB21D7E
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 18:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394285AbfJPSht (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:37:49 -0400
Received: from mga04.intel.com ([192.55.52.120]:46169 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394264AbfJPSht (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 14:37:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 11:37:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="397258429"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 16 Oct 2019 11:37:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 v3 06/12] x86/sgx: Fix a memory leak in sgx_encl_destroy()
Date:   Wed, 16 Oct 2019 11:37:39 -0700
Message-Id: <20191016183745.8226-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191016183745.8226-1-sean.j.christopherson@intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Delete an enclave page's entry in the radix tree regardless of whether
or not it has an associated EPC page, and free the page itself when it's
deleted from the radix tree.

Don't free/delete anything if the page is held by the reclaimer, as the
reclaimer needs the page itself and the driver needs the radix entry to
re-process the entry during sgx_encl_release().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ae81cd7cd8a8..6e60520a939c 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -469,14 +469,19 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 	radix_tree_for_each_slot(slot, &encl->page_tree, &iter, 0) {
 		entry = *slot;
 		if (entry->epc_page) {
-			if (!sgx_free_page(entry->epc_page)) {
-				encl->secs_child_cnt--;
-				entry->epc_page = NULL;
-			}
-
-			radix_tree_delete(&entry->encl->page_tree,
-					  PFN_DOWN(entry->desc));
+			/*
+			 * The page and its radix tree entry cannot be freed
+			 * if the page is being held by the reclaimer.
+			 */
+			if (sgx_free_page(entry->epc_page))
+				continue;
+			encl->secs_child_cnt--;
+			entry->epc_page = NULL;
 		}
+
+		radix_tree_delete(&entry->encl->page_tree,
+				  PFN_DOWN(entry->desc));
+		kfree(entry);
 	}
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
-- 
2.22.0

