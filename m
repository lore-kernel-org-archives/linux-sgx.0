Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C932857C4;
	Mon, 19 May 2025 18:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747679073; cv=none; b=BBScI/T/gM0lbdH7laIsjOOPZYM/evpAA29rd7ib7dJ7HT38h+Yd6Z3e1tJ5cCt5GpBfan3AkRnlvGwcU3/8fd/l69sIRihTU6lXRFwFKBIE6nX/e8HB0qO3rlU900OfeDT3go6B49UCGzE1TOPUGRM+xApRDiKhS3bkX8JBbfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747679073; c=relaxed/simple;
	bh=1KXAzjMSe/ri37+m07NJN/eRVwd604m2Fdfu1XxKbZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNNzoJFQWkMR+zM0KwsHm73HajmQidWVtkrt/AS7+bhLEi4aSuwPm7V+R6uz9EGR8s7im3CkIjqueznlD/AeH5amOq2kl5AL03QsA9xhYXNk4ozILaMm7drBHdFTUws7CYYgszpPGoQKwHjn3gU2qBvKjK+sQjopQcnJNAtwbok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l+LWGzHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+LWGzHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A402CC4CEE4;
	Mon, 19 May 2025 18:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747679073;
	bh=1KXAzjMSe/ri37+m07NJN/eRVwd604m2Fdfu1XxKbZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l+LWGzHwPLt9tuDO2OcldxtSI5ZY3J8HPzrk0cPNCGCz6dcAEu2vQfDlzMOAjU1Ls
	 VjTCWQlsOiSydSXIjojXyUgFyOijsOk4u4Sy9ZHQm58p4drcySd3SdMnf2YsSv3/Mv
	 AHRCjp4VqAzvufFY3qJgxWtYWybUTut7PVTjp7CdNAqvfMCzBQhE0qAUzFtHw+z9ZJ
	 kAxVQ0HRFoWe0RRjMUNqDiNrXBhB+8HjRPNNLRYLL/PrXzxxsFsEtYOVpKy9A6GDpG
	 hB44nxs98KijGU7OowwfGML52gsiHF7vPf8rILBu6vgC+2SvmiqkSXP/7bxzY0vFjv
	 NvluuWmqBIrTA==
Date: Mon, 19 May 2025 21:24:29 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, seanjc@google.com, kai.huang@intel.com,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, asit.k.mallick@intel.com,
	vincent.r.scarlata@intel.com, chongc@google.com,
	erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Message-ID: <aCt3XZ0m40wuA9bU@kernel.org>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-5-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519072603.328429-5-elena.reshetova@intel.com>

On Mon, May 19, 2025 at 10:24:30AM +0300, Elena Reshetova wrote:
> The SGX attestation architecture assumes a compromise
> of all running enclaves and cryptographic assets
> (like internal SGX encryption keys) whenever a microcode
> update affects SGX. To mitigate the impact of this presumed
> compromise, a new supervisor SGX instruction: ENCLS[EUPDATESVN],
> is introduced to update SGX microcode version and generate
> new cryptographic assets in runtime after SGX microcode update.
> 
> EUPDATESVN requires that SGX memory to be marked as "unused"
> before it will succeed. This ensures that no compromised enclave
> can survive the process and provides an opportunity to generate
> new cryptographic assets.
> 
> Add the method to perform ENCLS[EUPDATESVN].
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encls.h |  5 +++
>  arch/x86/kernel/cpu/sgx/main.c  | 57 +++++++++++++++++++++++++++++++++
>  2 files changed, 62 insertions(+)
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
> index 80d565e6f2ad..fd71e2ddca59 100644
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
> @@ -917,6 +918,62 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
>  /* Counter to count the active SGX users */
>  static atomic64_t sgx_usage_count;
>  
> +/**
> + * sgx_updatesvn() - Attempt to call ENCLS[EUPDATESVN]
> + * If EPC is empty, this instruction attempts to update CPUSVN to the
> + * currently loaded microcode update SVN and generate new
> + * cryptographic assets.sgx_updatesvn() Most of the time, there will

Is there something wrong here in the text? It looks malformed.

> + * be no update and that's OK.
> + *
> + * Return:
> + * 0: Success, not supported or run out of entropy
> + */
> +static int sgx_update_svn(void)
> +{
> +	int ret;
> +
> +	/*
> +	 * If EUPDATESVN is not available, it is ok to
> +	 * silently skip it to comply with legacy behavior.
> +	 */
> +	if (!X86_FEATURE_SGX_EUPDATESVN)
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
> +	 * SVN either was up-to-date or SVN update failed due
> +	 * to lack of entropy. In both cases, we want to return
> +	 * 0 in order not to break sgx_(vepc_)open. We dont expect
> +	 * SGX_INSUFFICIENT_ENTROPY error unless underlying RDSEED
> +	 * is under heavy pressure.
> +	 */
> +	if ((ret == SGX_NO_UPDATE) || (ret == SGX_INSUFFICIENT_ENTROPY))
	
	if (ret == SGX_NO_UPDATE || ret == SGX_INSUFFICIENT_ENTROPY)

> +		return 0;
> +
> +	if (!ret) {
> +		/*
> +		 * SVN successfully updated.
> +		 * Let users know when the update was successful.
> +		 */

This comment is like as useless as an inline comment can ever possibly
be. Please, remove it.

> +		pr_info("SVN updated successfully\n");

Let's not add this either in the scope of this patch set.

> +		return 0;
> +	}

Since you parse error codes already, I don't understand why deal with
the success case in the middle of doing that.

More consistent would be (not also the use of unlikely()):

	if (ret == SGX_NO_UPDATE || ret == SGX_INSUFFICIENT_ENTROPY)
		return 0;

	/*
	 * EUPDATESVN was called when EPC is empty, all other error
	 * codes are unexpected.
	 */
	if (unlikely(ret)) {
		ENCLS_WARN(ret, "EUPDATESVN");
		return ret;
	}
		
	return 0;
}

This is how I would rewrite the tail of this function.

BR, Jarkko
