Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657BBC3A5A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 13:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D82E2339D
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 13:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388390AbfHWNkA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 09:40:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:3799 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731976AbfHWNj7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 09:39:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 06:39:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="203772488"
Received: from unknown (HELO jsakkine-mobl1) ([10.252.39.229])
  by fmsmga004.fm.intel.com with ESMTP; 23 Aug 2019 06:39:57 -0700
Message-ID: <8fd85b69f07c84a2727802ca4eac91287838a217.camel@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Fix ELDU MAC failures
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, luto@kernel.org
Date:   Fri, 23 Aug 2019 16:39:55 +0300
In-Reply-To: <39b3936327dfda8fe36ee8ea103d1d5e7779bd3d.camel@linux.intel.com>
References: <20190823020002.25550-1-sean.j.christopherson@intel.com>
         <39b3936327dfda8fe36ee8ea103d1d5e7779bd3d.camel@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2019-08-23 at 16:35 +0300, Jarkko Sakkinen wrote:
> On Thu, 2019-08-22 at 19:00 -0700, Sean Christopherson wrote:
> > Revert a change that directly propagates the page type from SECINFO into
> > encl_page->desc.  encl_page->desc is a packed value, jamming the SECINFO
> > page_type sets bits that are intended for other uses.
> > 
> > Specifically, bits 11:3 are used to store the VA offset when a page is
> > swapped out and are available for other uses when the page is resident
> > in the EPC.  To allow overloading bits 11:3, the VA offset is cleared at
> > ELDU and so is not explicitly cleared at EWB, e.g. the VA offset is OR'd
> > into encl_page->desc.  As a result, a subsequent ELDU gets a MAC failure
> > due to loading the wrong VA offset.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > index 85e36e530baf..355ce967a77f 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > @@ -140,7 +140,8 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
> >  		return ERR_PTR(-ENOMEM);
> >  
> >  	encl_page->desc = addr;
> > -	encl_page->desc |= page_type;
> > +	if (page_type == SGX_SECINFO_TCS)
> > +		encl_page->desc |= SGX_ENCL_PAGE_TCS;
> >  	encl_page->encl = encl;
> 
> Oops. How embrassing from my side. Please also ignore my original review
> comment about unreadability. The parameter type was right and everything
> was right. I was just blind for a while.
> 
> This is exactly how it should be e.g. no boolean parameter. I think with
> most of this kind of APIs we should follow a patttern the API takes PT
> and the function does whatever encoding we have.

In any case the issue is fixed now on my tree and I also rewrote commit
message for the driver.

/Jarkko

