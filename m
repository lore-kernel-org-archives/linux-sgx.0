Return-Path: <SRS0=RnOm=7L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11659C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 03:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC32520DD4
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 03:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437141AbgE2Dir (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 May 2020 23:38:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:60881 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436976AbgE2Dir (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 May 2020 23:38:47 -0400
IronPort-SDR: RmS+NA5X7ve+mSJLULcfAxFqcIGKGVqqkYpQglUdjOdfxM9Z5Zkn2u4y98WJtVTCmcA0vBiG4n
 ryKEu5urIY4Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 20:38:46 -0700
IronPort-SDR: srrZt4gXFrrJaj61QY8iym0VMpVidDaNCFWzex459ZE0DrikXr4RroEFkjyN5A5GkXGPp3Wzvd
 QRf9YXr1lZow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="292232848"
Received: from pratuszn-mobl.ger.corp.intel.com (HELO localhost) ([10.252.58.65])
  by fmsmga004.fm.intel.com with ESMTP; 28 May 2020 20:38:37 -0700
Date:   Fri, 29 May 2020 06:38:36 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com, Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 08/20] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20200529033836.GD6182@linux.intel.com>
References: <20200526125207.GE28228@zn.tnic>
 <20200527042111.GI31696@linux.intel.com>
 <20200527204638.GG1721@zn.tnic>
 <20200528012319.GA7577@linux.intel.com>
 <20200528013617.GD25962@linux.intel.com>
 <20200528065223.GB188849@linux.intel.com>
 <20200528171635.GB382@zn.tnic>
 <20200528190718.GA2147934@linux.intel.com>
 <20200528195917.GF30353@linux.intel.com>
 <20200529032816.GC6182@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529032816.GC6182@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 29, 2020 at 06:28:28AM +0300, Jarkko Sakkinen wrote:
> On Thu, May 28, 2020 at 12:59:17PM -0700, Sean Christopherson wrote:
> > On Thu, May 28, 2020 at 10:07:18PM +0300, Jarkko Sakkinen wrote:
> > > On Thu, May 28, 2020 at 07:16:35PM +0200, Borislav Petkov wrote:
> > > > Lemme reply to all mails with one. :-)
> > > > And except those last two. Those are allocating a page from the EPC
> > > > sections so I'd call them:
> > > > 
> > > > sgx_try_alloc_page    -> sgx_alloc_epc_page_section
> > > > __sgx_try_alloc_page  -> __sgx_alloc_epc_page_section
> > > > 
> > > > former doing the loop, latter doing the per-section list games.
> > > 
> > > sgx_alloc_epc_page_section() is a bit nasty and long name to use for
> > > grabbing a page. And even the documentation spoke about grabbing before
> > > this naming discussion. I think it is a great description what is going
> > > on.  Everytime I talk about the subject I talk about grabbing.
> > > Lets just say that your suggestion, I could not use in a conference
> > > talk as a verb when I describe what is going on. That function > > > signature does not fit to my mouth :-) I would talk about
> > > grabbing a page.
> > 
> > "allocate an EPC page from the specified section"
> > 
> > It also works if/when we add NUMA awareness, e.g. sgx_alloc_epc_page_node()
> > means "allocate an EPC page from the specified node".  Note that I'm not
> > inventing these from scratch, simply stealing them from alloc_pages() and
> > alloc_pages_node().  The section thing is unique to SGX, but the underlying
> > concept is the same.
> 
> Then it should be sgx_alloc_epc_page_from_section() if you go with that.
> Otherwise it is mixes too much with the section. I did read these mails
> first quickly and first thought that functions were doing something with
> sgx_epc_section and not with pages.
> 
> Only with a deeper look that it's the name for allocating a page.
> 
> I think both names are waste of screen estate. Too long.
> 
> > >  * sgx_grab_page() - Grab a free EPC page
> > >  * @owner:	the owner of the EPC page
> > >  * @reclaim:	reclaim pages if necessary
> > >  *
> > >  * Iterate through EPC sections and borrow a free EPC page to the caller. When a
> > >  * page is no longer needed it must be released with sgx_free_page(). If
> > >  * @reclaim is set to true, directly reclaim pages when we are out of pages. No
> > >  * mm's can be locked when @reclaim is set to true.
> > >  *
> > >  * Finally, wake up ksgxswapd when the number of pages goes below the watermark
> > >  * before returning back to the caller.
> > >  *
> > >  * Return:
> > >  *   an EPC page,
> > >  *   -errno on error
> > >  */
> > > 
> > > I also rewrote the kdoc.
> > > 
> > > I do agree that sgx_try_grab_page() should be renamed as __sgx_grab_page().
> > 
> > FWIW, I really, really dislike "grab".  The nomenclature for normal memory
> > and pages uses "alloc" when taking a page off a free list, and "grab" when
> > elevating the refcount.  I don't understand the motivation for diverging
> > from that.  SGX is weird enough as is, using names that don't align with
> > exist norms will only serve to further obfuscate the code.
> 
> OK, what would be a better name then? The semantics are not standard
> memory allocation semantics in the first place. And kdoc in v30 speaks
> about grabbing.

I can live with sgx_alloc_epc_page() or sgx_alloc_epc_page_from_section()
although I'd prefer the shorter form.

/Jarkko
