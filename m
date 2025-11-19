Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F1A1E8329;
	Wed, 19 Nov 2025 02:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763519264; cv=none; b=l9jW9lI7cwbGXEj8xCqtIKaoMY/hxYkS3/gvcQFoFywe0t+/wYfcsAT6LvVFlwFwbd/owynTHSFKp15hGYnXeijAYpAgfX6i7liAYBcQsrNDa1OMdCj1i5raVEN8o0X84+/nJPSamgE2+UFabSDFRNZOcQzhmemJuxNz14LppAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763519264; c=relaxed/simple;
	bh=26h6O5p705/SRhlSWwNv/Bplx3yxVXIOIEkd7/uTLQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpzJmpfGpmKnjtx0SBqxj+dxm5JQlxVWcxZJVcpTZVmlsoXMuCVoeHa5lqoLoakO8xaNV0zPlZliMh3Wzb/lhh7O+SvIIxSHWLDDHVX6aBzr7O1VX83OsQbx17+mcLlY6yWIeXQlRcXnbXH8OMX1OZQ7Oz5rSIP0sUouMcvobnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6sGKglv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6sGKglv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D5AC2BCB4;
	Wed, 19 Nov 2025 02:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763519263;
	bh=26h6O5p705/SRhlSWwNv/Bplx3yxVXIOIEkd7/uTLQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e6sGKglvUcXx1AyoHmkvhw3q1kIji/Ln55M5zLompSVdyeLnLln/FgbHT2l9tAL3m
	 MTwE+UdnwRHcTIkjvb8YdCg5uSmyxFy8m5cCDEo8K9cAi/ukUDYmSuDa+jkTRQL6Dj
	 q1hYl2olnV2kcbr0KD46E0BERek8YiLTWXH/rBWmgPBSZZGfl+wU3NjxwQRPNu2+n5
	 yoT/Te+95aO7iKZT6E7GwX7Rb6sPvwlVmv37FpCG6g3X7Dec2P2w36Pq61zlt2J0E+
	 A9gcAXJx8LIDuugH27RsZUOoHoCQ6v/mXEm3fmJ8K1ZI0kmUYLEcSkTv8Ay6+A6m61
	 yqPjv5ErFrcxg==
Date: Wed, 19 Nov 2025 04:27:37 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/5] x86/sgx: Add a missing colon in kernel-doc markup
 for "struct sgx_enclave_run"
Message-ID: <aR0rGRe6GU9GjsHT@kernel.org>
References: <20251112160708.1343355-1-seanjc@google.com>
 <20251112160708.1343355-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112160708.1343355-2-seanjc@google.com>

On Wed, Nov 12, 2025 at 08:07:04AM -0800, Sean Christopherson wrote:
> Add a missing ':' for the description of sgx_enclave_run.reserved so that
> documentation for the member is correctly generated:
> 
>   WARNING: arch/x86/include/uapi/asm/sgx.h:184 struct member 'reserved' not
>   described in 'sgx_enclave_run'
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/all/20251106145506.145fc620@canb.auug.org.au
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/uapi/asm/sgx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 2dd35bbdc822..a438ea43bfd1 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -166,7 +166,7 @@ typedef int (*sgx_enclave_user_handler_t)(long rdi, long rsi, long rdx,
>   * @exception_addr:		The address that triggered the exception
>   * @user_handler:		User provided callback run on exception
>   * @user_data:			Data passed to the user handler
> - * @reserved			Reserved for future extensions
> + * @reserved:			Reserved for future extensions
>   *
>   * If @user_handler is provided, the handler will be invoked on all return paths
>   * of the normal flow.  The user handler may transfer control, e.g. via a
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
