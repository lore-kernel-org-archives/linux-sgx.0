Return-Path: <SRS0=pKip=DL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3B8C4727E
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Oct 2020 22:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E3A20796
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Oct 2020 22:28:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nx2xxKJ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbgJDW17 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 18:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgJDW17 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 4 Oct 2020 18:27:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1CCC0613CE;
        Sun,  4 Oct 2020 15:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f3LoEmiicIptti0tU7n5VZZ6rnPI7Ovsk8EdYqaxzlA=; b=Nx2xxKJ4AQxDT0QwzHgb9DrrY9
        nqYxZVdMKZXln955bYkzFZBZ7BriQLzXGI9keTbK1JvglUx3ANoGMeMWI8huHQKHF3sQfxOWexMCo
        0aZ/YV7D8Fe5KlwcQ687pbE5x169Uz89Dd0PtCjQFyyfenlAVXRPtUCSrmbdSnoaXPfUqZYlJfj+r
        MX6x+g7kkRLDeBkDLSM/kTgOKNKLmGUUXyCwdSOtT2ZcaVOyDFfRmNDroZowJiTI2H9UM3LhYQSSI
        bInQlK/hkD8mUkBsf23QpbEvvLdaBwuvS+5Ps+DMwtksvmHSXTEKUg+JKhJtjhaJBPj7AGcdzwmjU
        0pI7nmMw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPCTu-0001J4-6l; Sun, 04 Oct 2020 22:27:50 +0000
Date:   Sun, 4 Oct 2020 23:27:50 +0100
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
Message-ID: <20201004222750.GI20115@casper.infradead.org>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003195440.GD20115@casper.infradead.org>
 <20201004215049.GA43926@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004215049.GA43926@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 12:50:49AM +0300, Jarkko Sakkinen wrote:
> What is shoukd take is encl->lock.
> 
> The loop was pre-v36 like:
> 
> 	idx_start = PFN_DOWN(start);
> 	idx_end = PFN_DOWN(end - 1);
> 
> 	for (idx = idx_start; idx <= idx_end; ++idx) {
> 		mutex_lock(&encl->lock);
> 		page = radix_tree_lookup(&encl->page_tree, idx);
> 		mutex_unlock(&encl->lock);
> 
> 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> 			return -EACCES;
> 	}
> 
> Looking at xarray.h and filemap.c, I'm thinking something along the
> lines of:
> 
> 	for (idx = idx_start; idx <= idx_end; ++idx) {
> 		mutex_lock(&encl->lock);
> 		page = xas_find(&xas, idx + 1);
> 		mutex_unlock(&encl->lock);
> 
> 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> 			return -EACCES;
> 	}
> 
> Does this look about right?

Not really ...

	int ret = 0;

	mutex_lock(&encl->lock);
	rcu_read_lock();
	while (xas.index < idx_end) {
		page = xas_next(&xas);
		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
			ret = -EACCESS;
			break;
		}
	}
	rcu_read_unlock();
	mutex_unlock(&encl->lock);

	return ret;

... or you could rework to use the xa_lock instead of encl->lock.
I don't know how feasible that is for you.
