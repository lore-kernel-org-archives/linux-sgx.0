Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 392F3C27C7A
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Aug 2023 07:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348461AbjHQHig (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Aug 2023 03:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348601AbjHQHiV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 17 Aug 2023 03:38:21 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63482711
        for <linux-sgx@vger.kernel.org>; Thu, 17 Aug 2023 00:38:18 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-5236c9ff275so10012858a12.1
        for <linux-sgx@vger.kernel.org>; Thu, 17 Aug 2023 00:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1692257897; x=1692862697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tnHZeC4OHlm3dVvK23GMzHfxsVEYTo9JWpzfHBjyCcE=;
        b=LuVq2x9Fe0AaX1utg9KYAUBE6kXyBynOWHJNfMpp8zbu7aJ8TL2lLEnT2otZQMuDyW
         1+eCobTfVij0l7C+ynovP61j215hJ1WvhvY2BUv3wBqnDtYpCf9h55Yoio5K0LVgYWm+
         Vxy5lZo0CFtc4zeIfrA4KMgBHpUeWtbOCFxNlO5Er1seBPJ5scFyDVAd10mxTLw2b7mp
         I9JsNzA6+f2t2q49WAJ99Z+gOJ6e9z82Wtqv3YVf4/2o/oaCmboORHl9fMHAObYGClNV
         Oxm26xgqOE7PKNp8qF+K9EnCAA3yfrkubfTYp1vWUa3Pat3x+xo7+leNZFxtA5Rw3T6t
         LBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692257897; x=1692862697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tnHZeC4OHlm3dVvK23GMzHfxsVEYTo9JWpzfHBjyCcE=;
        b=SGEgSsB71JZRtdRSaUg50mfEsRG5sqQ5l6HeRc7SpXTo2wdtW+aykxiE3nWgHF0SiX
         WwhI/Ambr/a9E7x0czl2H43mRfgYTjI9drB0N6DI1s4iDuqnHIFP5BiTX8bt192bmV0G
         3xD9nLqx2i1Ri6rj1lXushXqej/iscVSZddEWn6PUbpfkdkqeXY5wYUG76hBLK9HAjJV
         L/bKCqTJPd7v6PhMUPe0rvBC5LvGJf8Yq+zy1oCxFol+f4r4yV4MSed29U2FVLphLhZ/
         /1NjBtsfSV9V0h0NLmOxCb1rzONDu9pTZnxLvoNfHO5PH+EvBNKYdGxPiUlO/Y96W+XQ
         9oaQ==
X-Gm-Message-State: AOJu0Yy5Qlg6lZNOkAte7E0auvkVGmQHU4OQ0rpefLIrE/XPItS2Tkzu
        NEliMG8A+p0/yGcCZdzXzhfx219QZNIWXTE+lVT9Xw==
X-Google-Smtp-Source: AGHT+IGxe7eQSbUJEBdO+uXj9dwNJ0UGzwDxs97yW6RAz8+XNiuu8RIJTjQyyWZvFHFU0D3hDW2uS4z0dFSet9LrqbA=
X-Received: by 2002:a05:6402:b3c:b0:523:38f5:c5ad with SMTP id
 bo28-20020a0564020b3c00b0052338f5c5admr3391412edb.20.1692257897314; Thu, 17
 Aug 2023 00:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230814043714.107971-1-jinpu.wang@ionos.com> <3954697abb1a6c84c4b30fbd0d5edcafae6f6966.camel@intel.com>
In-Reply-To: <3954697abb1a6c84c4b30fbd0d5edcafae6f6966.camel@intel.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Aug 2023 09:38:06 +0200
Message-ID: <CAMGffEk_ojyRsMy_7d1R0aacwNQ0itDV+ZYTDH0Fpoy03iPkTg@mail.gmail.com>
Subject: Re: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "yu.zhang@ionos.com" <yu.zhang@ionos.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Kai,

On Tue, Aug 15, 2023 at 1:58=E2=80=AFAM Huang, Kai <kai.huang@intel.com> wr=
ote:
>
> On Mon, 2023-08-14 at 06:37 +0200, Jack Wang wrote:
> > We hit softlocup with following call trace:
> >  kernel: [ 2041.288210] Call Trace:
> > kernel: [ 2041.288213]  <IRQ>
> > kernel: [ 2041.288216]  ? watchdog_timer_fn+0x1b4/0x210
> > kernel: [ 2041.288222]  ? lockup_detector_update_enable+0x50/0x50
> > kernel: [ 2041.288225]  ? __hrtimer_run_queues+0x127/0x280
> > kernel: [ 2041.288230]  ? hrtimer_interrupt+0xfc/0x210
> > kernel: [ 2041.288233]  ? __sysvec_apic_timer_interrupt+0x59/0xd0
> > kernel: [ 2041.288237]  ? sysvec_apic_timer_interrupt+0x6d/0x90
> > kernel: [ 2041.288242]  </IRQ>
> > kernel: [ 2041.288242]  <TASK>
> > kernel: [ 2041.288244]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> > kernel: [ 2041.288250]  xa_erase+0x21/0xb0
> > kernel: [ 2041.288256]  ? sgx_free_epc_page+0x20/0x50
> > kernel: [ 2041.288260]  sgx_vepc_release+0x75/0x220
> > kernel: [ 2041.288263]  __fput+0x89/0x250
> > kernel: [ 2041.288269]  task_work_run+0x59/0x90
> > kernel: [ 2041.288275]  do_exit+0x337/0x9a0
> >
> > Similar like 8795359e35bc ("x86/sgx: Silence softlockup detection when =
releasing large enclaves")
> > The test system has 64GB of enclave memory, and all assigned to a singl=
e
> > VM. Release vepc take longer time and triggers the softlockup warning.
> >
> > Add a cond_resched() to give other tasks a chance to run and placate
> > the softlockup detector.
> >
> > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > Cc: Haitao Huang <haitao.huang@linux.intel.com>
> > Reported-by: Yu Zhang <yu.zhang@ionos.com>
> >
> > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/virt.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/v=
irt.c
> > index c3e37eaec8ec..01d2795792cc 100644
> > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > @@ -204,6 +204,7 @@ static int sgx_vepc_release(struct inode *inode, st=
ruct file *file)
> >                       continue;
> >
> >               xa_erase(&vepc->page_array, index);
> > +             cond_resched();
> >       }
> >
> >       /*
> > @@ -222,6 +223,7 @@ static int sgx_vepc_release(struct inode *inode, st=
ruct file *file)
> >                       list_add_tail(&epc_page->list, &secs_pages);
> >
> >               xa_erase(&vepc->page_array, index);
> > +             cond_resched();
> >       }
> >
> >       /*
>
> This adds cond_resched() to the first two loops: releasing non-SECS pages=
 and
> releasing SECS pages which don't have children on remote vepc instance(s)=
.
> There is a third round loop to release SECS pages which have children on =
remote
> vepc instance(s).  I think it's better to add cond_resched() there too, a=
lthough
> it's extremely unlikely it could trigger softlockup w/o cond_resched().

I also think the third one are extremely unlikely could cause softlockup.
And our tests do not hit it either.

>
> Also similar to 8795359e35bc ("x86/sgx: Silence softlockup detection when
> releasing large enclaves"), this looks stable-kernel material.  So perhap=
s add:
>
> Cc: stable@vger.kernel.org

I've added the fixed tag and cc stable in the v2 patch.

Thx for the feedback and review.
