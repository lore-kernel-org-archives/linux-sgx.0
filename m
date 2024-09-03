Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581E718A6C1;
	Tue,  3 Sep 2024 16:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725379544; cv=none; b=K9/arFuOd8MMoeW63OZXgj/EJVnyagm/o8CcQf3T8HoE3ry1/+SZ3gbBzmF/xx53+Pq8vm1/MY9qR7mfxoghUh4h6I4MU/x2HPvI6ARLV5rtt56/y0vi8LNeYP15N9dZv1gljgiRkaoEI+TAsMsFDamYz7+XldRejayoz4ziURM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725379544; c=relaxed/simple;
	bh=78DCBS8RA2D93D+enVkc7piqW+f1dBnC88pDQa0b4Wk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=PXhtXB5J6XK/xpAa9oT3b8Nl3Ycuog4mwra7EamekgFFf1lOrQ9jbRUaAMLFgN0VRyDd/UobJwhVHqfuPfJ6o7BA+BTq3RqvpKWUVfrqb3e+NcfpjlSxelHNKK07LicIjCieE8oKp3OSnW7sUIs6z0/kjCzxrNpyH6rAn5+WYVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=joNpwx+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="joNpwx+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CFBC4CEC4;
	Tue,  3 Sep 2024 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725379543;
	bh=78DCBS8RA2D93D+enVkc7piqW+f1dBnC88pDQa0b4Wk=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=joNpwx+z5DBrT/7UrmsEo+ROkE/86tRHlNi2dCa8xUSvSIBNlbGC0xi+COyHgzVC1
	 76xVKGLa0FuYbBtX8tUV3Im6ebR5KaZoKqhk/C33YxCxiAj3xHqj8PH6O+PxR8ekaw
	 mCPq9Xs9RJQLSaWNvAgC+c8F8VOAQVYCFXTxCMmZWKb59WmpmAK+CRRd+mACeHOC35
	 N4Mp84DAiU4uwGcUvUL+KWPzA6CJRvSz2yBNlJNwGB7j04wskNFKDgMfO0opaXRtTV
	 pqcwO/vh7CXrJY8Ju0ObGN3Ll0DTlIXV9Ql7CwITUepujouvo3dHIB/MY7O/uuG1S8
	 NORRuejX5ZCzQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Sep 2024 19:05:40 +0300
Message-Id: <D3WS02D8SZMG.62T9IWX6WZI4@kernel.org>
Cc: "Dave Hansen" <dave.hansen@linux.intel.com>, <x86@kernel.org>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Zhimin Luo"
 <zhimin.luo@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Aaron Lu" <aaron.lu@intel.com>
X-Mailer: aerc 0.18.2
References: <20240829023800.1671210-1-aaron.lu@intel.com>
 <D3SJOVADFM48.JNOIOZJ0J6OE@kernel.org> <ZtFjPwNWS_hfs4px@ziqianlu-kbl>
In-Reply-To: <ZtFjPwNWS_hfs4px@ziqianlu-kbl>

On Fri Aug 30, 2024 at 9:14 AM EEST, Aaron Lu wrote:
> On Thu, Aug 29, 2024 at 07:44:13PM +0300, Jarkko Sakkinen wrote:
> > On Thu Aug 29, 2024 at 5:38 AM EEST, Aaron Lu wrote:
> > > When current node doesn't have a EPC section configured by firmware a=
nd
> > > all other EPC sections memory are used up, CPU can stuck inside the
> > > while loop in __sgx_alloc_epc_page() forever and soft lockup will hap=
pen.
> > > Note how nid_of_current will never equal to nid in that while loop be=
cause
> >                                                      ~~~~
> >=20
> > Oh *that* while loop ;-) Please be more specific.
>
> What about:
> Note how nid_of_current will never be equal to nid in the while loop that
> searches an available EPC page from remote nodes because nid_of_current i=
s
> not set in sgx_numa_mask.

That would work I think!

>
> > > nid_of_current is not set in sgx_numa_mask.
> > >
> > > Also worth mentioning is that it's perfectly fine for firmware to not
> > > seup an EPC section on a node. Setting an EPC section on each node ca=
n
> > > be good for performance but that's not a requirement functionality wi=
se.
> >=20
> > This lacks any description of what is done to __sgx_alloc_epc_page().
>
> Will add what Dave suggested on how the problem is fixed to the changelog=
.

Great. I think the code change is correct reflecting these additions.
I'll look the next version as a whole but with high probability I can
ack that as long as the commit message has these updates.

>
> > >
> > > Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to =
sgx_alloc_epc_page()")
> > > Reported-by: Zhimin Luo <zhimin.luo@intel.com>
> > > Tested-by: Zhimin Luo <zhimin.luo@intel.com>
> > > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>
> Thanks,
> Aaron

BR, Jarkko
