Return-Path: <SRS0=YsX3=DN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C1BC41604
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Oct 2020 15:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D695B206D4
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Oct 2020 15:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgJFPYF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Oct 2020 11:24:05 -0400
Received: from mga06.intel.com ([134.134.136.31]:49591 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgJFPYF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Oct 2020 11:24:05 -0400
IronPort-SDR: lpuarCP4Urnt/Mp/C7Hjsh9azlY0cTx22/XETa9xsQOGPviM73Xj/WHu3TKBwiAZMxjbFX8MI5
 HLwax9Dop5cQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="226131948"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="226131948"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 08:16:20 -0700
IronPort-SDR: sjpMk0tGs8RS7XFKbbHERGv3K65bw82TWySurlXXZk3W4GoijMr6zj5lEVmuO3Y1cXOjvKOpPl
 BykS814N9svQ==
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="527396670"
Received: from thijsmet-mobl.ger.corp.intel.com (HELO localhost) ([10.249.34.36])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 08:16:19 -0700
Date:   Tue, 6 Oct 2020 18:16:13 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        linux-sgx@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Remove checks for platform limits from
 sgx_validate_secs()
Message-ID: <20201006151613.GB109815@linux.intel.com>
References: <20201005020819.124724-1-jarkko.sakkinen@linux.intel.com>
 <op.0rzxe2jtwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20201005113840.GA181338@linux.intel.com>
 <20201005224626.GC15803@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005224626.GC15803@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 03:46:26PM -0700, Sean Christopherson wrote:
> On Mon, Oct 05, 2020 at 02:38:40PM +0300, Jarkko Sakkinen wrote:
> > On Sun, Oct 04, 2020 at 11:00:28PM -0500, Haitao Huang wrote:
> > > On Sun, 04 Oct 2020 21:08:19 -0500, Jarkko Sakkinen
> > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > 
> > > > Remove from sgx_validate_secs():
> > > > 
> > > > 	if (secs->miscselect & sgx_misc_reserved_mask ||
> > > > 	    secs->attributes & sgx_attributes_reserved_mask ||
> > > > 	    secs->xfrm & sgx_xfrm_reserved_mask)
> > > > 		return -EINVAL;
> > > > 
> > > > SECS can surpass the platform limits because it's the SIGSTRUCT that
> > > > defines the limits that are used at run-time.
> > > > 
> > > > What SECS does is that it defines the overall limits that must apply for
> > > > any platform, i.e.  SECS limits and platform limits are orthogonal. They
> > > > are not dependent.
> > > > 
> > > > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > Cc: Jethro Beekman <jethro@fortanix.com>
> > > > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > > > Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
> > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > ---
> > > >  arch/x86/kernel/cpu/sgx/ioctl.c | 5 -----
> > > >  1 file changed, 5 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c
> > > > b/arch/x86/kernel/cpu/sgx/ioctl.c
> > > > index 6b3cc8483008..008752cb54f0 100644
> > > > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > > > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > > > @@ -86,11 +86,6 @@ static int sgx_validate_secs(const struct sgx_secs
> > > > *secs)
> > > >  	if (secs->base & (secs->size - 1))
> > > >  		return -EINVAL;
> > > > -	if (secs->miscselect & sgx_misc_reserved_mask ||
> > > > -	    secs->attributes & sgx_attributes_reserved_mask ||
> > > > -	    secs->xfrm & sgx_xfrm_reserved_mask)
> > > > -		return -EINVAL;
> > > > -
> > > >  	if (secs->size > max_size)
> > > >  		return -EINVAL;
> > > > 
> > > 
> > > Looks good to me.
> > > Thanks
> > > Haitao
> > 
> > Thanks, I'll merge it then.
> 
> You can't remove this wholesale, the kernel should still disallow access to
> features that are unknown to the kernel and/or are explicitly disallowed by
> the kernel.  E.g. see SGX_ATTR_RESERVED_MASK and SGX_MISC_RESERVED_MASK.
> 
> Dropping sgx_xfrm_reserved_mask is ok because the CPU explicitly checks that
> XFRM is a strict subset of the current XCR0, though that makes me wonder what
> it does with XSS...

If possible send a patch so I can get a changelog reference.

Only thing you need to put as long description is permlink to my
response in this thread.

Thank you.

/Jarkko
