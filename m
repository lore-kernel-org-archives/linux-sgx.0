Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8B2C3A5A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 16:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F282622CEC
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 16:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436678AbfHWQRJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 12:17:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:47957 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436675AbfHWQRJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 12:17:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 09:17:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="263231717"
Received: from unknown (HELO localhost) ([10.252.39.229])
  by orsmga001.jf.intel.com with ESMTP; 23 Aug 2019 09:16:35 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 3/4] x86/sgx: Remove a deperecated enum
Date:   Fri, 23 Aug 2019 19:16:15 +0300
Message-Id: <20190823161616.27644-4-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190823161616.27644-1-jarkko.sakkinen@linux.intel.com>
References: <20190823161616.27644-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

&sgx_encl_mm_iter is no longer used for anything.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index cc1f8c4b1472..37b5c4bcda7a 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -109,12 +109,6 @@ static inline unsigned long sgx_pcmd_offset(pgoff_t page_index)
 	       sizeof(struct sgx_pcmd);
 }
 
-enum sgx_encl_mm_iter {
-	SGX_ENCL_MM_ITER_DONE		= 0,
-	SGX_ENCL_MM_ITER_NEXT		= 1,
-	SGX_ENCL_MM_ITER_RESTART	= 2,
-};
-
 int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
 		  struct vm_area_struct **vma);
 void sgx_encl_destroy(struct sgx_encl *encl);
-- 
2.20.1

