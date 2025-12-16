Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD46131329E;
	Tue, 16 Dec 2025 21:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765920429; cv=none; b=SZWPtG0toYtnslZVeCrrqyGZBw5Nl6v+lIyK4rytIfL3c3MUba3K4Iv2fcu2fpa/qYgWpmvVbNrWy+/BOylIdvEEx0Bix6kPm9Zfpmk4D+vQShE5AyPl3OOJ4VhFOFeCz7cQ8u8nPA4M7ccrRwuc9SU0T5m/oNJZWQXQMCkVJnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765920429; c=relaxed/simple;
	bh=IFbK2Vstj6wU91JxtVxu7k/PGBg6LmOaDJDvE5IgZnE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ficGqEqZ03ruXVw0XHJDG4CWmaHL+roPQTGBm4mQfT7GGTgRKW424GM1l256S6xFbZrFKcaGcUyUmlJ886dZ1imeG1fQ5zwfEdG69YbIeigzyr0CjhhCm74tYbz767HSDTdzOR2zauSX/AlDkxYo1Ri5NayXpp2Q6giafI2vTMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JAGn9jve; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JAGn9jve"
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGLQC222563820
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 16 Dec 2025 13:26:19 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGLQC222563820
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765920380;
	bh=AB+971Z2K/0s3r5t/Zl6ByNhuiR5RGHV+jj8e23dhBU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JAGn9jvequsBQajOt8EWt9/pri2sqlPQ2L0iTyrJ6ux3OCwDroLRIeW1Uh9OQGQeT
	 NCqjS+MnoOiWIWjUwVjAIFK0RKBgfg6RyvbVVEZH/twuOlDwqGpnJAIP52hdBJI56G
	 Qo+vguRsbMl/Pve/xkRKMgVBprRFOB2vzslWteExTDQrHCvRPURPNzXYAURn9TJEUy
	 /AskQg4SJyYiXEgPUUfGymdPHP12RySiVmP3GY7aZbVvGK5tinvf2vBlwvwSvnUAul
	 fmVWWkedofANuUXjtRl8bdsEmbJTgQPDSBl9ClMrKk7CURLGp8jnMBOCHz0yptmxHE
	 RfVC4rtckX9Uw==
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
Subject: [PATCH v4 03/10] x86/entry/vdso: refactor the vdso build
Date: Tue, 16 Dec 2025 13:25:57 -0800
Message-ID: <20251216212606.1325678-4-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216212606.1325678-1-hpa@zytor.com>
References: <20251216212606.1325678-1-hpa@zytor.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- Separate out the vdso sources into common, vdso32, and vdso64
  directories.
- Build the 32- and 64-bit vdsos in their respective subdirectories;
  this greatly simplifies the build flags handling.
- Unify the mangling of Makefile flags between the 32- and 64-bit
  vdso code as much as possible; all common rules are put in
  arch/x86/entry/vdso/common/Makefile.include. The remaining
  is very simple for 32 bits; the 64-bit one is only slightly more
  complicated because it contains the x32 generation rule.
- Define __DISABLE_EXPORTS when building the vdso. This need seems to
  have been masked by different ordering compile flags before.
- Change CONFIG_X86_64 to BUILD_VDSO32_64 in vdso32/system_call.S,
  to make it compatible with including fake_32bit_build.h.
- The -fcf-protection= option was "leaking" from the kernel build,
  for reasons that was not clear to me. Futhermore, several
  distributions ship with it set to a default value other than
  "-fcf-protection=none". Make it match the configuration options
  for *user space*.

