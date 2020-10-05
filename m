Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D5A3C4727D
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 01:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6CA22078B
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 01:31:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mLsD6Ikb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgJEBbG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 21:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgJEBbF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 4 Oct 2020 21:31:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76957C0613CE;
        Sun,  4 Oct 2020 18:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0qSk/poAAlh1rgBkhNlRg8Se+ak0sbI4FbkVJHltdr8=; b=mLsD6Ikb8fCqRb4wFjxC2fwp7H
        6AZNCciLtFbL3K6A/wkL/KkLBPZy63j6xad5I+eGexCvUSzAawRSWB0tAdmZ7ZjYWVMF3u1f4beLl
        EbuXu14fMeGwt9DUP7PyljNUqC8MBZec4xbzRZSYz6ZN6GG5dYcqh1bJlJrWFT9cDzBmtFSPtlLJu
        kIIBNzWc4yqOVkAo8+t3bFu9lVqUhmSdJJ+4WqfNVlVt1NZqh73O8P6aEucOpbm07TzfjFJ9w15hx
        OCTIdqdw4YvYD+7ySVKJ8qdr7E4U+75LrjQl9Q7jSF/VaWMm5twQhGbPE9SWxKPX6+Og1NAIGU/Az
        +viEtQWA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPFL3-00023F-T2; Mon, 05 Oct 2020 01:30:54 +0000
Date:   Mon, 5 Oct 2020 02:30:53 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20201005013053.GJ20115@casper.infradead.org>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003195440.GD20115@casper.infradead.org>
 <20201004215049.GA43926@linux.intel.com>
 <20201004222750.GI20115@casper.infradead.org>
 <20201004234153.GA49415@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004234153.GA49415@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 02:41:53AM +0300, Jarkko Sakkinen wrote:
> On Sun, Oct 04, 2020 at 11:27:50PM +0100, Matthew Wilcox wrote:
> > 	int ret = 0;
> > 
> > 	mutex_lock(&encl->lock);
> > 	rcu_read_lock();
> 
> Right, so xa_*() take RCU lock implicitly and xas_* do not.

Not necessarily the RCU lock ... I did document all this in xarray.rst:

https://www.kernel.org/doc/html/latest/core-api/xarray.html

> > 	while (xas.index < idx_end) {
> > 		page = xas_next(&xas);
> 
> It should iterate through every possible page index within the range,
> even the ones that do not have an entry, i.e. this loop also checks
> that there are no empty slots.
> 
> Does xas_next() go through every possible index, or skip the non-empty
> ones?

xas_next(), as its documentation says, will move to the next array
index:

https://www.kernel.org/doc/html/latest/core-api/xarray.html#c.xas_next

> > 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> > 			ret = -EACCESS;
> > 			break;
> > 		}
> > 	}
> > 	rcu_read_unlock();
> > 	mutex_unlock(&encl->lock);
> 
> In my Geminilake NUC the maximum size of the address space is 64GB for
> an enclave, and it is not fixed but can grow in microarchitectures
> beyond that.
> 
> That means that in (*artificial*) worst case the locks would be kept for
> 64*1024*1024*1024/4096 = 16777216 iterations.

Oh, there's support for that on the XArray API too.

        xas_lock_irq(&xas);
        xas_for_each_marked(&xas, page, end, PAGECACHE_TAG_DIRTY) {
                xas_set_mark(&xas, PAGECACHE_TAG_TOWRITE);
                if (++tagged % XA_CHECK_SCHED)
                        continue;

                xas_pause(&xas);
                xas_unlock_irq(&xas);
                cond_resched();
                xas_lock_irq(&xas);
        }
        xas_unlock_irq(&xas);

