Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A14C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 22:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A87B964FAD
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 22:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhCJWwo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Mar 2021 17:52:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:55279 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231998AbhCJWwZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Mar 2021 17:52:25 -0500
IronPort-SDR: LuKyxBNvw0NuQMHcwI/G54/Qm/Sh68cN2eHevTJARJ8g5u7U3Reh1msNYi5Kh+KVlBW6d2t6hZ
 1j5XRfWRulGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="249946420"
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="249946420"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 14:52:24 -0800
IronPort-SDR: pcxiQrQuu0aGSixmATswF77f+WUoZDINa7ajmyvvpEd/spUL0EWsZyfv0pcLMHQM4Hm06kA7Ms
 XMqv+wbVMc/A==
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="403864478"
Received: from xuhuiliu-mobl1.amr.corp.intel.com ([10.251.31.67])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 14:52:21 -0800
Message-ID: <6b9e71218f5ad43af46f32cf91fb3db068e49140.camel@intel.com>
Subject: Re: [PATCH v3 2/5] x86/sgx: Use sgx_free_epc_page() in
 sgx_reclaim_pages()
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Date:   Thu, 11 Mar 2021 11:52:19 +1300
In-Reply-To: <0fbd6e74ce70c64e9a5978b4b94f6df4e46a9d68.camel@intel.com>
References: <20210303150323.433207-1-jarkko@kernel.org>
         <20210303150323.433207-3-jarkko@kernel.org>
         <b223ea92-8b20-def3-7bd0-2cc44474bd78@intel.com>
         <YEjhjhBpYJ6i6EFD@kernel.org>
         <d8e55c583c4d76f3c9e9722e73f35c0618e40623.camel@intel.com>
         <YElD7orORGElfMdZ@kernel.org> <YElEQXZlzdrElovv@kernel.org>
         <YElJpEQ8KLa/HlLD@kernel.org>
         <0fbd6e74ce70c64e9a5978b4b94f6df4e46a9d68.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-03-11 at 11:43 +1300, Kai Huang wrote:
> On Thu, 2021-03-11 at 00:35 +0200, Jarkko Sakkinen wrote:
> > On Thu, Mar 11, 2021 at 12:12:17AM +0200, Jarkko Sakkinen wrote:
> > > On Thu, Mar 11, 2021 at 12:10:56AM +0200, Jarkko Sakkinen wrote:
> > > > On Thu, Mar 11, 2021 at 09:36:15AM +1300, Kai Huang wrote:
> > > > > On Wed, 2021-03-10 at 17:11 +0200, Jarkko Sakkinen wrote:
> > > > > > On Wed, Mar 03, 2021 at 08:59:17AM -0800, Dave Hansen wrote:
> > > > > > > On 3/3/21 7:03 AM, Jarkko Sakkinen wrote:
> > > > > > > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > > > > > > index 52d070fb4c9a..ed99c60024dc 100644
> > > > > > > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > > > > > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > > > > > > @@ -305,7 +305,6 @@ static void sgx_reclaim_pages(void)
> > > > > > > >  {
> > > > > > > >  	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
> > > > > > > >  	struct sgx_backing backing[SGX_NR_TO_SCAN];
> > > > > > > > -	struct sgx_epc_section *section;
> > > > > > > >  	struct sgx_encl_page *encl_page;
> > > > > > > >  	struct sgx_epc_page *epc_page;
> > > > > > > >  	pgoff_t page_index;
> > > > > > > > @@ -378,11 +377,7 @@ static void sgx_reclaim_pages(void)
> > > > > > > >  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> > > > > > > >  		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
> > > > > > > >  
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 
> > > > > > > > -		section = &sgx_epc_sections[epc_page->section];
> > > > > > > > -		spin_lock(&section->lock);
> > > > > > > > -		list_add_tail(&epc_page->list, &section->page_list);
> > > > > > > > -		section->free_cnt++;
> > > > > > > > -		spin_unlock(&section->lock);
> > > > > > > > +		sgx_free_epc_page(epc_page);
> > > > > > > >  	}
> > > > > > > >  }
> > > > > > > 
> > > > > > > In current upstream (3fb6d0e00e), sgx_free_epc_page() calls __eremove().
> > > > > > >  This code does not call __eremove().  That seems to be changing
> > > > > > > behavior where none was intended.
> > > > > > 
> > > > > > EREMOVE does not matter here, as it doesn't in almost all most of the sites
> > > > > > where sgx_free_epc_page() is used in the driver. It does nothing to an
> > > > > > uninitialized pages.
> > > > > 
> > > > > Right. EREMOVE on uninitialized pages does nothing, so a more reasonable way is to
> > > > > just NOT call EREMOVE (your original code), since it is absolutely unnecessary.
> > > > > 
> > > > > I don't see ANY reason we should call EREMOVE here. 
> > > > > 
> > > > > Actually w/o my patch to split EREMOVE out of sgx_free_epc_page(), it then makes
> > > > > perfect sense to have new sgx_free_epc_page() here.
> > > > > 
> > > > > > 
> > > > > > The two patches that I posted originally for Kai's series took EREMOVE out
> > > > > > of sgx_free_epc_page() and put an explicit EREMOVE where it is actually
> > > > > > needed, but for reasons unknown to me, that change is gone.
> > > > > > 
> > > > > 
> > > > > It's not gone. It goes into a new sgx_encl_free_epc_page(), which is exactly the same
> > > > > as current sgx_free_epc_page() which as EREMOVE, instead of putting EREMOVE into a
> > > > > dedicated sgx_reset_epc_page(), as you did in your series:
> > > > > 
> > > > > https://lore.kernel.org/linux-sgx/20210113233541.17669-1-jarkko@kernel.org/
> > > > > 
> > > > > However, your change has side effort: it always put page back into free pool, even
> > > > > EREMOVE fails. To make your change w/o having any functional change, it has to be:
> > > > > 
> > > > > 	if(!sgx_reset_epc_page())
> > > > > 		sgx_free_epc_page();
> > > > 
> > > > OK, great, your patch set uses the wrapper only in the necessary call
> > > > sites. Sorry, I overlooked this part.
> > > > 
> > > > Anyway, it knowingly does that. I considered either as equally harmful
> > > > side-ffects when I implemented. Either can only trigger, when there is a
> > > > bug in the kernel code.
> > > > 
> > > > It *could* do what that snippet suggest but it's like "out of the frying pan,
> > > > into the fire" kind of change.
> > > > 
> > > > Since NUMA patch set anyway requires to have a global dirty list, I think
> > > > the better way to deal with this, would be to declare a new global in the
> > > > patch under discussion:
> > > > 
> > > > static struct list_head sgx_dirty_list;
> > > 
> > > sgx_dirty_page_list
> > 
> > Actually, I think it is good as it is now. Please do nothing :-)
> > 
> > Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > I can continue from that and improve the fallback further. Not perfect, but
> > good enough.
> 
> Great. Thank you Jarkko.
> 
> I'll add your Acked-by and repost it since I also made a mistake in copy-paste:)
> 

Hmm.. This patch was originally from you, so it has From you, and has your SoB. It
also has Co-developed-by me, but does it still require Acked-by from you?

Anyway I have added it to my local. Let me know if I should remove it.

