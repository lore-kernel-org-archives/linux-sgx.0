Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EBC1CAA79;
	Wed, 12 Nov 2025 20:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762979022; cv=none; b=kCaOstTE9UI+NVYUtD1gpqAEJM/PUflGD+GoyQI1z7W83Gn/JyuWVWFl3M04aMtgANLWDnrp+QPRkQ9eeABEK9CSbTbYaktX40PlQ0U0xNit3Nlk/03mfIEid8kbzdbk7Fo4MCaQ9SXFY69JtwAt/Z7mYKGQVFUC9QhmhTV/IRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762979022; c=relaxed/simple;
	bh=Ggof8QFLQVXbbyG4CTdT5OVZw9nU3Adf0XwGidmrRO8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaPACbpwH+AvHbNGrr1SL2ISvy9MEpwNFwUqa+HXynnE/x6qg+DgZTNlEQMfo5xQrY/7nNnAnipLAvQuWz8oirJUoogEdlbV2mOYlrTFT/R1vu1kmDnvL/eyJ81Uyiyp51OG9Df+s77soHYTPeCI2s8+ChPlEIMvWzggIApUCxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LgNS1/eb; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LgNS1/eb"
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACKN2Lx978372
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Nov 2025 12:23:06 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACKN2Lx978372
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762978987;
	bh=6MH27EeqDLw8amuPQokZD4InT1d5GPZPkd9MxbYgWsE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LgNS1/ebwUUJLI6wX04wB/UVMoHRcPurr/w7mtuCJ07Rjfrjfw8sGSu+YDE762LUv
	 Qf5qPvR1qIFGc/oh2qVTiC8MIxlvueIxWS0sWvzzrypbb91W0nMmBppERfGIwm6Rqy
	 NPtaoOQrkEYeYKHXIJBUOxfceLx/LZxUJHpsOr5lBP1GQNI7Pv0shPJgYwmf3ExWTU
	 tcmc6bxOkKs5ZCrBbWAdMvVpFzs+/bSRcfY1jCojSSJ92vON6q91cQ8jtbQThI7+i+
	 ryN8RAabdY2zAlCO2OKGnpxxgzX1NcaB0FhlWV2Rjvr95mpCEH9O9GTqSMltyH2B1a
	 0ctgt6hMkXhHA==
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
Subject: [PATCH v3 1/9] x86/entry/vdso: rename vdso_image_* to vdso*_image
Date: Wed, 12 Nov 2025 12:22:46 -0800
Message-ID: <20251112202258.1310754-2-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112202258.1310754-1-hpa@zytor.com>
References: <20251112202258.1310754-1-hpa@zytor.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The .so files for the vdso are named vdso*.so, and these structures
are image of the corresponding vdso. Naming them accordingly is more
consistent, very slightly more compact (by one character...) and
simplifies the Makefile just a little bit.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/syscall_32.c  |  2 +-
 arch/x86/entry/vdso/Makefile |  8 ++++----
 arch/x86/entry/vdso/vma.c    | 10 +++++-----
 arch/x86/include/asm/elf.h   |  2 +-
 arch/x86/include/asm/vdso.h  |  6 +++---
 arch/x86/kernel/process_64.c |  6 +++---
 arch/x86/kernel/signal_32.c  |  4 ++--
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/entry/syscall_32.c b/arch/x86/entry/syscall_32.c
index 2b15ea17bb7c..eff33a4e0adc 100644
--- a/arch/x86/entry/syscall_32.c
+++ b/arch/x86/entry/syscall_32.c
@@ -318,7 +318,7 @@ __visible noinstr bool do_fast_syscall_32(struct pt_regs *regs)
 	 * convention.  Adjust regs so it looks like we entered using int80.
 	 */
 	unsigned long landing_pad = (unsigned long)current->mm->context.vdso +
-					vdso_image_32.sym_int80_landing_pad;
+					vdso32_image.sym_int80_landing_pad;
 
 	/*
 	 * SYSENTER loses EIP, and even SYSCALL32 needs us to skip forward
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index f247f5f5cb44..7f833026d5b2 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -16,9 +16,9 @@ vobjs-$(CONFIG_X86_SGX)	+= vsgx.o
 obj-y						+= vma.o extable.o
 
 # vDSO images to build:
-obj-$(CONFIG_X86_64)				+= vdso-image-64.o
-obj-$(CONFIG_X86_X32_ABI)			+= vdso-image-x32.o
-obj-$(CONFIG_COMPAT_32)				+= vdso-image-32.o vdso32-setup.o
+obj-$(CONFIG_X86_64)				+= vdso64-image.o
+obj-$(CONFIG_X86_X32_ABI)			+= vdsox32-image.o
+obj-$(CONFIG_COMPAT_32)				+= vdso32-image.o vdso32-setup.o
 
 vobjs := $(addprefix $(obj)/, $(vobjs-y))
 vobjs32 := $(addprefix $(obj)/, $(vobjs32-y))
@@ -44,7 +44,7 @@ hostprogs += vdso2c
 quiet_cmd_vdso2c = VDSO2C  $@
       cmd_vdso2c = $(obj)/vdso2c $< $(<:%.dbg=%) $@
 
-$(obj)/vdso-image-%.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(obj)/vdso2c FORCE
+$(obj)/vdso%-image.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(obj)/vdso2c FORCE
 	$(call if_changed,vdso2c)
 
 #
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index afe105b2f907..8f98c2d7c7a9 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -65,7 +65,7 @@ static vm_fault_t vdso_fault(const struct vm_special_mapping *sm,
 static void vdso_fix_landing(const struct vdso_image *image,
 		struct vm_area_struct *new_vma)
 {
-	if (in_ia32_syscall() && image == &vdso_image_32) {
+	if (in_ia32_syscall() && image == &vdso32_image) {
 		struct pt_regs *regs = current_pt_regs();
 		unsigned long vdso_land = image->sym_int80_landing_pad;
 		unsigned long old_land_addr = vdso_land +
@@ -230,7 +230,7 @@ static int load_vdso32(void)
 	if (vdso32_enabled != 1)  /* Other values all mean "disabled" */
 		return 0;
 
