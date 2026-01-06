Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB51288C2D;
	Tue,  6 Jan 2026 21:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767734421; cv=none; b=ewMAt0Pm3g4x9K9d1hbxfGENjO6Mny0TU/I/mIKDMIEq7uj6p5yIBg7xAIlABgtfX+TF+2V+c3Sa/FBh/hKWRAvA4JrvBhv+eU5/jyUuok/FXbki+hzsmesQq+NRUumRdS8EkvkWKGZw/QOeXFsa4yODW5OxbveEm79WkBFETQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767734421; c=relaxed/simple;
	bh=N1Z8+wkQNe1RsROgSoYg6HFodjmTZzIHEzxBe/9ZWhQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2pcJ/Ytpn9/7PFhep1L1B0cQei/hYVchuN1VVtkIIhCsPCcoh0J64AOYzE457ymeQqhRLirvXBL4qUgguKD9fNGby9UBZwxMq1DQzBbPO2RJ2czy/7gfudohmW6zjb0ABTTXJQf8qNPiTeocy+ve0c5Jwj+E2+v814/thMy0bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=HfvJFaa0; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="HfvJFaa0"
Received: from mail.zytor.com ([IPv6:2601:646:8081:9483:178c:dccb:2d71:85fe])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 606LIrDs029412
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 13:19:01 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 606LIrDs029412
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767734343;
	bh=VVho2iKTMWzAOd/OWaBSJbTv3DT5W1zC1/L1M7eea/8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HfvJFaa0gTbb2tkyjNL++bFb14gaJoaIOQQF17n1QCVepF2wHwBcovxKULPWgJ1O0
	 cApUL2Mc+6QipWb7uMwNJtevej0iVB1RpTlNLOeM1Wdc1n3Y5FawDz/hvQUSdtXOoG
	 jg7VkzjgGG+Pq//POPW/584bX2WXOJ3SD65xbBc/UQ040ebf7I41FAqcN18XClAnwe
	 xAfdpgoYDGS6dtDkoQFtnr41Km6KUGT/969P/ioHtKK3CeiSyfVUZpU8FNQsBovCNY
	 ndqBRuF30ldODoUvo8SiHeGJKcDKMfejZpXuZilgaSKiKfKHHumAPGmal9NtF2kzJI
	 IWS7NPMNNV0NA==
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
Subject: [PATCH v4.1 04/10] x86/entry/vdso32: don't rely on int80_landing_pad for adjusting ip
Date: Tue,  6 Jan 2026 13:18:37 -0800
Message-ID: <20260106211856.560186-4-hpa@zytor.com>
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

There is no fundamental reason to use the int80_landing_pad symbol to
adjust ip when moving the vdso. If ip falls within the vdso, and the
vdso is moved, we should change the ip accordingly, regardless of mode
or location within the vdso. This *currently* can only happen on 32
bits, but there isn't any reason not to do so generically.

Note that if this is ever possible from a vdso-internal call, then the
user space stack will also needed to be adjusted (as well as the
shadow stack, if enabled.) Fortunately this is not currently the case.

At the moment, we don't even consider other threads when moving the
vdso. The assumption is that it is only used by process freeze/thaw
for migration, where this is not an issue.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vma.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

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
-- 
2.52.0

