Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B93C10F14
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5202F2084D
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbfJHEqQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:8175 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729375AbfJHEqP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566497"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 03/16] x86/vdso: sgx: Rename the enclave exit handler typedef
Date:   Mon,  7 Oct 2019 21:46:00 -0700
Message-Id: <20191008044613.12350-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Rename the exit handler callback to sgx_enclave_exit_handler_t so that
the name itself describes the purpose of the function to some extent.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 06e18a2836de..5fbe07a03e6c 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -53,12 +53,12 @@
  *    -EFAULT if ENCL or the enclave faults or non-positive value is returned
  *     from the callback.
  */
-typedef int (*sgx_callback)(long rdi, long rsi, long rdx, int ret,
-			    long r8, long r9, void *tcs, long ursp,
-			    struct sgx_enclave_exception *e);
+typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx, int ret,
+					  long r8, long r9, void *tcs, long ursp,
+					  struct sgx_enclave_exception *e);
 int __vdso_sgx_enter_enclave(int leaf, void *tcs,
 			     struct sgx_enclave_exception *e,
-			     sgx_callback callback);
+			     sgx_enclave_exit_handler_t handler);
 #endif
 ENTRY(__vdso_sgx_enter_enclave)
 	/* Prolog */
@@ -86,17 +86,17 @@ ENTRY(__vdso_sgx_enter_enclave)
 	xor	%eax, %eax
 3:	mov	%eax, %ecx
 
-	/* Call *callback if supplied */
+	/* Call the exit handler if supplied */
 	mov	0x20(%rbp), %rax
 	test	%rax, %rax
 	jz	7f
 	/* Align stack per x86_64 ABI. The original %rsp is saved in %rbx to be
-	 * restored after *callback returns. */
+	 * restored after the exit handler returns. */
 	mov	%rsp, %rbx
 	and	$-0x10, %rsp
 	/* Clear RFLAGS.DF per x86_64 ABI */
 	cld
-	/* Parameters for *callback */
+	/* Parameters for the exit handler */
 	push	0x18(%rbp)
 	push	%rbx
 	push	0x10(%rbp)
@@ -105,9 +105,9 @@ ENTRY(__vdso_sgx_enter_enclave)
 	/* Restore %rsp to its original value left off by the enclave from last
 	 * exit */
 	mov	%rbx, %rsp
-	/* Positive return value from *callback will be interpreted as an ENCLU
-	 * leaf, while a non-positive value will be interpreted as the return
-	 * value to be passed back to the caller. */
+	/* Positive return value from the exit handler will be interpreted as
+	 * an ENCLU leaf, while a non-positive value will be interpreted as the
+	 * return value to be passed back to the caller. */
 	jmp	1b
 40:	/* retpoline */
 	call	42f
-- 
2.22.0

