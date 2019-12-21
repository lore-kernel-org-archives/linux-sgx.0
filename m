Return-Path: <SRS0=9G3N=2L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D109C2D0D2
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B09E2146E
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfLUAb7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Dec 2019 19:31:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:9723 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbfLUAb7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Dec 2019 19:31:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 16:31:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,337,1571727600"; 
   d="scan'208";a="267658118"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Dec 2019 16:31:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25 1/4] x86/sgx: Put SECS backing iff retrieving the backing succeeds
Date:   Fri, 20 Dec 2019 16:31:53 -0800
Message-Id: <20191221003156.27236-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221003156.27236-1-sean.j.christopherson@intel.com>
References: <20191221003156.27236-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Put the SECS backing if and only if retrieving the backing succeeded,
otherwise sgx_encl_put_backing() will consume uninitialized pointers.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 21fbfe2ed9c4..67bda5528625 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -361,9 +361,9 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 
 				sgx_free_page(encl->secs.epc_page);
 				encl->secs.epc_page = NULL;
+
+				sgx_encl_put_backing(&secs_backing, true);
 			}
-
-			sgx_encl_put_backing(&secs_backing, true);
 		}
 	}
 
-- 
2.24.1

