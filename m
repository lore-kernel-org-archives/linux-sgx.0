Return-Path: <SRS0=bD14=AL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74731C433E0
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 16:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B319206B6
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 16:48:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="Us1GnfTV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732085AbgF3Qsg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 30 Jun 2020 12:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730494AbgF3Qsf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 30 Jun 2020 12:48:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A967C03E979
        for <linux-sgx@vger.kernel.org>; Tue, 30 Jun 2020 09:48:35 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id w3so7817433wmi.4
        for <linux-sgx@vger.kernel.org>; Tue, 30 Jun 2020 09:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f7Ay0BZPslo+/hkCnggDepdpgQUh8gMzDJFRyBpq1nE=;
        b=Us1GnfTVGgPfn6BZ4oalx8awSn0OTVLHxF/OybbrBjUNIdDbMMtrsNdC8UeBizxeQr
         kLqIeB2f+/UErnJCKJ6L7kCAV0MjzaTFXCYV9VSYnLPtipEG5VQZwo6UTPOz/ZpSZpP6
         c8uOASv+hgH2OPRdLBkQkNbrrtYeVoV8XmsXMBatc7/gSEndnveufJCTL1si/k1glEuf
         glgrqCQpQUU/nu8aDXdW/SdKiJe1Y8njN6bLtrkajqa/Z9YFXHjBhjWDJ63rVH5X+95F
         7WoSYv6DPgWq0PKhILzkm4iU9hBm2T1hjlA4HK3cw/aSdRttrTnktnryceVXfxZGLVcf
         uzsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f7Ay0BZPslo+/hkCnggDepdpgQUh8gMzDJFRyBpq1nE=;
        b=QElwECJo0UrWxueUPJ9yYnKlBy2pFtjp5F12gxr2HakOBGz5+uepCTG5lgzuXtv6u8
         j/fbFLnw7X2eFiQHPoOweZAp+1/4FJTsylf/J2NrFa6+sI3rJ6Uonod2uS+4IDikE0lW
         FJLXhJ6TCk/c1ictCwRz8dwp5JL4vD8eyTs7hLDDdEla9g9ZG/btZQwQRjujtRUOMV5q
         X+fe65QWioERD+RbeP07coWwm07lj0R/rlmjjO6U3L3thO03zbi/QQ2GLNAPcEay3e9d
         aVZ4FrFZBcDb2NGgnR9Th3QNQAfvKZrQ1WZ317Y5UfqeUje7iXSTInuy9g95QyRoHAJu
         65Gw==
X-Gm-Message-State: AOAM533Ivzs3mq/oc6KHda+3iTlwMPIohFomTDyHkt+mtRg05eeXFPAZ
        m5/5VA7QVWJB8nFgJYG9JdhMzSnYWNPPLI+oQoW8Uw==
X-Google-Smtp-Source: ABdhPJxqzIU5btpf1eaBo0LEO1vKMRw3WnGwPch2zdl3Rfe6iegM4Lo9X8WcWgVOxg1bPl16MABezC6j9ET3LLm/5f8=
X-Received: by 2002:a7b:c92e:: with SMTP id h14mr21564715wml.36.1593535713991;
 Tue, 30 Jun 2020 09:48:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-16-jarkko.sakkinen@linux.intel.com> <20200629171022.GC32176@zn.tnic>
 <20200630060055.GS12312@linux.intel.com> <20200630084128.GA1093@zn.tnic>
In-Reply-To: <20200630084128.GA1093@zn.tnic>
From:   Andy Lutomirski <luto@amacapital.net>
Date:   Tue, 30 Jun 2020 09:48:22 -0700
Message-ID: <CALCETrWUHw2WSDaJrxrwVrXSGz-zR0N2R3cT06esKBCpqyoZaQ@mail.gmail.com>
Subject: Re: [PATCH v33 15/21] x86/vdso: Add support for exception fixup in
 vDSO functions
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, "Xing, Cedric" <cedric.xing@intel.com>,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, kmoy@google.com,
        Christian Ludloff <ludloff@google.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>, npmccallum@redhat.com,
        puiterwijk@redhat.com, David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 30, 2020 at 1:41 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Mon, Jun 29, 2020 at 11:00:55PM -0700, Sean Christopherson wrote:
> > E.g. the vDSO function should get the fixup even if userspace screws
> > up mmap() and invokes __vdso_sgx_enter_enclave() without being tagged
> > an SGX task.
>
> I sincerely hope you don't mean this seriously.
>
> Please add a member to task_struct which denotes that a task is an
> sgx task, test that member where needed and forget real quickly about
> running *any* *fixup* for unrelated tasks.

I don't see the problem.  If you call this magic vDSO function and get
a fault, it gets handled.  What's the failure mode?

>
> > No hard dependency, it's normal kernel code.  My reasoning for dropping it
> > in .../vdso was largely to co-locate it with vdso/extable.h due to the
> > dependency on the format of 'struct vdso_exception_table_entry'.
>
> A struct which you defined instead of simply using struct
> exception_table_entry even if it has a handler member which would remain
> unused?

Don't forget the cross-arch issue.  We need that structure to have
constant layout so that the -m32 build from the vDSO has the same
layout as in the kernel.

So my only actual objection to the patch is that there should probably
be a comment above the structure reminding people that it needs to
have the same layout on 32-bit, x32, and x86_64.  So maybe the entries
should be s32 instead of int, although this doesn't really matter.
