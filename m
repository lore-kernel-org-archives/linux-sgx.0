Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778D0329F1B;
	Wed, 10 Sep 2025 17:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757524368; cv=none; b=lW6H34gr9FqGSvkkt5zHTLzCHRHLOMLQ88GwevAjbW5UZt3yzYoVDPKd7uSBMpX75mKbL9I6IH6MiJSMOcSc7p3iarbyBRQgYftj2oeCdPw/aJUc/8KFj01p7CT0Wm4riLciAelBSVFapPCdv1AhDpvz+AoRLSY16f1NvsDratQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757524368; c=relaxed/simple;
	bh=O1xBmujHe+zclGHff4jsAavjp8DRvHEtrb9dfd4byaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fL6ZLB9TUe51EVoeL7eXJhV0RPAqAKIJcQhhMgC3Ltqu7V9z2z1UZbmj54uXvvbk615TXip27PzgcrXl0WzALUBPQQzn9RAKVT9DCOTy9zXN/NfPrnVadyQPYuC7/UreXpNJaHSxUO0S0sJ6hOWkQCxgS1aLX0lSXSzXNayePqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k2mN0BFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k2mN0BFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3305C4CEEB;
	Wed, 10 Sep 2025 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757524368;
	bh=O1xBmujHe+zclGHff4jsAavjp8DRvHEtrb9dfd4byaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k2mN0BFx21o+JiImj6Ta8/92oaqDmsjxHyxm5zlYPivZEPAw4i0dFzhJ2SlBkNLOL
	 bWY6tU9WDAyAlTs4YJFigLoTaLzZv61I9DLl0aYqR06Qz2M88j/ziR9g19VIXRPCn+
	 eJAeBa0LzOW39ANEM+IF3vYKkrNXG6GoXNLVtLpbWpgr/BBCVot+E723oXLQToYoju
	 z8sJIOFkA+9AtvbMtjcVDY38hFrzJ86wQ2f94S43wKQVxvjd51d6q2JsWhbNXhNZeg
	 Kb1mVjAAUCxxYzQkI1rWVa1iWyVI5vtE51WybxUKwHip7NWW0rPvcYwPaqGEyKXmB0
	 EonB/VxVp5czg==
Date: Wed, 10 Sep 2025 20:12:44 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Replace kmalloc() + copy_from_user() with
 memdup_user()
Message-ID: <aMGxjHIfPU9cbGq1@kernel.org>
References: <20250908201229.440105-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908201229.440105-2-thorsten.blum@linux.dev>

On Mon, Sep 08, 2025 at 10:12:29PM +0200, Thorsten Blum wrote:
> Replace kmalloc() followed by copy_from_user() with memdup_user() to
> improve and simplify sgx_ioc_enclave_create().
> 
> No functional changes intended.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 66f1efa16fbb..e99fc38f1273 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -164,15 +164,11 @@ static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
>  	if (copy_from_user(&create_arg, arg, sizeof(create_arg)))
>  		return -EFAULT;
>  
> -	secs = kmalloc(PAGE_SIZE, GFP_KERNEL);
> -	if (!secs)
> -		return -ENOMEM;
> -
> -	if (copy_from_user(secs, (void __user *)create_arg.src, PAGE_SIZE))
> -		ret = -EFAULT;
> -	else
> -		ret = sgx_encl_create(encl, secs);
> +	secs = memdup_user((void __user *)create_arg.src, PAGE_SIZE);
> +	if (IS_ERR(secs))
> +		return PTR_ERR(secs);
>  
> +	ret = sgx_encl_create(encl, secs);
>  	kfree(secs);
>  	return ret;
>  }
> -- 
> 2.51.0
> 
> 

Agreed:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
