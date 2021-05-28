Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53117C4707F
	for <linux-sgx@archiver.kernel.org>; Fri, 28 May 2021 00:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25EF0613DA
	for <linux-sgx@archiver.kernel.org>; Fri, 28 May 2021 00:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhE1AgP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 May 2021 20:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhE1AgO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 27 May 2021 20:36:14 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90DEC061574;
        Thu, 27 May 2021 17:34:39 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id v19-20020a0568301413b0290304f00e3d88so1977625otp.4;
        Thu, 27 May 2021 17:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dXpGjTuhJwdRDIKxoQcJr6oyH9WSthGNETSc4xMDJiU=;
        b=mDShOZJCbc9ZnRkk2LlbbSi09w/Ql99qc0RDXNWU7hUfKzZX6foOiRij32BVbIQvbt
         4zFfs/6ksoeux2CqMGxOvTBk4Q09lMR+HKpmdacdGqV7mtcNSC6bvrnbAfjWY2Tbe488
         yWHCp88x3MCUjStSj71LZXbrXpg2gLrvkm3AIcdTRhLAlIKKVl3SmMPonvkPr8FEfKb+
         ktZRxodTbcgNBRYS+9yasC0iT/VFyl2Xped+x/2QyFliSDT6syrOa7SbR36IHvWdhMj9
         sR+yPeowlGwrdaWcYo6eeNOlJg4skRhzhV68Y+fawuxCDimT8GQn9rOryalMd3N7IIYW
         EgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dXpGjTuhJwdRDIKxoQcJr6oyH9WSthGNETSc4xMDJiU=;
        b=UuHmMyVGCufA0KyaUr4deuL5WjfZ4g3D2/iokmC2faoPIsre3ot9eqZ4KjBNvoplp4
         qu60fzgitZ+LG6oce2wPDoJoB2tGIKcsJSsMbN3KDUAmYhwhorMKXLVy7GMnMDfFtCGp
         RlyErqz6Tz+I9Fe+YFpqJS5O8O+KBQ8EZYjrFmqmDEGJaKcpCPMU0+saHpeftZcCGyIH
         Nc0P27srMGt16dG1H6aSpJItnAQHDdDe9fDID5GkgDaJv14sAIzN0odMbiZjz61Ctmi8
         l+Gs2KrLtkFBkzy7kmDY7AvQlp3qUH2DwdqITqMiL3LAGKGEPv/aj9J0SiVrISXUg0C5
         DNmQ==
X-Gm-Message-State: AOAM533aYPliif57XCkrSA++B5hFtdtjRCe64KfoamVrQWYIwISXOOS8
        x+Q01uJpJ0dVrIbsJnrow9qLTrCKS6KbLWlLXOs=
X-Google-Smtp-Source: ABdhPJxEcBwHj6vd/TqmuZNb80xYTokDdKd6XNumwURVReeBHpvw4YJ1X6m7fUzPJd/TgtRg1OB+4jszG60GapH0+5g=
X-Received: by 2002:a9d:6655:: with SMTP id q21mr4901572otm.185.1622162079228;
 Thu, 27 May 2021 17:34:39 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f3fc9305c2e24311@google.com> <87v9737pt8.ffs@nanos.tec.linutronix.de>
 <0f6e6423-f93a-5d96-f452-4e08dbad9b23@redhat.com> <87sg277muh.ffs@nanos.tec.linutronix.de>
In-Reply-To: <87sg277muh.ffs@nanos.tec.linutronix.de>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 28 May 2021 08:34:28 +0800
Message-ID: <CANRm+CxaJ2Wu-f0Ys-1Fi7mo4FY9YBXNymdt142poSuND-K36A@mail.gmail.com>
Subject: Re: [syzbot] WARNING in x86_emulate_instruction
To:     Thomas Gleixner <tglx@linutronix.de>
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
        syzkaller-bugs@googlegroups.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 28 May 2021 at 08:31, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Fri, May 28 2021 at 01:21, Paolo Bonzini wrote:
> > On 28/05/21 00:52, Thomas Gleixner wrote:
> >>
> >> So this is stale for a week now. It's fully reproducible and nobody
> >> can't be bothered to look at that?
> >>
> >> What's wrong with you people?
> >
> > Actually there's a patch on list ("KVM: X86: Fix warning caused by stale
> > emulation context").  Take care.
>
> That's useful, but does not change the fact that nobody bothered to
> reply to this report ...

Will do it next time. Have a nice evening, guys!
