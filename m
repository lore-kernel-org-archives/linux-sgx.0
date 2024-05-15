Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854D048CFC;
	Wed, 15 May 2024 21:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715810363; cv=none; b=O1L8EG5ZZdPzp2BaMTZARH975FYEY/jraqs0xo0PCQMPIt+gcxBcyJY48HFBKtrTnNtdPfJ9igp6Yzgh/fkrFPD6u8Wo6lc9YMtxWPZgtvxXarX6DJJUWReh1XHzCd/bqSEl1boOqK9O0wKx3xcZBJDu5dozvyg2lvAlzMdFvL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715810363; c=relaxed/simple;
	bh=xwvsZL4xUOasLuqkQ5VnMErfdvO4hSnbY9rPdgYHnw8=;
	h=Content-Type:To:Cc:Subject:References:Date:MIME-Version:From:
	 Message-ID:In-Reply-To; b=UdaWrhdj/61FsK4O2RuJjIC77HUmt1XADy8YZJeP3UClZrBJT/9Ji9dPhi3rgCSwVmuhHq2GTR8Qa79XGM+bObSLqjTuhKowMbad8XCCM/vPPTZIG0H3KlmtD37q7SCvnq5RIFYfuppSbLC4BKUFxZ+FKLmAmjaULi88tg5+Wk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sagz+ON9; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sagz+ON9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715810362; x=1747346362;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=xwvsZL4xUOasLuqkQ5VnMErfdvO4hSnbY9rPdgYHnw8=;
  b=Sagz+ON96Zj72XFK3dbjyyE8kYm0CzZBlIW67c1aH+XKAkjUtJSMxb80
   uN1IOhWjjmurY/2T7gftjJubBMiUHAVa3YNATHwanDvYlD4SC644X1YXk
   ugm9opIcRXTsrAyl3kMzOd1pMKcsPrlbxDxkcYah/8ARBsW5j6G/IzJ1Y
   7zcGczMFCXDwrNUSd6cTQ01OA8t0fHFGv+vK+cChAZ1U6bIKdbpw3lVat
   6RnG2ORtE3r5nqLA4t+gEgUL2k693yyhDzmXs4hp8m7Z3Gb9U36C0Emw8
   ayYJVjD30DStjdT7y3TLnaj5A9lgrIwwncMv2oaAkW0ibHvMCwkS/TR32
   g==;
X-CSE-ConnectionGUID: 0I6/wIEdT52c1HZdLp4JpA==
X-CSE-MsgGUID: pTpVoTB+S7eDLzucn0Fqmg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22470042"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="22470042"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 14:59:21 -0700
X-CSE-ConnectionGUID: 2xWY3NV1Sw2lwqC/3ruNtQ==
X-CSE-MsgGUID: VrQJLRHBRIWE+xSyG5JefQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="68654177"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.92.17.168])
  by smtpauth.intel.com with ESMTP/TLS/AES256-SHA; 15 May 2024 14:59:20 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: dave.hansen@linux.intel.com, jarkko@kernel.org, kai.huang@intel.com,
 reinette.chatre@intel.com, linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Dmitrii Kuvaiskii"
 <dmitrii.kuvaiskii@intel.com>
Cc: mona.vij@intel.com, kailun.qin@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
References: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
 <20240515131240.1304824-3-dmitrii.kuvaiskii@intel.com>
Date: Wed, 15 May 2024 16:59:18 -0500
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.2nt104jcwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <20240515131240.1304824-3-dmitrii.kuvaiskii@intel.com>
User-Agent: Opera Mail/1.0 (Win32)

On Wed, 15 May 2024 08:12:40 -0500, Dmitrii Kuvaiskii  
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
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c  
> b/arch/x86/kernel/cpu/sgx/encl.c
> index 41f14b1a3025..7ccd8b2fce5f 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -257,7 +257,8 @@ static struct sgx_encl_page  
> *__sgx_encl_load_page(struct sgx_encl *encl,
> 	/* Entry successfully located. */
>  	if (entry->epc_page) {
> -		if (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)
> +		if (entry->desc & (SGX_ENCL_PAGE_BEING_RECLAIMED |
> +				   SGX_ENCL_PAGE_BEING_REMOVED))
>  			return ERR_PTR(-EBUSY);
> 		return entry;
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h  
> b/arch/x86/kernel/cpu/sgx/encl.h
> index f94ff14c9486..fff5f2293ae7 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -25,6 +25,9 @@
>  /* 'desc' bit marking that the page is being reclaimed. */
>  #define SGX_ENCL_PAGE_BEING_RECLAIMED	BIT(3)
> +/* 'desc' bit marking that the page is being removed. */
> +#define SGX_ENCL_PAGE_BEING_REMOVED	BIT(2)
> +
>  struct sgx_encl_page {
>  	unsigned long desc;
>  	unsigned long vm_max_prot_bits:8;
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c  
> b/arch/x86/kernel/cpu/sgx/ioctl.c
> index b65ab214bdf5..c542d4dd3e64 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -1142,6 +1142,7 @@ static long sgx_encl_remove_pages(struct sgx_encl  
> *encl,
>  		 * Do not keep encl->lock because of dependency on
>  		 * mmap_lock acquired in sgx_zap_enclave_ptes().
>  		 */
> +		entry->desc |= SGX_ENCL_PAGE_BEING_REMOVED;
>  		mutex_unlock(&encl->lock);
> 		sgx_zap_enclave_ptes(encl, addr);



Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>
