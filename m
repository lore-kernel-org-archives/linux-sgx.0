Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A3E224235;
	Wed, 16 Apr 2025 19:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744830086; cv=none; b=u4JXh2/hByFLeXMbcdhtI4FDq0DxighBjwT764Hoj4gl1G/x30hNHQxN3ysAq1hApDDu+VxcO72hmc2HFWVRt+zvucnAmL/4XjKhJYdiWvdN/MS8xS+DOvPRLUIQWn0vkZZqMJMzevI5QvrxUuX0f7h6aXFGDGUyOEIOAr/OGGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744830086; c=relaxed/simple;
	bh=j1vWLvML+7njUaTTm4Y3a+tPmDI+MY+g9VZMKMkmzCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AxrajgFSI8Ui+inU4dc9+PxIz7dISyj2W5hxrJe0ENu4kYRv3YmrOBYTX5kNUkGxyFPEtNy0vtM8sKFkZSbH6A50qTbebhEqQWC0tOCQnWViFJCpFug4kfVCXdGYrAe/e7tDp/XjZS2ZDyUJObF+BVTfuJwh9R/PSkdkKYECRs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0qm5mMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0qm5mMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84992C4CEED;
	Wed, 16 Apr 2025 19:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744830085;
	bh=j1vWLvML+7njUaTTm4Y3a+tPmDI+MY+g9VZMKMkmzCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C0qm5mMd18DuTkdYwGzoiZC50HaeXszjOPQAPxMJ1GjVU+haR4JQ5CaS5F9E4bx/C
	 8XMvCjXHgSwmqD6iA6Qy827iT6ExaaINvsQ3mCmtwJTdCq+EY8dBox3oVlBTjN0qbS
	 R8Rrsz5T5bPv36MFw9QBF0QQH23r1rXHlhXWGDaImywLKFlDXpZ6Sf01I2UaTTMQf2
	 hmcsYF6F+nq4JWex6DEilJssVyTRW8hg5hQHM1sib2yMYh9uwPOKt7EKqLB10Mrn86
	 8UXiSUH6xr0enasw8w+3BL2jihG9nzTaHgswG1rF3RBbdm3iecgKHj1MRyugbCm1mK
	 jyOWF4jU7Yhbw==
Date: Wed, 16 Apr 2025 22:01:22 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Message-ID: <Z__-gs8wxmrfaNnT@kernel.org>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
 <20250415115213.291449-3-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415115213.291449-3-elena.reshetova@intel.com>

On Tue, Apr 15, 2025 at 02:51:22PM +0300, Elena Reshetova wrote:
> SGX architecture introduced a new instruction called EUPDATESVN
> to Ice Lake. It allows updating security SVN version, given that EPC
> is completely empty. The latter is required for security reasons
> in order to reason that enclave security posture is as secure as the
> security SVN version of the TCB that created it.

"Ice Lake introduced ENCLS[EUPDATESVN], which allows to to update the
microcode version for an online system" ?

Now you are saying it allows updating SVN which is null information.

