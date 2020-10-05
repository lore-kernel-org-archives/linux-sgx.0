Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 606FAC4363D
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 03:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FE5D2072D
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 03:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgJEDUC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 23:20:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:9180 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgJEDUC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Oct 2020 23:20:02 -0400
IronPort-SDR: 2VombcV56z2vWIYOSLC/oOcInG5++iNr1zQ+Zru3YFVnhuru/nCj9ZTid8gQw+GCMRl1Ggekbo
 ivX6s8pYPo+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="164171623"
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="164171623"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:20:01 -0700
IronPort-SDR: IcOkf4v5NgI2Mv6Wc86tkrocUmAWq9UjrlfziOuBpt1xVeydhKCAKz69WjmMM5oIK6ys8b2t9Q
 YWSucD5G94zA==
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="459314594"
Received: from sidorovd-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.48.68])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:19:59 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v2] x86/sgx: Fix sgx_encl_may_map locking
Date:   Mon,  5 Oct 2020 06:19:54 +0300
Message-Id: <20201005031954.144239-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Fix the issue further discussed in:

1. https://lore.kernel.org/linux-sgx/op.0rwbv916wjvjmi@mqcpg7oapc828.gar.corp.intel.com/
2. https://lore.kernel.org/linux-sgx/20201003195440.GD20115@casper.infradead.org/

Use the approach suggested by Matthew, and supported by the analysis
that I wrote:

https://lore.kernel.org/linux-sgx/20201005030619.GA126283@linux.intel.com/

Reported-by: Haitao Huang <haitao.huang@linux.intel.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Jethro Beekman <jethro@fortanix.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 4c6407cd857a..2bb3ec6996e9 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -307,6 +307,7 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 	unsigned long idx_start = PFN_DOWN(start);
 	unsigned long idx_end = PFN_DOWN(end - 1);
 	struct sgx_encl_page *page;
+	unsigned long count = 0;
 
 	XA_STATE(xas, &encl->page_array, idx_start);
 
@@ -317,10 +318,31 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 	if (current->personality & READ_IMPLIES_EXEC)
 		return -EACCES;
 
-	xas_for_each(&xas, page, idx_end)
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
+
+		xas_pause(&xas);
+		xas_unlock(&xas);
+
+		/*
+		 * Attributes are not protected by the xa_lock, so I'm assuming
+		 * that this is the legit place for the check.
+		 */
 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
 			return -EACCES;
 
+		cond_resched();
+		xas_lock(&xas);
+	}
+
 	return 0;
 }
 
-- 
2.25.1

