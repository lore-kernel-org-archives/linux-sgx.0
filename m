Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C7E13F450;
	Wed, 15 May 2024 14:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715783328; cv=none; b=cvewRM59S++Ti2/fh6joG2zlCYT1CMDbB4tV/7xwIsCgueim7zLBF9wWam6Rln9ENHxidVXsaVmkKRy4fw76XF0q+66Q+9PiQzPc+IPaI6r1p9bp5Eyet3bYytgj8UcwySLPHQHJUNt/zTg2gs+DWSQK/KFSSNkgp6MqJuJG8cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715783328; c=relaxed/simple;
	bh=wVxlxaCe3WCmkKrErEY5yiOlxIbpPpGgac7nwZVst50=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=B0YkHbeGNALn5YqgWB6zGiqRsJUkZOZfo2F9LJ+qFz6+3dSOtceXtDIRnW9/72Y+yXAvY8rXoqhKh0rXvePWuS6DwBAQ+cIN7vaG3dVlswVkd6gbRZocIRRJ34hP2bVQ4BXhEnagT23TM1w86qxfPBLqLoKrDj0rYqXp6XSH/HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O424Jpx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O424Jpx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37208C116B1;
	Wed, 15 May 2024 14:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715783327;
	bh=wVxlxaCe3WCmkKrErEY5yiOlxIbpPpGgac7nwZVst50=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=O424Jpx4eTABQG70Ji1zLKnoiOWWaNqrxpvSW/DvCqHfLa05vyyCBVX5GH3VZUKk6
	 O3QL9RMabQQX0nzu2PbVvkF+PLP9hoM0duU9K4dUWrZm9ce7bm2TAMrnCBnvmoAnkM
	 Uf/plchz0n3Wza7jtk7w2/VylD6+Nt9xyHSY2fL5Fl0NWF3O0mszwYHIjuupEKUfZ9
	 DNivSAZrPw007Mz/InHOP2cmS6pYndphnHeEq50htflhtBE6lAwF8rLbKMD6nsQKP6
	 NZWDX3u8RAruvHx15PLE4miI7Rf2bEmLl6x1X6DbgXKwNCw+YkYC7oPqXUk4MZuCx1
	 Zns8dy2xQAL4g==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 May 2024 17:28:43 +0300
Message-Id: <D1AAFDCSFYH1.11RF8JUS2NEZS@kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>,
 =?utf-8?q?Marcelina_Ko=C5=9Bcielnicka?= <mwk@invisiblethingslab.com>
Subject: Re: [PATCH v2 1/2] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dave Hansen" <dave.hansen@intel.com>, "Dmitrii Kuvaiskii"
 <dmitrii.kuvaiskii@intel.com>, <dave.hansen@linux.intel.com>,
 <kai.huang@intel.com>, <haitao.huang@linux.intel.com>,
 <reinette.chatre@intel.com>, <linux-sgx@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
 <20240515131240.1304824-2-dmitrii.kuvaiskii@intel.com>
 <D1A9PC6LWL2S.38KB2X3EL9X79@kernel.org>
 <58e9d453-7909-4157-86fd-a2d5561e728e@intel.com>
In-Reply-To: <58e9d453-7909-4157-86fd-a2d5561e728e@intel.com>

On Wed May 15, 2024 at 5:15 PM EEST, Dave Hansen wrote:
> On 5/15/24 06:54, Jarkko Sakkinen wrote:
> > I'd cut out 90% of the description out and just make the argument of
> > the wrong error code, and done. The sequence is great for showing
> > how this could happen. The prose makes my head hurt tbh.
>
> The changelog is too long, but not fatally so.  I'd much rather have a
> super verbose description than something super sparse.
>
> Would something like this make more sense to folks?
>
> 	Imagine an mmap()'d file. Two threads touch the same address at
> 	the same time and fault. Both allocate a physical page and race
> 	to install a PTE for that page. Only one will win the race. The
> 	loser frees its page, but still continues handling the fault as
> 	a success and returns VM_FAULT_NOPAGE from the fault handler.
>
> 	The same race can happen with SGX. But there's a bug: the loser
> 	in the SGX steers into a failure path. The loser EREMOVE's the
> 	winner's EPC page, then returns SIGBUS, likely killing the app.
>
> 	Fix the SGX loser's behavior. Change the return code to
> 	VM_FAULT_NOPAGE to avoid SIGBUS and call sgx_free_epc_page()
> 	which avoids EREMOVE'ing the winner's page and only frees the
> 	page that the loser allocated.

Yes!

I did read the whole thing. My comment was only related to the
chain of maintainers who also have to deal with this patch
eventually.

BR, Jarkko
