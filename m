Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCFD15B129;
	Wed, 15 May 2024 22:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715810496; cv=none; b=Y4yH0YChWE6V0nScd3ioNvnPFTJEoawQnf6WvCFqOo6YXiTvQ7B5x+cx68yoJ4uJgKuzQzzIRf4qmPkBmNmHej/2Y1vtbA2nu6t2V/1ANQDuGkmfeQtnt+WpB2QflMYKLeIlvA58OvoUqpXnl6ho3dSo8ePOvRK8lgBzbyCUoeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715810496; c=relaxed/simple;
	bh=dHdfwlwPBvoCJJBjQTSgX8bbhsHk6BQcnw3m7mu29xQ=;
	h=Content-Type:To:Cc:Subject:References:Date:MIME-Version:From:
	 Message-ID:In-Reply-To; b=s7AZtcEjzxm+g9kK9IY1YrtIMfWR0xiThCwWl9pKMSek0ci+GPQpvD2maqTaufhTNA0BfDNnGiYEVDlgd44veDol99b2Ekm1+eU9ZO9gtRVgU7LEvsSKjynDYfir+ZDXTSFCbk1ElHoiA6/GAp6L5M9kRI+mS8kmmgDs4WNfm5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jt5/ik9B; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jt5/ik9B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715810495; x=1747346495;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=dHdfwlwPBvoCJJBjQTSgX8bbhsHk6BQcnw3m7mu29xQ=;
  b=jt5/ik9BJLLPCB4MxnAili2L/cZdKzxdplwRJBJJNsi9IPuOHoQuykXk
   cJDONQDzzO9cWfuKDWCd/h77sw+hBsuBKRgz2C87DIzg1PptffzdHInIg
   CnWtQCSjWIIAp9IIRrE9Jde+FhMuC9BDmIS1e6H5AGG/xAcLiccIUMTDp
   XsmN4XNT7g2VI6o+Jdp6dSs/DSIj0/1/d0b3f9XSOVwd/8qZo4MIUtfJp
   eYNFDhNy19tbxjmY9jlqcdAxnOfDQ460nGROi8VZViNqyx05Un2lc7oHl
   dqe8i494piCHSchxbtw2F/QBNgNpjlXv/lAGMhWT3kMylNHjEzMdUO55e
   g==;
X-CSE-ConnectionGUID: 7P/CSuPpRoGxl7qPxjezUA==
X-CSE-MsgGUID: Yq7sMt+bQZ633CNA35hCcQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22470250"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="22470250"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:01:35 -0700
X-CSE-ConnectionGUID: mY+sxc4RT1e2ocIjYMR7NQ==
X-CSE-MsgGUID: G9xxilN0Sf2bmVIkoe0ADQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="68654764"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.92.17.168])
  by smtpauth.intel.com with ESMTP/TLS/AES256-SHA; 15 May 2024 15:01:33 -0700
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: dave.hansen@linux.intel.com, jarkko@kernel.org, kai.huang@intel.com,
 reinette.chatre@intel.com, linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Dmitrii Kuvaiskii"
 <dmitrii.kuvaiskii@intel.com>
Cc: mona.vij@intel.com, kailun.qin@intel.com, stable@vger.kernel.org,
 =?utf-8?B?TWFyY2VsaW5hIEtvxZtjaWVsbmlja2E=?= <mwk@invisiblethingslab.com>
Subject: Re: [PATCH v2 1/2] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
References: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
 <20240515131240.1304824-2-dmitrii.kuvaiskii@intel.com>
Date: Wed, 15 May 2024 17:01:31 -0500
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: Quoted-Printable
From: "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.2nt14tziwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <20240515131240.1304824-2-dmitrii.kuvaiskii@intel.com>
User-Agent: Opera Mail/1.0 (Win32)

On Wed, 15 May 2024 08:12:39 -0500, Dmitrii Kuvaiskii  =

<dmitrii.kuvaiskii@intel.com> wrote:

