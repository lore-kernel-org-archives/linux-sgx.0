Return-Path: <SRS0=lC4h=R2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EE6C43381
	for <linux-sgx@archiver.kernel.org>; Sat, 23 Mar 2019 21:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9447A21841
	for <linux-sgx@archiver.kernel.org>; Sat, 23 Mar 2019 21:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553377116;
	bh=cl0jr4eyXKUaK4rgyZStbQ5rKTVR0eiKjCbLnGbDfDo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=kHFvEu/FxZV9ZgjMpK7+UYmkte4oJhbUM4m8u6JkhrLPUQ3fGs7gtGEectvASuUAg
	 AAu0JAKPvdeio/0JHYfMIQmVULfskKnHJ0JoiC+Yq7YSkF/tatgCh3lgLIeXhTmVdr
	 5r5Eo6sYv83Ph0HS8BgEpDqISHVA3b7SuOah94PM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbfCWVig (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 23 Mar 2019 17:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727184AbfCWVif (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 23 Mar 2019 17:38:35 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45A4821873
        for <linux-sgx@vger.kernel.org>; Sat, 23 Mar 2019 21:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553377114;
        bh=cl0jr4eyXKUaK4rgyZStbQ5rKTVR0eiKjCbLnGbDfDo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XfetP6J/7v0657y9M8ZIxiGf19LJ66Ur3ciWEKnORo5v8Um6C+5lZ/Pwg2LgOLnD/
         gnwU0B1ZulWZRF+voTe2tDoYUb/NFDjCBp2wIPAZc2TyTw6bNJeEvlZKeL8mO5KfvD
         b8z66wnyothTxDEn4GMHo+g6MVJ9r00cOka4oj+Q=
Received: by mail-wr1-f49.google.com with SMTP id j9so6012198wrn.6
        for <linux-sgx@vger.kernel.org>; Sat, 23 Mar 2019 14:38:34 -0700 (PDT)
X-Gm-Message-State: APjAAAWDSB1IgX6bzYBtOs+nD/cvrTBz2Fp8/1UScrF621tKGKgHPdwp
        yTFe0qOy913nLv2L55sp0gDnnv9HpxoXbPDSkzTUvw==
X-Google-Smtp-Source: APXvYqwXQm/lcVE5tTVE69PD0hUTvUsijzrcWFlYjp0kWlueI9ss+GtiY/8vpPJtOq8LcOe0Mq11EftOTrZLhyUPEAo=
X-Received: by 2002:adf:f011:: with SMTP id j17mr8091366wro.330.1553377112814;
 Sat, 23 Mar 2019 14:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
 <20190322215903.GE12666@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 23 Mar 2019 14:38:21 -0700
X-Gmail-Original-Message-ID: <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com>
Message-ID: <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add __vdso_sgx_enter_enclave()
 to wrap SGX enclave transitions
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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

> On Mar 23, 2019, at 10:36 AM, Xing, Cedric <cedric.xing@intel.com> wrote:
>
> Hi Sean,
>
>> Although its just 9 LOC, consider its impact on someone who is looking
>> at
>> the kernel's SGX support for the first time.  Questions they may have
>> when
>> looking at the vDSO code/documentation:
>>
>>  - What's an exit handler?
>>  - Why is an exit handler optional?  Don't I always want to handle
>> exits?
>>  - What value should my exit handler return?
>>  - What should my exit handler do if it detects an error?
>>  - Why would I want to preserve %rbp and not %rsp?
>>  - Isn't it insecure to use the untrusted stack in my enclave?
>>
>> AFAIK, the only reason to preserve %rbp instead of %rsp, i.e. support an
>> "exit handler" callback, is to be able to implement an o-call scheme
>> using
>> the untrusted stack to pass data.  Every idea I came up with for using
>> the
>> callback, e.g. logging, handling stack corruptiong, testing hooks,
>> etc...
>> was at worst no more difficult to implement when using a barebones vDSO.
>>
>> So, given the choice between a) documenting and maintaining all the
>> baggage
>> that comes with the exit handler and b) saying "go use signals", I chose
>> option b.
>
> Disagreed!
>
> This API is NOT even x86_64 compatible and NOT intended to be used by ave=
rage developers. Instead, this API will be used by SGX SDK vendors who have=
 all the needed background/expertise. And flexibility is way more important=
 to them than reduced documentation. Just imagine how much one needs to rea=
d to understand how SGX works, do you really think a function comprised of =
20 or so LOC will be a big deal?
>
> Anyway, the documentation needed IMO will not exceed even 1 page, which w=
ill be way shorter than most of docs in kernel source tree. I'll be more th=
an happy to help you out if that's out of your competence!
>
> Regarding maintenance, I see an API may require maintenance for 2 possibl=
e categories of reasons: 1) its interface cannot satisfy emerging applicati=
ons; or 2) the infrastructure it relies on has changed. Generally speaking,=
 a more generic API with less assumption/dependence on other components wil=
l impose lower maintenance cost in the long run. Comparing our proposals, t=
hey share the same dependences (i.e. SGX ISA and vDSO extable) but mine is =
more generic (as yours could be implemented using mine as a subroutine). Th=
us, I bet your proposal will impose higher maintenance cost in the long run=
.
>
>

I=E2=80=99m going to put my vDSO maintainer hat on for a minute.  Cedric, y=
our
proposal has the following issues related specifically to the vDSO:

It inherently contains indirect branches.  This means that, on
retpoline configurations, it probably needs to use retpolines.  This
is doable, but it=E2=80=99s nasty, and you need to worry about register
clobbers.

It uses effectively unbounded stack space. The vDSO timing functions
are already a problem for Go, and this is worse.

And with my vDSO hat back off, I find it disappointing that SGX SDKs
seem willing to couple the SGX enclaves so tightly to their host ABIs.
An *unmodified* SGX enclave should be able to run, without excessive
annoyance, in a Windows process, a Linux process, a C process, a Java
process, a Go process, and pretty much any other process.  Saying
=E2=80=9CI=E2=80=99ll just recompile it=E2=80=9D is a bad solution =E2=80=
=94 for enclaves that use
MRENCLAVE, you can=E2=80=99t, and for enclaves that use MRSIGNER, you need =
to
deal with the fact the protecting the signing key is a big deal.
Someone should be able to port the entire host program to a different
language without losing secrets and without access to a signing key.

Cedric, your proposal allows an enclave to muck with RSP, but not in a
way that=E2=80=99s particularly pleasant.  Since the ISA is set in stone, w=
e
can=E2=80=99t do anything about the enclave=E2=80=99s access to its caller=
=E2=80=99s
registers.  I would love to see a straightforward way to run an
enclave such that it does not access the main untrusted stack at all =E2=80=
=94
uRSP and uRBP should be arbitrary values passed in the untrusted code,
and the values the enclave sets should be relayed back to the caller
but otherwise not have any effect.  Sadly I see no way to do this
short of using GSBASE to store the real untrusted stack pointer.
Other than the segment bases, there appear to be literally zero
untrusted registers that are reliably preserved across an enclave
entry and exit.  I suppose we should use a syscall to help.

Since the above tricks seem unlikely to make it into the kernel, I
think we=E2=80=99re doing everyone a favor if the Linux APIs strongly
encourage SDK authors to build enclaves in a way that they don=E2=80=99t ma=
ke
problematic assumptions about the untrusted world. I would really like
to see enclaves generated by the Linux SDK work on Windows and vice
versa.
