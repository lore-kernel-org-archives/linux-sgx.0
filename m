Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786A22594BD;
	Wed, 12 Nov 2025 04:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762922331; cv=none; b=nNPshbnlC2gchhCunN5c3krjePovjAmkel3SzTGelRsHA9kaST408EbYP8AQVTGnpGQx3a/RrVXZuXGCFpaTCANTnEX6EDxW2E83YPkOUdLiFOd/PTbUedXT0Jjwe9QSU3h/AxTq6Nyf+3RrIyhAZvoBTPGAjWEFskn16r1hUZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762922331; c=relaxed/simple;
	bh=Z2D64GuUMELOolw9cKf4hzojFFY66C+zfDABA364ROY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSmhVBBgbj/v1Mt2ORJvC3vtpNEBWbJKBzEwJ/cEfAemtfS1Q6bBXveszR/bMnmZVj+T+aWvcn3jDeQqqbaQtHbqiwhK1e7MAA8tVb/s/zmWsACfIAbusCWE7iWRkQ4lRohZMUXHyULLPdJP2UvIjoJ6g9jxG1hxZc7HKHggOs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=i/IQlisW; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="i/IQlisW"
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AC4bYDT542538
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 11 Nov 2025 20:37:47 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AC4bYDT542538
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762922269;
	bh=DMqdBX9HO8+AZngQ2hCIyYV6RLWAiIgEKxARiQLqOYw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=i/IQlisWVBkqsZ6VqZoTW83K3NVYrvQYBx0Y3VkaFX9h4lgeU4fUuaWq30rZcuIfu
	 XxS/8UghVlWbL0SCp+tLs8Fk2bfBUHUipw/HU6f/H/nc0F2JzQYokibRdQER9Ie4hj
	 c0RHigxm1QzqyUHYFgj3dOqwCl1+cnp4EXzXWDWsjiujzBy+V55yG8akBI7m236YLU
	 fMMeyjFmYgfkdjPkTZMozP2KakLOnmUdmszea/IKCcggFtzUEQHAt0JRRp1xPis5og
	 fFV3A9zysNWH0QZLfWebtuLgf82jFhrCqMVCOJX0gl+5XFk/9aL7qrfrGqvQQ201hn
	 p7Q6pDw2hu7Sg==
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
Subject: [PATCH v2 7/9] x86/vdso: abstract out vdso system call internals
Date: Tue, 11 Nov 2025 20:37:25 -0800
Message-ID: <20251112043730.992152-8-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112043730.992152-1-hpa@zytor.com>
References: <20251112043730.992152-1-hpa@zytor.com>
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

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/include/asm/vdso/gettimeofday.h | 108 ++------------------
 arch/x86/include/asm/vdso/sys_call.h     | 119 +++++++++++++++++++++++
 2 files changed, 127 insertions(+), 100 deletions(-)
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
index 000000000000..6b1fbcdcbd5c
--- /dev/null
+++ b/arch/x86/include/asm/vdso/sys_call.h
@@ -0,0 +1,119 @@
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
+/*
+ * Note: only three arguments are currently supported,
+ * because there are no constraint letters for r10, r8, r9.
+ */
+#ifdef CONFIG_X86_64
+/* Using dummy output registers instead of clobbers avoids messing up
+   user-specified clobbers. */
+#define __sys_instr	"syscall"
+#define __sys_clobber	"rcx", "r11", "memory"
+#define __sys_nr(x,y)	__NR_ ## x
+#define __sys_reg1	"rdi"
+#define __sys_reg2	"rsi"
+#define __sys_reg3	"rdx"
+#define __sys_reg4	"r10"
+#define __sys_reg5	"r8"
+#define __sys_reg6	"r9"
+#else
+#define __sys_instr	"call __kernel_vsyscall"
+#define __sys_clobber	"memory"
+#define __sys_nr(x,y)	__NR_ ## x ## y
+#define __sys_reg1	"ebx"
+#define __sys_reg2	"ecx"
+#define __sys_reg3	"edx"
+#define __sys_reg4	"esi"
+#define __sys_reg5	"edi"
+#define __sys_reg6	"ebp"
+#endif
+
+/*
+ * Example usage:
+ *
+ * result = VDSO_SYSCALL3(foo,64,x,y,z);
+ *
+ * ... calls foo(x,y,z) on 64 bits, and foo64(x,y,z) on 32 bits.
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
+#define VDSO_SYSCALL6(name,suf32,a1,a2,a3,a4,a5,a6)			\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		register long _sys_arg2 asm(__sys_reg2) = (long)(a2);	\
+		register long _sys_arg3 asm(__sys_reg3) = (long)(a3);	\
+		register long _sys_arg4 asm(__sys_reg4) = (long)(a4);	\
+		register long _sys_arg5 asm(__sys_reg5) = (long)(a5);	\
+		register long _sys_arg6 asm(__sys_reg6) = (long)(a6);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1), "r" (_sys_arg2),		\
+			      "r" (_sys_arg3), "r" (_sys_arg4),		\
+			      "r" (_sys_arg5), "r" (_sys_arg6));	\
+	})
+
+#endif /* X86_VDSO_SYS_CALL_H */
-- 
2.51.1

