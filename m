Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4387C27C7A
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Aug 2023 07:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348550AbjHQHkT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Aug 2023 03:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348564AbjHQHjs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 17 Aug 2023 03:39:48 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C562D63
        for <linux-sgx@vger.kernel.org>; Thu, 17 Aug 2023 00:39:47 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-5254f9eda36so6238709a12.1
        for <linux-sgx@vger.kernel.org>; Thu, 17 Aug 2023 00:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1692257986; x=1692862786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tm/lQqSkTMQ1aJMMLX/MprKOESL3heohmQttU34o12c=;
        b=TldjcSeQkhpZ67EtMobJAAfzszDz89zEgRjNhqtgwYIZ8JmMEp//jBZJD61B5AHa2N
         FXgT4EuslebgFnmKB1jcLj/nok966fNDfgJAEqE42JKRB2OTUnsoDMYOZAdOlE7nEntJ
         ZO3L/UTyRRQWOSw1w3x6VR83fuep6HouKR8IGD7FvuMGPmtIZlHumZ5SpgTZC2D0yjeQ
         8r49Ol3o9nOWqhThkIcIxSDwz3MtqXbii0VwmfoonP8I1sFDminTbwPcsiOOa6qGpcZ6
         F2KoxxlCzbFT31T5E9ptHo8HvD46Les/j9JyyjGSwjj3IDEAWs7kNKbJjA0SpqOgAcJx
         3ZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692257986; x=1692862786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tm/lQqSkTMQ1aJMMLX/MprKOESL3heohmQttU34o12c=;
        b=SAip8KW5eeX6rkFwN9MKfogR/5uNV129QZAzAyIpFH+5mrh8QFxoDDN1OIeKjohY/u
         CbZk9Ae86+dOwnmvMe4PYD/s1VB83EC/RGd1QHIsRmeHb/JjEglPbirWO3oqAif+UZs1
         4zfvU233J4/wILiZLSI92TxAUpAuOAa/AB0SNnPDSIX5WtSJcQ2VrcB/XW2wSWq90Mhw
         hb51xx0FZNdL3evv3MP5CzeV0DqV/xEb9BVTcFMevrvKzx+U2mJuiauuElldskCwpkRr
         IdHQJMujbqr/xRyqt/TxJtxYhVsUrWp5xR87tYT0x2AtyDJYFJEp3Ged5Z/08CSxy68p
         v5Lw==
X-Gm-Message-State: AOJu0YxvAm/AFPESvmzPEHJKhOKf3aXM71/E6LFZ7aqr7M8PyfZn8OqD
        0UR/ZtdjxQDc/lwfB1px5H27NMDYJ0JdyxSOWZlGEg==
X-Google-Smtp-Source: AGHT+IHNwwTGuz9vavBV3GaGKrCZrBLUZCs0ugjtfOVpgl7POS+AFC1+COgIyr/QvG+TfX8B4sAW9GlZKbWi3+KPwBE=
X-Received: by 2002:a05:6402:517b:b0:523:bfec:4910 with SMTP id
 d27-20020a056402517b00b00523bfec4910mr3558329ede.8.1692257985828; Thu, 17 Aug
 2023 00:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230814043714.107971-1-jinpu.wang@ionos.com> <3954697abb1a6c84c4b30fbd0d5edcafae6f6966.camel@intel.com>
 <CUU98FETTOER.MLJEHF8QNJ6L@suppilovahvero>
