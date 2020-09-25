Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2163AC4363D
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 08:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA512085B
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 08:14:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="hIz+becV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgIYIOu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgIYIOu (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 25 Sep 2020 04:14:50 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0348DC0613CE;
        Fri, 25 Sep 2020 01:14:50 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0b3a00d3756fc4b2470eaa.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:3a00:d375:6fc4:b247:eaa])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7C8B91EC0430;
        Fri, 25 Sep 2020 10:14:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1601021688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=l/7weiyqiOxGuxBi5YYNdPQ1UkPqzVdGX8jds3f4aHU=;
        b=hIz+becVe0bb8xhSBZkt0t5O7MB7U27xkGBj7Hq9JnjdzPfTfJPvLLa/0KrNu6Dhgt8zTL
        7akzFZ7IevVYudSVDYJiJqq+aN9iF1XgYpb1Th4sOM9KRX4JVCpxFnLaYEpkxYw4L/Ctmu
        YHR1T5mUhIoOiL7nHgIOGH/zzUzE/bY=
Date:   Fri, 25 Sep 2020 10:14:41 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200925081441.GF16872@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <20200924180407.GO5030@zn.tnic>
 <20200925003808.GB20333@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200925003808.GB20333@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 05:38:10PM -0700, Sean Christopherson wrote:
> > Why not simply
> > 
> > arch/x86/entry/vdso/sgx.S
> > 
> > ?
> 
> I really like typing?

I'll say.

> Yes, to call out that there's a field there, but a field that the vDSO should
> never touch.

You wanna enforce that in the vdso code?

Because if it is there, luserspace will touch it.

> > > +#define SGX_ENCLAVE_RUN_EXCEPTION	4*8
> > > +
> > > +#define SGX_SYNCHRONOUS_EXIT		0
> > > +#define SGX_EXCEPTION_EXIT		1
> > 
> > Those are in ...uapi/asm/sgx.h too. Unify?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

What about this here?

> > Are the CFI annotations for userspace?
> 
> Yes, though that's a 90% confident "yes".

Looks like we wanna support it:

f24f91088427 ("x86/vdso: Define BUILD_VDSO while building and emit .eh_frame in asm")

> Argh, it's actually supposed to be TCS, SGX_ENCLAVE_RUN_TSC is the one that's
> wrong.

Whoopsie :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
