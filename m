Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18DFC4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 14:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66207207F7
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 14:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgJEOLY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 10:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgJEOLY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 10:11:24 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14155205F4;
        Mon,  5 Oct 2020 14:11:22 +0000 (UTC)
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v3] x86/sgx: Fix sgx_encl_may_map locking
Date:   Mon,  5 Oct 2020 17:11:19 +0300
Message-Id: <20201005141119.5395-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Fix the issue further discussed in:

1. https://lore.kernel.org/linux-sgx/op.0rwbv916wjvjmi@mqcpg7oapc828.gar.corp.intel.com/
2. https://lore.kernel.org/linux-sgx/20201003195440.GD20115@casper.infradead.org/

Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Jethro Beekman <jethro@fortanix.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
v3:
* Added the missing unlock pointed out by Matthew.
* Tested with the correct patch (last time had v1 applied)
* I don't know what happened to v2 changelog, checked from patchwork
  and it wasn't there. Hope this is not scraped.
 arch/x86/kernel/cpu/sgx/encl.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 4c6407cd857a..e91e521b03a8 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -307,6 +307,8 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 	unsigned long idx_start = PFN_DOWN(start);
 	unsigned long idx_end = PFN_DOWN(end - 1);
 	struct sgx_encl_page *page;
+	unsigned long count = 0;
+	int ret = 0;
 
 	XA_STATE(xas, &encl->page_array, idx_start);
 
@@ -317,11 +319,30 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 	if (current->personality & READ_IMPLIES_EXEC)
 		return -EACCES;
 
-	xas_for_each(&xas, page, idx_end)
-		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
-			return -EACCES;
+	/*
+	 * No need to hold encl->lock:
+	 * 1. None of the page->* get written.
+	 * 2. page->vm_max_prot_bits is set in sgx_encl_page_alloc(). This
+	 *    is before calling xa_insert(). After that it is never modified.
+	 */
+	xas_lock(&xas);
+	xas_for_each(&xas, page, idx_end) {
+		if (++count % XA_CHECK_SCHED)
+			continue;
 
-	return 0;
+		if (!page || (~page->vm_max_prot_bits & vm_prot_bits)) {
+			ret = -EACCES;
+			break;
+		}
+
+		xas_pause(&xas);
+		xas_unlock(&xas);
+		cond_resched();
+		xas_lock(&xas);
+	}
+	xas_unlock(&xas);
+
+	return ret;
 }
 
 static int sgx_vma_mprotect(struct vm_area_struct *vma,
-- 
2.25.1

