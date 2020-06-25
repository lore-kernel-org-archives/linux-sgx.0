Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654C3C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 22:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 479B22065F
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 22:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407537AbgFYWkS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 18:40:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:24488 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405127AbgFYWkR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 18:40:17 -0400
IronPort-SDR: rzNIDzYXhY3chKEt37x+7e3ouGoz4p41AF00kyYPsMQ4vB2He6cNokgXlavhpPcgQfkFwxWTVP
 NIwHfV1/zaYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="133514468"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="133514468"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 15:40:16 -0700
IronPort-SDR: pcAXwb9yQiL0xZNaBVRyCJV77i34uuWomPinHUgK9MTjbZx8DQ3nVrdWpAFLY2nBC41ls/7Oe4
 7GQgSHOdBz2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="385605612"
Received: from jproldan-mobl.ger.corp.intel.com (HELO localhost) ([10.252.49.123])
  by fmsmga001.fm.intel.com with ESMTP; 25 Jun 2020 15:40:05 -0700
Date:   Fri, 26 Jun 2020 01:40:04 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        linux-mm@kvack.org
Subject: Re: [PATCH v33 10/21] mm: Introduce vm_ops->may_mprotect()
Message-ID: <20200625224004.GA31121@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-11-jarkko.sakkinen@linux.intel.com>
 <20200625171416.GI20319@zn.tnic>
 <20200625173050.GF7703@casper.infradead.org>
 <20200625180646.GF3437@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625180646.GF3437@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 11:06:46AM -0700, Sean Christopherson wrote:
> On Thu, Jun 25, 2020 at 06:30:50PM +0100, Matthew Wilcox wrote:
> > On Thu, Jun 25, 2020 at 07:14:16PM +0200, Borislav Petkov wrote:
> > > On Thu, Jun 18, 2020 at 01:08:32AM +0300, Jarkko Sakkinen wrote:
> > > > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > > > index ce8b8a5eacbb..f7731dc13ff0 100644
> > > > --- a/mm/mprotect.c
> > > > +++ b/mm/mprotect.c
> > > > @@ -603,13 +603,21 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> > > >  			goto out;
> > > >  		}
> > > >  
> > > > +		tmp = vma->vm_end;
> > > > +		if (tmp > end)
> > > > +			tmp = end;
> > > > +
> > > > +		if (vma->vm_ops && vma->vm_ops->may_mprotect) {
> > > > +			error = vma->vm_ops->may_mprotect(vma, nstart, tmp,
> > > > +							  prot);
> > > > +			if (error)
> > > > +				goto out;
> > > > +		}
> > > > +
> > > >  		error = security_file_mprotect(vma, reqprot, prot);
> > > >  		if (error)
> > > >  			goto out;
> > > >  
> > 
> > I think the right way to do this is:
> > 
> >                 error = security_file_mprotect(vma, reqprot, prot);
> >                 if (error)
> >                         goto out;
> > 
> >                 tmp = vma->vm_end;
> >                 if (tmp > end)
> >                         tmp = end;
> > +		if (vma->vm_ops->mprotect)
> > +			error = vma->vm_ops->mprotect(vma, &prev, nstart, tmp,
> > +					newflags);
> > +		else
> > +			error = mprotect_fixup(vma, &prev, nstart, tmp,
> > +					newflags);
> > -               error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
> >                 if (error)
> >                         goto out;
> > 
> > and then the vma owner can do whatever it needs to before calling
> > mprotect_fixup(), which is already not static.
> 
> I'm certainly not opposed to a straight ->mprotect() hook.  ->may_protect()
> came about because I/we thought it would be less objectionable to allow the
> vma owner to apply additional restrictions as opposed to a wholesale
> replacement.

Can you send fixes to associated patches to linux-sgx (i.e. this and
driver)?

> > (how did we get to v33 with this kind of problem still in the patch set?)
> 
> Because no one from the mm world has looked at it.  Which is completely
> understandable because it's a giant patch set and the first 25 or so versions
> were spent sorting out fundamental architectural/design issue (there have
> been a _lot_ of speed bumps), e.g. the need for hooking mprotect() didn't
> even come about until v21.

Actually also because we did not have an explicit linux-mm CC.

/Jarkko
