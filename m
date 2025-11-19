Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FAC27F195;
	Wed, 19 Nov 2025 02:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763519289; cv=none; b=hVUhZcSA8/jD9ch1z1q/XUGnXtUoF9yEpJM3t9CL++r9ltx5Ns/3yWj2kg/G9q9UvAcEvf0rVzsbZOUx2nGsuuOQedv22s92f3enw91/vVcY6c//bGBLCLV/fiTyWMTixOZG7+IMr1S0GzRAi9cNkGNmMTlosnaAkQGJVn7Nkdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763519289; c=relaxed/simple;
	bh=ds3t9oiursRwulJsjAjIbI8EDFY1DdFEzOjKUy/5OzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYZWCmTvXsNgazaZFKJ5SzAdyBFKaLhzHHaKORjcdF/gtHH0xEHDGzZHdCh7i+ATlDduM6h/vJWnhweG3cVKivsrYb9TmgRaC6t4NSz0lqPCkOL1aBjT9tWC7RW+VuGxGMh0HkoA/mjcZA6hB1Bd/CqJNMl62CTr6CjwvgPU6cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAvQt3PP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAvQt3PP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9FEC19422;
	Wed, 19 Nov 2025 02:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763519287;
	bh=ds3t9oiursRwulJsjAjIbI8EDFY1DdFEzOjKUy/5OzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hAvQt3PPBg7/sBSGLFfm5rFXvE8JEsTfl1QOHh1gBOjruWtjG6++L7BvkQZvO9Y7U
	 I2VFhyw3Fqp3jhqxjwcv2d2EB973H+6LbeD3b8K8GxFGOSj5KPybBZlG5SsIXtStW6
	 uPERbwrkq6luXxF1RmsNcvty7P32MOkbnaoEWGaukwXv6YGYys9sb0b/KuwfK180Vt
	 ZnVJEY3eZ8HvjZSYbOyNM5Ays5WGIuycLryP8Z+3o6oBY8sLUQ6fbC9iYb0eY3hyMp
	 M8JZolxHOkDlrm0J5OFrbItwH3tZpx5vEjHfRDWvweBLN3173fA7T7ayTI1YmZk1Ps
	 pRpjWEl0jkP7A==
Date: Wed, 19 Nov 2025 04:28:01 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2/5] x86/sgx: Add kernel-doc descriptions for params
 passed to vDSO user handler
Message-ID: <aR0rMfBDW_HjR_14@kernel.org>
References: <20251112160708.1343355-1-seanjc@google.com>
 <20251112160708.1343355-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112160708.1343355-3-seanjc@google.com>

On Wed, Nov 12, 2025 at 08:07:05AM -0800, Sean Christopherson wrote:
> Add kernel-doc markup for the register parameters passed by the vDSO blob
> to the user handler to suppress build warnings, e.g.
> 
>   WARNING: arch/x86/include/uapi/asm/sgx.h:157 function parameter 'r8' not
>            described in 'sgx_enclave_user_handler_t'
> 
> Call out that except for RSP, the registers are undefined on asynchronous
> exits as far as the vDSO ABI is concerned.  E.g. the vDSO's exception
> handler clobbers RDX, RDI, and RSI, and the kernel doesn't guarantee that
> R8 or R9 will be zero (the synthetic value loaded by the CPU).
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/all/20251106145506.145fc620@canb.auug.org.au
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/uapi/asm/sgx.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index a438ea43bfd1..0d408f001ac6 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -143,6 +143,12 @@ struct sgx_enclave_run;
>  /**
>   * typedef sgx_enclave_user_handler_t - Exit handler function accepted by
>   *					__vdso_sgx_enter_enclave()
> + * @rdi:	RDI at the time of EEXIT, undefined on AEX
> + * @rsi:	RSI at the time of EEXIT, undefined on AEX
> + * @rdx:	RDX at the time of EEXIT, undefined on AEX
> + * @rsp:	RSP (untrusted) at the time of EEXIT or AEX
> + * @r8:		R8 at the time of EEXIT, undefined on AEX
> + * @r9:		R9 at the time of EEXIT, undefined on AEX
>   * @run:	The run instance given by the caller
>   *
>   * The register parameters contain the snapshot of their values at enclave
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
