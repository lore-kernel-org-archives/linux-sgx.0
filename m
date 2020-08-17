Return-Path: <SRS0=YMEK=B3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13920C433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Aug 2020 13:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E11F42072E
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Aug 2020 13:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F7UH5rrW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgHQNPB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Aug 2020 09:15:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728782AbgHQNMe (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 17 Aug 2020 09:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597669950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LoX/isK9XCVgjAah4bBlopo8zuCeI4gV5UtNPCvDo3s=;
        b=F7UH5rrW2p0FrrBtim9H9MbCDtyMV5qicJ6zL+OzurIZOmVEycNbVmsvNxtuQ94M8aTi77
        T1LPBoFqfjTotyQ29bYMS2F/anfVL9UddZ9nCIVkVkiJE4K3+dvuTVmAFX1/oiC80XajWr
        TzzvQpCZgNYHSXGCO0jlsRLsrNtAbv8=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-hqEMAC59N_64PBUQwZXnRA-1; Mon, 17 Aug 2020 09:12:29 -0400
X-MC-Unique: hqEMAC59N_64PBUQwZXnRA-1
Received: by mail-io1-f72.google.com with SMTP id e12so9773437ioc.8
        for <linux-sgx@vger.kernel.org>; Mon, 17 Aug 2020 06:12:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LoX/isK9XCVgjAah4bBlopo8zuCeI4gV5UtNPCvDo3s=;
        b=oQAhZEfqLtAlpVyT0EUw1y6hEgfKMevvrENM4yyXx5H17J/ATrXaAkTZQ/Qg0Gc3Le
         wpfVBACbtUSBIWda5WukmAdhh0wvhaL5a9akzEtddFCOpPhSh4H3V1/j+aUxSS2RwSu2
         nEBluQLRa/zfKBL8BCkS6oOaTQgL/vtip5t8FKAznhDgr04RqaafFNPo+P4C61ovOMGk
         1C+UidiS5NnAuWIjGdh3V5JJQQFJpm/GmwUlVn/xl2njFH+L8XuwmQxWMXmRFhk50b3y
         HMCofyCIvZZa4OFC5zrXuM2iHXxHFbEL4lxkvz+JiOq5XcGfIsx8SsdwWcbo0kHRE6K5
         XCew==
X-Gm-Message-State: AOAM531fvUzPkFWhu8dmrg4oMMlyyr9d+PJDul0sCw9/YEVoJuEQtAd/
        EUcKP/NSDpT8v3AHVexujY4TGmpEWx5W/4Nkrs6J47qBpGvShGKm3lhn6RYiLskAXB6sNLIJ5ld
        2zEXh98DhTV8z9JID7pEX3VXg/PsbBaMrzgQw
X-Received: by 2002:a05:6638:214d:: with SMTP id z13mr15049774jaj.7.1597669948416;
        Mon, 17 Aug 2020 06:12:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySWz11lucPGQHNkEw8pyo3c3ZZxi7eKspfGM76zBLQPdq7Ia5uS7PYukYTNWDcCWDz6duzJWXOVY4bGUKMnCI=
X-Received: by 2002:a05:6638:214d:: with SMTP id z13mr15049731jaj.7.1597669948084;
 Mon, 17 Aug 2020 06:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com> <CALCETrVch_XW-oc_-LR8Dbgat9DpSKtCYTV9YZaU7tfu61FHEw@mail.gmail.com>
In-Reply-To: <CALCETrVch_XW-oc_-LR8Dbgat9DpSKtCYTV9YZaU7tfu61FHEw@mail.gmail.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Mon, 17 Aug 2020 09:12:17 -0400
Message-ID: <CAOASepOFh-vOrNZEVDFrDSuHs+9GEzzpXUTG-fZMuyjWAkpRWw@mail.gmail.com>
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nmccallu@redhat.com
X-Mimecast-Spam-Score: 0.003
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 10, 2020 at 7:09 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Thu, Aug 6, 2020 at 7:55 AM Nathaniel McCallum <npmccallum@redhat.com> wrote:
> >
> > In a past revision of this patch, I had requested a void *misc
> > parameter that could be passed through vdso_sgx_enter_enclave_t into
> > sgx_enclave_exit_handler_t. This request encountered some push back
> > and I dropped the issue. However, I'd like to revisit it or something
> > similar.
>
> Why do you need an exit handler at all?  IIRC way back when I
> suggested that we simply not support it at all.  If you want to
> call__vdso_sgx_enter_enclave() in a loop, call it in a loop.  If you
> want to wrap it intelligently in Rust, you don't want a callback
> anyway -- that forces you have an FFI (or non-Rust, anyway) frame on
> the stack, which interacts poorly with panic handling and prevents you
> from using await in your Rust callback handler.  If, on the other
> hand, you just call __vdso_sg_enter_enclave() in a loop, all these
> problems go away and, if you really want, you can pass in a callback
> in Rust and call the callback from Rust.
>
> What am I missing?  I still don't really understand why we are
> supporting this mechanism at all.  Just the asm code to invoke the
> callback seems to be about half of the entire function.

There are three ways to pass state between the enclave and the outside world:
1. A pre-allocated memory block at enclave creation time.
2. A contract for pushing values onto the stack during entry/exit.
3. All registers and flags besides rax, rbx, and rcx.

Under the current vDSO function:

#1 is completely possible without a handler. The challenge is how to
communicate the address of this memory to the enclave. This can be
accomplished by a parameter in a measured block or by convention.
Otherwise, it needs to use #2 or #3 to communicate the address of the
block.

#2 requires a handler written in assembly. The semantics are well known.

#3 is possible without a handler, but only for the subset of the
registers allowed by the calling convention. However, with a handler
written in assembly you can pass both in and out the full range of
registers. To do this, the assembly handler needs a pointer to a
buffer to save the registers into. How does it get said pointer?
Currently: offsetof, which Rust doesn't support.

So when I want to write a general purpose library to expose this,
which method should I expose? In particular, I want to give a single
"best practice" workflow to library consumers so that the startup
process is easy. Since #1 requires #3 to avoid a bad developer
experience, I'm inclined to provide #3.

I can provide the calling convention registers easily. But this limits
the output registers to two (practically, one for a variety of
reasons). I might just accept that. But with a misc pointer to the
handler, I could expand the one or two return registers to 11 (rdi,
rsi, rdx, r8-r15).

Put simply: I think the one extra line of assembly is worth the
flexibility it gives to consumers of this interface. In particular, it
improves the FFI experience greatly since one doesn't have to resort
to offsetof tricks to get some additional context into the handler.

