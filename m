Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2507E27E056;
	Wed, 19 Nov 2025 02:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763519322; cv=none; b=biVXhKqIpkrtAiw6sqMZ20snQNyceC1UnFrxoWhtKa0KgQHmuPj6du3gqigcISuu5BvVfnPaJCDVIpHL81vDhjzfDBXkxNSjVuwJPidAS86NXf3GKwrKTJdNXSi3cbVrIjaw9sCS5FcWewcbrXF7yRuLvrAQgbyEomcx6cGPHVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763519322; c=relaxed/simple;
	bh=4XcbnNpKgBtT/X5Jj3YwcA6EdHzL9NtYnRjVTjsbPTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o5hKeb0TignDRANmm0Q8pLRCec7hKAWF+FhDiCymhnGI2odFBJXgnvP2BlxPt2NBh04iAm7jrQbG3JEDoqIEf5+jkX/6nTA3W13ws3ge8AwNRG6X644nmG8zYAJu0AjCa7z2vZV9ic1PIH/tFUnZs8BOzDH8lMCiabbT/WsZh/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEWoEV4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEWoEV4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A46EC19421;
	Wed, 19 Nov 2025 02:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763519321;
	bh=4XcbnNpKgBtT/X5Jj3YwcA6EdHzL9NtYnRjVTjsbPTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eEWoEV4VGat4JpvAs73CBacG8U45BKI4dgsCaRudiS140pnbz8vrr2DfUluDSCxwA
	 7UIkOvUs15vSBZ2IAZgw9oh6vdJmcXv/HJR65SRugQfeUs/pUGEkM9im3Bix+SCz/K
	 mzMUSbCGnqIC3Q0DHT2qB2U3IY5lh1+CtxO8s+PS/QrOdpyPw4TkEZSGI/RGBkKZmI
	 OTMpK+2Bz1YXNYwxwNmxKDuAfm4eThXH4OJ4t+HYmBHPL5XpF3P9PJzXO6slz7d3fS
	 v3Oum37PsHsiLGacXRjhv3kQ1NmN1PWENponV//DjL8CMbW8HrI0wwhkaMFm9JT7gr
	 FTzDqpcA9NQ+A==
Date: Wed, 19 Nov 2025 04:28:35 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 4/5] x86/sgx: Remove superfluous asterisk from copyright
 comment in asm/sgx.h
Message-ID: <aR0rU2QtecLes07w@kernel.org>
References: <20251112160708.1343355-1-seanjc@google.com>
 <20251112160708.1343355-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112160708.1343355-5-seanjc@google.com>

On Wed, Nov 12, 2025 at 08:07:07AM -0800, Sean Christopherson wrote:
> Drop an asterisk from a file-level copyright comment so that the comment
> isn't intrepeted as a kernel-doc comment.
> 
> E.g. if arch/x86/include/asm/sgx.h is fed into kernel-doc processing:
> 
>   WARNING: ./arch/x86/include/asm/sgx.h:2 This comment starts with '/**',
>   but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/sgx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index a88c4ab95edd..3c90cae04e1d 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -1,5 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -/**
> +/*
>   * Copyright(c) 2016-20 Intel Corporation.
>   *
>   * Intel Software Guard Extensions (SGX) support.
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
