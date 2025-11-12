Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E732C11E3;
	Wed, 12 Nov 2025 04:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762922331; cv=none; b=NZz66zOdW5Wbc7O6wB0B0ht1gBzncrvxwKWKHbbadgRCMeWOpHkhYMAt23t0ivy3R0UxO2JuXjPw1bbG0ANAXr1xEaaM7GeJNrDwcgZV7xe9WpxmahVNkP2CY9UiDsdPr/UPGWTLgLoQQuJ7s/+ht6cVV1bpiL192YzrKz9l6q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762922331; c=relaxed/simple;
	bh=W6pNYOImVPc9ZcljaYLlQUxzzHpTDnx/6KKkwpZzaXU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJDvLVrlLJW4nXgToOK7wScais0MQfePkwzwlNHzmOyPRz4SzhcSmsyr7981TcQr5oCj45yxS8j6jc8LbY3R9OJnj/lt7oUTPeiqKvfShroMMlJUHnqxY2VlaASOBAew5b+8L1uPTwnPSlRfUA8THV/z3ZykVZwSMP15JqlP5rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=jEcrnhOd; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="jEcrnhOd"
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AC4bYDQ542538
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 11 Nov 2025 20:37:42 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AC4bYDQ542538
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762922264;
	bh=dIA/jdXg8XhpF5qFcJkcp8Nfo/i/kNxnm5Fq/ADnXoU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jEcrnhOdpe8Ixmh0q49w9KDD0kroYtcUNitFGnm9RfGXtf5qBhYZseIDzUBYHEH7x
	 tIYuW1a/9fzwcnF80UT+skupeoK4R+vEL46PAJkVkzx7jzmq3eusoWzR7cHxJXhE6x
	 w6+ly7WKRU0Tq67PBUlNzgqZhbBzpR6AAgAVQB7/PXAPqI0ZKZG4HiAlth2Zkz+lyc
	 plLtmlM9V4IqVmKSFIFYNCi5VPB/WBuD5kz5T9GobknvSu0oeNVLNPczakZjatqlok
	 xBS22IQcwDI0gxb4w0lJ5D9/jl2MvZo+NdmOIuvZYstQRKoiFf/8UPcLQoGzIT4iRr
	 D09kaZUI4wMkQ==
From: "H. Peter Anvin" <hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: [PATCH v2 4/9] x86/entry/vdso32: remove SYSCALL_ENTER_KERNEL macro in sigreturn.S
Date: Tue, 11 Nov 2025 20:37:22 -0800
Message-ID: <20251112043730.992152-5-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112043730.992152-1-hpa@zytor.com>
References: <20251112043730.992152-1-hpa@zytor.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A macro SYSCALL_ENTER_KERNEL was defined in sigreturn.S, with the
ability of overriding it. The override capability, however, is not
used anywhere, and the macro name is potentially confusing because it
seems to imply that sysenter/syscall could be used here, which is NOT
true: the sigreturn system calls MUST use int $0x80.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vdso32/sigreturn.S | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/sigreturn.S b/arch/x86/entry/vdso/vdso32/sigreturn.S
index 1bd068f72d4c..965900c6763b 100644
--- a/arch/x86/entry/vdso/vdso32/sigreturn.S
+++ b/arch/x86/entry/vdso/vdso32/sigreturn.S
@@ -3,10 +3,6 @@
 #include <asm/unistd_32.h>
 #include <asm/asm-offsets.h>
 
-#ifndef SYSCALL_ENTER_KERNEL
-#define	SYSCALL_ENTER_KERNEL	int $0x80
-#endif
-
 	.text
 	.globl __kernel_sigreturn
 	.type __kernel_sigreturn,@function
@@ -16,7 +12,7 @@ __kernel_sigreturn:
 .LSTART_sigreturn:
 	popl %eax		/* XXX does this mean it needs unwind info? */
 	movl $__NR_sigreturn, %eax
-	SYSCALL_ENTER_KERNEL
+	int $0x80
 .LEND_sigreturn:
 SYM_INNER_LABEL(vdso32_sigreturn_landing_pad, SYM_L_GLOBAL)
 	nop
@@ -28,7 +24,7 @@ SYM_INNER_LABEL(vdso32_sigreturn_landing_pad, SYM_L_GLOBAL)
 __kernel_rt_sigreturn:
 .LSTART_rt_sigreturn:
 	movl $__NR_rt_sigreturn, %eax
-	SYSCALL_ENTER_KERNEL
+	int $0x80
 .LEND_rt_sigreturn:
 SYM_INNER_LABEL(vdso32_rt_sigreturn_landing_pad, SYM_L_GLOBAL)
 	nop
-- 
2.51.1

