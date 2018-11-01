Return-Path: <SRS0=LYKh=NM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45465C0044C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 19:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E304220657
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 19:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nu/+Ijrl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E304220657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbeKBEWb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:22:31 -0400
Received: from mail-lj1-f171.google.com ([209.85.208.171]:39295 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbeKBEWb (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 2 Nov 2018 00:22:31 -0400
Received: by mail-lj1-f171.google.com with SMTP id a28-v6so16052633ljd.6
        for <linux-sgx@vger.kernel.org>; Thu, 01 Nov 2018 12:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JR9rUjwyC6MIuio4ZAha46sSawiC0In9vkot0Q8cJ2Q=;
        b=Nu/+IjrlQBGr6lbwnDDEbN3gl7Dm5aEMZQdnVKQ/j2NiFCnJDdYsmTBTGgibLXHTFE
         P9NZAB+OG6Cuo1cSkQ5cSssqZKurVp5QdYgcJbSrqgi73Lkh3u82h2aSrnDfuCQlbRKA
         vv+QHJpJRE0c6EuXcEM12N8I9E//serNMtBL4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JR9rUjwyC6MIuio4ZAha46sSawiC0In9vkot0Q8cJ2Q=;
        b=VyGQl2GD+b3lHPGWzpHithuIDlxAzhg/CnBaQGEFL1Q5ftMLJ1Amh0PoKrBwhhEVek
         PhHvjstsAp6F8uAawhzE4jOR+pskiQKC02W4kBiZ+UYdl3W9pRLAh5qQp4T6gbow+/Cq
         9N2hMwQfii4vQmO/DvA5Yi388ADQ13sCs3tbTPJbM3jb/oeQpGmEMBGna/DBtihSQON0
         CeEDbk0iXkFD0czdX/+V8rgRQVfSSVVNNFkJAhFVyzJVRceupRYZobA87Dk1Dl8hcT15
         7lDUI1z6gMAVA0glCxni/jIQkHT3dQRjevMfE9LOGejC6L5gO2SHF0Oo/HYjAhcjoqlc
         i/dA==
X-Gm-Message-State: AGRZ1gLsyV64auh+61WsXTeZ2OA+OYQcQse59/sw92loobZlNZ8NxTCf
        GGKy1t8xsAW6sivQFBUBsAQ/AGU6f9rWvw==
X-Google-Smtp-Source: AJdET5d3ZkiGUBtIjjlk5oS4dbJtYE53G1COzc/iRF7gn7eVF0WUROir8AKHbnVwqj2iqEbiq0dz7A==
X-Received: by 2002:a2e:95c6:: with SMTP id y6-v6mr5536498ljh.59.1541099892800;
        Thu, 01 Nov 2018 12:18:12 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id q30sm2540400lfi.94.2018.11.01.12.18.12
        for <linux-sgx@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 12:18:12 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id m18-v6so14988067lfl.11
        for <linux-sgx@vger.kernel.org>; Thu, 01 Nov 2018 12:18:12 -0700 (PDT)
X-Received: by 2002:a19:288c:: with SMTP id o134-v6mr5447843lfo.124.1541099450974;
 Thu, 01 Nov 2018 12:10:50 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com> <20181101185225.GC5150@brightrain.aerifal.cx>
In-Reply-To: <20181101185225.GC5150@brightrain.aerifal.cx>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 1 Nov 2018 12:10:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
Message-ID:
 <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     dalias@libc.org
Cc:     Jann Horn <jannh@google.com>, luto@kernel.org,
        dave.hansen@linux.intel.com, sean.j.christopherson@intel.com,
        jethro@fortanix.com, jarkko.sakkinen@linux.intel.com,
        fweimer@redhat.com, linux-api@vger.kernel.org, x86@kernel.org,
        linux-arch@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, bp@alien8.de,
        carlos@redhat.com, adhemerval.zanella@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181101191035.72PvGDE9Jivz_yUt3Bk-vKbw3E3l_Cpg3Tf2758oWpA@z>

On Thu, Nov 1, 2018 at 11:52 AM Rich Felker <dalias@libc.org> wrote:
>
> There's no need to chain if the handler is specific to the context
> where the fault happens. You just replace the handler with the one
> relevant to the code you're about to run before you run it.

That's much too expensive to do as a system call.

Maybe an rseq-like "register an area where exception information will
be found" and then you can just swap in a pointer there (and nest with
previous pointers).

But even that doesn't work. Maybe some library wants to capture page
faults because they write-protected some area and want to log writes
and then emulate them (or just enable them after logging - statistical
logging is a thing).

And then another library (or just nested code) wants to handle the
eenter fault, so it overwrites the page handler fault. What do you do
if you now get a page fault before you even do the eenter?

The whole "one global error handler" model is broken. It's broken even
if the "global" one is just per-thread. Don't do it.

Even signals didn't make *that* bad a mistake, and signals are horrible.

                        Linus
