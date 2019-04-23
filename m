Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FCC1C10F03
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 19:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEF8221773
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 19:44:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="OQStFlgb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfDWToU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Apr 2019 15:44:20 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40345 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfDWToU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 23 Apr 2019 15:44:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id c207so8001205pfc.7
        for <linux-sgx@vger.kernel.org>; Tue, 23 Apr 2019 12:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YcuiLaNgcaVq/lgdvtW+JDu4KErW8v9Zxv1tIYocNuE=;
        b=OQStFlgbVKMw9CQpMOd3kSfeHxnakYhdivmi2CtBl4ekxjjMo/Ct0Oo1xbkvr6lM9s
         KHYcgRtAURTwDnApuJ/ph5hL3NtyoSNlHaa7Ufz9LydfvwPWr1wzw/PyTL4cL9mdjHWe
         d9fEpuJld64LhCfUl3FMxRwwxcRZdjmjTkam+oqnufvSuoOV+/qC+omQDxeQqwEy3SYv
         8aY/Ubm9nbvrji/mDFpFUeqwlpQA4OTo3V9baHPA4+GoBMT1XVJ6PBJHEmITWctp3s5p
         jFcSEOAqnINPb1nt2L/u+9vslJdMq0VYjYs6fqOJ/ejYhq4R3/ucIHCnNUSlr354C54u
         KSrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YcuiLaNgcaVq/lgdvtW+JDu4KErW8v9Zxv1tIYocNuE=;
        b=iv60KqkKrSWRtdiWpo9a6yrZbyquPvU+0q0mW7LZe7iIGQcuje+98M3igkRLmipwQf
         Ok3RBdHATI/dcqqyi9SFTYQw4udbbWz7vartBl2k9Ty5WwBY1xTgYq07JxQPioxIruD4
         WzAKEE+dNTFZy/ZzY62gyIyUX9THPA0cGzDxkjpT674Tvc+61l69ydhkydjNt7fuK7Hu
         LlkIOu70XajuhhPIaCY8bzFZgZU9fgzDpKIqqmefwKKhs1t0KhxGF/4Zmu6KY5BOcyme
         D91G/bUK8E/aA3eUIUhsXKIRWn4pYsy6ukj73brrYTSWrVlM9yfEBESFCMcRahsd5hwM
         Amsg==
X-Gm-Message-State: APjAAAU/+zq3EBt23sbXu6AtXpDDCEscKkk9U6QmTGB75GnWNx3qnAla
        e41+cRdVUjS+38yEP0tJUUeLKQ==
X-Google-Smtp-Source: APXvYqz9G1+X3E9HCsVlaSAi/KjuCekDBzUtbI+CAcN9ReNcBsYz0rL6KpLMB/H4r1NxDrSc5l7Mww==
X-Received: by 2002:aa7:83d1:: with SMTP id j17mr28862063pfn.78.1556048659111;
        Tue, 23 Apr 2019 12:44:19 -0700 (PDT)
Received: from ?IPv6:2600:1010:b06d:689:56b:56b1:bb0d:6783? ([2600:1010:b06d:689:56b:56b1:bb0d:6783])
        by smtp.gmail.com with ESMTPSA id c3sm29430521pfg.88.2019.04.23.12.44.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 12:44:18 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH v1 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave() to allow parameter passing on untrusted stack
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <20190423192654.GA12691@linux.intel.com>
Date:   Tue, 23 Apr 2019 12:44:16 -0700
Cc:     Cedric Xing <cedric.xing@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, Hansen@linux.intel.com,
        Dave <dave.hansen@intel.com>, Christopherson@linux.intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, Ayoun@linux.intel.com,
        Serge <serge.ayoun@intel.com>, Katz-zamir@linux.intel.com,
        Shay <shay.katz-zamir@intel.com>, Huang@linux.intel.com,
        Haitao <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        Svahn@linux.intel.com, Kai <kai.svahn@intel.com>, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, Kai <kai.huang@intel.com>,
        rientjes@google.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B84F5867-A729-46E2-88F2-7D6F7C4DEE79@amacapital.net>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com> <cover.1555965327.git.cedric.xing@intel.com> <ba2a51568f3adaf74994d33ea3cbee570e20c6f6.1555965327.git.cedric.xing@intel.com> <20190423192654.GA12691@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Apr 23, 2019, at 12:26 PM, Sean Christopherson <sean.j.christopherson@i=
