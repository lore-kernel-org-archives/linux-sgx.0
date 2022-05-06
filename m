Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341FBC433EF
	for <linux-sgx@archiver.kernel.org>; Fri,  6 May 2022 22:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355448AbiEFWqI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 May 2022 18:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444379AbiEFWqG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 6 May 2022 18:46:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6302961600
        for <linux-sgx@vger.kernel.org>; Fri,  6 May 2022 15:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00F0861029
        for <linux-sgx@vger.kernel.org>; Fri,  6 May 2022 22:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0250C385A8;
        Fri,  6 May 2022 22:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651876938;
        bh=MmHiSEvz3GabZoiPX6ApWyFHRMsNicLcpyv0s8UelM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WLVv5sSTunNUKArmaXjyB/rJrS6STllCtz14gRZGREchgTmxdMYxZP+05tUXAb/8C
         i3bz1KTZtp3AWYPFb+CdE/QJIcVnz156c0hFzyyF6b0yCTD7bGw568tGQuWJpDkwSE
         AehSG0Fzrl7J2SbesLb6Vp1b7OJIDqbASqkI9eGPtXwDI/24i6b4cCDmxpol1pub5d
         Ye9ij9p4W0JxQESVGzngfnPUfE+cx1GICn78GoTaQfMfZYaSsfHI32GzbsKBeyp1nb
         a05CBH8QWKbPUvRNRDfzSBfSRjA1NarB1efSArWLOMTSVn+l3Cqu0zAiN6uj9iGhbx
         E4aJTWUu9cdTw==
Date:   Sat, 7 May 2022 01:43:53 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        haitao.huang@intel.com
Subject: Re: [RFC PATCH 3/4] x86/sgx: Obtain backing storage page with
 enclave mutex held
Message-ID: <YnWkqTR/fPsuzD+E@kernel.org>
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <24fd9203331d11918b785c6a67f85d799d100be8.1651171455.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24fd9203331d11918b785c6a67f85d799d100be8.1651171455.git.reinette.chatre@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 28, 2022 at 01:11:26PM -0700, Reinette Chatre wrote:
> The SGX backing storage is accessed on two paths: when there
> are insufficient enclave pages in the EPC the reclaimer works
> to move enclave pages to the backing storage and as enclaves
> access pages that have been moved to the backing storage
> they are retrieved from there as part of page fault handling.
> 
> An oversubscribed SGX system will often run the reclaimer and
> page fault handler concurrently and needs to ensure that the
> backing store is accessed safely between the reclaimer and
> the page fault handler. The scenarios to consider here are:
> (a) faulting a page right after it was reclaimed,
> (b) faulting a page and reclaiming another page that are
>     sharing a PCMD page.
> 
> The reclaimer obtains pages from the backing storage without
> holding the enclave mutex and runs the risk of concurrently
> accessing the backing storage with the page fault handler that
> does access the backing storage with the enclave mutex held.
> 
> In the scenario below a page is written to the backing store
> by the reclaimer and then immediately faulted back, before
> the reclaimer is able to set the dirty bit of the page:
> 
> sgx_reclaim_pages() {                    sgx_vma_fault() {
> ...                                      ...
> /* write data to backing store */
> sgx_reclaimer_write();
>                                          mutex_lock(&encl->lock);
>                                          __sgx_encl_eldu() {
>                                          ...
>                                          /* page not dirty -
>                                           * contents may not be
>                                           * up to date
>                                          */
>                                          sgx_encl_get_backing();
>                                          ...
>                                          }
>                                          ...
> /* set page dirty */
> sgx_encl_put_backing();
> ...
>                                          mutex_unlock(&encl->lock);
> }                                        }
> 
> While it is not possible to concurrently reclaim and fault the same
> enclave page the PCMD pages are shared between enclave pages
> in the enclave and enclave pages in the backing store.
> In the below scenario a PCMD page is truncated from the backing
> store after all its pages have been loaded in to the enclave
> at the same time the PCMD page is loaded from the backing store
> when one of its pages are reclaimed:
> 
> sgx_reclaim_pages() {              sgx_vma_fault() {
>                                      ...
>                                      mutex_lock(&encl->lock);
>                                      ...
>                                      __sgx_encl_eldu() {
>                                        ...
>                                        if (pcmd_page_empty) {
> /*
>  * EPC page being reclaimed              /*
>  * shares a PCMD page with an             * PCMD page truncated
>  * enclave page that is being             * while requested from
>  * faulted in.                            * reclaimer.
>  */                                       */
> sgx_encl_get_backing()  <---------->      sgx_encl_truncate_backing_page()
>                                         }
> }                                    }
> 
> Protect the reclaimer's backing store access with the enclave's mutex
> to ensure that it can safely run concurrently with the page fault handler.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 0e8741a80cf3..ae79b8d6f645 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -252,6 +252,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>  	sgx_encl_ewb(epc_page, backing);
>  	encl_page->epc_page = NULL;
>  	encl->secs_child_cnt--;
> +	sgx_encl_put_backing(backing, true);
>  
>  	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
>  		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
> @@ -323,11 +324,14 @@ static void sgx_reclaim_pages(void)
>  			goto skip;
>  
>  		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
> +
> +		mutex_lock(&encl_page->encl->lock);
>  		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
> -		if (ret)
> +		if (ret) {
> +			mutex_unlock(&encl_page->encl->lock);
>  			goto skip;
> +		}
>  
> -		mutex_lock(&encl_page->encl->lock);
>  		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
>  		mutex_unlock(&encl_page->encl->lock);
>  		continue;
> @@ -355,7 +359,6 @@ static void sgx_reclaim_pages(void)
>  
>  		encl_page = epc_page->owner;
>  		sgx_reclaimer_write(epc_page, &backing[i]);
> -		sgx_encl_put_backing(&backing[i], true);
>  
>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
>  		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
> -- 
> 2.25.1
> 

I fully agree with your fix but also there I would open code the required
statements from sgx_encL_put_backing(). Let's render that out overtime.
It masks more than helps.

BR, Jarkko


