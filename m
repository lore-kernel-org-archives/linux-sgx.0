Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BC32765C4;
	Tue, 10 Feb 2026 04:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770697010; cv=none; b=Bzl+nfsfhn9ynKfBg9pmpa6gOE4BQct5aROPioHiEmvCiRmY9+ckvLLAdfXqiFP2DGCEbdBFIQBDKahJgvVthzuy57lDF+u9K4tAmVxxMury2kS3+lc+XUWdsGQ/+CldGVgSAvEsQ6DPXXllSG5XS42tKxLgul5J5L44TvhrS40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770697010; c=relaxed/simple;
	bh=dShp/s0xOahHfZuk2rk8o5k/pdR7As113m62F4PaSDw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=H7lxd4QndoxvLz/uXOiQ9wNL6lFz5EXTt3knokyOzKrTpZFQRKWu4Yolg3ODLuqOARNrSrL+3CyuDHkrMSLTmUahCsKAZk6iBUzz7BGHEQM9ZD/bTukYFUtSsuTPKe+DYf//BYraK6dpyo2MMVqGPMzZCDs70v0+kQSIpNIGcNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=bPjZ9Y2g reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="bPjZ9Y2g"
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61A4Fqvg3149966
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 9 Feb 2026 20:15:53 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61A4Fqvg3149966
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770696956;
	bh=lMA+e7t1AQwEppF56ecV3ZH9XLnQSHpFgr1CYZ9e58g=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=bPjZ9Y2gc8XthT6zR8auXTW7LY0+PoYLaGLDTGvP5fag/zuiuP5tQ6Cv1wveyTm57
	 ErTx2dN99MNaspd+H16qZxFGNWq4gETPUsrJoDgKj1PTeMhC7npPFbbF4bIVa8hIoO
	 NukcLD2uJLbiJ77RYGLeLH/E/TPTD31/BxU422+TVn8WU5ZP6uSWIObtIO9TNOQPtb
	 WrO0aiPQ/p3gP3xcrmc3gdEICDoxjGG11jNeQb1yAwO2td78+CCqjwFIVAJD9j7qFu
	 w8xSdWmfKueV84Yjuxx6TQ07qAZiYO5eLrXtTlCq8NvgnA8cMYxrSIKl+Ol4AJQrzF
	 13NMFFJ2qFaNg==
Date: Mon, 09 Feb 2026 20:15:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xi Ruoyao <xry111@xry111.site>, Jens Remus <jremus@linux.ibm.com>
CC: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?Thomas_Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
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
        linux-sgx@vger.kernel.org, x86@kernel.org,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Claudiu Zissulescu-Ianculescu <claudiu.zissulescu-ianculescu@oracle.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4=2E1_06/10=5D_x86/entry/vdso32?=
 =?US-ASCII?Q?=3A_remove_open-coded_DWARF_in_sigreturn=2ES?=
User-Agent: K-9 Mail for Android
In-Reply-To: <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
References: <vdso-cleanup-patch-4.1@zytor.com> <20260106211856.560186-6-hpa@zytor.com> <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com> <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com> <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
Message-ID: <29D95765-BD93-451D-8FD8-54250ADE1DEB@zytor.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On February 9, 2026 7:11:25 PM PST, Xi Ruoyao <xry111@xry111=2Esite> wrote:
>On Mon, 2026-02-02 at 19:57 -0800, H=2E Peter Anvin wrote:
>> That hack dates back from before the signal frame extension=2E It is no
>> longer necessary=2E
>
>Unfortunately at least it seems libgcc unwinder does not handle the
>signal frame extension properly=2E  The code reads:
>
>  fde =3D _Unwind_Find_FDE (context->ra + _Unwind_IsSignalFrame (context)=
 - 1,=20
>                          &context->bases);
>  if (fde =3D=3D NULL)
>    {   =20
>#ifdef MD_FALLBACK_FRAME_STATE_FOR
>      /* Couldn't find frame unwind info for this function=2E  Try a
>         target-specific fallback mechanism=2E  This will necessarily
>         not provide a personality routine or LSDA=2E  */
>      return MD_FALLBACK_FRAME_STATE_FOR (context, fs);=20
>#else
>      return _URC_END_OF_STACK;
>#endif
>    }   =20
>
>  fs->pc =3D context->bases=2Efunc;
>
>  cie =3D get_cie (fde);
>  insn =3D extract_cie_info (cie, context, fs);=20
>
>Thus, it indeed attempts to avoid subtracting 1 for a signal frame, but
>=2E=2E=2E _Unwind_IsSignalFrame (context) actually extracts a flag in con=
text
>which will only be raised up by extract_cie_info=2E
>
>Or am I missing something here?
>

Oh, good grief=2E=2E=2E

How does this possibly work on non-x86 platforms?