Note that this patch may seem large, but the vast majority of it is
simply code movement.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/Makefile                  | 161 +-----------------
 arch/x86/entry/vdso/common/Makefile.include   |  89 ++++++++++
 .../entry/vdso/{vdso-note.S => common/note.S} |   5 +-
 .../entry/vdso/{ => common}/vclock_gettime.c  |   0
 .../entry/vdso/{ => common}/vdso-layout.lds.S |   0
 arch/x86/entry/vdso/{ => common}/vgetcpu.c    |   0
 arch/x86/entry/vdso/vdso32/Makefile           |  24 +++
 arch/x86/entry/vdso/vdso32/note.S             |  19 +--
 arch/x86/entry/vdso/vdso32/system_call.S      |   2 +-
 arch/x86/entry/vdso/vdso32/vclock_gettime.c   |   5 +-
 arch/x86/entry/vdso/vdso32/vdso32.lds.S       |   2 +-
 arch/x86/entry/vdso/vdso32/vgetcpu.c          |   4 +-
 arch/x86/entry/vdso/vdso64/Makefile           |  46 +++++
 arch/x86/entry/vdso/vdso64/note.S             |   1 +
 arch/x86/entry/vdso/vdso64/vclock_gettime.c   |   1 +
 .../vdso/{vdso.lds.S => vdso64/vdso64.lds.S}  |   2 +-
 .../x86/entry/vdso/{ => vdso64}/vdsox32.lds.S |   2 +-
 arch/x86/entry/vdso/vdso64/vgetcpu.c          |   1 +
 .../vdso/{ => vdso64}/vgetrandom-chacha.S     |   0
 arch/x86/entry/vdso/{ => vdso64}/vgetrandom.c |   2 +-
 arch/x86/entry/vdso/{ => vdso64}/vsgx.S       |   0
 21 files changed, 180 insertions(+), 186 deletions(-)
 create mode 100644 arch/x86/entry/vdso/common/Makefile.include
 rename arch/x86/entry/vdso/{vdso-note.S => common/note.S} (62%)
 rename arch/x86/entry/vdso/{ => common}/vclock_gettime.c (100%)
 rename arch/x86/entry/vdso/{ => common}/vdso-layout.lds.S (100%)
 rename arch/x86/entry/vdso/{ => common}/vgetcpu.c (100%)
 create mode 100644 arch/x86/entry/vdso/vdso32/Makefile
 create mode 100644 arch/x86/entry/vdso/vdso64/Makefile
 create mode 100644 arch/x86/entry/vdso/vdso64/note.S
 create mode 100644 arch/x86/entry/vdso/vdso64/vclock_gettime.c
 rename arch/x86/entry/vdso/{vdso.lds.S => vdso64/vdso64.lds.S} (94%)
 rename arch/x86/entry/vdso/{ => vdso64}/vdsox32.lds.S (92%)
 create mode 100644 arch/x86/entry/vdso/vdso64/vgetcpu.c
 rename arch/x86/entry/vdso/{ => vdso64}/vgetrandom-chacha.S (100%)
 rename arch/x86/entry/vdso/{ => vdso64}/vgetrandom.c (91%)
 rename arch/x86/entry/vdso/{ => vdso64}/vsgx.S (100%)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 3d9b09f00c70..987b43fd4cd3 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -3,159 +3,10 @@
 # Building vDSO images for x86.
 #
 
-# Include the generic Makefile to check the built vDSO:
-include $(srctree)/lib/vdso/Makefile.include
+# Regular kernel objects
+obj-y				:= vma.o extable.o
+obj-$(CONFIG_COMPAT_32)		+= vdso32-setup.o
 
