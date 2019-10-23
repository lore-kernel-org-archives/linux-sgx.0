Return-Path: <SRS0=0rGN=YQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E5DCA9EB6
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Oct 2019 15:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB1C62173B
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Oct 2019 15:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406482AbfJWPX0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Oct 2019 11:23:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:48676 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403978AbfJWPX0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Oct 2019 11:23:26 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 08:23:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,221,1569308400"; 
   d="scan'208";a="398075367"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 23 Oct 2019 08:23:11 -0700
Date:   Wed, 23 Oct 2019 08:23:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 2/3] x86/sgx: Do not add in-use EPC page to the
 free page list
Message-ID: <20191023152310.GK329@linux.intel.com>
References: <20191022224922.28144-1-sean.j.christopherson@intel.com>
 <20191022224922.28144-3-sean.j.christopherson@intel.com>
 <20191023124340.GG23733@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023124340.GG23733@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 23, 2019 at 03:43:40PM +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 22, 2019 at 03:49:21PM -0700, Sean Christopherson wrote:
> > Don't add an EPC page to the free page list of EREMOVE fails, as doing
> > so will cause any future attempt to use the EPC page to fail, and likely
> > WARN as well.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index d45bf6fca0c8..8e7557d3ff03 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -138,7 +138,8 @@ int sgx_free_page(struct sgx_epc_page *page)
> >  	spin_unlock(&sgx_active_page_list_lock);
> >  
> >  	ret = __eremove(sgx_epc_addr(page));
> > -	WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret);
> > +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
> > +		return -EIO;
> 
> How did you end up choosing -EIO? Don't immediately have any better
> suggestion but neither sure if that is the best choice. That is why I'm
> asking.

sgx_edbgrd() and sgx_edbgwr() return -EIO on failure, and they're the only
other case I can think of where an ENCLS instruction failure is reported
to userspace *and* may or may not be due to a fault.

I honestly didn't spend much time thinking about it as the code is dropped
in the next path.
