Return-Path: <SRS0=LYKh=NM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E742C6786F
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 19:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15D7120657
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 19:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QLm6iK3y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15D7120657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbeKBEQV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:16:21 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39062 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbeKBEQU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 2 Nov 2018 00:16:20 -0400
Received: by mail-lj1-f193.google.com with SMTP id a28-v6so16035630ljd.6
        for <linux-sgx@vger.kernel.org>; Thu, 01 Nov 2018 12:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sAdyijJANdHXrZS7Rhy3SlpitoiP+F4HljNHFT3Q6h0=;
        b=QLm6iK3yWs27nIzZ2pM2WZg7LUjUDqDg6URDt6pOhlyh7k3cN660A+J6c18S1uCc/y
         tnr/I7p4mnFgSUp1kKhTS23iB5r1GfpvS5afsvW42SSgPiQgKGNAbVhs8EMfYgndu93g
         jrqkQ7wkUdB0OzKlCzqwTIoBCMuuAmFqL5ScE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sAdyijJANdHXrZS7Rhy3SlpitoiP+F4HljNHFT3Q6h0=;
        b=TlgSkafUhjMDZLntGvPHXjSRBp4zl29vFcvKHWfEzWJAssZv6udbj3sOkLiMN5lvVD
         sUAsc1OoO704m/0yMi0PUzWUDtxadYNUvx8BdIrsHNzgBDrcPlsofxOGNetCtplAJ9MG
         28GqQ8G9cNHAJ0QcMG0Yj954RHoPT6FppA1BXH7M1I6Qhe6Sgn0PRohCi+wUIntyWvec
         1zFBnk1EB8NZrp+d43+CqZ2AAHgMjNA1sGq92UolYjeNlMput0pbiVOLkzcaRF4RiZj0
         qpqEzFDW8KYuTm2st5Lt1Fowb+CKiS02TtZT7Go8LEw4r1+kaFNu+GoIiRp1nobfu8wc
         C/CQ==
X-Gm-Message-State: AGRZ1gKwnJ41jXxbcLQJsWm4OUwaaQWmhLl6gCOZ4Ay+YD3K4vufmRVp
        LA4ynhQ83XZS5rAIQ7DG4Z6kc1hEpJqiaA==
X-Google-Smtp-Source: AJdET5eojZpkUYXtMOo/B0a/6eGtbwDJn8Rz/PULx4YD75mY7RGVJQI5/qPYyi5KVp+KQcn4hzhL0w==
X-Received: by 2002:a2e:29d7:: with SMTP id p84-v6mr5627878ljp.12.1541099522672;
        Thu, 01 Nov 2018 12:12:02 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id m63-v6sm3323273lje.81.2018.11.01.12.12.02
        for <linux-sgx@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 12:12:02 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id g26-v6so17778613lja.10
        for <linux-sgx@vger.kernel.org>; Thu, 01 Nov 2018 12:12:02 -0700 (PDT)
X-Received: by 2002:a2e:95c6:: with SMTP id y6-v6mr5513348ljh.59.1541099197588;
 Thu, 01 Nov 2018 12:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
In-Reply-To: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 1 Nov 2018 12:06:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjJhdr3JCnGrMKqL-prxYd__kkAspKVYBO3BYYmq2hu4A@mail.gmail.com>
Message-ID:
 <CAHk-=wjJhdr3JCnGrMKqL-prxYd__kkAspKVYBO3BYYmq2hu4A@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     luto@kernel.org
Cc:     dave.hansen@linux.intel.com, sean.j.christopherson@intel.com,
        jethro@fortanix.com, jarkko.sakkinen@linux.intel.com,
        fweimer@redhat.com, linux-api@vger.kernel.org,
        Jann Horn <jannh@google.com>, x86@kernel.org,
        linux-arch@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, dalias@libc.org,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, bp@alien8.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181101190621.ybq-3XjMBdTaOx1DgZomZae3qW54u7Ljs9-29Id_ogc@z>

On Thu, Nov 1, 2018 at 10:53 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> There's been some discussion of adding a vDSO entry point to wrap
> EENTER and do something sensible with the exceptions,

I think that's likely the right thing to do, and would be similar to sysenter.

> The basic idea would be to allow libc, or maybe even any library, to
> register a handler that gets a chance to act on an exception caused by
> a user instruction before a signal is delivered.  As a straw-man
> example for how this could work, there could be a new syscall:
>
> long register_exception_handler(void (*handler)(int, siginfo_t *, void *));

I'm not a huge fan of signals, but the above is an abomination.

It has all the problems of signals _and_ then some.

And it in absolutely no way fixes the problem with libraires. In fact,
it arguably makes it much much worse, since now there's only one
single library that can register it.

Yes yes, maybe a library would then expose _another_ interface to
other libraries and act as some kind of dispatch point, but on the
whole the above is just crazy and fundamentally broken.

If you want to register an exception, you need to make it clear

 (a) which _thread_ the exception registration is valid for

 (b) which _range_ the exception registration is valid for

 (c) which _fault_ the exception registration is valid for (page
fault, div-by-zero, whatever)

 (d) which save area (aka stack) and exception handler point.

Note that (b) might be more than just an exception IP range. It might
well be interesting to register the exception by page fault address
(in addition to code range).

If you do something that does all of (a)-(d), and you allow some
limited number of exception registrations, then maybe. Because at that
point, you have something that is actually actively more powerful than
signal handling is.

But your suggested "just register a broken form of signal handling for
a special case" is just wrong. Don't do it.

              Linus
