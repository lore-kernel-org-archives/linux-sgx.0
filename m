Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAEF35FF6F
	for <linux-sgx@vger.kernel.org>; Tue,  6 Jan 2026 18:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767723004; cv=none; b=jrikZ1UBxw1OBDj1rysUIcqI5mukSl3srZ/Ysa+m5IhOE8Ll5j/oosJkOKWHuDxbiHsvU8aE7bg/NQE6plgv1KnCXCZ+fQk+DbH0efQ9lCgzcF2QQmhUDWC+MQbYM1u28PM04F51UgRX8uUgrCwnFgmqSe33wwJr5pf3ZZv3HgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767723004; c=relaxed/simple;
	bh=Jq+Uf5k124iv/BhQVifnXPdX8S5VoOMjHgpgJ2961Vs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=shpgnR2DbBNGtroUSYpdHNEsLul0wwcfuklyjD0aeHGn/MSIv+Nmk+H+RmZbBJJnCc2lC52AlUUaIWqN6P0t/8w/s7svlZWePcF0wUHtSl7UdiQUwl4lLBRpUDYyOO6UZ+zS8ymkI2T34uGQTOgnLp3Gv7ocNyRx8jJW8HuIK18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cro3nqED; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cro3nqED"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-382fb6d38f7so3164841fa.3
        for <linux-sgx@vger.kernel.org>; Tue, 06 Jan 2026 10:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767723000; x=1768327800; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tnFJTdAUFhEmW0tR2qamSfQ3pZ9alh5f7uC4JnPOGLk=;
        b=cro3nqED8vnpH0XhzJo1cFTS3095lKoa3SU7YvBK6AWTIYUMFqVwE4S6xln28CKsNM
         YwKknwZ2mlBy/bCM+LZKHqxg3k4W/Jru1zQC7I082c1otKhWWX1sL/QgJn8ZItVVuGSp
         b8c+dO/NkRtEGOpyHUGsDXxGYXk+cXHQHpYF5oTe5qS0IK44kCppkzLKXgrCe8OerjHQ
         q3UMilOrxX49/yIcLhl+C7O4ZTsFduh4I4Yn1m2FB0/8cIuzckA+xActFVcauP4QtFGS
         STsNMnFTjPT6RvecT2nHCHtFyKWKrF6D4XbKhFy8hLGCQ34pnPKmwb8cC7Bd8eiIgeyn
         04Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767723000; x=1768327800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tnFJTdAUFhEmW0tR2qamSfQ3pZ9alh5f7uC4JnPOGLk=;
        b=wHWB4kXc2BAlO910BuaZHOIMFCKTlvtNWym1fp8RsS+KUpRX8ZctGmILEuTtue1gFp
         FOmHWbFJkIFqsh1NwlGXkrdScMzZZyUTklb/kuKPpQe1sBQcM1EuBtU3RK6eZt3gNARP
         8MMeqi3DmpsYJXcKi4tyu2S+WsTllxqh+8+78M1lS6+zRtdmitFGjzLa1LV87A71B1a+
         +44lNsB+KH2uhI5bmd7YRUNKgvu4anTSG8h7HiJdXMzl5/+995c2XjpGbHjfHnl+hjZs
         2h7Ed/HHMgGdJsV+2R0dMwxipkbtC8vaSuMK8GdL7Ja772BbCFHLIraaSs6b5km56nFP
         GYiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUK97xBtYpuFK4QtacVeVC3Wmi1RTYvNeaFiNgbUh0h0/1w4T9M/0mCXSNH+Cx1dSU3mQ314HHv1o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjf90AC/xRUTjnjn9Eto7imkYzgelBehBDFy+s0kUxd70tlGBA
	+yBJyAXL6k4GORWRCjxfjITkbG3KoW1YHsb9DzYW10g1XIoYMqMzuL+pNjhqu9MoZ3l2Px+CWNR
	uf935CbVD7Mhbof6Pkst82Gd/T6TRl8U=
X-Gm-Gg: AY/fxX7WTGd7G52lkpF4iERkVF30odrfTxNoNq/pXK906nOjPkokjYTt2yknoT1GRUj
	Sezyj5vw47XbkDtgh5RbIoOtFWv275PFLiCQly5tZqRz+Vq6jNLShVChkIsrFqo2tSgQV1YbiwN
	cjOE4tOM/cRg4vdZ/b6cpsqklp5sQm9KFHf+D7YWmiMhxV+j8yw5EwBv+LUAdYN0INZM1ybgS4R
	kn2dy5uNVq4UWozmossg3XysgdERd8h/3obLo6z+Y/Sf+cmNB6bmgTXw8pCpTPWB1B2X2bfErHx
	gdLqmapshatXPdW5qL3bu7uFH7jvQizy3jvCPklLVHMrD5D6
