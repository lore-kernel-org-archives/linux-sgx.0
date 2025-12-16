Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B394318149;
	Tue, 16 Dec 2025 21:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765920430; cv=none; b=bAWcTKAY+qrBPQ8gcuvrBxS+fupcp8dZRU+f6Jk9HLQri9W+tmEH+f5baqnH8fx1C9VJCtwldwaeVkBL7MXXsOgJACirhILmEwXSnaH+bNg0uWExGOqPVtA/rwtL2sf7OH1VGzrcZvQ5FJnF3aOWGOrYNuQfy15KNXIo1W2XEHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765920430; c=relaxed/simple;
	bh=5wKIhwGqeQgVmQqB/Ukp3tnIYHAYzZuRhVE7Ujlvjt0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fj/CVFc5/LObMkQgkf9KBgY+qlnu8ZDQujzvSP2VLkkPqImeJI53HZtDoNZf1xRwOc+yhIU5c8VoXBoC40QTTU9yiyU6Wq02mnUWnxPhXUtrkKXB4/HqZ3sP81NPIhrxOkIpbjBjTBlF6/NxlzZHRUwkQIEKvg9ujBBfW2B00GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=xFYk0zw0; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="xFYk0zw0"
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGLQC282563820
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 16 Dec 2025 13:26:30 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGLQC282563820
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765920391;
	bh=XZJ8tAuCLXRb63lalw0MrBdPq41wQB+L/BAms3K0dhs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=xFYk0zw0ABhDZ/+NSSSRU+kjcZ2gGSmq4968oRbotr8DasKHhUx1jM7MT2dk++2M2
	 7TuCQ31r/TzRz+h4P1lARDpFsex13YxIg9gPMdvDX1VaxrMIYhFhHlKh1dLx5A0Z6m
	 45lK0+yc2Q+VMkddmfwfx7I1v2s1CXTfCrhHLK/b1JAvJBl9pu2kt5sPC/ALkIjuwi
	 oSwUlJun3dHTyK7ggnDEbCiJEGF5YKia7wuSKeLM+ZchRNfJl3+Nx36eonC18VDuAP
	 hifWqzAc0efJp/pcsceHRx6RNSHB58X6DPaQdhuxP2YXjN7qcSAQy6XPd9HoX4pq93
	 pqXZG5STlR9Ig==
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
Subject: [PATCH v4 09/10] x86/cpufeature: replace X86_FEATURE_SYSENTER32 with X86_FEATURE_SYSFAST32
Date: Tue, 16 Dec 2025 13:26:03 -0800
Message-ID: <20251216212606.1325678-10-hpa@zytor.com>
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

In most cases, the use of "fast 32-bit system call" depends either on
X86_FEATURE_SEP or X86_FEATURE_SYSENTER32 || X86_FEATURE_SYSCALL32.
However, nearly all the logic for both is identical.

Define X86_FEATURE_SYSFAST32 which indicates that *either* SYSENTER32 or
SYSCALL32 should be used, for either 32- or 64-bit kernels.  This
defaults to SYSENTER; use SYSCALL if the SYSCALL32 bit is also set.

As this removes ALL existing uses of X86_FEATURE_SYSENTER32, which is
a kernel-only synthetic feature bit, simply remove it and replace it
with X86_FEATURE_SYSFAST32.

This leaves an unused alternative for a true 32-bit kernel, but that
should really not matter in any way.

The clearing of X86_FEATURE_SYSCALL32 can be removed once the patches
for automatically clearing disabled features has been merged.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/Kconfig.cpufeatures             |  8 +++++++
 arch/x86/entry/vdso/vdso32/system_call.S |  8 ++-----
 arch/x86/include/asm/cpufeatures.h       |  2 +-
 arch/x86/kernel/cpu/centaur.c            |  3 ---
 arch/x86/kernel/cpu/common.c             |  8 +++++++
 arch/x86/kernel/cpu/intel.c              |  4 +---
 arch/x86/kernel/cpu/zhaoxin.c            |  4 +---
 arch/x86/kernel/fred.c                   |  2 +-
 arch/x86/xen/setup.c                     | 28 +++++++++++++++---------
 arch/x86/xen/smp_pv.c                    |  5 ++---
 arch/x86/xen/xen-ops.h                   |  1 -
 11 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/arch/x86/Kconfig.cpufeatures b/arch/x86/Kconfig.cpufeatures
