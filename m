Received: from mta1.migadu.com (out-99.mta1.migadu.com [95.215.58.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6010B2DA768
	for <linux-sgx@vger.kernel.org>; Mon, 31 Aug 2026 08:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788163631; cv=none; b=I7hpE6udZFcVhZvK1O3fkSqrVmSjxZ9/SMJf1W0vXKY/mNdpPtEncOnuswl8EqgH45azzowkN+iDov4pc+ncuX0TsVmjvuoSnDWO6RjlbeX9oR5YH3nSxQKjauxCZ0Y25uX6L4joWkX/ws0RwnJKJxYNh0GtdQNz1KwRFs9DfNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788163631; c=relaxed/simple;
	bh=Wic0KAfOyvn7y4GYgvEPi7foTvI81JYLM8yKMUeCl5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kg5fgxYFOuwJzaiMfXyf1cHwsfXVTZ0k+/SJ6j9rV/24ASMVsY0IFW6xLhlEmdfXagjBCuOMPBMH4clfV91w4gp2UoHhsp5PbnLkEh8CXkh2PRM6tsPkxjHinNDtIiRHbkU6/yWJNEboH+N5/iHp246NV4ptgMHpFoXhkAPUWW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fHnJYoMH; arc=none smtp.client-ip=95.215.58.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fHnJYoMH"
X-Envelope-To: linux-sgx@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Wic0KAfOyvn7y4GYgvEPi7foTvI81JYLM8yKMUeCl5I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788163624; v=1; x=1788768424;
 b=fHnJYoMHVwIBZIzUqMZXmzmFTug9vwClg/wMWCOu8Pz4/600GinIcsbYMtqSmTXlsxg9O4UL
 qkVUP+w9RAax7t4TNdqnspa+O2myJH5qvrd8XC5pp3y0LMmHD+qfwzjGCOKYvi2chkkP+y4nD0g
 V/3n3yjIOnzwu1dr3+f8u3Tg=
X-Envelope-To: linux-sgx@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 1298822926d88f9b;
	Mon, 31 Aug 2026 08:07:04 +0000
X-Mizu-Trace-ID: 1298822926d88f9b
X-Migadu-Flow: FLOW_OUT
Date: Mon, 31 Aug 2026 10:07:02 +0200
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] x86/sgx: Remove unused definitions and reuse
 launch token size
Message-ID: <apU2JrX7Dl5VrvxV@linux.dev>
References: <20260729125624.514697-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729125624.514697-5-thorsten.blum@linux.dev>

On Wed, Jul 29, 2026 at 02:56:25PM +0200, Thorsten Blum wrote:
> Remove SGX definitions that have never had in-tree users and reuse
> SGX_LAUNCH_TOKEN_SIZE when validating the launch token in
> __sgx_virt_einit().
> 
> Changes in v2:
> - Adjust commit message 3/3 as suggested by Kai
> - v1: https://lore.kernel.org/r/20260711100053.739588-5-thorsten.blum@linux.dev/
> 
> Thorsten Blum (3):
>   x86/sgx: Remove unused TCS definitions
>   x86/sgx: Remove unused size and count definitions
>   x86/sgx: Use SGX_LAUNCH_TOKEN_SIZE in __sgx_virt_einit()
> 
>  arch/x86/include/asm/sgx.h     | 59 ----------------------------------
>  arch/x86/kernel/cpu/sgx/virt.c |  3 +-
>  2 files changed, 1 insertion(+), 61 deletions(-)
> 
> 
> base-commit: 2d3090a8aeb596a26935db0955d46c9a5db5c6ce

Gentle ping - all 3 patches have had Reviewed-by: and/or Acked-by: tags
since mid-July. Is there anything missing or can these be applied?

Thanks,
Thorsten
