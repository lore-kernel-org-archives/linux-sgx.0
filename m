Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E0C1E5B9E;
	Sun, 25 Jan 2026 14:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769352335; cv=none; b=qxFHYslJFf22ZrGMbIHMuMcvY4bnmJfnNSchN+kKyig7zaOhq6kTzOMLtlkAIQ4ufFJmUZvgIBkk1jyKs/OqeGyKO6MENaGtLRMti3v0U6fgiu5qGaKIspTRSpEJEEO6RWPJsu/9DSajvbFTLI3b7oWKYwZGIpR/TWfKBFlKUNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769352335; c=relaxed/simple;
	bh=pgkOQSEjB2Sw/CI7QDlrl9YkRcVaVCAeiqMx1e8wmAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lrm1ab/sLBAF8Bw0PO6XuNpEf+EDDAwxWyvPu/JWBGjnI2jsJ94q990sYXHsJC8fgOE59q+Ira2tdNSykPN0HneetCLQolPawRKcfSZfH3GSgVIAmtIKM9LqVYynwvwKb8+vtjK6JkiCjOk4XSTzq8+z68ipK2IoryfNH2gp608=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6oL/QRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6oL/QRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B9AC4CEF1;
	Sun, 25 Jan 2026 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769352335;
	bh=pgkOQSEjB2Sw/CI7QDlrl9YkRcVaVCAeiqMx1e8wmAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m6oL/QRkuZtbyX55NjTdA/RX5Y8/r2M89CoYdUfLcpFzRoA0K7F7eNjkfN+GGx7uv
	 CM81trUqYgE9bH+7riIh4MBDGYKNwTZEYnFMMchLfwMWMc4ejzUdTimZLhM04amSRW
	 8YklSov1f57soG7M7qGS+w7RlLZ9xoCDPvT3eNDbGj3Q16Nov9tz9C4XR8MbOROy0k
	 OelfTp7OoEQ2kpOl5k5LgFVEC8IEdxih7mu4RRxB5Q0gTPG+HnjaPrjT9TyMYbzIEw
	 vy8il94ydSnTfHxu0DVX8rQpMDEARexPb26zQ9vGiPpwyc1KAGe6okjYiATBngqAgW
	 CWVXecugvd3cg==
Date: Sun, 25 Jan 2026 16:45:30 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Wentong Tian <tianwentong2000@gmail.com>
Cc: dave.hansen@linux.intel.com, tglx@kernel.org, mingo@redhat.com,
	bp@alien8.de, x86@kernel.org, linux-sgx@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: use vm_flags_t for vm_prot_bits
Message-ID: <aXYsikbf-2yMnJ1F@kernel.org>
References: <20260122055435.95911-1-tianwentong2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122055435.95911-1-tianwentong2000@gmail.com>

On Thu, Jan 22, 2026 at 01:54:35PM +0800, Wentong Tian wrote:
> The vm_flags_t type is the dedicated type for virtual memory flags.
> Architecture and driver code should use this type instead of assuming
> vm_flags is an unsigned long, as the underlying type may change in the
> future.
> 
> This follows the cleanup in commit d75fa3c94750 ("mm: update
> architecture and driver code to use vm_flags_t") by converting the
> remaining vm_prot_bits usage in SGX code.
> 
> No functional change intended.
> 
> Signed-off-by: Wentong Tian <tianwentong2000@gmail.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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
> -- 
> 2.34.1
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
