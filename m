Return-Path: <SRS0=JhNk=4K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96051C35671
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Feb 2020 05:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DCE0208C4
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Feb 2020 05:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582350099;
	bh=yVhUkeZJsjnZ3/rUgBkaWVRi/c/Sx/i/4Fl6pqkgqrY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=kl84nlLoe2EwuCG3tauAYEUliQVGs1Y8kdMKFAQTTx+wkch43IARGLKrVt6ox3fso
	 Bspz7cEtQXp4qWoMv1y/r5a2tdQVEH3e6cyIHJAt+x1d0Ovd2Hmg0WDFL5Shd+A/76
	 LghpkuSft+B2jG9dPEJ53iloJIpXJhf4mplTgJK0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgBVFlj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 22 Feb 2020 00:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgBVFli (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 22 Feb 2020 00:41:38 -0500
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88344208C4
        for <linux-sgx@vger.kernel.org>; Sat, 22 Feb 2020 05:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582350097;
        bh=yVhUkeZJsjnZ3/rUgBkaWVRi/c/Sx/i/4Fl6pqkgqrY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BeBMDUbzbXVkMk/WShPaVUOGmf5CK9OG5Ati8FxYbZ2wwoe+S1DcnoZmd1nF5NaPX
         R9SLZ0DxPx0HNW4obx+/Wb+EbBxrMW66uTKyMvq56DLz+aAJ917lV4Ya1ag9E4Yj4T
         XH4tR64xfhT9MgRCUZ8BYHEynwueZdn1euZsLHKk=
Received: by mail-wm1-f43.google.com with SMTP id q9so3855850wmj.5
        for <linux-sgx@vger.kernel.org>; Fri, 21 Feb 2020 21:41:37 -0800 (PST)
X-Gm-Message-State: APjAAAXPtpAo/o7cF1a0ewS+inR/rJDnk4sQ/ddhZareYr1NbIX9OBh0
        hpcp7NIaF+jRILUWjSiQbt3zPOtm4czWspZq3HDtJw==
X-Google-Smtp-Source: APXvYqzZRTsUOxoGK1lwl9hyF1NALTaWziDXZEXUEbWw6d713nl01YpnotdfUUfGPmSlM6aRvC57cSutan5TjPCaZUY=
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr7985768wmi.21.1582350095924;
 Fri, 21 Feb 2020 21:41:35 -0800 (PST)
MIME-Version: 1.0
References: <20200218104243.GA13967@wind.enjellic.com> <8269DEFA-960C-47D0-A1E5-14C427F3CD23@amacapital.net>
 <20200222031607.GA29858@wind.enjellic.com>
In-Reply-To: <20200222031607.GA29858@wind.enjellic.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 21 Feb 2020 21:41:24 -0800
X-Gmail-Original-Message-ID: <CALCETrX2UhC-+p3nkTk47RjqCSa9=MKQC47DTXw5wgsiijr0Rg@mail.gmail.com>
Message-ID: <CALCETrX2UhC-+p3nkTk47RjqCSa9=MKQC47DTXw5wgsiijr0Rg@mail.gmail.com>
Subject: Re: x86/sgx: v23-rc2
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 21, 2020 at 7:16 PM Dr. Greg <greg@enjellic.com> wrote:
>
> On Tue, Feb 18, 2020 at 07:00:23AM -0800, Andy Lutomirski wrote:
>
> > > On Feb 18, 2020, at 2:43 AM, Dr. Greg Wettstein <gw@idfusion.org> wrote:

> > No, this isn't the fundamental issue, because DAC/MAC is just as
> > relevant to systems with SGX and SGX2.  I'm sure that there will
> > be systems that work with SGX and with everything running as root
> > (or even SGX on a kernel without access control at all), but these
> > will be a minority. Even if you have absolutely perfect protection
> > of sensitive data, you sacrifice any sort of defense in depth
> > against an attacker DoSing you in any number of amazing ways.  Or,
> > for that matter, leaking keys derived from the provisioning key.
>
> I should have been more precise, my apologies.
>
> When I was suggesting that DAC/MAC controls were not relevant, I was
> referring to their relevance with respect to protecting the platform
> from running code that does not have defined provenance or origin.

Windows systems quite regularly get owned by code with "defined
provenance or origin" in the sense that it was signed by a valid
Authenticode certificate. :)

