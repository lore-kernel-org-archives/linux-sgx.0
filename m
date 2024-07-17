Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF6019A;
	Wed, 17 Jul 2024 10:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721212572; cv=none; b=F8aOXsE4Ok9+Ozv8iKI2wbyPUFcQQJUtXEuq65ahuPvt1Lw55jXM+D6tbeOJ20Fm1OcokcHLPzN/SU0ICTEmBjU2TByKivztfB22+kp8MUl/kWL5Yc2Mo7zwFF6dUAVPgPWMupDFs7ejxEcDBB4ualOqlBigWLo/pCJBfg3ptPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721212572; c=relaxed/simple;
	bh=E2dR+Vt+GQNtuSMxpalUSQ7oR9r3bZL8h8+gar+yttI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=hoq2XYRy5ERovzTnzKZgGdbuWgp25WExF5e+OeocrBfz5Ndh0B3LgL+3TwXcuYD0EgGsufv6Nk49TFAO8S7jGqy5PQ7YY6ty51j5TLFIwzhij8bGzJ6492bqJgFtBd5xFGnSPiKDYF+u9dkg/+1wmaBvSbdbfMyrtPLDuSWU8p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HBV3zmSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HBV3zmSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59623C32782;
	Wed, 17 Jul 2024 10:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721212572;
	bh=E2dR+Vt+GQNtuSMxpalUSQ7oR9r3bZL8h8+gar+yttI=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=HBV3zmSFqXcs/Rd0GQLWbrC2CTP2qgi7nVcKZm3IWRKIx8XM9LNF2OT36l9WSNFlO
	 NYX28Fmoeic/gEQjS/mK012KNZj5cz7pVaeRC3oFqdv9laC3HFau8Y9xRqOuNPqvwP
	 pAMeVxxiksSe4rdNUpZFIQjfD5EUpKh4Iu94td6DquXeqkYLpsT3t6l4huoh4Mb/kW
	 AsFDrHlNkxJPKs2YSClqE2I5F3rnVDUXRcYngdm2PAwDj4wv5rTNK/5IZQbSV+Di5p
	 7DibR3cpFlNX+zggpLOc7g9ggsNAPo5dgD4EZjyGohqF1qW/Cbaa/rTWyauRzXSIml
	 pWSKP9X5V8pQQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jul 2024 13:36:08 +0300
Message-Id: <D2RQXM679U0X.1XY6BWHSFTRFZ@kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED
 into two flags
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>,
 <dave.hansen@linux.intel.com>, <kai.huang@intel.com>,
 <haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
 <20240705074524.443713-2-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240705074524.443713-2-dmitrii.kuvaiskii@intel.com>

On Fri Jul 5, 2024 at 10:45 AM EEST, Dmitrii Kuvaiskii wrote:
> SGX_ENCL_PAGE_BEING_RECLAIMED flag is set when the enclave page is being
> reclaimed (moved to the backing store). This flag however has two
> logical meanings:
          ~~~~~~~~
	  side-effects

Missing the actor.

"The page reclaimer thread sets SGX_ENC_PAGE_BEING_RECLAIMED flag..."

It is not just randomly "set".

>
> 1. Don't attempt to load the enclave page (the page is busy).

Please point out where in the source code.

> 2. Don't attempt to remove the PCMD page corresponding to this enclave
>    page (the PCMD page is busy).

Please point out where in the source code.

These would be great reference when looking back.

>
> To reflect these two meanings, split SGX_ENCL_PAGE_BEING_RECLAIMED into

I don't care about meanings. Only who does and what.

BR, Jarkko
