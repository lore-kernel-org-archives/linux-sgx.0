Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EDF54BD4;
	Thu, 15 Aug 2024 18:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723746647; cv=none; b=rxFbIxfZK7yQWcUHYWUt+vT6G6VPwgVnYjrdM6EDv7pWMDY5HEZjPx31h7r5AgjlF5cRBcEOKxLRVRtmCT+Eh8TGVBaMWZ/nRcL0sUYOU8sKnm7wYLUvCl3nqxz4eTcOBthAbSITbQ+Mn0EnnvMoLcOK4VGgLc3N5UGq5/AFOGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723746647; c=relaxed/simple;
	bh=SV8UAoQ3XpbPb0QZKCXFcKTUB4yX1MZ0hrVo9Ppxwn0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=b1T4eNKVSMyUGjqkDyu2+oLjr6qKLqUUSVGo/3ySgicftoSjEj2OdbaORwdR6QmEukFjKeiFPRj3bDmDnuQLH1PHOBCWVh1nanuzTX5I9p6Pmlvi5wyJnbZPaQj33a3sc1x3UB93R2BU+kejiHt15SE+3ZVNaSqbmnp5NnhiTv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMjOXUz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMjOXUz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47C8C32786;
	Thu, 15 Aug 2024 18:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723746647;
	bh=SV8UAoQ3XpbPb0QZKCXFcKTUB4yX1MZ0hrVo9Ppxwn0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=jMjOXUz7ellBF/y6UsP27p+vUFi6gukiVfOaOpNrWF2ty3I4HY6n0QVQ2UzjyDJDG
	 EdgOoDDOXX1H59fyBopKJRGh4gQJ/h7C7WghTlECKlaWEjki0+zsWdHUNpTkBBF79V
	 vx1xUVaNPbfQ4AnMfw6gAWoPaKxTuYx5fJquOxHFeF1SAdbgbgPBkhQYHhA1+Go5RY
	 7xRGSPwYrIKm3SBVUbUJ1bKewQ+0WwcDe/LngUx87inVHbybyoGiMwKsxBYyu0rIHk
	 BApDoA1iyu7cvIwzCMhl+HhUFnQ8Ri8F1L32XL+/GY6upNeCZ5zjpHAPB1BwI5aBDR
	 rU4ayWzZG0bbg==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 Aug 2024 21:30:43 +0300
Message-Id: <D3GP6S1IDRS3.1YZNPT4GIR5TS@kernel.org>
Subject: Re: [PATCH v4 1/3] x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED
 into two flags
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>
Cc: <dave.hansen@linux.intel.com>, <haitao.huang@linux.intel.com>,
 <kai.huang@intel.com>, <kailun.qin@intel.com>,
 <linux-kernel@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
 <mona.vij@intel.com>, <reinette.chatre@intel.com>, <stable@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <D2RQYS2CVEWL.3IU1P67NT0D5Y@kernel.org>
 <20240812081657.3046029-1-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240812081657.3046029-1-dmitrii.kuvaiskii@intel.com>

On Mon Aug 12, 2024 at 11:16 AM EEST, Dmitrii Kuvaiskii wrote:
> On Wed, Jul 17, 2024 at 01:37:39PM +0300, Jarkko Sakkinen wrote:
> > On Fri Jul 5, 2024 at 10:45 AM EEST, Dmitrii Kuvaiskii wrote:
> > > +/*
> > > + * 'desc' bit indicating that PCMD page associated with the enclave =
page is
> > > + * busy (e.g. because the enclave page is being reclaimed).
> > > + */
> > > +#define SGX_ENCL_PAGE_PCMD_BUSY    BIT(3)
> >
> > What are other situations when this flag is set than being
> > reclaimed? The comment says that it is only one use for this
> > flag.
>
> Yes, your understanding is correct, currently there is only one situation=
.
>
> Do you want me to modify the comment somehow?

Yes, just s/e.g.//

>
> --
> Dmitrii Kuvaiskii


BR, Jarkko
