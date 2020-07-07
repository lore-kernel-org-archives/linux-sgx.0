Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 052EBC433E0
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D512320758
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L5Hcz9Nf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgGGEjU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jul 2020 00:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgGGEjU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Jul 2020 00:39:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BDCC061755;
        Mon,  6 Jul 2020 21:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9Fn0Sg12AGqPvCet6/i3cv1zgohdxMq/STaY/sGGKBM=; b=L5Hcz9Nfo/DNgz2qozusOJmZHe
        6yxUrH93tLHZbhy98UmvJDnpk9Y24OKFN4qqQ/Td8wKicNYtqRomjKM9dOGxzQod0nHXGvuRzvlCz
        MIwmIylU70LmPziuuj+aRsoMlk5qRDcAjDOVW9UscpZidiktVdQFFIQgRFTnV0p7EjipJ0RONLfoW
        yb3LvUHaViGZLc+ewmuBdz8E/NU30C+049ft+YFzTtGvpfxduQN0iz94zTXnfMgjiWkT/KvNit0Nz
        ZD1Z9Yea+wyvH6LJDU7aAM6cFYfi/ZAZoxuUUTfTzjaPCSDEY+edAUIdBbCEa95nA0OAczWB4vVgD
        3E4+MfRw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jsfNo-0006OJ-8J; Tue, 07 Jul 2020 04:39:04 +0000
Date:   Tue, 7 Jul 2020 05:39:04 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v34 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20200707043904.GJ25523@casper.infradead.org>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-12-jarkko.sakkinen@linux.intel.com>
 <20200707033617.GF25523@casper.infradead.org>
 <20200707041151.GE143804@linux.intel.com>
 <20200707042904.GD5208@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707042904.GD5208@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 06, 2020 at 09:29:04PM -0700, Sean Christopherson wrote:
> > > > +	idx_start = PFN_DOWN(start);
> > > > +	idx_end = PFN_DOWN(end - 1);
> > > > +
> > > > +	for (idx = idx_start; idx <= idx_end; ++idx) {
> > > > +		mutex_lock(&encl->lock);
> > > > +		page = radix_tree_lookup(&encl->page_tree, idx);
> > > > +		mutex_unlock(&encl->lock);
> > > > +
> > > > +		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> > > > +			return -EACCES;
> > > 
> > > You should really use an iterator here instead of repeated lookups.
> > > xas_for_each() will probably be what you want.
> > 
> > Thank you for your remarks. I'll look into using xarray for this.
> 
> Question for Matthew:
> 
> To enforce the "page must be populated" rule, is there a clean way to retrieve
> the index of the current entry?  Our entries/pages don't have information
> about their index.  Or should we just count the number of entries and check
> 'em at the end? E.g.
> 
>         xas_for_each(...) {
>                 if (~page->vm_max_prot_bits & vm_prot_bits)
>                         return -EACCES;
>                 nr_entries++;
>         }
> 
>         if (nr_entries != (end_index - start_index))
>                 return -EACCES;

Probably best just to steal the implementation from here:

pgoff_t page_cache_next_miss(struct address_space *mapping,
                             pgoff_t index, unsigned long max_scan)
{
        XA_STATE(xas, &mapping->i_pages, index);

        while (max_scan--) {
                void *entry = xas_next(&xas);
                if (!entry || xa_is_value(entry))
                        break;
                if (xas.xa_index == 0)
                        break;
        }

        return xas.xa_index;
}

although I think you have a simpler task.

	XA_STATE(xas, ..., start_index);

	for (;;) {
		struct page *page = xas_next(&xas);

		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
			return -EACCES;
	}

	return 0;

should do the trick, I think.