-	return map_vdso(&vdso_image_32, 0);
+	return map_vdso(&vdso32_image, 0);
 }
 
 int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
@@ -239,7 +239,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 		if (!vdso64_enabled)
 			return 0;
 
-		return map_vdso(&vdso_image_64, 0);
+		return map_vdso(&vdso64_image, 0);
 	}
 
 	return load_vdso32();
@@ -252,7 +252,7 @@ int compat_arch_setup_additional_pages(struct linux_binprm *bprm,
 	if (IS_ENABLED(CONFIG_X86_X32_ABI) && x32) {
 		if (!vdso64_enabled)
 			return 0;
-		return map_vdso(&vdso_image_x32, 0);
+		return map_vdso(&vdsox32_image, 0);
 	}
 
 	if (IS_ENABLED(CONFIG_IA32_EMULATION))
@@ -267,7 +267,7 @@ bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
 	const struct vdso_image *image = current->mm->context.vdso_image;
 	unsigned long vdso = (unsigned long) current->mm->context.vdso;
 
-	if (in_ia32_syscall() && image == &vdso_image_32) {
+	if (in_ia32_syscall() && image == &vdso32_image) {
 		if (regs->ip == vdso + image->sym_vdso32_sigreturn_landing_pad ||
 		    regs->ip == vdso + image->sym_vdso32_rt_sigreturn_landing_pad)
 			return true;
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 6c8fdc96be7e..2ba5f166e58f 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -361,7 +361,7 @@ else if (IS_ENABLED(CONFIG_IA32_EMULATION))				\
 
 #define VDSO_ENTRY							\
 	((unsigned long)current->mm->context.vdso +			\
-	 vdso_image_32.sym___kernel_vsyscall)
+	 vdso32_image.sym___kernel_vsyscall)
 
 struct linux_binprm;
 
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index b7253ef3205a..e8afbe9faa5b 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -27,9 +27,9 @@ struct vdso_image {
 	long sym_vdso32_rt_sigreturn_landing_pad;
 };
 
-extern const struct vdso_image vdso_image_64;
-extern const struct vdso_image vdso_image_x32;
-extern const struct vdso_image vdso_image_32;
+extern const struct vdso_image vdso64_image;
+extern const struct vdso_image vdsox32_image;
+extern const struct vdso_image vdso32_image;
 
 extern int __init init_vdso_image(const struct vdso_image *image);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 52a5c03c353c..ae00c788962a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -942,14 +942,14 @@ long do_arch_prctl_64(struct task_struct *task, int option, unsigned long arg2)
 #ifdef CONFIG_CHECKPOINT_RESTORE
 # ifdef CONFIG_X86_X32_ABI
 	case ARCH_MAP_VDSO_X32:
-		return prctl_map_vdso(&vdso_image_x32, arg2);
+		return prctl_map_vdso(&vdsox32_image, arg2);
 # endif
 # ifdef CONFIG_IA32_EMULATION
 	case ARCH_MAP_VDSO_32:
-		return prctl_map_vdso(&vdso_image_32, arg2);
+		return prctl_map_vdso(&vdso32_image, arg2);
 # endif
 	case ARCH_MAP_VDSO_64:
-		return prctl_map_vdso(&vdso_image_64, arg2);
+		return prctl_map_vdso(&vdso64_image, arg2);
 #endif
 #ifdef CONFIG_ADDRESS_MASKING
 	case ARCH_GET_UNTAG_MASK:
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 42bbc42bd350..e55cf19e68fe 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -282,7 +282,7 @@ int ia32_setup_frame(struct ksignal *ksig, struct pt_regs *regs)
 		/* Return stub is in 32bit vsyscall page */
 		if (current->mm->context.vdso)
 			restorer = current->mm->context.vdso +
-				vdso_image_32.sym___kernel_sigreturn;
+				vdso32_image.sym___kernel_sigreturn;
 		else
 			restorer = &frame->retcode;
 	}
@@ -368,7 +368,7 @@ int ia32_setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
 		restorer = ksig->ka.sa.sa_restorer;
 	else
 		restorer = current->mm->context.vdso +
-			vdso_image_32.sym___kernel_rt_sigreturn;
+			vdso32_image.sym___kernel_rt_sigreturn;
 	unsafe_put_user(ptr_to_compat(restorer), &frame->pretcode, Efault);
 
 	/*
-- 
2.51.1

