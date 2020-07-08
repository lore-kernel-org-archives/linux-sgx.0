Return-Path: <SRS0=axKZ=AT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC1DC433E0
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jul 2020 14:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08C16206DF
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jul 2020 14:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgGHOde (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jul 2020 10:33:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:34195 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729486AbgGHOde (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 8 Jul 2020 10:33:34 -0400
IronPort-SDR: CSvo5k/57tfwZe6we2UhzCLFRg7Hc5v+GM8VmwjjficWCifnJ+W7pMkzx+AqFRg1q7s8g56Qob
 1znwNszI+LqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="149313247"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="149313247"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 07:33:33 -0700
IronPort-SDR: 2gn2BVPH5VBBaMKCqKSK+xkp94CECkdlpw6fL9C23g9y0C1iv9HumZs4ZwJf0+mMVXSu7cHAUx
 RmQOBjRkuezw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="457523928"
Received: from jschirra-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.201])
  by orsmga005.jf.intel.com with ESMTP; 08 Jul 2020 07:33:22 -0700
Date:   Wed, 8 Jul 2020 17:33:20 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v34 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200708143320.GD538949@linux.intel.com>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-11-jarkko.sakkinen@linux.intel.com>
 <20200707031424.GD25523@casper.infradead.org>
 <20200707032254.GB5208@linux.intel.com>
 <20200707032408.GE25523@casper.infradead.org>
 <20200707040151.GA143804@linux.intel.com>
 <20200707041046.GI25523@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707041046.GI25523@casper.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 07, 2020 at 05:10:46AM +0100, Matthew Wilcox wrote:
> On Tue, Jul 07, 2020 at 07:01:51AM +0300, Jarkko Sakkinen wrote:
> > On Tue, Jul 07, 2020 at 04:24:08AM +0100, Matthew Wilcox wrote:
> > > On Mon, Jul 06, 2020 at 08:22:54PM -0700, Sean Christopherson wrote:
> > > > On Tue, Jul 07, 2020 at 04:14:24AM +0100, Matthew Wilcox wrote:
> > > > > > +		if (vma->vm_ops && vma->vm_ops->mprotect) {
> > > > > > +			error = vma->vm_ops->mprotect(vma, nstart, tmp, prot);
> > > > > > +			if (error)
> > > > > > +				goto out;
> > > > > > +		}
> > > > 
> > > > Based on "... and then the vma owner can do whatever it needs to before
> > > > calling mprotect_fixup(), which is already not static", my interpretation
> > > > is that Matthew's intent was to do:
> > > > 
> > > > 		if (vma->vm_ops && vma->vm_ops->mprotect)
> > > > 			error =  = vma->vm_ops->mprotect(vma, nstart, tmp, prot);
> > > > 		else
> > > > 			error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
> > > > 		if (error)
> > > > 			goto out;
> > > > 
> > > > i.e. make .mprotect() a full replacement as opposed to a prereq hook.
> > > 
> > > Yes, it was.  I was just looking at the next patch to be sure this was
> > > how I'd been misunderstood.
> > 
> > I'm don't get this part. If mprotect_fixup is called in the tail of the
> > callback, why it has to be called inside the callback and not be called
> > after the callback?
> 
> Because that's how every other VM operation works.  Look at your
> implementation of get_unmapped_area() for example.

I get the point but I don't think that your proposal could work given
that mprotect-callback takes neither 'prev' nor 'newflags' as its
parameters. The current callback has no means to call mprotect_fixup()
properly.

It would have to be extended

	int (*mprotect)(struct vm_area_struct *vma,
			struct vm_area_struct **pprev, unsigned long start,
			unsigned long end, unsigned long prot,
			unsigned long newflags);

Is this what you want?

/Jarkko
