Return-Path: <SRS0=PkQm=3M=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137EDC2D0DB
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Jan 2020 13:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F3324676
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Jan 2020 13:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgAWNHw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 Jan 2020 08:07:52 -0500
Received: from mga05.intel.com ([192.55.52.43]:30777 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgAWNHw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 Jan 2020 08:07:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 05:07:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="288153021"
Received: from wkalinsk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.23.16])
  by fmsmga001.fm.intel.com with ESMTP; 23 Jan 2020 05:07:48 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH] x86/sgx: Uncoditionally disallow SGX if MSRs are not writable
Date:   Thu, 23 Jan 2020 15:07:46 +0200
Message-Id: <20200123130746.20377-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

As suggested by Borislav, disallow SGX if the PK MSRs are not writable.

Link: https://patchwork.kernel.org/patch/11267757/#23072371
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
Just a sanity check before merge, please ack that this is what you
wanted.
 arch/x86/kernel/cpu/intel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 06252c82b8f7..0d57e9666de0 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -600,7 +600,7 @@ static void __maybe_unused detect_sgx(struct cpuinfo_x86 *c)
 
 	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
 		pr_info_once("sgx: The launch control MSRs are not writable\n");
-		goto err_msrs_rdonly;
+		goto err_unsupported;
 	}
 
 	return;
@@ -609,8 +609,6 @@ static void __maybe_unused detect_sgx(struct cpuinfo_x86 *c)
 	setup_clear_cpu_cap(X86_FEATURE_SGX);
 	setup_clear_cpu_cap(X86_FEATURE_SGX1);
 	setup_clear_cpu_cap(X86_FEATURE_SGX2);
-
-err_msrs_rdonly:
 	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
 }
 
-- 
2.20.1

