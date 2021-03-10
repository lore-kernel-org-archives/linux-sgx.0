Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4821C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 20:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6918664FCA
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 20:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhCJUgz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:36:55 -0500
Received: from mga07.intel.com ([134.134.136.100]:35868 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhCJUgX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Mar 2021 15:36:23 -0500
IronPort-SDR: yY1R1FbubAxVdMVP2ycA/QXwt7VEmXqiwp8ZvEdHud/HZk9+q6se9+SFahQyzm17l7hcSvVPws
 BGjcmmrRzecg==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="252577468"
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="252577468"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 12:36:22 -0800
IronPort-SDR: FLB+VvQuDdCBg9OG6QwBvOFLwAqjq9M4bMK9Mfom025xStVQUXEvMzyn/eCW0XeWhEvC0KTvZ2
 mavgNv32forg==
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="438038492"
Received: from xuhuiliu-mobl1.amr.corp.intel.com ([10.251.31.67])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 12:36:19 -0800
Message-ID: <d8e55c583c4d76f3c9e9722e73f35c0618e40623.camel@intel.com>
Subject: Re: [PATCH v3 2/5] x86/sgx: Use sgx_free_epc_page() in
 sgx_reclaim_pages()
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Date:   Thu, 11 Mar 2021 09:36:15 +1300
In-Reply-To: <YEjhjhBpYJ6i6EFD@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
         <20210303150323.433207-3-jarkko@kernel.org>
         <b223ea92-8b20-def3-7bd0-2cc44474bd78@intel.com>
         <YEjhjhBpYJ6i6EFD@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2021-03-10 at 17:11 +0200, Jarkko Sakkinen wrote:
> On Wed, Mar 03, 2021 at 08:59:17AM -0800, Dave Hansen wrote:
> > On 3/3/21 7:03 AM, Jarkko Sakkinen wrote:
> > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > index 52d070fb4c9a..ed99c60024dc 100644
> > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > @@ -305,7 +305,6 @@ static void sgx_reclaim_pages(void)
> > >  {
> > >  	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
> > >  	struct sgx_backing backing[SGX_NR_TO_SCAN];
> > > -	struct sgx_epc_section *section;
> > >  	struct sgx_encl_page *encl_page;
> > >  	struct sgx_epc_page *epc_page;
> > >  	pgoff_t page_index;
> > > @@ -378,11 +377,7 @@ static void sgx_reclaim_pages(void)
> > >  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> > >  		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
> > >  
> > > 
> > > 
> > > 
> > > 
> > > 
> > > 
> > > 
> > > -		section = &sgx_epc_sections[epc_page->section];
> > > -		spin_lock(&section->lock);
> > > -		list_add_tail(&epc_page->list, &section->page_list);
> > > -		section->free_cnt++;
> > > -		spin_unlock(&section->lock);
> > > +		sgx_free_epc_page(epc_page);
> > >  	}
> > >  }
> > 
> > In current upstream (3fb6d0e00e), sgx_free_epc_page() calls __eremove().
> >  This code does not call __eremove().  That seems to be changing
> > behavior where none was intended.
> 
> EREMOVE does not matter here, as it doesn't in almost all most of the sites
> where sgx_free_epc_page() is used in the driver. It does nothing to an
> uninitialized pages.

Right. EREMOVE on uninitialized pages does nothing, so a more reasonable way is to
just NOT call EREMOVE (your original code), since it is absolutely unnecessary.

I don't see ANY reason we should call EREMOVE here. 

Actually w/o my patch to split EREMOVE out of sgx_free_epc_page(), it then makes
perfect sense to have new sgx_free_epc_page() here.

> 
> The two patches that I posted originally for Kai's series took EREMOVE out
> of sgx_free_epc_page() and put an explicit EREMOVE where it is actually
> needed, but for reasons unknown to me, that change is gone.
> 

It's not gone. It goes into a new sgx_encl_free_epc_page(), which is exactly the same
as current sgx_free_epc_page() which as EREMOVE, instead of putting EREMOVE into a
dedicated sgx_reset_epc_page(), as you did in your series:

https://lore.kernel.org/linux-sgx/20210113233541.17669-1-jarkko@kernel.org/

However, your change has side effort: it always put page back into free pool, even
EREMOVE fails. To make your change w/o having any functional change, it has to be:

	if(!sgx_reset_epc_page())
		sgx_free_epc_page();

And for this, Dave raised one concern we should add a WARN() to let user know EPC
page is leaked, and reboot is requied to get them back.

However with sgx_reset_epc_page(), there's no place to add such WARN(), and
implementing original sgx_free_epc_page() as sgx_encl_free_epc_page() looks very
reasonable to me:

https://www.spinics.net/lists/linux-sgx/msg04631.html


> Replacing the ad-hoc code with sgx_free_epc_page() is absolutely the right
> action to take because it follows the pattern how sgx_free_epc_page() is
> used in the driver.
> 
> For reference:
> 
> https://lore.kernel.org/linux-sgx/20210113233541.17669-1-jarkko@kernel.org/
> 
> > Was this, perhaps, based on top of Kai's series that changes the
> > behavior of sgx_free_epc_page()?
> 
> I did not refer to that patch series.
> 
> /Jarkko


