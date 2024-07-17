Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0876374C2;
	Wed, 17 Jul 2024 10:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721212744; cv=none; b=lOBP5byDTnaGBInt3saehorOuZODS6N5R9cHgqghKPhDgP9t01U/XbmFfxP6fkArudkyNNv9jkuLjVjTm00Mdr1gCoYLb3lN89zjUeT3H+Od3lxHI8l5Fv9pBAmwTNYSo5PnDp+6sjivnODbISMm5L/MzHkd1C6eh5TrKvhpsg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721212744; c=relaxed/simple;
	bh=/2joJ6OWrM3T9+WwKJFjSZM8X5AF760AUd9+zeHl/g4=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=cgxD8adPMT0FWrwPBhOe3c5DS5AzutgJTFjvvWuWlW+MivhLxP/YJc5p/kjJGcBTD737UQ97bmqRbkakHVXOgDAnxw/mVsfQMQOH4Uu6RNROXYbSeWBDsLo5yVOgN+V/yAbpfjJYqOC2XuUWnfuzVQ298j9uB8QHXMD16tLTVb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKX25Rpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKX25Rpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8A6C32782;
	Wed, 17 Jul 2024 10:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721212743;
	bh=/2joJ6OWrM3T9+WwKJFjSZM8X5AF760AUd9+zeHl/g4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OKX25RpxStwLsMgnZAGwoqjEYQ8mYCWJtiSR3gM1M0xIOT4Z9e2Gtr72u7DxhahJG
	 VnqAC4WWxTAl/3gyOYkReaH+/afZXxO2BIOFfNdYDhUYI2wd0Uqln/MewahIFEuYbF
	 0Jy65H68HN82Q6g6g6K+SOWjNhATwMc+VK2IObE6NMqje3v/d73OKapbqnYd10mOhB
	 AnDq4zz2vHCOV73auTLEbxTo6Lr18LD2waCcDo0mbEFVUEhmzjv+iNiUId/W+kKv+z
	 kh20FhmHxqY6+TPYFLEDeftMAkAXkhpZaiCYY8udkzhN++ihy/i/BOqqMY8XzP1AoA
	 J57kWWkbH6SPQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jul 2024 13:38:59 +0300
Message-Id: <D2RQZSM3MMVN.8DFKF3GGGTWE@kernel.org>
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>,
 <dave.hansen@linux.intel.com>, <kai.huang@intel.com>,
 <haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
X-Mailer: aerc 0.17.0
References: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
 <20240705074524.443713-4-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240705074524.443713-4-dmitrii.kuvaiskii@intel.com>

On Fri Jul 5, 2024 at 10:45 AM EEST, Dmitrii Kuvaiskii wrote:
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
> Fixes: 9849bb27152c ("x86/sgx: Support complete page removal")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/io=
ctl.c
> index 5d390df21440..02441883401d 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -1141,7 +1141,14 @@ static long sgx_encl_remove_pages(struct sgx_encl =
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

Ditto.

BR, Jarkko
