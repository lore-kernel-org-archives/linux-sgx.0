Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8589D295526;
	Fri, 23 May 2025 15:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748015770; cv=none; b=N5trEj5zurzs96PRTZHVKzE1y80mx+ZsLa/BrDgr+S2Eg3FUohPEs2axBxZi+tYWxVBGTjPEBxmCZG+TagRh6xFbajWeR2HsXzmVC6IfSd2emvlABFAZRrTUvdwveVdEZuqorRxUbgjsBSUVubJRSVjnPetpOYsPtQ7QGZYooCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748015770; c=relaxed/simple;
	bh=msMY44I5D2WOxn90GS5QAIas+pFq1JbP1cWedc0Hu9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGjhGFiyyvQLGd68TMtEmbZZGWoBXj9AllWs5Wcea9w+wnxngaMeYZT7ZWeNkPjbyG1KPx7RgGNLEO4aAlsW/d14F36wYQXqJLkcZtcIrbyGHXOw0ImAaN4TVxmMguDCWqrQe7dBSB975Y7YE6+LDUgakzeMf2pjJtfD9DJM/xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Su9E6vCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Su9E6vCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77087C4CEE9;
	Fri, 23 May 2025 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748015770;
	bh=msMY44I5D2WOxn90GS5QAIas+pFq1JbP1cWedc0Hu9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Su9E6vCMgrwa4hxGHNupMUsl2A5/FezmCf9fVdfQf4omOsgGLEL7dVm8dvC3zxP0k
	 E2GZ0lqDnR1TLRCoAV15Df5Vob/KBEOoyIKYRmG7YXzrYr1VBPOGCcoiQpODBawSkM
	 kmNKmf+ehm1D6dmtYwgbKqayvf+A7lG7yyP5bbWYdfOiCC1ABP58WMO3T6A9DGJZHN
	 Tlhy6jWxXpw+pwTIfJc5dVMtMS04hfreys4S2apClHNleB4h25h7kJF8KenqLVcdo7
	 MyW5Vsf9AZ1IjJWTHRffQK3a3Y3hRNi9p45+Yo4KR4+f6ZY6n8rZKykzStfpSZFLvt
	 WNLcHfvsXdA5A==
Date: Fri, 23 May 2025 18:56:05 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, seanjc@google.com, kai.huang@intel.com,
	mingo@kernel.org, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v6 3/5] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
Message-ID: <aDCalY6qL0lhBiwo@kernel.org>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
 <20250522092237.7895-4-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522092237.7895-4-elena.reshetova@intel.com>

On Thu, May 22, 2025 at 12:21:36PM +0300, Elena Reshetova wrote:
> Add error codes for ENCLS[EUPDATESVN], then SGX CPUSVN update
> process can know the execution state of EUPDATESVN and notify
> userspace.
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/x86/include/asm/sgx.h | 37 ++++++++++++++++++++++---------------
>  1 file changed, 22 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 6a0069761508..1abf1461fab6 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -28,21 +28,22 @@
>  #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
>  
>  enum sgx_encls_function {
> -	ECREATE	= 0x00,
> -	EADD	= 0x01,
> -	EINIT	= 0x02,
> -	EREMOVE	= 0x03,
> -	EDGBRD	= 0x04,
> -	EDGBWR	= 0x05,
> -	EEXTEND	= 0x06,
> -	ELDU	= 0x08,
> -	EBLOCK	= 0x09,
> -	EPA	= 0x0A,
> -	EWB	= 0x0B,
> -	ETRACK	= 0x0C,
> -	EAUG	= 0x0D,
> -	EMODPR	= 0x0E,
> -	EMODT	= 0x0F,
> +	ECREATE		= 0x00,
> +	EADD		= 0x01,
> +	EINIT		= 0x02,
> +	EREMOVE		= 0x03,
> +	EDGBRD		= 0x04,
> +	EDGBWR		= 0x05,
> +	EEXTEND		= 0x06,
> +	ELDU		= 0x08,
> +	EBLOCK		= 0x09,
> +	EPA		= 0x0A,
> +	EWB		= 0x0B,
> +	ETRACK		= 0x0C,
> +	EAUG		= 0x0D,
> +	EMODPR		= 0x0E,
> +	EMODT		= 0x0F,
> +	EUPDATESVN	= 0x18,
>  };
>  
>  /**
> @@ -73,6 +74,10 @@ enum sgx_encls_function {
>   *				public key does not match IA32_SGXLEPUBKEYHASH.
>   * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
>   *				is in the PENDING or MODIFIED state.
> + * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
> + * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
> + *				updated because current SVN was not newer than
> + *				CPUSVN.
>   * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
>   */
>  enum sgx_return_code {
> @@ -81,6 +86,8 @@ enum sgx_return_code {
>  	SGX_CHILD_PRESENT		= 13,
>  	SGX_INVALID_EINITTOKEN		= 16,
>  	SGX_PAGE_NOT_MODIFIABLE		= 20,
> +	SGX_INSUFFICIENT_ENTROPY	= 29,
> +	SGX_NO_UPDATE				= 31,
>  	SGX_UNMASKED_EVENT		= 128,
>  };
>  
> -- 
> 2.45.2
> 

Saving reviewed-by up until head of the series looks good to me but
in principle this is as good as it can get ;-)

BR, Jarkko
