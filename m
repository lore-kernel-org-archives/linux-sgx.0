Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B05ECE598
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 21:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCCB621835
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 21:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfJJVnF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 17:43:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:32755 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbfJJVnE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 17:43:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 14:43:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="194145483"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 10 Oct 2019 14:43:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 3/9] x86/sgx: Fix a memory leak in sgx_encl_destroy()
Date:   Thu, 10 Oct 2019 14:42:55 -0700
Message-Id: <20191010214301.25669-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191010214301.25669-1-sean.j.christopherson@intel.com>
References: <20191010214301.25669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Delete an enclave page's entry in the radix tree regardless of whether
or not it has an associated EPC page.

Note, the reclaimer doesn't need the tree to reclaim EPC pages, i.e.
it's safe to delete the tree entry even if sgx_free_page() fails.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index ea21d3737a32..68ec8944692a 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -468,15 +468,14 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 
 	radix_tree_for_each_slot(slot, &encl->page_tree, &iter, 0) {
 		entry = *slot;
-		if (entry->epc_page) {
-			if (!sgx_free_page(entry->epc_page)) {
-				encl->secs_child_cnt--;
-				entry->epc_page = NULL;
-			}
-
-			radix_tree_delete(&entry->encl->page_tree,
-					  PFN_DOWN(entry->desc));
+		if (entry->epc_page &&
+		    !sgx_free_page(entry->epc_page)) {
+			encl->secs_child_cnt--;
+			entry->epc_page = NULL;
 		}
+
+		radix_tree_delete(&entry->encl->page_tree,
+				  PFN_DOWN(entry->desc));
 	}
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
-- 
2.22.0

