Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A345C125
	for <linux-sgx@vger.kernel.org>; Thu, 26 Sep 2024 01:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315341; cv=none; b=XDgMlJDEBYowTUFIZ7/GJ4x5rAEePhNiBwWK8pdzBkF5OpZ9KdAIYAgvVt2K3h12T7uA5+Pq6Zmqns0QH6lstzy7a7fiDocSOZa1YmGHSW/UvRLClsekfWnwCQ67cR+WAKWhd6K1Gx6mQIgvRz8Pqnj1fOLmJbiWfiswWWifl5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315341; c=relaxed/simple;
	bh=bGGN0MlFRdWr6XSSQfBysbQYemUhBKtd0dP6ORgAqFs=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:
	 References:In-Reply-To; b=G0n4hTKcrSVs+iKekUp5EFGdSGhczKFjgGXZM3v8LZOhIg6dpwzU78yygJ04UlwiocFNYRiuTEqtsmCPNxp+yRSMipSuyYP6FQEfZwlRhQr6ESmfaW5fZ/v2BtK1wDRUVz8f7lFoZ8Ya2pC5dvKbxCO5G4gCHNSeeFLXAXTxRrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dX5sgYBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dX5sgYBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4383CC4CEC3;
	Thu, 26 Sep 2024 01:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727315340;
	bh=bGGN0MlFRdWr6XSSQfBysbQYemUhBKtd0dP6ORgAqFs=;
	h=Date:To:Subject:From:References:In-Reply-To:From;
	b=dX5sgYBomN5MZPkc7m6dkphOKDQHxZsRLAzl5uoa13847qGBg0TLhUm6xdk98aGpN
	 yE+usoXxzrLfTdjJhze4MNuvYOnLhXyIKzOEiqMALmjkWRRsua9s3XYaPKfoRgFMHZ
	 ZgXEmJ+WDSQU9NIn1GaD0lAe4rx6lN/eR9GAGXjfN0w038ij64rW9I/qIuAvSszwRf
	 AREckmgXX4k1CFb+/p5ZxWg0SgMNlr9aWz3LYejRRJoSKij7ZnMqdrJB5VVXNZg+NX
	 tOWk8UE4kKRAC76Kiy0YAwrCRQvBMB5bE0KBBV/YTYuzRwyOZDutnolosQesntyb0A
	 QBTORQyDDM94g==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Sep 2024 04:48:56 +0300
Message-Id: <D4FU6N3RZ30A.2TY1PVOBZ6K8X@kernel.org>
To: "Jarkko Sakkinen" <jarkko.sakkinen@iki.fi>, "Huang, Kai"
 <kai.huang@intel.com>, <linux-sgx@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: VMA merging updateds?
From: "Jarkko Sakkinen" <jarkko@kernel.org>
X-Mailer: aerc 0.18.2
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi> <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
 <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
 <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
 <D4FSKQJ45J56.38A19ZT8CDTR0@iki.fi>
 <bd784be9-3723-4ad8-94a8-058f4a001042@intel.com>
 <D4FU5RJEFG44.2QYNE8R6J2GMP@iki.fi>
In-Reply-To: <D4FU5RJEFG44.2QYNE8R6J2GMP@iki.fi>

On Thu Sep 26, 2024 at 4:47 AM EEST, Jarkko Sakkinen wrote:
> On Thu Sep 26, 2024 at 3:38 AM EEST, Kai Huang wrote:
> >
> >
> > On 26/09/2024 12:33 pm, Jarkko Sakkinen wrote:
> > > On Thu Sep 26, 2024 at 3:07 AM EEST, Kai Huang wrote:
> > >>
> > >>
> > >> On 23/09/2024 7:48 pm, Jarkko Sakkinen wrote:
> > >>> On Sun Sep 22, 2024 at 7:57 PM EEST, Jarkko Sakkinen wrote:
> > >>>>> On Sun Sep 22, 2024 at 7:27 PM EEST, Jarkko Sakkinen wrote:
> > >>>>>> Hi
> > >>>>>>
> > >>>>>> I started to look into this old issue with mm subsystem and SGX,=
 i.e.
