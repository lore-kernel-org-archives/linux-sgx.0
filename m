Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6938C3A5A4
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 21:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C01C221019
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 21:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393025AbfHWVwj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 17:52:39 -0400
Received: from mga04.intel.com ([192.55.52.120]:26979 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727260AbfHWVwj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 17:52:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 14:52:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="203896861"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 23 Aug 2019 14:52:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH 1/3] x86/sgx: Tweak Kconfig help section according to checkpatch
Date:   Fri, 23 Aug 2019 14:52:34 -0700
Message-Id: <20190823215236.8081-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190823215236.8081-1-sean.j.christopherson@intel.com>
References: <20190823215236.8081-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Replace ---help--- with help as suggested by checkpatch.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eac03f448b59..2a8988aaa074 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1939,7 +1939,7 @@ config INTEL_SGX
 	depends on X86_64 && CPU_SUP_INTEL
 	select SRCU
 	select MMU_NOTIFIER
-	---help---
+	help
 	  Intel(R) SGX is a set of CPU instructions that can be used by
 	  applications to set aside private regions of code and data, referred
 	  to as enclaves. An enclave's private memory can only be accessed by
-- 
2.22.0

