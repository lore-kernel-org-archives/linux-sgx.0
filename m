Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999C01DE4CD;
	Sat, 22 Mar 2025 21:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742680081; cv=none; b=p41zgL07dYbebkWeHkdtcL5lV+Zf12IlOyPHoHwW7j2gIPQAqCaN9cwIKBdNi56rtbt58OCL2Z6dHHDSZHia7LM2rY309VweCVAeZxP0yap8p/uprrMxK9hGysHrommiI7GUeUZUicyMMbENcodIsi2B/DLmnplrYNoWrvICtVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742680081; c=relaxed/simple;
	bh=2+Rf8HE66ZTrNURy2GgAFk3clmWMw4DKih/8LHjHYvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqvekqoQib+C/VdbKyQsHHD+CXZcAIJRC9yq1WlPxr5dNgECBKgRJKyOvmv8ph3xbl1qdOc5fQuJqWJrKUKVdryAYL4AkIWZsrp+tV2CCMqS3F4D0NyULBPqjvjMcVQ2aLmIwScBbPnaM0jAC+YdrfquJRiX2UsZ2M5pzsTiZ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBQUr0iU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBQUr0iU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0EAC4CEDD;
	Sat, 22 Mar 2025 21:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742680081;
	bh=2+Rf8HE66ZTrNURy2GgAFk3clmWMw4DKih/8LHjHYvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UBQUr0iUNr1RO0cdoltKqrqeW7yFSh3Z1INlI82PJKdGu14oZLQkt8eyMk9VRDav/
	 iqJi2fTRlw8ksXV0MyjmQa8X8gX9bbUlmMP4zK8FucPfZnD4Ah/6o59oSXSkYSAkw/
	 FHWqGhmGg82vwwOaQ+I82yPJujwOyG0UQQZSXo0Hsx49cGjhb9szoHjm1cn6RS+/U/
	 Ygn6dd5H3HoGOLSsDavQ7swJDkMILKWTtxA85EjENp2mTn+Y7Rl/uUK9CqFxs5i+di
	 MVd3C/MwWc794zhhO7Woo2Ot5aKyB01uF3VtdVJgK+uUOzQp3xuSIco1V+8bUzeqKZ
	 DfpeZ5UhTmXCQ==
Date: Sat, 22 Mar 2025 23:47:57 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com,
	Cathy Zhang <cathy.zhang@intel.com>
Subject: Re: [PATCH 3/4] x86/sgx: Define error codes for ENCLS[EUPDATESVN]
Message-ID: <Z98wDd_eMCFE40Z7@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-4-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321123938.802763-4-elena.reshetova@intel.com>

On Fri, Mar 21, 2025 at 02:34:42PM +0200, Elena Reshetova wrote:
> Add error codes for ENCLS[EUPDATESVN], then SGX CPUSVN update
> process can know the execution state of EUPDATESVN.
> 

Enumerate the error codes. Do we need all of the three added?

> Code is from previous submission in https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/T/#m1becf67078dc8c59d454e2e6c6d67ca64db341a4
"Link: https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/T/#m1becf67078dc8c59d454e2e6c6d67ca64db341a4"

> 
> Co-developed-by: Cathy Zhang <cathy.zhang@intel.com>
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>

> Co-developed-by: Elena Reshetova <elena.reshetova@intel.com>
Should be removed:
https://docs.kernel.org/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by

> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/x86/include/asm/sgx.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 6a0069761508..8ba39bbf4e91 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -73,6 +73,11 @@ enum sgx_encls_function {
>   *				public key does not match IA32_SGXLEPUBKEYHASH.
>   * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
>   *				is in the PENDING or MODIFIED state.
> + * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
> + * %SGX_EPC_NOT_READY:		EPC is not ready for SVN update.
> + * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
> + *				updated because current SVN was not newer than
> + *				CPUSVN.
>   * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
>   */
>  enum sgx_return_code {
> @@ -81,6 +86,9 @@ enum sgx_return_code {
>  	SGX_CHILD_PRESENT		= 13,
>  	SGX_INVALID_EINITTOKEN		= 16,
>  	SGX_PAGE_NOT_MODIFIABLE		= 20,
> +	SGX_INSUFFICIENT_ENTROPY	= 29,
> +	SGX_EPC_NOT_READY		= 30,
>  +	SGX_NO_UPDATE			= 31,



>  	SGX_UNMASKED_EVENT		= 128,
>  };
>  
> -- 
> 2.45.2
> 
> 

BR, Jarkko
