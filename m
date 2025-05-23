Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124751805A;
	Fri, 23 May 2025 15:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748015871; cv=none; b=t40W39cgeQnjfGlnQD5zQJle9r72PR6JSk8RcDiCzBUN4UX1PIM29P+cO2jhVbyVa4UW5/oxDgzMXg7z+uGKRiyufMkiWOBGH1fiNsCsWdY3TAoQP02il+K3xx4CJ13T4oFcWlrG44PdFl8PdyIOIUZiPfjnUkWlMRKi4ICjxtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748015871; c=relaxed/simple;
	bh=+2vqHphUu4C6bprlfQR7KILEpwfjSblrde32WlRTix8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U24K6Fx09MHWTmbUawD4a5M+7r20mnTx4rSf/RDcF19BwSrZZwI7s6GzrC30G6SFOD4rqd1VdzhcEsN85y5QkMHE1fYZpe4+3kPso1fzBooe2JRwkyUHZGxyKipaJyb17bSFRYa2osQVtqwoj6JWbde1ivxQvpqAnau2MiJ871I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eyc+NuVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eyc+NuVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC95C4CEE9;
	Fri, 23 May 2025 15:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748015870;
	bh=+2vqHphUu4C6bprlfQR7KILEpwfjSblrde32WlRTix8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eyc+NuVWDjJ1F8NCyi+NHQoo1uiTIYCRQVKnyCvIE7jn1s3vl1LgxjQucaWhk2Hku
	 /mWG0hDdnY37mkmiw+99Guq9MI7CEPVW/SP+zEGC9/zTVXoFmAfWtHBVXyIt4AmtSz
	 STM5phoCmHxAhWWlpMLqbhcLnz/S7bIbokuB551IbzfokPx/eRSweuO5i934BWIzEn
	 JADWmBZXTQEcmV5K0faDtXNi3XWFl3/zQPhp6bWcp7bNz5tp10WBkAmjZExUZ8vJFG
	 7TJlFSoL0De1Hqr7TUD6ROWQJuNrmYwrUGc7yHwLxa5YzuI+/yZMEbJq+PkW+N6I7o
	 9tCz5poC9WxWA==
Date: Fri, 23 May 2025 18:57:45 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, seanjc@google.com, kai.huang@intel.com,
	mingo@kernel.org, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v6 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Message-ID: <aDCa-U8buhyjIygO@kernel.org>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
 <20250522092237.7895-5-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522092237.7895-5-elena.reshetova@intel.com>

On Thu, May 22, 2025 at 12:21:37PM +0300, Elena Reshetova wrote:
> All running enclaves and cryptographic assets (such as internal SGX
> encryption keys) are assumed to be compromised whenever an SGX-related
> microcode update occurs. To mitigate this assumed compromise the new
> supervisor SGX instruction ENCLS[EUPDATESVN] can generate fresh
> cryptographic assets.
> 
> Before executing EUPDATESVN, all SGX memory must be marked as unused.
> This requirement ensures that no potentially compromised enclave
> survives the update and allows the system to safely regenerate
> cryptographic assets.
> 
> Add the method to perform ENCLS[EUPDATESVN].
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encls.h |  5 +++
>  arch/x86/kernel/cpu/sgx/main.c  | 67 +++++++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
> index 99004b02e2ed..d9160c89a93d 100644
> --- a/arch/x86/kernel/cpu/sgx/encls.h
> +++ b/arch/x86/kernel/cpu/sgx/encls.h
> @@ -233,4 +233,9 @@ static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
>  	return __encls_2(EAUG, pginfo, addr);
>  }
>  
> +/* Attempt to update CPUSVN at runtime. */
> +static inline int __eupdatesvn(void)
> +{
> +	return __encls_ret_1(EUPDATESVN, "");
> +}
>  #endif /* _X86_ENCLS_H */
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index a018b01b8736..109d40c89fe8 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -16,6 +16,7 @@
>  #include <linux/vmalloc.h>
>  #include <asm/msr.h>
>  #include <asm/sgx.h>
> +#include <asm/archrandom.h>
>  #include "driver.h"
>  #include "encl.h"
>  #include "encls.h"
> @@ -920,6 +921,72 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
>  /* Counter to count the active SGX users */
>  static atomic64_t sgx_usage_count;
>  
> +/**
> + * sgx_updatesvn() - Attempt to call ENCLS[EUPDATESVN].
> + * This instruction attempts to update CPUSVN to the
> + * currently loaded microcode update SVN and generate new
> + * cryptographic assets. Must be called when EPC is empty.
> + * Most of the time, there will be no update and that's OK.
> + * If the failure is due to SGX_INSUFFICIENT_ENTROPY, the
> + * operation can be safely retried. In other failure cases,
> + * the retry should not be attempted.
> + *
> + * Return:
> + * 0: Success or not supported
> + * -EAGAIN: Can be safely retried, failure is due to lack of
> + *  entropy in RNG.
> + * -EIO: Unexpected error, retries are not advisable.
> + */
> +static int sgx_update_svn(void)
> +{
> +	int ret;
> +
> +	/*
> +	 * If EUPDATESVN is not available, it is ok to
> +	 * silently skip it to comply with legacy behavior.
> +	 */
> +	if (!cpu_feature_enabled(X86_FEATURE_SGX_EUPDATESVN))
> +		return 0;
> +
> +	for (int i = 0; i < RDRAND_RETRY_LOOPS; i++) {
> +		ret = __eupdatesvn();
> +
> +		/* Stop on success or unexpected errors: */
> +		if (ret != SGX_INSUFFICIENT_ENTROPY)
> +			break;
> +	}
> +
> +	/*
> +	 * SVN was already up-to-date. This is the most
> +	 * common case.
> +	 */
> +	if (ret == SGX_NO_UPDATE)
> +		return 0;
> +
> +	/*
> +	 * SVN update failed due to lack of entropy in DRNG.
> +	 * Indicate to userspace that it should retry.
> +	 */
> +	if (ret == SGX_INSUFFICIENT_ENTROPY)
> +		return -EAGAIN;
> +
> +	if (!ret) {
> +		/*
> +		 * SVN successfully updated.
> +		 * Let users know when the update was successful.
> +		 */
> +		pr_info("SVN updated successfully\n");
> +		return 0;
> +	}
> +
> +	/*
> +	 * EUPDATESVN was called when EPC is empty, all other error
> +	 * codes are unexpected.
> +	 */
> +	ENCLS_WARN(ret, "EUPDATESVN");
> +	return -EIO;
> +}

Even if unlikely() was not used I still don't agree with the order i.e.,
dealing with the success case in the middle. So I stand with my earlier
suggestion, except unlikely() (since that was a problem for David, not
going to fight over it).

BR, Jarkko
