Return-Path: <SRS0=yCNl=7J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C82BC433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 27 May 2020 20:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5807620890
	for <linux-sgx@archiver.kernel.org>; Wed, 27 May 2020 20:46:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="khOZm8Fb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgE0Uqq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 May 2020 16:46:46 -0400
Received: from mail.skyhub.de ([5.9.137.197]:51886 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgE0Uqp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 May 2020 16:46:45 -0400
Received: from zn.tnic (p200300ec2f0b8700952f735680ed3731.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:8700:952f:7356:80ed:3731])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2F68F1EC02CF;
        Wed, 27 May 2020 22:46:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590612404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=jDfc3rtizFtHZ71v7Qy79JRVRQqWPpw5tOmQip8jpdI=;
        b=khOZm8FbSs3x1599c83biUD6tMakTCnT75zyU4V4dPMXsFGjC/tIABhzNv8/1MVEp7qCoH
        +mN+lYGGeSqyLOtkPPbNXVIi6HgHSl0zz3d6jVG0O+0F74ZNNYx80gzltm9R8Gd25KZWuh
        B8xuN/q0Gy6cIwVqAI6mV0Qu8PqMn+k=
Date:   Wed, 27 May 2020 22:46:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 08/20] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20200527204638.GG1721@zn.tnic>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-9-jarkko.sakkinen@linux.intel.com>
 <20200526125207.GE28228@zn.tnic>
 <20200527042111.GI31696@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200527042111.GI31696@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 26, 2020 at 09:21:11PM -0700, Sean Christopherson wrote:
> In other words, sgx_alloc_epc_section() is poorly named.  It doesn't
> actually allocate EPC, it allocates kernel structures to map and track EPC.
> sgx_(un)map_epc_section() would be more accurate and would hopefully
> alleviate some of the confusion.

Makes sense.

> I have no objection to renaming __sgx_alloc_try_alloc_page() to something
> like sgx_alloc_epc_page_section or whatever, but IMO using get/put will be
> horrendously confusing.

Ok. My only issue is that the naming nomenclature sounds strange and
confusing as it is. "try" in an "alloc" function is kinda tautological -
of course the function will try to do its best. :)

And there are three functions having "alloc" in the name so I can
imagine someone getting very confused when having to stare at that code.

So at least naming them in a way so that it is clear what kind of pages
they "allocate" - i.e., what they actually do - would be a step in the
right direction...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
