Return-Path: <SRS0=Tkjg=R4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D133BC43381
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Mar 2019 23:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9349C206DF
	for <linux-sgx@archiver.kernel.org>; Mon, 25 Mar 2019 23:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553558082;
	bh=7IXy9PmaCQVWs3dr2OsZDsoJ+4vRKTCXqWnIvRBz76k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=OX8unh0mhriHkzLPb8mgRHFXBg11XKnrUiy2o4o1iLjMbNuK/Y9KXvDEcfBCz3M4s
	 DM9djqIcwCIkvU5wg+F0AteC3qZjLOvAQoo/7txMeFfrhDyMvW9vnH3Cgnc+mffEKJ
	 ag35BenthhDmC0Zc7IlswEOXceclG3bE8t8UD0Ac=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfCYXym (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 25 Mar 2019 19:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbfCYXyh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 25 Mar 2019 19:54:37 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAC4820863
        for <linux-sgx@vger.kernel.org>; Mon, 25 Mar 2019 23:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553558076;
        bh=7IXy9PmaCQVWs3dr2OsZDsoJ+4vRKTCXqWnIvRBz76k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XzC69H/tN4lPBbDrQRBTbjkRY6pxU0kBw05NZkNo+WwxSSCEW+YwwBkPfcL+qKXc7
         DJ0EU73PLPfGHUC2u0kMPObp5DuSB1wL4y1Cvg6PeFGwRd0jd25QMTAt3j45p/DmMS
         2ofeIPxMjX+kFyYDBDh/oQrIshVWbKj7oRQpLq10=
Received: by mail-wr1-f49.google.com with SMTP id t5so12166940wri.7
        for <linux-sgx@vger.kernel.org>; Mon, 25 Mar 2019 16:54:35 -0700 (PDT)
X-Gm-Message-State: APjAAAWHJ5Ji0uY8w+Qt0lUbDGvJDZ9F6pkr+xcEHyGZ/sPR2eqkrMx7
        SO2zuDWqxXQqF9kh1S5J3oESURizKDFDf3bXmVMhyw==
X-Google-Smtp-Source: APXvYqyAwesAdogoyPBQ9Lxod/+wH/aY0JfqLt7v1iZAm0KdKDvtbjsSoVTIYoTo1koKcclzFlN3HyDGjBZx1lh/tOE=
X-Received: by 2002:adf:f011:: with SMTP id j17mr15065852wro.330.1553558074255;
 Mon, 25 Mar 2019 16:54:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
 <20190322215903.GE12666@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
 <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 25 Mar 2019 16:54:23 -0700
X-Gmail-Original-Message-ID: <CALCETrWdc2d2HJ-aoE7-889sHN-YJiKXrEkssyWJ6QQTykb+EQ@mail.gmail.com>
Message-ID: <CALCETrWdc2d2HJ-aoE7-889sHN-YJiKXrEkssyWJ6QQTykb+EQ@mail.gmail.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add __vdso_sgx_enter_enclave()
 to wrap SGX enclave transitions
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
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

On Sun, Mar 24, 2019 at 1:59 AM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> Hi Andy,
>
> Thank you for your valuable feedbacks!
>
> Per what you have been saying, your feedbacks come from different angles =
- i.e. functionality vs. security, but they are mixed up somehow.

I think you're misunderstanding me.  I'm not talking about security at
all here.  SGX isn't a sandbox, full stop.  I'm talking about the
degree to which an SGX enclave acts like a well-behaved black box.

>
> > I=E2=80=99m going to put my vDSO maintainer hat on for a minute.  Cedri=
c, your
> > proposal has the following issues related specifically to the vDSO:
> >
> > It inherently contains indirect branches.  This means that, on retpolin=
e
> > configurations, it probably needs to use retpolines.  This is doable,
> > but it=E2=80=99s nasty, and you need to worry about register clobbers.
>
> Only the weakest link matters in security. With dynamic linking in use, t=
his additional indirect CALL can't make things worse. But I'm open to, and =
in fact also willing to, apply whatever mitigation that you think is satisf=
actory (or that has been applied to other indirect branches, such as in PLT=
), such as retpoline. Btw, don't worry about register clobbers because we h=
ave at least %rax at our disposal.

There is no actual fundamental reason that dynamic linking has to work
this way, and in principle, one could even use retpolines to the call
the vDSO.  In any event, the vDSO is currently compiled with
retpolines enabled, and if we decide to turn that off, it would be
decision to be made independently of SGX.

>
> >
> > It uses effectively unbounded stack space. The vDSO timing functions ar=
e
> > already a problem for Go, and this is worse.
>
> If targeting the same functionality (i.e. no exit callback), my API uses =
exactly 24 bytes more than Sean's. Is it really the case that those 24 byte=
s will break Go?

You're counting wrong.  Your version uses 24 bytes + the stack size of
the exit handler + the amount of stack consumed by the enclave, which
is effectively unbounded.  So this whole scheme becomes unusable on
anything other than a stack that is "large" for a totally undefined
value of large and that has guard pages.

>
> >
> > Cedric, your proposal allows an enclave to muck with RSP, but not in a
> > way that=E2=80=99s particularly pleasant.
>
> From security perspective, it is SGX ISA, but NOT any particular ABI, tha=
t allows enclaves "to muck with RSP".

Again, this has nothing to do with security.  With your proposal, it's
not possible for the caller of an enclave to decide, in an ocall
handler, to pause and do something else.  This isn't just theoretical.
Suppose someone wants to send a network request in an ocall handler.
With the current RSP approach, it's difficult to do this in a program
that uses poll / select / epoll -- you can't return out from the ocall
until you have an answer.
