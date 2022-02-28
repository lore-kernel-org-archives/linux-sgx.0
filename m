Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4019C433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Feb 2022 20:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiB1UP5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiB1UP4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 28 Feb 2022 15:15:56 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A604D3D4AA
        for <linux-sgx@vger.kernel.org>; Mon, 28 Feb 2022 12:15:16 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id u11so19021399lju.4
        for <linux-sgx@vger.kernel.org>; Mon, 28 Feb 2022 12:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rhevy6fb5H45VxDHjLDNCxtPhjJ0u7uFLdfSx9pxlIs=;
        b=SFiiDaskyFzzbW4jCoUqiJYglpNWscp1lwtLHE93w8dRI3h8eXZkrLgebAKqQfA9oZ
         haXikdZXvfEB810zRURGwChdn/CvMC8Q7Pab3hpE0iVI/nf3FVJvcryQMcC1uZhcoZUU
         P6IZH9h2w6s9V+B5fc5q6pR5l/tJkcQrm5JJ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rhevy6fb5H45VxDHjLDNCxtPhjJ0u7uFLdfSx9pxlIs=;
        b=d1WXyi0wAza8hM1/5j27CBQV80TjlFZ1tm8YZTTfpyQI64WdfxNIgA58i5+XJv7T+/
         Vd6nnEN9/CuVewB1YytEroMm5GlFkn4JyvAjp9kN0PPRDBDQ4SjqbXYTPscaC9Ho5fu+
         l2EZabSNBH2spnbjgTGqlpsu9uPxmLHiuUBJPNA3EligAqgfMAVd6XfDFyObpLe1SeIV
         xmOfD6AfIeZuWUX5BcEb9oIn7pc1cha067a+s4OjohEtIaDiN8Kx8PAkIwi66XY+yH2x
         u6DTafJYHYsFPYc6m5pL196W2pXW1F6A3lDDQsaz+W18cVh1hzC5e+0yQ+CdqMiibd5y
         vhGg==
X-Gm-Message-State: AOAM533fnnMrTA5hiJ3ly3rz/FEO2G/vaVb5omIkNeKxMBdoBLcqPwkc
        uJUfKyyJeKY3T2CC6OMG5VJBOPYSMwiNorHaCKo=
X-Google-Smtp-Source: ABdhPJyUyPopy2bHM9GoPK8j2gQJUhvEAYE8xDdG9e15hXVJA5cRPMijgC8+k4Rsk2kbmC6eSpQpwQ==
X-Received: by 2002:a2e:bf13:0:b0:246:753e:e418 with SMTP id c19-20020a2ebf13000000b00246753ee418mr11914138ljr.131.1646079314867;
        Mon, 28 Feb 2022 12:15:14 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id n23-20020a2e86d7000000b002460f3e885asm1513845ljj.20.2022.02.28.12.15.11
        for <linux-sgx@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 12:15:13 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id u20so23364954lff.2
        for <linux-sgx@vger.kernel.org>; Mon, 28 Feb 2022 12:15:11 -0800 (PST)
X-Received: by 2002:a2e:924d:0:b0:246:370c:5618 with SMTP id
 v13-20020a2e924d000000b00246370c5618mr15110351ljg.358.1646079300900; Mon, 28
 Feb 2022 12:15:00 -0800 (PST)
MIME-Version: 1.0
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com> <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <CAHk-=wj8fkosQ7=bps5K+DDazBXk=ypfn49A0sEq+7-nZnyfXA@mail.gmail.com> <CAHk-=wiTCvLQkHcJ3y0hpqH7FEk9D28LDvZZogC6OVLk7naBww@mail.gmail.com>
In-Reply-To: <CAHk-=wiTCvLQkHcJ3y0hpqH7FEk9D28LDvZZogC6OVLk7naBww@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 28 Feb 2022 12:14:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj27SZQ3kPTesBzkiGhe-mA3gOQqr_adt_bMFzmg1VNaA@mail.gmail.com>
Message-ID: <CAHk-=wj27SZQ3kPTesBzkiGhe-mA3gOQqr_adt_bMFzmg1VNaA@mail.gmail.com>
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc:     Jakob Koschel <jakobkoschel@gmail.com>,
        alsa-devel@alsa-project.org, linux-aspeed@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-staging@lists.linux.dev, "Bos, H.J." <h.j.bos@vu.nl>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sgx@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        tipc-discussion@lists.sourceforge.net,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Feb 28, 2022 at 12:10 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> We can do
>
>         typeof(pos) pos
>
> in the 'for ()' loop, and never use __iter at all.
>
> That means that inside the for-loop, we use a _different_ 'pos' than outside.

The thing that makes me throw up in my mouth a bit is that in that

        typeof(pos) pos

the first 'pos' (that we use for just the typeof) is that outer-level
'pos', IOW it's a *different* 'pos' than the second 'pos' in that same
declaration that declares the inner level shadowing new 'pos'
variable.

If I was a compiler person, I would say "Linus, that thing is too ugly
to live", and I would hate it. I'm just hoping that even compiler
people say "that's *so* ugly it's almost beautiful".

Because it does seem to work. It's not pretty, but hey, it's not like
our headers are really ever be winning any beauty contests...

                Linus
