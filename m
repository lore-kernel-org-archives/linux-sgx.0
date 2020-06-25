Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBDDC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 18:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFD8520789
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 18:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405871AbgFYSGs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 14:06:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:8495 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405552AbgFYSGs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 14:06:48 -0400
IronPort-SDR: fsuAdFjIsTRlyFg6zQ7G1dhU9e/pTLh1n9ps2V7BkOTBAhHGDGrE616cL2dwDvXZbbX6HE6BYF
 2zKG+bHVk8YQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="132454849"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="132454849"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 11:06:47 -0700
IronPort-SDR: n4HmymfMWcMYcqvRTz1IFT2bGVcc0o8Yr7L7hn1ffyc0Daj83lBvTuCxKdUh0EWzxuzSHnMppE
 LriRskFk7B1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="302082489"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jun 2020 11:06:46 -0700
Date:   Thu, 25 Jun 2020 11:06:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
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
Message-ID: <20200625180646.GF3437@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-11-jarkko.sakkinen@linux.intel.com>
 <20200625171416.GI20319@zn.tnic>
 <20200625173050.GF7703@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625173050.GF7703@casper.infradead.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 06:30:50PM +0100, Matthew Wilcox wrote:
> On Thu, Jun 25, 2020 at 07:14:16PM +0200, Borislav Petkov wrote:
> > On Thu, Jun 18, 2020 at 01:08:32AM +0300, Jarkko Sakkinen wrote:
> > > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > > index ce8b8a5eacbb..f7731dc13ff0 100644
> > > --- a/mm/mprotect.c
> > > +++ b/mm/mprotect.c
> > > @@ -603,13 +603,21 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> > >  			goto out;
> > >  		}
> > >  
> > > +		tmp = vma->vm_end;
> > > +		if (tmp > end)
> > > +			tmp = end;
> > > +
> > > +		if (vma->vm_ops && vma->vm_ops->may_mprotect) {
> > > +			error = vma->vm_ops->may_mprotect(vma, nstart, tmp,
> > > +							  prot);
> > > +			if (error)
> > > +				goto out;
> > > +		}
> > > +
> > >  		error = security_file_mprotect(vma, reqprot, prot);
> > >  		if (error)
> > >  			goto out;
> > >  
> 
> I think the right way to do this is:
> 
>                 error = security_file_mprotect(vma, reqprot, prot);
>                 if (error)
>                         goto out;
> 
>                 tmp = vma->vm_end;
>                 if (tmp > end)
>                         tmp = end;
> +		if (vma->vm_ops->mprotect)
> +			error = vma->vm_ops->mprotect(vma, &prev, nstart, tmp,
> +					newflags);
> +		else
> +			error = mprotect_fixup(vma, &prev, nstart, tmp,
> +					newflags);
> -               error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
>                 if (error)
>                         goto out;
> 
> and then the vma owner can do whatever it needs to before calling
> mprotect_fixup(), which is already not static.

I'm certainly not opposed to a straight ->mprotect() hook.  ->may_protect()
came about because I/we thought it would be less objectionable to allow the
vma owner to apply additional restrictions as opposed to a wholesale
replacement.

> (how did we get to v33 with this kind of problem still in the patch set?)

Because no one from the mm world has looked at it.  Which is completely
understandable because it's a giant patch set and the first 25 or so versions
were spent sorting out fundamental architectural/design issue (there have
been a _lot_ of speed bumps), e.g. the need for hooking mprotect() didn't
even come about until v21.
