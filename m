Return-Path: <SRS0=yCNl=7J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71734C433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 27 May 2020 20:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4947020890
	for <linux-sgx@archiver.kernel.org>; Wed, 27 May 2020 20:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="VY75sItQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgE0UfU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 May 2020 16:35:20 -0400
Received: from mail.skyhub.de ([5.9.137.197]:50190 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727863AbgE0UfT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 May 2020 16:35:19 -0400
Received: from zn.tnic (p200300ec2f0b8700952f735680ed3731.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:8700:952f:7356:80ed:3731])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1776C1EC03C1;
        Wed, 27 May 2020 22:35:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590611718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Fep83zRm+Nc7tQ6A7zu8+T4rH0ND8Zz8ls3kfkFk4SI=;
        b=VY75sItQDw1a1hMKOoFW96sfa0194tgCd1e9izbox020MO80E8JMS8k5gbvW7b7dssu+mb
        M+BUSh583sbLWJUTCRvLtzeYoaLl8rt9v3QBeimFM2JUQ+tx8QbFBDWIXEc5CS39edaVq4
        qA7P188tgPOAc3ejBmjTn92VGlUUAlA=
Date:   Wed, 27 May 2020 22:35:09 +0200
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
        Serge Ayoun <serge.ayoun@intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 07/20] x86/sgx: Enumerate and track EPC sections
Message-ID: <20200527203509.GF1721@zn.tnic>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-8-jarkko.sakkinen@linux.intel.com>
 <20200525092304.GD25636@zn.tnic>
 <20200527035613.GH31696@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200527035613.GH31696@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 26, 2020 at 08:56:14PM -0700, Sean Christopherson wrote:
> > > +		if (i == ARRAY_SIZE(sgx_epc_sections)) {
> > > +			pr_warn("No free slot for an EPC section\n");
> > > +			break;
> > > +		}
> > 
> > This is also the loop termination: do we really need this warn or can
> > the loop simply do "i < ARRAY_SIZE" ?
> 
> The warn alerts the user that there will effectively be lost/unused memory,
> so IMO it's worth keeping.

Can the user do anything about it? If not, then probably no need to say
anything.

> > > +		pr_info("EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
> > 
> > I'm assuming that's useful information to issue in dmesg?
> 
> Yes, it's effectively the equivalent of dumping the e820 tables.  It might
> not be as useful now that the code is stable, but I suspect it will come in
> handy for debug/triage down the road.

Ok.

> > Same for this one: also shared only among sgx code?
> 
> Yes, that one can definitely be buried behind a helper.

Shared only within sgx is fine. 

<snip> 

> One idea would be to provide a Kconfig a la NR_CPUS or NODES_SHIFT.  I.e.
> carve out the bits in sgx_epc_page_desc to allow up to N sections, but let
> the user limit the number of sections to recoup the unused memory.

I'd prefer a good estimate of a highest value, say 8 bits, which should
suffice for the foreseeable future. That's the simplest thing to do and
our Kconfig symbols space is an abomination of gazillion symbols.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
