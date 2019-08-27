Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46E4C3A5A3
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 16:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7745D21881
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 16:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbfH0QmF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Aug 2019 12:42:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:32161 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfH0QmF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Aug 2019 12:42:05 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:42:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="185346811"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 27 Aug 2019 09:42:04 -0700
Date:   Tue, 27 Aug 2019 09:42:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 1/4] x86/sgx: Ensure enclave state is visible before
 marking it created
Message-ID: <20190827164204.GF27459@linux.intel.com>
References: <20190827001128.25066-1-sean.j.christopherson@intel.com>
 <20190827001128.25066-2-sean.j.christopherson@intel.com>
 <20190827112044.rduraacnr242rpxj@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827112044.rduraacnr242rpxj@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 27, 2019 at 02:20:44PM +0300, Jarkko Sakkinen wrote:
> On Mon, Aug 26, 2019 at 05:11:25PM -0700, Sean Christopherson wrote:
> > Add a memory barrier pair to ensure all enclave state is visible in
> > memory prior to SGX_ENCL_CREATED being set.  Without the barries, adding
> > pages and/or initializing the enclaves could theoretically consume stale
> > data.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/ioctl.c | 16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> > index 911ff3b0f061..7134d68aecb3 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -163,6 +163,15 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
> >  	return encl_page;
> >  }
> >  
> > +static bool is_encl_created(struct sgx_encl *encl)
> > +{
> > +	bool created = encl->flags & SGX_ENCL_CREATED;
> > +
> > +	/* Pairs with smp_wmb() in sgx_encl_create(). */
> > +	smp_rmb();
> > +	return created;
> > +}
> 
> what if you just convert the flags to atomic_t? That would fix this
> issue and would prevent analogous issues from occuring.

I thought about that too, but originally discarded the idea because I
was worried doing so would negatively impact the other uses of flags.
After actually implementing the change, I think the positives outweigh
the negatives, so I'll send a v2 with this suggestion.
