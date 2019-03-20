Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF19C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 18:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAE612146E
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 18:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553107959;
	bh=HUxD4zz8Zf+WY2iSBbRgjfg2I0iw9IDkAFSzHi5UwbM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=tuFdwifjm9YU9b9p4CI7yufPKImbEbEwmgtSEAtdCiOCJ0khyKqS0mmkGItQwuQiS
	 LQLhJzUX/DkQxQNsjSMNJ5mcaVmhMd5MoZ6M7SlWF3zVTDMVGCpNCc/OLyNgsaLp4Q
	 cr2HpTCN7eWLeYjKZi6AZAe3yZ+9k5uHjjxljY9E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfCTSwj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 14:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727492AbfCTSwj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 14:52:39 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BCBB21920
        for <linux-sgx@vger.kernel.org>; Wed, 20 Mar 2019 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553107958;
        bh=HUxD4zz8Zf+WY2iSBbRgjfg2I0iw9IDkAFSzHi5UwbM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0coyyM/RhxAfI7QyrQoNtZcSaFX+1PKfm8ZtUTnCUTbpoeWM+5zvMmhsCx1J5+TCC
         lFqIVy++YNJNaUWAJCaS2JDQqHvDnnyqfAtkCXmBUh4b86ovIQFdKV0hHo2YN0xG9J
         PClAxccVOq0TdIE13GtfH7QhDQG59xdr4qx+3gdM=
Received: by mail-wr1-f45.google.com with SMTP id j9so3971929wrn.6
        for <linux-sgx@vger.kernel.org>; Wed, 20 Mar 2019 11:52:38 -0700 (PDT)
X-Gm-Message-State: APjAAAUpKyh6UMepNuNROlP4BIJqdb7rKhAXFZvrcEcrgupCnuRXR9zV
        x0L7WLC6pFRbdSLi1fSefXuQTZF+hdofVNG8qwNALg==
X-Google-Smtp-Source: APXvYqz+3EH7OAApLS1c3Ky5zJprm9XIhGC4yft3gC9LcO7BNV9y3r8KWkfsUvGPzeeN1MoMmQNqJWkPB9IfWDq2mhc=
X-Received: by 2002:adf:e743:: with SMTP id c3mr9313755wrn.330.1553107956638;
 Wed, 20 Mar 2019 11:52:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 20 Mar 2019 11:52:25 -0700
X-Gmail-Original-Message-ID: <CALCETrVKAUK-jZ7Knp7RetTL055p3iK1D8Wyr6=hPq5HkePkFg@mail.gmail.com>
Message-ID: <CALCETrVKAUK-jZ7Knp7RetTL055p3iK1D8Wyr6=hPq5HkePkFg@mail.gmail.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add __vdso_sgx_enter_enclave()
 to wrap SGX enclave transitions
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 20, 2019 at 11:30 AM Xing, Cedric <cedric.xing@intel.com> wrote=
:
>
> > +/**
> > + * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> > + *
> > + * %eax:        ENCLU leaf, must be EENTER or ERESUME
> > + * %rbx:        TCS, must be non-NULL
> > + * %rcx:        Optional pointer to 'struct sgx_enclave_exception'
> > + *
> > + * Return:
> > + *  0 on a clean entry/exit to/from the enclave
> > + *  -EINVAL if ENCLU leaf is not allowed or if TCS is NULL
> > + *  -EFAULT if ENCLU or the enclave faults
> > + *
> > + * Note that __vdso_sgx_enter_enclave() is not compliant with the x86-
> > 64 ABI.
> > + * All registers except RSP must be treated as volatile from the
> > +caller's
> > + * perspective, including but not limited to GPRs, EFLAGS.DF, MXCSR,
> > FCW, etc...
> > + * Conversely, the enclave being run must preserve the untrusted RSP
> > and stack.
>
> By requiring preservation of RSP at both AEX and EEXIT, this precludes th=
e possibility of using the untrusted stack as temporary storage by enclaves=
. While that looks reasonable at first glance, I'm afraid it isn't the case=
 in reality. The untrusted stack is inarguably the most convenient way for =
data exchange between an enclave and its enclosing process, and is in fact =
being used for that purpose by almost all existing enclaves to date. Given =
the expectation that this API will be used by all future SGX application, i=
t looks unwise to ban the most convenient and commonly used approach for da=
ta exchange.

I'm going to go out on a limb and say that this is a good thing.

Using the untrusted stack as a way to exchange data is very
convenient, but that doesn't mean it's a good idea.  Here are some
problems it causes:

 - It prevents using a normal function to wrap enclave entry (as we're
seeing with this patch set).

 - It makes quite a few unfortunate assumptions about the layout of
the untrusted stack.  It assumes that the untrusted stack is
arbitrarily expandable, which is entirely untrue in languages like Go.
It assumes that the untrusted stack isn't further constrained by
various CFI mechanisms (e.g. CET), and, as of last time I checked, the
interaction between CET and SGX was still not specified.  It also
assumes that the untrusted stack doesn't have ABI-imposed layout
restrictions related to unwinding, and, as far as I know, this means
that current enclaves with current enclave runtimes can interact quite
poorly with debuggers, exception handling, and various crash dumping
technologies.

 - It will make it quite unpleasant to call into an enclave in a
coroutine depending on how the host untrusted runtime implements
coroutines.

So I think it's a *good* thing if the effect is to make enclave SDKs
change their memory management so that untrusted buffers are
explicitly supplied by the host runtime.  Honestly, I would have much
preferred if the architecture did not give the enclave access to RSP
and RBP at all.  (And, for that matter, RIP.)
