Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E588019047F;
	Wed,  7 May 2025 16:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746634026; cv=none; b=d3Nb6N9LQlz8MUUUIaUNPX7ImXcK4e7s5G0jNc9CraPDv3COFBqVpqqvyXPKGkRysJ69xxSWgJNLTs3Nrl4CBVavfg9mxk9zbJiA4GlNXcZli/lcbgybiyCzWuX8txk1ENNlFsO/kI3u2YxqJ+QCRShaoeTJIjG10QbBuFTVHf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746634026; c=relaxed/simple;
	bh=5qtEJL4/tdpSTkF1qlEPcD4RUNN6Y2RvFgufgmieko8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q8pp0BsTgrLVDyGt8CF7YhM5rR0MNRakUhZwt4m5sSK421cOOZNfm+tW1NAV/qGN+4UjjzhhWvRfTiwqcg7N463JewiTJ6caofSfwmxj3Zo4ZYbKfsAY4MaZgKKpRfPGVIgM4KNkAB6pbCxOyUED9pNtSSe5B2fd0eoIr3k7NY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ECMZobRn; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ECMZobRn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746634024; x=1778170024;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5qtEJL4/tdpSTkF1qlEPcD4RUNN6Y2RvFgufgmieko8=;
  b=ECMZobRnMksCbRz/FfCssMTxE/uT5ElRASQLdQDFy0qM74wLGYhbvgLV
   XEuJF6HHflWBuxeNNAlIh3vlyJi8qk5geStwrP3jjl2q0Wwm0Vil5BcKD
   iTaIUgy9v3+Ja1LImUl0Vf4LGOSmZfZsYhtbHPd0ZO5oN9unrWczrtz7X
   424DeGv9JCezw9l0E+FJStCggjRdPnpKqDXC21Tvra2WwvZzyHSdYBRCt
   uzEmFhJU5hr2ifX0ZNKUvs+XWLAMnxIjhIX+C/4xiab1erMBalI3cphhj
   Q96ceUlb7D1HilTQdnSQ9rTXGud3+1YUvd0ydBWw0YaPnZlrK2M1ONi42
   A==;
X-CSE-ConnectionGUID: WQEdkINLSXSsWyRlReI/Aw==
X-CSE-MsgGUID: kld8CvfSQ5aeaZQNAjcNZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="47634735"
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="47634735"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 09:04:45 -0700
X-CSE-ConnectionGUID: OzYl8lx6TG+i87QA1Gn2ow==
X-CSE-MsgGUID: qz9Q7eSpRT+BkADvFdeZ1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="137004581"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.124.222.63]) ([10.124.222.63])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 09:04:44 -0700
Message-ID: <023ab74f-82b7-41fc-ab20-0c0089f1f348@intel.com>
Date: Wed, 7 May 2025 09:04:41 -0700
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: jarkko@kernel.org, seanjc@google.com, kai.huang@intel.com,
 linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 asit.k.mallick@intel.com, vincent.r.scarlata@intel.com, chongc@google.com,
 erdemaktas@google.com, vannapurve@google.com, dionnaglaze@google.com,
 bondarn@google.com, scott.raynor@intel.com
References: <20250507111542.709858-1-elena.reshetova@intel.com>
 <20250507111542.709858-2-elena.reshetova@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250507111542.709858-2-elena.reshetova@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/25 04:14, Elena Reshetova wrote:
> In case an SGX vulnerability is discovered and TCB recovery
> for SGX is triggered, Intel specifies a process that must be
> followed for a given vulnerability. Steps to mitigate can vary
> based on vulnerability type, affected components, etc.
> In some cases, a vulnerability can be mitigated via a runtime
> recovery flow by shutting down all running SGX enclaves,
> clearing enclave page cache (EPC), applying a microcode patch
> that does not require a reboot (via late microcode loading) and
> restarting all SGX enclaves.

Plain language and brevity have a lot of value in changelogs. There's a
substantial amount of irrelevant content here.

> Even when the above-described runtime recovery flow to mitigate the
> SGX vulnerability is followed, the SGX attestation evidence will
> still reflect the security SVN version being equal to the previous
> state of security SVN (containing vulnerability) that created
> and managed the enclave until the runtime recovery event. This
> limitation currently can be only overcome via a platform reboot,
> which negates all the benefits from the rebootless late microcode
> loading and not required in this case for functional or security
> purposes.

Can this please be trimmed down?

Actually, I think I wrote changelogs for this once upon a time. Could
you please go dig those up and use them?

> SGX architecture introduced a new instruction called ENCLS[EUPDATESVN]
> to Ice Lake [1].

Is it really on "Ice Lake" parts? Like, does it show up on
INTEL_ICELAKE? If not, this is only confusing and mostly irrelevant
information.

