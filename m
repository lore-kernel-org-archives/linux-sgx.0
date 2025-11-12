Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084DF2609CC;
	Wed, 12 Nov 2025 20:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762978972; cv=none; b=gS08EWSHQuAYegQOhkDUHSMWaR+QHIjYhqkUiytlrQ+P7/NzyabNQ4ln38znvts1IsyiGrMc5fn1r5n3Kj+kVEJbxK8DyeOyA6NDAJ7VX1nzs8qsP11OpSe0cYKM1ZVY+gLr4HqyDwk0z5N+JwhrIqTW1jsvtTp39Y5xZ5jiA+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762978972; c=relaxed/simple;
	bh=Qc+ZX9T/f2W+RDw2MY8se8ehYAGsJxhh8u3/jBxkUvE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=W7IgVJOBGR7CH+c1HUxoQ14rhsduukuSjeOB4B0NAjZVHWxxFRquYqlK9lnbuzqGceunJ/Z9dKoQ/SZLEvHztazMGSj20YebU6jk323rDD3RvWU8LuKHBlINnOxIHTkzTUJ928oOIQaR66Ki0Yr6Jdq7q+2s6ezgT7m4olFE/wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WhhQ7EuK; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WhhQ7EuK"
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACKLxgd978289
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Nov 2025 12:22:00 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACKLxgd978289
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762978922;
	bh=GacBjPJEXkeyFGvcySDne54yt1x9SXUnR3yJ7bSJhAE=;
	h=From:To:Subject:Date:From;
	b=WhhQ7EuKwYOXytPktFek3puY7Ka0XqBpn7jBOERZqLlcy7SfXWCNsSw4KzTyrdilv
	 xf34DKl84eb9wbp02eojRF1Arl3k73RGpmWbST7W1aDH5jgCFvity/lWEY3JsDu/66
	 uXn03ol/zqhoxm9wKKTvyWGhWcjKy1nt3b2wdtHuOktdHSOgmEQUbTK9TaRpNeFqna
	 GMKGGeMijqYo3e0UVhsVSvu/vfq6aj6nsMTELnn0OwBKjCJlGdM6QBeaOwImY1fAO8
	 BHm9EGykwgLoNslkep5UQch3jg45qyLBcV9GUZgL1RCODGmny3vbFlwxdy1QCUoeVl
	 ei6m6DpOShsyw==
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
Subject: [PATCH v3 0/3] x86/entry/vdso: clean up the vdso build, vdso updates
Date: Wed, 12 Nov 2025 12:21:45 -0800
Message-ID: <20251112202155.1310587-1-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset cleans up the vdso build by building the 32- and 64-bit
vdsos in separate directories, moving the vdso2c tool to
arch/x86/tools, and by merging common code and especially Makefile
rules between the 32- and 64-bit vdsos to the greatest extent
possible.

Be more strict about sanitizing and standardizing the vdso build
options.

Disable CFI for the vdso until the kernel adds user space IBT support.

Modernize the DWARF generation vdso32/sigreturn.S.

Add macros to cleanly call system calls from vdso source code.

Add the GNU_PROPERTY and GNU_STACK PHDRs to the vdso.

When using int $0x80 (old 32-bit hardware or FRED-capable 64-bit
hardware) skip the stack stuff in the 32-bit kernel entry code and
call int $0x80 directly when used from C code.

Changes from v3:

  In arch/x86/include/asm/vdso/sys_call.h:
  - remove stray comment from prototyping (Uros Biszjak)
  - remove VDSO_SYSCALL6() since it would require special
    handling on 32 bits with frame pointers and is
    currently unused. (Uros Biszjak)
  - indent nested preprocessor directives.

Changes from v2:

  Too many to count - much of the patchset has been reworked

Patches:

	x86/entry/vdso: rename vdso_image_* to vdso*_image
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
 arch/x86/entry/vdso/{ => common}/vdso-layout.lds.S |  51 ++++---
 arch/x86/entry/vdso/{ => common}/vgetcpu.c         |   0
 arch/x86/entry/vdso/vdso32/Makefile                |  24 +++
 arch/x86/entry/vdso/vdso32/note.S                  |  19 +--
 arch/x86/entry/vdso/vdso32/sigreturn.S             | 152 +++++--------------
 arch/x86/entry/vdso/vdso32/system_call.S           |  22 ++-
 arch/x86/entry/vdso/vdso32/vclock_gettime.c        |   5 +-
 arch/x86/entry/vdso/vdso32/vdso32.lds.S            |   2 +-
 arch/x86/entry/vdso/vdso32/vgetcpu.c               |   4 +-
 arch/x86/entry/vdso/vdso64/Makefile                |  45 ++++++
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
 47 files changed, 448 insertions(+), 498 deletions(-)
