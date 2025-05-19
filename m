Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27EA35957;
	Mon, 19 May 2025 07:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747640840; cv=none; b=U/LZQKTokfd9cNRhJr1119BIPdJpTL3TzhURy6kGGg1ZzY9+VJbn9sjIIu/c13ePDqpSBc+LKh2iTc7zVxaEN3t4xZp2/1EnatvoHGxCGkw6AvHtE0PJsRfJtZjMeJmaZwSI9TTreRaIGrrpMctqlovT4a3ck0YzyuHpMutCMQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747640840; c=relaxed/simple;
	bh=HcDL9SUROZxqK+izL4y3hh8ouuALvs5P4FFrJ5K4Jo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LxfY6QVM+PJqu7fmOFd1OS0LEF0Pb6RCybkXMOsXyhCRWKSkuxu3yZqIkJbv8y2+rggV71cu1YMuU/FXHLJvnDBd4gpmIX+0b5i41u+Nyd1WUo8lXYKRK3nNL3CoYut+C8Cy9RvAJw0ZHAtJMwTGdQYnszQPtLMz5A1xDIRupew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AW5X6Klg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AW5X6Klg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D32DC4CEE4;
	Mon, 19 May 2025 07:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747640839;
	bh=HcDL9SUROZxqK+izL4y3hh8ouuALvs5P4FFrJ5K4Jo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AW5X6Klgf+AT7HdWV/YcQ+/sNMHaWmIbljSLJ3KRi8qrfDZvTDw7LiQIB9HJ3Hoqu
	 O0A/PbSY9M1i/GkEB4It2Ezjb9oV8Z8+c9mY3wRYp4sfH2+69zMYt7HTZR2NF8f7mG
	 XHjETJomUtHlCSZJ59XwCdCZ7s0iEMa1Bo91YlaguD7gFcbYV8mB6eB5W25vjg+8cg
	 ZdUSwRiXG/BteCVrql33klIipqIxirrp6y9Dqr11WRkEDMpxrxpvwimVlz0Y/UIUiJ
	 otzu1BzNcAqQIX22av9FJFtpv6vg3je49BIQg2xF44xk3Ud7ie4AxhMM4Ar3/rUSSb
	 2+a9XXM8K2Bhw==
Date: Mon, 19 May 2025 09:47:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, jarkko@kernel.org, seanjc@google.com,
	kai.huang@intel.com, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v5 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN
 feature flag
Message-ID: <aCriAfYTS7Xz3so9@gmail.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-3-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519072603.328429-3-elena.reshetova@intel.com>


* Elena Reshetova <elena.reshetova@intel.com> wrote:

> Add a flag indicating whenever ENCLS[EUPDATESVN] SGX instruction
> is supported. This will be used by SGX driver to perform CPU
> SVN updates.
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/x86/include/asm/cpufeatures.h       | 1 +
>  arch/x86/kernel/cpu/scattered.c          | 1 +
>  tools/arch/x86/include/asm/cpufeatures.h | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 6c2c152d8a67..ed0c0fa5822a 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -481,6 +481,7 @@
>  #define X86_FEATURE_AMD_HETEROGENEOUS_CORES (21*32 + 6) /* Heterogeneous Core Topology */
>  #define X86_FEATURE_AMD_WORKLOAD_CLASS	(21*32 + 7) /* Workload Classification */
>  #define X86_FEATURE_PREFER_YMM		(21*32 + 8) /* Avoid ZMM registers due to downclocking */
> +#define X86_FEATURE_SGX_EUPDATESVN	(21*32 + 9) /* Support for ENCLS[EUPDATESVN] instruction */

Please base the patches on the latest x86 tree, there's been two 
additions already in this area.

>  /*
>   * BUG word(s)
> diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
> index 16f3ca30626a..a7e1fcedca3c 100644
> --- a/arch/x86/kernel/cpu/scattered.c
> +++ b/arch/x86/kernel/cpu/scattered.c
> @@ -41,6 +41,7 @@ static const struct cpuid_bit cpuid_bits[] = {
>  	{ X86_FEATURE_PER_THREAD_MBA,		CPUID_ECX,  0, 0x00000010, 3 },
>  	{ X86_FEATURE_SGX1,			CPUID_EAX,  0, 0x00000012, 0 },
>  	{ X86_FEATURE_SGX2,			CPUID_EAX,  1, 0x00000012, 0 },
> +	{ X86_FEATURE_SGX_EUPDATESVN,	CPUID_EAX, 10, 0x00000012, 0 },
>  	{ X86_FEATURE_SGX_EDECCSSA,		CPUID_EAX, 11, 0x00000012, 0 },
>  	{ X86_FEATURE_HW_PSTATE,		CPUID_EDX,  7, 0x80000007, 0 },
>  	{ X86_FEATURE_CPB,			CPUID_EDX,  9, 0x80000007, 0 },

So it should be obvious at a glance that this new line doesn't follow 
the coding convention of the surrounding lines...

Thanks,

	Ingo
