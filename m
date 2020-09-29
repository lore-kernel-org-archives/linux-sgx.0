Return-Path: <SRS0=LTc5=DG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87217C2D0A8
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 01:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4586C2083B
	for <linux-sgx@archiver.kernel.org>; Tue, 29 Sep 2020 01:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgI2BOn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Sep 2020 21:14:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:4324 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgI2BOm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Sep 2020 21:14:42 -0400
IronPort-SDR: 0VE6I+L1Fol83jxI6sTKxNeLjPrXI1miDj1xhAL+C+pXsUpiXHqhc4vxEFERovQhtoWZgKt20w
 uL3BNOWoGHqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149867893"
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="149867893"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 18:14:42 -0700
IronPort-SDR: pgtpNA+jtuvGoogfUXxiqFnRu841hblJguoLlGbttUi+kgiYHcNtBAOTadUTHJP2gwNzlDQWAZ
 MIKAy04r32Pw==
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="513656253"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 18:14:41 -0700
Date:   Mon, 28 Sep 2020 18:14:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 16/24] x86/sgx: Add a page reclaimer
Message-ID: <20200929011438.GA31167@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-17-jarkko.sakkinen@linux.intel.com>
 <20200922104538.GE22660@zn.tnic>
 <20200922140314.GA164527@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922140314.GA164527@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 05:03:23PM +0300, Jarkko Sakkinen wrote:
> On Tue, Sep 22, 2020 at 12:45:38PM +0200, Borislav Petkov wrote:
> > > +	spin_lock(&sgx_active_page_list_lock);
> > > +	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
> > > +		if (list_empty(&sgx_active_page_list))
> > 
> > Isn't it enough to do this once, i.e., not in the loop? You're holding
> > sgx_active_page_list_lock...

Argh, I missed this until I looked at Jarkko's updated tree.

The reason for checking list_empty() on every iteration is that the loop is
greedy, i.e. it tries to grab and reclaim up to 16 (SGX_NR_TO_SCAN) EPC pages
at a time.

> I think that would make sense. Distantly analogous to the EINIT
> discussion. Too complex code for yet to be known problem workloads I'd
> say.

Nooooo.  Please no.

This will most definitely impact workloads running a single large enclave, or a
process running multiple enclaves, as we'll lose the batching of ETRACK and IPIs.
ETRACK isn't a big deal, but the IPIs are painful and could thrash the system.
E.g. in the current code, reclaiming 10 pages from an enclave with actively
running threads will generate one round of IPIs to CPUs associated with the
enclave (based on the mm struct).  Going to per-page reclaim will likely result
in 10 rounds of IPIs as threads will reenter the enclave immediately after each
IPI wave.

Having to grab the section spinlock for every page is also (very) problematic.
Reclaiming one page at a time makes it nigh impossible for the reclaimer to
keep up as every allocation attempt acquires the spinlock.  I.e. the reclaimer
has to contend with every CPU that is faulting in an EPC page or is adding a
page to the enclave.  In my experiments with the EPC cgroup, even batching 16
pages may be insufficient to make "forward progress".  That's not an apples to
apples comparison, but it's a rough equivalent of what will happen with the
reclaim thread versus EPC page faults.  We can (and should) play with scaling
the number of reclaim threads, but at this stage, that's an exercise best left
to post-upstreaming.

I can't do A/B testing to provide numbers, because the changes in Jarkko's tree
break basic reclaim.  Which is a nice segue into my last point: this is by far
the most subtle code in the SGX code base; I really, really don't want to be
making last minute changes in this area unless they are absolutely necessary or
obviously benign.  Even if/when we get the basic reclaim functional again, and
assuming it doesn't have performance issues, I wouldn't be comfortable merging
the code without hammering it with the EPC cgroup tests for multiple days (on
top of the 1+ days to rebased the EPC cgroup).  Past testing with the cgroup
found multiple bugs with races between CPUs that required hitting a window that
was open for less than 10 instructions.
