Return-Path: <SRS0=00MA=DJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A39C46466
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Oct 2020 15:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8C1120795
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Oct 2020 15:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388081AbgJBPt6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Oct 2020 11:49:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:65434 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388004AbgJBPt6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Oct 2020 11:49:58 -0400
IronPort-SDR: rdVxWCxDSmDzwIJFawWEb6/Te/7bThZ30A3CSPFDUjIUy6C46kQHOq0mOUZIu4B/ispsi5WCGp
 LzfpiRKbM6QA==
X-IronPort-AV: E=McAfee;i="6000,8403,9762"; a="150653522"
X-IronPort-AV: E=Sophos;i="5.77,328,1596524400"; 
   d="scan'208";a="150653522"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 08:49:57 -0700
IronPort-SDR: 1dCIhWVJVKel33wAIqgiIyC9QUKIlIG/GRT5vQIKWYX3+yQQ1/IQ2roIIX5RDbE2sm03DQQNzm
 2GgLFcX3a/PA==
X-IronPort-AV: E=Sophos;i="5.77,328,1596524400"; 
   d="scan'208";a="509130547"
Received: from juergenf-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.32.48])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 08:49:54 -0700
Date:   Fri, 2 Oct 2020 18:49:51 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
Subject: Re: [PATCH] x86/vdso: Flatten and clean up struct sgx_enclave_run
Message-ID: <20201002154943.GA514495@linux.intel.com>
References: <20201001161642.10500-1-jarkko.sakkinen@linux.intel.com>
 <20201001165151.GE7474@linux.intel.com>
 <20201001204027.GA18610@linux.intel.com>
 <20201002042505.GA34513@linux.intel.com>
 <20201002142753.GA510505@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002142753.GA510505@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 02, 2020 at 05:27:56PM +0300, Jarkko Sakkinen wrote:
> On Fri, Oct 02, 2020 at 07:25:05AM +0300, Jarkko Sakkinen wrote:
> > On Fri, Oct 02, 2020 at 12:46:11AM +0300, Jarkko Sakkinen wrote:
> > > > > The documentation, selftest and the kernel source code use the terms "user
> > > > > handler" and "exit handler" in somewhat inconsistent manner. Start using
> > > > > "AEX handler" consistently as this is the term that Intel SDM volume D uses
> > > > > for these events.
> > > > 
> > > > No, AEX is specifically for "asynchronus" exits.  In this context, that is
> > > > limited to the exception path.  The vDSO invokes the user handler for EEXIT,
> > > > i.e. the synchrous path, which is not an AEX.
> > > 
> > > OK, I but this one.
> > > 
> > > I got gray hairs because:
> > > 
> > > - API called it user handler.
> > > - Documentation called it exit handler.
> > > - Selftest called it exit handler.
> > > 
> > > I think user_handler is too generic and abstract but I'm happy to hear
> > > other proposals than 'exit_' to which I will change given your feedback.
> > 
> > OK, so here I use my "too generic" argument pick user handler anyhow
> > because we don't know what the heck the handler is doing.
> > 
> > 'exit_handler' implies that not only it would be called for enclave
> > exit resulting from an exception, but also for EEXIT path.
> 
> Wile editing the commit message I read what I had written about flags.
> It was quite terrible, to say the least.
> 
> I'll send update soon.

When I added validation, I noticed that the offsets were wrong. Fixing
this but I think this is also one good reason for always validate the
full struct and not just some flags-field. It helps to catch bugs early
on [*].

Not going to do selftest improvements before sending v39 but the
selftest needs even more exception test than provision. I think I work
on both of these after the patch set has been sent.

For exception, wouldn't be easiest to add a 2nd TCS and code path that
trigger's #PF / EPCM conflict? I could add a write operation on a
read-only page.

[*] Proudly admitting that in v1 of this patch everything was wrong
    as far as flags-field is considered: no flags, no padding
    validation and no legit reasoning.

/Jarkko
