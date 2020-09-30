Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245EDC4727E
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 16:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C9120789
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 16:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731217AbgI3Qic (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 12:38:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:38492 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3Qi2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Sep 2020 12:38:28 -0400
IronPort-SDR: QSxtSE9V4gvx5yQeH82ehy9Ckag7pX9KOBN2SwRzFvIPaScgJt4U2kDSHW0IN3IhSveXlXrjo5
 PzqCmhgxkxUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="224085149"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="224085149"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 09:38:27 -0700
IronPort-SDR: UW1tK6kaEeWZjpQlt41JYNFTkCaRutkLNMAOaLO5JGHk50+3W5qdcTB4Z9KFKbpaiplsModnXI
 j5W03ynxxGtA==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="457717639"
Received: from geigerri-mobl.ger.corp.intel.com (HELO localhost) ([10.249.35.47])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 09:38:24 -0700
Date:   Wed, 30 Sep 2020 19:38:22 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org, Haitao Huang <haitao.huang@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
Subject: Re: [PATCH] x86/vdso: Remove retpoline from SGX vDSO call
Message-ID: <20200930163822.GA55565@linux.intel.com>
References: <20200930140108.48075-1-jarkko.sakkinen@linux.intel.com>
 <92578646-83a4-606c-b251-4d80cb62399c@intel.com>
 <20200930142017.GA49393@linux.intel.com>
 <112ad81e-16ab-d6e0-09e7-3658874434f7@intel.com>
 <20200930152806.GA52739@linux.intel.com>
 <20200930154349.GB32672@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930154349.GB32672@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 30, 2020 at 08:43:49AM -0700, Sean Christopherson wrote:
> On Wed, Sep 30, 2020 at 06:28:06PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Sep 30, 2020 at 07:33:38AM -0700, Dave Hansen wrote:
> > > On 9/30/20 7:20 AM, Jarkko Sakkinen wrote:
> > > > I'm not expert on Spectre, or any sort of security researcher, but I've
> > > > read a few papers about and understand the general concept. With the
> > > > constraints how the callback is used in practice, I'd *guess* it is
> > > > fine to drop retpoline but I really need some feedback on this from
> > > > people who understand these attacks better.
> > > 
> > > Do you recall why you added it in the first place?  What was the
> > > motivation for it?  Were you responding to a review comment?
> > 
> > Absolutely cannot recall it :-) I even cannot recall the exact time when
> > we landed the vDSO in the first place. Too much stuff has happend during
> > the long three year upstreaming cycle. I will try to backtrack this
> > info.
> 
> It originated in a comment from Andy when we were discussing the legitimacy
> of the callback.  From that point on it got taken as gospel that the indirect
> call would be implemented as a retpoline.
> 
> https://lkml.kernel.org/r/CALCETrVBR+2HjTqX=W4r9GOq69Xg36v4gmCKqK0wUjzAqBJnrw@mail.gmail.com

This patch from v20-v21 era is also relevant:

https://lore.kernel.org/linux-sgx/ba2a51568f3adaf74994d33ea3cbee570e20c6f6.1555965327.git.cedric.xing@intel.com/

It introduced the retpoline wrapping to the patch set but unfortunately
does not have any explanation for that particular detail.

Neither does Andy's comment except correctly stating that retpoline is
the modern standard for indirect calls but that does not get us too far.

My argument, or maybe just actually a question, is essentially that
given the usage pattern for this particular indirect call, do we need to
actually retpoline it?

Boot time patching turned out to be simple to implement but it is also
yet another whistle for the already complex vDSO.

/Jarkko
