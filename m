Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21313C433E3
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 19:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F380420772
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 19:05:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="lpuiljhh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHRTFG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 15:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHRTFE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 18 Aug 2020 15:05:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6881C061389
        for <linux-sgx@vger.kernel.org>; Tue, 18 Aug 2020 12:05:04 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y10so8090841plr.11
        for <linux-sgx@vger.kernel.org>; Tue, 18 Aug 2020 12:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=iJEogTWaQQgJpwgjOtv0l5zlRP2LWGmQZ1fuFNbF9jo=;
        b=lpuiljhhgfY+//KXDeGeM354jsiqtqo6FoDJqudVsi/5jS6wgfleD9Hu6euyeDdVKA
         zkEZ3JRDVmn/TKEurmggf0UcAJ6nApkaGzO09Kflf0Ru+AI5ZWhQsfcGtSjEwlQAZVgj
         /bJtNlyBXh6v24bmW5H17rc36Hv/Qi1ejqHjaQgQgUhg+L6J9kh2V/vaDjJ0SZiHJcDi
         hKoB6T7MZXousGZyb3wM5T5jM0LRq3h97LJTf7riWtizYYV3jx0uKE7vFxt/ZPqFIAxu
         WXFlgd5qOhaEq6Ni4dvUYGWr0Hg0bYiagfXUXoKZM8qSM7AawCfq2J/QamkWDzFAL6or
         ydaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=iJEogTWaQQgJpwgjOtv0l5zlRP2LWGmQZ1fuFNbF9jo=;
        b=fyg0mf7msSNLc1BVTgpcJQ9VapkB4nOtLZhWnT7R6mlNYE5gtHPk0TgfC6ysy/9RKi
         MV0e2yLOhtbEG9F9LdLQnXPBuLnfQ1zzzPYSCCFq+JIJev/GAmiy4goIXRLX/7RwRBbu
         5fCpgnpyFrusUeMzILE6F4sHXcurBjla/olqkJUtxTMPUo2vbkP3GxlDUuovZ0ySPrCC
         xuYguPIOnG9r+athLP+bJyVcSYRfbM8yeAm8iuzsyjC1FaD0DXMo0EqDBnvPtNEpmioa
         8pMGnd2WcaUYtRQs4TVAe2vWZqEWPtzH46OKRLUBr10FduxQWLsgDIBizYI292zyaK8t
         2L4w==
X-Gm-Message-State: AOAM533GfKGBrTz+t6LtqnLYsRSmA5GrtNGXXI1g85iF7YulEt1jvd3V
        ALhle0Qme5tDfoBimgkLImnsjoQBZNWfwg==
X-Google-Smtp-Source: ABdhPJz3DNK+F0F7q4OeUcIi7qcWgaVJVlwKv1TKEBM3yvnDozZCAWqyW132tS7c/R3mbhCWcy97SQ==
X-Received: by 2002:a17:902:8543:: with SMTP id d3mr16101106plo.244.1597777503829;
        Tue, 18 Aug 2020 12:05:03 -0700 (PDT)
Received: from ?IPv6:2600:1010:b013:d6bb:3d6c:5d2:3731:26ff? ([2600:1010:b013:d6bb:3d6c:5d2:3731:26ff])
        by smtp.gmail.com with ESMTPSA id c27sm22037811pgn.86.2020.08.18.12.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 12:05:02 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH 4/4] x86/vdso: x86/sgx: Allow the user to exit the vDSO loop on interrupts
Date:   Tue, 18 Aug 2020 12:05:00 -0700
Message-Id: <31D20204-057E-4A08-8DB3-B3CC8E123D24@amacapital.net>
References: <20200818173154.GH15390@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>, linux-sgx@vger.kernel.org
In-Reply-To: <20200818173154.GH15390@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: iPhone Mail (17G68)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> On Aug 18, 2020, at 10:31 AM, Sean Christopherson <sean.j.christopherson@i=
ntel.com> wrote:
>=20
> =EF=BB=BFOn Tue, Aug 18, 2020 at 10:15:49AM -0700, Andy Lutomirski wrote:
>>> On Mon, Aug 17, 2020 at 9:24 PM Sean Christopherson
>>> <sean.j.christopherson@intel.com> wrote:
>>>=20
>>> Allow userspace to exit the vDSO on interrupts that are acknowledged
>>> while the enclave is active.  This allows the user's runtime to switch
>>> contexts at opportune times without additional overhead, e.g. when using=

>>> an M:N threading model (where M user threads run N TCSs, with N > M).
>>=20
>> This is IMO rather odd.  We don't support this type of notification on
>> interrupts for normal user code.  The fact user code can detect
>> interrupts during enclave execution is IMO an oddity of SGX, and I
>> have asked Intel to consider replacing the AEX mechanism with
>> something more transparent to user mode.  If this ever happens, this
>> mechanism is toast.
>>=20
>> Even without architecture changes, building a *reliable* M:N threading
>> mechanism on top of this will be difficult or impossible, as there is
>> no particular guarantee that a thread will get timing interrupts at
>> all or that these interrupts will get lucky and hit enclave code, thus
>> triggering an AEX.  We certainly don't, and probably never will,
>> support any corresponding feature for non-enclave code.
>>=20
>> So this seems like an odd, and possibly unsupportable, feature to add.
>=20
> I 100% agree that allowing the user to act on interrupts is weird/fragile.=

> I'll happily kill this off if there's an "official" NAK, but I wanted to
> force the issue so that we're not stuck in limbo wondering whether or not
> this should be supported.

If you would like an official NAK, here you go: NAK!

If users want M:N and SIGALRM isn=E2=80=99t good enough, add something bette=
r. Please don=E2=80=99t rely on an architectural wart as an alternative.=
