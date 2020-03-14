Return-Path: <SRS0=6AlZ=47=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D5DC10DCE
	for <linux-sgx@archiver.kernel.org>; Sat, 14 Mar 2020 03:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 486AB2074D
	for <linux-sgx@archiver.kernel.org>; Sat, 14 Mar 2020 03:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgCNDay (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 13 Mar 2020 23:30:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:58624 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgCNDay (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 13 Mar 2020 23:30:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Mar 2020 20:30:53 -0700
IronPort-SDR: RsJpAh5vDst8J0O815UZuGaP14477JunOjsvcWN+e8B8ZpVC1UvDt1FalBa6KIQTNf0kyiT6RJ
 3StsXyfZbX6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,551,1574150400"; 
   d="scan'208";a="322965628"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 13 Mar 2020 20:30:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH] x86/sgx: Fix a build error introduced by WARN->ENCLS_WARN conversion
Date:   Fri, 13 Mar 2020 20:30:51 -0700
Message-Id: <20200314033051.32137-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove an unwanted param when invoking ENCLS_WARN on EREMOVE failure.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 9afe5e7d50a6..eb5008c37b64 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -352,7 +352,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 
 	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD) {
 		ret = __eremove(sgx_epc_addr(epc_page));
-		ENCLS_WARN(ret, "EREMOVE returned %d\n", ret);
+		ENCLS_WARN(ret, "EREMOVE returned %d\n");
 	} else {
 		sgx_encl_ewb(epc_page, backing);
 	}
-- 
2.24.1