> 
> Additionally it is important to ensure that while ENCLS[EUPDATESVN]
> runs, no concurrent page creation happens in EPC, because it might
> result in #GP delivered to the creator. Legacy SW might not be prepared
> to handle such unexpected #GPs and therefore this patch introduces
> a locking mechanism to ensure no concurrent EPC allocations can happen.
> 
> It is also ensured that ENCLS[EUPDATESVN] is not called when running
> in a VM since it does not have a meaning in this context (microcode
> updates application is limited to the host OS) and will create
> unnecessary load.
> 
> This patch is based on previous submision by Cathy Zhang
> https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/x86/include/asm/sgx.h      | 41 +++++++++++------
>  arch/x86/kernel/cpu/sgx/encls.h |  6 +++
>  arch/x86/kernel/cpu/sgx/main.c  | 82 ++++++++++++++++++++++++++++++++-
>  arch/x86/kernel/cpu/sgx/sgx.h   |  1 +
>  4 files changed, 114 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 6a0069761508..5caf5c31ebc6 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -26,23 +26,26 @@
>  #define SGX_CPUID_EPC_SECTION	0x1
>  /* The bitmask for the EPC section type. */
>  #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
> +/* EUPDATESVN presence indication */
> +#define SGX_CPUID_EUPDATESVN	BIT(10)
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
> @@ -73,6 +76,11 @@ enum sgx_encls_function {
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
> @@ -81,6 +89,9 @@ enum sgx_return_code {
>  	SGX_CHILD_PRESENT		= 13,
>  	SGX_INVALID_EINITTOKEN		= 16,
>  	SGX_PAGE_NOT_MODIFIABLE		= 20,
> +	SGX_INSUFFICIENT_ENTROPY	= 29,
> +	SGX_EPC_NOT_READY		= 30,
> +	SGX_NO_UPDATE			= 31,
>  	SGX_UNMASKED_EVENT		= 128,
>  };
>  
> diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
> index 99004b02e2ed..3d83c76dc91f 100644
> --- a/arch/x86/kernel/cpu/sgx/encls.h
> +++ b/arch/x86/kernel/cpu/sgx/encls.h
> @@ -233,4 +233,10 @@ static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
>  	return __encls_2(EAUG, pginfo, addr);
>  }
>  
> +/* Update CPUSVN at runtime. */
> +static inline int __eupdatesvn(void)
> +{
> +	return __encls_ret_1(EUPDATESVN, "");
> +}
> +
>  #endif /* _X86_ENCLS_H */
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index b61d3bad0446..c21f4f6226b0 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -32,6 +32,11 @@ static DEFINE_XARRAY(sgx_epc_address_space);
>  static LIST_HEAD(sgx_active_page_list);
>  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
>  
> +/* This lock is held to prevent new EPC pages from being created
> + * during the execution of ENCLS[EUPDATESVN].
> + */
> +static DEFINE_SPINLOCK(sgx_epc_eupdatesvn_lock);
> +
>  static atomic_long_t sgx_nr_used_pages = ATOMIC_LONG_INIT(0);
>  static unsigned long sgx_nr_total_pages;
>  
> @@ -444,6 +449,7 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
>  {
>  	struct sgx_numa_node *node = &sgx_numa_nodes[nid];
>  	struct sgx_epc_page *page = NULL;
> +	bool ret;
>  
>  	spin_lock(&node->lock);
>  
> @@ -452,12 +458,33 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
>  		return NULL;
>  	}
>  
> +	if (!atomic_long_inc_not_zero(&sgx_nr_used_pages)) {
> +		spin_lock(&sgx_epc_eupdatesvn_lock);
> +		/*
> +		 * Only call sgx_updatesvn() once the first enclave's
> +		 * page is allocated from EPC
> +		 */
> +		if (atomic_long_read(&sgx_nr_used_pages) == 0) {
> +			ret = sgx_updatesvn();
> +			if (!ret) {
> +				/*
> +				 * sgx_updatesvn() returned unknown error, smth
> +				 * must be broken, do not allocate a page from EPC
> +				 */
> +				spin_unlock(&sgx_epc_eupdatesvn_lock);
> +				spin_unlock(&node->lock);
> +				return NULL;
> +			}
> +		}
> +		atomic_long_inc(&sgx_nr_used_pages);
> +		spin_unlock(&sgx_epc_eupdatesvn_lock);
> +	}
> +
>  	page = list_first_entry(&node->free_page_list, struct sgx_epc_page, list);
>  	list_del_init(&page->list);
>  	page->flags = 0;
>  
>  	spin_unlock(&node->lock);
> -	atomic_long_inc(&sgx_nr_used_pages);
>  
>  	return page;
>  }
> @@ -970,3 +997,56 @@ static int __init sgx_init(void)
>  }
>  
>  device_initcall(sgx_init);
> +
> +/**
> + * sgx_updatesvn() - Issue ENCLS[EUPDATESVN]
> + * If EPC is ready, this instruction will update CPUSVN to the currently
> + * loaded microcode update SVN and generate new cryptographic assets.
> + *
> + * Return:
> + * True: success or EUPDATESVN can be safely retried next time
> + * False: Unexpected error occurred
> + */
> +bool sgx_updatesvn(void)
> +{
> +	int retry = 10;
> +	int ret;
> +
> +	lockdep_assert_held(&sgx_epc_eupdatesvn_lock);
> +
> +	if (!(cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN))
> +		return true;
> +
> +	/*
> +	 * Do not execute ENCLS[EUPDATESVN] if running in a VM since
> +	 * microcode updates are only meaningful to be applied on the host.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
> +		return true;
> +
> +	do {
> +		ret = __eupdatesvn();
> +		if (ret != SGX_INSUFFICIENT_ENTROPY)
> +			break;
> +
> +	} while (--retry);
> +
> +	switch (ret) {
> +	case 0:
> +		pr_info("EUPDATESVN: success\n");
> +		break;
> +	case SGX_EPC_NOT_READY:
> +	case SGX_INSUFFICIENT_ENTROPY:
> +	case SGX_EPC_PAGE_CONFLICT:
> +		ENCLS_WARN(ret, "EUPDATESVN");
> +		break;
> +	case SGX_NO_UPDATE:
> +		break;
> +	default:
> +		ENCLS_WARN(ret, "EUPDATESVN");
> +		return false;

I'm lost why only ENCLS_WARN() is practiced here. For spurious error
code at minimum EPC allocation should be turned off really. Something
is likely working incorrectly in the driver.

> +	}
> +
> +	return true;
> +
> +}
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index d2dad21259a8..d7d631c973d0 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -103,5 +103,6 @@ static inline int __init sgx_vepc_init(void)
>  #endif
>  
>  void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
> +bool sgx_updatesvn(void);
>  
>  #endif /* _X86_SGX_H */
> -- 
> 2.45.2
> 

BR, Jarkko
