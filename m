Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31BD2F5485
	for <linux-sgx@vger.kernel.org>; Thu, 18 Dec 2025 02:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766024184; cv=none; b=vDaFaf3WOGhV34z2smyYFTsk01q64u7cIk+i/vBryHdu2oGBug4Zsn5GcxVlKv66rGWdFR7jLeE9qmz/saRNsI+qHWfLEYgk/S9Kwr+Zgtrxe3ASY6Dhw++xWzb3pO9u4+fkP3pRQBUczYj0rpWws93GGnbYUk5QVTpLhqXUemc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766024184; c=relaxed/simple;
	bh=GcDJbgwivYQy8RGToN8JvMkLsgmiUCKKgdX6aOd5RXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=khTzKAFT33aCAVelLAkaJqyJz+FU9Dt4j+KER0fR0BOn8T+454odT6lG/7J42shseokLSJCZT+7eov/nmFGEAAu+tTp5WL+UNTBcMqJe1zss3Ct0tPdDWUc8XV5fScHDlob5gce6EqlwwwLaMo8WQkCMz6wg1Y0duUntPe60Lp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eqe3WqMz; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eqe3WqMz"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-37a3d86b773so1102551fa.0
        for <linux-sgx@vger.kernel.org>; Wed, 17 Dec 2025 18:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766024181; x=1766628981; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9AN9sEG2AE52fSnYh2OeNG8uWEMWv3JCgynDFEzzgMU=;
        b=Eqe3WqMzgIQcpsxQYsFofUbjGXfV38HG86DllJVJBz/B+qPc548ZQ1l8JODdTJ8e4p
         vWTNE68pfzlGOKbbRVeeJODMx7HuloeF0Adqrv+s2z54w4kYssq4XaukMTb/iBcbmUhk
         Tml0vZR+zaNdR4Kr4nOhlmpY4wljU5VTtLj4NfG6qijvYxbCzW2LvuTC1iLQv2qK3Cgk
         CIB5bd+WV1UyLYvnEq81PdqQpC6EyzRGpcvJkbBJxBNBdsVAb54Amr5QVq0sDrkwJUeB
         Cw7uLObYyhv1ZkgIZpIN2lrwaMcseClM3/zq61MvdqSuf8/wt+u1Eg9BojAoUP+AFx/P
         B6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766024181; x=1766628981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9AN9sEG2AE52fSnYh2OeNG8uWEMWv3JCgynDFEzzgMU=;
        b=NP9tO7B0l7Q0JQJeljJbRgKrLScnq+9Y306/C1IwF4CyzMpx8cGxyahDxRD2rfHrTJ
         mmBbCMjRs/gaFk9m3hH8IJffIKtCXgjoN8tuNVc0EL3rdNcTCUbdnsNgli2oZnRH/r2Q
         P0M6WIPJ8R7Orm9HvbU20hg3i3Lb++LSkDvhSl63gmLVIAmh3HVXW6oTqzZb2CdNfmVK
         gs3RAUawcVWhdS8ddaUgkEzSCswcwll6LV0h5FUJjNhtbg568dOb3BpM40fDTgu4dn1b
         3+yDMIBMop58yWSMAcz537S5pNLR920h5P2HRr1BVVg5xARmAwzglhEYuCHFeEKJQ+FC
         5bwA==
X-Forwarded-Encrypted: i=1; AJvYcCWyBd9IVr8sd1ilBPpmzFHUGVysiB5U5E5GGsWrDZhlmKpY9nmmApPVPUvlKPkt8TE9bLeZDs5pjGg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZSrLtdGBffXs8Bh6LrUpucuPM6r8PTEfkADFC7ZFKgcETTc2M
	OuwV3UB120JFhHW2OewUqnRY/hH2AZ4CY4CAB7SyfNpljM6bc9BzWlQ4AhnDxe7Rx0h2voaLp+6
	nNoe3nxoVqMTqxxLndCmM0OLLa6YgbQ==