X-Google-Smtp-Source: AGHT+IHMYU+nk1r5SKL7TSwqR3QLSy12FC5m91tH1LYgMH9CNfNRgKMZ574MhYRurVuFQRtgy5OSRqqEEKHj6a+SALI=
X-Received: by 2002:a05:651c:b1e:b0:37b:9976:df0d with SMTP id
 38308e7fff4ca-382eaac3863mr10517641fa.21.1767722999902; Tue, 06 Jan 2026
 10:09:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251216212606.1325678-1-hpa@zytor.com> <20251216212606.1325678-9-hpa@zytor.com>
In-Reply-To: <20251216212606.1325678-9-hpa@zytor.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Tue, 6 Jan 2026 19:09:48 +0100
X-Gm-Features: AQt7F2p_W3_5YudECGljLUVodss-gTpK6wtqg-lAs_JJhTsy4VEleAOJ12I6yk4
Message-ID: <CAFULd4bQ-0ZD8PeAYiK1WK6yhKctxTSPksJLGg4gmE1eqzKDNg@mail.gmail.com>
Subject: Re: [PATCH v4 08/10] x86/vdso: abstract out vdso system call internals
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Brian Gerst <brgerst@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, 
	Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-sgx@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 10:26=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wro=
te:
>
> Abstract out the calling of true system calls from the vdso into
> macros.
>
> It has been a very long time since gcc did not allow %ebx or %ebp in
> inline asm in 32-bit PIC mode; remove the corresponding hacks.
>
> Remove the use of memory output constraints in gettimeofday.h in favor
> of "memory" clobbers. The resulting code is identical for the current
> use cases, as the system call is usually a terminal fallback anyway,
> and it merely complicates the macroization.
>
> This patch adds only a handful of more lines of code than it removes,
> and in fact could be made substantially smaller by removing the macros
> for the argument counts that aren't currently used, however, it seems
> better to be general from the start.
>
> [ v3: remove stray comment from prototyping; remove VDSO_SYSCALL6()
>       since it would require special handling on 32 bits and is
>       currently unused. (Uros Biszjak)
>
>       Indent nested preprocessor directives. ]
>
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>

Acked-by: Uros Bizjak <ubizjak@gmail.com>