> It allows updating security SVN version, given that EPC
> is completely empty. The latter is required for security reasons
> in order to reason that enclave security posture is as secure as the
> security SVN version of the TCB that created it.
> 
> Additionally it is important to ensure that while ENCLS[EUPDATESVN]
> runs, no concurrent page creation happens in EPC, because it might
> result in #GP delivered to the creator. Legacy SW might not be prepared
> to handle such unexpected #GPs and therefore this patch introduces
> a locking mechanism in sgx_(vepc_)open to ensure no concurrent EPC
> allocations can happen.
> 
> Implement ENCLS[EUPDATESVN] and enable kernel to opportunistically
> call it during sgx_(vepc_)open().


> [1]
> https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true

These become stale almost immediately. Please also cite the document title.

>  arch/x86/include/asm/sgx.h       | 42 ++++++++++++-------
>  arch/x86/kernel/cpu/sgx/driver.c |  4 ++
>  arch/x86/kernel/cpu/sgx/encl.c   |  1 +
>  arch/x86/kernel/cpu/sgx/encls.h  |  5 +++
>  arch/x86/kernel/cpu/sgx/main.c   | 70 ++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h    |  3 ++
>  arch/x86/kernel/cpu/sgx/virt.c   |  6 +++
>  7 files changed, 116 insertions(+), 15 deletions(-)

Gah, how did this get squished back down to a single patch? It was
multiple patches before. There are multiple logical things going on here
and they need to be broken out.

> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 6a0069761508..8ac026ef6365 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -27,22 +27,26 @@
>  /* The bitmask for the EPC section type. */
>  #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
>  
> +/* EUPDATESVN support in CPUID.0x12.0.EAX */
> +#define SGX_CPUID_EUPDATESVN	BIT(10)
> +
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
> +	EPA			= 0x0A,
> +	EWB			= 0x0B,
> +	ETRACK		= 0x0C,
> +	EAUG		= 0x0D,
> +	EMODPR		= 0x0E,
> +	EMODT		= 0x0F,
> +	EUPDATESVN	= 0x18,
>  };
>  
>  /**
> @@ -73,6 +77,11 @@ enum sgx_encls_function {
>   *				public key does not match IA32_SGXLEPUBKEYHASH.
>   * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
>   *				is in the PENDING or MODIFIED state.
> + * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
> + * %SGX_EPC_NOT_READY:			EPC is not ready for SVN update.
> + * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
> + *				updated because current SVN was not newer than
> + *				CPUSVN.
>   * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
>   */
>  enum sgx_return_code {
> @@ -81,6 +90,9 @@ enum sgx_return_code {
>  	SGX_CHILD_PRESENT		= 13,
>  	SGX_INVALID_EINITTOKEN		= 16,
>  	SGX_PAGE_NOT_MODIFIABLE		= 20,
> +	SGX_INSUFFICIENT_ENTROPY	= 29,
> +	SGX_EPC_NOT_READY			= 30,
> +	SGX_NO_UPDATE				= 31,
>  	SGX_UNMASKED_EVENT		= 128,
>  };

I'd *much* rather that these mechanical constant introductions and
mindless refactoring (like reindenting) not be mixed with actual logic code.

>  
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index 7f8d1e11dbee..669e44d61f9f 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -19,6 +19,10 @@ static int sgx_open(struct inode *inode, struct file *file)
>  	struct sgx_encl *encl;
>  	int ret;
>  
> +	ret = sgx_inc_usage_count();
> +	if (ret)
> +		return ret;
> +
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
> diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
> index 99004b02e2ed..788acf8ec563 100644
> --- a/arch/x86/kernel/cpu/sgx/encls.h
> +++ b/arch/x86/kernel/cpu/sgx/encls.h
> @@ -233,4 +233,9 @@ static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
>  	return __encls_2(EAUG, pginfo, addr);
>  }
>  
> +/* Update CPUSVN at runtime. */
> +static inline int __eupdatesvn(void)
> +{
> +	return __encls_ret_1(EUPDATESVN, "");
> +}
>  #endif /* _X86_ENCLS_H */
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 8ce352fc72ac..2872567cd22b 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -15,6 +15,7 @@
>  #include <linux/sysfs.h>
>  #include <linux/vmalloc.h>
>  #include <asm/sgx.h>
> +#include <asm/archrandom.h>
>  #include "driver.h"
>  #include "encl.h"
>  #include "encls.h"
> @@ -914,6 +915,73 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
>  }
>  EXPORT_SYMBOL_GPL(sgx_set_attribute);
>  
> +static bool sgx_has_eupdatesvn;

We have CPUID "caches" of sorts. Why open code this?

