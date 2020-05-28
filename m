Return-Path: <SRS0=sWWJ=7K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C2EC433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 01:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D7DF207BC
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 01:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgE1BgT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 May 2020 21:36:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:20034 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgE1BgS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 May 2020 21:36:18 -0400
IronPort-SDR: 70tfPtqlPSR65feYQ5XNUxo+MEpOn7CeW2Bvv0rQVHRvG+9i7Jc8CiOswBjOlBshRtA7In1san
 6VjB34zhYMsQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 18:36:18 -0700
IronPort-SDR: 5FHc3bsOtXXn0GI8Fxncz+SX1EnPoAI6y8QVhyEk9mriFUiTCVtbw+Z56hKItwZGpyvKeIjYNY
 OIb9P6FeDZ7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208,217";a="255991778"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 27 May 2020 18:36:18 -0700
Date:   Wed, 27 May 2020 18:36:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Message-ID: <20200528013617.GD25962@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-9-jarkko.sakkinen@linux.intel.com>
 <20200526125207.GE28228@zn.tnic>
 <20200527042111.GI31696@linux.intel.com>
 <20200527204638.GG1721@zn.tnic>
 <20200528012319.GA7577@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528012319.GA7577@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 28, 2020 at 04:23:19AM +0300, Jarkko Sakkinen wrote:
> On Wed, May 27, 2020 at 10:46:38PM +0200, Borislav Petkov wrote:
> > On Tue, May 26, 2020 at 09:21:11PM -0700, Sean Christopherson wrote:
> > > In other words, sgx_alloc_epc_section() is poorly named.  It doesn't
> > > actually allocate EPC, it allocates kernel structures to map and track EPC.
> > > sgx_(un)map_epc_section() would be more accurate and would hopefully
> > > alleviate some of the confusion.

...

> I'm not sure I follow fully Sean's reasoning but the way alloc is used
> mostly in Linux is to ask through some API the used kernel memory
> allocator to give memory for some kernel data structures.

Function names are usually some form of

  <namespace>_<verb>_<object>

where 'object' is the target of the 'verb'.  So sgx_alloc_epc_section()
is most likely going to be read as "SGX, allocate an EPC section".  But
that code doesn't allocate an EPC section, it maps an EPC section, and on
success, adds the section's pages to the unsanitized list, i.e. what
effectively becomes the pool of EPC pages.  The allocation part is a side
effect of how we track EPC pages, it's not the primary purpose of the
function.

Maybe sgx_add_epc_section() and sgx_remove_epc_section() would be better
than map/unmap?

Eliminating the misnamed sgx_alloc_epc_section() frees up the "alloc" verb
for use in the actual EPC page allocation paths, i.e. avoids having to
rename those to "grab".  IMO, "alloc" is the best name as it most closely
aligns with the nomenclature for regular pages, e.g. "grab" is most often
used to elevate refcounts.