In-Reply-To: <CUU98FETTOER.MLJEHF8QNJ6L@suppilovahvero>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Aug 2023 09:39:34 +0200
Message-ID: <CAMGffE=aFsUmHjQaJFJ_xycX8m_MehzBbUoiz3uSLUJkDLysHg@mail.gmail.com>
Subject: Re: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "yu.zhang@ionos.com" <yu.zhang@ionos.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 16, 2023 at 10:34=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org=
> wrote:
>
> On Tue Aug 15, 2023 at 2:58 AM EEST, Huang, Kai wrote:
> > On Mon, 2023-08-14 at 06:37 +0200, Jack Wang wrote:
> > > We hit softlocup with following call trace:
> > >  kernel: [ 2041.288210] Call Trace:
> > > kernel: [ 2041.288213]  <IRQ>
> > > kernel: [ 2041.288216]  ? watchdog_timer_fn+0x1b4/0x210
> > > kernel: [ 2041.288222]  ? lockup_detector_update_enable+0x50/0x50
> > > kernel: [ 2041.288225]  ? __hrtimer_run_queues+0x127/0x280
> > > kernel: [ 2041.288230]  ? hrtimer_interrupt+0xfc/0x210
> > > kernel: [ 2041.288233]  ? __sysvec_apic_timer_interrupt+0x59/0xd0
> > > kernel: [ 2041.288237]  ? sysvec_apic_timer_interrupt+0x6d/0x90
> > > kernel: [ 2041.288242]  </IRQ>
> > > kernel: [ 2041.288242]  <TASK>
> > > kernel: [ 2041.288244]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> > > kernel: [ 2041.288250]  xa_erase+0x21/0xb0
> > > kernel: [ 2041.288256]  ? sgx_free_epc_page+0x20/0x50
> > > kernel: [ 2041.288260]  sgx_vepc_release+0x75/0x220
> > > kernel: [ 2041.288263]  __fput+0x89/0x250
> > > kernel: [ 2041.288269]  task_work_run+0x59/0x90
> > > kernel: [ 2041.288275]  do_exit+0x337/0x9a0
> > >
> > > Similar like 8795359e35bc ("x86/sgx: Silence softlockup detection whe=
n releasing large enclaves")
> > > The test system has 64GB of enclave memory, and all assigned to a sin=
gle
> > > VM. Release vepc take longer time and triggers the softlockup warning=
.
> > >
> > > Add a cond_resched() to give other tasks a chance to run and placate
> > > the softlockup detector.
> > >
> > > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > > Cc: Haitao Huang <haitao.huang@linux.intel.com>
> > > Reported-by: Yu Zhang <yu.zhang@ionos.com>
> > >
> > > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> > > ---
> > >  arch/x86/kernel/cpu/sgx/virt.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx=
/virt.c
> > > index c3e37eaec8ec..01d2795792cc 100644
> > > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > > @@ -204,6 +204,7 @@ static int sgx_vepc_release(struct inode *inode, =
struct file *file)
> > >                     continue;
> > >
> > >             xa_erase(&vepc->page_array, index);
> > > +           cond_resched();
> > >     }
> > >
> > >     /*
> > > @@ -222,6 +223,7 @@ static int sgx_vepc_release(struct inode *inode, =
struct file *file)
> > >                     list_add_tail(&epc_page->list, &secs_pages);
> > >
> > >             xa_erase(&vepc->page_array, index);
> > > +           cond_resched();
> > >     }
> > >
> > >     /*
> >
> > This adds cond_resched() to the first two loops: releasing non-SECS pag=
es and
> > releasing SECS pages which don't have children on remote vepc instance(=
s).
> > There is a third round loop to release SECS pages which have children o=
n remote
> > vepc instance(s).  I think it's better to add cond_resched() there too,=
 although
> > it's extremely unlikely it could trigger softlockup w/o cond_resched().
> >
> > Also similar to 8795359e35bc ("x86/sgx: Silence softlockup detection wh=
en
> > releasing large enclaves"), this looks stable-kernel material.  So perh=
aps add:
> >
> > Cc: stable@vger.kernel.org
>
> + would not hurt to have also fixes tag for clarity.
>
> BR, Jarkko

I did it in v2 here,

https://lore.kernel.org/linux-sgx/3b93dfa438fb2f42f917393c3752ffc2dec35e52.=
camel@intel.com/T/#t

Thx for the review!


>
