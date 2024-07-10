Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C056192B8F;
	Wed, 10 Jul 2024 15:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720624597; cv=none; b=MJU2/JP9iQx7U5YK1RCk+uV8yM3dV74FgPoMsy7BSs2balWGgfDWU9kcqB6+NS9T9N8pslNws0aglf7WKN3NzJp8/9Nvl2lH2X9bawdNxKTnmoZwI+v+VZO81i8pNKugeRsyGuMBcxIcTE5H697bSlOY7CuuDzYOY1rkCH539T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720624597; c=relaxed/simple;
	bh=AqJNM5xdynP2MO5ef02aGJ/r8QOdCLqO8F1KMYv+ZNI=;
	h=Content-Type:To:Cc:Subject:References:Date:MIME-Version:From:
	 Message-ID:In-Reply-To; b=pYe5jhURqXM7UWlZPLs9aCV/UtZ6RTJeuXQAnEUYwmOJ/EUhmuTxcP7yFjOPhcbuq71IAX5wPhcno4/gFmvucJ7862wz2+EIpHNErlrcP6SMM8/d7xJGLbeAa8iDXDHEKs88BwU2W4xuUl1LqvITG+iKfdqXuiwzA92SX/bJmwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EW8eAuOO; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EW8eAuOO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720624595; x=1752160595;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=AqJNM5xdynP2MO5ef02aGJ/r8QOdCLqO8F1KMYv+ZNI=;
  b=EW8eAuOOPX0LNF0Ms8DgKGHD77k9AjGQTz0pF8soZduVeev9K4xxhuIc
   9h6FICq7Mv6U4r+OUuNyoiuZpkbvnr6mhx3s9iY7UKEMFfv9QZqr/pGWS
   AoOy8F6TMoODOODy5iGj2V+dkJZMXlduIsfasOK1Vanq4XTVhOm+aB36L
   DygpWXn1ZVkAkRUJis60vyArtkBFm71P2G2QncS3QUgMjM5fZXBsGOvGS
   sggEfLXE2bEcRY5VTQZ/yp6jcsSXrChWjbEyL3rpTH0Pv08MeB03EKJe0
   XaQf3UYVP70UXRJeCRqFHSDuaQzjDKrcZgtRSVvjMwPnJCv/2flIsM4MH
   A==;
X-CSE-ConnectionGUID: RSBuemH3Rw2nc2jDJzjodw==
X-CSE-MsgGUID: thRVckzcQLCdfMs3/YMK+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11129"; a="29349088"
X-IronPort-AV: E=Sophos;i="6.09,198,1716274800"; 
   d="scan'208";a="29349088"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 08:16:35 -0700
X-CSE-ConnectionGUID: cSgY6dgfRxeLhEzarRKTlw==
X-CSE-MsgGUID: BYcyqRB5Q3WwdaclekYFzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,198,1716274800"; 
   d="scan'208";a="53195652"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.246.119.97])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 10 Jul 2024 08:16:33 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: dave.hansen@linux.intel.com, jarkko@kernel.org, kai.huang@intel.com,
 reinette.chatre@intel.com, linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Dmitrii Kuvaiskii"
 <dmitrii.kuvaiskii@intel.com>
Cc: mona.vij@intel.com, kailun.qin@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
References: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
 <20240705074524.443713-4-dmitrii.kuvaiskii@intel.com>
Date: Wed, 10 Jul 2024 10:16:32 -0500
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.2qo8puuewjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <20240705074524.443713-4-dmitrii.kuvaiskii@intel.com>
User-Agent: Opera Mail/1.0 (Win32)

On Fri, 05 Jul 2024 02:45:24 -0500, Dmitrii Kuvaiskii  
<dmitrii.kuvaiskii@intel.com> wrote:

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
>   entry = sgx_encl_load_page(encl);
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
>                                    xa_load(&encl->page_array) != NULL ->
>                                    /*
>                                     * SGX driver thinks that this page
>                                     * was swapped out and loads it
>                                     */
>                                    mutex_lock(&encl->lock);
>                                    /*
>                                     * this is effectively a no-op
>                                     */
>                                    entry = sgx_encl_load_page_in_vma();
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
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c  
> b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 5d390df21440..02441883401d 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -1141,7 +1141,14 @@ static long sgx_encl_remove_pages(struct sgx_encl  
> *encl,
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
> +		entry->desc |= SGX_ENCL_PAGE_BUSY;
>  		mutex_unlock(&encl->lock);
> 		sgx_zap_enclave_ptes(encl, addr);

Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>
Thanks
Haitao
