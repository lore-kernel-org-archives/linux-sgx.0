Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173F22C0F96;
	Wed, 12 Nov 2025 20:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762979032; cv=none; b=ut1QRDl06lpICSK7EYoT9hm7+mBtan/GD3k+z3xsSb6K/Uae+SX9QzISd+IWTHWedXkMkoBLN++ANSPuICYTXHRNJxF2W3EqTwvW6J6VOn6f5Y7aeSObTup/aPiWGsCp7KpBKk8tO2DSsa0U8o+tH1o6HQhfWO69qz7SKB23GEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762979032; c=relaxed/simple;
	bh=VdK7Sw/uu7+b7c1UUf3GRlYMrJViBS8fbzHr8lx3IeM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTnkHU4DuyE1CQywfbCdOiCVc6yzy2Tyu73whaSD9ayBxToPaBJtWOcy5CIMl8oee5yvaRjd6Hprk9OHKJQypZF2j8KjyR0ydv4hMapwFA12LltrGoDUP3IG9If9OHBMvLg7PPDGX15FyHGrQyxSErqaWQL1CNe0IeSgW4+8Itw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=m5Zdg3v6; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="m5Zdg3v6"
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACKN2M5978372
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Nov 2025 12:23:16 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACKN2M5978372
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762978998;
	bh=kKepbIurdihWBOSv7qfxVjB2xtYQNTgrV9okxaVFtJY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=m5Zdg3v6NVwk5n3XG9KSuQXOOMS2SeHI7FvfxMGCwHyBkA4GLazgEU/ibfCXefRP5
	 NDyff88v5Po6/9PBN7H3oL8d1C/L/La1SNXMmZfOvdJ6bkQktDmzGqhpXb0qd8Z9fH
	 Cj/nXsP2LbPYPvPYIWATaJNSbhh8oX+WwKVM3yz3NMhvFuhz/ZUZaZefJFGLi+tf9l
	 3WmhxMzphWWWhv3ehR3oxOSx46DqLCZDPDa6LpJOvGhPh27BuWtl71XQVrM7ROIZwN
	 vF0eIDeqp+hcfbYHWyxP2Ib/6JMQj0vX02iIFUMHegXtp4bPlBP+c3+Ax9e0MnywIm
	 S4bdBCckfPnoA==
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
Subject: [PATCH v3 7/9] x86/vdso: abstract out vdso system call internals
Date: Wed, 12 Nov 2025 12:22:52 -0800
Message-ID: <20251112202258.1310754-8-hpa@zytor.com>
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

Abstract out the calling of true system calls from the vdso into
macros.

It has been a very long time since gcc did not allow %ebx or %ebp in
inline asm in 32-bit PIC mode; remove the corresponding hacks.

Remove the use of memory output constraints in gettimeofday.h in favor
of "memory" clobbers. The resulting code is identical for the current
use cases, as the system call is usually a terminal fallback anyway,
and it merely complicates the macroization.

This patch adds only a handful of more lines of code than it removes,
and in fact could be made substantially smaller by removing the macros
for the argument counts that aren't currently used, however, it seems
better to be general from the start.

[ v3: remove stray comment from prototyping; remove VDSO_SYSCALL6()
      since it would require special handling on 32 bits and is
      currently unused. (Uros Biszjak)

      Indent nested preprocessor directives. ]

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/include/asm/vdso/gettimeofday.h | 108 ++---------------------
 arch/x86/include/asm/vdso/sys_call.h     | 103 +++++++++++++++++++++
 2 files changed, 111 insertions(+), 100 deletions(-)
 create mode 100644 arch/x86/include/asm/vdso/sys_call.h

diff --git a/arch/x86/include/asm/vdso/gettimeofday.h b/arch/x86/include/asm/vdso/gettimeofday.h
index 73b2e7ee8f0f..3cf214cc4a75 100644
--- a/arch/x86/include/asm/vdso/gettimeofday.h
+++ b/arch/x86/include/asm/vdso/gettimeofday.h
@@ -18,6 +18,7 @@
 #include <asm/msr.h>
 #include <asm/pvclock.h>
 #include <clocksource/hyperv_timer.h>
+#include <asm/vdso/sys_call.h>
 
 #define VDSO_HAS_TIME 1
 
@@ -53,130 +54,37 @@ extern struct ms_hyperv_tsc_page hvclock_page
 	__attribute__((visibility("hidden")));
 #endif
 
