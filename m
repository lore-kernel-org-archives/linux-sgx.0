Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D251C433E1
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 664212070C
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 03:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgGGDW4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Jul 2020 23:22:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:50529 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgGGDWz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Jul 2020 23:22:55 -0400
IronPort-SDR: kjwhbp//dGl1fXJjOprbT8HiYAGhcpkyt/XCuEXRyqjRfr2N/YoD50lS6OcsjKx/8j0x3gxiQm
 5HrthiBf7P9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="232393801"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="232393801"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 20:22:55 -0700
IronPort-SDR: kFG3YGSwU14G0VmMYUJYxvgt7qnUy1WiYQg/a7BqkOz04+jXrJV5/Ucx3XmXs1E0EGD97qONgk
 KX0AZl737OCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="315377658"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jul 2020 20:22:54 -0700
Date:   Mon, 6 Jul 2020 20:22:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20200707032254.GB5208@linux.intel.com>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-11-jarkko.sakkinen@linux.intel.com>
 <20200707031424.GD25523@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707031424.GD25523@casper.infradead.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 07, 2020 at 04:14:24AM +0100, Matthew Wilcox wrote:
> On Tue, Jul 07, 2020 at 06:01:50AM +0300, Jarkko Sakkinen wrote:
> > +++ b/mm/mprotect.c
> > @@ -603,13 +603,20 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> >  			goto out;
> >  		}
> >  
> > +		tmp = vma->vm_end;
> > +		if (tmp > end)
> > +			tmp = end;
> > +
> >  		error = security_file_mprotect(vma, reqprot, prot);
> >  		if (error)
> >  			goto out;
> >  
> > -		tmp = vma->vm_end;
> > -		if (tmp > end)
> > -			tmp = end;
> 
> You don't need to move this any more, right?

Ya, I was typing up a longer version, you beat me to the punch...

The calculation of 'tmp' doesn't need to be moved.  The previous incarnation
only moved it so that that 'tmp would be available for .may_mprotect().

The only reason  .may_mprotect() was placed before security_file_mprotect()
was to avoid triggering LSM errors that would have been blocked by
.may_mprotect(), but that justification is no longer relevant as the
proposed SGX LSM hooks obviously didn't worm their way into this series.

> > +		if (vma->vm_ops && vma->vm_ops->mprotect) {
> > +			error = vma->vm_ops->mprotect(vma, nstart, tmp, prot);
> > +			if (error)
> > +				goto out;
> > +		}

Based on "... and then the vma owner can do whatever it needs to before
calling mprotect_fixup(), which is already not static", my interpretation
is that Matthew's intent was to do:

		if (vma->vm_ops && vma->vm_ops->mprotect)
			error =  = vma->vm_ops->mprotect(vma, nstart, tmp, prot);
		else
			error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
		if (error)
			goto out;

i.e. make .mprotect() a full replacement as opposed to a prereq hook.
		
> > +
> >  		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
> >  		if (error)
> >  			goto out;
> > -- 
> > 2.25.1
> > 
