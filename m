Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0039026A0AD;
	Sun, 26 Oct 2025 22:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761516786; cv=none; b=iiA1TK/obH2u3pljILHvbEGxQHbhir9LU6LSxpIGKX5PVukG4549RbQNKKjPSiqUWujpBixJEjE57WhUfS4uvsHebuSZ4frRXaCyavteoGvyFDvhET6Q+3WBWiuoIoFzdpj1HLESN/WTDj41SYzW6CR1CPjQjb4bdWBA7DBhi4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761516786; c=relaxed/simple;
	bh=7xkCqAjZ2qPkAYjjPIlr5vhCZy8eQqivf3CA9qYNAl4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6kNZ2YhJfXFnXi+ZK02MP4kagk6dFjZgiVdV40tEdWymY9srFUws3b28jlV6wAuxYIsBaNPFcJlRlFNZJvaycwJrIw3MNL/b9akYCT2222gV2i2ezPiQ1BxKOlv/b4WaiApLQ2dNw2bZbXoYBoXh3IO07GKKSTso6iidLeZtzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=fH8drbcH; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="fH8drbcH"
Received: from mail.zytor.com ([IPv6:2601:646:8081:9484:8257:f1ab:878e:498b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QMCFpQ548264
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 15:12:29 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QMCFpQ548264
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761516750;
	bh=nPqmZ+cMh7BpOCrdO7SUJ5c3yBPWnI92MTbF8FZezpQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fH8drbcH5SIfNt0oVQdilq+q3DjrQcT5T2rtiEMh18PSPqnhZnxuveHvYSr6bISBI
	 S3LYWK516TvBRrVow+T3RTo3qrV12T/Gjp86mihPSovvtdwJKPQ86zzKLLOvprJfn7
	 DgzzHJKBBQb7D6F0bfTS6AJQqbxladE1aljHSr6+PE/k0BNv5GwrUAIMOSTAprL/+3
	 WQmtgUuxC8U2FtcmNnhkfbJQvdCRoeO1ykiIadVWXHeDUUB6NV+ZBBk6ONK4nyTfVO
	 ArXeItD7QNahPhGvapu5y4P36wLwr97f60L8VvNtGaMD0kWZ3XYYgByZzvumgNtioL
	 YBBO4xRZ/nX+g==
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
Subject: [PATCH 6/6] x86/entry/vdso32: add endbr32 to system_call.S
Date: Sun, 26 Oct 2025 15:12:06 -0700
Message-ID: <20251026221208.1938173-7-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251026221208.1938173-1-hpa@zytor.com>
References: <20251026221208.1938173-1-hpa@zytor.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

*If* the C code is compiled with endbr support, put one at the assembly
system call entry point as well.

Note that no endbr is required at the sigreturn entry points, because
those are logically subroutine returns and invoked via ret
instructions.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vdso32/system_call.S | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index d14eca4403c5..0ca7ca1c490b 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -8,12 +8,19 @@
 #include <asm/cpufeatures.h>
 #include <asm/alternative.h>
 
+.macro CET_ENDBR
+#if defined(__CET__) && (__CET__ & 1)
+	endbr32
+#endif
+.endm
+
 	.text
 	.globl __kernel_vsyscall
 	.type __kernel_vsyscall,@function
 	ALIGN
 __kernel_vsyscall:
 	CFI_STARTPROC
+	CET_ENDBR
 	/*
 	 * Reshuffle regs so that all of any of the entry instructions
 	 * will preserve enough state.
-- 
2.51.1

