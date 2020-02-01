Return-Path: <SRS0=7EJM=3V=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD90C3F68F
	for <linux-sgx@archiver.kernel.org>; Sat,  1 Feb 2020 17:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3038B20679
	for <linux-sgx@archiver.kernel.org>; Sat,  1 Feb 2020 17:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgBARtn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 1 Feb 2020 12:49:43 -0500
Received: from mga17.intel.com ([192.55.52.151]:64397 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgBARtm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 1 Feb 2020 12:49:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 09:49:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="429034034"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2020 09:49:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25 2/3] x86/msr: Fixup "Intel SGX Launch Control hardware bits"
Date:   Sat,  1 Feb 2020 09:49:39 -0800
Message-Id: <20200201174940.20984-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201174940.20984-1-sean.j.christopherson@intel.com>
References: <20200201174940.20984-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Fix the Feature Control MSR bit definition for SGX LC that got borked
during the rebase to the latest upstream.

Note, the name diverges from what was previously used in the SGX series.
The decision made by/with Boris was to follow the SDM names.

Fixes: 24670c2036be ("x86/cpufeatures: x86/msr: Intel SGX Launch Control hardware bits")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ddc6336aaa2..a0776c262820 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -564,6 +564,7 @@
 #define FEAT_CTL_LOCKED				BIT(0)
 #define FEAT_CTL_VMX_ENABLED_INSIDE_SMX		BIT(1)
 #define FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX	BIT(2)
+#define FEAT_CTL_SGX_LC_ENABLED			BIT(17)
 #define FEAT_CTL_SGX_ENABLED			BIT(18)
 #define FEAT_CTL_LMCE_ENABLED			BIT(20)
 
-- 
2.24.1

