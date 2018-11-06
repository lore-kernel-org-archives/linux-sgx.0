Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631F4C32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 19:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30A1520827
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 19:07:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRnIspXo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30A1520827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbeKGEeQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Nov 2018 23:34:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730511AbeKGEeM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Nov 2018 23:34:12 -0500
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A22F2133D
        for <linux-sgx@vger.kernel.org>; Tue,  6 Nov 2018 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541530945;
        bh=OWckdEQFOYA4cQI4pvxJmjEMWkomeSWDwDzW0sSXU3I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BRnIspXorYhZ52GkKqjKwcn+s0kJVwoICdJ5dFN1rG7cxprt17FJWg1Q8O4mSlYY7
         49LaD3Bwyzi1SVRXWVzs4Vod6wFcIhhnevbGCWh8Vi/PzCqhc7xKk+85VE2u1t5D3I
         iqgEOsMYulPu/7RWws9FqcZBLQ02ha+r2otWcw8A=
Received: by mail-wr1-f41.google.com with SMTP id z16-v6so14799935wrv.2
        for <linux-sgx@vger.kernel.org>; Tue, 06 Nov 2018 11:02:25 -0800 (PST)
X-Gm-Message-State: AGRZ1gIgBej7wIpaBJIwPY26k2vpMSrfXMdUrOdZpu8mtWwxdFb+U6Gn
        wwepaBP56WCCe1dAWzpr0hL8KtUpdHw0y+UYQOVHZg==
X-Google-Smtp-Source: AJdET5cY5VvCpEhjQsROy7auLcaoVPiGC/i10wYYKxTYu/qGLWJ1I1Yxc/0Zf1kEyhRGZ6QhltvmT9CYBzUzNbunCVc=
X-Received: by 2002:adf:82c9:: with SMTP id 67-v6mr23365080wrc.131.1541530943892;
 Tue, 06 Nov 2018 11:02:23 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7050972d-a874-dc08-3214-93e81181da60@intel.com>
 <20181102170627.GD7393@linux.intel.com> <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
 <20181102173350.GF7393@linux.intel.com> <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
 <20181102182712.GG7393@linux.intel.com> <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
 <20181102220437.GI7393@linux.intel.com> <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
 <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
 <1541518670.7839.31.camel@intel.com> <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
 <1541524750.7839.51.camel@intel.com> <22596E35-F5D1-4935-86AB-B510DCA0FABE@amacapital.net>
 <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
In-Reply-To: <c9659222-efc6-b73a-ce48-30be8bdc5397@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 6 Nov 2018 11:02:11 -0800
X-Gmail-Original-Message-ID: <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
Message-ID:
 <CALCETrWBV=1JbAKYn2Jy2LxkGZQvKRtFRnrWUMoejrwQe73VHw@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Florian Weimer <fweimer@redhat.com>,
        Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com, linux-sgx@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "Carlos O'Donell" <carlos@redhat.com>,
        adhemerval.zanella@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106190211.mpyaKUfTtIbmIuIxMRJB5M9AiafvsBmWYpMx17RQIKk@z>

On Tue, Nov 6, 2018 at 10:41 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 11/6/18 10:20 AM, Andy Lutomirski wrote:
> > I almost feel like the right solution is to call into SGX on its own
> > private stack or maybe even its own private address space.
>
> Yeah, I had the same gut feeling.  Couldn't the debugger even treat the
> enclave like its own "thread" with its own stack and its own set of
> registers and context?  That seems like a much more workable model than
> trying to weave it together with the EENTER context.

So maybe the API should be, roughly

sgx_exit_reason_t sgx_enter_enclave(pointer_to_enclave, struct
host_state *state);
sgx_exit_reason_t sgx_resume_enclave(same args);

where host_state is something like:

struct host_state {
  unsigned long bp, sp, ax, bx, cx, dx, si, di;
};

and the values in host_state explicitly have nothing to do with the
actual host registers.  So, if you want to use the outcall mechanism,
you'd allocate some memory, point sp to that memory, call
sgx_enter_enclave(), and then read that memory to do the outcall.

Actually implementing this would be distinctly nontrivial, and would
almost certainly need some degree of kernel help to avoid an explosion
when a signal gets delivered while we have host_state.sp loaded into
the actual SP register.  Maybe rseq could help with this?

The ISA here is IMO not well thought through.
