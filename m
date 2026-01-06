Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B332FE591;
	Tue,  6 Jan 2026 21:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767734422; cv=none; b=uAVLsU48ZevCGoGG1UowGe6nZursJMOJG70DaoJW8phJ1ssXp061u6iUtFtpI4mhdcaVrUKOOWXFv9IEs0YWyemExBx7o+053j9FVgITQQYNeLO3avAqUwZY+5sPeCjDnFcAKkImAUcUua1ikGoi+oOvdK9s+kB0xootmnvUX5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767734422; c=relaxed/simple;
	bh=GND+ivawVz9u4D2ysviHFt3tTpZU07t3qCULaxjZ3KA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k37DC6P9NzJJHuqLsk0Qs9tpH+GwMuoL7I4ZnD2pBD1T+ge6QznbmO4a4llA60OBy8l4adCPsUJXIvjrozWJJGzsauJWc9ak8+nyhMmJvExh44wxki40lwGk65prEfyDZNiM/nCGZGs2sppKbi80gB04HeY6N453/FRRGXAMY+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=HtOBDzSY; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="HtOBDzSY"
Received: from mail.zytor.com ([IPv6:2601:646:8081:9483:178c:dccb:2d71:85fe])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 606LIrDo029412
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 13:18:53 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 606LIrDo029412
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767734336;
	bh=aI8MIw+sMa6PRGtTxYvVJEbs7tXT12sE7HZ5eTyFKjU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HtOBDzSYOXIElCekW0xbSMoqezJNGWAvd6WaEV1EvTfZMIldHnKSr20qoQaBLFLXj
	 xODoSdOhVI2fcQNwmMkzFzmtKjkyeGlaK/DXbOZnF1UWa81uqePmMadJ8n6FfTvvbG
	 RM8kPPigUITdMIV8FuKGvK6EdVGp79UaHWT2o+W9VWD9oOi5LF/fNOh9/24TrDilRT
	 Sli0hekCuEPa8Dd5tLyvdvJf5ip5+okYvSAPDkKO5MGVxFxWvlgUXcWz+vpztnswqw
	 1p+kPkQgRASGlDp2tUHdT3rG5+82/UPMj7deC4ziJ/KQ6C34DB/PvlS1juBFoVj2PZ
	 SBzySI8XzhPWw==
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
Subject: [PATCH v4.1 00/10] x86/entry/vdso: clean up the vdso build, vdso updates
Date: Tue,  6 Jan 2026 13:18:33 -0800
Message-ID: <vdso-cleanup-patch-4.1@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216212606.1325678-1-hpa@zytor.com>
References: 
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is intended as a ping, since I think the v4 got swallowed by the
holidays. v4.1 IS BASICALLY A REBASE AND RESEND OF v4; THE ONLY CODE
CHANGE IS A SINGLE SPACE CHARACTER.

This patchset cleans up the vdso build by building the 32- and 64-bit
vdsos in separate directories, moving the vdso2c tool to
arch/x86/tools, and by merging common code and especially Makefile
rules between the 32- and 64-bit vdsos to the greatest extent
possible.

Be more strict about sanitizing and standardizing the vdso build
options.

Disable CFI for the vdso until the kernel adds user space IBT support.

Modernize the DWARF generation in vdso32/sigreturn.S.

Add macros to cleanly call system calls from vdso source code.

Add the GNU_PROPERTY and GNU_STACK PHDRs to the vdso.

When using int $0x80 (old 32-bit hardware or FRED-capable 64-bit
hardware) skip the stack stuff in the 32-bit kernel entry code and
call int $0x80 directly when used from C code.

Changes from v4 to v4.1:

  - Fix a single bogus whitespace character change in patch 7.
  - Fix the spelling of Uros Bizjak's name in the comment to patch 8.
  - Rebased onto v6.19-rc4.

Changes from v3 to v4:

  - Improved description of patch 01/10.
  - Split out the move of vdso2c to tools into a separate patch.
  - Remove unrelated formatting changes from vdso-layout.lds.S.
  - Fix *-x32.o being missing from "targets".
  - Rebased onto v6.19-rc1.

Changes from v2 to v3:

  In arch/x86/include/asm/vdso/sys_call.h:
  - Remove stray comment from prototyping (Uros Bizjak)
  - Remove VDSO_SYSCALL6() since it would require special
    handling on 32 bits with frame pointers and is
    currently unused. (Uros Bizjak)
  - Indent nested preprocessor directives.

Changes from v1 to v2:

  Too many to count - much of the patchset has been reworked

