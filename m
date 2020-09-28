Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19E4C4346E
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 00:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E6AC239EB
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 00:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgI1Ao4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 27 Sep 2020 20:44:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:37588 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgI1Aoz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 27 Sep 2020 20:44:55 -0400
IronPort-SDR: j3U0gIa+fDtmKObWADo8VGRBgeUg+roRewPRo7WGRxVnGR9/N7oOmp4+mvHNh0OBcmlvzXVCBq
 MzducvvSUkHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9757"; a="246663602"
X-IronPort-AV: E=Sophos;i="5.77,312,1596524400"; 
   d="scan'208";a="246663602"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2020 17:44:55 -0700
IronPort-SDR: jCuOEo1H37AGRm5VTOBT/P0142AXFxLfU9ZTBX0RgJMQ/NoSrMy/M+h173kEVZywHEwb0igdXI
 P/of59sdy9YA==
X-IronPort-AV: E=Sophos;i="5.77,312,1596524400"; 
   d="scan'208";a="488350016"
Received: from memara-mobl.ger.corp.intel.com (HELO localhost) ([10.252.49.157])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2020 17:44:49 -0700
Date:   Mon, 28 Sep 2020 03:44:50 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, yaozhangx@google.com
Subject: Re: [PATCH v38 24/24] x86/sgx: Update MAINTAINERS
Message-ID: <20200928004450.GA6704@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-25-jarkko.sakkinen@linux.intel.com>
 <20200925223753.GA9998@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925223753.GA9998@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 25, 2020 at 03:37:54PM -0700, Sean Christopherson wrote:
> On Tue, Sep 15, 2020 at 02:28:42PM +0300, Jarkko Sakkinen wrote:
> > Add the maintainer information for the SGX subsystem.
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  MAINTAINERS | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3b186ade3597..1d4daeb12d0a 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9051,6 +9051,17 @@ F:	Documentation/x86/intel_txt.rst
> >  F:	arch/x86/kernel/tboot.c
> >  F:	include/linux/tboot.h
> >  
> > +INTEL SGX
> > +M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > +M:	Sean Christopherson <sean.j.christopherson@intel.com>
> > +L:	linux-sgx@vger.kernel.org
> > +S:	Maintained
> > +Q:	https://patchwork.kernel.org/project/intel-sgx/list/
> > +T:	git https://github.com/jsakkine-intel/linux-sgx.git
> 
> This is stale, you moved your tree to kernel.org.

That's correct. It is already updated in my GIT tree:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git/tree/MAINTAINERS

/Jarkko
