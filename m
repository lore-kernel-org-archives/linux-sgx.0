Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845D8C5519F
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D976E2222F
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fT+L4yAa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgKLWC3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbgKLWC2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Nov 2020 17:02:28 -0500
Received: from suppilovahvero.lan (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D0A022241;
        Thu, 12 Nov 2020 22:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605218547;
        bh=9M4BC2Cr5Q3zI63yXfmamd5rYGuuJOkwMwhYc6Pak7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fT+L4yAaRwqFS3SOtR6e4aMLNM5+UlpNCByFJPgvZJSGAQcWTfVYSyaamu6gL5/wk
         YQ9epFVxlUdmQs92fYa+hlwCkIZW8eNFi0h1KSJBwV7wPzkQHn4dmkc07vvPcXZJPj
         7J3e3HNAL1a99F1vV+UOw7hwxoY1vPH2dWG3Xc7U=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v41 06/24] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Date:   Fri, 13 Nov 2020 00:01:17 +0200
Message-Id: <20201112220135.165028-7-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112220135.165028-1-jarkko@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The x86 architecture has a set of page fault error codes.  These indicate
things like whether the fault occurred from a write, or whether it
originated in userspace.

The SGX hardware architecture has its own per-page memory management
metadata (EPCM) [*] and hardware which is separate from the normal x86 MMU.
The architecture has a new page fault error code: PF_SGX.  This new error
code bit is set whenever a page fault occurs as the result of the SGX MMU.

These faults occur for a variety of reasons.  For instance, an access
attempt to enclave memory from outside the enclave causes a PF_SGX fault.
PF_SGX would also be set for permission conflicts, such as if a write to an
enclave page occurs and the page is marked read-write in the x86 page
tables but is read-only in the EPCM.

These faults do not always indicate errors, though.  SGX pages are
encrypted with a key that is destroyed at hardware reset, including
suspend. Throwing a SIGSEGV allows user space software to react and recover
when these events occur.

Include PF_SGX in the PF error codes list and throw SIGSEGV when it is
encountered.

[*] Intel SDM: 36.5.1 Enclave Page Cache Map (EPCM)

Acked-by: Jethro Beekman <jethro@fortanix.com> # v40
# Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/include/asm/trap_pf.h |  1 +
 arch/x86/mm/fault.c            | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
index 305bc1214aef..1794777b2a85 100644
--- a/arch/x86/include/asm/trap_pf.h
+++ b/arch/x86/include/asm/trap_pf.h
@@ -19,6 +19,7 @@ enum x86_pf_error_code {
 	X86_PF_RSVD	=		1 << 3,
 	X86_PF_INSTR	=		1 << 4,
 	X86_PF_PK	=		1 << 5,
+	X86_PF_SGX	=		1 << 15,
 };
 
 #endif /* _ASM_X86_TRAP_PF_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 82bf37a5c9ec..9339fee83784 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1101,6 +1101,18 @@ access_error(unsigned long error_code, struct vm_area_struct *vma)
 	if (error_code & X86_PF_PK)
 		return 1;
 
+	/*
+	 * SGX hardware blocked the access.  This usually happens
+	 * when the enclave memory contents have been destroyed, like
+	 * after a suspend/resume cycle. In any case, the kernel can't
+	 * fix the cause of the fault.  Handle the fault as an access
+	 * error even in cases where no actual access violation
+	 * occurred.  This allows userspace to rebuild the enclave in
+	 * response to the signal.
+	 */
+	if (unlikely(error_code & X86_PF_SGX))
+		return 1;
+
 	/*
 	 * Make sure to check the VMA so that we do not perform
 	 * faults just to hit a X86_PF_PK as soon as we fill in a
-- 
2.27.0

