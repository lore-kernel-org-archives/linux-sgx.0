Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8697122EE8
	for <linux-sgx@vger.kernel.org>; Thu, 26 Sep 2024 00:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727310812; cv=pass; b=hyUi2CJoR7ZCrrD0GSSPH1XWWnEus+4obWv6rrz5SKM5AXenntB2v6eZflByBSRkUAQfHgkvmQPMNQvyXcL6i0eVW4DOJ61s5Awp8GRHt5259ebcnDFtqV7xlvfdWCi9syzWAnDVFdGVpKpyWV1ZYAlsJ5eEYG1vw3s3i6YhaRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727310812; c=relaxed/simple;
	bh=8N87OvgJUxwfWqiex/tEHqxauvPChneh2IAatesrTfo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=C8PTBnUhIPQrU1MTz9F6rzoUG8f3ORpGxDYlOXJUghoI7ih+qLNPS1BcVaBVOLhVFi8jsPMh5nqhYMviqaQRgQZT9ohVsZ5izwuR5mwcVAkg6XXuaM9kyN7NncTSKIIn+QcW9urKfettPDvacYJW8NxvrJs7HuvJxy74v53LG5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=QdF24qaV; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="QdF24qaV"
Received: from localhost (83-245-197-106.elisa-laajakaista.fi [83.245.197.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sakkinen)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4XDZMN4tMBzyS6;
	Thu, 26 Sep 2024 03:33:20 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1727310801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V2m6BH2Lp4BBXI2ofu//Tlvq/CWXxU59kt760E/Zgyw=;
	b=QdF24qaVCExP8u0PvoL/C/ldShiJm4OrHakCtP+1eHyossSi/o0mxAo7T1cKPT2kB4wfgg
	GW8zpG0nAmemWJMoY6OG06N0dKXW/3qzcWVwzsdzA9n1P+nX2kcf5YSSVLsTWxXs62ZNsI
	54UARJBY2kes9GCKd+j4duXQ0YgtNzg=
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1727310801; a=rsa-sha256; cv=none;
	b=zGOD6m7IEU2ds9ufy+o6TMxwCqV2+hXURULRaNwb90IjV2pE1S9NmHqdvzuHUYPtoA95EN
	HosaxLm3nFAw8eQfe/Ch720DEKxP5eTUpRu4ov3t8WS6UUSsCit3vsOjniNeHpdX6K6itI
	Yk5itTwDmiws+0wX66iUqGortApJqKA=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=sakkinen smtp.mailfrom=jarkko.sakkinen@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1727310800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V2m6BH2Lp4BBXI2ofu//Tlvq/CWXxU59kt760E/Zgyw=;
	b=j+s9fAklxpFaRT7cP35+FYbJJVz5NqZVlJdpbd1YQx/4Hk4rs/z7nwg36yK05r4A5EeBiI
	Rzib+DuROVmYSENa8xFr8f+JQE2j0AjjyYbJDAknxyWmVg8QapunWl3CSGjimHVqpBnieq
	V2lMVsGoqeo/Anj3Ng+3ZDTDxw3H4MM=
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Sep 2024 03:33:19 +0300
Message-Id: <D4FSKQJ45J56.38A19ZT8CDTR0@iki.fi>
Subject: Re: VMA merging updateds?
From: "Jarkko Sakkinen" <jarkko.sakkinen@iki.fi>
To: "Huang, Kai" <kai.huang@intel.com>, "Jarkko Sakkinen"
 <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>, <linux-mm@kvack.org>
X-Mailer: aerc 0.18.2
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi> <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
 <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
 <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
In-Reply-To: <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>

On Thu Sep 26, 2024 at 3:07 AM EEST, Kai Huang wrote:
>
>
> On 23/09/2024 7:48 pm, Jarkko Sakkinen wrote:
> > On Sun Sep 22, 2024 at 7:57 PM EEST, Jarkko Sakkinen wrote:
> >>> On Sun Sep 22, 2024 at 7:27 PM EEST, Jarkko Sakkinen wrote:
> >>>> Hi
> >>>>
> >>>> I started to look into this old issue with mm subsystem and SGX, i.e=
.
> >>>> can we make SGX VMA's to merge together?
> >>>>
> >>>> This demonstrates the problem pretty well:
> >>>>
> >>>> https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd42018=
824f97.camel@kernel.org/
> >>>>
> >>>> It was result of brk() syscall being applied a few times.
> >>
> >> Briging some context here. This can be fixed in the run-time by book
> >> keeping the ranges and doing unmapping/mapping. I guess this goes
> >> beyond what mm should support?
> >>
> >> I thought to plain check this as it has been two years since my last
> >> query on topic (if we could improve either the driver or mm somehow).
> >=20
> > In the past I've substituted kernel's mm merge code with user space
> > replacement:
> >=20
> > https://github.com/enarx/mmledger/blob/main/src/lib.rs
> >=20
> > It's essentially a reimplementation of al stuff that goes into
> > mm/mmap.c's vma_merge(). I cannot recall anymore whether merges
> > which map over existing ranges were working correctly, i.e. was
> > the issue only concerning adjacent VMA's.
> >=20
> > What I'm looking here is that can we make some cosntraints that
> > if satisfied by the pfnmap code, it could leverage the code from
> > vma_merge(). Perhaps by making explicit call to vma_merge()?
> > I get that implicit use moves too much responsibility to the mm
> > subsystem.
> >=20
>
> Hi Jarkko,
>
> Just want to understand more on the background:
>
> Are you seeing any real problem due to needing a lot of mmap()s to the=20
> same enclave, or it is just a problem that doesn't look nice and you=20
> want to resolve?
>
> I mean, this problem doesn't seem to be SGX-specific but a common one=20
> for VMAs with VM_PFNMAP (any bit in VM_SPECIAL), e.g., from random=20
> device drivers with mmap() support.  We will need a good justification=20
> if we want to make any core-mm change, if any, for this.

It requires essentially replicating core mm in user space.

It's a manageable problem but feels silly since logic in merging
is mostly 1:1. It's not a problem for me personally as I'm not
making any money from SGX (more so to Intel).

BR, Jarkko
