Return-Path: <SRS0=4Rt9=NQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424E2C0044C
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Nov 2018 20:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F076A2085A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Nov 2018 20:40:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CHZgKJLV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F076A2085A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbeKFGB2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Nov 2018 01:01:28 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43831 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbeKFGB2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 6 Nov 2018 01:01:28 -0500
Received: by mail-qt1-f195.google.com with SMTP id i7so175361qtj.10;
        Mon, 05 Nov 2018 12:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ILE+k7pWV9cIqAzEgJwaEkmdZ3c+veByDIIVUcB7Py0=;
        b=CHZgKJLVodPnnKVd8EPAbYvi+4i7CBRgvR7N9YrdQ0c9m8yVM8DPHG25R45oZxUQ8g
         ZDMl8JUlf3FcN1BSGJRN2FZhTi0LPKKUrVzMl6fRMgco1cD/zQnJ2Cqs2VL70DABSZZl
         UkQ032C/UvDfzp6tukY1Edv9lc3UZRtSTL9MTzNvfcO9GaMYHQ8Q9UINfDJQ+h0211PW
         sYewIDqyhPvLY8fHZhmsKE0TDD1691Eq2j1vdkpS1bIwXXkRgqfx9f4pd5Ui2Ex+QXn8
         tgVbTzJQQPAlIiTf56EnRc+cRmERNjvSucqVvtDqyqy7hDyNXwAXKsWdeotP+Ffop9cg
         a58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ILE+k7pWV9cIqAzEgJwaEkmdZ3c+veByDIIVUcB7Py0=;
        b=X2f67vqMXbkdL3M+3tcTZBHpr47Yt5rYyA7RDfH7IHpg9xF+FzMNAr9VkbfK8E2VJm
         cb3Tt0l6iU8+B/Smbo5DgzFSeBL4zNk45EHmLDmrX8WqyjRTqSufbX/6bNuK/7DgWgUd
         GTg3buAiedbP5+oy8qgKgr1hY+jTlpsRcLaufntN3VR44gUBd0wZEzYcrEP9GhYrCNyT
         tSVifFRSolar60IMzhwG1+hoVp7NLVOLOoVd/RGjYzZ4w9llfArELXmK5nd5WYe+oIYQ
         4K/RokiY3zXazsAgpVm7xPTY4bmMzzvtmLPJaeYqgjDfBhNDMSJilTG8FFuE2oDU8OLR
         cDsQ==
X-Gm-Message-State: AGRZ1gLvFA9xfWSNlyWdm11Xx04aR+mnQU4bdohrx1BfgvEItLcpjEcY
        mYPE3hcuAQ0NnUGyOTQURFk7yMR689SSe4B/TuP/DW3T
X-Google-Smtp-Source: AJdET5dgSoTZ7cPNFPDCBymGSyqyylQq/gygeb6V4Ffjt/a24Cfa+n1c9dn+GqBxU+34Q25baEslhLXnh2AX7uUEzyA=
X-Received: by 2002:aed:2d24:: with SMTP id h33mr15845979qtd.373.1541450397787;
 Mon, 05 Nov 2018 12:39:57 -0800 (PST)
MIME-Version: 1.0
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-16-jarkko.sakkinen@linux.intel.com> <CAHp75VdhSwy8zzf64PZnHhZVikJEzasu-=a+UOz4cLAxEJW-YA@mail.gmail.com>
 <20181105173038.GD4502@linux.intel.com>
In-Reply-To: <20181105173038.GD4502@linux.intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 5 Nov 2018 22:39:46 +0200
Message-ID:
 <CAHp75Vfa2jvjOtvERB_Td1zCrfKyJp24Prd+foYz02kUCjNr-g@mail.gmail.com>
Subject: Re: [PATCH v15 15/23] x86/sgx: Add wrappers for ENCLS leaf functions
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, suresh.b.siddha@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181105203946.fSB-1bDhjbbn8WxaLClCqhbfIjZmxI_pLSLX59TH7X8@z>

On Mon, Nov 5, 2018 at 7:30 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Sat, Nov 03, 2018 at 03:17:35PM +0200, Andy Shevchenko wrote:
> > On Sat, Nov 3, 2018 at 1:18 AM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > ENCLS is an umbrella instruction for a variety of cpl0 SGX functions.
> > > The ENCLS function that is executed is specified in EAX, with each
> > > function potentially having more leaf-specific operands beyond EAX.
> > > ENCLS introduces its own (positive value) error codes that (some)
> > > leafs use to return failure information in EAX.  Leafs that return
> > > an error code also modify RFLAGS.  And finally, ENCLS generates
> > > ENCLS-specific non-fatal #GPs and #PFs, i.e. a bug-free kernel may
> > > encounter faults on ENCLS that must be handled gracefully.
> > >
> > > Because of the complexity involved in encoding ENCLS and handling its
> > > assortment of failure paths, executing any given leaf is not a simple
> > > matter of emitting ENCLS.
> > >
> > > To enable adding support for ENCLS leafs with minimal fuss, add a
> > > two-layer macro system along with an encoding scheme to allow wrappers
> > > to return trap numbers along ENCLS-specific error codes.  The bottom
> > > layer of the macro system splits between the leafs that return an
> > > error code and those that do not.  The second layer generates the
> > > correct input/output annotations based on the number of operands for
> > > each leaf function.
> >
> > > +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> >
> > > +/**
> >
> > I dunno if kernel-doc script still complains about this.
>
> Is there a way to ask for make htmldocs to do only a subset of docs?
> Still kind of trying to figure out what would be  a good flow for
> working with Sphinx.

What I'm telling here is about Copyright notice, which in my
understanding is not a part of kernel-doc formatting. Though I might
be mistaken.
I remember some USB code has that and I saw a warning.

-- 
With Best Regards,
Andy Shevchenko
