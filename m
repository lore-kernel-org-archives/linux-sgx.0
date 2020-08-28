Return-Path: <SRS0=biZR=CG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E757BC433E2
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Aug 2020 23:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C864220897
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Aug 2020 23:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgH1Xjh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Aug 2020 19:39:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:21007 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726649AbgH1Xjg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 28 Aug 2020 19:39:36 -0400
IronPort-SDR: 56oNT3GQyWK4CNBXkOiko/x8UozCi5eMxYrV0vHtmlm1ixXAzEpWQ4axdDETz+lczjIwMsIKGC
 iNhN47Ab7ITw==
X-IronPort-AV: E=McAfee;i="6000,8403,9727"; a="156766696"
X-IronPort-AV: E=Sophos;i="5.76,365,1592895600"; 
   d="scan'208";a="156766696"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 16:39:36 -0700
IronPort-SDR: z459cfAwG2WPzJDS8O6sZb2k1TCHzoBT+lQ1QQ779wMU9U2N8zbRWsoMYm0W2/itXnvLNihTu/
 RAIM4lF9/E5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,365,1592895600"; 
   d="scan'208";a="281087111"
Received: from faerberc-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.36.74])
  by fmsmga007.fm.intel.com with ESMTP; 28 Aug 2020 16:39:29 -0700
Date:   Sat, 29 Aug 2020 02:39:28 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 12/24] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
Message-ID: <20200828233928.GA39420@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-13-jarkko.sakkinen@linux.intel.com>
 <20200826145239.GC22390@zn.tnic>
 <20200827132436.GA4674@linux.intel.com>
 <20200827161527.GC30897@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827161527.GC30897@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 27, 2020 at 06:15:27PM +0200, Borislav Petkov wrote:
> On Thu, Aug 27, 2020 at 04:24:36PM +0300, Jarkko Sakkinen wrote:
> > I have not checked if this passes checkpatch.pl yet, but I would
> > be surprised if that did not pass (obviously I'll check that).
> 
> Right, when you're done with the patchset, just do
> 
> checkpatch.pl -g ...
> 
> on it before sending and you'll be good to go. Just remember to read the
> suggestions checkpatch gives with turned on brain and sanity-check them
> instead of blindly following them.
> 
> > I'm sorry about that. This was not intentional. I'll revisit them by
> > going through all your responses from here:
> > 
> >   https://patchwork.kernel.org/patch/11581715/
> 
> Actually this one:
> 
> https://lkml.kernel.org/r/20200617220844.57423-12-jarkko.sakkinen@linux.intel.com
> 
> i.e., the v33 version.

Ya, pasted wrong link, sorry :-)

> 
> Also, make sure you go through the review comments of v34 and v35 in
> case you haven't done so yet.

I'll re-check them before I send a new version.

> > v34 had the splitting of the big driver patch into multiple patches.
> > 
> > During that process I've obviously failed to address these.
> 
> Yeah, that can happen - I mean, this is not even close to being an easy
> patchset so thanks for putting in the effort.

I'd guess that this will get less painful given that the patches are now
more reasonably sizeda after chopping the driver patch.

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
