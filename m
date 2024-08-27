Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3261D2F5A;
	Tue, 27 Aug 2024 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724782809; cv=none; b=oUF7/YoSJNxZSZVNokDLLaIRC/5e5ormNN6jkE3VunxqAgO7+Z6lVRklLyVulNuA2Wv0G5Jr4bQA2XTPMgADelrbQJhrMKt/SlyYJdVcIIDyT4eveeBcYH9ke/zEre0ifhgzp0ljyLidnk0Bth4KW2MUn/N8KA1/vrnzECm7wvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724782809; c=relaxed/simple;
	bh=FRABr4azaFuEXiK5Po2lpcwaS0CPZC0pZPz2hJV2pkY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=nvV2CHVM7iBu1aw96vKnThk/y6krd19vtRNfYdQpO98SnKa628ciuXXoeAjvsHs7wjoN+1P2fJO5rKjCpnFtiAAshP7ozHRrHgQmfI0gBsHiMuIuhe+3nt39WPlMbFuaAHTB0Bwx+Et2t27AXccZArjfL3RPb05WnwV7ftdTrFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+czxmJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+czxmJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A44FC4AF10;
	Tue, 27 Aug 2024 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724782808;
	bh=FRABr4azaFuEXiK5Po2lpcwaS0CPZC0pZPz2hJV2pkY=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=H+czxmJ0EUYvUWa9m2CYzscQxGJu3N9rNP7EXKGeba8nLtmM96JgXRFBNPdQLMXmm
	 mGI7rff0C97RIvANaoX4a9GkkZTdw2IetuZilGLkCrop05T0n5bbD/iGQ+lGhwcbiC
	 4glq86gS3D4wEAuYAziG0wOBb7KozBy0N+6X9C9aJG9qVEfO0wqTQLQ2x2Y9dSneBC
	 Z8LxLmSdwCliqW7tZ0EnZhyPTxUBKyLaA/SANxvg0r6coZzmSJzoJx2Di8cecpWnO9
	 JB/BfOpx6H54toy34MTu+RuIaBnlov0v+PBjYYvI/LJbus707PudinxjsxtI1br6+v
	 rvXB56PQOAHCQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Aug 2024 21:20:05 +0300
Message-Id: <D3QWH61GROZP.35B5OD2T7FZNZ@kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>,
 <dave.hansen@linux.intel.com>, <kai.huang@intel.com>,
 <haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240821100215.4119457-1-dmitrii.kuvaiskii@intel.com>
 <20240821100215.4119457-4-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240821100215.4119457-4-dmitrii.kuvaiskii@intel.com>

