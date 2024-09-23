Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365D228689
	for <linux-sgx@vger.kernel.org>; Mon, 23 Sep 2024 07:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727077708; cv=none; b=eMQtQAC3OppYK0L53c8T3cA3ne5aoiqeIelPzX506XJKmuv8Hvy4GN4TWQc20qiOtwR7UIzvSXUR0khJbJgUy6Hjd/mewXiAyyqQAbvMHIc2ly4582RkLUHl6TDETu5azCLHRMrj0vSEiKoJUSmy7psGLmzyzIaqb4MtN/1CcxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727077708; c=relaxed/simple;
	bh=8rxXpFW6BNtOfD+JqInDd0LqR937jznZjZuFvZ6u51Y=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=sZ7RRkcRRIh8JHTT2Xl+46PgUF+J4bxwPslVaa5IrxQLb/DYdbJYJcVVU6iThga+Vcro+NYyRocc/VJzlSGc2Ih4TowTco+K9CVx696yDp8ndyNJqzGuwp19UfU07RYQ9mdvNzPnFL1Q7uSYrlGeLi2lJTsPMhx6IkLYm2Wovps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkst6L7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkst6L7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C58C4CEC4;
	Mon, 23 Sep 2024 07:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727077707;
	bh=8rxXpFW6BNtOfD+JqInDd0LqR937jznZjZuFvZ6u51Y=;
	h=Date:Subject:From:To:References:In-Reply-To:From;
	b=lkst6L7rnoICjE9Y4i9sxfUBcAr6l/A9eiqKQ28FdPXpGycdH7pN/iVuJCvRWuBsH
	 L3WCMoUClNhZoiF92Xcxd/qWrPIM92TcANI+vcp2WAIr8xFS3cmxWoL2W9JaOxjjYZ
	 RLIu3l58mPqqhH/rMD1fQZmJkexMS7V6EL8kkIvph4sZNnVKgKG39WirASYzUYtlS4
	 y8idgrNnQjTXg4DwnOBCLxO15ifeKZaukxyeTMduLcLKxprZ1x3IArWKpJOWkY762A
	 qVWyS9p0u2TsWH9ehGt1GS61bpYgTurwhScBwZZOyyauokYTihNKWhVgAvyl8BQrYg
	 9vxUiW0PeEJsA==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Sep 2024 10:48:23 +0300
Message-Id: <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
Subject: Re: VMA merging updateds?
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "Jarkko Sakkinen"
 <jarkko.sakkinen@iki.fi>, <linux-sgx@vger.kernel.org>, <linux-mm@kvack.org>
X-Mailer: aerc 0.18.2
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi> <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
In-Reply-To: <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>

On Sun Sep 22, 2024 at 7:57 PM EEST, Jarkko Sakkinen wrote:
> > On Sun Sep 22, 2024 at 7:27 PM EEST, Jarkko Sakkinen wrote:
> > > Hi
> > >
> > > I started to look into this old issue with mm subsystem and SGX, i.e.
> > > can we make SGX VMA's to merge together?
> > >
> > > This demonstrates the problem pretty well:
> > >
> > > https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd420188=
24f97.camel@kernel.org/
> > >
> > > It was result of brk() syscall being applied a few times.
>
> Briging some context here. This can be fixed in the run-time by book
> keeping the ranges and doing unmapping/mapping. I guess this goes
> beyond what mm should support?
>
> I thought to plain check this as it has been two years since my last
> query on topic (if we could improve either the driver or mm somehow).

In the past I've substituted kernel's mm merge code with user space
replacement:

https://github.com/enarx/mmledger/blob/main/src/lib.rs

It's essentially a reimplementation of al stuff that goes into=20
mm/mmap.c's vma_merge(). I cannot recall anymore whether merges
which map over existing ranges were working correctly, i.e. was
the issue only concerning adjacent VMA's.

What I'm looking here is that can we make some cosntraints that
if satisfied by the pfnmap code, it could leverage the code from
vma_merge(). Perhaps by making explicit call to vma_merge()?
I get that implicit use moves too much responsibility to the mm
subsystem.

BR, Jarkko
