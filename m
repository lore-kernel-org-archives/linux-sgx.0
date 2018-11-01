Return-Path: <SRS0=LYKh=NM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48920C0044C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 23:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8C0420820
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 23:23:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVKXYLV/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8C0420820
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbeKBI2L (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Nov 2018 04:28:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbeKBI2L (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Nov 2018 04:28:11 -0400
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DF602087A
        for <linux-sgx@vger.kernel.org>; Thu,  1 Nov 2018 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541114588;
        bh=415MFWHDIZtY1qe6caCyVVn8I98XBm9BvsFAfLS0CTU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JVKXYLV/sYI1NWV6HXUo6hcHdtWht5lJelqnZ359Fahb6uzf7V/ZYFoyB2O0xMa7r
         0AQvyLchCLsOvB4QhR3jjXJw8muiqLi1+Qiu0qCbOvTxkOq/UhadOOsolehV8Txk15
         vga7mxRRpQqNpP2KaXo90bVL9CE1Ni0KWVT6dLDA=
Received: by mail-wr1-f43.google.com with SMTP id 74-v6so121403wrb.13
        for <linux-sgx@vger.kernel.org>; Thu, 01 Nov 2018 16:23:08 -0700 (PDT)
X-Gm-Message-State: AGRZ1gLnS1ULYFJLOulQ5AKE8euH8e/IFgGLoWn/B0Ikmjq7vIv/pcQV
        5TQLoYfxDiSiQpaYCr8uXcn0kz7jVOxm3HAvpSnTLw==
X-Google-Smtp-Source: AJdET5dhuzroPAEW5lPVQoXX0VyqDMbXzwT6rfzx0IjgqP5lijbGEa9KnlxloP0J7tTYHatP7JIn6BVCRwejrzQzveg=
X-Received: by 2002:adf:97d3:: with SMTP id t19-v6mr8620050wrb.283.1541114586807;
 Thu, 01 Nov 2018 16:23:06 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrWdpoDkbZjkucKL91GWpDPG9p=VqYrULade2pFDR7S=GQ@mail.gmail.com>
 <CAG48ez0vBqL0tyfWwmuc_cq+OAUoEi88=r+t6h64a-Fw8z59zA@mail.gmail.com>
 <20181101185225.GC5150@brightrain.aerifal.cx> <CAHk-=wgFo8tuZX5gzCfWGdAwGyn_Ar9JFnnMFNuwr9=vtfDV1g@mail.gmail.com>
 <20181101193107.GE5150@brightrain.aerifal.cx> <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
In-Reply-To: <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 1 Nov 2018 16:22:55 -0700
X-Gmail-Original-Message-ID: <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
Message-ID:
 <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
Subject: Re: RFC: userspace exception fixups
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Rich Felker <dalias@libc.org>, Jann Horn <jannh@google.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Message-ID: <20181101232255.S5_XmmTFTk29r4FUwOp4pFOPA18ko246gETGcs8TLt0@z>

On Thu, Nov 1, 2018 at 2:24 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Nov 1, 2018 at 12:31 PM Rich Felker <dalias@libc.org> wrote:
> >
> > See my other emails in this thread. You would register the *address*
> > (in TLS) of a function pointer object pointing to the handler, rather
> > than the function address of the handler. Then switching handler is
> > just a single store in userspace, no syscalls involved.
>
> Yes.
>
> And for just EENTER, maybe that's the right model.
>
> If we want to generalize it to other thread-synchronous faults, it
> needs way more information and a list of handlers, but if we limit the
> thing to _only_ EENTER getting an SGX fault, then a single "this is
> the fault handler" address is probably the right thing to do.

It sounds like you're saying that the kernel should know, *before*
running any user fixup code, whether the fault in question is one that
wants a fixup.  Sounds reasonable.

I think it would be nice, but not absolutely necessary, if user code
didn't need to poke some value into TLS each time it ran a function
that had a fixup.  With the poke-into-TLS approach, it looks a lot
like rseq, and rseq doesn't nest very nicely.  I think we really want
this mechanism to Just Work.  So we could maybe have a syscall that
associates a list of fixups with a given range of text addresses.  We
might want the kernel to automatically zap the fixups when the text in
question is unmapped.
