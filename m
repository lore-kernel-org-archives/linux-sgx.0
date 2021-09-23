Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B48C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Sep 2021 20:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8AF7611B0
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Sep 2021 20:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhIWUrj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 Sep 2021 16:47:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:21140 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhIWUri (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 Sep 2021 16:47:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10116"; a="204095851"
X-IronPort-AV: E=Sophos;i="5.85,317,1624345200"; 
   d="scan'208";a="204095851"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 13:46:06 -0700
X-IronPort-AV: E=Sophos;i="5.85,317,1624345200"; 
   d="scan'208";a="702898333"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 13:46:06 -0700
Date:   Thu, 23 Sep 2021 13:46:05 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org
Subject: Re: [PATCH v6 1/7] x86/sgx: Provide indication of life-cycle of EPC
 pages
Message-ID: <YUznjYO0TZuorE/2@agluck-desk2.amr.corp.intel.com>
References: <20210917213836.175138-1-tony.luck@intel.com>
 <20210922182123.200105-1-tony.luck@intel.com>
 <20210922182123.200105-2-tony.luck@intel.com>
 <5aa9e385b38ce0f63d6b531ede2baafd17fc7861.camel@kernel.org>
 <42f4b668b5abe818295d804d43c077e5d3cb4a4c.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42f4b668b5abe818295d804d43c077e5d3cb4a4c.camel@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 23, 2021 at 11:24:35PM +0300, Jarkko Sakkinen wrote:
> On Thu, 2021-09-23 at 23:21 +0300, Jarkko Sakkinen wrote:
> > On Wed, 2021-09-22 at 11:21 -0700, Tony Luck wrote:
> > > -		section->pages[i].owner = NULL;
> > > +		section->pages[i].owner = (void *)-1;
> > 
> > Probably should have a named constant.
> > 
> > Anyway, I wonder why we want to do tricks with 'owner', when the
> > struct has a flags field?
> > 
> > Right now its use is so nice and straight forward, and most
> > importantly intuitive.
> > 
> > So what I would do instead of this, would be to add something
> > like
> > 
> > /* Pages, which are being tracked by the page reclaimer. */
> > #define SGX_EPC_PAGE_RECLAIMER_TRACKED	BIT(0)
> > 
> > /* Pages, which are allocated for use. */
> > #define SGX_EPC_PAGE_ALLOCATED		BIT(1)
> > 
> > This would be set by sgx_alloc_epc_page() and reset by
> > sgx_free_epc_page().
> > 
> > In the subsequent patch you could then instead of
> > 
> >        /*
> >         * If there is no owner, then the page is on a free list.
> >         * Move it to the poison page list.
> >         */
> >        if (!page->owner) {
> >                list_del(&page->list);
> >                list_add(&page->list, &sgx_poison_page_list);
> >                goto out;
> >        }
> > 
> > you would
> > 
> >        /*
> >         * If there is no owner, then the page is on a free list.
> >         * Move it to the poison page list.
> >         */
> >        if (!page->flags) {
> >                list_del(&page->list);
> >                list_add(&page->list, &sgx_poison_page_list);
> >                goto out;
> >        }
> > 
> > You don't actually need to compare to that flag because the
> > invariant would be that it is set, as long as the page is
> > not explicitly freed.
> > 
> > I think this is a better solution than in the patch set
> > because it does not introduce any unorthodox use of anything.
> 
> And does not contain any special cases, e.g. when you debug
> something you can always assume that a valid owner pointer is
> always a legit sgx_encl_page instance.
> 
Jarkko,

That's nice. It avoids having to create a fictitious owner for
the dirty pages, and for the sgx_alloc_va_page() case. Which
in turn means that the owner field in struct sgx_epc_page can
remain as "struct sgx_encl_page *owner;" (neatly avoiding DaveH's
request that it be an anonymous union of all the possible types,
because it is back to just being one type).

Thanks!  Will include in next version.

-Tony
