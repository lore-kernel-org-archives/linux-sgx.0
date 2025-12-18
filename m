Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB6C212554
	for <linux-sgx@vger.kernel.org>; Thu, 18 Dec 2025 06:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766041031; cv=none; b=D08W+03I0suVXBcXx9UaFw8SEVqUjPWZBBiN7foH/Rosc7FMjHGruopBFS5YFP8n+D4c0mw8XvgW2uprV1cHOxD4cNcEDApYqa9a4p/RdbrDw9IHDJhYP9+yLBaWhKQV1lrBpDCAxPqM39uC0/XgGsFHdyUPS8y3GW3vOrU+wzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766041031; c=relaxed/simple;
	bh=lHBgVRn313sbb6fi7XJ1Js/RpR0kuDF9q970J/Swg88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MUKsK/0N8FMsdWqnPwyKoJmPIN6pmZwpDiqO5cs+ic0qubnruYAgzjrF4xqif4uodS1mBrxem9Nb71M32OYp5a2PbdxZpyQnAkPyAG2r+XwxltZo8EirBj5ewfDWU5KJB7Vxfm3IDAy/WJfI2kXhIDil2TLBisPDtnY0XzfBVVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AejVIvZU; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AejVIvZU"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6598413b604so176128eaf.0
        for <linux-sgx@vger.kernel.org>; Wed, 17 Dec 2025 22:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766041023; x=1766645823; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IrlPr+wtyI1Uo99JO4RRQCXi++qPSF8IhqjKEAT8dVs=;
        b=AejVIvZUo6bcQfSLbL62yP26HdjXQdfA3zz+HHs60Ckf2P8fvyaWAtGbZZ62JYGKf+
         JaJt3dXwmccT2cbSb3Q9IEND6PAbyl9yCHANcy5MEd5zWYAtKpVHmEgR8krQy/iRXUyx
         J+NhlwNHMpOCHUjsdFe4SEYEUV/Da+FrWHLSZ+7QqJbNZ5t+7VV57cD/g+QgfyPZQKGb
         tMIyvRc1rv4PJdey55muwEurrngD4pvuh+HtYxHilXFZjRwccso7JBa7WBeD6t5ul/z5
         6RsNY6Rm0PeYrd4Pz1BcYsgddwVtcoOD1r9P6sjomwtFSoaPqjeB3J39VOHlCsO58kx8
         Wnxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766041023; x=1766645823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IrlPr+wtyI1Uo99JO4RRQCXi++qPSF8IhqjKEAT8dVs=;
        b=FuZrnUxxTsTIdd2Dq9ZH9PY2YXESlaQ4PRx0yL3f3sddJm8WaZhz7U0zexHnswjK24
         TlsyU+prIEFYdBThldLmeih8gKy02CsYJjt3SQgv4mfK/k8nhrQtVpqIBIbWN/yQU91v
         t7h/My+aw5qXB28p6NM0SYMV4Toc+cuOTU1rHVCXna3dwNKade3r45OH4m7b3Nwpgbrw
         JTY/PCT+R/Uickj0Zxsi2qiUQqQL8HjotihIPz6GmsIYjztCE0b+lxhzmpP+F6TVYgsv
         ccP+CEkzy628jio7kctSdVp2a0sQscYySU2dJTDDx5RNVVSLgQXtFU3WFxtOrjaL3dDf
         MaOg==
X-Forwarded-Encrypted: i=1; AJvYcCW5LqB0SNprDoMkZYCNhdm4TBx3V9gYfLdXGAkeT35tKMpqGwAnQ47wwYr11q0WrSduppy8IDEQMRg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqtbLkmB7HnJMarhZdS7wkXzzHCtIEqLwpVaM7TDkcZX24VsqS
	7g9QvE9NcIZzMzVYzyqyFZPFxUHnZL9FzBqA/fQQkG351t6nUptPRi/CVrNXpBeqbCh22g8L34G
	weqTzyJcZoxepHVY8kxzh/pyCIPGdeg==
X-Gm-Gg: AY/fxX7Js6tmayt08j/keApIltDbgUDqufD1rsap8VA+/+6RCGalaLPbsBom+MA/SkO
	qrEuYaMbOKuj8cBgGLDxkjXdahbG5ttvqsvupFQPXtZXoNhUA56dmYQb3SaPkz1xmHdYwe/D9je
	DP6sianc7xdr6b5H4MGYOpwYsqq2feC9MqTk8w0HdcoASiLYNW9aJVPvoUPVt5KXubu14t1B4Tz
	9r16qeS/fRgTCHoap0I7lcXaLYkc0+pTC+wsgfz1WD9UQ+SU/ozhB7oqenEB7zxtW3rF3YUfFzO
	nzTAtAElSQ==
