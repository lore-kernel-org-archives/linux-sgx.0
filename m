Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB81B3839C
	for <linux-sgx@vger.kernel.org>; Sun, 22 Sep 2024 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727024251; cv=none; b=gkXppVlbiGEWuqRh8G523pCIs567Dn6UG1oGTMgBrT6Cl864zN26+g7wF4ObYncvh/l6lNdojexpCkNAVal5sIMIqPYLjOy5iLWBmmX/BuFBo6UhSiwt+h2GgS3k2GvlmFh27T5IQBntaXOPitViKmeH7R6nXeO0L5nUsd6wBoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727024251; c=relaxed/simple;
	bh=Ttqj47KjYkGxWdbrWa7gvWu9j3bTAFQ5VveFE3va1Ro=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=KSJfZAGZ2O32p+NWwHZxuVOJqiq5XIK/2b2rM+iPBufykvaDcXyDGmMDCvRf5OXXLPaHX4GFWdEO4qzDOK6D93UT/Ucwm+rrlJfmXRIS6+6SO5Ic67Xb+VhjuBt9KNq4oXc8tBa9FRfg8+WL7tuxJE9aOA7t+xyPaa3lb2bx4rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DK37ClKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DK37ClKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F53C4CECE;
	Sun, 22 Sep 2024 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727024251;
	bh=Ttqj47KjYkGxWdbrWa7gvWu9j3bTAFQ5VveFE3va1Ro=;
	h=Date:Subject:From:To:References:In-Reply-To:From;
	b=DK37ClKx20psql9vvlJThNErGbasy2tQfbZaiDpZG9I82/IshqsGQMiJhamQoxtv4
	 bGm1m7I8tU3pFYwp8G7G9Sk5WvyIoG/VGTkgYrcZm8iPFk7tOSE0nHFBrFcwz2x2TE
	 4/d2A21J7PKTRG+gviaxL5FUucCjL59bBoe54VP7jczKXZv5U3YQb+F+YXuWWHcNm5
	 /0kcmSAa00CUSEhlbPCBPjBNDqr4H386WIbdP+8YVd6HQNIYeQy/wnN2Qxro7RfAPd
	 Pyf2uwKAPrRKY8xxxjZZkpLo1/LzByskiQS+zUlTyde5VDoxddZQECMWRE6KGYdnqh
	 5gkhsbyN087yQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 22 Sep 2024 19:57:27 +0300
Message-Id: <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
Subject: Re: VMA merging updateds?
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Jarkko Sakkinen" <jarkko.sakkinen@iki.fi>, <linux-sgx@vger.kernel.org>,
 <linux-mm@kvack.org>
X-Mailer: aerc 0.18.2
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi>
In-Reply-To: <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi>

> On Sun Sep 22, 2024 at 7:27 PM EEST, Jarkko Sakkinen wrote:
> > Hi
> >
> > I started to look into this old issue with mm subsystem and SGX, i.e.
> > can we make SGX VMA's to merge together?
> >
> > This demonstrates the problem pretty well:
> >
> > https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd42018824=
f97.camel@kernel.org/
> >
> > It was result of brk() syscall being applied a few times.

Briging some context here. This can be fixed in the run-time by book
keeping the ranges and doing unmapping/mapping. I guess this goes
beyond what mm should support?

I thought to plain check this as it has been two years since my last
query on topic (if we could improve either the driver or mm somehow).

BR, Jarkko
