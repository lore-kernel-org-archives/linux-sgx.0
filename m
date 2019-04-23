Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBB0C282E1
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 19:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFE2F218D3
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556046462;
	bh=9GSdW1aq+r9nV1/Bl6Pg8a6JY989aBpJAknNyTYBqWU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=hIs3WJa3Ffn//WKlJIGyM4HQjIMKpKDng41SSbhVUF+8lYwTvrvTd+VcBsxumItd+
	 okLNSkFu8reWCzeeLnpRW5rBJuFwVWg12KrtOI6Q9H8hmdZoFThmmK2gufjzJTsWr8
	 aopZoQKEHQCEceI0AMGqrvGN8UrgC00LnVuaY8CI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfDWTHl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Apr 2019 15:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbfDWTHk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Apr 2019 15:07:40 -0400
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54C7021907
        for <linux-sgx@vger.kernel.org>; Tue, 23 Apr 2019 19:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556046459;
        bh=9GSdW1aq+r9nV1/Bl6Pg8a6JY989aBpJAknNyTYBqWU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tE8EDMvHYUZdISI2w7FGpF/jSAL/HeobSnoquVCzOrUVjswzg9Awgrk1G5e6HJfKh
         D38PlZAo5bubEBtS7r0JqfnbpEm0KKC+t8JJxprba6+iU7b7wInB+aTsVdeQDt/OWy
         ojIsREI7tc6k86ypF0gvGwKIHlBp4QVJ8BnLCfKU=
Received: by mail-wr1-f51.google.com with SMTP id k17so21607999wrx.10
        for <linux-sgx@vger.kernel.org>; Tue, 23 Apr 2019 12:07:39 -0700 (PDT)
X-Gm-Message-State: APjAAAVwBu3/mI8Q6pM26QMifcrdfUYd7Bt+282xWnBMlTry/tJp7nMx
        7Tl1Cdf8fGXB18MgOkTKhFY1t4jAGMSiQqvbuzBn/g==
X-Google-Smtp-Source: APXvYqwbjAAuv9MqdQbukmfVqGACv2C4RdBg4SyS/qRMXdaLvf0h2YAOufody3VVB6sBsgJRHOJRN0uX17QpVKBQXKE=
X-Received: by 2002:adf:ed82:: with SMTP id c2mr17544533wro.176.1556046457760;
 Tue, 23 Apr 2019 12:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <cover.1555965327.git.cedric.xing@intel.com> <f82e81c9cae31634684964d3fc4e9637e7565c69.1555965327.git.cedric.xing@intel.com>
 <CALCETrWpMxoX00SfnCgYdNbT5JmnzHNJ+73NmUjebBEjk7DuJA@mail.gmail.com> <20190423185937.GD10720@linux.intel.com>
In-Reply-To: <20190423185937.GD10720@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 23 Apr 2019 12:07:26 -0700
X-Gmail-Original-Message-ID: <CALCETrWcJw7+tSni3zp4kO=r6gVGkVDnc2477fPg0ErUzvJAKg@mail.gmail.com>
Message-ID: <CALCETrWcJw7+tSni3zp4kO=r6gVGkVDnc2477fPg0ErUzvJAKg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 3/3] selftests/x86: Augment SGX selftest to test
 new __vdso_sgx_enter_enclave() and its callback interface
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave <dave.hansen@intel.com>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge <serge.ayoun@intel.com>,
        Shay <shay.katz-zamir@intel.com>,
        Haitao <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kai <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai <kai.huang@intel.com>, David Rientjes <rientjes@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 23, 2019 at 11:59 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Apr 22, 2019 at 06:29:06PM -0700, Andy Lutomirski wrote:
> > What's not tested here is running this code with EFLAGS.TF set and
> > making sure that it unwinds correctly.  Also, Jarkko, unless I missed
> > something, the vDSO extable code likely has a bug.  If you run the
> > instruction right before ENCLU with EFLAGS.TF set, then do_debug()
> > will eat the SIGTRAP and skip to the exception handler.  Similarly, if
> > you put an instruction breakpoint on ENCLU, it'll get skipped.  Or is
> > the code actually correct and am I just remembering wrong?
>
> The code is indeed broken, and I don't see a sane way to make it not
> broken other than to never do vDSO fixup on #DB or #BP.  But that's
> probably the right thing to do anyways since an attached debugger is
> likely the intended recipient the 99.9999999% of the time.
>
> The crux of the matter is that it's impossible to identify whether or
> not a #DB/#BP originated from within an enclave, e.g. an INT3 in an
> enclave will look identical to an INT3 at the AEP.  Even if hardware
> provided a magic flag, #DB still has scenarios where the intended
> recipient is ambiguous, e.g. data breakpoint encountered in the enclave
> but on an address outside of the enclave, breakpoint encountered in the
> enclave and a code breakpoint on the AEP, etc...

Ugh.  It sounds like ignoring the fixup for #DB is the right call.
But what happens if the enclave contains an INT3 or ICEBP instruction?
 Are they magically promoted to #GP, perhaps?

As a maybe possible alternative, if we made it so that the AEX address
was not the same as the ENCLU, could we usefully distinguish these
exceptions based on RIP?  I suppose it's also worth considering
whether page faults from *inside* the enclave should result in SIGSEGV
or result in a fixup.  We certainly want page faults from the ENCLU
instruction itself to get fixed up, but maybe we want most exceptions
inside the enclave to work a bit differently.  Of course, if we do
this, we need to make sure that the semantics of returning from the
signal handler are reasonable.
