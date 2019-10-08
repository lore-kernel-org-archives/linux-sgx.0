Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F437ECE596
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31810206C2
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbfJHEqP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:8175 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfJHEqP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566494"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 02/16] x86/vdso: sgx: Do not use exception info to pass success/failure
Date:   Mon,  7 Oct 2019 21:45:59 -0700
Message-Id: <20191008044613.12350-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Do not overload sgx_enclave_exception.leaf to indicate success vs.
failure, i.e. EEXIT vs. fault.  Instead, explicitly pass what would be
the return value (from __vdso_sgx_enter_enclave()) to userspace's exit
handler.  Passing the return values makes the two flows (exit handler
vs. no exit handler) symmetric and provides the exit handler with a
fault indicator without requiring struct sgx_enclave_exception.

Opportunistically fix the typedef for the callback to reference struct
sgx_enclave_exception instead of the non-existent sgx_enclave_exinfo.

Intentionally leave the local labels out of whack, they'll be cleaned
up in a future patch.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 33 +++++++++++-------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 96726000aa27..06e18a2836de 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -53,11 +53,11 @@
  *    -EFAULT if ENCL or the enclave faults or non-positive value is returned
  *     from the callback.
  */
-typedef int (*sgx_callback)(long rdi, long rsi, long rdx,
-			    struct sgx_enclave_exinfo *exinfo, long r8,
-			    long r9, void *tcs, long ursp);
+typedef int (*sgx_callback)(long rdi, long rsi, long rdx, int ret,
+			    long r8, long r9, void *tcs, long ursp,
+			    struct sgx_enclave_exception *e);
 int __vdso_sgx_enter_enclave(int leaf, void *tcs,
-			     struct sgx_enclave_exinfo *exinfo,
+			     struct sgx_enclave_exception *e,
 			     sgx_callback callback);
 #endif
 ENTRY(__vdso_sgx_enter_enclave)
@@ -83,21 +83,12 @@ ENTRY(__vdso_sgx_enter_enclave)
 2:	enclu
 
 	/* EEXIT path */
-	xor	%ebx, %ebx
-3:	mov	0x18(%rbp), %rcx
-	jrcxz	4f
-	mov	%eax, EX_LEAF(%rcx)
-	jnc	4f
-	mov	%di, EX_TRAPNR(%rcx)
-	mov	%si, EX_ERROR_CODE(%rcx)
-	mov	%rdx, EX_ADDRESS(%rcx)
+	xor	%eax, %eax
+3:	mov	%eax, %ecx
 
-4:	/* Call *callback if supplied */
+	/* Call *callback if supplied */
 	mov	0x20(%rbp), %rax
 	test	%rax, %rax
-	/* At this point, %ebx holds the effective return value, which shall be
-	 * returned if no callback is specified */
-	cmovz	%rbx, %rax
 	jz	7f
 	/* Align stack per x86_64 ABI. The original %rsp is saved in %rbx to be
 	 * restored after *callback returns. */
@@ -106,6 +97,7 @@ ENTRY(__vdso_sgx_enter_enclave)
 	/* Clear RFLAGS.DF per x86_64 ABI */
 	cld
 	/* Parameters for *callback */
+	push	0x18(%rbp)
 	push	%rbx
 	push	0x10(%rbp)
 	/* Call *%rax via retpoline */
@@ -126,8 +118,13 @@ ENTRY(__vdso_sgx_enter_enclave)
 	ret
 
 5:	/* Exception path */
-	mov	$-EFAULT, %ebx
-	stc
+	mov	0x18(%rbp), %rcx
+	jrcxz	52f
+	mov	%eax, EX_LEAF(%rcx)
+	mov	%di,  EX_TRAPNR(%rcx)
+	mov	%si,  EX_ERROR_CODE(%rcx)
+	mov	%rdx, EX_ADDRESS(%rcx)
+52:	mov	$-EFAULT, %eax
 	jmp	3b
 
 6:	/* Unsupported ENCLU leaf */
-- 
2.22.0

