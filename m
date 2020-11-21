Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374C7C5519F
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Nov 2020 18:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0028B22206
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Nov 2020 18:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4NAE/tE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgKUShS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 21 Nov 2020 13:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728201AbgKUShR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 21 Nov 2020 13:37:17 -0500
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C2822269
        for <linux-sgx@vger.kernel.org>; Sat, 21 Nov 2020 18:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605983836;
        bh=k4bb1XSryjOjrKpxNZH2F9eH58+fbIVd+aoQp0laXe4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Y4NAE/tEqUg/gNMrQ7inrCvPTLXMwTuIj3xOAWqsXeKJ+KzxTBJwDo9ThXWitboWn
         DcLN36fXAWIljW5O/B76tftncEDlzr9WVJZs5/K56Edt42vSlCydm8qtp7i75IQ4es
         9z1GViBGnY+3/drXDznTvhLlCyIiqi59OB1O/rXI=
Received: by mail-wm1-f54.google.com with SMTP id x13so4991550wmj.1
        for <linux-sgx@vger.kernel.org>; Sat, 21 Nov 2020 10:37:16 -0800 (PST)
X-Gm-Message-State: AOAM531aOwcb0fYzXwCKBTG2hXRX3G6Inqlhz2qAKqc5uYeCqJVjG6vp
        6HV1OCjiI0o524Lo4ozH4VwFaGLTdOkj0Dkx2uW5rw==
X-Google-Smtp-Source: ABdhPJyT+5j8rFsBwyu797OsJDl+WuTD1EdSAaQGjTptGYVDhPFIXviNZWOffcBNlGT7AqKtPnhaNScW8JUX+5hc0PY=
X-Received: by 2002:a7b:c92a:: with SMTP id h10mr15913375wml.138.1605983835075;
 Sat, 21 Nov 2020 10:37:15 -0800 (PST)
MIME-Version: 1.0
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com> <20201121151259.GA3948@wind.enjellic.com>
In-Reply-To: <20201121151259.GA3948@wind.enjellic.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 21 Nov 2020 10:36:58 -0800
X-Gmail-Original-Message-ID: <CALCETrXTjZSg-ccDKF7yX8y+vCCrcn9C_m6ZCGNdWHq73aUHQQ@mail.gmail.com>
Message-ID: <CALCETrXTjZSg-ccDKF7yX8y+vCCrcn9C_m6ZCGNdWHq73aUHQQ@mail.gmail.com>
Subject: Re: [PATCH v40 00/24] Intel SGX foundations
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Mikko Ylinen <mikko.ylinen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Dr. Greg, I know you like sending these emails, but they're not really
helpful for Linux kernel development.  Please see below.

On Sat, Nov 21, 2020 at 7:13 AM Dr. Greg <greg@enjellic.com> wrote:
>
> On Wed, Nov 04, 2020 at 04:54:06PM +0200, Jarkko Sakkinen wrote:
>
> Good morning, I hope the weekend is going well for everyone.
>
> > Important Kernel Touch Points
> > =============================
> >
> > This implementation is picky and will decline to work on hardware which
> > is locked to Intel's root of trust.
>
> Given that this driver is no longer locked to the Intel trust root, by
> virtue of being restricted to run only on platforms which support
> Flexible Launch Control, there is no longer any legitimate technical
> reason to not expose all of the functionality of the hardware.

I read this three times, and I can't tell what functionality you're
referring to.

>
> The patch that I am including below implements signature based policy
> controls for enclave initialization.  It does so in a manner that is
> completely transparent to the default behavior of the driver, which is
> to initialize any enclave passed to it with the exception of enclaves
> that set the PROVISION_KEY attribute bit.

It's completely unreviewable.  It's an ABI patch, and it does not
document what it does, nor does it document why it does it.  It's just
a bunch of code.  NAK.

To be crystal clear, I will not review, and I will NAK outright, any
patches of this sort, until ALL of the following conditions are met:

a) Either a functioning SGX driver lands in a -rc kernel or there is
an excellent justification for why a change of this sort is needed
prior to a release.  Dr. Greg, you seem to be interested in SGX
actually landing upstream, but these patches are just causing delays.
Please stop.

b) The patch needs to explain what problem it solves and why it is a
good solution to that problem.

c) The patch needs to explain, either in a changelog or in a text file
in the patch, *exactly* what it does.  Imagine MSDN-like documentation
in the good old days.  The documentation needs to be sufficiently
clear that a userspace programmer could use your mechanism without
reference to your implementation and that a kernel programmer could,
in principle, re-implement your code from the description.

Unless all three of these are met, your patch is going nowhere, and I
think no one should waste their time trying to read it.

>
> Secondary to the discussions that have been ongoing regarding the
> restriction of mmap/mprotect, this patch has been extended to
> implement signature based controls on dynamic enclaves.  The default
> behavior of the driver under this patch is to reject mmap/mprotect on
> initialized enclaves, unless the platform owner has elected to allow
> the enclave signer the option to implement 'dynamic' enclaves,
> ie. enclaves that are allowed to modify their page permissions after
> initialization.

You have sent this change repeatedly, and now for some reason you're
sending it mixed in with unrelated changes.  Please stop.  At no point
have you explained why this approach is better than anything else.  It
has the obnoxious side effect that you can't usefully SCM_RIGHTS an
enclave to a different process with your patch applied, which is at
least a minor disadvantage.  You have not explained any advantage to
your patch at all.

Dr Greg, before you hit send on further emails about SGX, could you
kindly try to imagine you're a kernel maintainer, read your own email,
and consider whether how to make it add something useful to the
discussion?

Thanks,
Andy
