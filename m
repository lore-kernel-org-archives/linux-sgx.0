Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D497C433DB
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Mar 2021 01:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E9865252
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Mar 2021 01:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCIBWA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Mar 2021 20:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhCIBVv (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 8 Mar 2021 20:21:51 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CEFC06174A
        for <linux-sgx@vger.kernel.org>; Mon,  8 Mar 2021 17:21:51 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id k2so12165139ioh.5
        for <linux-sgx@vger.kernel.org>; Mon, 08 Mar 2021 17:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SBgaCx4Kgy4zSOnyXBRYaY7wtExb8F1UAm82JRel65I=;
        b=UkBDGOfxnT8tG4TtZZHWkkYHKlW9INiQ3r+pwTpoUgI/0I1AKf3pA8SQbyJbK/sne8
         +L4OzmKtV7b9OU14U4yNk64bIgVaVX9eBBwHvqqJUDXvmValk2BhgQlvbSsCWBooCT8S
         i1Im/fli15oyFHF2nFiiw/Hof9h2cLEIlX08MXJEWaL+5OItzN31pjVl88GJyQQbAjpC
         NKhO/RBEBQLHb6EI1bziMCvEVZbsKY3m7P2pCJOIH+GXdrKVzMqC3fL+rRFJKpc/qJg3
         GWr7eUbvSnXPEytRQFJJwGURHS99jbAAirzmaKQNjzBUvyoFLn0blGP2UhJr7eqZICpF
         Q0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SBgaCx4Kgy4zSOnyXBRYaY7wtExb8F1UAm82JRel65I=;
        b=tYb1ilFBcR7Y5zwA+K5+nGPS/mjdW+d/BfEubqBGH+cYU59+2S00zHJJ2ePQPOyHhE
         J9X6gloGPyYriVl3hirguoSDDnsd0tWI0bHcMGjTt6RYHnoK6yvsnyC+ZDruGLBDzC1w
         cllCdn9sojo/Fn1CYbrp2kFfgSTigVjI7R2XOv34bxwUBpcAWxTStb0h7H3/PlI5PXsq
         QyNWqM3DjqcrLDNBCEf/7cosHtVAs/TiVvS4O09+Szal/9JyKSdo3GfkHAMEordHbLWJ
         U2xwQkvtm0XSxhZRkMoaCf0X3QlsfG7Mk9qcmcl0FU0fSAar1iBoiQzLQmWCBBXFMCsn
         bAzg==
X-Gm-Message-State: AOAM532mDv+EjvZu+w/HDSSBiQyK3ZSH/fq9/mG8lH2VF1s9mHRXdelv
        mKEWQJlDnpZwZ0ERv1fEKSkjMBARqoV64q8X+eeP1/wZvZUEbw==
X-Google-Smtp-Source: ABdhPJylw6gTPWvxkpZIzajxGqGvlH//PeCyb3ZJ8+20LjjvPRdThWCOoscjV0hYKLBK4tms0vHttlwzCbd2QQMfnds=
X-Received: by 2002:a02:6a0b:: with SMTP id l11mr26177218jac.82.1615252910995;
 Mon, 08 Mar 2021 17:21:50 -0800 (PST)
MIME-Version: 1.0
References: <399c5f27-1387-55c5-e147-f7885bf86df5@sr71.net>
In-Reply-To: <399c5f27-1387-55c5-e147-f7885bf86df5@sr71.net>
From:   Joman Chu <jomanchu@gmail.com>
Date:   Mon, 8 Mar 2021 20:21:12 -0500
Message-ID: <CABjqtEG5yL3aCnr8Kk8ZOJDDa49K=ESx6-mgm_EnYcCDcYpDCg@mail.gmail.com>
Subject: Re: SGX Linux-Compatible Hardware
To:     Dave Hansen <dave@sr71.net>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 8, 2021 at 8:04 PM Dave Hansen <dave@sr71.net> wrote:
>
> It can be somewhat challenging to find hardware which works.  For
> instance I've got a i7-8086K which has all of the processor support
> required for SGX, but the system firmware still opts to lock the Launch
> Control MSRs.

In my experience there isn=E2=80=99t much hardware that supports Flexible
Launch Control (FLC). The Intel blog post from 2018 that announces FLC
lists two NUCs (NUC7CJYH and NUC7PJYH) and the Xeon E processors.[1]

The feature also requires BIOS enablement so you might have to confirm
with an OEM. Last time I researched this in July 2020, Dell and
Supermicro had single-processor platforms that claimed to support it,
but I never followed through with actual hardware.

My apologies if you got this message twice, had an email client issue.

[1]: https://software.intel.com/content/www/us/en/develop/blogs/an-update-o=
n-3rd-party-attestation.html
