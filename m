Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D573C433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 15:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C2DE2054F
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 15:15:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OBRzqbGJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgHRPPx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:15:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22219 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726904AbgHRPPr (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 18 Aug 2020 11:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597763746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZmSXgUG7PzCoSvo4N3Oduu/FWHr7ocTQUrHMN2SdrAk=;
        b=OBRzqbGJGzt7HaQkjaSyEXDwiacguZlI97ntcnViXJt9ScQef5jSJExqE1CH39cmQfm5cw
        dL3MjJ93zF3K5J6bdE/ofh4yxWP60N1hGqWCV3noSybAug0cahbeLttUY0yLaZb7S53Uki
        Ooa5S3zNqnr+V7fKfQGhBlI8HaKs//g=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-mNXgGqM-OSym92YQ9dB_lQ-1; Tue, 18 Aug 2020 11:15:44 -0400
X-MC-Unique: mNXgGqM-OSym92YQ9dB_lQ-1
Received: by mail-il1-f200.google.com with SMTP id w8so14594918ilg.15
        for <linux-sgx@vger.kernel.org>; Tue, 18 Aug 2020 08:15:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZmSXgUG7PzCoSvo4N3Oduu/FWHr7ocTQUrHMN2SdrAk=;
        b=Asrwi8g8Rk1t6wlFYqiZLF5xj9CRceML7rx/Gm/e6KVFQEyujWbnYXV/89ws/PfHKz
         ivev+vvJccjf8hk2nT1jdzdOQSG9z2W/zxqkb9dxpW8L5H7GFuE7WwSgBLZGD56lim8v
         ujs9sj3x52p9XVn6NLILvF02OkNgfvz3cCQkgXVDum5YsCbRr3Jc/Zz4XCKPLPhzOFVC
         6q20jTXTN3zRQjae9pkjOsQheGN13gnjRJ8irnT7nm2Qtp9j43OLi/WO6yuSdLbOXj/q
         /brBSP3FIfMWkcfmXbqmgsA/j2uUOVqwj5Eo1jwrF8FrzgLX3yLk8HzEzfPfqdK5xZ5W
         kQKQ==
X-Gm-Message-State: AOAM533IOjNncMb4iCoPQLzQ1Kv7b7cbWDqJtTSdjGK7wSgml9xkzAZK
        IYJ+77clUwZ+pRdcoUkwTV9rDLDp7b40hz2HLso+68RxkenIBHiIwblh8dQgBuditLB/4hrgGB3
        /Ja5qUO5ArOPI9rkAtSgOX5M7+UCCfpxua/OU
X-Received: by 2002:a92:5ad8:: with SMTP id b85mr17831930ilg.304.1597763743767;
        Tue, 18 Aug 2020 08:15:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGutJKs3yCY+VKjCHraMFHO3syxUNa8yAFJVpAyVJ5DdI96lv0iHVCRDEyWnSAHcF2yNFcy3Ea22Biia1UsgI=
X-Received: by 2002:a92:5ad8:: with SMTP id b85mr17831870ilg.304.1597763743282;
 Tue, 18 Aug 2020 08:15:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
 <20200810222317.GG14724@linux.intel.com> <20200818145234.GC132200@linux.intel.com>
 <20200818150627.GD132200@linux.intel.com>
In-Reply-To: <20200818150627.GD132200@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Tue, 18 Aug 2020 11:15:32 -0400
Message-ID: <CAOASepNxu0YtSPjXynLaVgyt-S0uSad8HVrNgMNWf+Z7iamPvQ@mail.gmail.com>
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
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
        Andy Lutomirski <luto@kernel.org>,
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

That seems like overkill to me. I'm just asking for one additional mov
instruction. :)

On Tue, Aug 18, 2020 at 11:06 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Tue, Aug 18, 2020 at 05:52:41PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Aug 10, 2020 at 03:23:17PM -0700, Sean Christopherson wrote:
> > > > This can be done implicitly by wrapping the struct
> > > > sgx_enclave_exception in another structure and then using techniques
> > > > like container_of() to find another field. However, this is made more
> > > > difficult by the fact that the sgx_enclave_exit_handler_t is not
> > > > really using the x86_64 sysv calling convention. Therefore, the
> > > > sgx_enclave_exit_handler_t MUST be written in assembly.
> > >
> > > What bits of the x86-64 ABI require writing the handler in assembly?  There
> > > are certainly restrictions on what the handler can do without needing an
> > > assembly trampoline, but I was under the impression that vanilla C code is
> > > compatible with the exit handler patch.  Is Rust more picky about calling
> > > convention?
> > >
> > > Side topic, the documentation for vdso_sgx_enter_enclave_t is wrong, it
> > > states the EFLAGS.DF is not cleared before invoking the handler, but that's
> > > a lie.
> >
> > If handler requires the use of setjmp/longjmp API for sudden exits, that
> > is considered bad even with C++, as it is not compatible with stack
> > unwinding. The handler has a lot of constraints for its environment, and
> > is somewhat unappealing to use.
> >
> > That's why I started today thinking a possibility of using a bpf program
> > as a middle-man. BPF programs can be used to execute code by the kernel
> > in behalf of user in a domain defined sandbox. The execution context is
> > just a buffer passed in R1 to the BPF interpreter. It can be defined by
> > application.
>
> Something like
>
> 1. An exception is triggered.
> 2. Kernel executes an eBPF program behalf of the caller, if one was
>    given.
> 3. vDSO calls a fixed exit handler that based on the outcome calls
>    ERESUME/EENTER.
>
> Possibly an ioctl could be used to attach an eBPF program to an
> enclave and vDSO would only get a context struct.
>
> /Jarkko
>

