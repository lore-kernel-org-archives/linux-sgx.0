Return-Path: <SRS0=sWWJ=7K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81873C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 06:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 639B5207E8
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 06:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgE1GvP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 May 2020 02:51:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:33654 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgE1GvO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 May 2020 02:51:14 -0400
IronPort-SDR: eghkqmFSU/uMrfRbZfc2rDSALChVA0V5oElTny0P/tOApAqLCDcq7vcqwp5uNMCOEynrTbhae9
 ejZqqWpwrUww==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 23:51:14 -0700
IronPort-SDR: mM+OThdX20pk9Xfuqk50rnFFZKO5jEyK2l6SkGUjrx0a3e96dj8UVCaXFouR1Jx6Aw+QLDZ+hE
 Keed0UQpm+CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="469033310"
Received: from dmescala-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.59.102])
  by fmsmga006.fm.intel.com with ESMTP; 27 May 2020 23:51:06 -0700
Date:   Thu, 28 May 2020 09:51:04 +0300
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
Message-ID: <20200528065104.GA188849@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-9-jarkko.sakkinen@linux.intel.com>
 <20200526125207.GE28228@zn.tnic>
 <20200527042111.GI31696@linux.intel.com>
 <20200527204638.GG1721@zn.tnic>
 <20200528005217.GB25962@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528005217.GB25962@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 27, 2020 at 05:52:17PM -0700, Sean Christopherson wrote:
> On Wed, May 27, 2020 at 10:46:38PM +0200, Borislav Petkov wrote:
> > On Tue, May 26, 2020 at 09:21:11PM -0700, Sean Christopherson wrote:
> > > In other words, sgx_alloc_epc_section() is poorly named.  It doesn't
> > > actually allocate EPC, it allocates kernel structures to map and track EPC.
> > > sgx_(un)map_epc_section() would be more accurate and would hopefully
> > > alleviate some of the confusion.
> > 
> > Makes sense.
> > 
> > > I have no objection to renaming __sgx_alloc_try_alloc_page() to something
> > > like sgx_alloc_epc_page_section or whatever, but IMO using get/put will be
> > > horrendously confusing.
> > 
> > Ok. My only issue is that the naming nomenclature sounds strange and
> > confusing as it is. "try" in an "alloc" function is kinda tautological -
> > of course the function will try to do its best. :)
> 
> Heh, so what you're saying is we should add __sgx_really_try_alloc_page()?
> 
> > And there are three functions having "alloc" in the name so I can
> > imagine someone getting very confused when having to stare at that code.
> > 
> > So at least naming them in a way so that it is clear what kind of pages
> > they "allocate" - i.e., what they actually do - would be a step in the
> > right direction...
> 
> Ya, and things will only get more confusing when actual NUMA awareness gets
> thrown into the mix.
> 
> Jarkko, splicing in the NUMA awareness code, what do you think about:
> 
>   sgx_alloc_epc_section -> sgx_map_epc_section
>   sgx_free_epc_section  -> sgx_unmap_epc_section

Here alloc makes sense because memory gets allocated for the data
structures.

>   sgx_alloc_page        -> sgx_alloc_epc_page
>   sgx_free_page         -> sgx_free_epc_page
> 
>   sgx_try_alloc_page    -> sgx_alloc_epc_page_node
>   __sgx_try_alloc_page  -> sgx_alloc_epc_page_section

I'm going with sgx_grab_page() and sgx_try_grab_page().

/Jarkko
