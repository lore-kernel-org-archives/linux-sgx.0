Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CC019CC29;
	Fri, 23 May 2025 15:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748015653; cv=none; b=QPvqvVk+dBDlFfkL5n+Aw+WsmC3MHjrrIUn+FgQWr5rFVz5wHytvksW1MQ43M0iwtKs9dmFUoeS/Q90TwApSQbBezdH2oCImKqhPyz7Nkf0sbtTbHvlAh9l6gi/GQH3o1SMb8wZbsGtnX+TMQfMG5/1C7N482ZZp7DKF6VHiq9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748015653; c=relaxed/simple;
	bh=JGQoAI2vntnF5yWx6bLoRJ0QmSd2XgCAASpLNKXu90Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eiwRlf8MXWtwRnI1TLEpz2byfoJPkCJiuhT21GToUeR1U39AjZTRomdJjX5WaQchxmIfAxbV7vTuJNDLP+ioPCF+5RtHhfJqBD5+2IjuEyeyNoqU/8SWTWFjMjUiilRrgvFk4RuZ5FXpljTkhkTlOCxhqARkYZswUKTMygZMTuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BitSFQnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BitSFQnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B480DC4CEE9;
	Fri, 23 May 2025 15:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748015652;
	bh=JGQoAI2vntnF5yWx6bLoRJ0QmSd2XgCAASpLNKXu90Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BitSFQnwULTq4H94+FO6NgAN2PEVENed7c/1UGSpgdA7QWpK3W2x3clk3v6YtMYP1
	 xjGXLMhtSXrh2PA4PTUlYdxfALHCKCz1sKTrcwT4262N0QkeTKVk9PJ58aUgjRC4DZ
	 R7fw8dXrbCNK9OBfTz2Srn9kETsobqr+IysqHuq8qe/XYT1eHS989niGVNsqRAN5bt
	 xs2ZYXMHvYirpZGnfeiVLwEx+X3PIZksc9Fgqzet8GkCsDf+X+YmlK5kE3Mcct8a0s
	 zPbd7WcMbxwzC1IceKYOfP3ZXQEUb02PNyMvVVLmdjZ5kgX5trud7+mmDcqMzNj2bb
	 WoWBqS/RPJNpA==
Date: Fri, 23 May 2025 18:54:07 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, seanjc@google.com, kai.huang@intel.com,
	mingo@kernel.org, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v6 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Message-ID: <aDCaH2WAMhLhFAVE@kernel.org>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
 <20250522092237.7895-2-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522092237.7895-2-elena.reshetova@intel.com>

On Thu, May 22, 2025 at 12:21:34PM +0300, Elena Reshetova wrote:
> Currently SGX does not have a global counter to count the
> active users from userspace or hypervisor. Implement such a counter,
> sgx_usage_count. It will be used by the driver when attempting
> to call EUPDATESVN SGX instruction.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver.c | 22 ++++++++++++++++------
>  arch/x86/kernel/cpu/sgx/encl.c   |  1 +
>  arch/x86/kernel/cpu/sgx/main.c   | 14 ++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h    |  3 +++
>  arch/x86/kernel/cpu/sgx/virt.c   | 16 ++++++++++++++--
>  5 files changed, 48 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index 7f8d1e11dbee..a2994a74bdff 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -19,9 +19,15 @@ static int sgx_open(struct inode *inode, struct file *file)
>  	struct sgx_encl *encl;
>  	int ret;
>  
> +	ret = sgx_inc_usage_count();
> +	if (ret)
> +		return ret;
> +
>  	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
> -	if (!encl)
> -		return -ENOMEM;
> +	if (!encl) {
> +		ret = -ENOMEM;
> +		goto err_usage_count;
> +	}
>  
>  	kref_init(&encl->refcount);
>  	xa_init(&encl->page_array);
> @@ -31,14 +37,18 @@ static int sgx_open(struct inode *inode, struct file *file)
>  	spin_lock_init(&encl->mm_lock);
>  
>  	ret = init_srcu_struct(&encl->srcu);
> -	if (ret) {
> -		kfree(encl);
> -		return ret;
> -	}
> +	if (ret)
> +		goto err_encl;
>  
>  	file->private_data = encl;
>  
>  	return 0;
> +
> +err_encl:
> +	kfree(encl);
> +err_usage_count:
> +	sgx_dec_usage_count();
> +	return ret;
>  }
>  
>  static int sgx_release(struct inode *inode, struct file *file)
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 279148e72459..3b54889ae4a4 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -765,6 +765,7 @@ void sgx_encl_release(struct kref *ref)
>  	WARN_ON_ONCE(encl->secs.epc_page);
>  
>  	kfree(encl);
> +	sgx_dec_usage_count();
>  }
>  
>  /*
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 2de01b379aa3..a018b01b8736 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -917,6 +917,20 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
>  }
>  EXPORT_SYMBOL_GPL(sgx_set_attribute);
>  
> +/* Counter to count the active SGX users */
> +static atomic64_t sgx_usage_count;
> +
> +int sgx_inc_usage_count(void)
> +{
> +	atomic64_inc(&sgx_usage_count);
> +	return 0;
> +}

Maybe this was discussed but why this is not just a void-function?

> +
> +void sgx_dec_usage_count(void)
> +{
> +	atomic64_dec(&sgx_usage_count);
> +}

I think these both should be static inlines in arch/x86/kernel/cpu/sgx.h.
Global symbols is over the top. Even if I think disassembly (when doing
debugging, bug hunting or similar tasks), it'd nicer that way.

> +
>  static int __init sgx_init(void)
>  {
>  	int ret;
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index d2dad21259a8..f5940393d9bd 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -102,6 +102,9 @@ static inline int __init sgx_vepc_init(void)
>  }
>  #endif
>  
> +int sgx_inc_usage_count(void);
> +void sgx_dec_usage_count(void);
> +
>  void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
>  
>  #endif /* _X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index 7aaa3652e31d..6ce908ed51c9 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -255,22 +255,34 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
>  	xa_destroy(&vepc->page_array);
>  	kfree(vepc);
>  
> +	sgx_dec_usage_count();
>  	return 0;
>  }
>  
>  static int sgx_vepc_open(struct inode *inode, struct file *file)
>  {
>  	struct sgx_vepc *vepc;
> +	int ret;
> +
> +	ret = sgx_inc_usage_count();
> +	if (ret)
> +		return ret;
>  
>  	vepc = kzalloc(sizeof(struct sgx_vepc), GFP_KERNEL);
> -	if (!vepc)
> -		return -ENOMEM;
> +	if (!vepc) {
> +		ret = -ENOMEM;
> +		goto err_usage_count;
> +	}
>  	mutex_init(&vepc->lock);
>  	xa_init(&vepc->page_array);
>  
>  	file->private_data = vepc;
>  
>  	return 0;
> +
> +err_usage_count:
> +	sgx_dec_usage_count();
> +	return ret;

Right, mirrors here my earlier suggestion for rollback, great (two
iterations ago)!

>  }
>  
>  static long sgx_vepc_ioctl(struct file *file,
> -- 
> 2.45.2
> 
> 

BR, Jrakko