On Wed Aug 21, 2024 at 1:02 PM EEST, Dmitrii Kuvaiskii wrote:
> Two enclave threads may try to add and remove the same enclave page
> simultaneously (e.g., if the SGX runtime supports both lazy allocation
> and MADV_DONTNEED semantics). Consider some enclave page added to the
> enclave. User space decides to temporarily remove this page (e.g.,
> emulating the MADV_DONTNEED semantics) on CPU1. At the same time, user
> space performs a memory access on the same page on CPU2, which results
> in a #PF and ultimately in sgx_vma_fault(). Scenario proceeds as
> follows:
>
> /*
>  * CPU1: User space performs
>  * ioctl(SGX_IOC_ENCLAVE_REMOVE_PAGES)
>  * on enclave page X
>  */
> sgx_encl_remove_pages() {
>
>   mutex_lock(&encl->lock);
>
>   entry =3D sgx_encl_load_page(encl);
>   /*
>    * verify that page is
>    * trimmed and accepted
>    */
>
>   mutex_unlock(&encl->lock);
>
>   /*
>    * remove PTE entry; cannot
>    * be performed under lock
>    */
>   sgx_zap_enclave_ptes(encl);
>                                  /*
>                                   * Fault on CPU2 on same page X
>                                   */
>                                  sgx_vma_fault() {
>                                    /*
>                                     * PTE entry was removed, but the
>                                     * page is still in enclave's xarray
>                                     */
>                                    xa_load(&encl->page_array) !=3D NULL -=
>
>                                    /*
>                                     * SGX driver thinks that this page
>                                     * was swapped out and loads it
>                                     */
>                                    mutex_lock(&encl->lock);
>                                    /*
>                                     * this is effectively a no-op
>                                     */
>                                    entry =3D sgx_encl_load_page_in_vma();
>                                    /*
>                                     * add PTE entry
>                                     *
>                                     * *BUG*: a PTE is installed for a
>                                     * page in process of being removed
>                                     */
>                                    vmf_insert_pfn(...);
>
>                                    mutex_unlock(&encl->lock);
>                                    return VM_FAULT_NOPAGE;
>                                  }
>   /*
>    * continue with page removal
>    */
>   mutex_lock(&encl->lock);
>
>   sgx_encl_free_epc_page(epc_page) {
>     /*
>      * remove page via EREMOVE
>      */
>     /*
>      * free EPC page
>      */
>     sgx_free_epc_page(epc_page);
>   }
>
>   xa_erase(&encl->page_array);
>
>   mutex_unlock(&encl->lock);
> }
>
> Here, CPU1 removed the page. However CPU2 installed the PTE entry on the
> same page. This enclave page becomes perpetually inaccessible (until
> another SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl). This is because the page is
> marked accessible in the PTE entry but is not EAUGed, and any subsequent
> access to this page raises a fault: with the kernel believing there to
> be a valid VMA, the unlikely error code X86_PF_SGX encountered by code
> path do_user_addr_fault() -> access_error() causes the SGX driver's
> sgx_vma_fault() to be skipped and user space receives a SIGSEGV instead.
> The userspace SIGSEGV handler cannot perform EACCEPT because the page
> was not EAUGed. Thus, the user space is stuck with the inaccessible
> page.
>
> Fix this race by forcing the fault handler on CPU2 to back off if the
> page is currently being removed (on CPU1). This is achieved by
> setting SGX_ENCL_PAGE_BUSY flag right-before the first mutex_unlock() in
> sgx_encl_remove_pages(). Upon loading the page, CPU2 checks whether this
> page is busy, and if yes then CPU2 backs off and waits until the page is
> completely removed. After that, any memory access to this page results
> in a normal "allocate and EAUG a page on #PF" flow.
>
> Additionally fix a similar race: user space converts a normal enclave
> page to a TCS page (via SGX_IOC_ENCLAVE_MODIFY_TYPES) on CPU1, and at
> the same time, user space performs a memory access on the same page on
> CPU2. This fix is not strictly necessary (this particular race would
> indicate a bug in a user space application), but it gives a consistent
> rule: if an enclave page is under certain operation by the kernel with
> the mapping removed, then other threads trying to access that page are
> temporarily blocked and should retry.
>
> Fixes: 9849bb27152c ("x86/sgx: Support complete page removal")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.h  |  3 ++-
>  arch/x86/kernel/cpu/sgx/ioctl.c | 17 +++++++++++++++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/enc=
l.h
> index b566b8ad5f33..96b11e8fb770 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -22,7 +22,8 @@
>  /* 'desc' bits holding the offset in the VA (version array) page. */
>  #define SGX_ENCL_PAGE_VA_OFFSET_MASK	GENMASK_ULL(11, 3)
> =20
> -/* 'desc' bit indicating that the page is busy (being reclaimed). */
> +/* 'desc' bit indicating that the page is busy (being reclaimed, removed=
 or
> + * converted to a TCS page). */
>  #define SGX_ENCL_PAGE_BUSY	BIT(2)
> =20
>  /*
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/io=
ctl.c
> index 5d390df21440..ee619f2b3414 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -969,12 +969,22 @@ static long sgx_enclave_modify_types(struct sgx_enc=
l *encl,
>  			/*
>  			 * Do not keep encl->lock because of dependency on
>  			 * mmap_lock acquired in sgx_zap_enclave_ptes().
> +			 *
> +			 * Releasing encl->lock leads to a data race: while CPU1
> +			 * performs sgx_zap_enclave_ptes() and removes the PTE
> +			 * entry for the enclave page, CPU2 may attempt to load
> +			 * this page (because the page is still in enclave's
> +			 * xarray). To prevent CPU2 from loading the page, mark
> +			 * the page as busy before unlock and unmark after lock
> +			 * again.
>  			 */
> +			entry->desc |=3D SGX_ENCL_PAGE_BUSY;
>  			mutex_unlock(&encl->lock);
> =20
>  			sgx_zap_enclave_ptes(encl, addr);
> =20
>  			mutex_lock(&encl->lock);
> +			entry->desc &=3D ~SGX_ENCL_PAGE_BUSY;
> =20
>  			sgx_mark_page_reclaimable(entry->epc_page);
>  		}
> @@ -1141,7 +1151,14 @@ static long sgx_encl_remove_pages(struct sgx_encl =
*encl,
>  		/*
>  		 * Do not keep encl->lock because of dependency on
>  		 * mmap_lock acquired in sgx_zap_enclave_ptes().
> +		 *
> +		 * Releasing encl->lock leads to a data race: while CPU1
> +		 * performs sgx_zap_enclave_ptes() and removes the PTE entry
> +		 * for the enclave page, CPU2 may attempt to load this page
> +		 * (because the page is still in enclave's xarray). To prevent
> +		 * CPU2 from loading the page, mark the page as busy.
>  		 */
> +		entry->desc |=3D SGX_ENCL_PAGE_BUSY;
>  		mutex_unlock(&encl->lock);
> =20
>  		sgx_zap_enclave_ptes(encl, addr);

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