> > >>>>>> can we make SGX VMA's to merge together?
> > >>>>>>
> > >>>>>> This demonstrates the problem pretty well:
> > >>>>>>
> > >>>>>> https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd4=
2018824f97.camel@kernel.org/
> > >>>>>>
> > >>>>>> It was result of brk() syscall being applied a few times.
> > >>>>
> > >>>> Briging some context here. This can be fixed in the run-time by bo=
ok
> > >>>> keeping the ranges and doing unmapping/mapping. I guess this goes
> > >>>> beyond what mm should support?
> > >>>>
> > >>>> I thought to plain check this as it has been two years since my la=
st
> > >>>> query on topic (if we could improve either the driver or mm someho=
w).
> > >>>
> > >>> In the past I've substituted kernel's mm merge code with user space
> > >>> replacement:
> > >>>
> > >>> https://github.com/enarx/mmledger/blob/main/src/lib.rs
> > >>>
> > >>> It's essentially a reimplementation of al stuff that goes into
> > >>> mm/mmap.c's vma_merge(). I cannot recall anymore whether merges
> > >>> which map over existing ranges were working correctly, i.e. was
> > >>> the issue only concerning adjacent VMA's.
> > >>>
> > >>> What I'm looking here is that can we make some cosntraints that
> > >>> if satisfied by the pfnmap code, it could leverage the code from
> > >>> vma_merge(). Perhaps by making explicit call to vma_merge()?
> > >>> I get that implicit use moves too much responsibility to the mm
> > >>> subsystem.
> > >>>
> > >>
> > >> Hi Jarkko,
> > >>
> > >> Just want to understand more on the background:
> > >>
> > >> Are you seeing any real problem due to needing a lot of mmap()s to t=
he
> > >> same enclave, or it is just a problem that doesn't look nice and you
> > >> want to resolve?
> > >>
> > >> I mean, this problem doesn't seem to be SGX-specific but a common on=
e
> > >> for VMAs with VM_PFNMAP (any bit in VM_SPECIAL), e.g., from random
> > >> device drivers with mmap() support.  We will need a good justificati=
on
> > >> if we want to make any core-mm change, if any, for this.
> > >=20
> > > It requires essentially replicating core mm in user space.
> > >=20
> >
> > Is there any real problem if we don't do this at all (neither in core m=
m=20
> > nor in userspace)?
>
> 7f8f00000000-7f8f00009000 r--s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f00009000-7f8f00034000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f00034000-7f8f000ff000 r-xs 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f000ff000-7f8f00201000 ---p 00000000 00:00 0
> 7f8f00201000-7f8f003fc000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f003fc000-7f8f003fd000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f003fd000-7f8f00400000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f00400000-7f8f00643000 r--s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f00643000-7f8f0197b000 r-xs 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0197b000-7f8f01bab000 r--s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f01bab000-7f8f01fa7000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f01fa7000-7f8f08000000 ---p 00000000 00:00 0
> 7f8f08000000-7f8f08001000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08001000-7f8f08003000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08003000-7f8f08006000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08006000-7f8f0800b000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0800b000-7f8f08014000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08014000-7f8f08025000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08025000-7f8f08046000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08046000-7f8f0804a000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0804a000-7f8f0804b000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0804b000-7f8f0804c000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0804c000-7f8f0804d000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0804d000-7f8f0804e000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0804e000-7f8f0804f000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0804f000-7f8f08050000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08050000-7f8f08051000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08051000-7f8f08052000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08052000-7f8f08053000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08053000-7f8f08054000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08054000-7f8f08055000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08055000-7f8f08056000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08056000-7f8f08057000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08057000-7f8f08058000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08058000-7f8f08059000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08059000-7f8f0805a000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0805a000-7f8f0805b000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0805b000-7f8f0805c000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0805c000-7f8f0805d000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0805d000-7f8f0805e000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0805e000-7f8f0805f000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0805f000-7f8f08060000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08060000-7f8f08062000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08062000-7f8f08063000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08063000-7f8f08064000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08064000-7f8f08065000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08065000-7f8f08066000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08066000-7f8f08067000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08067000-7f8f08068000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08068000-7f8f08069000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08069000-7f8f0806a000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0806a000-7f8f0806b000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0806b000-7f8f0806c000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0806c000-7f8f0806d000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0806d000-7f8f0806e000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0806e000-7f8f0806f000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0806f000-7f8f08070000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08070000-7f8f08071000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08071000-7f8f08072000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08072000-7f8f08081000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08081000-7f8f08082000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08082000-7f8f08083000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08083000-7f8f08084000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08084000-7f8f08085000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08085000-7f8f08086000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08086000-7f8f08087000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08087000-7f8f08088000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08088000-7f8f08089000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08089000-7f8f0808a000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0808a000-7f8f0808b000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0808b000-7f8f0809a000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0809a000-7f8f0809c000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0809c000-7f8f0809d000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0809d000-7f8f0809e000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0809e000-7f8f080a0000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f080a0000-7f8f080a3000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f080a3000-7f8f080a9000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f080a9000-7f8f080b5000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f080b5000-7f8f080c0000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f080c0000-7f8f080c6000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f080c6000-7f8f080d1000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f080d1000-7f8f080dd000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f080dd000-7f8f080f4000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f080f4000-7f8f08121000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08121000-7f8f0814a000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f0814a000-7f8f08162000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08162000-7f8f08177000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08177000-7f8f081a0000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f081a0000-7f8f081c1000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f081c1000-7f8f081d6000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f081d6000-7f8f081ff000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f081ff000-7f8f08228000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave
> 7f8f08228000-7f8ffffff000 ---p 00000000 00:00 0
> 7f8ffffff000-7f9000000000 rw-s 00000000 00:05 84                         =
/dev/sgx_enclave

Just giving ridiculous answer to a ridiculous question.

You clearly started commenting w/o reading the original thread.

BR, Jarkko
