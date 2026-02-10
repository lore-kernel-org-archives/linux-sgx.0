Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE38481DD;
	Tue, 10 Feb 2026 04:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770699418; cv=none; b=rg3rUzV3iUCYwEAwDTRLQNLUfJfZraM4BPdXZZYdlyeMW7/Tre7e/lvTSdMLTEqFrrwQvL3WusWZgwNPfkCSxFYQ/Lcq+EZvmx2ElrHlazrYUqMf4YptpmxtxoLUXTievRzBSdYFep9tNdADwnIjWdRaECjUDYAVHzMzTIYIsJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770699418; c=relaxed/simple;
	bh=5Wkflz0liHbiyE1Wp013nwCe13W/ToRQ5I3BfU1Fs6Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d9ztYtZXFOfaLWX2cv/sWnrNwT7eN+cPdcgla3wIS/njnDwC9p2yeP/ouGDUCz6wyUmiMIqzYyf3tcGIseqXwcz4IQBpuOTthfP200S1BjODuWq+84E7SYBL/krHrphC1RjQRgKusENOHNdOo2nwCNa/H7K3g6QxcqPQLedNibc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=kUW2q5N7; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="kUW2q5N7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1770699409;
	bh=S7S/RwYpthg8tXjbrJE4w6sTQLQrQ7h2vcjko87DBKI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=kUW2q5N76xasLaNR97zoGtQHnIvmUOvDpWavvSP0MvJkmykc3ybvyrdM4KaLzHgoC
	 Fcnw1yUeADhSYiqx1WEjmTiMvGcWZxeIBs0wc04T3hV2COZu8glN1w5vd0t25QbdGc
	 THeZf+UtqzZtojSxSzPa5sSEzqjbT270FTExl3uI=
Received: from [127.0.0.1] (2607-8700-5500-e873-0000-0000-0000-1001.16clouds.com [IPv6:2607:8700:5500:e873::1001])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 1DD061A43D2;
	Mon,  9 Feb 2026 23:56:41 -0500 (EST)
Message-ID: <32ec2da7ad9b0c65f41b7c3e14fb6d8e1a5c1865.camel@xry111.site>
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
Date: Tue, 10 Feb 2026 12:56:39 +0800
In-Reply-To: <e31817cb-c102-485c-8844-d81c39eac442@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
	 <20260106211856.560186-6-hpa@zytor.com>
	 <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
	 <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
	 <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
	 <e31817cb-c102-485c-8844-d81c39eac442@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-02-09 at 20:51 -0800, H. Peter Anvin wrote:
> On 2026-02-09 19:11, Xi Ruoyao wrote:
> > On Mon, 2026-02-02 at 19:57 -0800, H. Peter Anvin wrote:
> > > That hack dates back from before the signal frame extension. It is no
> > > longer necessary.
> >=20
> > Unfortunately at least it seems libgcc unwinder does not handle the
> > signal frame extension properly.=C2=A0 The code reads:
> >=20
> > =C2=A0 fde =3D _Unwind_Find_FDE (context->ra + _Unwind_IsSignalFrame (c=
ontext) - 1,=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 &context->bases);
> > =C2=A0 if (fde =3D=3D NULL)
> > =C2=A0=C2=A0=C2=A0 {=C2=A0=C2=A0=C2=A0=20
> > #ifdef MD_FALLBACK_FRAME_STATE_FOR
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Couldn't find frame unwind info for t=
his function.=C2=A0 Try a
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 target-specific fallba=
ck mechanism.=C2=A0 This will necessarily
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 not provide a personal=
ity routine or LSDA.=C2=A0 */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return MD_FALLBACK_FRAME_STATE_FOR (cont=
ext, fs);=20
> > #else
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return _URC_END_OF_STACK;
> > #endif
> > =C2=A0=C2=A0=C2=A0 }=C2=A0=C2=A0=C2=A0=20
> >=20
> > =C2=A0 fs->pc =3D context->bases.func;
> >=20
> > =C2=A0 cie =3D get_cie (fde);
> > =C2=A0 insn =3D extract_cie_info (cie, context, fs);=20
> >=20
> > Thus, it indeed attempts to avoid subtracting 1 for a signal frame, but
> > ... _Unwind_IsSignalFrame (context) actually extracts a flag in context
> > which will only be raised up by extract_cie_info.
> >=20
> > Or am I missing something here?
> >=20
>=20
> Well, it looks like this might be a non-manifest bug on x86 *IN THIS CASE=
*,

But only if after the patch _Unwind_Find_FDE returns NULL here (instead
of a FDE of another function).  I've not verified it on x86.  If glibc
tests (specifically misc/tst-sigcontext-get_pc) work fine things should
be fine.

/* snip */

> Could you file a gcc bug on this?

Will do.


--=20
Xi Ruoyao <xry111@xry111.site>
