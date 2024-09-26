Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17741E50D
	for <linux-sgx@vger.kernel.org>; Thu, 26 Sep 2024 00:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727311093; cv=pass; b=k2L+Mb5DeDGZtTd4rl1isHVzJwW4bAKqBY9D+GGEJ96lxxbKKM+TxguRXhGdmq9vt0xY41vfnTvfOG7rjfup7DUi/cyIYeopk5Ph+SOpwippDQVEuN38oI68g6wXg1xvo/9KR6YktoEaroc9VmvtBtoX/sqVLOLxQ/1kPj7gewE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727311093; c=relaxed/simple;
	bh=u/wnjos/S7LE3wwZ1bkFUCGlG0TpA7XeocEU80zAg3c=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=GwmDtgzLZ+byBIuUDdhb4vcg47sc35n1VjshVRbQxpv70tC/DQmE5iA4YAEIMgvuGCaNM7X3MngTutAQEElZJK5JrxQhKLKJGsP80ypncn8R0g8UKwdoLcSYSwS8Qa7TCNZ1+37ve95i+xx1dthO7MB1CzztKsdAR4gY6hSeMe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=nrwRp1Ww; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="nrwRp1Ww"
Received: from localhost (83-245-197-106.elisa-laajakaista.fi [83.245.197.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sakkinen)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4XDZSx3RlKzyS6;
	Thu, 26 Sep 2024 03:38:09 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1727311089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QsCHVO2sdikPdrjkdbqgFfDhRwJoUJgXeqhcwKCUfQ0=;
	b=nrwRp1WwIUGjHjMuw7Y+z8Hj4NRjBywl7F9XVBVAm8ThEZaEhtPztoPjKsf1L51AKddweX
	sBaYHyRm642lJeYzQBBQp1hWDQ3LtLJZbGZN7d41dxjF5fTixGbAZlmCmVbhHexSp10fBa
	BITklOS1vHQcb0qhmhOdzz1iTCMZr60=
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1727311089; a=rsa-sha256; cv=none;
	b=X8YGEy9GwmqgwkQBccqhtCzFUR3VJNQBgWafNVo5IxZuBkT93D/aOL62j6Sym/wkgqvnPV
	qrwPCNEGsw+mx+nhjeaY0nMmRLLgF7BgwxyVDFJvStjBfk20KoY6+qs4UQEUbeWjF4w7Aw
	7fE9JJzEMvb0s0IgGct1W3Apo4I7iS0=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=sakkinen smtp.mailfrom=jarkko.sakkinen@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1727311089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QsCHVO2sdikPdrjkdbqgFfDhRwJoUJgXeqhcwKCUfQ0=;
	b=BIYSaLJQp5aAliUc6beEU5/dzWTF2eVn0qXq5zFpHsG681wS9QGhNwnc2108EBdpr3DX5C
	gzdhnyC7/nAXLF3O28wAAfNQb6TebdHMjcpFHc6qKa3QVrxjbeQlJ9jtl8ZSr3OfxuwhzS
	87MH/pcPgnz0iGjyv16kLiPH/g/kv8I=
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Sep 2024 03:38:08 +0300
Message-Id: <D4FSOFDIBTSU.395W5ZC73BU4N@iki.fi>
Subject: Re: VMA merging updateds?
From: "Jarkko Sakkinen" <jarkko.sakkinen@iki.fi>
To: "Jarkko Sakkinen" <jarkko.sakkinen@iki.fi>, "Huang, Kai"
 <kai.huang@intel.com>, "Jarkko Sakkinen" <jarkko@kernel.org>,
 <linux-sgx@vger.kernel.org>, <linux-mm@kvack.org>
X-Mailer: aerc 0.18.2
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi> <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
 <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
 <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
 <D4FSKQJ45J56.38A19ZT8CDTR0@iki.fi>
In-Reply-To: <D4FSKQJ45J56.38A19ZT8CDTR0@iki.fi>

qn Thu Sep 26, 2024 at 3:33 AM EEST, Jarkko Sakkinen wrote:
> On Thu Sep 26, 2024 at 3:07 AM EEST, Kai Huang wrote:
> >
> >
> > On 23/09/2024 7:48 pm, Jarkko Sakkinen wrote:
> > > On Sun Sep 22, 2024 at 7:57 PM EEST, Jarkko Sakkinen wrote:
> > >>> On Sun Sep 22, 2024 at 7:27 PM EEST, Jarkko Sakkinen wrote:
> > >>>> Hi
> > >>>>
> > >>>> I started to look into this old issue with mm subsystem and SGX, i=
.e.
> > >>>> can we make SGX VMA's to merge together?
> > >>>>
> > >>>> This demonstrates the problem pretty well:
> > >>>>
> > >>>> https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd420=
18824f97.camel@kernel.org/
> > >>>>
> > >>>> It was result of brk() syscall being applied a few times.
> > >>
> > >> Briging some context here. This can be fixed in the run-time by book
> > >> keeping the ranges and doing unmapping/mapping. I guess this goes
> > >> beyond what mm should support?
> > >>
> > >> I thought to plain check this as it has been two years since my last
> > >> query on topic (if we could improve either the driver or mm somehow)=
.
> > >=20
> > > In the past I've substituted kernel's mm merge code with user space
> > > replacement:
> > >=20
> > > https://github.com/enarx/mmledger/blob/main/src/lib.rs
> > >=20
> > > It's essentially a reimplementation of al stuff that goes into
> > > mm/mmap.c's vma_merge(). I cannot recall anymore whether merges
> > > which map over existing ranges were working correctly, i.e. was
> > > the issue only concerning adjacent VMA's.
> > >=20
> > > What I'm looking here is that can we make some cosntraints that
> > > if satisfied by the pfnmap code, it could leverage the code from
> > > vma_merge(). Perhaps by making explicit call to vma_merge()?
> > > I get that implicit use moves too much responsibility to the mm
> > > subsystem.
> > >=20
> >
> > Hi Jarkko,
> >
> > Just want to understand more on the background:
> >
> > Are you seeing any real problem due to needing a lot of mmap()s to the=
=20
> > same enclave, or it is just a problem that doesn't look nice and you=20
> > want to resolve?
> >
> > I mean, this problem doesn't seem to be SGX-specific but a common one=
=20
> > for VMAs with VM_PFNMAP (any bit in VM_SPECIAL), e.g., from random=20
> > device drivers with mmap() support.  We will need a good justification=
=20
> > if we want to make any core-mm change, if any, for this.
>
> It requires essentially replicating core mm in user space.
>
> It's a manageable problem but feels silly since logic in merging
> is mostly 1:1. It's not a problem for me personally as I'm not
> making any money from SGX (more so to Intel).

I.e. in the case when you want do a syscall shim. You fix it up by
maintaining reflected version of the VMA database in the user space
and remapping everything based on that for every possible mm-call.

I've implemented such feature in the past for Enarx so it is entirely
possible.

BR, Jarkko
