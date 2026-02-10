Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD7C481DD;
	Tue, 10 Feb 2026 04:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770698772; cv=none; b=PX/pBfHFH0Sq12mnVrvG+InPUPDnh7EpZrM8aJetGpicYzikfp7or42jjDgHw5LldKYi2IFHXYoQ9F2zOpfwJd2fsg3fnXXTetfziM5X9PfCGUCQaGmy1GP6hZfPe23O8b8QAH6qkgFu8H4IcqdtAoJipNsBCvIDHZc23tRcw7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770698772; c=relaxed/simple;
	bh=MAprlYPqV7U8DLzYchi54L7sWO58KLPjk0ElmsQ4frA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lnxaci+ay6Fbd8O1WYQVwtm6ULC5AzFbFxiVN9ZoCNMn//Gmq0nI5kGURfLh1DtXnvJ5pLZI6kpbyiO6qXngu4t4Wsyq1PHqDzGLITsv5FEridM8vYDTt6f362O7eOTSEbK5HVi6tmzTmw7Q9cwiQOWpGsCbjm9tTNrwr+ub/YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=kKWQii54; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="kKWQii54"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1770698763;
	bh=maTKwIrG4gBsB19kvjBipujcA/45nYbxMGmoeNQLwM8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=kKWQii54+eoNj+a+pDddfbxUnYtyqYL9QkXLWPk5d9k7oyHdsvssdlqW8kEU1T9Hx
	 6RluLpriI+nIsXQ0NElu78VNhSgMgpkZOpzX27+uD1fO55tl/ToPiVNzbfWMNRAwdK
	 Uny7oFXe2ky4GFzVk0t/LFFt9R3UAULl3WLbRleM=
Received: from [127.0.0.1] (2607-8700-5500-e873-0000-0000-0000-1001.16clouds.com [IPv6:2607:8700:5500:e873::1001])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 570B01A40A4;
	Mon,  9 Feb 2026 23:45:55 -0500 (EST)
Message-ID: <0ee773dea213f6efbdac03009ee80f350b17c949.camel@xry111.site>
Subject: Re: [PATCH v4.1 06/10] x86/entry/vdso32: remove open-coded DWARF in
 sigreturn.S
From: Xi Ruoyao <xry111@xry111.site>
To: "H. Peter Anvin" <hpa@zytor.com>, Jens Remus <jremus@linux.ibm.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Peter Zijlstra (Intel)"	
 <peterz@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Thomas
 =?ISO-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>, Xin Li
 <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>, Andy Lutomirski
 <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov
 <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, Ingo Molnar	 <mingo@redhat.com>, James Morse
 <james.morse@arm.com>, Jarkko Sakkinen	 <jarkko@kernel.org>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Kees Cook	 <kees@kernel.org>, Nam Cao
 <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,  Perry Yuan
 <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>, Thomas Huth
 <thuth@redhat.com>,  Uros Bizjak <ubizjak@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-sgx@vger.kernel.org, x86@kernel.org, Indu Bhagat
 <indu.bhagat@oracle.com>,  Claudiu Zissulescu-Ianculescu
 <claudiu.zissulescu-ianculescu@oracle.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Date: Tue, 10 Feb 2026 12:45:53 +0800
In-Reply-To: <29D95765-BD93-451D-8FD8-54250ADE1DEB@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
	 <20260106211856.560186-6-hpa@zytor.com>
	 <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
	 <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
	 <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
	 <29D95765-BD93-451D-8FD8-54250ADE1DEB@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-02-09 at 20:15 -0800, H. Peter Anvin wrote:
> On February 9, 2026 7:11:25 PM PST, Xi Ruoyao <xry111@xry111.site> wrote:
> > On Mon, 2026-02-02 at 19:57 -0800, H. Peter Anvin wrote:
> > > That hack dates back from before the signal frame extension. It is no
> > > longer necessary.
> >=20
> > Unfortunately at least it seems libgcc unwinder does not handle the
> > signal frame extension properly.=C2=A0 The code reads:
> >=20
> > =C2=A0fde =3D _Unwind_Find_FDE (context->ra + _Unwind_IsSignalFrame (co=
ntext) - 1,=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 &context->bases);
> > =C2=A0if (fde =3D=3D NULL)
> > =C2=A0=C2=A0 {=C2=A0=C2=A0=C2=A0=20
> > #ifdef MD_FALLBACK_FRAME_STATE_FOR
> > =C2=A0=C2=A0=C2=A0=C2=A0 /* Couldn't find frame unwind info for this fu=
nction.=C2=A0 Try a
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 target-specific fallback mec=
hanism.=C2=A0 This will necessarily
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 not provide a personality ro=
utine or LSDA.=C2=A0 */
> > =C2=A0=C2=A0=C2=A0=C2=A0 return MD_FALLBACK_FRAME_STATE_FOR (context, f=
s);=20
> > #else
> > =C2=A0=C2=A0=C2=A0=C2=A0 return _URC_END_OF_STACK;
> > #endif
> > =C2=A0=C2=A0 }=C2=A0=C2=A0=C2=A0=20
> >=20
> > =C2=A0fs->pc =3D context->bases.func;
> >=20
> > =C2=A0cie =3D get_cie (fde);
> > =C2=A0insn =3D extract_cie_info (cie, context, fs);=20
> >=20
> > Thus, it indeed attempts to avoid subtracting 1 for a signal frame, but
> > ... _Unwind_IsSignalFrame (context) actually extracts a flag in context
> > which will only be raised up by extract_cie_info.
> >=20
> > Or am I missing something here?
> >=20
>=20
> Oh, good grief...
>=20
> How does this possibly work on non-x86 platforms?

On ARM64 the vdso does not have eh_frame_hdr at all, on LoongArch
eh_frame_hdr is empty (note that an ampty en_frame_hdr is actually buggy
and I'm trying to fix it), so _Unwind_Find_FDE returns NULL and libgcc
falls back to MD_FALLBACK_FRAME_STATE_FOR, which handles the sigreturn
trampoline using some machine-dependant logic.

On RISC-V things are more theatrical: the sigreturn trampoline happens
to be at the beginning of the vdso .text section, so after subtracting 1
from the PC, the result is out of the .text section and so not in any
FDE.  Thus _Unwind_Find_FDE returns NULL and libgcc again falls back to
MD_FALLBACK_FRAME_STATE_FOR.

If the RISC-V sigreturn trampoline was not the first in .text,
subtracting 1 would cause the PC to be in the FDE of the previous
function and then _Unwind_Find_FDE would return that FDE, then RISC-V
would have some big trouble.

I've not taken a serious look at other architectures yet.

--=20
Xi Ruoyao <xry111@xry111.site>
