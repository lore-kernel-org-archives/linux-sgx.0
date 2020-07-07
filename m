Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B3FC433DF
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2780320684
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nDpF4Boi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgGGEKv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jul 2020 00:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgGGEKv (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Jul 2020 00:10:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F184C061755;
        Mon,  6 Jul 2020 21:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jx2Euu6X0Gk2ywXBVaInMxlmuC+nxVpXXbv+4Y+K5cU=; b=nDpF4Boi5/wsAnVgUXbTljU/rc
        I+xcYCbqlI6v9CZyJvZ06zKKoilgJMwk7djybkbZyZFON9myGiXER+nfUG2SwR0rKim8uaHrrgOLS
        imC64AJX98pOoSPEGqHcNI0lihGzFl3O++JXgDY7WFfJ2c7PUy5xp3rLF0UaOdexXQr1TygHKVPll
        gIBNMc/YvnU/zQWd8j5eUy/lOGVO/LpnfNneBCfrCyf1JJ9j2z9yNYgQPgWeWq92+ekRmfEAnY75g
        j9+KaVyFc4+lQS5lhOn4GGPOPV8aRH+ADISyyHspXdgNjUrHJVAkX49FGETbv4JKHqIifAVq2Z7oZ
        d6y35umA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jsewQ-0005Nx-60; Tue, 07 Jul 2020 04:10:46 +0000
Date:   Tue, 7 Jul 2020 05:10:46 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Message-ID: <20200707041046.GI25523@casper.infradead.org>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-11-jarkko.sakkinen@linux.intel.com>
 <20200707031424.GD25523@casper.infradead.org>
 <20200707032254.GB5208@linux.intel.com>
 <20200707032408.GE25523@casper.infradead.org>
 <20200707040151.GA143804@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707040151.GA143804@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 07, 2020 at 07:01:51AM +0300, Jarkko Sakkinen wrote:
> On Tue, Jul 07, 2020 at 04:24:08AM +0100, Matthew Wilcox wrote:
> > On Mon, Jul 06, 2020 at 08:22:54PM -0700, Sean Christopherson wrote:
> > > On Tue, Jul 07, 2020 at 04:14:24AM +0100, Matthew Wilcox wrote:
> > > > > +		if (vma->vm_ops && vma->vm_ops->mprotect) {
> > > > > +			error = vma->vm_ops->mprotect(vma, nstart, tmp, prot);
> > > > > +			if (error)
> > > > > +				goto out;
> > > > > +		}
> > > 
> > > Based on "... and then the vma owner can do whatever it needs to before
> > > calling mprotect_fixup(), which is already not static", my interpretation
> > > is that Matthew's intent was to do:
> > > 
> > > 		if (vma->vm_ops && vma->vm_ops->mprotect)
> > > 			error =  = vma->vm_ops->mprotect(vma, nstart, tmp, prot);
> > > 		else
> > > 			error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
> > > 		if (error)
> > > 			goto out;
> > > 
> > > i.e. make .mprotect() a full replacement as opposed to a prereq hook.
> > 
> > Yes, it was.  I was just looking at the next patch to be sure this was
> > how I'd been misunderstood.
> 
> I'm don't get this part. If mprotect_fixup is called in the tail of the
> callback, why it has to be called inside the callback and not be called
> after the callback?

Because that's how every other VM operation works.  Look at your
implementation of get_unmapped_area() for example.

