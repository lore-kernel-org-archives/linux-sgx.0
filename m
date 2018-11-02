Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2DDC65C22
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 19:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F7212081F
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 19:02:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KX4kTb+d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F7212081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbeKCELK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 00:11:10 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35240 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730024AbeKCELI (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 3 Nov 2018 00:11:08 -0400
Received: by mail-ot1-f68.google.com with SMTP id 81so2622307otj.2
        for <linux-sgx@vger.kernel.org>; Fri, 02 Nov 2018 12:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BmgOn/yOoSR5HejHQH+1zKMqDw4ij/eJkqq+C7pQAUA=;
        b=KX4kTb+d4WBipAeFvz9QabhXCg1pEOGQU9kYdFeIQmGul56l/GXBYRI9uMr2bmA/DI
         +n06ZyZ+nDd4NwyNbucA+J7jbo4/cfKglRvI+2BQzl12O44cAk4/IOrbdgMjndFPdZBa
         wCPLiVcZ4Bi79st4O64LtLOZQUT+vHAXmJU1u0GH7j5p+lWQQbP5H2InIHgFb5CCZl4K
         0KHGVHqTwmBJauZyQaKARJEdFKSX7CEHxZngFjkx66v5CRNiAm+Z4CClKnpSC4+SxAwM
         w9aHBdLvONeJ4KdR+cyLmxnmI7zIjVXJyLOXKJZKr4iYzapJWbC0wGSYIoho099unyM1
         Y9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BmgOn/yOoSR5HejHQH+1zKMqDw4ij/eJkqq+C7pQAUA=;
        b=frRbGzxs32K3usq77vprE+QV0FegdVVo+GZKR0K5A4ZIN4JOdZsQ/wEhnqOYvlPbqj
         kZQYKl0cJ2N347tn269mBNK1/kvxJD9ycIoV2APfeOU+8t9pEBzVpYArFU3ShgpogFOr
         MqZshqE6NkKiLy1zGQzPqte3pJjjS/IA8onK98fCyEgw1b8/Hi/sAcOAFGH0B/ZS8Yl5
         LMblmIS591M/UUlrk+7WTRHNWBxnsf8ZydNPXdPcnQAMwcIJcBfPPtcUZfxqEWjBAQBp
         A8l4E2k/fa6V9FTwpvU9pAy1J7lRt+ZCGk68FutPrmoOYFZWYOD2SynruwmfFJlp5iIj
         xkIQ==
X-Gm-Message-State: AGRZ1gK2rtOT6A5MKUNg6jluNXtEDKFx6Z6WeaGDQwq/X2n1WBckMFFt
        TvGvUlSYCie+nnUt9MC3K5CdAePr3p7qPzmoeJjhoQ==
X-Google-Smtp-Source: AJdET5ePCZkyU5wM9FAkNbdBLUWLC1SnGDdumYlqRwTFDUAc+dkVTJdeOcH0ahdA5ryqvG5os6BzaKSMzGuWyrFzZfQ=
X-Received: by 2002:a9d:638f:: with SMTP id w15mr5149669otk.230.1541185369982;
 Fri, 02 Nov 2018 12:02:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx> <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
 <20181102182712.GG7393@linux.intel.com>
In-Reply-To: <20181102182712.GG7393@linux.intel.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 2 Nov 2018 20:02:23 +0100
Message-ID:
 <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     sean.j.christopherson@intel.com
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        dalias@libc.org, Dave Hansen <dave.hansen@linux.intel.com>,
        jethro@fortanix.com, jarkko.sakkinen@linux.intel.com,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        andriy.shevchenko@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        carlos@redhat.com, adhemerval.zanella@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181102190223.yKxiruYhHVdfp3ODKG1aBfMp1oWi6U1O-AxyfkzEz8k@z>

On Fri, Nov 2, 2018 at 7:27 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
> On Fri, Nov 02, 2018 at 10:48:38AM -0700, Andy Lutomirski wrote:
> > This whole mechanism seems very complicated, and it's not clear
> > exactly what behavior user code wants.
>
> No argument there.  That's why I like the approach of dumping the
> exception to userspace without trying to do anything intelligent in
> the kernel.  Userspace can then do whatever it wants AND we don't
> have to worry about mucking with stacks.
>
> One of the hiccups with the VDSO approach is that the enclave may
> want to use the untrusted stack, i.e. the stack that has the VDSO's
> stack frame.  For example, Intel's SDK uses the untrusted stack to
> pass parameters for EEXIT, which means an AEX might occur with what
> is effectively a bad stack from the VDSO's perspective.

What exactly does "uses the untrusted stack to pass parameters for
EEXIT" mean? I guess you're saying that the enclave is writing to
RSP+[0...some_positive_offset], and the written data needs to be
visible to the code outside the enclave afterwards?

In other words, the vDSO helper would have to not touch the stack
pointer (only using the 128-byte redzone to store spilled data, at
least across the enclave entry), and return by decrementing the stack
pointer by 8 immediately before returning (storing the return pointer
in the redzone)?

So you'd call the vDSO helper with a normal "call
vdso_helper_address", then the vDSO helper does "add rsp, 8", then the
vDSO helper does its magic, and then it returns with "sub rsp, 8" and
"ret"? That way you don't touch anything on the high-address side of
RSP while still avoiding running into CET problems. (I'm assuming that
you can use CET in a process that is hosting SGX enclaves?)
