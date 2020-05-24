Return-Path: <SRS0=tK8G=7G=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE75EC433E0
	for <linux-sgx@archiver.kernel.org>; Sun, 24 May 2020 21:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C01C207FB
	for <linux-sgx@archiver.kernel.org>; Sun, 24 May 2020 21:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387850AbgEXV1W (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 24 May 2020 17:27:22 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57496 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387830AbgEXV1W (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 24 May 2020 17:27:22 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CF0E11C02AB; Sun, 24 May 2020 23:27:20 +0200 (CEST)
Date:   Sun, 24 May 2020 23:27:19 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200524212719.GA1192@bug>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <20200426165753.GA11046@wind.enjellic.com>
 <87d07gk24l.fsf@nanos.tec.linutronix.de>
 <20200508190226.GA31465@wind.enjellic.com>
 <20200508195635.GR27052@linux.intel.com>
 <20200514091637.GA25156@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514091637.GA25156@wind.enjellic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi!

> > > At the very least a modular form of the driver should be
> > > considered that would allow alternate implementations.  Sean
> > > indicated that there was a 'kludgy' approach that would allow an
> > > alternate modular implementation alongside the in-kernel driver.
> > > I believe that Andy has already indicated that may not be an
> > > advisable approach.
> 
> > Modularizing the the driver does nothing for your use case.  The
> > "driver" is a relatively lightweight wrapper, removing that is akin
> > to making /dev/sgx/enclave inaccessible, i.e. it doesn't make the

Well... SGX is proprietary feature of Intel. I don't see any effort for standartization
so that other architectures could use it. Yet it provides userspace interface...

You clearly want distros to enable it, but that will waste memory on non-Intel systems.

That is not good.

> Here in a nutshell is the paradox the kernel faces:
> 
> No one seems to be disputing the fact that the primary focus of this
> driver will be to support the notion of 'runtime encryption' and
> Confidential Computing.  The whole premise of the concept and economic
> predicate of the initiative is that the owner/manager of the platform
> has no visibility into what is being done on the platform.

Well, in my eyes preventing owner of the machine from accessing all its parts is
pretty questionable.

Physics says it is impossible, many tried, and many failed. Why it should be
different this time?

> If the Linux community believes that standard platform security
> controls can make qualitatively good judgements on what enclave based
> execution is doing, it is effectively making the statement that the
> very concept of runtime encryption and by extension Confidential
> Computing is invalid.

And yes, I believe that concept of Confidential Computing is invalid.. and we
should simply not merge this support.

It provides false sense of security, and I'm afraid big companies will try to force
people to use it. "DRM, now with hardware support". "Finally advertisments you can
not skip". "Just run this piece of code on your machine to access your bank account.
Trust us!"

:-(.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
