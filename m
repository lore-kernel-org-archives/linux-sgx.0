Return-Path: <SRS0=9G3N=2L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C576CC2D0C8
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C2C620866
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLUAb7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Dec 2019 19:31:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:9724 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfLUAb7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Dec 2019 19:31:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 16:31:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,337,1571727600"; 
   d="scan'208";a="267658122"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Dec 2019 16:31:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25 2/4] x86/sgx: Use goto to handle sgx_encl_get_backing() failure in SECS flows
Date:   Fri, 20 Dec 2019 16:31:54 -0800
Message-Id: <20191221003156.27236-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221003156.27236-1-sean.j.christopherson@intel.com>
References: <20191221003156.27236-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use a goto for the SECS backing error path in sgx_reclaimer_write() so
that the happy path is a straight shot, e.g. to make it obvious that the
backing is not being leaked.  Reducing the indentation also eliminates a
line wrap.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I could go either way on this patch, included it in case you have a
preference.

 arch/x86/kernel/cpu/sgx/reclaim.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 67bda5528625..c5c0ba92ab63 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -355,18 +355,19 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 		} else if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) {
 			ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
 						   &secs_backing);
-			if (!ret) {
-				sgx_encl_ewb(encl->secs.epc_page,
-					     &secs_backing);
+			if (ret)
+				goto out;
 
-				sgx_free_page(encl->secs.epc_page);
-				encl->secs.epc_page = NULL;
+			sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
 
-				sgx_encl_put_backing(&secs_backing, true);
-			}
+			sgx_free_page(encl->secs.epc_page);
+			encl->secs.epc_page = NULL;
+
+			sgx_encl_put_backing(&secs_backing, true);
 		}
 	}
 
+out:
 	mutex_unlock(&encl->lock);
 }
 
-- 
2.24.1

