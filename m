Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25311C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 12 May 2022 14:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355117AbiELONQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 May 2022 10:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355152AbiELONP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 12 May 2022 10:13:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C95B6352C
        for <linux-sgx@vger.kernel.org>; Thu, 12 May 2022 07:13:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17DD2B8282E
        for <linux-sgx@vger.kernel.org>; Thu, 12 May 2022 14:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADFFC385B8;
        Thu, 12 May 2022 14:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652364786;
        bh=gcb17IVsbP2Zr0q/5Buw678ZqOkBLH1mt4GUKCc8vUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pYYFfUridSm0ftCsiwBalEA5KbaazFNE8z1iu5GWafSCXXgkl7KgGNwj7wuxAzSDS
         Rn7KzF4nW6qYe+0JINC6/IUjfQc7VWmIfQ120lTrUsZhJk604gzGbUe0fosKS3Lj/3
         uPVPDe7ux6rbNnelcgSbRxeIPt/kH3Md5kf38lD6nd5emGgjQUBNrEG8J18wN9kf+f
         LwVk7y6/wXTBQ0NwrLnfZ6Z/Eiv7pq+7SGuhbddJ6aJI8jNrbYHFRbQ9KpA9iL1GNX
         O3KIwWry0+/pRZwSXP1rDThMcmCF2ZncwKmRwTHWbJhsUGGBkfolu+M3bOVAs8kryX
         0dwaqpkC0hmNA==
Date:   Thu, 12 May 2022 17:14:43 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org,
        haitao.huang@intel.com
Subject: Re: [PATCH V2 3/5] x86/sgx: Obtain backing storage page with enclave
 mutex held
Message-ID: <Yn0WU8Cw5yPpauen@iki.fi>
References: <cover.1652131695.git.reinette.chatre@intel.com>
 <b98b7b0d60778845eceb4e279b4354632b7111f2.1652131695.git.reinette.chatre@intel.com>
 <YnuacaADPcuAFkDB@kernel.org>
 <420e255f-08ba-9077-fb4d-8a5fa81fa1a1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <420e255f-08ba-9077-fb4d-8a5fa81fa1a1@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 11, 2022 at 11:02:47AM -0700, Reinette Chatre wrote:
> Hi Jarkko,
> 
> On 5/11/2022 4:13 AM, Jarkko Sakkinen wrote:
> > On Mon, May 09, 2022 at 02:48:01PM -0700, Reinette Chatre wrote:
> 
> ...
> 
> >> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> >> index fad3d6c4756e..a60f8b2780fb 100644
> >> --- a/arch/x86/kernel/cpu/sgx/main.c
> >> +++ b/arch/x86/kernel/cpu/sgx/main.c
> >> @@ -310,6 +310,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
> >>  	sgx_encl_ewb(epc_page, backing);
> >>  	encl_page->epc_page = NULL;
> >>  	encl->secs_child_cnt--;
> >> +	sgx_encl_put_backing(backing);
> >>  
> >>  	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
> >>  		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
> >> @@ -381,11 +382,14 @@ static void sgx_reclaim_pages(void)
> >>  			goto skip;
> >>  
> >>  		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
> >> +
> >> +		mutex_lock(&encl_page->encl->lock);
> >>  		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
> >> -		if (ret)
> >> +		if (ret) {
> >> +			mutex_unlock(&encl_page->encl->lock);
> >>  			goto skip;
> >> +		}
> >>  
> >> -		mutex_lock(&encl_page->encl->lock);
> >>  		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
> >>  		mutex_unlock(&encl_page->encl->lock);
> >>  		continue;
> >> @@ -413,7 +417,6 @@ static void sgx_reclaim_pages(void)
> >>  
> >>  		encl_page = epc_page->owner;
> >>  		sgx_reclaimer_write(epc_page, &backing[i]);
> >> -		sgx_encl_put_backing(&backing[i]);
> >>  
> >>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> >>  		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
> >> -- 
> >> 2.25.1
> >>
> > 
> > I get the locking part but why is the move of sgx_encl_put_backing
> > relevant?
> 
> Moving sgx_encl_put_backing() accomplishes the locking goal.
> 
> Before the patch:
> 
> sgx_reclaim_pages() {
> 	...
> 	sgx_reclaimer_write() {
> 		mutex_lock(&encl->lock);
> 		...
> 		mutex_unlock(&encl->lock);
> 	}
> 	sgx_encl_put_backing(); /* Not protected by enclave mutex */
> }
> 
> After the patch:
> 
> sgx_reclaim_pages() {
> 	...
> 	sgx_reclaimer_write() {
> 		mutex_lock(&encl->lock);
> 		...
> 			sgx_encl_put_backing(); /* Protected by enclave mutex */
> 		...
> 		mutex_unlock(&encl->lock);
> 	}
> 
> }

Right.

> Even so, because of patch 1/1 the first scenario described in the
> changelog is no longer valid since the page is marked as dirty
> with the enclave mutex held. It may thus not be required
> to call sgx_encl_put_backing() with enclave mutex held but it
> remains important for sgx_encl_get_backing() to be called with
> enclave mutex held since it ensures that SGX_ENCL_PAGE_BEING_RECLAIMED
> can be used (in patch 4/5) to reliably reflect references to the
> backing storage.
> Considering that I would like to continue to consistently protect
> sgx_encl_get_backing()/sgx_encl_put_backing() with the enclave mutex.

I fully agree with your conclusion.

> Reinette	

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

Also

Tested-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
