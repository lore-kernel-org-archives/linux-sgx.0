Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABDE320A3E
	for <linux-sgx@vger.kernel.org>; Thu, 13 Nov 2025 07:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763018124; cv=none; b=Jkhlx2E/vrYhGQB30z5Hy109r7sdEmpE70Irlvm7XcG+AuRDsdfb6hwGko+I7h1II92uh0RbQ9Xfv0rXj9GUfGy5lBJfEGzSnSUiVoI5dEGvaDqFAumzCyeAHCBByUktAc3A1oY21wufrqOcilE5+gKvK/V3McXpYEtzheV2cBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763018124; c=relaxed/simple;
	bh=aFlDfAwxf+VpT8Ky7p+j+3MsDI4S/RTCzglavU60I5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n/VhctMqeMhFQO04ZFzDFClbi9vDm2OLKHV0StvskqvhssYt8viE+IdWhVO14y6yBCvk8y/d6PRsaW3bWkppOZqg1MD6Ydjy0NsPynRj/LjosMJnFOOTndC40YHKh+hryw8cbN/3yfsgTrHAVb1IB4N8VGMpTUxkyIWGKpgMRw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RVlTCY3R; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVlTCY3R"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-37a48fc491aso3972451fa.1
        for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 23:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763018121; x=1763622921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lqJtc6nctLL296A0D8g+RFLLJKY4jF/ch+KnAKR18is=;
        b=RVlTCY3R9JwYZJnOoBuoE7qGVBbsCMag8OJBKDNyS8XDnarWlmJxEq6zb3H6D0nvun
         OLg009OwPmF+8m8zx2MHY5/KPWqEwYcdbIUQY54n2Z5v0c88WffmLPidyGov2Z2u/l5Q
         Ez9wLIjETdfqc7Hwkb2xB1gRs14DNkhFrbLn8zLuj07GkfS72ixD44l17qlPzAED7enA
         tIOvCVpDHZMuaGlUAWHtIiOct0xADaBsvN0oDd8GIJ20HWfPJ1vjSU/fY/l9/pPEP5R5
         HlAoTJlnUBK7T2DDkqbMc8eGzayoLjCfF6k4/A8JfGZhU7IRJaExh5TS6+rdLt201INk
         vCBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763018121; x=1763622921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lqJtc6nctLL296A0D8g+RFLLJKY4jF/ch+KnAKR18is=;
        b=Lrb13KvfQW07Dx5gZtb1rlcr36+C187jFTjBXwUhtEP5ph/GL1U054QFeVvhNL/12M
         Ef52qjqpO2P8XpAMv0sEjSSfzF4TdBi727sc0ba7K2HhtvGKFeGwgMcSiczHS5ctOglx
         o3b+gOjPNGHF6pwO8WgphbkkZPZyODEQGKM4d65cQ7NWWEA3yT1jCX+JdkhDnJfX5b1l
         pJDQ4L0MunzRWbSxghh9fP6d7sjkmHG9Suv9ZJtq4e/yRbVZ+sRo1e69gwycvqZDK8gi
         lF0KOckuY5ibWOMtfrjcCWgK+GPl8g5DhAYiqK2pS0PAiVm/ZngysGBzWnWy3lUtXQeH
         jw0g==
X-Forwarded-Encrypted: i=1; AJvYcCXXpHpRgB/gVsCW2p7FPuHFfmuFDBtE5MG/8dbKJ68aWyUt91fy8cED5lXENu5R/SGQLObexzg6GCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbjrfDzECiIGNlz9YjHf0/LZKMEeHFwGfISqNlCyNSl17oE4Zl
	O4TJ41c74zcfXgDsfCpZBvB0DwYx79VNirVOCQuk2ZhfJFdvPKFTiqspV9dIgQOxDE8gvwVtXdO
	zHpjt09fXol2PkpD8n78t+xp7+htzyR4=