> ---
>  arch/x86/include/asm/vdso/gettimeofday.h | 108 ++---------------------
>  arch/x86/include/asm/vdso/sys_call.h     | 103 +++++++++++++++++++++
>  2 files changed, 111 insertions(+), 100 deletions(-)
>  create mode 100644 arch/x86/include/asm/vdso/sys_call.h
>
> diff --git a/arch/x86/include/asm/vdso/gettimeofday.h b/arch/x86/include/=
asm/vdso/gettimeofday.h
> index 73b2e7ee8f0f..3cf214cc4a75 100644
> --- a/arch/x86/include/asm/vdso/gettimeofday.h
> +++ b/arch/x86/include/asm/vdso/gettimeofday.h
> @@ -18,6 +18,7 @@
>  #include <asm/msr.h>
>  #include <asm/pvclock.h>
>  #include <clocksource/hyperv_timer.h>
> +#include <asm/vdso/sys_call.h>
>
>  #define VDSO_HAS_TIME 1
>
> @@ -53,130 +54,37 @@ extern struct ms_hyperv_tsc_page hvclock_page
>         __attribute__((visibility("hidden")));
>  #endif
>
> -#ifndef BUILD_VDSO32
> -
>  static __always_inline
>  long clock_gettime_fallback(clockid_t _clkid, struct __kernel_timespec *=
_ts)
>  {
> -       long ret;
> -
> -       asm ("syscall" : "=3Da" (ret), "=3Dm" (*_ts) :
> -            "0" (__NR_clock_gettime), "D" (_clkid), "S" (_ts) :
> -            "rcx", "r11");
> -
> -       return ret;
> +       return VDSO_SYSCALL2(clock_gettime,64,_clkid,_ts);
>  }
>
>  static __always_inline
>  long gettimeofday_fallback(struct __kernel_old_timeval *_tv,
>                            struct timezone *_tz)
>  {
> -       long ret;
> -
> -       asm("syscall" : "=3Da" (ret) :
> -           "0" (__NR_gettimeofday), "D" (_tv), "S" (_tz) : "memory");
> -
> -       return ret;
> +       return VDSO_SYSCALL2(gettimeofday,,_tv,_tz);
>  }
>
>  static __always_inline
>  long clock_getres_fallback(clockid_t _clkid, struct __kernel_timespec *_=
ts)
>  {
> -       long ret;
> -
> -       asm ("syscall" : "=3Da" (ret), "=3Dm" (*_ts) :
> -            "0" (__NR_clock_getres), "D" (_clkid), "S" (_ts) :
> -            "rcx", "r11");
> -
> -       return ret;
> +       return VDSO_SYSCALL2(clock_getres,_time64,_clkid,_ts);
>  }
>
> -#else
> -
> -static __always_inline
> -long clock_gettime_fallback(clockid_t _clkid, struct __kernel_timespec *=
_ts)
> -{
> -       long ret;
> -
> -       asm (
> -               "mov %%ebx, %%edx \n"
> -               "mov %[clock], %%ebx \n"
> -               "call __kernel_vsyscall \n"
> -               "mov %%edx, %%ebx \n"
> -               : "=3Da" (ret), "=3Dm" (*_ts)
> -               : "0" (__NR_clock_gettime64), [clock] "g" (_clkid), "c" (=
_ts)
> -               : "edx");
> -
> -       return ret;
> -}
> +#ifndef CONFIG_X86_64
>
>  static __always_inline
>  long clock_gettime32_fallback(clockid_t _clkid, struct old_timespec32 *_=
ts)
>  {
> -       long ret;
> -
> -       asm (
> -               "mov %%ebx, %%edx \n"
> -               "mov %[clock], %%ebx \n"
> -               "call __kernel_vsyscall \n"
> -               "mov %%edx, %%ebx \n"
> -               : "=3Da" (ret), "=3Dm" (*_ts)
> -               : "0" (__NR_clock_gettime), [clock] "g" (_clkid), "c" (_t=
s)
> -               : "edx");
> -
> -       return ret;
> -}
> -
> -static __always_inline
> -long gettimeofday_fallback(struct __kernel_old_timeval *_tv,
> -                          struct timezone *_tz)
> -{
> -       long ret;
> -
> -       asm(
> -               "mov %%ebx, %%edx \n"
> -               "mov %2, %%ebx \n"
> -               "call __kernel_vsyscall \n"
> -               "mov %%edx, %%ebx \n"
> -               : "=3Da" (ret)
> -               : "0" (__NR_gettimeofday), "g" (_tv), "c" (_tz)
> -               : "memory", "edx");
> -
> -       return ret;
> +       return VDSO_SYSCALL2(clock_gettime,,_clkid,_ts);
>  }
>
>  static __always_inline long
> -clock_getres_fallback(clockid_t _clkid, struct __kernel_timespec *_ts)
> -{
> -       long ret;
> -
> -       asm (
> -               "mov %%ebx, %%edx \n"
> -               "mov %[clock], %%ebx \n"
> -               "call __kernel_vsyscall \n"
> -               "mov %%edx, %%ebx \n"
> -               : "=3Da" (ret), "=3Dm" (*_ts)
> -               : "0" (__NR_clock_getres_time64), [clock] "g" (_clkid), "=
c" (_ts)
> -               : "edx");
> -
> -       return ret;
> -}
> -
> -static __always_inline
> -long clock_getres32_fallback(clockid_t _clkid, struct old_timespec32 *_t=
s)
> +clock_getres32_fallback(clockid_t _clkid, struct old_timespec32 *_ts)
>  {
> -       long ret;
> -
> -       asm (
> -               "mov %%ebx, %%edx \n"
> -               "mov %[clock], %%ebx \n"
> -               "call __kernel_vsyscall \n"
> -               "mov %%edx, %%ebx \n"
> -               : "=3Da" (ret), "=3Dm" (*_ts)
> -               : "0" (__NR_clock_getres), [clock] "g" (_clkid), "c" (_ts=
)
> -               : "edx");
> -
> -       return ret;
> +       return VDSO_SYSCALL2(clock_getres,,_clkid,_ts);
>  }
>
>  #endif
> diff --git a/arch/x86/include/asm/vdso/sys_call.h b/arch/x86/include/asm/=
vdso/sys_call.h
> new file mode 100644
> index 000000000000..dcfd17c6dd57
> --- /dev/null
> +++ b/arch/x86/include/asm/vdso/sys_call.h
> @@ -0,0 +1,103 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Macros for issuing an inline system call from the vDSO.
> + */
> +
> +#ifndef X86_ASM_VDSO_SYS_CALL_H
> +#define X86_ASM_VDSO_SYS_CALL_H
> +
> +#include <linux/compiler.h>
> +#include <asm/cpufeatures.h>
> +#include <asm/alternative.h>
> +
> +#ifdef CONFIG_X86_64
> +# define __sys_instr   "syscall"
> +# define __sys_clobber "rcx", "r11", "memory"
> +# define __sys_nr(x,y) __NR_ ## x
> +# define __sys_reg1    "rdi"
> +# define __sys_reg2    "rsi"
> +# define __sys_reg3    "rdx"
> +# define __sys_reg4    "r10"
> +# define __sys_reg5    "r8"
> +#else
> +# define __sys_instr   "call __kernel_vsyscall"
> +# define __sys_clobber "memory"
> +# define __sys_nr(x,y) __NR_ ## x ## y
> +# define __sys_reg1    "ebx"
> +# define __sys_reg2    "ecx"
> +# define __sys_reg3    "edx"
> +# define __sys_reg4    "esi"
> +# define __sys_reg5    "edi"
> +#endif
> +
> +/*
> + * Example usage:
> + *
> + * result =3D VDSO_SYSCALL3(foo,64,x,y,z);
> + *
> + * ... calls foo(x,y,z) on 64 bits, and foo64(x,y,z) on 32 bits.
> + *
> + * VDSO_SYSCALL6() is currently missing, because it would require
> + * special handling for %ebp on 32 bits when the vdso is compiled with
> + * frame pointers enabled (the default on 32 bits.) Add it as a special
> + * case when and if it becomes necessary.
> + */
> +#define _VDSO_SYSCALL(name,suf32,...)                                  \
> +       ({                                                              \
> +               long _sys_num_ret =3D __sys_nr(name,suf32);              =
 \
> +               asm_inline volatile(                                    \
> +                       __sys_instr                                     \
> +                       : "+a" (_sys_num_ret)                           \
> +                       : __VA_ARGS__                                   \
> +                       : __sys_clobber);                               \
> +               _sys_num_ret;                                           \
> +       })
> +
> +#define VDSO_SYSCALL0(name,suf32)                                      \
> +       _VDSO_SYSCALL(name,suf32)
> +#define VDSO_SYSCALL1(name,suf32,a1)                                   \
> +       ({                                                              \
> +               register long _sys_arg1 asm(__sys_reg1) =3D (long)(a1);  =
 \
> +               _VDSO_SYSCALL(name,suf32,                               \
> +                             "r" (_sys_arg1));                         \
> +       })
> +#define VDSO_SYSCALL2(name,suf32,a1,a2)                                \
> +       ({                                                              \
> +               register long _sys_arg1 asm(__sys_reg1) =3D (long)(a1);  =
 \
> +               register long _sys_arg2 asm(__sys_reg2) =3D (long)(a2);  =
 \
> +               _VDSO_SYSCALL(name,suf32,                               \
> +                             "r" (_sys_arg1), "r" (_sys_arg2));        \
> +       })
> +#define VDSO_SYSCALL3(name,suf32,a1,a2,a3)                             \
> +       ({                                                              \
> +               register long _sys_arg1 asm(__sys_reg1) =3D (long)(a1);  =
 \
> +               register long _sys_arg2 asm(__sys_reg2) =3D (long)(a2);  =
 \
> +               register long _sys_arg3 asm(__sys_reg3) =3D (long)(a3);  =
 \
> +               _VDSO_SYSCALL(name,suf32,                               \
> +                             "r" (_sys_arg1), "r" (_sys_arg2),         \
> +                             "r" (_sys_arg3));                         \
> +       })
> +#define VDSO_SYSCALL4(name,suf32,a1,a2,a3,a4)                          \
> +       ({                                                              \
> +               register long _sys_arg1 asm(__sys_reg1) =3D (long)(a1);  =
 \
> +               register long _sys_arg2 asm(__sys_reg2) =3D (long)(a2);  =
 \
> +               register long _sys_arg3 asm(__sys_reg3) =3D (long)(a3);  =
 \
> +               register long _sys_arg4 asm(__sys_reg4) =3D (long)(a4);  =
 \
> +               _VDSO_SYSCALL(name,suf32,                               \
> +                             "r" (_sys_arg1), "r" (_sys_arg2),         \
> +                             "r" (_sys_arg3), "r" (_sys_arg4));        \
> +       })
> +#define VDSO_SYSCALL5(name,suf32,a1,a2,a3,a4,a5)                       \
> +       ({                                                              \
> +               register long _sys_arg1 asm(__sys_reg1) =3D (long)(a1);  =
 \
> +               register long _sys_arg2 asm(__sys_reg2) =3D (long)(a2);  =
 \
> +               register long _sys_arg3 asm(__sys_reg3) =3D (long)(a3);  =
 \
> +               register long _sys_arg4 asm(__sys_reg4) =3D (long)(a4);  =
 \
> +               register long _sys_arg5 asm(__sys_reg5) =3D (long)(a5);  =
 \
> +               _VDSO_SYSCALL(name,suf32,                               \
> +                             "r" (_sys_arg1), "r" (_sys_arg2),         \
> +                             "r" (_sys_arg3), "r" (_sys_arg4),         \
> +                             "r" (_sys_arg5));                         \
> +       })
> +
> +#endif /* X86_VDSO_SYS_CALL_H */
> --
> 2.52.0
>
