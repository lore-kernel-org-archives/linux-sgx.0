Return-Path: <SRS0=LYKh=NM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B90BC0044C
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 17:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38F5B20830
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Nov 2018 17:53:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="DiVV/fTG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38F5B20830
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbeKBC5D (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Nov 2018 22:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbeKBC5D (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Nov 2018 22:57:03 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4657E2084C
        for <linux-sgx@vger.kernel.org>; Thu,  1 Nov 2018 17:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541094783;
        bh=7MPhE/56b+Tg2AzXHfnOhsnZWjawfOGQisxu5FN6fC8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DiVV/fTGsNIKxqpIRitIyJcfwWyoqHmU94impFZFMW3YRY7cmzI+wmetwU0fq5NZv
         dYKKbtAD+a7kO3fi8wFiezrSyK6bTSnpIgUgs/q4Fc5csC4JswJmyQcjQqUSLAAi5P
         TqpfAESmMe6UISVZDF/JFnvExhP7LPxLDXdBhv/s=
Received: by mail-wr1-f47.google.com with SMTP id x12-v6so20908306wrw.8
        for <linux-sgx@vger.kernel.org>; Thu, 01 Nov 2018 10:53:03 -0700 (PDT)
X-Gm-Message-State: AGRZ1gLgzEufqljomWyCRwsMXbx1ex1Q37zzwNl+rkVuBQ3PyztR+PhU
        uDB+hkj6rxu1+k3nJ7+BV5YimhM9OkL2bLStRT/DCA==
X-Google-Smtp-Source: AJdET5dOYJf/U33g1byRKHZfT0JFc0prDVp5SxTAFjrW4EXhkgKFsSalRFfSTi2jdtMHCbFr+9tFl+oY+wTJDfSM3Zc=
X-Received: by 2002:adf:9d4a:: with SMTP id o10-v6mr4641849wre.94.1541094781681;
 Thu, 01 Nov 2018 10:53:01 -0700 (PDT)
MIME-Version: 1.0
References: <20180926173516.GA10920@linux.intel.com> <2D60780F-ADB4-48A4-AB74-15683493D369@amacapital.net>
 <9835e288-ba98-2f9e-ac73-504db9512bb9@intel.com> <20180926204400.GA11446@linux.intel.com>
 <b7e14c6e-fc05-93fa-eef9-5e3f06ab4729@intel.com> <CALCETrXByb2UVuZ6AXUeOd8y90NAikbZuvdN3wf_TjHZ+CxNhA@mail.gmail.com>
 <992b1d6d-cc0f-776f-d938-2a1f7cad52c8@intel.com> <20180927135603.GF8242@linux.intel.com>
 <ae76dfe7-3587-0d21-37b7-535279edc235@fortanix.com> <2e7b81e1-818f-7d76-e2b4-793d9ec5d5a6@intel.com>
 <20181031213036.GA23089@linux.intel.com> <a9c23203-476d-875d-9fbb-263716833e17@intel.com>
 <dc0f8bc8-4d69-517e-68af-abda2d51423f@fortanix.com> <a6deac4e-ce8f-aa43-2d75-a04c05bac104@intel.com>
 <2833FD27-42A0-435C-AEA5-2DC73315867A@amacapital.net> <99b6de19-5620-7f3b-5c37-dbf8a6baef17@intel.com>
In-Reply-To: <99b6de19-5620-7f3b-5c37-dbf8a6baef17@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 1 Nov 2018 10:52:48 -0700
X-Gmail-Original-Message-ID: <CALCETrWzi=eV2YHgxr9uoxtscJGgrhBJjFkNX2qHZ3z-XxkeBg@mail.gmail.com>
Message-ID:
 <CALCETrWzi=eV2YHgxr9uoxtscJGgrhBJjFkNX2qHZ3z-XxkeBg@mail.gmail.com>
Subject: Re: [PATCH v14 09/19] x86/mm: x86/sgx: Signal SEGV_SGXERR for #PFs w/ PF_SGX
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        linux-sgx@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181101175248.UxYUOKrMVli7wHJessMsH_ODEXGJQSNstkXQ9l4v_zM@z>

On Thu, Nov 1, 2018 at 10:51 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 10/31/18 3:52 PM, Andy Lutomirski wrote:
> > I think EENTER in plain user code should have well defined semantics,
> > and it should get regular signals with the appropriate bits set in
> > the error code field in the ucontext.  But we should probably
> > simultaneously offer a nicer API, and the libraries will use it
> > because it=E2=80=99s nicer.
>
> FWIW, if we have a signal-based version and a VDSO-based version, nobody
> will use the VDSO one.
>
> The Intel libraries are surely going to keep using the approach they've
> been using for years and I doubt their owners will be tempted even by a
> simpler interface to change one line of code.
>
> If we want to do the VDSO route, I think we probably need to go
> whole-hog and toss the signal-based one.

That's a fair point.  We don't want a situation where a widely-used
SGX library registers a SIGSEGV handler.
