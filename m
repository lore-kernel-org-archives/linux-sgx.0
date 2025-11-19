Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917D827FB0E;
	Wed, 19 Nov 2025 02:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763519349; cv=none; b=p2xcpvY6GUA0pJ2YLt2uMMoHKFvol1U6keCuvhAq8FlvVgcBFQrKuPLYfUeoejJkq/6THq6l5xF18m9sOU45PB7toCGunFLu3nvniYFnrYBVMc8S9NJMruwoPvhRi/7p8Rqj9X2PRLbD4ZNrDLqd6ZQQZFVA9p8X+WFtx+y91Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763519349; c=relaxed/simple;
	bh=CosOw8P6OaaAcl1QWpwf5wmIFddta1H+5flgIOETLxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L60+SJHU0mVnayG9LaBmR0jkRAkLTYMRsn3rprDfVj8LFWdoJvadoeCFCyG9OwVtz49KvyTWYZSThHn522L2RDP8oGqKv5ugqm6bfygYX7CqJge65FLq1vFJgVBeOWisGPFdQetM4K8Gs4FATgyW2Frf58yQ2iyEpkn1iQC9E1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rnEDjKTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rnEDjKTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B738C19421;
	Wed, 19 Nov 2025 02:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763519343;
	bh=CosOw8P6OaaAcl1QWpwf5wmIFddta1H+5flgIOETLxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rnEDjKTOYT2bB7IEgaLXTFzZbzpB8Z2dtXy/5DcdqjjrbobPfusMRQj7cG3fy0AR7
	 2lqKFI8t+j1FtwDbJ2CjSBDZLMexOsB4vGC7cUMX+j1vTtQ8K1cHRHjMWvPBKj5UjT
	 O61zrkSxp/htAoDiEPt0BGl47D9dM8udiOYK6hI1+Otz+a3+xoNE+yjJtrnUXKop/b
	 5fQtADj2OgU6MBAPdlwMENE81oDlWYIHh6NL40P9q4svB2vr+cgKwjx/WLM1qqWuj+
	 G8/fAm+Q8DW0K+Te1H3/iH3FS3UTXcvca9Z3ibPVGNv3DJ/02/cRTcFC/jzbqjHASR
	 6cfraCgTffzDA==
Date: Wed, 19 Nov 2025 04:28:58 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 5/5] x86/sgx: Fix a typo in the kernel-doc comment for
 enum sgx_attribute
Message-ID: <aR0raibotOVv9IXd@kernel.org>
References: <20251112160708.1343355-1-seanjc@google.com>
 <20251112160708.1343355-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112160708.1343355-6-seanjc@google.com>

On Wed, Nov 12, 2025 at 08:07:08AM -0800, Sean Christopherson wrote:
> Use the exact enum name when documenting "enum sgx_attribute" to fix a
> warning if the file is fed into kernel-doc processing:
> 
>   WARNING: ./arch/x86/include/asm/sgx.h:139 expecting prototype for enum
>            sgx_attributes. Prototype was for enum sgx_attribute instead
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/sgx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 3c90cae04e1d..04958459a7ca 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -112,7 +112,7 @@ enum sgx_miscselect {
>  #define SGX_SSA_MISC_EXINFO_SIZE	16
>  
>  /**
> - * enum sgx_attributes - the attributes field in &struct sgx_secs
> + * enum sgx_attribute - the attributes field in &struct sgx_secs
>   * @SGX_ATTR_INIT:		Enclave can be entered (is initialized).
>   * @SGX_ATTR_DEBUG:		Allow ENCLS(EDBGRD) and ENCLS(EDBGWR).
>   * @SGX_ATTR_MODE64BIT:		Tell that this a 64-bit enclave.
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
