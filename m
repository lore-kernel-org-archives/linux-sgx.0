Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB945C2FC0E
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Aug 2023 07:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348620AbjHQHxx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Aug 2023 03:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239776AbjHQHxa (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 17 Aug 2023 03:53:30 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70951728
        for <linux-sgx@vger.kernel.org>; Thu, 17 Aug 2023 00:53:28 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-523d0fab783so7744733a12.2
        for <linux-sgx@vger.kernel.org>; Thu, 17 Aug 2023 00:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1692258807; x=1692863607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6NdOP8wkVUjVyxwMphs0+hEPd58wqDO/h4xswXfSZs=;
        b=LeOdC3jOPQ+aQVTecpbirGZpyG7jGvlzp1PcLUvT2Nr5k28Mvx+qwSPluDL0xDGGsN
         3/yo5g03ZKcjfvZAT5iETK9b08LinpSGm4uGjXaw/CIDMCJQe75Diyd5w2ue6QYlwZVh
         2pHm1F1f4h0Y9exmEsogxWdfdd3vMH5AgSdIKVT0Nm2dSuL7p9YnIYxnkm+WeUtZtxxV
         3O3j7xQCxbfcBVFq9B2CIXFYz32U95tb6uIb9kANIdGOLR0ea7yyGyo0Cil5JfcHGtrZ
         ErjFG1XPGJ+TW3Dx+MqK8ec/wDfvph/htwaROuptEBF9WDiIr1ARxsBumyHOKdQFPNR3
         lz9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692258807; x=1692863607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k6NdOP8wkVUjVyxwMphs0+hEPd58wqDO/h4xswXfSZs=;
        b=fEAx1dHfh3cb/EtQ4jrEQ5Qm64EX6WDsF8gx4iaaP69zmVxm10wpoc2FSPmVXqYdFH
         oqoVnYkfm++/4pgDTi8c9FPsJJiPYzS3gPw6bFWH07bwr8w9Ysc9qeF689AOxWwXu3wn
         /2MewHvF0h61tZfAF62VdpkL5VeVBfb9vh7VgDFD6SDrhKUA4gUxIEI5TajTSlHH7clV
         Bt0PR7yssQPbLVfSnw/3v52H16CarfEpFcpJa31+4rcfUeoUNqQMj4Gx8xQamOO+685j
         oLz8DvbrGyMUZKigR7RrrlJr+2BsUSqQozkQ7l0Sg99b455pf6GURT0D7Y7Wnw2XDX5e
         kx3g==
X-Gm-Message-State: AOJu0YzeLXS4Xv+4YLqcMHcRkAqwmTeu/tpWwivxWn4saQYh+CuNPrYR
        ylcbdMppCTXgayuq8k4TMMBMhdECEke4nOVzpLsV7Q==
X-Google-Smtp-Source: AGHT+IFcPNIVKraAzo/nPZxL1quP6JI3aQeA2pdOSCa5y5JhgAVR48OgBJ7gduOU9IZcdLxOwKlNU5DESQFdzyPM4J8=
X-Received: by 2002:aa7:d347:0:b0:51b:d567:cfed with SMTP id
 m7-20020aa7d347000000b0051bd567cfedmr3220045edr.5.1692258807380; Thu, 17 Aug
 2023 00:53:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230815182258.177153-1-jinpu.wang@ionos.com> <3b93dfa438fb2f42f917393c3752ffc2dec35e52.camel@intel.com>
In-Reply-To: <3b93dfa438fb2f42f917393c3752ffc2dec35e52.camel@intel.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Aug 2023 09:53:16 +0200
Message-ID: <CAMGffEn8Ky3rDiy4uEB96Lzf_pzk--=q=9DRZ+AbiL4b+CyMyA@mail.gmail.com>
Subject: Re: [PATCHv2] x86/sgx: Avoid softlockup from sgx_vepc_release
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "yu.zhang@ionos.com" <yu.zhang@ionos.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 16, 2023 at 12:13=E2=80=AFPM Huang, Kai <kai.huang@intel.com> w=
rote:
>
> On Tue, 2023-08-15 at 20:22 +0200, Jack Wang wrote:
> > We hit softlocup with following call trace:
>
> Please add an empty line for better readability.
>
> > ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> > xa_erase+0x21/0xb0
> > ? sgx_free_epc_page+0x20/0x50
> > sgx_vepc_release+0x75/0x220
> > __fput+0x89/0x250
> > task_work_run+0x59/0x90
> > do_exit+0x337/0x9a0
> >
> > Similar like commit
> > 8795359e35bc ("x86/sgx: Silence softlockup detection when releasing lar=
ge enclaves")
>
> Please wrap text properly.
>
> > The test system has 64GB of enclave memory, and all assigned to a singl=
e
> > VM. Release vepc take longer time and triggers the softlockup warning.
> >
> > Add a cond_resched() to give other tasks a chance to run and placate
>       ^
>
> You are adding more than one 'cond_resched()', so remove 'a'.
>
> > the softlockup detector.

Hi Kai,

Thx for the comments, sorry for slow reply. was busy with other high
prio tasks. I've answered your initial input in v1 patch.

I will wait a bit see if there is other comments, maybe the maintainer
want to fix them while apply

Thx!
> >
> > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > Cc: Haitao Huang <haitao.huang@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 540745ddbc70 ("x86/sgx: Introduce virtual EPC for use by KVM gue=
sts")
> > Reported-by: Yu Zhang <yu.zhang@ionos.com>
> > Tested-by: Yu Zhang <yu.zhang@ionos.com>
> > Acked-by: Haitao Huang <haitao.huang@linux.intel.com>
> > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> > ---
> > v2:
> > * collects review and test by.
> > * add fixes tag
> > * trim call trace.
> >
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
> >
>
> Comments ignored without explanation:
>
> https://lore.kernel.org/linux-sgx/op.19p011pawjvjmi@hhuan26-mobl.amr.corp=
.intel.com/T/#mf004deb81f9eb1eab7ad3c1c88746bfa23d5109c
>
