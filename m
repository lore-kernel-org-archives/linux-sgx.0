Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC072F999F;
	Tue,  6 Jan 2026 21:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767734421; cv=none; b=BkGf3/hB3LmpZ8aYl7qyLRZ0zuOinDvAllgpC7nfjpMBKv3ITQ8baopVzaY17qzkQ/5aViDbT/DP6VJDvpay1OyOW4zHGLFKxOyrKvNYecDiuHq6ToLD6waO1og7gzZVBobbO4+YrYdB+VMQficNLUFoQfCYUj4Nhu64Fm7qd+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767734421; c=relaxed/simple;
	bh=MoqvLbMfn2F43wSd1sfYHLLZub8UGjJ7D/U+nOpcdbY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3132pZPCvGEhr1imQQRNXyKuIaE/somys8VFnK/6BbOqQ5oV/xJV8NjagjnXg3NGAj0hN5Amfm2wuhT+HK1hvJI8D2ZrIt5eLsB4XVOft4OZPup1zhohFiEEwaPB0j6OXAwT9zX7BKYNEnasMzkMrIBTf1JR/VduM3MgCPWwPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=bGAskTlw; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="bGAskTlw"
Received: from mail.zytor.com ([IPv6:2601:646:8081:9483:178c:dccb:2d71:85fe])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 606LIrDq029412
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 13:18:58 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 606LIrDq029412
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767734339;
	bh=qfIXPrDPPzOmRPX4wlKrygGvZVz41nwH1/qG7m+qlJI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bGAskTlw3xK0ppwBuBMw3DPh1VchZUr2ucDh9N6oGGsIftfABz2G6bDvPJHoG6Owy
	 pmbRzuPAeMu/MaBPASvYECtJsgPKGvYO5TUwS1RwMXaebPF3I5oS5hcwIWQ58YyyyZ
	 QHadaH8HdTIpf9vFFUJ1w0vBeJ36l8uyRO8RBgTn/f75N5BDaqVcy8mHOPFS4TpEey
	 cUr/Qeoy27ERS6aWRYybHrAIl6NKJlgcCYsbwzuyRZMmlqCr7MuFN09nPA+MCGsGpo
	 oNR09mhYaOJ7Cb4BP/dN+kvbQ/eVue8iSP9Uu3jxkaJ7W4KNODumsPzMG0TY2w/q/A
	 5eRNx7pza5Pgw==
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
Subject: [PATCH v4.1 02/10] x86/entry/vdso: move vdso2c to arch/x86/tools
Date: Tue,  6 Jan 2026 13:18:35 -0800
Message-ID: <20260106211856.560186-2-hpa@zytor.com>
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

It is generally better to build tools in arch/x86/tools to keep host
cflags proliferation down, and to reduce makefile sequencing issues.
Move the vdso build tool vdso2c into arch/x86/tools in preparation for
refactoring the vdso makefiles.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/Makefile                       |  2 +-
 arch/x86/entry/vdso/Makefile            |  7 +++----
 arch/x86/tools/Makefile                 | 15 ++++++++++-----
 arch/x86/{entry/vdso => tools}/vdso2c.c |  0
 arch/x86/{entry/vdso => tools}/vdso2c.h |  0
 5 files changed, 14 insertions(+), 10 deletions(-)
 rename arch/x86/{entry/vdso => tools}/vdso2c.c (100%)
 rename arch/x86/{entry/vdso => tools}/vdso2c.h (100%)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1d403a3612ea..9ab7522ced18 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -252,7 +252,7 @@ endif
 
 
 archscripts: scripts_basic
-	$(Q)$(MAKE) $(build)=arch/x86/tools relocs
+	$(Q)$(MAKE) $(build)=arch/x86/tools relocs vdso2c
 
 ###
 # Syscall table generation
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 7f833026d5b2..3d9b09f00c70 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -38,13 +38,12 @@ VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -soname linux-vdso.so.1 \
 $(obj)/vdso64.so.dbg: $(obj)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,vdso_and_check)
 
-HOST_EXTRACFLAGS += -I$(srctree)/tools/include -I$(srctree)/include/uapi -I$(srctree)/arch/$(SUBARCH)/include/uapi
-hostprogs += vdso2c
+VDSO2C = $(objtree)/arch/x86/tools/vdso2c
 
 quiet_cmd_vdso2c = VDSO2C  $@
-      cmd_vdso2c = $(obj)/vdso2c $< $(<:%.dbg=%) $@
+      cmd_vdso2c = $(VDSO2C) $< $(<:%.dbg=%) $@
 
-$(obj)/vdso%-image.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(obj)/vdso2c FORCE
+$(obj)/vdso%-image.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(VDSO2C) FORCE
 	$(call if_changed,vdso2c)
 
 #
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index 7278e2545c35..39a183fffd04 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -38,9 +38,14 @@ $(obj)/insn_decoder_test.o: $(srctree)/tools/arch/x86/lib/insn.c $(srctree)/tool
 
 $(obj)/insn_sanity.o: $(srctree)/tools/arch/x86/lib/insn.c $(srctree)/tools/arch/x86/lib/inat.c $(srctree)/tools/arch/x86/include/asm/inat_types.h $(srctree)/tools/arch/x86/include/asm/inat.h $(srctree)/tools/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
 
-HOST_EXTRACFLAGS += -I$(srctree)/tools/include
-hostprogs	+= relocs
-relocs-objs     := relocs_32.o relocs_64.o relocs_common.o
-PHONY += relocs
-relocs: $(obj)/relocs
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include -I$(srctree)/include/uapi \
+		    -I$(srctree)/arch/$(SUBARCH)/include/uapi
+
+hostprogs	+= relocs vdso2c
+relocs-objs	:= relocs_32.o relocs_64.o relocs_common.o
+
+always-y	:= $(hostprogs)
+
+PHONY += $(hostprogs)
+$(hostprogs): %: $(obj)/%
 	@:
diff --git a/arch/x86/entry/vdso/vdso2c.c b/arch/x86/tools/vdso2c.c
similarity index 100%
rename from arch/x86/entry/vdso/vdso2c.c
rename to arch/x86/tools/vdso2c.c
diff --git a/arch/x86/entry/vdso/vdso2c.h b/arch/x86/tools/vdso2c.h
similarity index 100%
rename from arch/x86/entry/vdso/vdso2c.h
rename to arch/x86/tools/vdso2c.h
-- 
2.52.0

