Return-Path: <SRS0=HNuV=C7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE47BC4363D
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 18:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77AE623787
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 18:02:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="UgM9Rpk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgIVSCS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Sep 2020 14:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIVSCS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 22 Sep 2020 14:02:18 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7677C061755;
        Tue, 22 Sep 2020 11:02:17 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0bfb00105f6dfc0f2f9e65.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:fb00:105f:6dfc:f2f:9e65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C0E051EC027B;
        Tue, 22 Sep 2020 20:02:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600797735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9wsNfmarJ+ZwBMwKOM+TIGDi/giemsqRt1pXRwMjD/8=;
        b=UgM9Rpk2W4r30U2yLEgZ1N7PL8I3ft8uk2H/04npg38QSFeWxbPJUz6CfcFF9pB5ieaL2s
        NmnNGLh0M4uC9Rso5gHnoS37S13/RcJEmFF3rseBErfi9QlowUApB386aZZcpJYR/r15Ii
        qDwNj5pRJRzLAUH08TsmAfeSFxQISdA=
Date:   Tue, 22 Sep 2020 20:02:03 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jethro Beekman <jethro@fortanix.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Seth Moore <sethmo@google.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 16/24] x86/sgx: Add a page reclaimer
Message-ID: <20200922180203.GQ22660@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-17-jarkko.sakkinen@linux.intel.com>
 <20200922104538.GE22660@zn.tnic>
 <20200922162437.GA30827@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200922162437.GA30827@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 22, 2020 at 09:24:38AM -0700, Sean Christopherson wrote:
> The "else if" is correct.  Version Array (VA) pages have 512 slots that hold
> metadata for evicted EPC pages, i.e. swapping a page out of the EPC requires
> a VA slot.  For simplicity (LOL),

I'll say.

> the approach we are taking for initial support is to reserve a VA slot
> when adding a page to the enclave[*]. In most cases, reserving a slot
> does not require allocating a new VA page, e.g. to reserve slots 1-511
> of the "current" VA page. The if-elif is handling the case where the
> current VA page is fully reserved and a new one needs to be allocated.
> The if handles the error, the elif handles success, i.e.
> 
> 	if (IS_ERR(va_page)) <- needed a new VA page, allocation failed
> 		return PTR_ERR(va_page);
> 	else if (va_page)    <- needed a new VA page, allocation succeeded
> 		list_add(&va_page->list, &encl->va_pages);
> 	else
> 		             <- reused the current VA page

Aha, in that case va_page will be NULL but you're not using it in that
function later and that current VA page is on encl->va_pages which
others can get from there. Ok, gotcha.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
