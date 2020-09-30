Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE3BC4727E
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 14:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A7042076B
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 14:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgI3OBP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 10:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbgI3OBO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Sep 2020 10:01:14 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 940B520754;
        Wed, 30 Sep 2020 14:01:13 +0000 (UTC)
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
Subject: [PATCH] x86/vdso: Remove retpoline from SGX vDSO call
Date:   Wed, 30 Sep 2020 17:01:08 +0300
Message-Id: <20200930140108.48075-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The user handler, which can be optionally used to handle enclave
exceptions, is always the same global handler provided by the SGX
runtime, who wants to use such a handler instead returning on exception.

Thus, there is no any non-deterministic branch prediction happening.
The code path is always the same and never change. Obviously, you could
change it all the time purposely but for any sane real-world use that
would not make any sense.

Thus, remove retpoline wrapping.

Cc: x86@kernel.org
Cc: Haitao Huang <haitao.huang@linux.intel.com>
CC: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/entry/vdso/vsgx.S | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx.S b/arch/x86/entry/vdso/vsgx.S
index 8f8190ab9ed5..5f65bb22014f 100644
--- a/arch/x86/entry/vdso/vsgx.S
+++ b/arch/x86/entry/vdso/vsgx.S
@@ -129,7 +129,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 
 	/* Load the callback pointer to %rax and invoke it via retpoline. */
 	mov	SGX_ENCLAVE_RUN_USER_HANDLER(%rax), %rax
-	call	.Lretpoline
+	call	*%rax
 
 	/* Undo the post-exit %rsp adjustment. */
 	lea	0x10(%rsp, %rbx), %rsp
@@ -143,13 +143,6 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	jle	.Lout
 	jmp	.Lenter_enclave
 
-.Lretpoline:
-	call	2f
-1:	pause
-	lfence
-	jmp	1b
-2:	mov	%rax, (%rsp)
-	ret
 	.cfi_endproc
 
 _ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
-- 
2.25.1