Patches:

  x86/entry/vdso: rename vdso_image_* to vdso*_image
  x86/entry/vdso: move vdso2c to arch/x86/tools
  x86/entry/vdso: refactor the vdso build
  x86/entry/vdso32: don't rely on int80_landing_pad for adjusting ip
  x86/entry/vdso32: remove SYSCALL_ENTER_KERNEL macro in sigreturn.S
  x86/entry/vdso32: remove open-coded DWARF in sigreturn.S
  x86/entry/vdso: include GNU_PROPERTY and GNU_STACK PHDRs
  x86/vdso: abstract out vdso system call internals
  x86/cpufeature: replace X86_FEATURE_SYSENTER32 with X86_FEATURE_SYSFAST32
  x86/entry/vdso32: when using int $0x80, use it directly

---
 arch/x86/Kconfig.cpufeatures                       |   8 +
 arch/x86/Makefile                                  |   2 +-
 arch/x86/entry/syscall_32.c                        |   2 +-
 arch/x86/entry/vdso/.gitignore                     |  11 +-
 arch/x86/entry/vdso/Makefile                       | 162 +--------------------
 arch/x86/entry/vdso/common/Makefile.include        |  89 +++++++++++
 arch/x86/entry/vdso/{vdso-note.S => common/note.S} |   5 +-
 arch/x86/entry/vdso/{ => common}/vclock_gettime.c  |   0
 arch/x86/entry/vdso/{ => common}/vdso-layout.lds.S |  38 +++--
 arch/x86/entry/vdso/{ => common}/vgetcpu.c         |   0
 arch/x86/entry/vdso/vdso32/Makefile                |  24 +++
 arch/x86/entry/vdso/vdso32/note.S                  |  19 +--
 arch/x86/entry/vdso/vdso32/sigreturn.S             | 152 +++++--------------
 arch/x86/entry/vdso/vdso32/system_call.S           |  22 ++-
 arch/x86/entry/vdso/vdso32/vclock_gettime.c        |   5 +-
 arch/x86/entry/vdso/vdso32/vdso32.lds.S            |   2 +-
 arch/x86/entry/vdso/vdso32/vgetcpu.c               |   4 +-
 arch/x86/entry/vdso/vdso64/Makefile                |  46 ++++++
 arch/x86/entry/vdso/vdso64/note.S                  |   1 +
 arch/x86/entry/vdso/vdso64/vclock_gettime.c        |   1 +
 .../entry/vdso/{vdso.lds.S => vdso64/vdso64.lds.S} |   2 +-
 arch/x86/entry/vdso/{ => vdso64}/vdsox32.lds.S     |   2 +-
 arch/x86/entry/vdso/vdso64/vgetcpu.c               |   1 +
 .../entry/vdso/{ => vdso64}/vgetrandom-chacha.S    |   0
 arch/x86/entry/vdso/{ => vdso64}/vgetrandom.c      |   2 +-
 arch/x86/entry/vdso/{ => vdso64}/vsgx.S            |   0
 arch/x86/entry/vdso/vma.c                          |  24 ++-
 arch/x86/include/asm/cpufeatures.h                 |   2 +-
 arch/x86/include/asm/dwarf2.h                      |   1 +
 arch/x86/include/asm/elf.h                         |   2 +-
 arch/x86/include/asm/vdso.h                        |   6 +-
 arch/x86/include/asm/vdso/gettimeofday.h           | 108 +-------------
 arch/x86/include/asm/vdso/sys_call.h               | 105 +++++++++++++
 arch/x86/kernel/asm-offsets.c                      |   6 +
 arch/x86/kernel/cpu/centaur.c                      |   3 -
 arch/x86/kernel/cpu/common.c                       |   8 +
 arch/x86/kernel/cpu/intel.c                        |   4 +-
 arch/x86/kernel/cpu/zhaoxin.c                      |   4 +-
 arch/x86/kernel/fred.c                             |   2 +-
 arch/x86/kernel/process_64.c                       |   6 +-
 arch/x86/kernel/signal_32.c                        |   4 +-
 arch/x86/tools/Makefile                            |  15 +-
 arch/x86/{entry/vdso => tools}/vdso2c.c            |   0
 arch/x86/{entry/vdso => tools}/vdso2c.h            |   0
 arch/x86/xen/setup.c                               |  28 ++--
 arch/x86/xen/smp_pv.c                              |   5 +-
 arch/x86/xen/xen-ops.h                             |   1 -
 47 files changed, 444 insertions(+), 490 deletions(-)
