Return-Path: <SRS0=j74F=WZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC501C3A59F
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 18:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82F55215EA
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Aug 2019 18:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfH2Sne (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Aug 2019 14:43:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:10560 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbfH2Sne (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Aug 2019 14:43:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 11:43:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,444,1559545200"; 
   d="scan'208";a="193060622"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 29 Aug 2019 11:43:33 -0700
Date:   Thu, 29 Aug 2019 11:43:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH v2 2/5] x86/sgx: Reject concurrent ioctls on single
 enclave
Message-ID: <20190829184332.GA27262@linux.intel.com>
References: <20190827192717.27312-1-sean.j.christopherson@intel.com>
 <20190827192717.27312-3-sean.j.christopherson@intel.com>
 <20190829131543.ejdsviysr2u33rnj@linux.intel.com>
 <20190829160001.GD26580@linux.intel.com>
 <20190829181438.oxix5d7qfgru7bd7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829181438.oxix5d7qfgru7bd7@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 29, 2019 at 09:14:38PM +0300, Jarkko Sakkinen wrote:
> On Thu, Aug 29, 2019 at 09:00:01AM -0700, Sean Christopherson wrote:
> > > #PF handler should be good as it has this conditional:
> > > 
> > > flags = atomic_read(&encl->flags);
> > > 
> > > if ((flags & SGX_ENCL_DEAD) || !(flags & SGX_ENCL_INITIALIZED))
> > > 	return ERR_PTR(-EFAULT);
> > > 
> > > What about the reclaimer?
> > 
> > Can you elaborate?  I'm not sure what you're asking.
> 
> I'm thinking of a race between list_add() in the ioctl and
> list_move_tail() in the reclaimer.

Ah crud, I forgot that the reclaimer can manipulate the list of VA pages,
I was thinking they were invisible to the reclaimer.

> A quick way to fix this would be move sgx_alloc_va_page() from
> sgx_encl_grow() and return NULL if a new allocation is required.

We don't even need to do that, moving the list_add() from sgx_encl_grow()
to its caller would be sufficient.  Same concept, but the allocation would
be handled by sgx_encl_grow() instead of having to duplicate that code in
sgx_encl_add_page() and sgx_encl_create().

> In the ioctl you can then allocate the page before taking locks and
> do "list_add(&va_page->list, &encl->va_pages);" behind the locks.
