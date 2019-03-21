Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5A6C43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 17:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC6072192C
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 17:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553188671;
	bh=WsKSF+zGLwW5PKCNIOztvcWl/iA1OqywT7nrcQF1ejs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=KoCHoLvK9mzRNX7WH3do/Ra4ayrA75uzbt48axvo+Bm/fJ7DQ2w7HVMtxoyZ1F03U
	 1sUG7tWgz1G2DezXNE6GaL7b3JUjamlzLR73tP1Rws5NPL37uhM2WxJEAjRxxdleCF
	 bum8ZQ5O4OVfNO+TSrUVrJ+eNqtgzl3LiwCUH0/s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfCURRu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:17:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbfCURRu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 13:17:50 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C98702192C
        for <linux-sgx@vger.kernel.org>; Thu, 21 Mar 2019 17:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553188669;
        bh=WsKSF+zGLwW5PKCNIOztvcWl/iA1OqywT7nrcQF1ejs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=e1zwLzr5mrTfauENfheIebZJHDS1+mOQHlh0EIPdsynHekd9MyydaIgpa73ECHzWl
         fAp182JAq4nJ2rV+C4mVK6OzcwoWdrQ7DRPU7Zhc/lWkBw9elFZITjDzJL8gQVw6vI
         a9r0eNa8dyu0/qx/gMuDMx8VV2qSof6MLKu29CII=
Received: by mail-wr1-f52.google.com with SMTP id p1so7479081wrs.8
        for <linux-sgx@vger.kernel.org>; Thu, 21 Mar 2019 10:17:48 -0700 (PDT)
X-Gm-Message-State: APjAAAXW1zjNUvQNdyMFFXiEGJdu6sm36WXnEzwa+9ozEo221aZ4PbeM
        8xmEar6LgsL6dJpPgtR+OXR9+O6eBS9DJUU49t/fiw==
X-Google-Smtp-Source: APXvYqw16rjChxr+9f5xA+AoFwKmqqUiPbgDItduKW2igqPF9TGgeGe7abMtDrU7kMzjoJTOLJNA5rjqMI7yQi0WB1Y=
X-Received: by 2002:a5d:6252:: with SMTP id m18mr3198617wrv.199.1553188667346;
 Thu, 21 Mar 2019 10:17:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <CALCETrVKAUK-jZ7Knp7RetTL055p3iK1D8Wyr6=hPq5HkePkFg@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C53D@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E85C53D@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 21 Mar 2019 10:17:36 -0700
X-Gmail-Original-Message-ID: <CALCETrUmWJRg120Evk4ctAUXOiA5HcfrW2uGWq_Z0OT5K70zGw@mail.gmail.com>
Message-ID: <CALCETrUmWJRg120Evk4ctAUXOiA5HcfrW2uGWq_Z0OT5K70zGw@mail.gmail.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add __vdso_sgx_enter_enclave()
 to wrap SGX enclave transitions
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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

On Wed, Mar 20, 2019 at 12:57 PM Xing, Cedric <cedric.xing@intel.com> wrote=
:
>
> > Using the untrusted stack as a way to exchange data is very convenient,
> > but that doesn't mean it's a good idea.  Here are some problems it
> > causes:
> >
> >  - It prevents using a normal function to wrap enclave entry (as we're
> > seeing with this patch set).
>
> It doesn't prevent. It's all about what's agreed between the enclave and =
its hosting process. With the optional "exit/exception callback" set to nul=
l, this will behave exactly the same as in the current patch. That's what I=
 meant by "flexibility" and "superset of functionality".
>
> >
> >  - It makes quite a few unfortunate assumptions about the layout of the
> > untrusted stack.  It assumes that the untrusted stack is arbitrarily
> > expandable, which is entirely untrue in languages like Go.
>
> I'm with you that stack is not always good thing, hence I'm NOT ruling ou=
t any other approaches for exchanging data. But is stack "bad" enough to be=
 ruled out completely? The point here is flexibility because the stack coul=
d be "good" for its convenience. After all, only buffers of "reasonable" si=
zes will be exchanged in most cases, and in the rare exceptions of stack ov=
erflow they'd probably get caught in validation anyway. The point here agai=
n is - flexibility. I'd say it's better to leave the choice to the SDK impl=
ementers than to force the choice on them.
>
> > It assumes that the untrusted stack isn't further constrained by variou=
s
> > CFI mechanisms (e.g. CET), and, as of last time I checked, the
> > interaction between CET and SGX was still not specified.
>
> I was one of the architects participating in the CET ISA definition. The =
assembly provided was crafted with CET in mind and will be fully compatible=
 with CET.
>
> > It also
> > assumes that the untrusted stack doesn't have ABI-imposed layout
> > restrictions related to unwinding, and, as far as I know, this means
> > that current enclaves with current enclave runtimes can interact quite
> > poorly with debuggers, exception handling, and various crash dumping
> > technologies.
>
> Per comments from the patch set, I guess it's been agreed that this vDSO =
function will NOT be x86_64 ABI compatible. So I'm not sure why stacking un=
winding is relevant here. However, I'm with you that we should take debuggi=
ng/exception handling/reporting/crash dumping into consideration by making =
this vDSO API x86_64 ABI compatible. IMO it's trivial and the performance o=
verhead in negligible (dwarfed by ENCLU anyway. I'd be more than happy to p=
rovide a x86_64 ABI compatible version if that's also your preference.
>
> >  - It will make it quite unpleasant to call into an enclave in a
> > coroutine depending on how the host untrusted runtime implements
> > coroutines.
>
> I'm not sure what you are referring to by "coroutine". But this vDSO API =
will be (expected to be) the only routine that actually calls into an encla=
ve. Isn't that correct?

I mean use in languages and runtimes that allow a function and its
callees to pause and then resume later.  Something like (pseudocode,
obviously):

void invoke_the_enclave()
{
  do_eenter_through_vdso();
}

void some_ocall_handler(void *ptr)
{
  yield;
}

If the enclave has ptr pointing to the untrusted stack, then this gets
quite awkward for the runtime to handle efficiently.  IMO a much nicer
approach would be:

void invoke_the_enclave()
{
  char buffer[1024];
  while (true)
  {
    eenter (through vdso);
    if (exit was an ocall request) {
      some_ocall_handler(buffer);
    }
  }
}

And now there is nothing funny happening behind the runtime's back
when some_ocall_handler tries to yield.
