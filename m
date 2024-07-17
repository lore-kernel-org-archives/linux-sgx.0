Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9642374C2;
	Wed, 17 Jul 2024 10:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721212722; cv=none; b=CBa0rwk1MMJPzT9luA6jX194Yp5fHyTpYqMzHxs2caikIcfJO8/WLAgBWOSnLHJpVuoVpVA0hrJ4frVk6RkuIoq+yF+cWm1wUhsEDvLPT5Q9nCsBrg1I2Ib4TCiEWRBfSvJyvczmypgUoIMXJBF9XlSTwv1iZcWYGLO+dCxk818=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721212722; c=relaxed/simple;
	bh=cSmlak4IrX6c5dKpqBLYsz07DVXJmPYgqTwk39trJ44=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=BQuVwa+nrQMR8BH6Memqno1CSIzXIwIZbDkMaKi/0EMg3EG8JnzPCjk+qBmm7pSIRSxftfmOhQLj1Xl13hWYKBI09vROFPQGIBa3tXXmIuiz2C+hVx3AlGnyJt01CZOTMG5oBxbU+LXIrKMdmZh+LKa8FFZrM11HM6UpKhCTK7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnlsi64G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnlsi64G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609F1C32782;
	Wed, 17 Jul 2024 10:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721212721;
	bh=cSmlak4IrX6c5dKpqBLYsz07DVXJmPYgqTwk39trJ44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lnlsi64GkNqwS2ubzlMkO7aW5VbGb3gDID+Ig+3r7LDKA9IPe+OsPNohI/sL4sFr8
	 IbqsPFUN+nsRJMWXpMHepeae2JCXHkifIBEcTpYX+8MyPJuZkwTyzbMUutFF7vg8Nu
	 sr/Urake5Xq1eayNG5YhBmq5yKEYIj+TlaIidUYnCTUZA4hYWzWljJCD3R07MdvDLf
	 pwnP78qDp9mnweDhMRw4a2Z+rtVo01ZAfa5cjPsQYC0uwHfM0JUbi08REEHWV22/WX
	 fIsTt9Ih1mV5cQGiGwTKhIMEwMBIyApgDa0yJlr2HfrzKyZMFoUUVEu22RFSFJ5IKz
	 frUegVV+SGGmQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jul 2024 13:38:37 +0300
Message-Id: <D2RQZIG59264.2S8OC7IYWLA0F@kernel.org>
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>,
 <dave.hansen@linux.intel.com>, <kai.huang@intel.com>,
 <haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>,
 =?utf-8?q?Marcelina_Ko=C5=9Bcielnicka?= <mwk@invisiblethingslab.com>
Subject: Re: [PATCH v4 2/3] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
X-Mailer: aerc 0.17.0
References: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
 <20240705074524.443713-3-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240705074524.443713-3-dmitrii.kuvaiskii@intel.com>

On Fri Jul 5, 2024 at 10:45 AM EEST, Dmitrii Kuvaiskii wrote:
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
> Fix the SGX loser's behavior. Change the return code to VM_FAULT_NOPAGE
> to avoid SIGBUS and call sgx_free_epc_page() which avoids EREMOVE'ing
> the winner's page and only frees the page that the loser allocated.
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
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
> Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/enc=
l.c
> index c0a3c00284c8..9f7f9e57cdeb 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -380,8 +380,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_=
struct *vma,
>  	 * If ret =3D=3D -EBUSY then page was created in another flow while
>  	 * running without encl->lock
>  	 */
> -	if (ret)
> +	if (ret) {
> +		if (ret =3D=3D -EBUSY)
> +			vmret =3D VM_FAULT_NOPAGE;
>  		goto err_out_shrink;
> +	}
> =20
>  	pginfo.secs =3D (unsigned long)sgx_get_epc_virt_addr(encl->secs.epc_pag=
e);
>  	pginfo.addr =3D encl_page->desc & PAGE_MASK;
> @@ -417,7 +420,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_s=
truct *vma,
>  err_out_shrink:
>  	sgx_encl_shrink(encl, va_page);
>  err_out_epc:
> -	sgx_encl_free_epc_page(epc_page);
> +	sgx_free_epc_page(epc_page);
>  err_out_unlock:
>  	mutex_unlock(&encl->lock);
>  	kfree(encl_page);

Fixes should be in the head of the series so please reorder.

BR, Jarkko
