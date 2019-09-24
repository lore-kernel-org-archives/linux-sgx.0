Return-Path: <SRS0=S/Hi=XT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61593C432C1
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 16:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 355472168B
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 16:25:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="HSIvtQQ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439210AbfIXQZW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Sep 2019 12:25:22 -0400
Received: from mail.skyhub.de ([5.9.137.197]:35760 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfIXQZV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Sep 2019 12:25:21 -0400
Received: from zn.tnic (p200300EC2F0DB700CDA5DCD899733FA6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:b700:cda5:dcd8:9973:3fa6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3D1B81EC03F6;
        Tue, 24 Sep 2019 18:25:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569342320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=b2LZ0wWlgO+SsWzDsfhzM2/OLOuJ6ofaRtuo/MAkItE=;
        b=HSIvtQQ8QtlfDTUZ1lXGgEpP4uObig8a8o5vNVpZuxDgCrYOkA1oKovzROG6lDbDexMVHx
        V0JzkBt+uqAoh9sH+QVQn2OwuCiEaHWHftv/Gu1clX5/H7nVNVLUZ6A4AAulf/jxb4rGPx
        SG1dfKLqUdApVDyvuscCD7U63ZgXEfA=
Date:   Tue, 24 Sep 2019 18:25:20 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, Kai Huang <kai.huang@linux.intel.com>
Subject: Re: [PATCH v22 01/24] x86/cpufeatures: x86/msr: Add Intel SGX
 hardware bits
Message-ID: <20190924162520.GJ19317@zn.tnic>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-2-jarkko.sakkinen@linux.intel.com>
 <20190924152848.GF19317@zn.tnic>
 <20190924161150.GA16218@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190924161150.GA16218@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 24, 2019 at 09:11:50AM -0700, Sean Christopherson wrote:
> With respect to more SGX feature flags, the original changelog even
> stated "with more expected in the not-too-distant future".

That means nothing, you know that, right? :)

There's a big difference between expectation and it actually happening
and besides, the longterm plan with all those feature words which are
scattered, is to propagate them to proper ->x86_capability[] words once
the number of feature bits used is gradually growing.

Also,...

> I'm not arguing that this isn't ugly, just want to make it clear that
> we're not wantonly throwing junk into the kernel.  I'm all for a dedicated
> SGX word, it makes our lives easier.

... you didn't do the first-8-bits-need-to-match-the-CPUID-leaf for KVM
thing then, you're doing now. Which would make word 8 half-hard-coded
and the other half Linux-defined.

Which makes a separate leaf look much better now. :)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
