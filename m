Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85686C4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 02:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 616F523359
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 02:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbhANCSe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 Jan 2021 21:18:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728979AbhAMVHb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 13 Jan 2021 16:07:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0C5B21D95;
        Wed, 13 Jan 2021 21:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610572093;
        bh=Ka2MpYcNBAmgYF+C+pNwC6sPLN/J6QceD2sMyARhchM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lSH8EkizxUchF3nisOrsAx43e/QsOlJdiQd/uesipmGvW9YS/sLgf3GkhXxV/ofK9
         5ouVmk5bZH0HxTxXHvPwh366euqTbZ11sUZXA0p4ye3O4eMVeBMeGOs2BRYsasGyJM
         GpeVdlu7MQlvotg0EkIUh7deSdYb6vDWQn1PlEjDos8Oz5TCxZPPlG38z6fub1rcWr
         oC/h9zqGnGKmB2JXmAm5SaJYyQJM7RGr0TBUJ6jptCB1wi21V99CXhNcVIihR0Ktcy
         IY628cg2SGGTt12yOZHFbJhUuau6Fj1NH526OMu2Twl3JtSbJ9nBwh4UbYWh/EMCSb
         sGU8rt8eLqJbA==
Date:   Wed, 13 Jan 2021 23:08:08 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 2/2] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
Message-ID: <X/9hONWr8c9XLB14@kernel.org>
References: <20210112233351.68678-1-jarkko@kernel.org>
 <20210112233351.68678-3-jarkko@kernel.org>
 <20210113140917.d02dd73185604bc5d2f1501e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113140917.d02dd73185604bc5d2f1501e@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 13, 2021 at 02:09:17PM +1300, Kai Huang wrote:
> On Wed, 13 Jan 2021 01:33:51 +0200 jarkko@kernel.org wrote:
> > From: "jarkko@kernel.org" <jarkko@kernel.org>
> > 
> > Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
> > sgx_reset_epc_page(), which is a static helper function for
> > sgx_encl_release(). It's the only function existing, which deals with
> > initialized pages.
> > 
> > Signed-off-by: jarkko@kernel.org <jarkko@kernel.org>
> > ---
> > v2: Fixed a compilation error s/page/epc_page/ change not amended
> >     to the patches.
> >  arch/x86/kernel/cpu/sgx/encl.c | 15 ++++++++++++++-
> >  arch/x86/kernel/cpu/sgx/main.c | 10 ++++------
> >  2 files changed, 18 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index fe7256db6e73..511f4bc70699 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -389,6 +389,16 @@ const struct vm_operations_struct sgx_vm_ops = {
> >  	.access = sgx_vma_access,
> >  };
> >  
> > +
> > +static void sgx_reset_epc_page(struct sgx_epc_page *epc_page)
> > +{
> > +	int ret;
> > +
> > +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> > +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
> > +		return;
> > +}
> > +
> >  /**
> >   * sgx_encl_release - Destroy an enclave instance
> >   * @kref:	address of a kref inside &sgx_encl
> > @@ -412,6 +422,7 @@ void sgx_encl_release(struct kref *ref)
> >  			if (sgx_unmark_page_reclaimable(entry->epc_page))
> >  				continue;
> >  
> > +			sgx_reset_epc_page(entry->epc_page);
> >  			sgx_free_epc_page(entry->epc_page);
> >  			encl->secs_child_cnt--;
> >  			entry->epc_page = NULL;
> > @@ -423,6 +434,7 @@ void sgx_encl_release(struct kref *ref)
> >  	xa_destroy(&encl->page_array);
> >  
> >  	if (!encl->secs_child_cnt && encl->secs.epc_page) {
> > +		sgx_reset_epc_page(encl->secs.epc_page);
> >  		sgx_free_epc_page(encl->secs.epc_page);
> >  		encl->secs.epc_page = NULL;
> >  	}
> > @@ -431,7 +443,8 @@ void sgx_encl_release(struct kref *ref)
> >  		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
> >  					   list);
> >  		list_del(&va_page->list);
> > -		sgx_free_epc_page(va_page->epc_page);
> > +		sgx_reset_epc_page(entry->epc_page);
> > +		sgx_free_epc_page(entry->epc_page);
> 
> Reply so that Sean can see, since he just subscribed to linux-sgx list.
> 
> As Sean pointed out in KVM SGX virtualization thread, entry should be va_page.

Thank, noticed, and responded. I'm sending v3. I think it would be best to
then include that version to KVM patch set, as there is no such a rush to
get my patches to upstream. I already dropped them from my bleeding edge
numa branch.

/Jarkko
