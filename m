Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E3B28983E;
	Mon, 19 May 2025 16:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747670688; cv=none; b=VALHfgYcJHm2qBk6h2uLKjmHPJjqbwwxg5fEo5NkO/fpLnuGozyA8QqqUwJxCUgqcL4epxq/5mdlm3Y2EXXE9NFDaJQeLpJS8fh0IljQuCkfl0cGwrbTzNWcsbqEW1H2pH15FCEeSqsF6v/dmmTV30MtAfsqSkmCVPlZdHzx75I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747670688; c=relaxed/simple;
	bh=4S9Gn4Qjmm6QpZEK/3GBryQ0ISYwhIwThl0Cq6l5WAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s2lMDAVHeoVwp4UJWKBsU84V01eFvNtJF8/DSUHiJq7Jj6VwFO8oxdg2iSiM9T8j+RBBr8gJ5Fomm5fjDwKrBlXjkPdziDIx+t0OOfWKAWWlb/Ay01pE8P3Q3mGJGkTjHWsdZh5HL7m8LrNz9uKOAAHJs7kl12A2mWcsCwPl8Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dXOuPcHB; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dXOuPcHB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747670686; x=1779206686;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4S9Gn4Qjmm6QpZEK/3GBryQ0ISYwhIwThl0Cq6l5WAw=;
  b=dXOuPcHBrdnpLHUgQKgnPc8oSgztjP3WoNqqY9kEfbEP1NjpFFpmNmy5
   xiqEGscb6KYG33DGwrimGkL9B/nxB+8MfZBQZd3r+RgKCxYl+nKtNscXX
   mCQ1Gqv1PK3pbWyq3aUDRP4FVL3dYhX8Uz/WYbKO71MeFKrkvgJXO/yEs
   yquLI7crFr6SSJSvjY6MbUlaRqaFviiSmWX6BkRKpnigyJ7I7qjmQDJzf
   d5uD6h7kFoSsTUISVeCM5UFMBl4tYrDwPsfhj2qAIeQz9AZ0NKbScUEoC
   5OsjAHojzWCAftT+NsK7XBHOE8uVMpd8BuX9MmRPlASM7WOCaZTjrKCMT
   A==;
X-CSE-ConnectionGUID: bnUv2HMhQ/yY19a18W2Egw==
X-CSE-MsgGUID: kG3JGCR3Sf6eAYyBDgrnCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="60968952"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="60968952"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 09:02:42 -0700
X-CSE-ConnectionGUID: 2QWUtKXhRL2DoJ8b0pHvLw==
X-CSE-MsgGUID: aZ8S5zeCTY+KOFBRfYukpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="139450870"
Received: from puneetse-mobl.amr.corp.intel.com (HELO [10.125.109.70]) ([10.125.109.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 09:02:40 -0700
Message-ID: <f5f1bfbf-8323-4bc6-aa79-f277c89b60a0@intel.com>
Date: Mon, 19 May 2025 09:02:39 -0700
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: jarkko@kernel.org, seanjc@google.com, kai.huang@intel.com,
 linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 asit.k.mallick@intel.com, vincent.r.scarlata@intel.com, chongc@google.com,
 erdemaktas@google.com, vannapurve@google.com, dionnaglaze@google.com,
 bondarn@google.com, scott.raynor@intel.com
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-5-elena.reshetova@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250519072603.328429-5-elena.reshetova@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/19/25 00:24, Elena Reshetova wrote:
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

That's really bizarre text wrapping. You might want to have your editor
give it another go.

I also found this pretty hard to read, but a friendly AI chatbot helped
me rewrite it:

All running enclaves and cryptographic assets (such as internal SGX
encryption keys) are assumed to be compromised whenever an SGX-related
microcode update occurs. To mitigate this assumed compromise the new
supervisor SGX instruction ENCLS[EUPDATESVN] can generate fresh
cryptographic assets.

Before executing EUPDATESVN, all SGX memory must be marked as unused.
This requirement ensures that no potentially compromised enclave
survives the update and allows the system to safely regenerate
cryptographic assets.

> @@ -917,6 +918,62 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
>  /* Counter to count the active SGX users */
>  static atomic64_t sgx_usage_count;
>  
> +/**
> + * sgx_updatesvn() - Attempt to call ENCLS[EUPDATESVN]
> + * If EPC is empty, this instruction attempts to update CPUSVN to the
> + * currently loaded microcode update SVN and generate new
> + * cryptographic assets.sgx_updatesvn() Most of the time, there will

				^ What happened here?

> + * be no update and that's OK.
> + *
> + * Return:
> + * 0: Success, not supported or run out of entropy
> + */

Good documentation will help folks know when they might call this. It
sets clear expectations. When is it safe to call? What do I do if it fails?

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

At this point, it's pretty obvious that this code hasn't been tested.
This code would (I think) croak on any SGX users on non-EUPDATESVN
hardware. I'm going to stop reviewing this now. You've gotten quite a
bit of feedback on it and I think I'll wait for v6, which I'm sure will
have a few more correctness passes on it before going out.

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

Remember, no "we's". Use imperative voice.

