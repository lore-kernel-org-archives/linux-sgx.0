Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA36FFA3728
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 00:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C05220872
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 00:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391413AbfJQAF4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 20:05:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:28763 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbfJQAF4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 20:05:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 17:05:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,305,1566889200"; 
   d="scan'208";a="370965127"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 16 Oct 2019 17:05:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>
Subject: [PATCH for_v23 v2 3/3] x86/vdso: sgx: Fix unwinder support, again
Date:   Wed, 16 Oct 2019 17:05:54 -0700
Message-Id: <20191017000554.11927-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191017000554.11927-1-sean.j.christopherson@intel.com>
References: <20191017000554.11927-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move the .cfi_endproc directive back to the end of the function where it
belongs, and instead update the Canonical Frame Address to account for
the out-of-line code running in the pre-leave context, i.e. before the
stack frame is popped.

Reported-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index d36043b99dc6..c6ca6e6031b6 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -113,7 +113,9 @@ ENTRY(__vdso_sgx_enter_enclave)
 	leave
 	.cfi_def_cfa		%rsp, 8
 	ret
-	.cfi_endproc
+
+	/* The out-of-line code runs with the pre-leave stack frame. */
+	.cfi_def_cfa		%rbp, 16
 
 .Linvalid_leaf:
 	mov	$(-EINVAL), %eax
@@ -178,6 +180,7 @@ ENTRY(__vdso_sgx_enter_enclave)
 	jmp	1b
 2:	mov	%rax, (%rsp)
 	ret
+	.cfi_endproc
 
 _ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
 
-- 
2.22.0