X-Google-Smtp-Source: AGHT+IHoyKgJft9GXWOvq29wKjxPOdiqHvAXZh4kRr6kHL+8DE+l609ZcYKgNfj2eeC4DwCl0S+iuqFUSarqUO9+Dc4=
X-Received: by 2002:a05:6820:198f:b0:659:9a49:9044 with SMTP id
 006d021491bc7-65b45165e85mr8281438eaf.15.1766041023437; Wed, 17 Dec 2025
 22:57:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251216212606.1325678-1-hpa@zytor.com> <20251216212606.1325678-8-hpa@zytor.com>
 <CAMzpN2g9QNnYhxkGvkO2YcOJTmJGf75qFhKiEQQY18ZaEPQNdw@mail.gmail.com>
In-Reply-To: <CAMzpN2g9QNnYhxkGvkO2YcOJTmJGf75qFhKiEQQY18ZaEPQNdw@mail.gmail.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Thu, 18 Dec 2025 01:56:49 -0500
X-Gm-Features: AQt7F2pSEHTNrfBDjbeKYJMaGHx2b0RfaShrNHFVQFaZQtwh_3mq6tdQ_izXv3M
Message-ID: <CAMzpN2jJ9T=xtXZo1=sxEBjJoqmv4DhfCR-Ef3Mj-cfrhrv3gg@mail.gmail.com>
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

On Wed, Dec 17, 2025 at 9:16=E2=80=AFPM Brian Gerst <brgerst@gmail.com> wro=
te:
>
> On Tue, Dec 16, 2025 at 4:26=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wr=
ote:
> >
> > Currently the vdso doesn't include .note.gnu.property or a GNU noexec
> > stack annotation (the -z noexecstack in the linker script is
> > ineffective because we specify PHDRs explicitly.)
> >
> > The motivation is that the dynamic linker currently do not check
> > these.
> >
> > However, this is a weak excuse: the vdso*.so are also supposed to be
> > usable at link libraries, and there is no reason why the dynamic
> > linker might not want or need to check these in the future, so add
> > them back in -- it is trivial enough.
> >
> > Use symbolic constants for the PHDR permission flags.
> >
> > [ v4: drop unrelated formatting changes ]
> >
> > Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> > ---
> >  arch/x86/entry/vdso/common/vdso-layout.lds.S | 38 ++++++++++++--------
> >  1 file changed, 23 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/en=
try/vdso/common/vdso-layout.lds.S
> > index ec1ac191a057..a1e30be3e83d 100644
> > --- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
> > +++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
> > @@ -47,18 +47,18 @@ SECTIONS
> >                 *(.gnu.linkonce.b.*)
> >         }                                               :text
> >
> > -       /*
> > -        * Discard .note.gnu.property sections which are unused and hav=
e
> > -        * different alignment requirement from vDSO note sections.
> > -        */
> > -       /DISCARD/ : {
> > +       .note.gnu.property : {
> >                 *(.note.gnu.property)
> > -       }
> > -       .note           : { *(.note.*) }                :text   :note
> > -
> > -       .eh_frame_hdr   : { *(.eh_frame_hdr) }          :text   :eh_fra=
me_hdr
> > -       .eh_frame       : { KEEP (*(.eh_frame)) }       :text
> > +       }                                       :text :note :gnu_proper=
ty
> > +       .note           : {
> > +               *(.note*)
> > +       }                                       :text :note
> >
> > +       .eh_frame_hdr   : { *(.eh_frame_hdr) }  :text :eh_frame_hdr
> > +       .eh_frame       : {
> > +               KEEP (*(.eh_frame))
> > +               *(.eh_frame.*)
> > +       }                                       :text
> >
> >         /*
> >          * Text is well-separated from actual data: there's plenty of
> > @@ -87,15 +87,23 @@ SECTIONS
> >   * Very old versions of ld do not recognize this name token; use the c=
onstant.
> >   */
> >  #define PT_GNU_EH_FRAME        0x6474e550
> > +#define PT_GNU_STACK   0x6474e551
> > +#define PT_GNU_PROPERTY        0x6474e553
>
> Do we even still support the old linkers that need these constants?

Digging into the binutils source, PT_GNU_EH_FRAME and PT_GNU_STACK
were added to the parser around bintils-2.15.  PT_GNU_PROPERTY was
added in binutils-2.38, which is newer than the minimum supported
version of binutils-2.30.

Probably better to just leave them then.


Brian Gerst
