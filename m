Return-Path: <SRS0=pKip=DL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2201C4363C
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Oct 2020 22:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54FC12064C
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Oct 2020 22:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgJDWjd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 18:39:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:13159 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbgJDWjd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Oct 2020 18:39:33 -0400
IronPort-SDR: SaEnvdh5J+/0xgbR1oxc/acjtT9mfH7ru0W6GC38RXzZu4HZQN14t+rorYOyIeygUz3vBo0zsO
 U62FBjjLVMLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="151093825"
X-IronPort-AV: E=Sophos;i="5.77,336,1596524400"; 
   d="scan'208";a="151093825"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 15:39:32 -0700
IronPort-SDR: q3N0KWptmMBcYAecsPXECP1Z4ZDmXJi37nBwbx/BkW4gf0Or8YeP6Xa1ov6+tjLnyHAOdApOTB
 E1YUS/ouD1XQ==
X-IronPort-AV: E=Sophos;i="5.77,336,1596524400"; 
   d="scan'208";a="522137154"
Received: from avahldie-mobl.amr.corp.intel.com (HELO localhost) ([10.249.32.74])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 15:39:24 -0700
Date:   Mon, 5 Oct 2020 01:39:21 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com, willy@infradead.org
Subject: Re: [PATCH v39 16/24] x86/sgx: Add a page reclaimer
Message-ID: <20201004223921.GA48517@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-17-jarkko.sakkinen@linux.intel.com>
 <op.0rwbv916wjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20201003133245.GA6074@linux.intel.com>
 <op.0rxb1z06wjvjmi@mqcpg7oapc828.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0rxb1z06wjvjmi@mqcpg7oapc828.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 03, 2020 at 01:23:49PM -0500, Haitao Huang wrote:
> On Sat, 03 Oct 2020 08:32:45 -0500, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> 
> > On Sat, Oct 03, 2020 at 12:22:47AM -0500, Haitao Huang wrote:
> > > When I turn on CONFIG_PROVE_LOCKING, kernel reports following
> > > suspicious RCU
> > > usages. Not sure if it is an issue. Just reporting here:
> > 
> > I'm glad to hear that my tip helped you to get us the data.
> > 
> > This does not look like an issue in the page reclaimer, which was not
> > obvious for me before. That's a good thing. I was really worried about
> > that because it has been very stable for a long period now. The last
> > bug fix for the reclaimer was done in June in v31 version of the patch
> > set and after that it has been unchanged (except possibly some renames
> > requested by Boris).
> > 
> > I wildly guess I have a bad usage pattern for xarray. I migrated to it
> > in v36, and it is entirely possible that I've misused it. It was the
> > first time that I ever used it. Before xarray we had radix_tree but
> > based Matthew Wilcox feedback I did a migration to xarray.
> > 
> > What I'd ask you to do next is to, if by any means possible, to try to
> > run the same test with v35 so we can verify this. That one still has
> > the radix tree.
> > 
> 
> 
> v35 does not cause any such warning messages from kernel

Thank you. Looks like Matthew already located the issue, a fix will
land soon.

/Jarkko