index 733d5aff2456..423ac795baa7 100644
--- a/arch/x86/Kconfig.cpufeatures
+++ b/arch/x86/Kconfig.cpufeatures
@@ -56,6 +56,10 @@ config X86_REQUIRED_FEATURE_MOVBE
 	def_bool y
 	depends on MATOM
 
+config X86_REQUIRED_FEATURE_SYSFAST32
+	def_bool y
+	depends on X86_64 && !X86_FRED
+
 config X86_REQUIRED_FEATURE_CPUID
 	def_bool y
 	depends on X86_64
@@ -120,6 +124,10 @@ config X86_DISABLED_FEATURE_CENTAUR_MCR
 	def_bool y
 	depends on X86_64
 
+config X86_DISABLED_FEATURE_SYSCALL32
+	def_bool y
+	depends on !X86_64
+
 config X86_DISABLED_FEATURE_PCID
 	def_bool y
 	depends on !X86_64
diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index 2a15634bbe75..7b1c0f16e511 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -52,13 +52,9 @@ __kernel_vsyscall:
 	#define SYSENTER_SEQUENCE	"movl %esp, %ebp; sysenter"
 	#define SYSCALL_SEQUENCE	"movl %ecx, %ebp; syscall"
 
-#ifdef BUILD_VDSO32_64
 	/* If SYSENTER (Intel) or SYSCALL32 (AMD) is available, use it. */
-	ALTERNATIVE_2 "", SYSENTER_SEQUENCE, X86_FEATURE_SYSENTER32, \
-	                  SYSCALL_SEQUENCE,  X86_FEATURE_SYSCALL32
-#else
-	ALTERNATIVE "", SYSENTER_SEQUENCE, X86_FEATURE_SEP
-#endif
+	ALTERNATIVE_2 "", SYSENTER_SEQUENCE, X86_FEATURE_SYSFAST32, \
+			  SYSCALL_SEQUENCE,  X86_FEATURE_SYSCALL32
 
 	/* Enter using int $0x80 */
 	int	$0x80
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index c3b53beb1300..63b0f9aa9b3e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -84,7 +84,7 @@
 #define X86_FEATURE_PEBS		( 3*32+12) /* "pebs" Precise-Event Based Sampling */
 #define X86_FEATURE_BTS			( 3*32+13) /* "bts" Branch Trace Store */
 #define X86_FEATURE_SYSCALL32		( 3*32+14) /* syscall in IA32 userspace */
-#define X86_FEATURE_SYSENTER32		( 3*32+15) /* sysenter in IA32 userspace */
+#define X86_FEATURE_SYSFAST32		( 3*32+15) /* sysenter/syscall in IA32 userspace */
 #define X86_FEATURE_REP_GOOD		( 3*32+16) /* "rep_good" REP microcode works well */
 #define X86_FEATURE_AMD_LBR_V2		( 3*32+17) /* "amd_lbr_v2" AMD Last Branch Record Extension Version 2 */
 #define X86_FEATURE_CLEAR_CPU_BUF	( 3*32+18) /* Clear CPU buffers using VERW */
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index a3b55db35c96..9833f837141c 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -102,9 +102,6 @@ static void early_init_centaur(struct cpuinfo_x86 *c)
 	    (c->x86 >= 7))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
-#ifdef CONFIG_X86_64
-	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
-#endif
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e7ab22fce3b5..1c3261cae40c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1068,6 +1068,9 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 	init_scattered_cpuid_features(c);
 	init_speculation_control(c);
 
+	if (IS_ENABLED(CONFIG_X86_64) || cpu_has(c, X86_FEATURE_SEP))
+		set_cpu_cap(c, X86_FEATURE_SYSFAST32);
+
 	/*
 	 * Clear/Set all flags overridden by options, after probe.
 	 * This needs to happen each time we re-probe, which may happen
@@ -1813,6 +1816,11 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	 * that it can't be enabled in 32-bit mode.
 	 */
 	setup_clear_cpu_cap(X86_FEATURE_PCID);
