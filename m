Return-Path: <SRS0=BaFh=XH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61467C4CEC7
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Sep 2019 19:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33C7F2081B
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Sep 2019 19:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfILTrt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Sep 2019 15:47:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:19814 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbfILTrs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Sep 2019 15:47:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 12:47:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="336682930"
Received: from dscaswel-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.53.44])
  by orsmga004.jf.intel.com with ESMTP; 12 Sep 2019 12:47:44 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RESEND 03/11] x86/sgx: Write backing storage only if EWB is successful
Date:   Thu, 12 Sep 2019 20:47:12 +0100
Message-Id: <20190912194720.7107-4-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190912194720.7107-1-jarkko.sakkinen@linux.intel.com>
References: <20190912194720.7107-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Do not call set_page_dirty() unless the EWB operation is successful.
Probably nothing bad will happen by doing this but it is still an
unnecessary action.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index d82ce1eaa60e..213406756443 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -266,9 +266,12 @@ static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
 	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
-	set_page_dirty(pcmd);
+	if (!ret) {
+		set_page_dirty(pcmd);
+		set_page_dirty(backing);
+	}
+
 	put_page(pcmd);
-	set_page_dirty(backing);
 
 err_pcmd:
 	put_page(backing);
-- 
2.20.1

