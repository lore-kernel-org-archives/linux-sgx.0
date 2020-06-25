Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AC8C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 20:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29CDF20767
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 20:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405330AbgFYUz2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 16:55:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:59156 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405184AbgFYUz1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 16:55:27 -0400
IronPort-SDR: 3Sem9uUCndJnPauK8KKqZO9ZjjETWW875nGGPmXcJMdvd89i/x0sBkAgCEVUW6s0XXgwhTRI7P
 s1VZ9voSeobA==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="229804796"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="229804796"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 13:55:26 -0700
IronPort-SDR: H2kX/ypC4IrLeOWQfnoGzaLLbEEfEX8H3LnF0hIq1Olox27cM/jkWYvQNCXBStALC6gfGqaLvt
 DvEMyuswu+Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="479775209"
Received: from drews-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.49.247])
  by fmsmga005.fm.intel.com with ESMTP; 25 Jun 2020 13:55:16 -0700
Date:   Thu, 25 Jun 2020 23:55:05 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 09/21] x86/sgx: Add __sgx_alloc_epc_page() and
 sgx_free_epc_page()
Message-ID: <20200625205505.GD15394@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-10-jarkko.sakkinen@linux.intel.com>
 <20200625170648.GH20319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625170648.GH20319@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 07:06:48PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:31AM +0300, Jarkko Sakkinen wrote:
> > Add __sgx_alloc_epc_page(), which iterates through EPC sections and borrows
> > a page structure that is not used by anyone else. When a page is no longer
> > needed it must be released with sgx_free_epc_page(). This function
> > implicitly calls ENCLS[EREMOVE], which will return the page to the
> > uninitialized state (i.e. not required from caller part).
> > 
> > Acked-by: Jethro Beekman <jethro@fortanix.com>
> > Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 61 ++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/sgx/sgx.h  |  3 ++
> >  2 files changed, 64 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index c5831e3db14a..b776d249289f 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -83,6 +83,67 @@ static bool __init sgx_page_reclaimer_init(void)
> >  	return true;
> >  }
> >  
> > +static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_section *section)
> > +{
> > +	struct sgx_epc_page *page;
> > +
> > +	if (list_empty(&section->page_list))
> > +		return NULL;
> > +
> > +	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
> > +	list_del_init(&page->list);
> 
> <---- newline here.
> 
> > +	return page;
> > +}
> 
> Otherwise looks good; nice comments.

Thanks!

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarko
