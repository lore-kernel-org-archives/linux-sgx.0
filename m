Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEFCC433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 11:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiEKLPa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 07:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiEKLP2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 07:15:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71507233A67
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 04:15:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 485CCB82215
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 11:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71FBC340F2;
        Wed, 11 May 2022 11:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652267723;
        bh=y+ElHL8xJPnSlkwUGu3DQVxJ5jLWTp+Gu5rm0H3mj/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GE66Pupn0j2nVSNGMYJAdqj77k/bDbj6XSMbKdKXua2LCcDkNjHOqxoICI3GRkewG
         TF8ld4WlQgh8OEHNgvNgxQejxwm88e1wjmDG/33XP4f7iefhGkaFjXZ0e1429b+pkd
         o6z590C8O0zetE8lY6zPlppRsL+RSF/NxsaV7QtMWT4uxp+27qknAzrgmusUP5Bryc
         Gs4JdGe1KzUK16FCZMe0RUqZnJkxkJ8+l1L4jr30e+IZ9LSLFiAWdb3M77osUFC4lh
         iw1TU0QrrVivFInJVwaxLLWN/j4BL+YIXliLD19mAREBoaXpuXdXIoP4P7tSVTvoZ1
         3JLnDZC7sa/AA==
Date:   Wed, 11 May 2022 14:13:53 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        haitao.huang@intel.com
Subject: Re: [PATCH V2 3/5] x86/sgx: Obtain backing storage page with enclave
 mutex held
Message-ID: <YnuacaADPcuAFkDB@kernel.org>
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <b98b7b0d60778845eceb4e279b4354632b7111f2.1652131695.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b98b7b0d60778845eceb4e279b4354632b7111f2.1652131695.git.reinette.chatre@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, May 09, 2022 at 02:48:01PM -0700, Reinette Chatre wrote:
> Haitao reported encountering a WARN triggered by the ENCLS[ELDU]
> instruction faulting with a #GP.
> 
> The WARN is encountered when the reclaimer evicts a range of
> pages from the enclave when the same pages are faulted back
> right away.
> 
> The SGX backing storage is accessed on two paths: when there
> are insufficient free pages in the EPC the reclaimer works
> to move enclave pages to the backing storage and as enclaves
> access pages that have been moved to the backing storage
> they are retrieved from there as part of page fault handling.
> 
> An oversubscribed SGX system will often run the reclaimer and
> page fault handler concurrently and needs to ensure that the
> backing store is accessed safely between the reclaimer and
> the page fault handler. This is not the case because the
> reclaimer accesses the backing store without the enclave mutex
> while the page fault handler accesses the backing store with
> the enclave mutex.
> 
> Two scenarios are considered to describe the consequences of
> the unsafe access:
> (a) Scenario: Fault a page right after it was reclaimed.
>     Consequence: The page is faulted by loading outdated data
>     into the enclave using ENCLS[ELDU] that faults when it checks
>     the MAC and PCMD data.
> (b) Scenario: Fault a page while reclaiming another page that
>     share a PCMD page.
>     Consequence: A race between the reclaimer and page fault
>     handler, the reclaimer attempting to access a PCMD at the
>     same time it is truncated by the page fault handler. This
>     could result in lost PCMD data. Data may still be
>     lost if the reclaimer wins the race, this is addressed in
>     the following patch.
> 
> The reclaimer accesses pages from the backing storage without
> holding the enclave mutex and runs the risk of concurrently
> accessing the backing storage with the page fault handler that
> does access the backing storage with the enclave mutex held.
> 
> The two scenarios ((a) and (b)) are shown below.
> 
> In scenario (a), a page is written to the backing store
> by the reclaimer and then immediately faulted back, before
> the reclaimer is able to set the dirty bit of the page:
> 
> sgx_reclaim_pages() {                    sgx_vma_fault() {
> ...                                      ...
>   sgx_reclaimer_write() {
>     mutex_lock(&encl->lock);
>     /* Write data to backing store */
>     mutex_unlock(&encl->lock);
>   }
>                                          mutex_lock(&encl->lock);
>                                          __sgx_encl_eldu() {
>                                            ...
>                                            /* Enclave backing store
>                                             * page not released
>                                             * nor marked dirty -
>                                             * contents may not be
>                                             * up to date.
>                                             */
>                                            sgx_encl_get_backing();
>                                            ...
>                                            /*
>                                             * Enclave data restored
>                                             * from backing store
>                                             * and PCMD pages that
>                                             * are not up to date.
>                                             * ENCLS[ELDU] faults
>                                             * because of MAC or PCMD
>                                             * checking failure.
>                                             */
>                                            sgx_encl_put_backing();
>                                          }
>                                          ...
> /* set page dirty */
> sgx_encl_put_backing();
> ...
>                                          mutex_unlock(&encl->lock);
> }                                        }
> 
> In scenario (b) below a PCMD page is truncated from the backing
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
>                                        mutex_unlock(&encl->lock);
> }                                    }
> 
> In scenario (b) there is a race between the reclaimer and the page fault
> handler when the reclaimer attempts to get access to the same PCMD page
> that is being truncated. This could result in the reclaimer writing to
> the PCMD page that is then truncated, causing the PCMD data to be lost,
> or in a new PCMD page being allocated. The lost PCMD data may still occur
> after protecting the backing store access with the mutex - this is fixed
> in the next patch. By ensuring the backing store is accessed with the mutex
> held the enclave page state can be made accurate with the
> SGX_ENCL_PAGE_BEING_RECLAIMED flag accurately reflecting that a page
> is in the process of being reclaimed.
> 
> Consistently protect the reclaimer's backing store access with the
> enclave's mutex to ensure that it can safely run concurrently with the
> page fault handler.
> 
> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> Reported-by: Haitao Huang <haitao.huang@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index fad3d6c4756e..a60f8b2780fb 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -310,6 +310,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>  	sgx_encl_ewb(epc_page, backing);
>  	encl_page->epc_page = NULL;
>  	encl->secs_child_cnt--;
> +	sgx_encl_put_backing(backing);
>  
>  	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
>  		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
> @@ -381,11 +382,14 @@ static void sgx_reclaim_pages(void)
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
> @@ -413,7 +417,6 @@ static void sgx_reclaim_pages(void)
>  
>  		encl_page = epc_page->owner;
>  		sgx_reclaimer_write(epc_page, &backing[i]);
> -		sgx_encl_put_backing(&backing[i]);
>  
>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
>  		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
> -- 
> 2.25.1
> 

I get the locking part but why is the move of sgx_encl_put_backing
relevant?

BR, Jarkko
