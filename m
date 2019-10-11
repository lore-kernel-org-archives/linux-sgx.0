Return-Path: <SRS0=gA9u=YE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC52ECE598
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43C132053B
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Oct 2019 00:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfJKAlD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 20:41:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:44340 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfJKAlC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 20:41:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 17:41:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,282,1566889200"; 
   d="scan'208";a="198542999"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 10 Oct 2019 17:41:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 4/5] x86/vdso: sgx: Reorder params to callback to improve readability
Date:   Thu, 10 Oct 2019 17:40:58 -0700
Message-Id: <20191011004059.28581-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191011004059.28581-1-sean.j.christopherson@intel.com>
References: <20191011004059.28581-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Swap @ret and @ursp in the callback prototype so that the output from
the vDSO itself, @ret and @e, are grouped together.  Having the first
N parameters all share a type also makes the prototype easier to parse
by (some) humans.  And, passing @ursp via register saves one whole
MOV instruction!

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 16 +++++++---------
 arch/x86/include/uapi/asm/sgx.h          | 10 +++++-----
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 3dd22780b7ef..94f613b53b13 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -134,23 +134,21 @@ ENTRY(__vdso_sgx_enter_enclave)
 	jmp	.Lhandle_exit
 
 .Linvoke_userspace_handler:
+	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
+	mov	%rsp, %rcx
+
 	/*
-	 * Align stack per x86_64 ABI. Save the original %rsp in %rbx to be
-	 * restored after the callback returns.  Note, %rsp needs to be 16-byte
-	 * aligned _after_ pushing the three parameters on the stack.
+	 * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned
+	 * _after_ pushing the three parameters on the stack.
 	 */
-	mov	%rsp, %rbx
 	and	$-0x10, %rsp
 	sub	$0x8, %rsp
 
-	/* Push @e, u_rsp and @tcs as parameters to the callback. */
+	/* Push @e, the "return" value and @tcs as params to the callback. */
 	push	0x18(%rbp)
-	push	%rbx
+	push	%rax
 	push	0x10(%rbp)
 
-	/* Pass the "return" value to the callback via %rcx. */
-	mov	%eax, %ecx
-
 	/* Clear RFLAGS.DF per x86_64 ABI */
 	cld
 
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 255392f5054f..95f69f938b58 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -88,16 +88,16 @@ struct sgx_enclave_exception {
  * @rdi:	RDI at the time of enclave exit
  * @rsi:	RSI at the time of enclave exit
  * @rdx:	RDX at the time of enclave exit
- * @ret:	0 on success (EEXIT), -EFAULT on an exception
+ * @ursp:	RSP at the time of enclave exit (untrusted stack)
  * @r8:		R8 at the time of enclave exit
  * @r9:		R9 at the time of enclave exit
  * @tcs:	Thread Control Structure used to enter enclave
- * @ursp:	RSP at the time of enclave exit
+ * @ret:	0 on success (EEXIT), -EFAULT on an exception
  * @e:		Pointer to struct sgx_enclave_exception (as provided by caller)
  */
-typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx, int ret,
-					  long r8, long r9, void *tcs,
-					  long ursp,
+typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
+					  long ursp, long r8, long r9,
+					  void *tcs, int ret,
 					  struct sgx_enclave_exception *e);
 
 #endif /* _UAPI_ASM_X86_SGX_H */
-- 
2.22.0

