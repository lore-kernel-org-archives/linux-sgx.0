Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4171C4363D
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 07:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CCAA21D7F
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 07:53:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="OcxF9+jG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgIYHxE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 03:53:04 -0400
Received: from mail.skyhub.de ([5.9.137.197]:59352 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbgIYHxE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Sep 2020 03:53:04 -0400
Received: from zn.tnic (p200300ec2f0b3a00d3756fc4b2470eaa.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:3a00:d375:6fc4:b247:eaa])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 617721EC0430;
        Fri, 25 Sep 2020 09:53:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1601020383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fdwFiJtPf7+dSMv7FNN3C/po5DSCeBzma9H2c6j2sfU=;
        b=OcxF9+jGbAtT2C+0FEneJGbiHTHeLWW0tDVUMCdJ99MNM7QXAaYIA7vYVWLMW3EOaR9AOD
        xjZCuz+JnY+XIzAOQo76+pe4yCg5c/uILfCrfGyb0u2qW8LXFENcIUUwhIw8mMyKbOo1iR
        a1uG7Xg1YSonDzR6IMhzIP5kSUHRang=
Date:   Fri, 25 Sep 2020 09:53:01 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 17/24] x86/sgx: ptrace() support for the SGX driver'
Message-ID: <20200925075301.GE16872@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-18-jarkko.sakkinen@linux.intel.com>
 <20200922154424.GL22660@zn.tnic>
 <20200923132037.GA5160@linux.intel.com>
 <20200923161733.GP28545@zn.tnic>
 <20200924115119.GD56811@linux.intel.com>
 <20200924155751.GJ5030@zn.tnic>
 <20200924203859.GD108958@linux.intel.com>
 <20200924204022.GE108958@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200924204022.GE108958@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 11:40:22PM +0300, Jarkko Sakkinen wrote:
> I'm not sure if I said it already but I also added cc to linux-mm (same
> CC's in the patch as with mprotect callback commit). This should also
> have mm ack I think.

Why? This is adding ptrace functionality to enclaves which is purely
arch/x86/.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
