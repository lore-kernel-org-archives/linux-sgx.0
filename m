Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF54383A3;
	Thu, 15 Aug 2024 18:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723746872; cv=none; b=V5SamCMFAlMgN5NnJedcAPmTvNHnLqz2mYG7sBDVrhLENCWYmQcx97hwx4Lk8L84gIUp9G2zKVvyAm8+u/QnngNG/1Qo+ez7dL9S+3+iSsKxY1ptazvfVjjmFbsx75POa18t0FgT7KwrC9YBuGk9Kl2MI+t3VTO4uEkHZto1DpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723746872; c=relaxed/simple;
	bh=nWfVmAun0Cx3DA+43CHSrDQiQLi21CFd4iQTZkbUIk0=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=OWcRzA4VqZftxRqSjJ4g8JKgV/Gmfi7TDSjAEakOrup4ddxTmscoZSPTKEFuvjfyNTaFJ//WdDdf1ngks4dnSELdNf5r+zSt4dwi9CMQOSkqZWGlfXhPWuLBBvSF/+NiRr96silEvu0p8VegxptPbeAsPfrKfDHKsxofsY6j3Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1w0wzHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1w0wzHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2421EC32786;
	Thu, 15 Aug 2024 18:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723746871;
	bh=nWfVmAun0Cx3DA+43CHSrDQiQLi21CFd4iQTZkbUIk0=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=o1w0wzHcdGcuv4jtDomB1MsIEG92YWnwO4bTUbCio34b5S1w1x9K9zBsmwR+s80xl
	 o9saMHCVYZy+3tiCZtSfWSNIXC60MG27YpQCuSax08dSV2oTE65RjajxRMUPcESm9t
	 6nXZ7IhEIav4GqyJRHCxDuXECLrxUBLRMZqWWYF3moI4YbZqXd6M4AADoHUGcuRhNV
	 rfJYkAZ2OUnv36FYRw0vw5vXUojT/u1abxAw6tFmFj6ZAk1aZbUidEVVqK/sxhnKT3
	 nuX7+ogjv6X+QWXydGgQfsDERgrPEKbLgvVEZOKSvm6UTWyprSmS7Boch3vlTYfsRI
	 OO9O1Z8HvGDTQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 Aug 2024 21:34:27 +0300
Message-Id: <D3GP9N3N7TUE.38H37K436OD50@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>
Cc: <dave.hansen@linux.intel.com>, <haitao.huang@linux.intel.com>,
 <kai.huang@intel.com>, <kailun.qin@intel.com>,
 <linux-kernel@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
 <mona.vij@intel.com>, <reinette.chatre@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
From: "Jarkko Sakkinen" <jarkko@kernel.org>
X-Mailer: aerc 0.17.0
References: <D2RQZSM3MMVN.8DFKF3GGGTWE@kernel.org>
 <20240812082543.3119659-1-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240812082543.3119659-1-dmitrii.kuvaiskii@intel.com>

On Mon Aug 12, 2024 at 11:25 AM EEST, Dmitrii Kuvaiskii wrote:
> On Wed, Jul 17, 2024 at 01:38:59PM +0300, Jarkko Sakkinen wrote:
>
> > Ditto.
>
> Just to be sure: I assume this means "Fixes should be in the head of the
> series so please reorder"? If yes, please see my reply in the other email
> [1].

OK, based on your earlier remarks and references I agree with you.

>
> [1] https://lore.kernel.org/all/20240812082128.3084051-1-dmitrii.kuvaiski=
i@intel.com/
>
> --
> Dmitrii Kuvaiskii

I think for future and since we have bunch of state flags, removing
that "e.g." is worth of doing. Often you need to go through all of
the flags to remind you how they interact, and at that point "one
vs many" does help navigating the complexity.

BR, Jarkko
