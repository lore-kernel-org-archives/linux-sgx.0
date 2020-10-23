Return-Path: <SRS0=GMJ6=D6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CF4C388F9
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 10:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94845221F9
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 10:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461924AbgJWKMG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Oct 2020 06:12:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:46184 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S461902AbgJWKMF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Oct 2020 06:12:05 -0400
IronPort-SDR: 4fU/Woo3wmfkc5Pk3qimhBVE01hqnJRwAn3eLIJ8m9b3k2LJzA6obYmqrh6C5zhxXaydZDFQDj
 7VuZ1pPnoaUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="147513133"
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="147513133"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 03:11:59 -0700
IronPort-SDR: LSKuDUDfpwS2jQem0DjiV2xOl3oOGjpv/J4wOGYEJ9lcXgMvZn9siwQDe+1XtTE/0JD8p9mo2E
 iYMGhBGYBt8Q==
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="534346115"
Received: from spiccard-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.41.38])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 03:11:44 -0700
Date:   Fri, 23 Oct 2020 13:11:44 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Message-ID: <20201023101144.GE168477@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-14-jarkko.sakkinen@linux.intel.com>
 <1739984e-0010-2031-1561-809a0b6380bb@intel.com>
 <20201018050311.GK68722@linux.intel.com>
 <516a1b7a-38cc-adde-833b-b661cbee97f2@intel.com>
 <20201019211525.GC23072@linux.intel.com>
 <564152e4-2334-2c82-1a12-4c980b08a944@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <564152e4-2334-2c82-1a12-4c980b08a944@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 19, 2020 at 02:44:19PM -0700, Dave Hansen wrote:
> On 10/19/20 2:15 PM, Sean Christopherson wrote:
> >>>> Yeah...  Don't we need to do another access_ok() check here, if we
> >>>> needed one above since we are moving away from addrp.src?
> >>> I don't think so because the page is pinned with get_user_pages().
> >> No, get_user_pages() is orthogonal.
> >>
> >> Looking at this again, you _might_ be OK since you validated addp.length
> >> against encl->size.  But, it's all very convoluted and doesn't look very
> >> organized or obviously right.
> > The easiest fix would be to have the existing access_ok() check the entire
> > range, no?  Or am I missing something obvious?
> 
> In general, I want the actual userspace access to be as close as
> possible and 1:1 with the access_ok() checks.  That way, it's blatantly
> obvious that the pointers have been checked.
> 
> *But* get_user_pages() has access_ok() checks inside of its
> implementation, which makes sense.  *But*, that begs the question of
> what the top-level one was doing in the first place.  Maybe it was just
> superfluous.
> 
> Either way, it still doesn't explain what this is doing:

I guess it is just history. Used to be one page ioctl.

> > +       ret = get_user_pages(src, 1, 0, &src_page, NULL);
> > +       if (ret < 1)
> > +               return -EFAULT;
> > +
> > +       pginfo.secs = (unsigned long)sgx_get_epc_addr(encl->secs.epc_page);
> > +       pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
> > +       pginfo.metadata = (unsigned long)secinfo;
> > +       pginfo.contents = (unsigned long)kmap_atomic(src_page);
> > +
> > +       ret = __eadd(&pginfo, sgx_get_epc_addr(epc_page));
> > +
> > +       kunmap_atomic((void *)pginfo.contents);
> 
> I think the point is to create a stable kernel alias address for
> 'src_page' so that any mucking with the userspace mapping doesn't screw
> up the __eadd() and any failures aren't due to reclaim or MADV_DONTNEED.
> 
> If this isn't even touching the userspace mapping, it didn't need
> access_ok() in the first place.

The whole access_ok() check is just evolutionary cruft. I will remove
it.

/Jarkko
