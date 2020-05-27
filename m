Return-Path: <SRS0=yCNl=7J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B8BC433E1
	for <linux-sgx@archiver.kernel.org>; Wed, 27 May 2020 04:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD6E207D3
	for <linux-sgx@archiver.kernel.org>; Wed, 27 May 2020 04:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgE0EVV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 May 2020 00:21:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:26590 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728783AbgE0EVN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 May 2020 00:21:13 -0400
IronPort-SDR: mBROrqPJfqw3j5YDKi2ewskOpAI9cktD1Q0yJL1rDTEfs4Xjf64A6T4Tc88sGopNqS7HKf3u3M
 aQMQf15ts3nQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 21:21:12 -0700
IronPort-SDR: PcU5yY9E2pJLVa886AAhaZ6QEDa9HNDnDWDoPh4F7pmjAftHlkjufDsQ2GFY0ExYMpMoC1HHbQ
 2VgupNLrDaYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="256655293"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 26 May 2020 21:21:11 -0700
Date:   Tue, 26 May 2020 21:21:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 08/20] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20200527042111.GI31696@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-9-jarkko.sakkinen@linux.intel.com>
 <20200526125207.GE28228@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526125207.GE28228@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 26, 2020 at 02:52:08PM +0200, Borislav Petkov wrote:
> On Fri, May 15, 2020 at 03:43:58AM +0300, Jarkko Sakkinen wrote:
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 38424c1e8341..60d82e7537c8 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -13,6 +13,66 @@
> >  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> >  int sgx_nr_epc_sections;
> >  
> > +static struct sgx_epc_page *__sgx_try_alloc_page(struct sgx_epc_section *section)
> > +{
> > +	struct sgx_epc_page *page;
> > +
> > +	if (list_empty(&section->page_list))
> > +		return NULL;
> > +
> > +	page = list_first_entry(&section->page_list, struct sgx_epc_page, list);
> > +	list_del_init(&page->list);
> > +	return page;
> > +}
> > +
> > +/**
> > + * sgx_try_alloc_page() - Allocate an EPC page
> 
> Uuh, this is confusing. Looking forward into the patchset, you guys have
> 
> sgx_alloc_page()
> sgx_alloc_va_page()
>
> and this here
> 
> sgx_try_alloc_page()
> 
> So this one here should be called sgx_alloc_epc_page() if we're going to
> differentiate *what* it is allocating.

No objection to the rename.

> But then looking at sgx_alloc_page():
> 
> + * sgx_alloc_page() - Allocate an EPC page
> ...
> 
> + struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
> 
> this one returns a struct sgx_epc_page * too.
> 
> The former "allocates" from the EPC cache so I'm thinking former should
> not have "alloc" in its name at all. It should be called something like
> 
> sgx_get_epc_page()
> 
> or so.

> Now, looking at sgx_alloc_page(), it does call this one -
> sgx_try_alloc_page() to get a page from the page list but it
> does not allocate anything. The actual allocation happens in
> sgx_alloc_epc_section() which actually does the k*alloc().

Ah.  The Enclave Page Cache isn't actually a cache, and it's not a kernel
construct.  The EPC is really just Enclave Memory, but Intel really likes
three letter acronyms.  On current CPUs, the EPC is carved out of main
memory via range registers, i.e. it's a statically located and sized chunk
of DRAM with special access rules that are enforced by the CPU.  It's no
more of a cache than regular DRAM. 

In other words, sgx_alloc_epc_section() is poorly named.  It doesn't
actually allocate EPC, it allocates kernel structures to map and track EPC.
sgx_(un)map_epc_section() would be more accurate and would hopefully
alleviate some of the confusion.

> Which sounds to me like those functions should not use "alloc" and
> "free" in their names but "get" and "put" to denote that they're simply
> getting pages from lists and returning them back to those lists.
> 
> IMNSVHO.

A better analogy is k*alloc() == sgx_alloc_epc_page() and
__sgx_alloc_try_alloc_page() == alloc_pages_node().  EPC sections aren't
guaranteed to have a 1:1 relationship with NUMA nodes, but that holds true
for current platforms.

I have no objection to renaming __sgx_alloc_try_alloc_page() to something
like sgx_alloc_epc_page_section or whatever, but IMO using get/put will be
horrendously confusing.
