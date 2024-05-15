Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A7515572B;
	Wed, 15 May 2024 14:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715784268; cv=none; b=kB10PS4Yzk+oGotqAQWqjATEP/RuJq+k06JZy34Ql356VBcu1rqBy214qefeah5tiIXmAMlbZH0sNOL5rE6aHw2JllGcFU9rIWLFf5iEBukX0vo5I1uaEyiaVEhcOc14Uyx44F7Dzo5k+82CG/xpXOx3NLNdt98x4y5mdjNO/hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715784268; c=relaxed/simple;
	bh=QNqUB93y8PgV67K6mssFSCgz13UIfEW1Q2Kzl++uav4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=kCZKhcRlllMhRoSQUX9v3QpBaofm63Rp2KjKkZrAVpB9IFbjZ6Ob8cKAMOVh062ZK96GnDRPNNQV/qoLD/2KhpwhoIIfDcT7fWil0owhdmgT8mwAvciLg5miuN/1eVQ2s5o84gXxKvMzy4XBoySLH4EpXxldFfegyL5N01onwZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QdjLEVvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QdjLEVvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFDEC2BD11;
	Wed, 15 May 2024 14:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715784268;
	bh=QNqUB93y8PgV67K6mssFSCgz13UIfEW1Q2Kzl++uav4=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=QdjLEVvR2CEYcnKwb6NJneUBnDtWE/VzeQaGlaoi1H0RgMzowDEEl3P46MN25YrSk
	 5rrc3Zxc/3ATsJL9MijKiGLTki0Y8BKyAUqX3bg98WCwejdgxQCDOs2jvs1CFutqPn
	 BQhSD+P+0KLzD7vxjWXyQEvar6QVzyTOxU1sa+eekHznK9A/jNlmLgZkAs6M13q4SA
	 Y16JqRi6dyunFDBFCr7Matx7LMkTX1r64ci80EftXVNQ4YqQ3HCZVLmLezWouqCXAw
	 wphZ+J7I7pF3RrW11SJ8AQM2uBTDDkvxxpHW25HlEEJPbMR3F9Kl/seMwE7gHksT8U
	 mxYR0a8T8KtRQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 May 2024 17:44:24 +0300
Message-Id: <D1AARDFZXEXW.2K9IDHUO8FK29@kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>,
 <dave.hansen@linux.intel.com>, <kai.huang@intel.com>,
 <haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
 <20240515131240.1304824-3-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240515131240.1304824-3-dmitrii.kuvaiskii@intel.com>

On Wed May 15, 2024 at 4:12 PM EEST, Dmitrii Kuvaiskii wrote:
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
> introducing a new flag SGX_ENCL_PAGE_BEING_REMOVED, which is unset by
> default and set only right-before the first mutex_unlock() in
> sgx_encl_remove_pages(). Upon loading the page, CPU2 checks whether this
> page is being removed, and if yes then CPU2 backs off and waits until
> the page is completely removed. After that, any memory access to this
> page results in a normal "allocate and EAUG a page on #PF" flow.
>
> Fixes: 9849bb27152c ("x86/sgx: Support complete page removal")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c  | 3 ++-
>  arch/x86/kernel/cpu/sgx/encl.h  | 3 +++
>  arch/x86/kernel/cpu/sgx/ioctl.c | 1 +
>  3 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/enc=
l.c
> index 41f14b1a3025..7ccd8b2fce5f 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -257,7 +257,8 @@ static struct sgx_encl_page *__sgx_encl_load_page(str=
uct sgx_encl *encl,
> =20
>  	/* Entry successfully located. */
>  	if (entry->epc_page) {
> -		if (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)
> +		if (entry->desc & (SGX_ENCL_PAGE_BEING_RECLAIMED |
> +				   SGX_ENCL_PAGE_BEING_REMOVED))
>  			return ERR_PTR(-EBUSY);
> =20
>  		return entry;
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/enc=
l.h
> index f94ff14c9486..fff5f2293ae7 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -25,6 +25,9 @@
>  /* 'desc' bit marking that the page is being reclaimed. */
>  #define SGX_ENCL_PAGE_BEING_RECLAIMED	BIT(3)
> =20
> +/* 'desc' bit marking that the page is being removed. */
> +#define SGX_ENCL_PAGE_BEING_REMOVED	BIT(2)
> +
>  struct sgx_encl_page {
>  	unsigned long desc;
>  	unsigned long vm_max_prot_bits:8;
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/io=
ctl.c
> index b65ab214bdf5..c542d4dd3e64 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -1142,6 +1142,7 @@ static long sgx_encl_remove_pages(struct sgx_encl *=
encl,
>  		 * Do not keep encl->lock because of dependency on
>  		 * mmap_lock acquired in sgx_zap_enclave_ptes().
>  		 */
> +		entry->desc |=3D SGX_ENCL_PAGE_BEING_REMOVED;
>  		mutex_unlock(&encl->lock);
> =20
>  		sgx_zap_enclave_ptes(encl, addr);

Makes perfect sense:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
