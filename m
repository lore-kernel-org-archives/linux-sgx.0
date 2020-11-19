Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA096C5519F
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 01:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7892C22260
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 01:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="M/eizIq7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgKSBQ4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Nov 2020 20:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgKSBQ4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 18 Nov 2020 20:16:56 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691B8C0613D4
        for <linux-sgx@vger.kernel.org>; Wed, 18 Nov 2020 17:16:56 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 62so2666088pgg.12
        for <linux-sgx@vger.kernel.org>; Wed, 18 Nov 2020 17:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=2GHzrJxMvHukv63GTTgJprc5vAmkA5WKHyRpGOGWTdU=;
        b=M/eizIq78tHHcr/fPSSMuYNF76N4b4f/jTBVGLOJFnDM+DBrxXPjRXioI5H8amRggT
         LUAPFaU6eleFFFsq3Qf76QVMuSdYteN4NS2cv3fl41TO0ttOBdaCvpwXOcIDiDy1U2et
         /xmD1WLdnM4NEnvdDAFONlfvanKZ+Ii6aAHzwmAj44wp4w9wJlUlJjaMKunjtDgd8yPk
         b4vd6VY6w6n6k9Aph3yv0kejgt1JkFelGG9Y/0ILlLeqK85No4zWqId5TCLWLirJweiD
         GYVPA/uVVJ1uPY0bfCY3KXu7Izw8NnKbdkuHO9QhwYZYDOnklGPYcjWL3q5nkfoB6fsk
         owAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=2GHzrJxMvHukv63GTTgJprc5vAmkA5WKHyRpGOGWTdU=;
        b=l5Qv4YX4/VpaI7x0ioUCV2IlyiiCSTTQBdlE3n66YG4AlLwiYAnT8LxWDEcJJnhHWl
         RiKmUwU14xZEBfVMisHBS3vku/UIO8VDbzWvFjIPLOSViRAWBh/3OC9h/YzQOMwnDMc8
         1rSkj0+PZIKb8+Rf06NsOde4Z6kA0LvQBdQCfNazma/7H6nC6APTul52wNko+y5B9l5K
         3OXHBII22C1qNe5BsbqBxZSTj/dW7JgqhIIrIE5vgE6LCQ9ButxTY/PfwgL/IGFSN1R/
         d05hASTlOM89ooNYm4rc34zvbDQEOe1G5pqxVG6lXgUNfkHqBHnvcFjTTqrzFxx1e365
         JZbw==
X-Gm-Message-State: AOAM532rp1dP+PvjMdzN1IWV2cEOM3npKZSqblddwmCl+n+xSg9lEzqt
        mkRyMIY9qqLj+Ic9Ien9+G1Yig==
X-Google-Smtp-Source: ABdhPJy8tlcVF8aiTOgLbctszIcuUOPba2z9JdZ26ff1reBPfahlfEpJ0NtKcHHR6hswWwA20OMMwQ==
X-Received: by 2002:a17:90b:344c:: with SMTP id lj12mr222201pjb.115.1605748616014;
        Wed, 18 Nov 2020 17:16:56 -0800 (PST)
Received: from [192.168.0.122] (c-67-180-165-146.hsd1.ca.comcast.net. [67.180.165.146])
        by smtp.gmail.com with ESMTPSA id m18sm19868739pfk.10.2020.11.18.17.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 17:16:55 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] selftests/x86: Fix malformed src_offset initialization
Date:   Wed, 18 Nov 2020 17:16:53 -0800
Message-Id: <AA92701F-05C7-4551-9C26-39946CC55B0A@amacapital.net>
References: <20201118215446.GO7472@zn.tnic>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
In-Reply-To: <20201118215446.GO7472@zn.tnic>
To:     Borislav Petkov <bp@alien8.de>
X-Mailer: iPhone Mail (18B92)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Nov 18, 2020, at 1:54 PM, Borislav Petkov <bp@alien8.de> wrote:
>=20
> =EF=BB=BFOn Wed, Nov 18, 2020 at 11:37:55PM +0200, Jarkko Sakkinen wrote:
>> Just checking that I got this right: you want me to port my anon inode
>> changes from March to be applied on top of tip and send them?
>=20
> Well, we need to somehow address the issue when some distros map /dev
> noexec and that is conflicting with SGX due to it needing to mmap with
> executable permissions but /dev/sgx_enclave is noexec...
>=20
> I guess the first thing that needs figuring out is why are some distros
> mounting /dev noexec.
>=20
> I mean, you can always do the easiest thing: somewhere in the SGX
> docs say that one of the steps towards running SGX enclaves on such
> distros is for the admin to map /dev exec. However, does that have other
> security implications which would make such exec mounting a security
> hazard?
>=20
> If so, then the SGX code would need changing...
>=20
> Questions like those.

I thought we had determined that this was solvable entirely in userspace.  U=
dev can handle this, no?

>=20
> HTH.
>=20
> --=20
> Regards/Gruss,
>    Boris.
>=20
> https://people.kernel.org/tglx/notes-about-netiquette
