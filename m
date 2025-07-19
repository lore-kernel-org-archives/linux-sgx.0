Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767EA220F57;
	Sat, 19 Jul 2025 11:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752923721; cv=none; b=nwHGLtTdoIQL7yxTom/2udNMK9v35Q1PqL8BJSmUcyVu1vB44KsaSWLOHO9gEGSDHN7+4nsNzy3TSET21yiQmKedJ0V0JaMSAmWeEgM0e8eqksQ1MbRBNbv8DVILrZA4rMweXPK+v91SZJ6srRD2A1QMgVBikfb86YO1e9+vmWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752923721; c=relaxed/simple;
	bh=a/5GSfotPGt52jAleSoNOBlZO4ibbnAdwmVwPsbffrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FC3NMyt33GH9WJRCUEagkJnaz3EP7NO6Q/BxuDq6MF4sQTKRxZgz2cmEX2zucTONSv27x29Cfk6qYqvPoFSn3SMEjOswtJGUTgrxeGwyGsvNBN1VmCJtN/L5W79eCOf0fJmPVHDGVRlug++R5FHlupyhvcoUuTNHiRrVY53MCg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pEiN5d85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pEiN5d85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68237C4CEE7;
	Sat, 19 Jul 2025 11:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752923720;
	bh=a/5GSfotPGt52jAleSoNOBlZO4ibbnAdwmVwPsbffrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pEiN5d85KISAJVp5B9BHI2WEiSr7KYR0iJkBXOUDOEPN3BrUP+EyxsarSSK34LL7o
	 pWGqFZdUzZihVi1GpHdke83Tlh+mbkhgXDpVx/ncSETUlp9Ma9cZNZJWSUzxetkuhg
	 aPuUUjtbDG8i0crPw2Ugm/ZtclgBfCXAb0E/AEGZwIqDcuEYGos4Q3/MGbwbzw8Qsc
	 L5/0lJJG6EPaUJvzKHtYvfdCLyiluOiXQrfUTkHL7UsZ4mzecfxJLQ4AObgD60byq+
	 OK1eDRsiV0c5+Tne3sC+72gDNQmkSdhJbVqpSI/cCaWHOF9Q7diXaW7wiOSTBnqdWe
	 wfiE8ULB0aRiA==
Date: Sat, 19 Jul 2025 14:15:16 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, seanjc@google.com, kai.huang@intel.com,
	mingo@kernel.org, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v8 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Message-ID: <aHt-RLfgVM-HfTh_@kernel.org>
References: <20250715124109.1711717-1-elena.reshetova@intel.com>
 <20250715124109.1711717-2-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715124109.1711717-2-elena.reshetova@intel.com>

On Tue, Jul 15, 2025 at 03:40:18PM +0300, Elena Reshetova wrote:
> Currently SGX does not have a global counter to count the
> active users from userspace or hypervisor. Implement such a counter,
> sgx_usage_count. It will be used by the driver when attempting
> to call EUPDATESVN SGX instruction.
> 
> Note: the sgx_inc_usage_count prototype is defined to return
> int for the cleanliness of the follow-up patches. When the
> EUPDATESVN SGX instruction will be enabled in the follow-up patch,
> the sgx_inc_usage_count will start to return int.
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
> index 2de01b379aa3..0e75090f93c9 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -917,6 +917,20 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
>  }
>  EXPORT_SYMBOL_GPL(sgx_set_attribute);
>  
> +/* Counter to count the active SGX users */
> +static int sgx_usage_count;
> +
> +int sgx_inc_usage_count(void)
> +{
> +	sgx_usage_count++;
> +	return 0;
> +}
> +
> +void sgx_dec_usage_count(void)
> +{
> +	sgx_usage_count--;
> +}
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
>  }

This is essentially a wrapper over pre-existing function. I vote for
renaming the pre-existing function as __sgx_vepc_open() and add then a
new function calling it:

static int sgx_vepc_open(struct inode *inode, struct file *file)
{
	int ret;

	ret = sgx_inc_usage_count();
	if (ret)
		return ret;

	ret =  __sgx_vepc_open(inode, file);
	if (ret) {
		sgx_dec_usage_count();
		return ret;
	}

	return 0;		
}

I think this a factor better standing point also when having to dig
into this later on (easier to see the big picture) as it has clear
split of responsibilities:

1. top layer manages to usage count
2. lower layer allocates vepc structures (which has nothing to do
   with the logic of the usage count).

This comment applies also to sgx_open().

>  
>  static long sgx_vepc_ioctl(struct file *file,
> -- 
> 2.45.2
> 

BR, Jarkko