X-Gm-Gg: ASbGncuTQBsgZ7tciz2wMA8/b7y0TtOR9VRH4y5EZLLyEr0kasAUFwlyUm/K3ZB8z2y
	OMBWIeDH7Ykwl0NZhSUHyW3gKgriM2ca6RpnooMR5HPHS5ngDyafy35Nr9C679u0xmPDoJi0Lim
	1n4U440mTLjtLZJ/q/S8FVZYONqwkCKAOtOIWZrpafRtWItl4ABLlpz/MI1p1AvwiIlPfS5Ic98
	odNyLPj9Ethd3BmDonqbrOhB2yl1oK1/Et5SfmZUELHRP3RWXeq/V5NIvZp7LZF8mjPh4U=
X-Google-Smtp-Source: AGHT+IH06bOdyKarVLIhwFMJ182ryvbHyCSiMCHvWXATRskyshzs0BRRyhF/MSZVLle+D6Cn1SH8KSCA7r6aIB1kImo=
X-Received: by 2002:a05:651c:3043:b0:37a:7c41:79e with SMTP id
 38308e7fff4ca-37b8c2e5f7bmr13698611fa.13.1763018120526; Wed, 12 Nov 2025
 23:15:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251112043730.992152-1-hpa@zytor.com> <20251112043730.992152-8-hpa@zytor.com>
 <CAFULd4aMOueG5y3K7F57ryLtt-JUhE-yfsDODC=5+bgjF_gtSw@mail.gmail.com> <d5531acf-cd79-428d-80d1-eb7562cf3922@zytor.com>
In-Reply-To: <d5531acf-cd79-428d-80d1-eb7562cf3922@zytor.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Thu, 13 Nov 2025 08:15:08 +0100
X-Gm-Features: AWmQ_bmJP9AwfP8znrA5yY9Ud6xnrgSPvI_XaneFw49MCSp3ohPB7gxGYKTmaBA
Message-ID: <CAFULd4bfxaSy0kkVjfjqgHe=3iT-QcGAhbK9WFepPmZu7=ocjw@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] x86/vdso: abstract out vdso system call internals
To: "H. Peter Anvin" <hpa@zytor.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>
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

On Wed, Nov 12, 2025 at 10:25=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wro=
te:
>
> On 2025-11-12 02:31, Uros Bizjak wrote:
> >
> > Unfortunately, %ebp is still special with -fno-omit-frame-pointer, so
> > using "ebp" as _sys_arg6 on 32-bit targets will result in:
> >
> > error: bp cannot be used in =E2=80=98asm=E2=80=99 here
> >
> > Please see how %ebp register is handled in
> > arch/x86/include/asm/vmware.h, vmware_hypercall_hb_out() and
> > vmware_hypercall_hb_in().
> >
>
> #ifdef CONFIG_X86_64
> #define VMW_BP_CONSTRAINT "r"
> #else
> #define VMW_BP_CONSTRAINT "m"
> #endif
>
>         asm_inline volatile (
>                 UNWIND_HINT_SAVE
>                 "push %%" _ASM_BP "\n\t"
>                 UNWIND_HINT_UNDEFINED
>                 "mov %[in6], %%" _ASM_BP "\n\t"
>                 "rep outsb\n\t"
>                 "pop %%" _ASM_BP "\n\t"
>                 UNWIND_HINT_RESTORE
>                 : "=3Da" (out0), "=3Db" (*out1)
>                 : "a" (VMWARE_HYPERVISOR_MAGIC),
>                   "b" (cmd),
>                   "c" (in2),
>                   "d" (in3 | VMWARE_HYPERVISOR_PORT_HB),
>                   "S" (in4),
>                   "D" (in5),
>                   [in6] VMW_BP_CONSTRAINT (in6)
>                 : "cc", "memory");
>         return out0;
>
> That code is actually incorrect, in at least two ways:
>
>
> 1. It should be conditioned on frame pointers enabled, not x86-64 vs i386=
.
> 2. The compiler is perfectly within its right to emit an %esp-relative
>    reference for the "m"-constrained [in6]. This is particularly likely
>    when *not* compiled with frame pointers, see #1.
>
> A better sequence might be:
>
>         pushl %[in6]
>         push %ebp
>         mov 4(%esp),%ebp
>         <stuff>
>         pop %ebp
>         pop %[junk]
>
> Then %[in6] can even safely be a "g" constraint (hence pushl).

If we want to also handle x86_64, the above code (including push)
needs to be 64-bit, with "rme" constraint for the pushed value.

I have CC'd the author of the above code, he might be interested in
the above discussion.

Uros.
