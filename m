Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557921C8FB0;
	Tue, 27 Aug 2024 18:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724782796; cv=none; b=LqNpF3E22v0Pe1yLV8+FhroChREldUnD+lWCFKoo0+vrIrMjmG8vH9A58BzgTiVpnECnCNEHyL/NcbcIjIUuRGNtfn49HUaMKlWXVf4St7FEvL4J99B++ekdWjvl4BZWYA9XxN1a1VgClb1oasQYQhqI2T+4xXp/DVbcbHUW+dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724782796; c=relaxed/simple;
	bh=ZQUXw99MA12ckKbpaqrt9zvlY5lW/PID+4UMlvpKv+o=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=flCxhcLBxcQrMst36MfNICTisXvFwm8I6as/o0uwwbo6Q2omPWEb8LP8qSsP6RrpCdxEGEQdI1PThOdsD+TKkgeycORKX9mj1VFte49BVpJSrySRAaKSe56/N6OoiyYosgO6AdIhD6KBvRxFWrVPg+aeAo+Su0TZm11BABtbu5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t5whJXwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t5whJXwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35A9C4AF0F;
	Tue, 27 Aug 2024 18:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724782796;
	bh=ZQUXw99MA12ckKbpaqrt9zvlY5lW/PID+4UMlvpKv+o=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=t5whJXwSKa9WHswwCj5aRBF/hC2ifA5CUp6WaMpwLz59CkM70OEXvhyYwJ6HH8ahS
	 ER9Q4YGoLIR26zYq8Lr9uR8+uQSkc4gGvC+C8UzSQ94Byt4wlIwynP5ZMlg7lfzHoV
	 6Ieveib9EjHL91Bxt6KmjVPmJ4Wjg4508euesRRt7QPc4AYa0HznIjPsplA+SI5ee8
	 HQ66SFWE8BG1BOSog3+7DVSSPLYDpQ2qeZXil7/etYvM4bMJfIpxDqbl1+bSAb4IIO
	 hW2JikghlKQWnJQagguoFlUnxFiHKN0g83SonG9NyX080T7pKmgnS1YCD7ckEEpRbD
	 vKxyWSQ5zPrPw==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Aug 2024 21:19:52 +0300
Message-Id: <D3QWH0D6PVDA.3RU74RKMW1AEZ@kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>,
 =?utf-8?q?Marcelina_Ko=C5=9Bcielnicka?= <mwk@invisiblethingslab.com>
Subject: Re: [PATCH v5 2/3] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>,
 <dave.hansen@linux.intel.com>, <kai.huang@intel.com>,
 <haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240821100215.4119457-1-dmitrii.kuvaiskii@intel.com>
 <20240821100215.4119457-3-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240821100215.4119457-3-dmitrii.kuvaiskii@intel.com>

