Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE87C43333
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 02:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 065E0235F8
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 02:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbhANCN1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 Jan 2021 21:13:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:42325 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbhAMVla (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 13 Jan 2021 16:41:30 -0500
IronPort-SDR: yCCwq/m62RxHu5z7gaHapea9Zeim2yhf3JO6y7qsx0xfrqLH+i9xHB3GKJKML4wHT6+tlOktEN
 vf0jXSZC2ajg==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="178418939"
X-IronPort-AV: E=Sophos;i="5.79,345,1602572400"; 
   d="scan'208";a="178418939"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 13:40:48 -0800
IronPort-SDR: YhmcSYgmEv3hHsbQRBUyCYGDH+pFa9/6rKgFh6wWWACkG+ZYjGh3nvnT9ILavJfIEvQnQhMbsv
 WWSVfgShw8xQ==
X-IronPort-AV: E=Sophos;i="5.79,345,1602572400"; 
   d="scan'208";a="353636065"
Received: from cyalaman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.5.162])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 13:40:45 -0800
Date:   Thu, 14 Jan 2021 10:40:42 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 2/2] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210114104042.95da8258b2e3f9063ae79aba@intel.com>
In-Reply-To: <X/9hONWr8c9XLB14@kernel.org>
References: <20210112233351.68678-1-jarkko@kernel.org>
        <20210112233351.68678-3-jarkko@kernel.org>
        <20210113140917.d02dd73185604bc5d2f1501e@intel.com>
        <X/9hONWr8c9XLB14@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 13 Jan 2021 23:08:08 +0200 Jarkko Sakkinen wrote:
> On Wed, Jan 13, 2021 at 02:09:17PM +1300, Kai Huang wrote:
> > On Wed, 13 Jan 2021 01:33:51 +0200 jarkko@kernel.org wrote:
> > > From: "jarkko@kernel.org" <jarkko@kernel.org>
> > > 
> > > Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
> > > sgx_reset_epc_page(), which is a static helper function for
> > > sgx_encl_release(). It's the only function existing, which deals with
> > > initialized pages.
> > > 
> > > Signed-off-by: jarkko@kernel.org <jarkko@kernel.org>
> > > ---
> > > v2: Fixed a compilation error s/page/epc_page/ change not amended
> > >     to the patches.
> > >  arch/x86/kernel/cpu/sgx/encl.c | 15 ++++++++++++++-
> > >  arch/x86/kernel/cpu/sgx/main.c | 10 ++++------
> > >  2 files changed, 18 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > > index fe7256db6e73..511f4bc70699 100644
> > > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > > @@ -389,6 +389,16 @@ const struct vm_operations_struct sgx_vm_ops = {
> > >  	.access = sgx_vma_access,
> > >  };
> > >  
> > > +
> > > +static void sgx_reset_epc_page(struct sgx_epc_page *epc_page)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> > > +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
> > > +		return;
> > > +}
> > > +
> > >  /**
> > >   * sgx_encl_release - Destroy an enclave instance
> > >   * @kref:	address of a kref inside &sgx_encl
> > > @@ -412,6 +422,7 @@ void sgx_encl_release(struct kref *ref)
> > >  			if (sgx_unmark_page_reclaimable(entry->epc_page))
> > >  				continue;
> > >  
> > > +			sgx_reset_epc_page(entry->epc_page);
> > >  			sgx_free_epc_page(entry->epc_page);
> > >  			encl->secs_child_cnt--;
> > >  			entry->epc_page = NULL;
> > > @@ -423,6 +434,7 @@ void sgx_encl_release(struct kref *ref)
> > >  	xa_destroy(&encl->page_array);
> > >  
> > >  	if (!encl->secs_child_cnt && encl->secs.epc_page) {
> > > +		sgx_reset_epc_page(encl->secs.epc_page);
> > >  		sgx_free_epc_page(encl->secs.epc_page);
> > >  		encl->secs.epc_page = NULL;
> > >  	}
> > > @@ -431,7 +443,8 @@ void sgx_encl_release(struct kref *ref)
> > >  		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
> > >  					   list);
> > >  		list_del(&va_page->list);
> > > -		sgx_free_epc_page(va_page->epc_page);
> > > +		sgx_reset_epc_page(entry->epc_page);
> > > +		sgx_free_epc_page(entry->epc_page);
> > 
> > Reply so that Sean can see, since he just subscribed to linux-sgx list.
> > 
> > As Sean pointed out in KVM SGX virtualization thread, entry should be va_page.
> 
> Thank, noticed, and responded. I'm sending v3. I think it would be best to
> then include that version to KVM patch set, as there is no such a rush to
> get my patches to upstream. I already dropped them from my bleeding edge
> numa branch.

Sure. I'll take your patch once I see it. Thanks Jarkko.

