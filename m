Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225512D023;
	Sat, 22 Mar 2025 22:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742681964; cv=none; b=SyBh6GxYG/KZn6LBoQYFPLeZ3LZiW9qT+Ir3Ec/kKkGyr9enpcuwX71HRGJyJXBBX0H5m15QURJqSV3qPgT7Y207BYDR/HWm3BG+VHIk07bsDJ+H+6VqDgZG1ZgaK+yvvs0xbVML9XC3eXHF+Gg29j53nSAQpZtFS+3N8FxMds8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742681964; c=relaxed/simple;
	bh=iynpC1DDLxYyv3InM2Zrq3j21FUJht27MG23dxh7TFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UUhImPe0SBfg/ls2omY/HOONU8u80y3Gkf5fKdt0o5AAADbPeZEj/T26hbwyybYHurOT9zNhvUgHFNoe3aqerevaExsvXl067EvQOtWlIfsNayycXbeVBUAGUeBgsO7YrZuiGQgHOtKAyzPm1kQToabAx4LYGnesvyKKROTBsp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mw5hVkXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mw5hVkXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFE3C4CEDD;
	Sat, 22 Mar 2025 22:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742681963;
	bh=iynpC1DDLxYyv3InM2Zrq3j21FUJht27MG23dxh7TFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mw5hVkXPCpgmcpVMLcKdZRG/KdkJmmlp3IcKrC80MkVgVeCbAszqu8nTL2Nt8kj+z
	 cd1ueE4N1KkwoHgUtxW+Uwpti1DW9HN1k3Dsoic5XJOQOj8ukui6tJbB5Bgc37NRdx
	 1seTHbJLhxffUF9HbDzcRoTPkYZGnyHQ/TFjZJranpL5J8KqWWO+z2vVIWZav6ArDg
	 O2vQEMT+nnPkLLHWZGMZ3+srOaZ6n5PWm4Myk0BN/Pir1tDwS7Wf2biZhD+eyPq6ud
	 mmWx7Mpalap+o+QGxzQ5P5t8E6m4JfnkbDqAlLf36XubbCiVLGQoGvZqntsOIOYUTN
	 X8p/m4Np+wkpw==
Date: Sun, 23 Mar 2025 00:19:17 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com,
	Cathy Zhang <cathy.zhang@intel.com>
Subject: Re: [PATCH 4/4] x86/sgx: Implement ENCLS[EUPDATESVN] and
 opportunistically call it during first EPC page alloc
Message-ID: <Z983ZaTaWNqFUpYS@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-5-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321123938.802763-5-elena.reshetova@intel.com>

On Fri, Mar 21, 2025 at 02:34:43PM +0200, Elena Reshetova wrote:
> SGX architecture introduced  a new instruction called EUPDATESVN [1]
> to Ice Lake. It allows updating security SVN version, given that EPC
> is completely empty. The latter is required for security reasons
> in order to reason that enclave security posture is as secure as the
> security SVN version of the TCB that created it.
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
> The implementation of ENCLS[EUPDATESVN] is based on previous submision in [2]
> 
> [1] https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true

I don't think for Intel opcodes a link is needed. We know where to look
them up.

> [2] https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/T/#medb89e6a916337b4f9e68c736a295ba0ae99ac90

Link:

> 
> Co-developed-by: Cathy Zhang <cathy.zhang@intel.com>
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> Co-developed-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/x86/include/asm/sgx.h      | 33 +++++++++--------
>  arch/x86/kernel/cpu/sgx/encls.h |  6 +++
>  arch/x86/kernel/cpu/sgx/main.c  | 65 ++++++++++++++++++++++++++++++++-
>  arch/x86/kernel/cpu/sgx/sgx.h   |  2 +
>  4 files changed, 90 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 8ba39bbf4e91..5caf5c31ebc6 100644
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
> index b61d3bad0446..698921229094 100644
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
> @@ -457,7 +462,17 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
>  	page->flags = 0;
>  
>  	spin_unlock(&node->lock);
> -	atomic_long_inc(&sgx_nr_used_pages);
> +
> +	if (!atomic_long_inc_not_zero(&sgx_nr_used_pages)) {
> +		spin_lock(&sgx_epc_eupdatesvn_lock);
> +		/* Only call sgx_updatesvn() once the first enclave's
> +		 * page is allocated from EPC
> +		 */
> +		if (atomic_long_read(&sgx_nr_used_pages) == 0)
> +			sgx_updatesvn();
> +		atomic_long_inc(&sgx_nr_used_pages);
> +		spin_unlock(&sgx_epc_eupdatesvn_lock);
> +	}
>  
>  	return page;
>  }
> @@ -970,3 +985,51 @@ static int __init sgx_init(void)
>  }
>  
>  device_initcall(sgx_init);
> +
> +/**
> + * sgx_updatesvn() - Issue ENCLS[EUPDATESVN]
> + * If EPC is ready, this instruction will update CPUSVN to the currently
> + * loaded microcode update SVN and generate new cryptographic assets.
> + */
> +void sgx_updatesvn(void)
> +{
> +	int ret;
> +	int retry = 10;

Reverse declaration order.

> +
> +	lockdep_assert_held(&sgx_epc_eupdatesvn_lock);
> +
> +	/* Do not execute EUPDATESVN if instruction is unavalible or running in a VM */
> +	if (!(cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN) ||
> +		    boot_cpu_has(X86_FEATURE_HYPERVISOR))
> +		return;


	if (!(cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN))
		return;

	/* ... */
	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
		return;

The first check really does not need a comment. The second would benefit
from explaining why bail out inside a VM.
		
		



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
> +		pr_debug("EUPDATESVN was successful!\n");
> +		break;
> +	case SGX_NO_UPDATE:
> +		pr_debug("EUPDATESVN was successful, but CPUSVN was not updated, "
> +			"because current SVN was not newer than CPUSVN.\n");
> +		break;
> +	case SGX_EPC_NOT_READY:
> +		pr_debug("EPC is not ready for SVN update.");
> +		break;
> +	case SGX_INSUFFICIENT_ENTROPY:
> +		pr_debug("CPUSVN update is failed due to Insufficient entropy in RNG, "
> +			"please try it later.\n");
> +		break;
> +	case SGX_EPC_PAGE_CONFLICT:
> +		pr_debug("CPUSVN update is failed due to concurrency violation, please "
> +			"stop running any other ENCLS leaf and try it later.\n");
> +		break;
> +	default:
> +		break;

Remove pr_debug() statements.

> +	}
> +}
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index d2dad21259a8..92c9e226f1b5 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -104,4 +104,6 @@ static inline int __init sgx_vepc_init(void)
>  
>  void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
>  

I don't think we need a newline in-between.

> +void sgx_updatesvn(void);
> +
>  #endif /* _X86_SGX_H */
> -- 
> 2.45.2
> 

BR, Jarkko
