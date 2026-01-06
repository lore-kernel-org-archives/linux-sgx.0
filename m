Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F63288C2D;
	Tue,  6 Jan 2026 21:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767734400; cv=none; b=OzluIQe0sLXPliuWx7gJANgzQB4HMtb1V2Ty55UgI3Rv9233PmRvz71HPvRIR+8YGujobN5rulZN7q6W4RdrmQ4yKHI6JjeFDYhB5j1gajQWvEPGTj2SbcmMNjII1yTk4+/XKiCHxw0GRd/jJb7tB/NhkLSUpIsjpYdUBcyikL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767734400; c=relaxed/simple;
	bh=LKSHPGyZnWIui09gUR/8mMblof6SZgg53q5YsR/lh2g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnyKosp7C202RRXAkv+a47hHuXmQnNtWPqiKG2ozj9K/bq5o+oU2hQTQSVuAFnsrI7/D2853a/fQnHNZh7rPDQoazG8wxxNgmAcDc6VHWLbUq7nJtdAZpMrLjw8adfeUHdrXmXKu6SZwiNfLo6vYHwMKv28JzVpzjuWnKgCw6Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Y1vIUDSV; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Y1vIUDSV"
Received: from mail.zytor.com ([IPv6:2601:646:8081:9483:178c:dccb:2d71:85fe])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 606LIrDv029412
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 13:19:06 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 606LIrDv029412
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767734348;
	bh=CTBP4aBnODc0yXRlz3WhZ0rn5gDmow6+pxmIdmq9SnI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Y1vIUDSVipUbN4VpiAdAa0yFCAzNgoPVmwy5lyYcO6fvdz9MrfPxg8l234fgUYda/
	 DxbHbJNbzxBO4qMBjBKjwcfkKkAbwD/H/wv24zdSrxZsids2649zftiTnG2z7lkYtC
	 iHCxT0pD08vrvenCdtwiYpiZrC4cOds1kOp1wQwfUDI3EdD6f1BlMAITdCaYm40+M9
	 Ba/MpNfRe0ilDQy8WEhjhX3SZCKwfq8NT2KyujHgoOykHmj6DxfZg06M7esqT9qMVk
	 CMeess2Iwth9XSnep8ksArFyQgc7XY4sFuIi+NJZtJpdymauL68GtOOlm1u2e+cS24
	 DDx1H7zxatm0Q==
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
Subject: [PATCH v4.1 07/10] x86/entry/vdso: include GNU_PROPERTY and GNU_STACK PHDRs
Date: Tue,  6 Jan 2026 13:18:40 -0800
Message-ID: <20260106211856.560186-7-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <vdso-cleanup-patch-4.1@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the vdso doesn't include .note.gnu.property or a GNU noexec
stack annotation (the -z noexecstack in the linker script is
ineffective because we specify PHDRs explicitly.)

The motivation is that the dynamic linker currently do not check
these.

However, this is a weak excuse: the vdso*.so are also supposed to be
usable at link libraries, and there is no reason why the dynamic
linker might not want or need to check these in the future, so add
them back in -- it is trivial enough.

Use symbolic constants for the PHDR permission flags.

[ v4: drop unrelated formatting changes ]
[ v4.1: drop one last bogus formatting change (Brian Gerst) ]

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/common/vdso-layout.lds.S | 36 ++++++++++++--------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/entry/vdso/common/vdso-layout.lds.S
index ec1ac191a057..f050fd723712 100644
--- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
@@ -47,18 +47,18 @@ SECTIONS
 		*(.gnu.linkonce.b.*)
 	}						:text
 
-	/*
-	 * Discard .note.gnu.property sections which are unused and have
-	 * different alignment requirement from vDSO note sections.
-	 */
-	/DISCARD/ : {
+	.note.gnu.property : {
 		*(.note.gnu.property)
-	}
-	.note		: { *(.note.*) }		:text	:note
-
-	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
-	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+	}					:text :note :gnu_property
+	.note		: {
+		*(.note*)
+	}					:text :note
 
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }	:text :eh_frame_hdr
+	.eh_frame	: {
+		KEEP (*(.eh_frame))
+		*(.eh_frame.*)
+	}					:text
 
 	/*
 	 * Text is well-separated from actual data: there's plenty of
@@ -87,15 +87,23 @@ SECTIONS
  * Very old versions of ld do not recognize this name token; use the constant.
  */
 #define PT_GNU_EH_FRAME	0x6474e550
+#define PT_GNU_STACK	0x6474e551
+#define PT_GNU_PROPERTY	0x6474e553
 
 /*
  * We must supply the ELF program headers explicitly to get just one
  * PT_LOAD segment, and set the flags explicitly to make segments read-only.
  */
+#define PF_R	FLAGS(4)
+#define PF_RW	FLAGS(6)
+#define PF_RX	FLAGS(5)
+
 PHDRS
 {
-	text		PT_LOAD		FLAGS(5) FILEHDR PHDRS; /* PF_R|PF_X */
-	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
-	note		PT_NOTE		FLAGS(4);		/* PF_R */
-	eh_frame_hdr	PT_GNU_EH_FRAME;
+	text		PT_LOAD		PF_RX FILEHDR PHDRS;
+	dynamic		PT_DYNAMIC	PF_R;
+	note		PT_NOTE		PF_R;
+	eh_frame_hdr	PT_GNU_EH_FRAME PF_R;
+	gnu_stack	PT_GNU_STACK	PF_RW;
+	gnu_property	PT_GNU_PROPERTY	PF_R;
 }
-- 
2.52.0

