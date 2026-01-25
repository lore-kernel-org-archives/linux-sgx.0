Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236C4A937;
	Sun, 25 Jan 2026 14:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769352422; cv=none; b=d2k7TslQRcVV9s55bO/r3+omiD+KEcvKiu28ejaACtQh+NH38ti8VL9IO0PTa/8787i2Df9h8iZobfFmWd/j7dorYrybWrCVnJs9dvhdBcBSjbedrO3qgvCH9JtrZ/AiUTllLcAJAHqEJ1L5vNOqi6P/M9p0JE5X6k0AL1M1B8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769352422; c=relaxed/simple;
	bh=D4rZHek649r38ZMrKc0EUETSxogBTg6UND5Vy7tJuco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VVX58K/kySn7kJ/vc/ydpi0JuwyI7PURVcKLcsl1iTPt8oLHPC7Kj2Xlw4NRKAJWfnf83PYmqoM1yPW/e8QCmGzBqohSdfCa3DVZM/vddBUfCHNrv4x1hwpPIwp6wxzaHqY7bM8HxPCwKJrodb/6wx1nP9yZdIXTCmUh1rCfg3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aw0t/T1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aw0t/T1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A86AC4CEF1;
	Sun, 25 Jan 2026 14:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769352421;
	bh=D4rZHek649r38ZMrKc0EUETSxogBTg6UND5Vy7tJuco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Aw0t/T1+o7fdk6QYLzKKJivljnur6v67ACKvC4S8H+eVALhS5z2OftpOca/2ip1vT
	 mP+TErWLDAgv4hW1xmsBzRU9yZ8M/uOn87tjE5IDCqBOPPzvzbIsxsMl6EV+UL80Dy
	 tvJgIjkGAOSxz10G9q4hE52kHSfGRvpZwvs6p03OPaUGL00W6878lBlhoz0e1t0EAO
	 EMS3+DJHEjMUhiW5+resBf0NdRY49WZT2DFOKwn5xjHU3oaqq5kBOpu6IO3rDCwwHs
	 EIboBUhJdwLQr8OWBqzpJqvfpNrzLdLbP1dmo7BjOdCsX2AZ/I614TVnqN2xNKHVXk
	 TzdzzUx/4SWKA==
Date: Sun, 25 Jan 2026 16:46:57 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Wentong Tian <tianwentong2000@gmail.com>
Cc: dave.hansen@linux.intel.com, tglx@kernel.org, mingo@redhat.com,
	bp@alien8.de, x86@kernel.org, linux-sgx@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Message-ID: <aXYs4QyRrnDc_iDj@kernel.org>
References: <20260122133633.79792-1-tianwentong2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122133633.79792-1-tianwentong2000@gmail.com>

On Thu, Jan 22, 2026 at 09:36:33PM +0800, Wentong Tian wrote:
> The vm_flags_t type is the dedicated type for virtual memory flags.
> Architecture and driver code should use this type instead of assuming
> vm_flags is an unsigned long, as the underlying type may change in the
> future.
> 
> This follows the cleanup in commit d75fa3c94750 ("mm: update
> architecture and driver code to use vm_flags_t") by converting the
> remaining vm_prot_bits usage in SGX code. Also, update the vm_max_prot_bits
> type in struct sgx_encl_page to vm_flags_t for consistency.
> 
> No functional change intended.
> 
> Signed-off-by: Wentong Tian <tianwentong2000@gmail.com>
> ---
> v2:
>  - Also convert the type of vm_max_prot_bits in struct sgx_encl_page
>    to vm_flags_t, as suggested.
> 
>  arch/x86/kernel/cpu/sgx/encl.c | 2 +-
>  arch/x86/kernel/cpu/sgx/encl.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index cf149b9f4916..814edcde225d 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -281,7 +281,7 @@ static struct sgx_encl_page *sgx_encl_load_page_in_vma(struct sgx_encl *encl,
>  						       unsigned long addr,
>  						       vm_flags_t vm_flags)
>  {
> -	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
> +	vm_flags_t vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
>  	struct sgx_encl_page *entry;
>  
>  	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index 8ff47f6652b9..0e0b97e91905 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -27,7 +27,7 @@
>  
>  struct sgx_encl_page {
>  	unsigned long desc;
> -	unsigned long vm_max_prot_bits:8;
> +	vm_flags_t vm_max_prot_bits:8;
>  	enum sgx_page_type type:16;
>  	struct sgx_epc_page *epc_page;
>  	struct sgx_encl *encl;

OK, I missed the remark from Kai, but it is acceptable.

> -- 
> 2.34.1
> 

So again:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
