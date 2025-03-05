Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C461FDA;
	Wed,  5 Mar 2025 00:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741132918; cv=none; b=r8TrW+1JdZVLWf/649xWNCAcOCu5gmc/86QR4XCbr+OkKQGqrSP9jIfIx7+RuIamGBoCXDlEf9SWSBg1+ycsC+BRQMc2qI2ViCB245ezI2gUogGFQgAeAUvRMguq9gEXl0zjWiVBDxxC/g261Yc+bPgqDP+zD0RMT3VOQtpfouU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741132918; c=relaxed/simple;
	bh=kuUVjqvDQ2nlQ/tWv11clt7d+84RweKrOf4HgXk44p0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P5Vf2U0H0SyZTjmjTK6ASRygfGMWSGAHwxZVz7ZKor1UKc4NabYLZMvd/FQV3R6rAwsMJtMAJ2GiZ/ovmUCv7ySr7nowBzdFbS0m0mY12oljJUCZkoc0eloVPdCakLHLiqEfdlU+uff/Xnlv1mSZ3E3k2wGPCjqWQtY9feQ5hLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jlYx1ebn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jlYx1ebn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB51C4CEE5;
	Wed,  5 Mar 2025 00:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741132917;
	bh=kuUVjqvDQ2nlQ/tWv11clt7d+84RweKrOf4HgXk44p0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jlYx1ebntuTvqNdBjwyctRhn2g8rbJWY0omlCtjeMrLIrY5McXNUtc5c/bY+1RSoI
	 pO2XBNOPw/fuAn422p7nJAuYr+dUrwlvSj5tL+gdtSChOzCKIwBZGFeLAPbXN0Dkud
	 Wbo17BBdPE9y3cUtbyzq+i4JtvUgzRQJi5vXNYShQi1L/BZupSn+rbUmRp6IQudfwK
	 wJj5c9hQ7/zQjGU/cSsMyfh98BhpvxKI9hB7UW2qh9GTnLkqlNQxkNB0tFl8vTeznN
	 TIkg6gWBJ67PcfGeUSO3Ds5z7FduH1U9I5onUVRj8gvS0P4b9D55G3BhmcvePa4aG1
	 hrEE5R7pf6WhA==
Date: Wed, 5 Mar 2025 02:01:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86: Fix size overflows in sgx_encl_create()
Message-ID: <Z8eUcELiMdcM5IJq@kernel.org>
References: <20250304225648.116440-1-jarkko@kernel.org>
 <45e68dea-af6a-4b2a-8249-420f14de3424@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45e68dea-af6a-4b2a-8249-420f14de3424@intel.com>

On Tue, Mar 04, 2025 at 03:30:54PM -0800, Dave Hansen wrote:
> On 3/4/25 14:56, Jarkko Sakkinen wrote:
> > The total size calculated for EPC can overflow u64 given the added up page
> > for SECS.  Further, the total size calculated for shmem can overflow even
> > when the EPC size stays within limits of u64, given that it adds the extra
> > space for 128 byte PCMD structures (one for each page).
> > 
> > Address this by adding the necessary validation for each partial results
> > before going forward. Return -E2BIG when an overflow is detected.
> 
> Wouldn't this be a lot simpler if we just had some sane limit that's
> *FAR* below where u64 will overflow?

Yes, we can simply check right at the get go that the uarch requirement
of SGX is satisfied: secs->size is power of two.

BR, Jarkko
