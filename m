Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB4BC32789
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 17:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 341C82082E
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 17:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IH5lJKzE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 341C82082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbeKCCJK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 22:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbeKCCJK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Nov 2018 22:09:10 -0400
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63F7A20831
        for <linux-sgx@vger.kernel.org>; Fri,  2 Nov 2018 17:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541178081;
        bh=S/RgsQzwWHSrtj65TB+IqaGqcj5OTVXTmwytmcwW24g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IH5lJKzExP6sbQNnal062jDT2zyJQ4HEm4n29919/5tBxK02+TEqHvB1C6mQp366u
         fZ8lF4PGFXIxbwMz1JlmnzO3w58L2EhA+R1B5xHZGQCt+AzSeG2RVayJQenSQWZERP
         guXnc5/f1boxf97abc4UB4aXpKWztJVhXuUJOxQQ=
Received: by mail-wm1-f46.google.com with SMTP id u13-v6so2468355wmc.4
        for <linux-sgx@vger.kernel.org>; Fri, 02 Nov 2018 10:01:21 -0700 (PDT)
X-Gm-Message-State: AGRZ1gI6TWxpAmqLQAiSN5oefSZ1QoDS+ctAG5ZfQ5rkEunwb91eLDRh
        KTeRK1vekhbnaseOb8sW9uC8v0sV0Zj44Uo88LytXg==
X-Google-Smtp-Source: AJdET5ddY2WwIxQdWRcVWuyM/Sy+AmOpv7jPbD5Taou11l5n48Li5HXlCLYNyNYL36ji3vUGWMYGTMraOgNjsKb661I=
X-Received: by 2002:a1c:d4b:: with SMTP id 72-v6mr67012wmn.102.1541178079853;
 Fri, 02 Nov 2018 10:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx> <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx> <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
 <20181102163034.GB7393@linux.intel.com> <7e14ee0e-ce15-1e88-7ae9-4d0f40cb3d84@fortanix.com>
 <20181102165204.GC7393@linux.intel.com> <dd455b30-b586-bf5b-2195-cf20c1af9890@fortanix.com>
In-Reply-To: <dd455b30-b586-bf5b-2195-cf20c1af9890@fortanix.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 2 Nov 2018 10:01:08 -0700
X-Gmail-Original-Message-ID: <CALCETrUo8uwnu3dBVSHVtB_z4uQgW=40grVdZWmTt64Tei6WiQ@mail.gmail.com>
Message-ID:
 <CALCETrUo8uwnu3dBVSHVtB_z4uQgW=40grVdZWmTt64Tei6WiQ@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
Message-ID: <20181102170108.FAy-R8DRyGyX6AS-6QZjvEcmZwzyqR2ZvWtIf3H1cXM@z>

On Fri, Nov 2, 2018 at 9:56 AM Jethro Beekman <jethro@fortanix.com> wrote:
>
> On 2018-11-02 09:52, Sean Christopherson wrote:
> > On Fri, Nov 02, 2018 at 04:37:10PM +0000, Jethro Beekman wrote:
> >> On 2018-11-02 09:30, Sean Christopherson wrote:
> >>> ... The intended convention for EENTER is to have an ENCLU at the AEX target ...
> >>>
> >>> ... to further enforce that the AEX target needs to be ENCLU.
> >>
> >> Some SGX runtimes may want to use a different AEX target.
> >
> > To what end?  Userspace gets no indication as to why the AEX occurred.
> > And if exceptions are getting transfered to userspace the trampoline
> > would effectively be handling only INTR, NMI, #MC and EPC #PF.
> >
>
> Various reasons...
>
> Userspace may have established an exception handling convention with the
> enclave (by setting TCS.NSSA > 1) and may want to call EENTER instead of
> ERESUME.
>

Ugh,

I sincerely hope that a future ISA extension lets the kernel return
directly back to enclave mode so that AEX events become entirely
invisible to user code.  It would be nice if user developers didn't
start depending on the rather odd AEX semantics right now.  But I
don't think the kernel can sanely do much about it.
