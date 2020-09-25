Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C45DC4363D
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 08:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8F69208A9
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 08:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="UUkNyaTo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgIYI2P (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:28:15 -0400
Received: from mail.skyhub.de ([5.9.137.197]:36820 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbgIYI2P (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Sep 2020 04:28:15 -0400
Received: from zn.tnic (p200300ec2f0b3a0093be1e56408cfaf4.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:3a00:93be:1e56:408c:faf4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B47501EC0430;
        Fri, 25 Sep 2020 10:28:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1601022493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=aBvHXwx9a9PqqUZzuoVpY410vW5jppv7nSFihXyq/xQ=;
        b=UUkNyaTo5MHxuo5KXBUniRQ5MFQbOkTYQvRMMJhSYw00RwnQtQdAVPyGDWxEt8VS1JcpRe
        ++qVWlkXZz9wcal/MNO0QjzcLLFHUREbPPtHvKZLAicOzfqZn0eS+Fp71IvZW7TJMfcyLK
        RjxBAlC2V5hnTwqNkca3FdXgVTI+YnA=
Date:   Fri, 25 Sep 2020 10:28:07 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
Message-ID: <20200925082807.GG16872@zn.tnic>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <20200924180407.GO5030@zn.tnic>
 <20200925010031.GH119995@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200925010031.GH119995@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 25, 2020 at 04:00:40AM +0300, Jarkko Sakkinen wrote:
> I renamed it as vsgx.S (for the sake of convention).

Right.

> I have not authored this patch but what I would propose is to use just
> raw value in the place of these constants. It is practially just a
> boolean value.
> 
> I can also add sgx_vdso.h to uapi directory. I just don't see the point.

Just be very cautious what you add to the uapi/ directory because it
becomes API and there's no changing it. That's why I point you guys to
it, to think hard what you expose there and that it becomes contract
with luserspace.

> > I can see why you would write "TCS" though - there's a thread control
> > structure thing too in that patch.
> 
> Renamed.

See Sean's reply.

> /**
>  * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
>  *					__vdso_sgx_enter_enclave()
>  * @rdi:	RDI snapshot
>  * @rsi:	RSI snapshot
>  * @rdx:	RDX snapshot
>  * @rsp:	RSP snapshot (untrusted stack)
>  * @r8:		R8 snapshot
>  * @r9:		R9 snapshot

I'd say here:

"The registers' content is the snapshot made at enclave exit."

> Also, I renamed 'r' as 'run' in some places.
> 
> End result:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git/tree/arch/x86/include/uapi/asm/sgx.h
> 
> I'm wondering this sentence:
> 
> "The calling convention is custom and does not follow System V x86-64 ABI."

Yeah, I was wondering what that meant too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
