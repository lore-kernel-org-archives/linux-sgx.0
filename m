Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9627C47082
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Jun 2021 10:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2290611BD
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Jun 2021 10:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhFGKgv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Jun 2021 06:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhFGKgt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Jun 2021 06:36:49 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CD4C061789
        for <linux-sgx@vger.kernel.org>; Mon,  7 Jun 2021 03:34:43 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id c124so16084861qkd.8
        for <linux-sgx@vger.kernel.org>; Mon, 07 Jun 2021 03:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W1Z9gEhrO+dFGwff9bZiaB/Edk6g694l5FTvX8TnmqE=;
        b=iTtdkG5oAQc1PJs6q76R+08BA/t3w7Wq0B5q0H3ufJUid+AhdIEg3Y7fEh5tvg+XdW
         59gjhb2UQezoRRcs6jsnQry+7KjS/8g6IMni8HGD16dE51trmOBjXRtipOnNlpsv21H/
         4gB311yqb4F57DW8p98BkOuLBxbWB/QMW/ct8ycdrOesNpXpOqGaHtOf//MeCDDjrH5q
         uF0ze7KA5EuIxV5OEmz2vTKb7IYQSVhse9ZIsA0utfTlmx1u3ZfETfQW9jpk4VhCu02/
         unJalB4bnrHV3OiWEs7dCHEm4b8l0JftUBB4lDcwiHZZ79ZbMqv7OGCPzQTCU5xdEPmM
         dSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W1Z9gEhrO+dFGwff9bZiaB/Edk6g694l5FTvX8TnmqE=;
        b=ObIHDA93DAiv+jeUy8Kf25+OcW34FPHd/rO+iNrGcYV1NXHncpDJYFlWW4e6ZMMxiu
         rm+UdTUbk1kTglO87mIjMJDASbRnbD1YnB87QiwUabB/f1nQfsKtDLdwnzrVRHMwN8up
         aNH6uBD5nOr48KMHQE9/NMja+2KPlxts8wRWc3TraNYin2gqEvg9yF/SB0q99mfXijzS
         YqOq3JIjM6UBQ/p3219NjIjrXFCaFYSqEZ3MrLTcS8bapXFbowOmwGTVQv+siVJElx9/
         GUAKm5R4n6KMkzC3OkUzKsuH2bNMg9ZNQaYDHgRNrNCyEJQwghSUs0VeyeCjv/sy7EnB
         MZuA==
X-Gm-Message-State: AOAM530BoPeCO97AbZbUBMyf60MC613LRRNw+n7zd5p4KXBdcKpkeFj7
        2BqK86vxHqmwH1jD9Frjq707YWdSg18ROsc0u5/UAA==
X-Google-Smtp-Source: ABdhPJzTaPg9Os78/lByEqsfjEnL/w2wMnrVZ00vCZM9WGJQ9q3qi9YoIFwEozZ90r1enDNg908KqoHmNpKV1LanaKs=
X-Received: by 2002:a37:4694:: with SMTP id t142mr16089543qka.265.1623062081807;
 Mon, 07 Jun 2021 03:34:41 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f3fc9305c2e24311@google.com> <87v9737pt8.ffs@nanos.tec.linutronix.de>
 <0f6e6423-f93a-5d96-f452-4e08dbad9b23@redhat.com> <87sg277muh.ffs@nanos.tec.linutronix.de>
 <CANRm+CxaJ2Wu-f0Ys-1Fi7mo4FY9YBXNymdt142poSuND-K36A@mail.gmail.com>
In-Reply-To: <CANRm+CxaJ2Wu-f0Ys-1Fi7mo4FY9YBXNymdt142poSuND-K36A@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 7 Jun 2021 12:34:30 +0200
Message-ID: <CACT4Y+YDtBf1GebeAA=twsfuv9e0HN+w7Lt5ZqDJhMJ5-PWYXQ@mail.gmail.com>
Subject: Re: [syzbot] WARNING in x86_emulate_instruction
To:     Wanpeng Li <kernellwp@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        syzbot <syzbot+71271244f206d17f6441@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, jarkko@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kan.liang@linux.intel.com,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>, steve.wahl@hpe.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 28, 2021 at 2:34 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Fri, 28 May 2021 at 08:31, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > On Fri, May 28 2021 at 01:21, Paolo Bonzini wrote:
> > > On 28/05/21 00:52, Thomas Gleixner wrote:
> > >>
> > >> So this is stale for a week now. It's fully reproducible and nobody
> > >> can't be bothered to look at that?
> > >>
> > >> What's wrong with you people?
> > >
> > > Actually there's a patch on list ("KVM: X86: Fix warning caused by stale
> > > emulation context").  Take care.
> >
> > That's useful, but does not change the fact that nobody bothered to
> > reply to this report ...
>
> Will do it next time. Have a nice evening, guys!

There was an idea to do this automatically by syzbot:

dashboard/app: notify bug report about fix patches
https://github.com/google/syzkaller/issues/1574

Namely: if syzbot discovers a fix anywhere (by the hash), it could
send a notification email to the bug report email thread.
The downside is that the robot sends even more emails, so I am not
sure how it will be accepted. Any opinions?