On Wed Aug 21, 2024 at 1:02 PM EEST, Dmitrii Kuvaiskii wrote:
> Imagine an mmap()'d file. Two threads touch the same address at the same
> time and fault. Both allocate a physical page and race to install a PTE
> for that page. Only one will win the race. The loser frees its page, but
> still continues handling the fault as a success and returns
> VM_FAULT_NOPAGE from the fault handler.
>
> The same race can happen with SGX. But there's a bug: the loser in the
> SGX steers into a failure path. The loser EREMOVE's the winner's EPC
> page, then returns SIGBUS, likely killing the app.
>
> Fix the SGX loser's behavior. Check whether another thread already
> allocated the page and if yes, return with VM_FAULT_NOPAGE.
>
> The race can be illustrated as follows:
>
> /*                             /*
>  * Fault on CPU1                * Fault on CPU2
>  * on enclave page X            * on enclave page X
>  */                             */
> sgx_vma_fault() {              sgx_vma_fault() {
>
>   xa_load(&encl->page_array)     xa_load(&encl->page_array)
>       =3D=3D NULL -->                    =3D=3D NULL -->
>
>   sgx_encl_eaug_page() {         sgx_encl_eaug_page() {
>
>     ...                            ...
>
>     /*                             /*
>      * alloc encl_page              * alloc encl_page
>      */                             */
>                                    mutex_lock(&encl->lock);
>                                    /*
>                                     * alloc EPC page
>                                     */
>                                    epc_page =3D sgx_alloc_epc_page(...);
>                                    /*
>                                     * add page to enclave's xarray
>                                     */
>                                    xa_insert(&encl->page_array, ...);
>                                    /*
>                                     * add page to enclave via EAUG
>                                     * (page is in pending state)
>                                     */
>                                    /*
>                                     * add PTE entry
>                                     */
>                                    vmf_insert_pfn(...);
>
>                                    mutex_unlock(&encl->lock);
>                                    return VM_FAULT_NOPAGE;
>                                  }
>                                }
>                                /*
>                                 * All good up to here: enclave page
>                                 * successfully added to enclave,
>                                 * ready for EACCEPT from user space
>                                 */
>     mutex_lock(&encl->lock);
>     /*
>      * alloc EPC page
>      */
>     epc_page =3D sgx_alloc_epc_page(...);
>     /*
>      * add page to enclave's xarray,
>      * this fails with -EBUSY as this
>      * page was already added by CPU2
>      */
>     xa_insert(&encl->page_array, ...);
>
>   err_out_shrink:
>     sgx_encl_free_epc_page(epc_page) {
>       /*
>        * remove page via EREMOVE
>        *
>        * *BUG*: page added by CPU2 is
>        * yanked from enclave while it
>        * remains accessible from OS
>        * perspective (PTE installed)
>        */
>       /*
>        * free EPC page
>        */
>       sgx_free_epc_page(epc_page);
>     }
>
>     mutex_unlock(&encl->lock);
>     /*
>      * *BUG*: SIGBUS is returned
>      * for a valid enclave page
>      */
>     return VM_FAULT_SIGBUS;
>   }
> }
>
> Fixes: 5a90d2c3f5ef ("x86/sgx: Support adding of pages to an initialized =
enclave")
> Cc: stable@vger.kernel.org
> Reported-by: Marcelina Ko=C5=9Bcielnicka <mwk@invisiblethingslab.com>
> Suggested-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 36 ++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/enc=
l.c
> index c0a3c00284c8..2aa7ced0e4a0 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -337,6 +337,16 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_=
struct *vma,
>  	if (!test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
>  		return VM_FAULT_SIGBUS;
> =20
> +	mutex_lock(&encl->lock);
> +
> +	/*
> +	 * Multiple threads may try to fault on the same page concurrently.
> +	 * Re-check if another thread has already done that.
> +	 */
> +	encl_page =3D xa_load(&encl->page_array, PFN_DOWN(addr));
> +	if (encl_page)
> +		goto done;
> +
>  	/*
>  	 * Ignore internal permission checking for dynamically added pages.
>  	 * They matter only for data added during the pre-initialization
> @@ -345,23 +355,23 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area=
_struct *vma,
>  	 */
>  	secinfo_flags =3D SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X;
>  	encl_page =3D sgx_encl_page_alloc(encl, addr - encl->base, secinfo_flag=
s);
> -	if (IS_ERR(encl_page))
> -		return VM_FAULT_OOM;
> -
> -	mutex_lock(&encl->lock);
> +	if (IS_ERR(encl_page)) {
> +		vmret =3D VM_FAULT_OOM;
> +		goto err_out_unlock;
> +	}
> =20
>  	epc_page =3D sgx_encl_load_secs(encl);
>  	if (IS_ERR(epc_page)) {
>  		if (PTR_ERR(epc_page) =3D=3D -EBUSY)
>  			vmret =3D VM_FAULT_NOPAGE;
> -		goto err_out_unlock;
> +		goto err_out_encl;
>  	}
> =20
>  	epc_page =3D sgx_alloc_epc_page(encl_page, false);
>  	if (IS_ERR(epc_page)) {
>  		if (PTR_ERR(epc_page) =3D=3D -EBUSY)
>  			vmret =3D  VM_FAULT_NOPAGE;
> -		goto err_out_unlock;
> +		goto err_out_encl;
>  	}
> =20
>  	va_page =3D sgx_encl_grow(encl, false);
> @@ -376,10 +386,6 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_=
struct *vma,
> =20
>  	ret =3D xa_insert(&encl->page_array, PFN_DOWN(encl_page->desc),
>  			encl_page, GFP_KERNEL);
> -	/*
> -	 * If ret =3D=3D -EBUSY then page was created in another flow while
> -	 * running without encl->lock
> -	 */
>  	if (ret)
>  		goto err_out_shrink;
> =20
> @@ -389,7 +395,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_s=
truct *vma,
> =20
>  	ret =3D __eaug(&pginfo, sgx_get_epc_virt_addr(epc_page));
>  	if (ret)
> -		goto err_out;
> +		goto err_out_eaug;
> =20
>  	encl_page->encl =3D encl;
>  	encl_page->epc_page =3D epc_page;
> @@ -408,20 +414,20 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area=
_struct *vma,
>  		mutex_unlock(&encl->lock);
>  		return VM_FAULT_SIGBUS;
>  	}
> +done:
>  	mutex_unlock(&encl->lock);
>  	return VM_FAULT_NOPAGE;
> =20
> -err_out:
> +err_out_eaug:
>  	xa_erase(&encl->page_array, PFN_DOWN(encl_page->desc));
> -
>  err_out_shrink:
>  	sgx_encl_shrink(encl, va_page);
>  err_out_epc:
>  	sgx_encl_free_epc_page(epc_page);
> +err_out_encl:
> +	kfree(encl_page);
>  err_out_unlock:
>  	mutex_unlock(&encl->lock);
> -	kfree(encl_page);
> -
>  	return vmret;
>  }
> =20

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
