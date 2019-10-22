Return-Path: <SRS0=OrTC=YP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8CAC47E49
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 22:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E8952075A
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Oct 2019 22:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389590AbfJVWtX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Oct 2019 18:49:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:58904 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731185AbfJVWtX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Oct 2019 18:49:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 15:49:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,218,1569308400"; 
   d="scan'208";a="372690700"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 22 Oct 2019 15:49:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 1/3] x86/sgx: Update the free page count in a single operation
Date:   Tue, 22 Oct 2019 15:49:20 -0700
Message-Id: <20191022224922.28144-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022224922.28144-1-sean.j.christopherson@intel.com>
References: <20191022224922.28144-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use atomic_add() instead of running atomic_inc() in a loop to manually
do the equivalent addition.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 499a9b0740c8..d45bf6fca0c8 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -195,8 +195,7 @@ static bool __init sgx_alloc_epc_section(u64 addr, u64 size,
 		list_add_tail(&page->list, &section->unsanitized_page_list);
 	}
 
-	for (i = 0; i < nr_pages; i++)
-		atomic_inc(&sgx_nr_free_pages);
+	atomic_add(nr_pages, &sgx_nr_free_pages);
 
 	return true;
 
-- 
2.22.0

