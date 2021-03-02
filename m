Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B63C43331
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Mar 2021 21:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 689CD64F32
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Mar 2021 21:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351086AbhCBVmy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Mar 2021 16:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347729AbhCBFzi (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 2 Mar 2021 00:55:38 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A93C061788
        for <linux-sgx@vger.kernel.org>; Mon,  1 Mar 2021 21:54:50 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id c10so6413138ejx.9
        for <linux-sgx@vger.kernel.org>; Mon, 01 Mar 2021 21:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aE+beNEvjt+160qICUV7IW22PMXdqkQSosAMIz1xiew=;
        b=WXL+m7DRhhTeLqDdtfvsyVgKScs9OwWTmM/xgUe1SyOWhjUzhsDJTrwJgnKsw75Jn6
         rtjD67UCYwKWCmc8PPl/ipC/XXRzZT43+wZclDZFNHQ67r9WBWIXh6Tj8h73YLm37uJ0
         2yhEwxOqEjfinVj5VgHs1UEPPrNj4eIJhUzHsYNvLmW9Bp6oYIVU5LKQeJRReb3akX1m
         7aKWpkdEPl80e5a7FTjDxsGmtRQYuniOjkqtYtItmtjkFtV4UwGx5nVC+fU5GZN6R4QY
         s8renkHa7QhI+BcnrvbcXFHgDxp3tAuBOlcI+Qlmbzxneh+0jZP3is0fvU6yt+2Z2jlN
         Z5eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aE+beNEvjt+160qICUV7IW22PMXdqkQSosAMIz1xiew=;
        b=TNTwje4tzbCvFLKgw1kaXInrWa0kwPZOKUQyQD9Ky+qxPt7MrBdxLwarzXkEMgCERw
         MoYkrpWuQD2iVz63lz4WHuaycjbx0yLY6vGTINohGYWZIZ1BVQbSFOJHhqWcPtFVu2E1
         XWGb8agoAYHto0mxD3bDnWfoEoGYa/Rmv6QvRz+Osc0jrCjXHMNuN+05oaB+dZ7tC87W
         /ltsM6CCVGiNfTGptNHab2ZdEc6pkxbU4qYCVCN3bh9XkEB2JIT6RwUsnpA3oKmCOnw9
         d/mONKToNpp2cIL0FbnSZX/kiHZJCo6yrplxtJ8K+NM4ZEUUqjvx1t+9LBMGE3uUqg/R
         EElA==
X-Gm-Message-State: AOAM531C8pXTPfEGfqxTYDKT/UTogvHeBa4waGgmIPxuAyaNnhA8OAEb
        BcYmrDNU7cTkM9u9HSU+J16T8Y0XQPCviGbPtvn3fw==
X-Google-Smtp-Source: ABdhPJwSyP3rZz9B4pZY1h/aOwj6LhLQmjVjevIubruhpfuMPVRGPhMf/FlYnDqki0sGBW+2oOURnsaWtJIfRlZxJ30=
X-Received: by 2002:a17:906:a896:: with SMTP id ha22mr19188137ejb.503.1614664489221;
 Mon, 01 Mar 2021 21:54:49 -0800 (PST)
MIME-Version: 1.0
References: <20210301051836.30738-1-tianjia.zhang@linux.alibaba.com>
 <YDy51R2Wva7s+k/x@kernel.org> <3bcdcf04-4bed-ed95-84b6-790675f18240@linux.alibaba.com>
In-Reply-To: <3bcdcf04-4bed-ed95-84b6-790675f18240@linux.alibaba.com>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Mon, 1 Mar 2021 21:54:37 -0800
Message-ID: <CALCETrVn_inXAULfsPrCXeHUTBet+KnL1XsxuiaR+jgG1uTJNg@mail.gmail.com>
Subject: Re: [PATCH] selftests/sgx: fix EINIT failure dueto SGX_INVALID_SIGNATURE
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Shuah Khan <shuah@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 1, 2021 at 9:06 PM Tianjia Zhang
<tianjia.zhang@linux.alibaba.com> wrote:
>
>
>
> On 3/1/21 5:54 PM, Jarkko Sakkinen wrote:
> > On Mon, Mar 01, 2021 at 01:18:36PM +0800, Tianjia Zhang wrote:
> >> q2 is not always 384-byte length. Sometimes it only has 383-byte.
> >
> > What does determine this?
> >
> >> In this case, the valid portion of q2 is reordered reversely for
> >> little endian order, and the remaining portion is filled with zero.
> >
> > I'm presuming that you want to say "In this case, q2 needs to be reversed because...".
> >
> > I'm lacking these details:
> >
> > 1. Why the length of Q2 can vary?
> > 2. Why reversing the bytes is the correct measure to counter-measure
> >     this variation?
> >
> > /Jarkko
> >
>
> When use openssl to generate a key instead of using the built-in
> sign_key.pem, there is a probability that will encounter this problem.
>
> Here is a problematic key I encountered. The calculated q1 and q2 of
> this key are both 383 bytes, If the length is not processed, the
> hardware signature will fail.

Presumably the issue is that some keys have parameters that have
enough leading 0 bits to be effectively shorter.  The openssl API
(and, sadly, a bunch  of the ASN.1 stuff) treats these parameters as
variable-size integers.

>
> -----BEGIN RSA PRIVATE KEY-----
> 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
> -----END RSA PRIVATE KEY-----
>
> good luck!
>
> Tianjia
>


-- 
Andy Lutomirski
AMA Capital Management, LLC
