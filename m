Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6678DC2BB84
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 20:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16798205CB
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 20:42:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="Ox88Fati"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgIPUkx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgIPRFg (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 16 Sep 2020 13:05:36 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB21C061223;
        Wed, 16 Sep 2020 09:21:07 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c3e00db2f62bd592f04a0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:3e00:db2f:62bd:592f:4a0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0315D1EC032C;
        Wed, 16 Sep 2020 18:21:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600273266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=bIXSVgwmouub5tQQiDJ6zHx3om935DwZM13GEWZRvYw=;
        b=Ox88FatiCrIiQHkFOoc+k3Qu2xr3U63O6XxF7mA1+89aTstwme3ws54oZBMncKcd4/GY84
        spDXHkxbnqzydyc3gEI0A4xqeY8ICS7ydsn7lKf8f+Mu4L4Id3uE6pOe6rLl+lY001tu6p
        mCBmbpKNNKqPKeIarFtvgwc9+POsNoU=
Date:   Wed, 16 Sep 2020 18:20:59 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v37 02/24] x86/cpufeatures: x86/msr: Add Intel SGX Launch
 Control hardware bits
Message-ID: <20200916162059.GM2643@zn.tnic>
References: <20200911124019.42178-1-jarkko.sakkinen@linux.intel.com>
 <20200911124019.42178-3-jarkko.sakkinen@linux.intel.com>
 <20200914151816.u6camicid4bd5lgo@treble>
 <20200914153812.c6uh3spqmcy2ft3d@treble>
 <20200915095716.GI3612@linux.intel.com>
 <20200915132725.a2qbdio3jsu7rsqs@treble>
 <20200915133929.GI14436@zn.tnic>
 <20200916160419.GB21026@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200916160419.GB21026@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 16, 2020 at 07:04:19PM +0300, Jarkko Sakkinen wrote:
> The duplicate versions of v38 are equal. The "backup" server was just
> really slow with vger. That's why I retried.

Well, vger has been really slow for a while now...

> As can be seen here both v38's are also complete:
> 
> https://lore.kernel.org/linux-sgx/
> 
> I've tried for months to get kernel.org account but I have troubles
> getting my PGP trusted.

Have you tried this:

https://korg.docs.kernel.org/accounts.html

?

I believe you'll find enough people within Intel who are in the web of
trust.

> I really would like to move the whole thing over there. And use that
> account for email.

https://korg.docs.kernel.org/mail.html

You'd need mailbox hosting etc as k.org doesn't have that.

> Three maintainers have signed my key but when I do gpg --refresh, I
> do not get any signatures for my key. The command uses keys.openpgp.org.
> I have no idea if that is the correct key server or not. And I have no
> idea how PGP servers mirror stuff with each other. And I have not found
> anything on this from kernel documentation (e.g. PGP maintainer guide).

Yeah, see that accounts.html link I pasted above - "Exporting your
public key".

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