X-Gm-Gg: AY/fxX5eoMYSBEXlly9Mp/C62GJ27kZYGw08u75e4rCy6s3BPrQy4Bb7GtaHg9WbtnC
	U8qizeXD3VSffRmMOX/9VUIIBs6GTCQQiIUywgy94gv9rUabRojyW5A44J90mDyVm8ckVnKPumN
	m41azq04sKN1gVS+kbwjdYC06xPoOzwJ5QHwKKJSEyqjrmoEpev0z+0Cvz4DmkKSlspOpbQO4kh
	htO//O6fJ7qLUUxIBpNJklKWlCQmK1ogGyOjr8G/bHG+2PKzHUTNOzlQvGCvBIFvyJgtVkDlgoT
	9+y6U9JsdC0ZCA7OBrYc
X-Google-Smtp-Source: AGHT+IH+OADZ6GESLoGiMPu8hoFMOP7s7nP4zFXC7YbnBNR5dFco3tMJoPvVr4wWL3ocwWAFY/G13MIXPc5nmNaijSc=
X-Received: by 2002:a2e:a801:0:b0:37b:95ee:f605 with SMTP id
 38308e7fff4ca-37fd077cfd2mr59325781fa.10.1766024180565; Wed, 17 Dec 2025
 18:16:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251216212606.1325678-1-hpa@zytor.com> <20251216212606.1325678-8-hpa@zytor.com>
In-Reply-To: <20251216212606.1325678-8-hpa@zytor.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Wed, 17 Dec 2025 21:16:08 -0500
X-Gm-Features: AQt7F2p9l8UeuqBazA8cYojN0tIogcUvjCrbiceup-Wji5NWm9gKMgC-Lp1qUmc
Message-ID: <CAMzpN2g9QNnYhxkGvkO2YcOJTmJGf75qFhKiEQQY18ZaEPQNdw@mail.gmail.com>
Subject: Re: [PATCH v4 07/10] x86/entry/vdso: include GNU_PROPERTY and
 GNU_STACK PHDRs
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morse <james.morse@arm.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, Nam Cao <namcao@linutronix.de>, 
	Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-sgx@vger.kernel.org, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 4:26=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wrot=
e:
>
> Currently the vdso doesn't include .note.gnu.property or a GNU noexec
> stack annotation (the -z noexecstack in the linker script is
> ineffective because we specify PHDRs explicitly.)
>
> The motivation is that the dynamic linker currently do not check
> these.
>
> However, this is a weak excuse: the vdso*.so are also supposed to be
> usable at link libraries, and there is no reason why the dynamic
> linker might not want or need to check these in the future, so add
> them back in -- it is trivial enough.
>
> Use symbolic constants for the PHDR permission flags.
>
> [ v4: drop unrelated formatting changes ]
>
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> ---
>  arch/x86/entry/vdso/common/vdso-layout.lds.S | 38 ++++++++++++--------
>  1 file changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/entr=
y/vdso/common/vdso-layout.lds.S
> index ec1ac191a057..a1e30be3e83d 100644
> --- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
> +++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
> @@ -47,18 +47,18 @@ SECTIONS
>                 *(.gnu.linkonce.b.*)
>         }                                               :text
>
> -       /*
> -        * Discard .note.gnu.property sections which are unused and have
> -        * different alignment requirement from vDSO note sections.
> -        */
> -       /DISCARD/ : {
> +       .note.gnu.property : {
>                 *(.note.gnu.property)
> -       }
> -       .note           : { *(.note.*) }                :text   :note
> -
> -       .eh_frame_hdr   : { *(.eh_frame_hdr) }          :text   :eh_frame=
_hdr
> -       .eh_frame       : { KEEP (*(.eh_frame)) }       :text
> +       }                                       :text :note :gnu_property
> +       .note           : {
> +               *(.note*)
> +       }                                       :text :note
>
> +       .eh_frame_hdr   : { *(.eh_frame_hdr) }  :text :eh_frame_hdr
> +       .eh_frame       : {
> +               KEEP (*(.eh_frame))
> +               *(.eh_frame.*)
> +       }                                       :text
>
>         /*
>          * Text is well-separated from actual data: there's plenty of
> @@ -87,15 +87,23 @@ SECTIONS
>   * Very old versions of ld do not recognize this name token; use the con=
stant.
>   */
>  #define PT_GNU_EH_FRAME        0x6474e550
> +#define PT_GNU_STACK   0x6474e551
> +#define PT_GNU_PROPERTY        0x6474e553

Do we even still support the old linkers that need these constants?


Brian Gerst
