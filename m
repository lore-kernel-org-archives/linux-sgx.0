Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0137A1B4F09;
	Fri, 21 Aug 2026 01:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787274914; cv=none; b=qkBkeUaK/rgbo94t05FlLWU0mOagssGObdWzGbJOK6k+dnEBClDqCCS5xxp8MJiCJ1A7/kjESgWAS/VRvKuEGGwx4GDjIIPRMRhi1ALye4bKjyXgU0hJ7D7/UnXrzEdWoG6KQHzDV96rVP9TQ5OICUkaUyutR5cAMvjqdS+/cf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787274914; c=relaxed/simple;
	bh=50Y6lkWcvLg99Jaff5rPN7XOvSFF4NXVTrm97HURkhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QlDHrZZIv6DnLR6q3yO2pjbXPPg8OxghgRTzNym+cuSFiUKctFu8Dugo3SHf6CjlBIbHKIh1EAZ6M4L2/hrnanoz8RCR0vbBhiLba+ToGjDOqlvJRF9j0Yq0iPiTdc2fEfy1qaDe3yt6+z97x4hX9puQO48bab2DaLNEJ9tSDCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N773Re3M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N773Re3M"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 139D51F000E9;
	Fri, 21 Aug 2026 01:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787274912;
	bh=QJ+ZOkcJvqgVZqa83qiKZ103a1bAHpE522V76Yzvx6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N773Re3MuTXZy3wqhJiQXfMqbNNvsd4EKOGJBHHTnK++pMXaG31b0BYF8OkOKfz+V
	 r/c9GyWruxS7wwXcmQCDC/zWdGb17SrTIHT9vMw/AY/eSpYIgZmtUkn1troRa+xOgd
	 4sYP2eP2TB91AVhpuhTFVA2wqauM61ypf2z03/zd1Xs1weqxGu3BCOe/HaCB+H/u4P
	 G216+X0Cn0mG0SC70o9qB3/8SEgtYUbrKGVBhqImm2hmXVXQ6l0Q6uCi8heVkZLgmY
	 VBFxc7jKx7lo6dHf86S1OE4Wr0LyegXhdOzoezE9/YWj4Nh/bC+2LFzTbiy2g3IjEg
	 oYkwb/xhnK4GQ==
Date: Fri, 21 Aug 2026 04:15:08 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Drop enclave reference on MMU notifier
 registration failure
Message-ID: <aoemnGBuFlRVQ__n@kernel.org>
References: <20260814134020.1386599-1-ruoyuw560@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814134020.1386599-1-ruoyuw560@gmail.com>

On Fri, Aug 14, 2026 at 09:40:20PM +0800, Ruoyu Wang wrote:
> Each sgx_encl_mm instance holds an enclave reference so the enclave
> outlives its MMU notifier. sgx_encl_mm_add() acquires that reference
> before calling __mmu_notifier_register().
> 
> Notifier registration can fail while allocating subscription state or
> when mm_take_all_locks() is interrupted. In that case no notifier or
> mm_list entry takes ownership of encl_mm. The error path frees encl_mm
> but leaves the enclave reference behind, preventing the enclave and its
> resources from being released.
> 
> Drop the enclave reference before freeing the unpublished encl_mm. This
> balances the acquisition without changing the successful registration
> and teardown paths.
> 
> This issue was found by a static analysis checker and confirmed by
> manual source review.
> 
> Fixes: 2ade0d60939b ("x86/sgx: Maintain encl->refcount for each encl->mm_list entry")
> Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 3f0222d10f6e6..04fbf7e703e1e 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -866,6 +866,7 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
>  
>  	ret = __mmu_notifier_register(&encl_mm->mmu_notifier, mm);
>  	if (ret) {
> +		kref_put(&encl->refcount, sgx_encl_release);
>  		kfree(encl_mm);
>  		return ret;
>  	}
> -- 
> 2.51.0
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
