Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CBB277009;
	Sun, 26 Oct 2025 22:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761516786; cv=none; b=Mx4IY1PwBWp1ujhTQxSkKf7VP+4zNSuzYpQrdSDyc8gCZKns3ImDYHrg81fJkbSys1vrshhnqp0UtnR0fMcOYKm44DFDoOhfHWb1wUwwRpQ1mRo6zGd5y6t6prASawvMjgwVzArPb/j8FfVwZG2oYISviu5kcobJ5Z0QE0+yP/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761516786; c=relaxed/simple;
	bh=iKyx+pNs9KxHGHHkyaAUBWfEJ75+Bm/faN7h3GMdmeg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KP6uLXUFkVBodMVtK6bP2xBanlpqRIxUp8sVK7kxkXWtDy6njKBAKkdGqDg2NgQjG09TkPCyT2Q9EYcvmLNR51OI+QPkGw8RVP367z686x2jWbEsWO+BbwbNm7p9omffihykYQZ1Ffd49XG9ZW2uQqY+yGWrX7t68RwVh0mYT08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=GDPHiDaQ; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="GDPHiDaQ"
Received: from mail.zytor.com ([IPv6:2601:646:8081:9484:8257:f1ab:878e:498b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QMCFpN548264
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 15:12:24 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QMCFpN548264
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761516745;
	bh=hzsd16Tk4N416+vtdjDD9iGYV6V8cuWWcU6HWANhALM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GDPHiDaQjqh4k3a4U+47ybqkHjhVkac5gEVdIoSd7V/tM7lZ64H7FQ5ZVNWAOh3xY
	 hs3fajKprTuBOxTHlED1aaCVpX/pkUo8K2MOmPwR/EDQCzTMwLE7BJ0qzoyqGT7Vlm
	 2TmEOdmmx7S++t8Ysboe0oZz9tO35+jcZAO4pscigd8SO16eh5vTI1hmLPGG8TZgLr
	 6w6HSdm25WHtfhvam06xgNaulibqzgO1jS2uG7jY3t+57WdrqQoHBQojz/MaS2cqvl
	 t9J8JycyzDr/iIJmvYj247thxg9hOiNM7O9DPjO8HKIIxUTIXMzXbpUDSaCjAvfkCO
	 HRj76AIji1xnA==
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
Subject: [PATCH 3/6] x86/entry/vdso32: remove int80_landing_pad
Date: Sun, 26 Oct 2025 15:12:03 -0700
Message-ID: <20251026221208.1938173-4-hpa@zytor.com>
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

There is no fundamental reason for the int80_landing_pad symbol. If ip
falls within the vdso, and the vdso is moved, we should change the ip
accordingly, regardless of mode or location within the vdso. This
*currently* can only happen on 32 bits, but there isn't any reason not
to do so generically.

Note that if this is ever possible from a vdso-internal call, then the
user space stack will also needed to be adjusted (as well as the
shadow stack, if enabled.) Fortunately this is not currently the case.

At the moment, we don't even consider other threads when moving the
vdso. The assumption is that it is only used by process freeze/thaw
for migration, where this is not an issue.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vdso32/system_call.S |  1 -
 arch/x86/entry/vdso/vma.c                | 16 ++++++----------
 arch/x86/tools/vdso2c.c                  |  1 -
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index 2a15634bbe75..d14eca4403c5 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -62,7 +62,6 @@ __kernel_vsyscall:
 
 	/* Enter using int $0x80 */
 	int	$0x80
-SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)
 
 	/*
 	 * Restore EDX and ECX in case they were clobbered.  EBP is not
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 8f98c2d7c7a9..e7fd7517370f 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -65,16 +65,12 @@ static vm_fault_t vdso_fault(const struct vm_special_mapping *sm,
 static void vdso_fix_landing(const struct vdso_image *image,
 		struct vm_area_struct *new_vma)
 {
-	if (in_ia32_syscall() && image == &vdso32_image) {
-		struct pt_regs *regs = current_pt_regs();
-		unsigned long vdso_land = image->sym_int80_landing_pad;
-		unsigned long old_land_addr = vdso_land +
-			(unsigned long)current->mm->context.vdso;
-
-		/* Fixing userspace landing - look at do_fast_syscall_32 */
-		if (regs->ip == old_land_addr)
-			regs->ip = new_vma->vm_start + vdso_land;
-	}
+	struct pt_regs *regs = current_pt_regs();
+	unsigned long ipoffset = regs->ip -
+		(unsigned long)current->mm->context.vdso;
+
+	if (ipoffset < image->size)
+		regs->ip = new_vma->vm_start + ipoffset;
 }
 
 static int vdso_mremap(const struct vm_special_mapping *sm,
diff --git a/arch/x86/tools/vdso2c.c b/arch/x86/tools/vdso2c.c
index f84e8f8fa5fe..c81bb32b1e6c 100644
--- a/arch/x86/tools/vdso2c.c
+++ b/arch/x86/tools/vdso2c.c
@@ -79,7 +79,6 @@ struct vdso_sym required_syms[] = {
 	{"__kernel_vsyscall", true},
 	{"__kernel_sigreturn", true},
 	{"__kernel_rt_sigreturn", true},
-	{"int80_landing_pad", true},
 	{"vdso32_rt_sigreturn_landing_pad", true},
 	{"vdso32_sigreturn_landing_pad", true},
 };
-- 
2.51.1