+
+	/*
+	 * Never use SYSCALL on a 32-bit kernel
+	 */
+	setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
 #endif
 
 	/*
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 98ae4c37c93e..646ff33c4651 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -236,9 +236,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 		clear_cpu_cap(c, X86_FEATURE_PSE);
 	}
 
-#ifdef CONFIG_X86_64
-	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
-#else
+#ifndef CONFIG_X86_64
 	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
 	if (c->x86 == 15 && c->x86_cache_alignment == 64)
 		c->x86_cache_alignment = 128;
diff --git a/arch/x86/kernel/cpu/zhaoxin.c b/arch/x86/kernel/cpu/zhaoxin.c
index 89b1c8a70fe8..031379b7d4fa 100644
--- a/arch/x86/kernel/cpu/zhaoxin.c
+++ b/arch/x86/kernel/cpu/zhaoxin.c
@@ -59,9 +59,7 @@ static void early_init_zhaoxin(struct cpuinfo_x86 *c)
 {
 	if (c->x86 >= 0x6)
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-#ifdef CONFIG_X86_64
-	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
-#endif
+
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
diff --git a/arch/x86/kernel/fred.c b/arch/x86/kernel/fred.c
index 816187da3a47..e736b19e18de 100644
--- a/arch/x86/kernel/fred.c
+++ b/arch/x86/kernel/fred.c
@@ -68,7 +68,7 @@ void cpu_init_fred_exceptions(void)
 	idt_invalidate();
 
 	/* Use int $0x80 for 32-bit system calls in FRED mode */
-	setup_clear_cpu_cap(X86_FEATURE_SYSENTER32);
+	setup_clear_cpu_cap(X86_FEATURE_SYSFAST32);
 	setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
 }
 
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 3823e52aef52..ac8021c3a997 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -990,13 +990,6 @@ static int register_callback(unsigned type, const void *func)
 	return HYPERVISOR_callback_op(CALLBACKOP_register, &callback);
 }
 
-void xen_enable_sysenter(void)
-{
-	if (cpu_feature_enabled(X86_FEATURE_SYSENTER32) &&
-	    register_callback(CALLBACKTYPE_sysenter, xen_entry_SYSENTER_compat))
-		setup_clear_cpu_cap(X86_FEATURE_SYSENTER32);
-}
-
 void xen_enable_syscall(void)
 {
 	int ret;
@@ -1008,11 +1001,27 @@ void xen_enable_syscall(void)
 		   mechanism for syscalls. */
 	}
 
-	if (cpu_feature_enabled(X86_FEATURE_SYSCALL32) &&
-	    register_callback(CALLBACKTYPE_syscall32, xen_entry_SYSCALL_compat))
+	if (!cpu_feature_enabled(X86_FEATURE_SYSFAST32))
+		return;
+
+	if (cpu_feature_enabled(X86_FEATURE_SYSCALL32)) {
+		/* Use SYSCALL32 */
+		ret = register_callback(CALLBACKTYPE_syscall32,
+					xen_entry_SYSCALL_compat);
+
+	} else {
+		/* Use SYSENTER32 */
+		ret = register_callback(CALLBACKTYPE_sysenter,
+					xen_entry_SYSENTER_compat);
+	}
+
+	if (ret) {
 		setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
+		setup_clear_cpu_cap(X86_FEATURE_SYSFAST32);
+	}
 }
 
+
 static void __init xen_pvmmu_arch_setup(void)
 {
 	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_writable_pagetables);
@@ -1022,7 +1031,6 @@ static void __init xen_pvmmu_arch_setup(void)
 	    register_callback(CALLBACKTYPE_failsafe, xen_failsafe_callback))
 		BUG();
 
-	xen_enable_sysenter();
 	xen_enable_syscall();
 }
 
diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index 9bb8ff8bff30..c40f326f0c3a 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -65,10 +65,9 @@ static void cpu_bringup(void)
 	touch_softlockup_watchdog();
 
 	/* PVH runs in ring 0 and allows us to do native syscalls. Yay! */
-	if (!xen_feature(XENFEAT_supervisor_mode_kernel)) {
-		xen_enable_sysenter();
+	if (!xen_feature(XENFEAT_supervisor_mode_kernel))
 		xen_enable_syscall();
-	}
+
 	cpu = smp_processor_id();
 	identify_secondary_cpu(cpu);
 	set_cpu_sibling_map(cpu);
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 090349baec09..f6c331b20fad 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -60,7 +60,6 @@ phys_addr_t __init xen_find_free_area(phys_addr_t size);
 char * __init xen_memory_setup(void);
 void __init xen_arch_setup(void);
 void xen_banner(void);
-void xen_enable_sysenter(void);
 void xen_enable_syscall(void);
 void xen_vcpu_restore(void);
 
-- 
2.52.0

