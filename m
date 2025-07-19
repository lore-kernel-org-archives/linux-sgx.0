Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78871D5CE8;
	Sat, 19 Jul 2025 11:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752924135; cv=none; b=VdJcSQdEMLXqxfqxtCXmsvHmPgRjz6GHevP9Q5ZquwzhhbDqaUC/h2d14JlM0JA5kI+tC11xFpHxrvvCNNK7qGIQ6kaKKBew/MFDlpzs1/glzv8jtliPkU6etvCBLC2Imx0P6jaScbtwOyHO0xssZBBf3vfEUS3rppUzOctwE4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752924135; c=relaxed/simple;
	bh=OemD69XNu4bVL5RG5dSNkAwP0rHMtlS8t/5gDfFpzPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTr0SNeo4U68kY7wZlXd4nLoNDhAbCmgbcwLqqp5wuKr1MYfWgEX3VPJf7sazin4AQ8kFtA5d+sNd59jf4z0z5UFBUpVOo3LxJInnfsUlsemG3BLPT869CANQWesVAxIe1z8wIKXKWEIav6qV0iijihN1U2cH/9fFcn9ZHouE8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXpBQWhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXpBQWhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E80C4CEE3;
	Sat, 19 Jul 2025 11:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752924134;
	bh=OemD69XNu4bVL5RG5dSNkAwP0rHMtlS8t/5gDfFpzPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nXpBQWhrGt8RCplSagwoNEc6e8t+dnVEaA/JJHY1TefQgeNbUQY/J9sb+aoYGX+Pa
	 sRxI3Dwsx83+if7O+rlLMjzU4Sb7uLi2azSBMo6OPXfxlsOAcnu1/TaQqeuwf7Ni1B
	 /0REXCyACxW48XnrkoZe1bDG3h5tgrX63oWU/DDL1ixBSRRQIafI2pdLOEoLNXxjB0
	 QKmO8Pt1hnoNzAuNKGQeVLcbN56qhV8/31sNVDejjV4zpHAnobA+2LZVErioujoCOh
	 HQUagU5R9Bd2OaoY0MX4G6tKMsK3pQro14KH/sZVWmdRSt8cgvV/efyZv+PMwgRpqY
	 oZWWGsQVh+PXQ==
Date: Sat, 19 Jul 2025 14:22:10 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, seanjc@google.com, kai.huang@intel.com,
	mingo@kernel.org, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v8 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Message-ID: <aHt_4oLff2zjIuNH@kernel.org>
References: <20250715124109.1711717-1-elena.reshetova@intel.com>
 <20250715124109.1711717-6-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715124109.1711717-6-elena.reshetova@intel.com>

On Tue, Jul 15, 2025 at 03:40:22PM +0300, Elena Reshetova wrote:
> -static int __maybe_unused sgx_update_svn(void)
> +static int sgx_update_svn(void)

I'd combine 4/5 and 5/5 because of this. Makes them so much easier to
backtrack changes later on if this type of stuff is avoided when
possible.

BR, Jarkko
