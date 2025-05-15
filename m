Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B764204E;
	Thu, 15 May 2025 17:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747328721; cv=none; b=WQioUw5tL5QgQ5guDR75ysV3wI02EHxLlX7xwvnx4M3ItXq+dOaNp+2FrEUBIXh2ZtHGuYEbnpv7PafC3tJOdBv67OhTfuex7cM2jumysnnsEOaJUzqgI8oNVyotXkx9jXgQQcoqWUNSzh05i0m2L6N4WYFiKWvbTYVVowK5j6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747328721; c=relaxed/simple;
	bh=2tva5z8F4BkHvDMW0L8lVvxBVLAA8/4Ekn1G6iy/Oww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IRaq7ioOKHg/gvOrkCg+PUMWhIuItuf5MHzK4Yp9xEb/14gnfhFXu24Kazm5/g1FGn5mPYPH5gVmCSQcgjnl+qzaWNTLb4iIVusiIfZPfwj+yTnpCkqtDb0KiVpUfahCH2cWUsi5yJoqVmdLB/J0kNq8SBw3Ag2XHQ4bJb+6gnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyW6RZxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyW6RZxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D67C4CEE7;
	Thu, 15 May 2025 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747328720;
	bh=2tva5z8F4BkHvDMW0L8lVvxBVLAA8/4Ekn1G6iy/Oww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fyW6RZxA6F33r8u63gWJN+rqZQigTYDjvtqV98T+Hd1yS47faeqWyZ5zShhYF8l5W
	 NpVQsttj9j40PnpBsDpbNRNr1kFXKhDg3NbZCfAx+kUV8K7Ws62abVW61xxwQEr/iY
	 P9dScSCIKRg7UTwpHRvNxiis5vism+tu9LKykzE98u8TUujr9lv6ENIDYXacqPwst2
	 6fwIt7JVIhw8B1Q1LpV/2dKnToaod0ziHCGZWFbgS+tobi/6cAB+YglSoRm7K6I9yM
	 ti30tU/dtj8mYkFWIp3T98MyxqqbINoEo/aQ+yy5tkUvS+O8Y74k7+03d6fzOAIw41
	 FSkJS4VHjfPZw==
Date: Thu, 15 May 2025 19:05:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Zaborowski <andrew.zaborowski@intel.com>, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>, balrogg@gmail.com
Subject: Re: [PATCH v2] x86/sgx: Prevent attempts to reclaim poisoned pages
Message-ID: <aCYey1W6i7i3yPLL@gmail.com>
References: <20250508230429.456271-1-andrew.zaborowski@intel.com>
 <448598e9-972f-4807-ba54-fc1f7e141b4f@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <448598e9-972f-4807-ba54-fc1f7e141b4f@intel.com>


* Dave Hansen <dave.hansen@intel.com> wrote:

> Thanks for sending this, Andrew!
> 
> I think I'll probably add a slightly shorter summary:
> 
> tl;dr: SGX page reclaim touches the page to copy its contents to
> secondary storage. SGX instructions do not gracefully handle machine
> checks. Despite this, the existing SGX code will try to reclaim pages
> that it _knows_ are poisoned. Avoid even trying to reclaim poisoned pages.
> 
> But otherwise it looks great:
> 
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

Thanks, I've applied this fix to tip:x86/sgx, with the TL;DR paragraph 
added in.

Thanks,

	Ingo
