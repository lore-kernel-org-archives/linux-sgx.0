Return-Path: <SRS0=YjYT=DA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67CC5C4727D
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 15:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECE4D235FC
	for <linux-sgx@archiver.kernel.org>; Wed, 23 Sep 2020 15:55:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="VbY+WpYK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgIWPzO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 23 Sep 2020 11:55:14 -0400
Received: from mail.skyhub.de ([5.9.137.197]:50904 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726732AbgIWPzO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 23 Sep 2020 11:55:14 -0400
Received: from zn.tnic (p200300ec2f0d130017aaf728a0fb4ec3.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1300:17aa:f728:a0fb:4ec3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C99061EC02E6;
        Wed, 23 Sep 2020 17:55:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600876512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=CIbMZjK4qzCcVtKZK70lx6mGmFTWDuCssH7GyKK77V4=;
        b=VbY+WpYKz3kw/yaNiZBIASqxUbbn6UvP4FAmRIzQWT45tEhnDzh4JLmoNiF0xvLYpYDC1n
        +gduIjrIwFcy7qXADK9hFcW1YOhaairDayepylTbYinS9sP+q0HpgGLf69Zz9RrwezYiBV
        O8aRDHHLNsdoBMRA+Wcja6gaMkVJLwY=
Date:   Wed, 23 Sep 2020 17:55:11 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
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
Message-ID: <20200923155511.GN28545@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-15-jarkko.sakkinen@linux.intel.com>
 <20200921173514.GI5901@zn.tnic>
 <20200921181021.GA24481@linux.intel.com>
 <20200921182753.GK5901@zn.tnic>
 <20200921191658.GA24823@linux.intel.com>
 <20200922082918.GC22660@zn.tnic>
 <a6f4d3e5-c128-fcd7-a1ca-5515a6c4c09a@fortanix.com>
 <20200922142909.GI22660@zn.tnic>
 <20200923144707.GF5160@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200923144707.GF5160@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 23, 2020 at 05:47:07PM +0300, Jarkko Sakkinen wrote:
> OK, so I did not follow this particular discussion in high detail,

What do you mean you did not follow it? It is not a huge subthread in
your mbox.

> so as a sanity check I'll preview my changes.

Sorry, but you'll have to read threads properly like everyone else.

In any case, my preference would be make it the simplest possible: no
cache and try EINIT only once.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
