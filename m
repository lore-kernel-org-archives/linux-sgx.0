Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E11FC433DF
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10D8820702
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgGGE3F (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jul 2020 00:29:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:17162 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbgGGE3F (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 7 Jul 2020 00:29:05 -0400
IronPort-SDR: yiFcuQjDZgwVUD8y0GymcOEuLi4U+58jkkfH3ai97V5ZWjTJvnNY2XU+IOWrSjUKU3G6Yfi3FE
 4hySrXVX9/cA==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="127624021"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="127624021"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 21:29:04 -0700
IronPort-SDR: vEy7KA1HNinYAO7xUdxEB5KiqWDaxM1DoqJ6bCM1wUKER80OKYK3e3sNT+23vpPDKslKXoFW3C
 pSFzAWOwehaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="283301840"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 06 Jul 2020 21:29:04 -0700
Date:   Mon, 6 Jul 2020 21:29:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Matthew Wilcox <willy@infradead.org>, x86@kernel.org,
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
Message-ID: <20200707042904.GD5208@linux.intel.com>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-12-jarkko.sakkinen@linux.intel.com>
 <20200707033617.GF25523@casper.infradead.org>
 <20200707041151.GE143804@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707041151.GE143804@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Man, I really need to type faster.

On Tue, Jul 07, 2020 at 07:11:51AM +0300, Jarkko Sakkinen wrote:
> On Tue, Jul 07, 2020 at 04:36:17AM +0100, Matthew Wilcox wrote:
> > What's a leaf function?  Is it like a CPU instruction?
> 
> Yeah, the opcode is ENCLS for ring-0 (enclave management and
> construction) and ENCLU for ring-3 (entrance to the enclave etc).
> The leaf function number goes to EAX.

To add to Jarkko's comments, for all intents and purposes they are individual
instructions, e.g. all of their own entries in the SDM, but are buried behind
a single opcode that switches on EAX, e.g. ECREATE is EAX=0,  EADD is EAX=1,
EINIT is EAX=2.  It's purely a way to save opcode space when the extra
overhead is a non-issue, e.g. SMX/TXT's GETSEC does the same shenanigans.

> > > +	atomic_set(&encl->flags, 0);
> > > +	kref_init(&encl->refcount);
> > > +	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
> > 
> > Why are you using a radix tree instead of an xarray?
> 
> Because xarray did not exist in 2017 and nobody has pointed out to use
> it. Now I know it exists (yet do not know what it is).

I've followed xarrays a little, but obviously not closely enough to
understand their advantages over radix trees.  At a glance, range-based
iteration alone is probably justification enough to switch.

> > > +int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> > > +		     unsigned long end, unsigned long vm_prot_bits)
> > > +{
> > > +	unsigned long idx, idx_start, idx_end;
> > > +	struct sgx_encl_page *page;
> > > +
> > > +	/*
> > > +	 * Disallow RIE tasks as their VMA permissions might conflict with the
> > > +	 * enclave page permissions.
> > > +	 */
> > > +	if (!!(current->personality & READ_IMPLIES_EXEC))
> > > +		return -EACCES;
> > > +
> > > +	idx_start = PFN_DOWN(start);
> > > +	idx_end = PFN_DOWN(end - 1);
> > > +
> > > +	for (idx = idx_start; idx <= idx_end; ++idx) {
> > > +		mutex_lock(&encl->lock);
> > > +		page = radix_tree_lookup(&encl->page_tree, idx);
> > > +		mutex_unlock(&encl->lock);
> > > +
> > > +		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> > > +			return -EACCES;
> > 
> > You should really use an iterator here instead of repeated lookups.
> > xas_for_each() will probably be what you want.
> 
> Thank you for your remarks. I'll look into using xarray for this.

Question for Matthew:

To enforce the "page must be populated" rule, is there a clean way to retrieve
the index of the current entry?  Our entries/pages don't have information
about their index.  Or should we just count the number of entries and check
'em at the end? E.g.

        xas_for_each(...) {
                if (~page->vm_max_prot_bits & vm_prot_bits)
                        return -EACCES;
                nr_entries++;
        }

        if (nr_entries != (end_index - start_index))
                return -EACCES;
