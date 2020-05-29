Return-Path: <SRS0=RnOm=7L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988CDC433E4
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77BDA206E2
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgE2RyN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 May 2020 13:54:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:51589 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgE2RyM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 29 May 2020 13:54:12 -0400
IronPort-SDR: E+DYVhe9BbToVfahedcTNwERMQTkTI42UrVojN4gvy2VmwEp57HzYU9JA+2W8XKLXIrpWco5Q1
 KpHpvyjPcVeg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:54:09 -0700
IronPort-SDR: 82hgiKg5LAZ+OT+xGpu6aHO93KSAa+lgTgFB+pBZzMPIogjY9Qy5wPUXgNds1MjsPPXCs8zxkO
 xk7H0PiPjUFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="271292333"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 29 May 2020 10:54:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v31 5/6] x86/sgx: Update stale comment in EPC page allocators
Date:   Fri, 29 May 2020 10:54:06 -0700
Message-Id: <20200529175407.2109-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200529175407.2109-1-sean.j.christopherson@intel.com>
References: <20200529175407.2109-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Replace "Grab" with "Allocate" in the function comments for the EPC page
allocators.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 855b14237e7c4..ba5486a1ef6f4 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -505,7 +505,7 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_sec
 }
 
 /**
- * __sgx_alloc_epc_page() - Grab a free EPC page
+ * __sgx_alloc_epc_page() - Allocate a free EPC page
  *
  * Iterate through EPC sections and borrow a free EPC page to the caller. When a
  * page is no longer needed it must be released with sgx_free_epc_page().
@@ -534,7 +534,7 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 }
 
 /**
- * sgx_alloc_epc_page() - Grab a free EPC page
+ * sgx_alloc_epc_page() - Allocate a free EPC page
  * @owner:	the owner of the EPC page
  * @reclaim:	reclaim pages if necessary
  *
-- 
2.26.0