ntel.com> wrote:
>=20
>> On Mon, Apr 22, 2019 at 05:37:24PM -0700, Cedric Xing wrote:
>> The previous __vdso_sgx_enter_enclave() requires enclaves to preserve %rs=
p,
>> which prohibits enclaves from allocating and passing parameters for
>> untrusted function calls (aka. o-calls).
>>=20
>> This patch addresses the problem above by introducing a new ABI that pres=
erves
>> %rbp instead of %rsp. Then __vdso_sgx_enter_enclave() can anchor its fram=
e
>> using %rbp so that enclaves are allowed to allocate space on the untruste=
d
>> stack by decrementing %rsp. Please note that the stack space allocated in=
 such
>> way will be part of __vdso_sgx_enter_enclave()'s frame so will be freed a=
fter
>> __vdso_sgx_enter_enclave() returns. Therefore, __vdso_sgx_enter_enclave()=
 has
>> been changed to take a callback function as an optional parameter, which i=
f
>> supplied, will be invoked upon enclave exits (both AEX (Asynchronous Encl=
ave
>> eXit) and normal exits), with the value of %rsp left
>> off by the enclave as a parameter to the callback.
>>=20
>> Here's the summary of API/ABI changes in this patch. More details could b=
e
>> found in arch/x86/entry/vdso/vsgx_enter_enclave.S.
>> * 'struct sgx_enclave_exception' is renamed to 'struct sgx_enclave_exinfo=
'
>>  because it is filled upon both AEX (i.e. exceptions) and normal enclave
>>  exits.
>> * __vdso_sgx_enter_enclave() anchors its frame using %rbp (instead of %rs=
p in
>>  the previous implementation).
>> * __vdso_sgx_enter_enclave() takes one more parameter - a callback functi=
on to
>>  be invoked upon enclave exits. This callback is optional, and if not
>>  supplied, will cause __vdso_sgx_enter_enclave() to return upon enclave e=
xits
>>  (same behavior as previous implementation).
>> * The callback function is given as a parameter the value of %rsp at encl=
ave
>>  exit to address data "pushed" by the enclave. A positive value returned b=
y
>>  the callback will be treated as an ENCLU leaf for re-entering the enclav=
e,
>>  while a zero or negative value will be passed through as the return
>>  value of __vdso_sgx_enter_enclave() to its caller. It's also safe to
>>  leave callback by longjmp() or by throwing a C++ exception.
>>=20
>> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
>> ---
>> arch/x86/entry/vdso/vsgx_enter_enclave.S | 156 ++++++++++++++---------
>> arch/x86/include/uapi/asm/sgx.h          |  14 +-
>> 2 files changed, 100 insertions(+), 70 deletions(-)
>>=20
>> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vd=
so/vsgx_enter_enclave.S
>> index fe0bf6671d6d..210f4366374a 100644
>> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
>> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
>> @@ -14,88 +14,118 @@
>> .code64
>> .section .text, "ax"
>>=20
>> -#ifdef SGX_KERNEL_DOC
>=20
> This #ifdef and the pseudo-C code below has a functional purpose.  From
> the original commit:
>=20
>  Note, the C-like pseudocode describing the assembly routine is wrapped
>  in a non-existent macro instead of in a comment to trick kernel-doc into
>  auto-parsing the documentation and function prototype.  This is a double
>  win as the pseudocode is intended to aid kernel developers, not userland
>  enclave developers.
>=20
> We don't need full pseudocode, but a C-like prototype is necessary to get
> the kernel-doc comment parsed correctly.

That should be explained in a comment :)

=E2=80=94Andy

