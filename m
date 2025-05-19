Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B47244699;
	Mon, 19 May 2025 17:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747675317; cv=none; b=GyOw9p/Xdtc3TncwrS/5NLPNtTjTdZlMWQE3w1kE+mPzB6foOA4/Ly6a11C8k9ELa2dNn5pJSgA+Zk0BbXaBR3Ma1NCF5/UK8cqH2mxQqZJAAy4LQlm/qmbq8VYeT3zMnZuTGZRX2gJOjSr6xm/rj8xtyuMrelOOaJdR6qixJ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747675317; c=relaxed/simple;
	bh=3Kfs+8UoIc+Nl4DLIGOmtcSxf3HMGxNNUKXjDdKqLak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KJrxIWYosLmfGfs+Udf1TVeVKQXO+Cdghyu2b3pQ8uQXKp7U9B8WwmKk6/1OdyOdKTSghz8uH7k2DdCnWwDRXGZWwaiDENBED1M0csbztVkYtbpWpXxigKYerXt/VwDvNvzHQzXOwPZ+Y3dEe3gr8nXI6JKLy02jIUS/oDN0SEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sLoJZ6oe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sLoJZ6oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945B2C4CEE9;
	Mon, 19 May 2025 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747675317;
	bh=3Kfs+8UoIc+Nl4DLIGOmtcSxf3HMGxNNUKXjDdKqLak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sLoJZ6oeZHx9FTtWRVsQPjvf/L4cRmjeJ2pmqJfuE47U5peYGpc67FKYy8Yu76veQ
	 mdBMVlXHnTsrOIzYROdBeeuD2+uUyE4MRLmGDB2MkxkCNjtsHcfJqo3p/liMx0iJuC
	 QcKGrCU2JnXQwIQ21WUykSI9LWFjIJ10SlpsPLTI26bdygGh15Lh0TlHSY7MFWFsNi
	 /FEgRXfpN8W7BXUrzyquHdomQJiwT/uXWn98gtjgwdSN4MupPJZuS2D4pViZpeUKk+
	 GhbEcvYZHvdS3HE+5DTRLtUJkHqgyojGcZykjV0qJVpACwMoOXPhnh3Hfm+WSUHOZf
	 Ug6hblIsscA2g==
Date: Mon, 19 May 2025 20:21:51 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, seanjc@google.com, kai.huang@intel.com,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, asit.k.mallick@intel.com,
	vincent.r.scarlata@intel.com, chongc@google.com,
	erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Message-ID: <aCtor7AxyLAk3rlB@kernel.org>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-2-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519072603.328429-2-elena.reshetova@intel.com>

On Mon, May 19, 2025 at 10:24:27AM +0300, Elena Reshetova wrote:
> Currently SGX does not have a global counter to count the
> active users from userspace or hypervisor. Implement such a counter,
> sgx_usage_count. It will be used by the driver when attempting
> to call EUPDATESVN SGX instruction.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver.c |  1 +
>  arch/x86/kernel/cpu/sgx/encl.c   |  1 +
>  arch/x86/kernel/cpu/sgx/main.c   | 14 ++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h    |  3 +++
>  arch/x86/kernel/cpu/sgx/virt.c   |  2 ++
>  5 files changed, 21 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index 7f8d1e11dbee..b5ffe104af4c 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -19,6 +19,7 @@ static int sgx_open(struct inode *inode, struct file *file)
>  	struct sgx_encl *encl;
>  	int ret;
>  
> +	sgx_inc_usage_count();
>  	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
>  	if (!encl)
>  		return -ENOMEM;
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
> index 8ce352fc72ac..80d565e6f2ad 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -914,6 +914,20 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
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
> +
> +void sgx_dec_usage_count(void)
> +{
> +	atomic64_dec(&sgx_usage_count);
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
> index 7aaa3652e31d..83de0907f32c 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -255,6 +255,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
>  	xa_destroy(&vepc->page_array);
>  	kfree(vepc);
>  
> +	sgx_dec_usage_count();
>  	return 0;
>  }
>  
> @@ -262,6 +263,7 @@ static int sgx_vepc_open(struct inode *inode, struct file *file)
>  {
>  	struct sgx_vepc *vepc;
>  
> +	sgx_inc_usage_count();
>  	vepc = kzalloc(sizeof(struct sgx_vepc), GFP_KERNEL);
>  	if (!vepc)
>  		return -ENOMEM;
> -- 
> 2.45.2
> 

Maybe just use raw atomic_inc() and atomic_dec() at the sites?

IMHO, it makes only sense to wrap, when it makes sense to wrap.

BR, Jarkko
