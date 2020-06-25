Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A800C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 18:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 334B52082E
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 18:45:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="rfyusMuS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390025AbgFYSpq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 14:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390007AbgFYSpp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 25 Jun 2020 14:45:45 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931FAC08C5C1;
        Thu, 25 Jun 2020 11:45:45 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ed100359123de3d1ebdc6.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:d100:3591:23de:3d1e:bdc6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0ED621EC03FA;
        Thu, 25 Jun 2020 20:45:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1593110744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=X64spH/ShbFrkkGbyJgQmg0OWwZHGce0YFejQLciW4Q=;
        b=rfyusMuSzuELSa3fTW3ghwVBn2TnqfvE74XKu5pvX7y37a1x8VEAWewMt8VKbDE3Fhn20j
        kpzTxg5BOPFI3xzj74IJRWKzMcKPrMS3Lc3nro9uJPiQ4ZqkL0YNI7wYLF+G1Hx/PizM0J
        bMK62aK2D2Mp/w/R+J4al5ZgQVQcZsA=
Date:   Thu, 25 Jun 2020 20:45:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200625184538.GM20319@zn.tnic>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200625172319.GJ20319@zn.tnic>
 <20200625183448.GG3437@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200625183448.GG3437@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 11:34:48AM -0700, Sean Christopherson wrote:
> Hmm, I think the most reasonable way to break up this beast would be to
> incrementally introduce functionality.  E.g. four or so patches, one for
> each ioctl() of ENCLAVE_CREATE, ENCLAVE_ADD_PAGES, ENCLAVE_INIT and
> ENCLAVE_SET_ATTRIBUTE, in that order.

Yeah, I guess I can try reviewing it this way too and address each ioctl
separately. You can try splitting later so that we don't waste time now.
It would be good to have it split eventually, though, so that it is more
palatable for other rewiewers too...

> Splitting up by file probably wouldn't work very well.  The split is
> pretty arbitrary, e.g. encl.[ch] isn't simply a pure representation of an
> enclave, there is a lot of the driver details/dependencies in there, i.e.
> the functionality between encl/ioctl/driver is all pretty intertwined.

... provided the functionality is not too intertwined to make a split
actually worse than a single big patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