> Two enclave threads may try to access the same non-present enclave pag=
e
> simultaneously (e.g., if the SGX runtime supports lazy allocation). Th=
e
> threads will end up in sgx_encl_eaug_page(), racing to acquire the
> enclave lock. The winning thread will perform EAUG, set up the page
> table entry, and insert the page into encl->page_array. The losing
> thread will then get -EBUSY on xa_insert(&encl->page_array) and procee=
d
> to error handling path.
>
> This race condition can be illustrated as follows:
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
>                                    epc_page =3D sgx_alloc_epc_page(...=
);
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
> The err_out_shrink error handling path contains two bugs: (1) function=

> sgx_encl_free_epc_page() is called that performs EREMOVE even though t=
he
> enclave page was never intended to be removed, and (2) SIGBUS is sent =
to
> userspace even though the enclave page is correctly installed by anoth=
er
> thread.
>
> The first bug renders the enclave page perpetually inaccessible (until=

> another SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl). This is because the page =
is
> marked accessible in the PTE entry but is not EAUGed, and any subseque=
nt
> access to this page raises a fault: with the kernel believing there to=

> be a valid VMA, the unlikely error code X86_PF_SGX encountered by code=

> path do_user_addr_fault() -> access_error() causes the SGX driver's
> sgx_vma_fault() to be skipped and user space receives a SIGSEGV instea=
d.
> The userspace SIGSEGV handler cannot perform EACCEPT because the page
> was not EAUGed. Thus, the user space is stuck with the inaccessible
> page. The second bug is less severe: a spurious SIGBUS signal is
> unnecessarily sent to user space.
>
> Fix these two bugs (1) by returning VM_FAULT_NOPAGE to the generic Lin=
ux
> fault handler so that no signal is sent to userspace, and (2) by
> replacing sgx_encl_free_epc_page() with sgx_free_epc_page() so that no=

> EREMOVE is performed.
>
> Note that sgx_encl_free_epc_page() performs an additional WARN_ON_ONCE=

> check in comparison to sgx_free_epc_page(): whether the EPC page is
> being reclaimer tracked. However, the EPC page is allocated in
> sgx_encl_eaug_page() and has zeroed-out flags in all error handling
> paths. In other words, the page is marked as reclaimable only in the
> happy path of sgx_encl_eaug_page(). Therefore, in the particular code
> path affected in this commit, the "page reclaimer tracked" condition i=
s
> always false and the warning is never printed. Thus, it is safe to
> replace sgx_encl_free_epc_page() with sgx_free_epc_page().
>
> Fixes: 5a90d2c3f5ef ("x86/sgx: Support adding of pages to an initializ=
ed  =

> enclave")
> Cc: stable@vger.kernel.org
> Reported-by: Marcelina Ko=C5=9Bcielnicka <mwk@invisiblethingslab.com>
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c  =

> b/arch/x86/kernel/cpu/sgx/encl.c
> index 279148e72459..41f14b1a3025 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -382,8 +382,11 @@ static vm_fault_t sgx_encl_eaug_page(struct  =

> vm_area_struct *vma,
>  	 * If ret =3D=3D -EBUSY then page was created in another flow while
>  	 * running without encl->lock
>  	 */
> -	if (ret)
> +	if (ret) {
> +		if (ret =3D=3D -EBUSY)
> +			vmret =3D VM_FAULT_NOPAGE;
>  		goto err_out_shrink;
> +	}
> 	pginfo.secs =3D (unsigned long)sgx_get_epc_virt_addr(encl->secs.epc_p=
age);
>  	pginfo.addr =3D encl_page->desc & PAGE_MASK;
> @@ -419,7 +422,7 @@ static vm_fault_t sgx_encl_eaug_page(struct  =

> vm_area_struct *vma,
>  err_out_shrink:
>  	sgx_encl_shrink(encl, va_page);
>  err_out_epc:
> -	sgx_encl_free_epc_page(epc_page);
> +	sgx_free_epc_page(epc_page);
>  err_out_unlock:
>  	mutex_unlock(&encl->lock);
>  	kfree(encl_page);

Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>
