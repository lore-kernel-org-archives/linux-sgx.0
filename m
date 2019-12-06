Return-Path: <SRS0=FYK3=Z4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D80C43603
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Dec 2019 21:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C23C42467B
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Dec 2019 21:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="YiZr2VKq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfLFVYg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Dec 2019 16:24:36 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:40483 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbfLFVYg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 6 Dec 2019 16:24:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f5oI80mTn39w1hU29CqZ6P+VkrEvXGJ4k0LUXKZT8Ps=; b=YiZr2VKqlR+4IcLSUEFC5AL57u
        BdGjDf9lyE6SeNX6/9JiTwauIOtaPY9hgxPTeiq+8oXkFj9mKss32PDFiDYE6HoyuPgvFQjoSefxW
        mK9RIrHS78cRL/cVyqrqre/ajJbtvdNnpy/+KY6NJ7E2k+9EZhjvJkc+i0U+1xfvfg7mGtW9PkL+x
        8HbvRQnMDkJHNMyVKofpNoJQratS6oMF473i46gSoq6xn4pN6UsIRj000gJP88+K3LAkEuVqLbXIU
        t6eTR3A6TuOcwwIAuQrgbwNC7VENIBw7xAjl3n05AUf4nUgSsOT5lVS9oEl0bEXrXr1tn6mers+4O
        gAxoHiFw==;
Received: from 91-154-92-5.elisa-laajakaista.fi ([91.154.92.5] helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jarkko.sakkinen@linux.intel.com>)
        id 1idL5U-0003gY-LV; Fri, 06 Dec 2019 23:24:32 +0200
Date:   Fri, 6 Dec 2019 23:24:32 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Neil Horman <nhorman@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v24 01/24] x86/sgx: Update MAINTAINERS
Message-ID: <20191206212432.GG9971@linux.intel.com>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
 <20191129231326.18076-2-jarkko.sakkinen@linux.intel.com>
 <20191130013824.GA28617@hmswarspite.think-freely.org>
 <20191206212301.GF9971@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206212301.GF9971@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 91.154.92.5
X-SA-Exim-Mail-From: jarkko.sakkinen@linux.intel.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 06, 2019 at 11:23:01PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 29, 2019 at 08:38:24PM -0500, Neil Horman wrote:
> > On Sat, Nov 30, 2019 at 01:13:03AM +0200, Jarkko Sakkinen wrote:
> > > Add the maintainer information for the SGX subsystem.
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > ---
> > >  MAINTAINERS | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 0154674cbad3..08a67272ed14 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -8512,6 +8512,17 @@ F:	Documentation/x86/intel_txt.rst
> > >  F:	include/linux/tboot.h
> > >  F:	arch/x86/kernel/tboot.c
> > >  
> > > +INTEL SGX
> > > +M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > +M:	Sean Christopherson <sean.j.christopherson@intel.com>
> > > +L:	linux-sgx@vger.kernel.org
> > > +S:	Maintained
> > > +Q:	https://patchwork.kernel.org/project/intel-sgx/list/
> > > +T:	git https://github.com/jsakkine-intel/linux-sgx.git
> > > +F:	arch/x86/include/uapi/asm/sgx.h
> > > +F:	arch/x86/kernel/cpu/sgx/*
> > > +K:	\bSGX_
> > > +
> > >  INTERCONNECT API
> > >  M:	Georgi Djakov <georgi.djakov@linaro.org>
> > >  L:	linux-pm@vger.kernel.org
> > > -- 
> > > 2.20.1
> > > 
> > Wheres patch 12/24?
> > Neil
> 
> I've had issues with my VPN connection lately. I'll do a repost
> next week.

But... I received all of them.

Also checked patchworks and lore.

/Jarkko
