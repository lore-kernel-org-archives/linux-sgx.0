Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7EDC433E5
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 04:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B822078D
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 04:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgHREYI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 00:24:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:16707 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgHREYH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 00:24:07 -0400
IronPort-SDR: vhJGRyaXF6p3kVun5ATvfZxW9T2WkvIgvq9SH8eJQJ3aNGh0RrfkLv8vwFqH8AJ+WiOzlJb0Gb
 u09hBwQ6ioDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="219156473"
X-IronPort-AV: E=Sophos;i="5.76,326,1592895600"; 
   d="scan'208";a="219156473"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 21:24:06 -0700
IronPort-SDR: Eqw73L5KCeigX2R3f2bYGhgglXhiTcLLSfP/SzRHPLdBJ4ruw91GQCrISdMazKQmNDm0G8b/CP
 MF+QHUsur5vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,326,1592895600"; 
   d="scan'208";a="334270264"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Aug 2020 21:24:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [RFC PATCH 1/4] x86/vdso: x86/sgx: Explicitly force 8-byte CMP for detecting user handler
Date:   Mon, 17 Aug 2020 21:24:02 -0700
Message-Id: <20200818042405.12871-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200818042405.12871-1-sean.j.christopherson@intel.com>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use 'cmpq' to force an 8-byte CMP when checking for a user provided exit
handler.  The handler is a pointer, which is guaranteed to be an 8-byte
value since SGX is 64-bit mode only, and gcc defaults to 'cmpl' given a
bare 'cmp', i.e. is only checking the lower 32 bits.  This could cause
a false negative when detecting a user exit handler.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index be7e467e1efb3..2d88acd408d4e 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -48,7 +48,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 
 	/* Invoke userspace's exit handler if one was provided. */
 .Lhandle_exit:
-	cmp	$0, 0x20(%rbp)
+	cmpq	$0, 0x20(%rbp)
 	jne	.Linvoke_userspace_handler
 
 .Lout:
-- 
2.28.0

