Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A2164A8F;
	Thu, 15 Aug 2024 18:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723747039; cv=none; b=VWkQyjIRLN3q5eAMGUFTO3VsBIg9j1RMcJ0yYjOkb9pLslqvtf3E8fxVFZbEgMfS6nzCldG2JvgqYzsw219b0Y+gqCMyESXqJxsJ5NEHPU4lhct9ghqzOgE2/SDFws7/KndEOEYpfJL+P0osQr/jtllZWfkj+69VxJr1kZLpxn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723747039; c=relaxed/simple;
	bh=aMf3pjfpTnX8z327HHQryX/4jONEwof5psCMcESWwxI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=R8WrE4oNFAkaA5Xj/JdAeu6sTC6cIj9CunMzf6pIWvy7jkd1cwj01HXx5HhumfVmzBjsUKP1OR8C601gzCr+SamjniOSR2fnYMnlQHtOs58na67OamaRInsuxU7AV8bwWyCBVCHEJ1xw10MY/ybZM+Vab1zNwWJJY2H1LrgtaVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsmA154B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsmA154B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F103C4AF0E;
	Thu, 15 Aug 2024 18:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723747039;
	bh=aMf3pjfpTnX8z327HHQryX/4jONEwof5psCMcESWwxI=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=AsmA154BqQHKlCyLqkllG8Xwe9v3J7vaFKoxn5adE1NpPXD6mp2JoBX8Hjioyu1Gs
	 P4SWvAp3ZJzrCyG0yL2/6X/GZvhjUMv1lwgS2VSBaZ8GewJWOy+/NGBTWSacMhAyrZ
	 zzPgNh3pCiNDzAmgtF2Ky+Y60/21RD7CUKtHBEOqQLwdSop2nxHOg3M11HQ9ahSeCJ
	 dspq2B76Yca/vBjBgxQNeBhnC/1olkDk62s4PWwTSKfCTFHzMyIgVyXC5U4zczRpK4
	 7OsEA+0TCkhCrdhoME/RWIn5+0VQBlPaVw4CrTN1xRJvaHg+iMh22SQHsXTbiMUwKe
	 nA4eyCWu3lDfw==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 Aug 2024 21:37:15 +0300
Message-Id: <D3GPBS12YXTZ.3M7RZ3EGDHN8E@kernel.org>
Subject: Re: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "Dmitrii Kuvaiskii"
 <dmitrii.kuvaiskii@intel.com>
Cc: <dave.hansen@linux.intel.com>, <haitao.huang@linux.intel.com>,
 <kai.huang@intel.com>, <kailun.qin@intel.com>,
 <linux-kernel@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
 <mona.vij@intel.com>, <reinette.chatre@intel.com>, <stable@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <D2RQZSM3MMVN.8DFKF3GGGTWE@kernel.org>
 <20240812082543.3119659-1-dmitrii.kuvaiskii@intel.com>
 <D3GP9N3N7TUE.38H37K436OD50@kernel.org>
In-Reply-To: <D3GP9N3N7TUE.38H37K436OD50@kernel.org>

On Thu Aug 15, 2024 at 9:34 PM EEST, Jarkko Sakkinen wrote:
> On Mon Aug 12, 2024 at 11:25 AM EEST, Dmitrii Kuvaiskii wrote:
> > On Wed, Jul 17, 2024 at 01:38:59PM +0300, Jarkko Sakkinen wrote:
> >
> > > Ditto.
> >
> > Just to be sure: I assume this means "Fixes should be in the head of th=
e
> > series so please reorder"? If yes, please see my reply in the other ema=
il
> > [1].
>
> OK, based on your earlier remarks and references I agree with you.
>
> >
> > [1] https://lore.kernel.org/all/20240812082128.3084051-1-dmitrii.kuvais=
kii@intel.com/
> >
> > --
> > Dmitrii Kuvaiskii
>
> I think for future and since we have bunch of state flags, removing
> that "e.g." is worth of doing. Often you need to go through all of
> the flags to remind you how they interact, and at that point "one
> vs many" does help navigating the complexity.

Actually every time there's a patch that has anything to do with
the state flags I go through all  of em as a reminder. Might seem
like irrelevant detail but really is not (and neither unnecessarry
nitpicking). All small clues speed up that process or can mislead.

BR, Jarkko
