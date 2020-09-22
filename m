Return-Path: <SRS0=HNuV=C7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290F2C2D0E2
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 08:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98C56239E5
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 08:29:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="qKHk11PS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIVI3Z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Sep 2020 04:29:25 -0400
Received: from mail.skyhub.de ([5.9.137.197]:34792 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgIVI3Z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Sep 2020 04:29:25 -0400
Received: from zn.tnic (p200300ec2f0bfb00524dde00a85e5113.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:fb00:524d:de00:a85e:5113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 964C61EC047E;
        Tue, 22 Sep 2020 10:29:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600763363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=my0BiTfuw78PRSxQkYalUvNGgbAS+8+tGotWiPO3720=;
        b=qKHk11PS4bsI8+fCWlD1orBMgH8FXAnqSal8BmRD2ycHTiQsgjAkQT/XaD4CRP8asQb4Iw
        Xxj6FBbXRHicVhjY94W12OQZY6bK8N5DfajU60ba6qtc8Mh63Td5RC1HtTmLNeB9r8n1Sj
        YHOgngTbhQHUbA4k+/R3gZgeDe/udLE=
Date:   Tue, 22 Sep 2020 10:29:18 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 14/24] x86/sgx: Add SGX_IOC_ENCLAVE_INIT
Message-ID: <20200922082918.GC22660@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-15-jarkko.sakkinen@linux.intel.com>
 <20200921173514.GI5901@zn.tnic>
 <20200921181021.GA24481@linux.intel.com>
 <20200921182753.GK5901@zn.tnic>
 <20200921191658.GA24823@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200921191658.GA24823@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 12:17:00PM -0700, Sean Christopherson wrote:
> That was effectively my original suggestion as well, check for a stale cache
> and retry indefinitely.  I capitulated because it did feel like I was being
> overly paranoid.  I'm obviously ok going the retry indefinitely route :-).
> 
> https://lkml.kernel.org/r/20180904163546.GA5421@linux.intel.com

Right, so if EINIT is so expensive, why does it matter how many cyccles
WRMSR has? I.e., you don't really need to cache - you simply write the 4
MSRs and you're done. Simple.

As to "indefinitely" - caller can increment a counter which counts
how many times it returned SGX_INVALID_EINITTOKEN. I guess when it
reaches some too high number which should not be reached during normal
usage patterns, you can give up and issue a message to say that counter
reached max retries or so but other than that, you should be ok. That
thing is running interruptible in a loop anyway...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
