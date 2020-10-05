Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1F2C4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 11:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 414D020776
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 11:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgJELis (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 07:38:48 -0400
Received: from mga17.intel.com ([192.55.52.151]:20302 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJELis (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 07:38:48 -0400
IronPort-SDR: zjrILCOfJkHUVCp77+N97fAWbsvScFV31w1ooACrT92QeYFS+D6pdAnppliREk8WyrGmura8kO
 QzAPT4ySKzSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="143374885"
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="143374885"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 04:38:44 -0700
IronPort-SDR: GDKV1gVhUA+6T9RvJSznhWIQ1Fzrpd8MoksLjUHgTrq9PG2WL44DurrEOl2JS4oPvAbam5QedQ
 C1RXHqYeBF5A==
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="525214400"
Received: from bclindho-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.32.27])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 04:38:42 -0700
Date:   Mon, 5 Oct 2020 14:38:40 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Remove checks for platform limits from
 sgx_validate_secs()
Message-ID: <20201005113840.GA181338@linux.intel.com>
References: <20201005020819.124724-1-jarkko.sakkinen@linux.intel.com>
 <op.0rzxe2jtwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0rzxe2jtwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Oct 04, 2020 at 11:00:28PM -0500, Haitao Huang wrote:
> On Sun, 04 Oct 2020 21:08:19 -0500, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> 
> > Remove from sgx_validate_secs():
> > 
> > 	if (secs->miscselect & sgx_misc_reserved_mask ||
> > 	    secs->attributes & sgx_attributes_reserved_mask ||
> > 	    secs->xfrm & sgx_xfrm_reserved_mask)
> > 		return -EINVAL;
> > 
> > SECS can surpass the platform limits because it's the SIGSTRUCT that
> > defines the limits that are used at run-time.
> > 
> > What SECS does is that it defines the overall limits that must apply for
> > any platform, i.e.  SECS limits and platform limits are orthogonal. They
> > are not dependent.
> > 
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Jethro Beekman <jethro@fortanix.com>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/ioctl.c | 5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c
> > b/arch/x86/kernel/cpu/sgx/ioctl.c
> > index 6b3cc8483008..008752cb54f0 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -86,11 +86,6 @@ static int sgx_validate_secs(const struct sgx_secs
> > *secs)
> >  	if (secs->base & (secs->size - 1))
> >  		return -EINVAL;
> > -	if (secs->miscselect & sgx_misc_reserved_mask ||
> > -	    secs->attributes & sgx_attributes_reserved_mask ||
> > -	    secs->xfrm & sgx_xfrm_reserved_mask)
> > -		return -EINVAL;
> > -
> >  	if (secs->size > max_size)
> >  		return -EINVAL;
> > 
> 
> Looks good to me.
> Thanks
> Haitao

Thanks, I'll merge it then.

/JArkko
