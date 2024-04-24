Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800CB1428F9;
	Wed, 24 Apr 2024 10:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713955352; cv=none; b=jrqUZ4UoJPUJFsLCjYuvslpzEc0kZGMrM97PUHfp1/FjtlwMnWo6OfkYZRWJNlgSrapks6KC5fpEYRpY+rkyr8i/g7o21sltanWKXdJbk918RB2pHFKr3WsmdbBOEaTHaog2LfTZXRb8VtVRUHJJq1G00Yh3pIxI2t4VyuP41II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713955352; c=relaxed/simple;
	bh=KDBVxFl2yr98XTL883s9LytCD+NjLU2a39+qhbVZIr0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=lEf4dI9QXTg6+3yaeI8wOnJOHffX+aLalDq/UcKgHY1FXmzy1SH/cXQXsIf2+EYVdDPDwHiwO5yZGI8dmJdIgzb2kgaAURjzIv4HKzSPR63TPN/dMWdlLgObLib5SVBGP3H7852KzKAzkNVLrpsQe9kmggVi8jo/gMdAfJ4iuJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uiuXsG9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uiuXsG9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD4BC113CE;
	Wed, 24 Apr 2024 10:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713955352;
	bh=KDBVxFl2yr98XTL883s9LytCD+NjLU2a39+qhbVZIr0=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=uiuXsG9x1xajMFF4vw6ql7I9b9i+GHjvUk8CFnfopl24XaQ9bLtEppV3FqVCpOWRc
	 xnDa9tz0jImkSb7hpUnOebMP7CLfdDX591VSutpzuczSGn8O1Al3dQB1bFeRlWW6Bq
	 n6Vf/Rdb5+lf/YeahOW0ak8ssuV6Zx2Y9hZRexqUVWoLwtrYCN/oztKJbMTlOjhx2a
	 +EQNT5qiTgpvAUoeNfed7nXmpRA2H8cbktrwVU2G2UT6ONZb7H2BL6vnDfyLum5MdT
	 YvQO6AeT6ezQc46SePWJIFUl4nWSOf11lJGmO5Ml/A0BKuoBLyNynsg//QcDc9UW3b
	 QAdIy6V1R0G3Q==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 24 Apr 2024 13:42:28 +0300
Message-Id: <D0SAGP6DPKXF.2EHTXI9UH0HQ9@kernel.org>
Cc: =?utf-8?b?5YiY5Y+MKOi9qeWxuSk=?= <ls123674@antgroup.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>
Subject: Re: [RFC PATCH 1/1] x86/sgx: Explicitly give up the CPU in EDMM's
 ioctl() to avoid softlockup
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "Bojun Zhu"
 <zhubojun.zbj@antgroup.com>, "Huang, Kai" <kai.huang@intel.com>,
 "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
X-Mailer: aerc 0.17.0
References: <20240423092550.59297-1-zhubojun.zbj@antgroup.com>
 <20240423092550.59297-2-zhubojun.zbj@antgroup.com>
 <02fe00c3b10e4476d500ad7a34024b7eae5e3c97.camel@intel.com>
 <85dfbebc-a2d5-4828-b3b9-f929cd6e30cf@antgroup.com>
 <D0S5S2NL1N5P.3Q0SM01VIZBJX@kernel.org>
In-Reply-To: <D0S5S2NL1N5P.3Q0SM01VIZBJX@kernel.org>

On Wed Apr 24, 2024 at 10:02 AM EEST, Jarkko Sakkinen wrote:
> On Wed Apr 24, 2024 at 9:46 AM EEST, Bojun Zhu wrote:
> > Based on the the discussion among you, Jarkko and Reinette,
> > I will keep the need_resched() and wrap the logic in using sgx_resched(=
),
> > as suggested by Jarkko.
>
> Sounds like a plan :-)

In sgx_ioc_enclave_add_pages() "if (!c)" check might cause possibly
some  confusion.

Reason for it is that in "transaction sense" the operation can
be only meaningfully restarted when no pages have not been added
as MRENCLAVE checksum cannot be reset.

BR, Jarkko