> I'm certainly not argueing against defense in depth or the merits of
> DAC/MAC controls.  I'm simply stating that they are irrelevant, with
> respect to the concerns that you raised about code provenance and
> origin, on flexible launch control platforms that support SGX2 and
> EDMM.  Platforms that by and large will be the primary target for this
> driver.

I have a little FLC platform on my desk.  What I don't have is an FLC
platform with anything resembling a policy that helps here at all.

> I only bring up the issue in the interests of intellectual honesty and
> the fact that I'm sure our exchanges will go down in the annals of
> security history as being as important as the Lincoln/Douglas debates.

That would be amazing!

>
> It is one of my jobs to follow the security literature closely.
> Everyone who does so can easily envision a future abstract reading
> something like the following:
>
> "Using an unmodified and stock DIST_OS kernel we were able to
> demonstrate the download and execution of malicious code into an
> enclave that bypasses all security controls in the Linux operating
> system allowing us to recover XXXX information from the platform with
> subsequent exfiltration of the information from the platform without
> detection."
>

Alas, the significance of this seems to depend on what XXXX is.  If
XXXX is a detail of the specific machine (a derived provisioning key,
a launch token, etc.), then the paper won't be terribly interesting.
As root (or someone who can escalate to root or better) on a given
system, I can extract *tons* of identifying details of the platform.
If XXXX is a secret created by the user (a sealing key, something
sealed by SGX, a private key or secret that allows one to pretend to
be an enclave with MRSIGNER=YYY, etc), then launch control and DAC are
essentially irrelevant to the discussion.  What actually happened is
that some code signed by YYY screwed up.  And this is because launch
control is not part of the SGX root of trust, nor is launch control
even a necessary part of the SGX security model.  SGX with launch
control deleted entirely would be just as useful, if potentially a bit
more dangerous in terms of being able to make malware hard to analyze.

> > (Don't forget that, no matter how carefully your system might lock
> > down the SGXPUBKEYHASH MSRs and control the associated keys, that
> > lockdown is being done by non-enclave *software*, and a bad guy who
> > gets root is quite likely to be able to unlock the registers by
> > upgrading their root access to control the firmware.  Or get a launch
> > token that can't be revoked because SGX doesn't have a token
> > expiration mechanism.)
>
> Dispassionate observers would note that you make the case for locked
> launch control registers.... :-)
>
> At an SGX engineering meeting in Israel last summer, we made the case
> for the fact that locked vs. unlocked platforms should be a BIOS
> configurable option.  With an additional option that specifying locked
> also allows specification of what the identity modulus signature
> should be.  That would seem to be the best of all worlds, we will see
> what happens.
>
> One of the pushbacks we received, is that SGX is supposed to be immune
> from firmware manipulation, which our suggested approach would open
> the door for, which we noted was irrelevant given the trajectory that
> the Linux kernel driver is on, ie. no cryptographic controls over code
> origin and provenance.

I don't believe I have ever said that Linux shouldn't support
cryptographic verification of SGX code provenance or that Linux
shouldn't eventually support locked launch control MSRs.  What I've
said is that the initial upstream version of the driver doesn't need
this, and that adding support for locked MSRs is tricky and needs some
design work.

FWIW, I didn't expect upstreaming to take anywhere near this long.

>
> Just to provide a frame of reference, our interest in SGX is with
> respect to its guarantee of integrity of execution, for the purposes
> of verifying that the kernel could not have executed code that was
> outside a desired behavioral definition for the platform.

SGX cannot and will never prevent the kernel from executing normal
CPL0 code of any sort.  I'm not really sure what you're getting at
here.  If you have magically trustworthy firmware and locked launch
control registers, you can prevent the kernel from executing
unapproved *enclave* code.  It's not entirely clear to me why you
consider unapproved enclave code to be worse than any other sort of
unapproved code.
