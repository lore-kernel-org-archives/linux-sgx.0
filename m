Return-Path: <SRS0=2oz+=XM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228B6C4CEC9
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Sep 2019 23:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2115206C2
	for <linux-sgx@archiver.kernel.org>; Tue, 17 Sep 2019 23:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfIQXVU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 17 Sep 2019 19:21:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:60052 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728554AbfIQXVU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 17 Sep 2019 19:21:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 16:21:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,518,1559545200"; 
   d="scan'208";a="386705531"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 17 Sep 2019 16:21:19 -0700
Date:   Tue, 17 Sep 2019 16:21:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v3 09/17] x86/sgx: Move SGX_ENCL_DEAD check to
 sgx_reclaimer_write()
Message-ID: <20190917232119.GG10319@linux.intel.com>
References: <20190916101803.30726-1-jarkko.sakkinen@linux.intel.com>
 <20190916101803.30726-10-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916101803.30726-10-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 16, 2019 at 01:17:55PM +0300, Jarkko Sakkinen wrote:
> Do enclave state checks only in sgx_reclaimer_write(). Checking the
> enclave state is not part of the sgx_encl_ewb() flow. The check is done
> differently for SECS and for addressable pages.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Shay Katz-zamir <shay.katz-zamir@intel.com>
> Cc: Serge Ayoun <serge.ayoun@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/reclaim.c | 69 +++++++++++++++----------------
>  1 file changed, 34 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
> index e758a06919e4..a3e36f959c74 100644
> --- a/arch/x86/kernel/cpu/sgx/reclaim.c
> +++ b/arch/x86/kernel/cpu/sgx/reclaim.c
> @@ -308,47 +308,45 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
>  
>  	encl_page->desc &= ~SGX_ENCL_PAGE_RECLAIMED;
>  
> -	if (!(atomic_read(&encl->flags) & SGX_ENCL_DEAD)) {
> -		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
> -					   list);
> -		va_offset = sgx_alloc_va_slot(va_page);
> -		if (sgx_va_page_full(va_page))
> -			list_move_tail(&va_page->list, &encl->va_pages);
> +	va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
> +				   list);
> +	va_offset = sgx_alloc_va_slot(va_page);
> +	if (sgx_va_page_full(va_page))
> +		list_move_tail(&va_page->list, &encl->va_pages);
> +
> +	ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
> +			     page_index);
> +	if (ret == SGX_NOT_TRACKED) {
> +		ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
> +		if (ret) {
> +			if (encls_failed(ret) ||
> +			    encls_returned_code(ret))
> +				ENCLS_WARN(ret, "ETRACK");
> +		}
>  
>  		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
>  				     page_index);
>  		if (ret == SGX_NOT_TRACKED) {
> -			ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
> -			if (ret) {
> -				if (encls_failed(ret) ||
> -				    encls_returned_code(ret))
> -					ENCLS_WARN(ret, "ETRACK");
> -			}
> -
> -			ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
> -					     page_index);
> -			if (ret == SGX_NOT_TRACKED) {
> -				/*
> -				 * Slow path, send IPIs to kick cpus out of the
> -				 * enclave.  Note, it's imperative that the cpu
> -				 * mask is generated *after* ETRACK, else we'll
> -				 * miss cpus that entered the enclave between
> -				 * generating the mask and incrementing epoch.
> -				 */
> -				on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
> -						 sgx_ipi_cb, NULL, 1);
> -				ret = __sgx_encl_ewb(encl, epc_page, va_page,
> -						     va_offset, page_index);
> -			}
> +			/*
> +			 * Slow path, send IPIs to kick cpus out of the
> +			 * enclave.  Note, it's imperative that the cpu
> +			 * mask is generated *after* ETRACK, else we'll
> +			 * miss cpus that entered the enclave between
> +			 * generating the mask and incrementing epoch.
> +			 */
> +			on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
> +					 sgx_ipi_cb, NULL, 1);
> +			ret = __sgx_encl_ewb(encl, epc_page, va_page,
> +					     va_offset, page_index);
>  		}
> +	}
>  
> -		if (ret)
> -			if (encls_failed(ret) || encls_returned_code(ret))
> -				ENCLS_WARN(ret, "EWB");
> +	if (ret)
> +		if (encls_failed(ret) || encls_returned_code(ret))
> +			ENCLS_WARN(ret, "EWB");
>  
> -		encl_page->desc |= va_offset;
> -		encl_page->va_page = va_page;
> -	}
> +	encl_page->desc |= va_offset;
> +	encl_page->va_page = va_page;
>  }
>  
>  static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
> @@ -359,10 +357,11 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
>  
>  	mutex_lock(&encl->lock);
>  
> -	sgx_encl_ewb(epc_page, SGX_ENCL_PAGE_INDEX(encl_page));
>  	if (atomic_read(&encl->flags) & SGX_ENCL_DEAD) {
>  		ret = __eremove(sgx_epc_addr(epc_page));
>  		WARN(ret, "EREMOVE returned %d\n", ret);
> +	} else {
> +		sgx_encl_ewb(epc_page, SGX_ENCL_PAGE_INDEX(encl_page));

The sgx_encl_ewb() for SECS also needs to be skipped, otherwise we'll
attempt EWB on a dead enclave.  If the enclave is dead we can simply
free the SECS.

>  	}
>  
>  	encl_page->epc_page = NULL;
> -- 
> 2.20.1
> 
