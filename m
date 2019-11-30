Return-Path: <SRS0=9gEY=ZW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE4FC432C0
	for <linux-sgx@archiver.kernel.org>; Sat, 30 Nov 2019 15:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D890B2082E
	for <linux-sgx@archiver.kernel.org>; Sat, 30 Nov 2019 15:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfK3PEX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 30 Nov 2019 10:04:23 -0500
Received: from wind.enjellic.com ([76.10.64.91]:49908 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfK3PEX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 30 Nov 2019 10:04:23 -0500
X-Greylist: delayed 1554 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Nov 2019 10:04:23 EST
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id xAUEbqmR031430;
        Sat, 30 Nov 2019 08:37:52 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id xAUEbpiu031429;
        Sat, 30 Nov 2019 08:37:51 -0600
Date:   Sat, 30 Nov 2019 08:37:51 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Neil Horman <nhorman@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v24 01/24] x86/sgx: Update MAINTAINERS
Message-ID: <20191130143751.GA31365@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com> <20191129231326.18076-2-jarkko.sakkinen@linux.intel.com> <20191130013824.GA28617@hmswarspite.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191130013824.GA28617@hmswarspite.think-freely.org>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 30 Nov 2019 08:37:52 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 29, 2019 at 08:38:24PM -0500, Neil Horman wrote:
> On Sat, Nov 30, 2019 at 01:13:03AM +0200, Jarkko Sakkinen wrote:

Good morning, I hope the weekend is going well for everyone.

> > Add the maintainer information for the SGX subsystem.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  MAINTAINERS | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 0154674cbad3..08a67272ed14 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -8512,6 +8512,17 @@ F:	Documentation/x86/intel_txt.rst
> >  F:	include/linux/tboot.h
> >  F:	arch/x86/kernel/tboot.c
> >  
> > +INTEL SGX
> > +M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > +M:	Sean Christopherson <sean.j.christopherson@intel.com>
> > +L:	linux-sgx@vger.kernel.org
> > +S:	Maintained
> > +Q:	https://patchwork.kernel.org/project/intel-sgx/list/
> > +T:	git https://github.com/jsakkine-intel/linux-sgx.git
> > +F:	arch/x86/include/uapi/asm/sgx.h
> > +F:	arch/x86/kernel/cpu/sgx/*
> > +K:	\bSGX_
> > +
> >  INTERCONNECT API
> >  M:	Georgi Djakov <georgi.djakov@linaro.org>
> >  L:	linux-pm@vger.kernel.org
> > -- 
> > 2.20.1

> Wheres patch 12/24?

Out here in North Dakota we are currently missing the following
patches out of the series:

11/24
13/24
18/24
19/24
20/24

The missing parts are consistent on both the linux-kernel and
linux-sgx lists, ie we have duplicates of every patch but are
completely missing the noted patches.

Given gregkh's comments, it would seem to do little good to re-post
the series, given the fact the device model doesn't appear to be
acceptable in its current form.

> Neil

Have a good weekend.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D    Worker / Principal Engineer
IDfusion, LLC
4206 19th Ave N.            Specialists in SGX secured infrastructure.
Fargo, ND  58102
PH: 701-281-1686            CELL: 701-361-2319
EMAIL: gw@idfusion.org
------------------------------------------------------------------------------
"Artifical Intelligence stands no chance against Natural Stupidity."
                                -- John Henders