> +static atomic_t sgx_usage_count;

Is 32 bits enough for sgx_usage_count? What goes boom when it overflows?

> +static DEFINE_MUTEX(sgx_svn_lock);

What does this lock protect?

> +/**
> + * sgx_updatesvn() - Issue ENCLS[EUPDATESVN]
> + * If EPC is empty, this instruction will update CPUSVN to the currently
> + * loaded microcode update SVN and generate new cryptographic assets.

This is *NOT* EUPDATESVN. "this instruction" is not what's happening here.

sgx_updatesvn() _tries_ to update the SVN. Most of the time, there will
be no update and that's OK. This should only be called with EPC is empty.

> + * Return:
> + * 0: Success or not supported
> + * errno on error

I'm not a big fan of filling thing out just because.

What value is there in saying "errno on error"?

> + */
> +static int sgx_update_svn(void)
> +{
> +	int retry = RDRAND_RETRY_LOOPS;
> +	int ret;
> +
> +	if (!sgx_has_eupdatesvn)
> +		return 0;

This looks goofy. Why is it OK to just silently ignore an update
request? (I know the answer, but it needs to be obvious)

> +	do {
> +		ret = __eupdatesvn();
> +	} while (ret == SGX_INSUFFICIENT_ENTROPY && --retry);


	for (i = 0; i < RDRAND_RETRY_LOOPS; i++) {
		ret = __eupdatesvn();

		/* Stop on success or unexpected errors: */
		if (ret != SGX_INSUFFICIENT_ENTROPY)
			break;
	}

> +	if (!ret || ret == SGX_NO_UPDATE) {
> +		/*
> +		 * SVN successfully updated, or it was already up-to-date.
> +		 * Let users know when the update was successful.
> +		 */
> +		if (!ret)
> +			pr_info("SVN updated successfully\n");
> +		return 0;
> +	}

Isn't this a lot simpler?

	if (ret == SGX_NO_UPDATE)
		return 0;

	if (!ret) {
		pr_info("SVN updated successfully\n");
		return 0;
	}

> +	/*
> +	 * EUPDATESVN was called when EPC is empty, all other error
> +	 * codes are unexcepted except running out of entropy.

			^ unexpected

Spell check, please.

> +	 */
> +	if (ret != SGX_INSUFFICIENT_ENTROPY)
> +		ENCLS_WARN(ret, "EUPDATESVN");
> +	return ret;
> +}

The indentation here is backwards. The error paths should be indented
and the success path at the lowest indent whenever possible. This, for
example:

	if (ret == SGX_NO_UPDATE)
		return 0;

	if (ret) {
		ENCLS_WARN(ret, "EUPDATESVN");
		return ret;
	}

	pr_info("SVN updated successfully\n");
	return 0;

Oh, and do we expect SGX_INSUFFICIENT_ENTROPY all the time? I thought it
was supposed to be horribly rare. Shouldn't we warn on it?

> +int sgx_inc_usage_count(void)
> +{

No comments, eh?

What does success _mean_? What does failure mean?

> +	int ret;
> +
> +	if (atomic_inc_not_zero(&sgx_usage_count))
> +		return 0;
> +
> +	guard(mutex)(&sgx_svn_lock);
> +
> +	if (atomic_inc_not_zero(&sgx_usage_count))
> +		return 0;
> +
> +	ret = sgx_update_svn();
> +	if (!ret)
> +		atomic_inc(&sgx_usage_count);
> +	return ret;
> +}

Gah, this is 100% *NOT* obvious what's going on. Yet there are zero
comments on it. The lock is uncommented. The atomic is uncommented.

What does any of this mean? What do the components do?

> +
> +void sgx_dec_usage_count(void)
> +{
> +	atomic_dec(&sgx_usage_count);
> +}



>  static int __init sgx_init(void)
>  {
>  	int ret;
> @@ -947,6 +1015,8 @@ static int __init sgx_init(void)
>  	if (sgx_vepc_init() && ret)
>  		goto err_provision;
>  
> +	sgx_has_eupdatesvn = (cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN);
> +
>  	return 0;
>  
>  err_provision:
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
> index 7aaa3652e31d..e548de340c2e 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -255,12 +255,18 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
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
>  	if (!vepc)

I think I'd do this in at least 4 patches:

1. Introduce the usage count tracking: the atomic and the open/release
   "hooks", maybe without error handling on the open() side
2. Introduce the EUPDATESVN mechanical bits: the CPUID bit, the
   enumeration, the bool, the new error enum values
3. Introduce the mechanical eupdatesvn function. The retry loop and the
   "no entropy" handling
4. Plumb #3 into #1

#4 is your place to argue if EUPDATESVN failures should cascade to open().