-#ifndef BUILD_VDSO32
-
 static __always_inline
 long clock_gettime_fallback(clockid_t _clkid, struct __kernel_timespec *_ts)
 {
-	long ret;
-
-	asm ("syscall" : "=a" (ret), "=m" (*_ts) :
-	     "0" (__NR_clock_gettime), "D" (_clkid), "S" (_ts) :
-	     "rcx", "r11");
-
-	return ret;
+	return VDSO_SYSCALL2(clock_gettime,64,_clkid,_ts);
 }
 
 static __always_inline
 long gettimeofday_fallback(struct __kernel_old_timeval *_tv,
 			   struct timezone *_tz)
 {
-	long ret;
-
-	asm("syscall" : "=a" (ret) :
-	    "0" (__NR_gettimeofday), "D" (_tv), "S" (_tz) : "memory");
-
-	return ret;
+	return VDSO_SYSCALL2(gettimeofday,,_tv,_tz);
 }
 
 static __always_inline
 long clock_getres_fallback(clockid_t _clkid, struct __kernel_timespec *_ts)
 {
-	long ret;
-
-	asm ("syscall" : "=a" (ret), "=m" (*_ts) :
-	     "0" (__NR_clock_getres), "D" (_clkid), "S" (_ts) :
-	     "rcx", "r11");
-
-	return ret;
+	return VDSO_SYSCALL2(clock_getres,_time64,_clkid,_ts);
 }
 
-#else
-
-static __always_inline
-long clock_gettime_fallback(clockid_t _clkid, struct __kernel_timespec *_ts)
-{
-	long ret;
-
-	asm (
-		"mov %%ebx, %%edx \n"
-		"mov %[clock], %%ebx \n"
-		"call __kernel_vsyscall \n"
-		"mov %%edx, %%ebx \n"
-		: "=a" (ret), "=m" (*_ts)
-		: "0" (__NR_clock_gettime64), [clock] "g" (_clkid), "c" (_ts)
-		: "edx");
-
-	return ret;
-}
+#ifndef CONFIG_X86_64
 
 static __always_inline
 long clock_gettime32_fallback(clockid_t _clkid, struct old_timespec32 *_ts)
 {
-	long ret;
-
-	asm (
-		"mov %%ebx, %%edx \n"
-		"mov %[clock], %%ebx \n"
-		"call __kernel_vsyscall \n"
-		"mov %%edx, %%ebx \n"
-		: "=a" (ret), "=m" (*_ts)
-		: "0" (__NR_clock_gettime), [clock] "g" (_clkid), "c" (_ts)
-		: "edx");
-
-	return ret;
-}
-
-static __always_inline
-long gettimeofday_fallback(struct __kernel_old_timeval *_tv,
-			   struct timezone *_tz)
-{
-	long ret;
-
-	asm(
-		"mov %%ebx, %%edx \n"
-		"mov %2, %%ebx \n"
-		"call __kernel_vsyscall \n"
-		"mov %%edx, %%ebx \n"
-		: "=a" (ret)
-		: "0" (__NR_gettimeofday), "g" (_tv), "c" (_tz)
-		: "memory", "edx");
-
-	return ret;
+	return VDSO_SYSCALL2(clock_gettime,,_clkid,_ts);
 }
 
 static __always_inline long
-clock_getres_fallback(clockid_t _clkid, struct __kernel_timespec *_ts)
-{
-	long ret;
-
-	asm (
-		"mov %%ebx, %%edx \n"
-		"mov %[clock], %%ebx \n"
-		"call __kernel_vsyscall \n"
-		"mov %%edx, %%ebx \n"
-		: "=a" (ret), "=m" (*_ts)
-		: "0" (__NR_clock_getres_time64), [clock] "g" (_clkid), "c" (_ts)
-		: "edx");
-
-	return ret;
-}
-
-static __always_inline
-long clock_getres32_fallback(clockid_t _clkid, struct old_timespec32 *_ts)
+clock_getres32_fallback(clockid_t _clkid, struct old_timespec32 *_ts)
 {
-	long ret;
-
-	asm (
-		"mov %%ebx, %%edx \n"
-		"mov %[clock], %%ebx \n"
-		"call __kernel_vsyscall \n"
-		"mov %%edx, %%ebx \n"
-		: "=a" (ret), "=m" (*_ts)
-		: "0" (__NR_clock_getres), [clock] "g" (_clkid), "c" (_ts)
-		: "edx");
-
-	return ret;
+	return VDSO_SYSCALL2(clock_getres,,_clkid,_ts);
 }
 
 #endif