-# Files to link into the vDSO:
-vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vgetrandom.o vgetrandom-chacha.o
-vobjs32-y := vdso32/note.o vdso32/system_call.o vdso32/sigreturn.o
-vobjs32-y += vdso32/vclock_gettime.o vdso32/vgetcpu.o
-vobjs-$(CONFIG_X86_SGX)	+= vsgx.o
-
-# Files to link into the kernel:
-obj-y						+= vma.o extable.o
-
-# vDSO images to build:
-obj-$(CONFIG_X86_64)				+= vdso64-image.o
-obj-$(CONFIG_X86_X32_ABI)			+= vdsox32-image.o
-obj-$(CONFIG_COMPAT_32)				+= vdso32-image.o vdso32-setup.o
-
-vobjs := $(addprefix $(obj)/, $(vobjs-y))
-vobjs32 := $(addprefix $(obj)/, $(vobjs32-y))
-
-$(obj)/vdso.o: $(obj)/vdso.so
-
-targets += vdso.lds $(vobjs-y)
-targets += vdso32/vdso32.lds $(vobjs32-y)
-
-targets += $(foreach x, 64 x32 32, vdso-image-$(x).c vdso$(x).so vdso$(x).so.dbg)
-
-CPPFLAGS_vdso.lds += -P -C
-
-VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -soname linux-vdso.so.1 \
-			-z max-page-size=4096
-
-$(obj)/vdso64.so.dbg: $(obj)/vdso.lds $(vobjs) FORCE
-	$(call if_changed,vdso_and_check)
-
-VDSO2C = $(objtree)/arch/x86/tools/vdso2c
-
-quiet_cmd_vdso2c = VDSO2C  $@
-      cmd_vdso2c = $(VDSO2C) $< $(<:%.dbg=%) $@
-
-$(obj)/vdso%-image.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(VDSO2C) FORCE
-	$(call if_changed,vdso2c)
-
-#
-# Don't omit frame pointers for ease of userspace debugging, but do
-# optimize sibling calls.
-#
-CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
-       $(filter -g%,$(KBUILD_CFLAGS)) -fno-stack-protector \
-       -fno-omit-frame-pointer -foptimize-sibling-calls \
-       -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO
-
-ifdef CONFIG_MITIGATION_RETPOLINE
-ifneq ($(RETPOLINE_VDSO_CFLAGS),)
-  CFL += $(RETPOLINE_VDSO_CFLAGS)
-endif
-endif
-
-$(vobjs): KBUILD_CFLAGS := $(filter-out $(PADDING_CFLAGS) $(CC_FLAGS_LTO) $(CC_FLAGS_CFI) $(RANDSTRUCT_CFLAGS) $(KSTACK_ERASE_CFLAGS) $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
-$(vobjs): KBUILD_AFLAGS += -DBUILD_VDSO
-
-#
-# vDSO code runs in userspace and -pg doesn't help with profiling anyway.
-#
-CFLAGS_REMOVE_vclock_gettime.o = -pg
-CFLAGS_REMOVE_vdso32/vclock_gettime.o = -pg
-CFLAGS_REMOVE_vgetcpu.o = -pg
-CFLAGS_REMOVE_vdso32/vgetcpu.o = -pg
-CFLAGS_REMOVE_vsgx.o = -pg
-CFLAGS_REMOVE_vgetrandom.o = -pg
-
-#
-# X32 processes use x32 vDSO to access 64bit kernel data.
-#
-# Build x32 vDSO image:
-# 1. Compile x32 vDSO as 64bit.
-# 2. Convert object files to x32.
-# 3. Build x32 VDSO image with x32 objects, which contains 64bit codes
-# so that it can reach 64bit address space with 64bit pointers.
-#
-
-CPPFLAGS_vdsox32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdsox32.lds = -m elf32_x86_64 -soname linux-vdso.so.1 \
-			   -z max-page-size=4096
-
-# x32-rebranded versions
-vobjx32s-y := $(vobjs-y:.o=-x32.o)
-
-# same thing, but in the output directory
-vobjx32s := $(addprefix $(obj)/, $(vobjx32s-y))
-
-# Convert 64bit object file to x32 for x32 vDSO.
-quiet_cmd_x32 = X32     $@
-      cmd_x32 = $(OBJCOPY) -O elf32-x86-64 $< $@
-
-$(obj)/%-x32.o: $(obj)/%.o FORCE
-	$(call if_changed,x32)
-
-targets += vdsox32.lds $(vobjx32s-y)
-
-$(obj)/%.so: OBJCOPYFLAGS := -S --remove-section __ex_table
-$(obj)/%.so: $(obj)/%.so.dbg FORCE
-	$(call if_changed,objcopy)
-
-$(obj)/vdsox32.so.dbg: $(obj)/vdsox32.lds $(vobjx32s) FORCE
-	$(call if_changed,vdso_and_check)
-
-CPPFLAGS_vdso32/vdso32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -soname linux-gate.so.1
-
-KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS)) -DBUILD_VDSO
-$(obj)/vdso32.so.dbg: KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
-$(obj)/vdso32.so.dbg: asflags-$(CONFIG_X86_64) += -m32
-
-KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
-KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 := $(filter-out $(RANDSTRUCT_CFLAGS),$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 := $(filter-out $(KSTACK_ERASE_CFLAGS),$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 := $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 := $(filter-out $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 := $(filter-out $(CC_FLAGS_LTO),$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 := $(filter-out $(CC_FLAGS_CFI),$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 := $(filter-out $(PADDING_CFLAGS),$(KBUILD_CFLAGS_32))
-KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
-KBUILD_CFLAGS_32 += -fno-stack-protector
-KBUILD_CFLAGS_32 += $(call cc-option, -foptimize-sibling-calls)
-KBUILD_CFLAGS_32 += -fno-omit-frame-pointer
-KBUILD_CFLAGS_32 += -DDISABLE_BRANCH_PROFILING
-KBUILD_CFLAGS_32 += -DBUILD_VDSO
-
-ifdef CONFIG_MITIGATION_RETPOLINE
-ifneq ($(RETPOLINE_VDSO_CFLAGS),)
-  KBUILD_CFLAGS_32 += $(RETPOLINE_VDSO_CFLAGS)
-endif
-endif
-
-$(obj)/vdso32.so.dbg: KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
-
-$(obj)/vdso32.so.dbg: $(obj)/vdso32/vdso32.lds $(vobjs32) FORCE
-	$(call if_changed,vdso_and_check)
-
-#
-# The DSO images are built using a special linker script.
-#
-quiet_cmd_vdso = VDSO    $@
-      cmd_vdso = $(LD) -o $@ \
-		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$(filter %.lds,$(^F))) \
-		       -T $(filter %.lds,$^) $(filter %.o,$^)
-
-VDSO_LDFLAGS = -shared --hash-style=both --build-id=sha1 --no-undefined \
-	$(call ld-option, --eh-frame-hdr) -Bsymbolic -z noexecstack
-
-quiet_cmd_vdso_and_check = VDSO    $@
-      cmd_vdso_and_check = $(cmd_vdso); $(cmd_vdso_check)
+# vDSO directories
+obj-$(CONFIG_X86_64)		+= vdso64/
+obj-$(CONFIG_COMPAT_32)		+= vdso32/
diff --git a/arch/x86/entry/vdso/common/Makefile.include b/arch/x86/entry/vdso/common/Makefile.include
new file mode 100644
index 000000000000..3514b4a6869b
--- /dev/null
+++ b/arch/x86/entry/vdso/common/Makefile.include
@@ -0,0 +1,89 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Building vDSO images for x86.
+#
+
+# Include the generic Makefile to check the built vDSO:
+include $(srctree)/lib/vdso/Makefile.include
+
+obj-y    += $(foreach x,$(vdsos-y),vdso$(x)-image.o)
+
+targets  += $(foreach x,$(vdsos-y),vdso$(x)-image.c vdso$(x).so vdso$(x).so.dbg vdso$(x).lds)
+targets  += $(vobjs-y)
+
+# vobjs-y with $(obj)/ prepended
+vobjs := $(addprefix $(obj)/,$(vobjs-y))
+
+# Options for vdso*.lds
+CPPFLAGS_VDSO_LDS := -P -C -I$(src)/..
+$(obj)/%.lds : KBUILD_CPPFLAGS += $(CPPFLAGS_VDSO_LDS)
+
+#
+# Options from KBUILD_[AC]FLAGS that should *NOT* be kept
+#
+flags-remove-y += \
+	-D__KERNEL__ -mcmodel=kernel -mregparm=3 \
+	-fno-pic -fno-PIC -fno-pie fno-PIE \
+	-mfentry -pg \
+	$(RANDSTRUCT_CFLAGS) $(GCC_PLUGIN_CFLAGS) $(KSTACK_ERASE_CFLAGS) \
+	$(RETPOLINE_CFLAGS) $(CC_FLAGS_LTO) $(CC_FLAGS_CFI) \
+	$(PADDING_CFLAGS)
+
+#
+# Don't omit frame pointers for ease of userspace debugging, but do
+# optimize sibling calls.
+#
+flags-y += -D__DISABLE_EXPORTS
+flags-y += -DDISABLE_BRANCH_PROFILING
+flags-y += -DBUILD_VDSO
+flags-y += -I$(src)/.. -I$(srctree)
+flags-y += -O2 -fpic
+flags-y += -fno-stack-protector
+flags-y += -fno-omit-frame-pointer
+flags-y += -foptimize-sibling-calls
+flags-y += -fasynchronous-unwind-tables
+
+# Reset cf protections enabled by compiler default
+flags-y += $(call cc-option, -fcf-protection=none)
+flags-$(X86_USER_SHADOW_STACK) += $(call cc-option, -fcf-protection=return)
+# When user space IBT is supported, enable this.
+# flags-$(CONFIG_USER_IBT) += $(call cc-option, -fcf-protection=branch)
+
+flags-$(CONFIG_MITIGATION_RETPOLINE) += $(RETPOLINE_VDSO_CFLAGS)
+
+# These need to be conditional on $(vobjs) as they do not apply to
+# the output vdso*-image.o files which are standard kernel objects.
+$(vobjs) : KBUILD_AFLAGS := \
+	$(filter-out $(flags-remove-y),$(KBUILD_AFLAGS)) $(flags-y)
+$(vobjs) : KBUILD_CFLAGS := \
+	$(filter-out $(flags-remove-y),$(KBUILD_CFLAGS)) $(flags-y)
+
+#
+# The VDSO images are built using a special linker script.
+#
+VDSO_LDFLAGS := -shared --hash-style=both --build-id=sha1 --no-undefined \
+	$(call ld-option, --eh-frame-hdr) -Bsymbolic -z noexecstack
+
+quiet_cmd_vdso = VDSO    $@
+      cmd_vdso = $(LD) -o $@ \
+		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$*) \
+		       -T $(filter %.lds,$^) $(filter %.o,$^)
+quiet_cmd_vdso_and_check = VDSO    $@
+      cmd_vdso_and_check = $(cmd_vdso); $(cmd_vdso_check)
+
+$(obj)/vdso%.so.dbg: $(obj)/vdso%.lds FORCE
+	$(call if_changed,vdso_and_check)
+
+$(obj)/%.so: OBJCOPYFLAGS := -S --remove-section __ex_table
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+VDSO2C = $(objtree)/arch/x86/tools/vdso2c
+
+quiet_cmd_vdso2c = VDSO2C  $@
+      cmd_vdso2c = $(VDSO2C) $< $(<:%.dbg=%) $@
+
+$(obj)/%-image.c: $(obj)/%.so.dbg $(obj)/%.so $(VDSO2C) FORCE
+	$(call if_changed,vdso2c)
+
+$(obj)/%-image.o: $(obj)/%-image.c
diff --git a/arch/x86/entry/vdso/vdso-note.S b/arch/x86/entry/vdso/common/note.S
similarity index 62%
rename from arch/x86/entry/vdso/vdso-note.S
rename to arch/x86/entry/vdso/common/note.S
index 79423170118f..2cbd39939dc6 100644
--- a/arch/x86/entry/vdso/vdso-note.S
+++ b/arch/x86/entry/vdso/common/note.S
@@ -1,13 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * This supplies .note.* sections to go into the PT_NOTE inside the vDSO text.
  * Here we can supply some information useful to userland.
  */
 
 #include <linux/build-salt.h>
-#include <linux/uts.h>
 #include <linux/version.h>
 #include <linux/elfnote.h>
 
+/* Ideally this would use UTS_NAME, but using a quoted string here
+   doesn't work. Remember to change this when changing the
+   kernel's name. */
 ELFNOTE_START(Linux, 0, "a")
 	.long LINUX_VERSION_CODE
 ELFNOTE_END
diff --git a/arch/x86/entry/vdso/vclock_gettime.c b/arch/x86/entry/vdso/common/vclock_gettime.c
similarity index 100%
rename from arch/x86/entry/vdso/vclock_gettime.c
rename to arch/x86/entry/vdso/common/vclock_gettime.c
diff --git a/arch/x86/entry/vdso/vdso-layout.lds.S b/arch/x86/entry/vdso/common/vdso-layout.lds.S
similarity index 100%
rename from arch/x86/entry/vdso/vdso-layout.lds.S
rename to arch/x86/entry/vdso/common/vdso-layout.lds.S
diff --git a/arch/x86/entry/vdso/vgetcpu.c b/arch/x86/entry/vdso/common/vgetcpu.c
similarity index 100%
rename from arch/x86/entry/vdso/vgetcpu.c
rename to arch/x86/entry/vdso/common/vgetcpu.c
diff --git a/arch/x86/entry/vdso/vdso32/Makefile b/arch/x86/entry/vdso/vdso32/Makefile
new file mode 100644
index 000000000000..add6afb484ba
--- /dev/null
+++ b/arch/x86/entry/vdso/vdso32/Makefile
@@ -0,0 +1,24 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# 32-bit vDSO images for x86.
+#
+
+# The vDSOs built in this directory
+vdsos-y			:= 32
+
+# Files to link into the vDSO:
+vobjs-y			:= note.o vclock_gettime.o vgetcpu.o
+vobjs-y			+= system_call.o sigreturn.o
+
+# Compilation flags
+flags-y			:= -DBUILD_VDSO32 -m32 -mregparm=0
+flags-$(CONFIG_X86_64)	+= -include $(src)/fake_32bit_build.h
+flags-remove-y          := -m64
+
+# The location of this include matters!
+include $(src)/../common/Makefile.include
+
+# Linker options for the vdso
+VDSO_LDFLAGS_32		:= -m elf_i386 -soname linux-gate.so.1
+
+$(obj)/vdso32.so.dbg: $(vobjs)
diff --git a/arch/x86/entry/vdso/vdso32/note.S b/arch/x86/entry/vdso/vdso32/note.S
index 2cbd39939dc6..62d8aa51ce99 100644
--- a/arch/x86/entry/vdso/vdso32/note.S
+++ b/arch/x86/entry/vdso/vdso32/note.S
@@ -1,18 +1 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * This supplies .note.* sections to go into the PT_NOTE inside the vDSO text.
- * Here we can supply some information useful to userland.
- */
-
-#include <linux/build-salt.h>
-#include <linux/version.h>
-#include <linux/elfnote.h>
-
-/* Ideally this would use UTS_NAME, but using a quoted string here
-   doesn't work. Remember to change this when changing the
-   kernel's name. */
-ELFNOTE_START(Linux, 0, "a")
-	.long LINUX_VERSION_CODE
-ELFNOTE_END
-
-BUILD_SALT
+#include "common/note.S"
diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index d33c6513fd2c..2a15634bbe75 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -52,7 +52,7 @@ __kernel_vsyscall:
 	#define SYSENTER_SEQUENCE	"movl %esp, %ebp; sysenter"
 	#define SYSCALL_SEQUENCE	"movl %ecx, %ebp; syscall"
 
-#ifdef CONFIG_X86_64
+#ifdef BUILD_VDSO32_64
 	/* If SYSENTER (Intel) or SYSCALL32 (AMD) is available, use it. */
 	ALTERNATIVE_2 "", SYSENTER_SEQUENCE, X86_FEATURE_SYSENTER32, \
 	                  SYSCALL_SEQUENCE,  X86_FEATURE_SYSCALL32
diff --git a/arch/x86/entry/vdso/vdso32/vclock_gettime.c b/arch/x86/entry/vdso/vdso32/vclock_gettime.c
index 86981decfea8..1481f0021b9f 100644
--- a/arch/x86/entry/vdso/vdso32/vclock_gettime.c
+++ b/arch/x86/entry/vdso/vdso32/vclock_gettime.c
@@ -1,4 +1 @@
-// SPDX-License-Identifier: GPL-2.0
-#define BUILD_VDSO32
-#include "fake_32bit_build.h"
-#include "../vclock_gettime.c"
+#include "common/vclock_gettime.c"
diff --git a/arch/x86/entry/vdso/vdso32/vdso32.lds.S b/arch/x86/entry/vdso/vdso32/vdso32.lds.S
index 8a3be07006bb..8a853543fc0d 100644
--- a/arch/x86/entry/vdso/vdso32/vdso32.lds.S
+++ b/arch/x86/entry/vdso/vdso32/vdso32.lds.S
@@ -11,7 +11,7 @@
 
 #define BUILD_VDSO32
 
-#include "../vdso-layout.lds.S"
+#include "common/vdso-layout.lds.S"
 
 /* The ELF entry point can be used to set the AT_SYSINFO value.  */
 ENTRY(__kernel_vsyscall);
diff --git a/arch/x86/entry/vdso/vdso32/vgetcpu.c b/arch/x86/entry/vdso/vdso32/vgetcpu.c
index 3a9791f5e998..00cc8325a020 100644
--- a/arch/x86/entry/vdso/vdso32/vgetcpu.c
+++ b/arch/x86/entry/vdso/vdso32/vgetcpu.c
@@ -1,3 +1 @@
-// SPDX-License-Identifier: GPL-2.0
-#include "fake_32bit_build.h"
-#include "../vgetcpu.c"
+#include "common/vgetcpu.c"
diff --git a/arch/x86/entry/vdso/vdso64/Makefile b/arch/x86/entry/vdso/vdso64/Makefile
new file mode 100644
index 000000000000..bfffaf1aeecc
--- /dev/null
+++ b/arch/x86/entry/vdso/vdso64/Makefile
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# 64-bit vDSO images for x86.
+#
+
+# The vDSOs built in this directory
+vdsos-y				:= 64
+vdsos-$(CONFIG_X86_X32_ABI)	+= x32
+
+# Files to link into the vDSO:
+vobjs-y				:= note.o vclock_gettime.o vgetcpu.o
+vobjs-y				+= vgetrandom.o vgetrandom-chacha.o
+vobjs-$(CONFIG_X86_SGX)		+= vsgx.o
+
+# Compilation flags
+flags-y				:= -DBUILD_VDSO64 -m64 -mcmodel=small
+
+# The location of this include matters!
+include $(src)/../common/Makefile.include
+
+#
+# X32 processes use x32 vDSO to access 64bit kernel data.
+#
+# Build x32 vDSO image:
+# 1. Compile x32 vDSO as 64bit.
+# 2. Convert object files to x32.
+# 3. Build x32 VDSO image with x32 objects, which contains 64bit codes
+# so that it can reach 64bit address space with 64bit pointers.
+#
+
+# Convert 64bit object file to x32 for x32 vDSO.
+quiet_cmd_x32 = X32     $@
+      cmd_x32 = $(OBJCOPY) -O elf32-x86-64 $< $@
+
+$(obj)/%-x32.o: $(obj)/%.o FORCE
+	$(call if_changed,x32)
+
+vobjsx32 = $(patsubst %.o,%-x32.o,$(vobjs))
+targets += $(patsubst %.o,%-x32.o,$(vobjs-y))
+
+# Linker options for the vdso
+VDSO_LDFLAGS_64  := -m elf_x86_64 -soname linux-vdso.so.1 -z max-page-size=4096
+VDSO_LDFLAGS_x32 := $(subst elf_x86_64,elf32_x86_64,$(VDSO_LDFLAGS_64))
+
+$(obj)/vdso64.so.dbg:	$(vobjs)
+$(obj)/vdsox32.so.dbg:	$(vobjsx32)
diff --git a/arch/x86/entry/vdso/vdso64/note.S b/arch/x86/entry/vdso/vdso64/note.S
new file mode 100644
index 000000000000..62d8aa51ce99
--- /dev/null
+++ b/arch/x86/entry/vdso/vdso64/note.S
@@ -0,0 +1 @@
+#include "common/note.S"
diff --git a/arch/x86/entry/vdso/vdso64/vclock_gettime.c b/arch/x86/entry/vdso/vdso64/vclock_gettime.c
new file mode 100644
index 000000000000..1481f0021b9f
--- /dev/null
+++ b/arch/x86/entry/vdso/vdso64/vclock_gettime.c
@@ -0,0 +1 @@
+#include "common/vclock_gettime.c"
diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vdso64/vdso64.lds.S
similarity index 94%
rename from arch/x86/entry/vdso/vdso.lds.S
rename to arch/x86/entry/vdso/vdso64/vdso64.lds.S
index 0bab5f4af6d1..5ce3f2b6373a 100644
--- a/arch/x86/entry/vdso/vdso.lds.S
+++ b/arch/x86/entry/vdso/vdso64/vdso64.lds.S
@@ -9,7 +9,7 @@
 
 #define BUILD_VDSO64
 
-#include "vdso-layout.lds.S"
+#include "common/vdso-layout.lds.S"
 
 /*
  * This controls what userland symbols we export from the vDSO.
diff --git a/arch/x86/entry/vdso/vdsox32.lds.S b/arch/x86/entry/vdso/vdso64/vdsox32.lds.S
similarity index 92%
rename from arch/x86/entry/vdso/vdsox32.lds.S
rename to arch/x86/entry/vdso/vdso64/vdsox32.lds.S
index 16a8050a4fb6..3dbd20c8dacc 100644
--- a/arch/x86/entry/vdso/vdsox32.lds.S
+++ b/arch/x86/entry/vdso/vdso64/vdsox32.lds.S
@@ -9,7 +9,7 @@
 
 #define BUILD_VDSOX32
 
-#include "vdso-layout.lds.S"
+#include "common/vdso-layout.lds.S"
 
 /*
  * This controls what userland symbols we export from the vDSO.
diff --git a/arch/x86/entry/vdso/vdso64/vgetcpu.c b/arch/x86/entry/vdso/vdso64/vgetcpu.c
new file mode 100644
index 000000000000..00cc8325a020
--- /dev/null
+++ b/arch/x86/entry/vdso/vdso64/vgetcpu.c
@@ -0,0 +1 @@
+#include "common/vgetcpu.c"
diff --git a/arch/x86/entry/vdso/vgetrandom-chacha.S b/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
similarity index 100%
rename from arch/x86/entry/vdso/vgetrandom-chacha.S
rename to arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
diff --git a/arch/x86/entry/vdso/vgetrandom.c b/arch/x86/entry/vdso/vdso64/vgetrandom.c
similarity index 91%
rename from arch/x86/entry/vdso/vgetrandom.c
rename to arch/x86/entry/vdso/vdso64/vgetrandom.c
index 430862b8977c..6a95d36b12d9 100644
--- a/arch/x86/entry/vdso/vgetrandom.c
+++ b/arch/x86/entry/vdso/vdso64/vgetrandom.c
@@ -4,7 +4,7 @@
  */
 #include <linux/types.h>
 
-#include "../../../../lib/vdso/getrandom.c"
+#include "lib/vdso/getrandom.c"
 
 ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len)
 {
diff --git a/arch/x86/entry/vdso/vsgx.S b/arch/x86/entry/vdso/vdso64/vsgx.S
similarity index 100%
rename from arch/x86/entry/vdso/vsgx.S
rename to arch/x86/entry/vdso/vdso64/vsgx.S
-- 
2.52.0

