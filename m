Return-Path: <SRS0=pKip=DL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A39C4363C
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Oct 2020 23:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7657D206A1
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Oct 2020 23:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgJDXmJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 19:42:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:20869 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgJDXmJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Oct 2020 19:42:09 -0400
IronPort-SDR: R5Zpscd5C8uGdYaWjIKupHhcGZJb0yjG2oKenRgYERg7mJ9ON4q5XsMW21q11og/W0xTXM0ej8
 LG+9/7zWSfcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="227448155"
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="227448155"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 16:42:07 -0700
IronPort-SDR: seGpSuZbW+Slv1I+Z7lk0E2yUnPxGWRnioLNMY1aTZKPNE2VrS6ifA2Nh788vAzGFJ/MqBgfmE
 NgF6YJL73RIw==
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="522376134"
Received: from avahldie-mobl.amr.corp.intel.com (HELO localhost) ([10.249.32.74])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 16:41:55 -0700
Date:   Mon, 5 Oct 2020 02:41:53 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Wilcox <willy@infradead.org>
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
Message-ID: <20201004234153.GA49415@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003195440.GD20115@casper.infradead.org>
 <20201004215049.GA43926@linux.intel.com>
 <20201004222750.GI20115@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004222750.GI20115@casper.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Oct 04, 2020 at 11:27:50PM +0100, Matthew Wilcox wrote:
> On Mon, Oct 05, 2020 at 12:50:49AM +0300, Jarkko Sakkinen wrote:
> > What is shoukd take is encl->lock.
> > 
> > The loop was pre-v36 like:
> > 
> > 	idx_start = PFN_DOWN(start);
> > 	idx_end = PFN_DOWN(end - 1);
> > 
> > 	for (idx = idx_start; idx <= idx_end; ++idx) {
> > 		mutex_lock(&encl->lock);
> > 		page = radix_tree_lookup(&encl->page_tree, idx);
> > 		mutex_unlock(&encl->lock);
> > 
> > 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> > 			return -EACCES;
> > 	}
> > 
> > Looking at xarray.h and filemap.c, I'm thinking something along the
> > lines of:
> > 
> > 	for (idx = idx_start; idx <= idx_end; ++idx) {
> > 		mutex_lock(&encl->lock);
> > 		page = xas_find(&xas, idx + 1);
> > 		mutex_unlock(&encl->lock);
> > 
> > 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> > 			return -EACCES;
> > 	}
> > 
> > Does this look about right?
> 
> Not really ...
> 
> 	int ret = 0;
> 
> 	mutex_lock(&encl->lock);
> 	rcu_read_lock();

Right, so xa_*() take RCU lock implicitly and xas_* do not.

> 	while (xas.index < idx_end) {
> 		page = xas_next(&xas);

It should iterate through every possible page index within the range,
even the ones that do not have an entry, i.e. this loop also checks
that there are no empty slots.

Does xas_next() go through every possible index, or skip the non-empty
ones?

> 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> 			ret = -EACCESS;
> 			break;
> 		}
> 	}
> 	rcu_read_unlock();
> 	mutex_unlock(&encl->lock);

In my Geminilake NUC the maximum size of the address space is 64GB for
an enclave, and it is not fixed but can grow in microarchitectures
beyond that.

That means that in (*artificial*) worst case the locks would be kept for
64*1024*1024*1024/4096 = 16777216 iterations.

I just realized that in sgx_encl_load_page ([1], the encl->lock is
acquired by the caller) I have used xa_load(), which more or less would
be compatible with the old radix_tree pattern, i.e.

for (idx = idx_start; idx <= idx_end; ++idx) {
	mutex_lock(&encl->lock);
	page = xas_load(&encl->page_array, idx);
	mutex_unlock(&encl->lock);

	if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
		return -EACCES;
}

To make things stable again, I'll go with this for the immediate future.

> 	return ret;
> 
> ... or you could rework to use the xa_lock instead of encl->lock.
> I don't know how feasible that is for you.

encl->lock is used to protect enclave state but it is true that
page->vm_max_prort_bits is not modified through concurrent access, once
the page is added (e.g. by the reclaimer, which gets pages through
sgx_activate_page_list, not through xarray).

It's an interesting idea, but before even considering it I want to fix
the bug, even if the fix ought to be somehow unoptimal in terms of
performance.

Thanks for helping with this. xarray is still somewhat alien to me and
most of the code I see just use the iterator macros excep mm/*, but
I'm slowly adapting the concepts.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git/tree/arch/x86/kernel/cpu/sgx/encl.c
[2] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git/tree/arch/x86/kernel/cpu/sgx/main.c

/Jarkko