diff --git a/arch/x86/include/asm/vdso/sys_call.h b/arch/x86/include/asm/vdso/sys_call.h
new file mode 100644
index 000000000000..dcfd17c6dd57
--- /dev/null
+++ b/arch/x86/include/asm/vdso/sys_call.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Macros for issuing an inline system call from the vDSO.
+ */
+
+#ifndef X86_ASM_VDSO_SYS_CALL_H
+#define X86_ASM_VDSO_SYS_CALL_H
+
+#include <linux/compiler.h>
+#include <asm/cpufeatures.h>
+#include <asm/alternative.h>
+
+#ifdef CONFIG_X86_64
+# define __sys_instr	"syscall"
+# define __sys_clobber	"rcx", "r11", "memory"
+# define __sys_nr(x,y)	__NR_ ## x
+# define __sys_reg1	"rdi"
+# define __sys_reg2	"rsi"
+# define __sys_reg3	"rdx"
+# define __sys_reg4	"r10"
+# define __sys_reg5	"r8"
+#else
+# define __sys_instr	"call __kernel_vsyscall"
+# define __sys_clobber	"memory"
+# define __sys_nr(x,y)	__NR_ ## x ## y
+# define __sys_reg1	"ebx"
+# define __sys_reg2	"ecx"
+# define __sys_reg3	"edx"
+# define __sys_reg4	"esi"
+# define __sys_reg5	"edi"
+#endif
+
+/*
+ * Example usage:
+ *
+ * result = VDSO_SYSCALL3(foo,64,x,y,z);
+ *
+ * ... calls foo(x,y,z) on 64 bits, and foo64(x,y,z) on 32 bits.
+ *
+ * VDSO_SYSCALL6() is currently missing, because it would require
+ * special handling for %ebp on 32 bits when the vdso is compiled with
+ * frame pointers enabled (the default on 32 bits.) Add it as a special
+ * case when and if it becomes necessary.
+ */
+#define _VDSO_SYSCALL(name,suf32,...)					\
+	({								\
+		long _sys_num_ret = __sys_nr(name,suf32);		\
+		asm_inline volatile(					\
+			__sys_instr					\
+			: "+a" (_sys_num_ret)				\
+			: __VA_ARGS__					\
+			: __sys_clobber);				\
+		_sys_num_ret;						\
+	})
+
+#define VDSO_SYSCALL0(name,suf32)					\
+	_VDSO_SYSCALL(name,suf32)
+#define VDSO_SYSCALL1(name,suf32,a1)					\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1));				\
+	})
+#define VDSO_SYSCALL2(name,suf32,a1,a2)				\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		register long _sys_arg2 asm(__sys_reg2) = (long)(a2);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1), "r" (_sys_arg2));	\
+	})
+#define VDSO_SYSCALL3(name,suf32,a1,a2,a3)				\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		register long _sys_arg2 asm(__sys_reg2) = (long)(a2);	\
+		register long _sys_arg3 asm(__sys_reg3) = (long)(a3);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1), "r" (_sys_arg2),		\
+			      "r" (_sys_arg3));				\
+	})
+#define VDSO_SYSCALL4(name,suf32,a1,a2,a3,a4)				\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		register long _sys_arg2 asm(__sys_reg2) = (long)(a2);	\
+		register long _sys_arg3 asm(__sys_reg3) = (long)(a3);	\
+		register long _sys_arg4 asm(__sys_reg4) = (long)(a4);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1), "r" (_sys_arg2),		\
+			      "r" (_sys_arg3), "r" (_sys_arg4));	\
+	})
+#define VDSO_SYSCALL5(name,suf32,a1,a2,a3,a4,a5)			\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		register long _sys_arg2 asm(__sys_reg2) = (long)(a2);	\
+		register long _sys_arg3 asm(__sys_reg3) = (long)(a3);	\
+		register long _sys_arg4 asm(__sys_reg4) = (long)(a4);	\
+		register long _sys_arg5 asm(__sys_reg5) = (long)(a5);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1), "r" (_sys_arg2),		\
+			      "r" (_sys_arg3), "r" (_sys_arg4),		\
+			      "r" (_sys_arg5));				\
+	})
+
+#endif /* X86_VDSO_SYS_CALL_H */
-- 
2.51.1

