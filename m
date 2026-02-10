Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7FA277017;
	Tue, 10 Feb 2026 03:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770693752; cv=none; b=BELf5VEPeJvIA8PHrNKRTVKLcaUzXbcR/6NboU/Yfc1fe7EYvdkap/LhidW8PvBwEvKS3fd8iXQJ+Hn9en6ehj5BjkKjajAWDGdWiahNiJKrLtxLqWDkysKDs4itC1VZcS/2VC0x+zoxTkTvnqZg5OA28FRDm3HxjZeiu/DwQPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770693752; c=relaxed/simple;
	bh=itDwaGIFL7m65v5FA9/OeZs04ogr4PKWQR+n813/B/c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Kp8zU9aeXw5fc1yW6XmwV0/sv6N/MdpfLl0SPxrz8TwOozbuBmVn2GccUhcTpridrMUHJNxN1zfV99p6ePXuJLemmoRwKzDhZ91pHPgjPP9lCwQ95GCh7YPSLJPe2AiRjV+HG/XcZzgP03isiBbPsSa4Ng8p5QjoMKUOTGqa6PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=jEcl0Mom; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="jEcl0Mom"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1770693096;
	bh=9px7Ui8PtzZwXAEBRwukPtIGEvdyEJKbwGQDV4ujkZs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=jEcl0MomuTS76a+go7td6z8P9IRn2Z/4QJdsB/xPIwJFVyTlRwVNdjujKmVAWJsPA
	 PeSMLtk4blAC8Np/J5hek7wugWB3PNaqKpOCdtVmRtXqR8C0h1xm/2wkBZ/XTnI4EG
	 3zsDS1m0iWTOmATN0wENIaR8hVpSn7DzOKXbH4cU=
Received: from [127.0.0.1] (2607-8700-5500-e873-0000-0000-0000-1001.16clouds.com [IPv6:2607:8700:5500:e873::1001])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 64DD31A405B;
	Mon,  9 Feb 2026 22:11:28 -0500 (EST)
Message-ID: <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
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
Date: Tue, 10 Feb 2026 11:11:25 +0800
In-Reply-To: <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
		 <20260106211856.560186-6-hpa@zytor.com>
		 <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
	 <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-02-02 at 19:57 -0800, H. Peter Anvin wrote:
> That hack dates back from before the signal frame extension. It is no
> longer necessary.

Unfortunately at least it seems libgcc unwinder does not handle the
signal frame extension properly.  The code reads:

  fde =3D _Unwind_Find_FDE (context->ra + _Unwind_IsSignalFrame (context) -=
 1,=20
                          &context->bases);
  if (fde =3D=3D NULL)
    {   =20
#ifdef MD_FALLBACK_FRAME_STATE_FOR
      /* Couldn't find frame unwind info for this function.  Try a
         target-specific fallback mechanism.  This will necessarily
         not provide a personality routine or LSDA.  */
      return MD_FALLBACK_FRAME_STATE_FOR (context, fs);=20
#else
      return _URC_END_OF_STACK;
#endif
    }   =20

  fs->pc =3D context->bases.func;

  cie =3D get_cie (fde);
  insn =3D extract_cie_info (cie, context, fs);=20

Thus, it indeed attempts to avoid subtracting 1 for a signal frame, but
... _Unwind_IsSignalFrame (context) actually extracts a flag in context
which will only be raised up by extract_cie_info.

Or am I missing something here?

--=20
Xi Ruoyao <xry111@xry111.site>
