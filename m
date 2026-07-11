Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E57255E43;
	Sat, 11 Jul 2026 18:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783794148; cv=none; b=mnIT8ovxoxtOPPYd4hjcbtwxQXLMg6RwlNCeILy243BVspczAFD9/nPDoKnTxBYA60KkX8hW6rgX9eXsHVIAD5b/dkuAuzgbPyeqVLV54nnxgVpOA07q3BHjxVLycIXk9b8T5REHuAyAG598OGRoAcsR5RXyzN1Q9yTvYfRz57k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783794148; c=relaxed/simple;
	bh=6tFzAgS+T6a67yHAS4xOiaUu7QAvIH11jVM6OnhVCWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZIB+7iPqGncYqkfJ4Ka+ANs8okoWwuqxqFVpOh5d7diC2GbfgOVP0RjR3hE8k+u/mn8CcdzjkA3cEIEmgIXWBBIGN/GW5l6xz84/9LBgfk3kMejk6Kct0RB1mBk/JdBKYczuSUpVv7n/Ber9VsavF7rN1YUPsL0QCr0NliyYW4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S7jfsel0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S7jfsel0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 881BA1F000E9;
	Sat, 11 Jul 2026 18:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783794147;
	bh=VFniH+NmxNTztcqZrB0te7a9zqV98HwEtOnBexz8e5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S7jfsel0nMy6/hQ0FVPnWeRr1pf99Mb9yhqoObFFp0gp5bXfN0TJvNc+W8ZjDsdxG
	 2nHBbcTegZpUwqDXKXgyTk8YoGum1pL5h4UEqSMxKecNS+NoWnCEc3BFfkIVZN3utS
	 JPtngXuSy/YUaDd3+nUP42lMgWTmxW/JlhQkTvGY+yK1WD9HSos5ajLXZuUhSscI+a
	 CdwKbkHw6i/nsdrSJPmFB6QbfL9Np/jmvVyZHlRap2fY5qQCxKECZOehFGPMQaTZhp
	 i1mO+3qgG9qDz14cfqMJ7DVgoHe1t1G3hJtbNoE83zTkRwICZui7NLwZnkeZk768+F
	 ctYgwV3ZDgTqQ==
Date: Sat, 11 Jul 2026 21:22:23 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/sgx: Remove unused size and count definitions
Message-ID: <alKJ37nRNvWw4LKS@kernel.org>
References: <20260711100053.739588-5-thorsten.blum@linux.dev>
 <20260711100053.739588-7-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711100053.739588-7-thorsten.blum@linux.dev>

On Sat, Jul 11, 2026 at 12:00:56PM +0200, Thorsten Blum wrote:
> The definitions were added with commit 70d3b8ddcd20 ("x86/sgx: Add SGX
> architectural data structures"), but have never been used. The SIGSTRUCT
> reserved field sizes are also redundant because the structure uses
> literal sizes instead. Remove them.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  arch/x86/include/asm/sgx.h | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index fe106c55a593..af5cd6ce9010 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -108,9 +108,6 @@ enum sgx_miscselect {
>  
>  #define SGX_MISC_RESERVED_MASK	GENMASK_ULL(63, 1)
>  
> -#define SGX_SSA_GPRS_SIZE		184
> -#define SGX_SSA_MISC_EXINFO_SIZE	16
> -
>  /**
>   * enum sgx_attribute - the attributes field in &struct sgx_secs
>   * @SGX_ATTR_INIT:		Enclave can be entered (is initialized).
> @@ -227,7 +224,6 @@ enum sgx_page_type {
>  	SGX_PAGE_TYPE_TRIM,
>  };
>  
> -#define SGX_NR_PAGE_TYPES	5
>  #define SGX_PAGE_TYPE_MASK	GENMASK(7, 0)
>  
>  /**
> @@ -288,11 +284,6 @@ struct sgx_pcmd {
>  	u8  mac[16];
>  } __packed __aligned(128);
>  
> -#define SGX_SIGSTRUCT_RESERVED1_SIZE 84
> -#define SGX_SIGSTRUCT_RESERVED2_SIZE 20
> -#define SGX_SIGSTRUCT_RESERVED3_SIZE 32
> -#define SGX_SIGSTRUCT_RESERVED4_SIZE 12
> -
>  /**
>   * struct sgx_sigstruct_header -  defines author of the enclave
>   * @header1:		constant byte string


Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
