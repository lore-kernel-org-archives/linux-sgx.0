Return-Path: <SRS0=5ZAu=65=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81822C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 19:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E6D120727
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 19:55:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i4LsiWMo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgEOTzA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 15 May 2020 15:55:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34707 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726183AbgEOTy7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 15 May 2020 15:54:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589572497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iQptZ1WJz6XqQM2Mwc/yY9NqQTOh8PTaYoHOYTOng5k=;
        b=i4LsiWMoFVJVgcr/iSuH6QX+xdDN2B+9It0slnCNc2qms/moEejuiHwZqem4lWX/SiFrbu
        TOsbUpk5hk/9bbXF8aGyZEF9thxMZMfDS+VZyNCvODVnWvacBgvCFBfVzIPMZ/M1K8Ku0m
        sLVbmF8KNIGoPFt5HGDYuPA4i85dvag=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-XttBtji8NKq_7y4fzbmaLw-1; Fri, 15 May 2020 15:54:53 -0400
X-MC-Unique: XttBtji8NKq_7y4fzbmaLw-1
Received: by mail-il1-f198.google.com with SMTP id t10so3115673ilf.12
        for <linux-sgx@vger.kernel.org>; Fri, 15 May 2020 12:54:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iQptZ1WJz6XqQM2Mwc/yY9NqQTOh8PTaYoHOYTOng5k=;
        b=XFRF+oh0kaNnLPU8QDFLVl0Oy4Cek1VmYzv5fg7lzVGGgN1nKEdIcfpGkRdsDXFo2b
         o8v1yjcmp24Nehkajw4KMxRI02S6qsB5fGNhQU1KmD/Ywj3pd4pfnE9w98oOTVtRe1PT
         AmbREU55lN6mIAKRTEEi/34+NZ5iifieTQadC0CKf/ksdvOOAaNSE3cENvMsgwu2tKgb
         bUDqL3xUkPTxAZ4tkcUs3XwfJCF8fdgFSwW9fvdbE2VzwB+xY6rlZB0iFUge00Tv/k3s
         xAjQb1QZ2sVFwtu71zkkz5V3KMQz6AmHKHiNWLzUamuZrX2O3DZ9QZgiwPipuz83EtKc
         EXgA==
X-Gm-Message-State: AOAM5327384hzlfv6T1U6ZOYdKKZJ3V5S5cs2hnfFhU+PiBXABOlCrQT
        v+Ofvw02smo2FOSQRvz5coU9BeJVOAghxbper5kt+aLzZ24Kp1k5oSCtjU6gVk71TaWaW/vaHKC
        Hodu2qyllgsQuBKnd1m3KPykk4UX/9eiIOnWS
X-Received: by 2002:a05:6e02:1051:: with SMTP id p17mr5175252ilj.86.1589572492181;
        Fri, 15 May 2020 12:54:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2ERl/1dBTWD3PB9czGXWhCffXnov/d0Ql9SBZJHMfyt3ob43QayOj9wqOgICp/7dRukZ7aGynPI1zz06O1Bs=
X-Received: by 2002:a05:6e02:1051:: with SMTP id p17mr5175228ilj.86.1589572491727;
 Fri, 15 May 2020 12:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <20200426165753.GA11046@wind.enjellic.com> <87d07gk24l.fsf@nanos.tec.linutronix.de>
 <20200508190226.GA31465@wind.enjellic.com> <20200508195635.GR27052@linux.intel.com>
 <20200514091637.GA25156@wind.enjellic.com>
In-Reply-To: <20200514091637.GA25156@wind.enjellic.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Fri, 15 May 2020 15:54:40 -0400
Message-ID: <CAOASepNdOqsoYvPPf7+0_qU70JBMb9GMONrGX+jdt=SQtT1X8g@mail.gmail.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 14, 2020 at 5:17 AM Dr. Greg <greg@enjellic.com> wrote:
>
> On Fri, May 08, 2020 at 12:56:35PM -0700, Sean Christopherson wrote:
>
> Good morning, I hope the week is proceeding well for everyone.
>
> > On Fri, May 08, 2020 at 02:02:26PM -0500, Dr. Greg wrote:
> > > On Thu, May 07, 2020 at 02:41:30AM +0200, Thomas Gleixner wrote:
> > > > The diffstat of your patch is irrelevant. What's relevant is the
> > > > fact that it is completely unreviewed and that it creates yet
> > > > another user space visible ABI with a noticable lack of
> > > > documentation.
> >
> > ...
> >
> > > As to lack of review, we would certainly welcome technical and API
> > > comments but we cannot force them.
>
> > Thomas' point isn't that your code needs to be reviewed, it's that
> > trying to squeeze it into the initial merge will, not might, _will_
> > push out the acceptance of SGX.  The same is true for other features
> > we have lined up, e.g. KVM and cgroup support.  It's not a slight on
> > your code, it's just reality at this point.
>
> For the record and for whatever it is worth at this point.  The patch
> has been available in its present form and function for around 14
> months.
>
> So there was plenty of time for its consideration and integration into
> what is being prepared as the final merge candidate.
>
> > > In fact, anyone who reviews the patch will see that the current driver
> > > creates a pointer in the ioctl call to pass downward into the hardware
> > > initialization routines.  Our code simply replaces that pointer with
> > > one supplied by userspace.
>
> > Personally, I'm in favor of adding a reserved placeholder for a
> > token so as to avoid adding a second ioctl() in the event that
> > something gets upstreamed that wants the token.  Ditto for a file
> > descriptor for the backing store in sgx_enclave_create.
>
> That would be a very low cost and forward looking addition.
>
> > > At the very least a modular form of the driver should be
> > > considered that would allow alternate implementations.  Sean
> > > indicated that there was a 'kludgy' approach that would allow an
> > > alternate modular implementation alongside the in-kernel driver.
> > > I believe that Andy has already indicated that may not be an
> > > advisable approach.
>
> > Modularizing the the driver does nothing for your use case.  The
> > "driver" is a relatively lightweight wrapper, removing that is akin
> > to making /dev/sgx/enclave inaccessible, i.e. it doesn't make the
> > EPC tracking and core code go away.  Modularizing the whole thing is
> > flat out not an option, as doing so is not compatible with an EPC
> > cgroup and adds unnecessary complexity to KVM enabling, both of
> > which are highly desired features by pretty much everyone that plans
> > on using SGX.
>
> All well taken technical points, but they don't speak directly to the
> issue at hand.  The potential security issue in all of this is access
> to /dev/sgx/enclave, not the EPC tracking and core code.
>
> Here in a nutshell is the paradox the kernel faces:
>
> No one seems to be disputing the fact that the primary focus of this
> driver will be to support the notion of 'runtime encryption' and
> Confidential Computing.  The whole premise of the concept and economic
> predicate of the initiative is that the owner/manager of the platform
> has no visibility into what is being done on the platform.
>
> If the Linux community believes that standard platform security
> controls can make qualitatively good judgements on what enclave based
> execution is doing, it is effectively making the statement that the
> very concept of runtime encryption and by extension Confidential
> Computing is invalid.
>
> If we accept the concept that Confidential Computing is valid then we
> admit the technology provides the opportunity for unsupervised code
> execution and data manipulation.
>
> Our premise in all of this is that one page of code implementing three
> linked lists is a small price to pay to provide platform owners with
> the opportunity to optionally implement what is effectively 2-factor
> authentication over this process.
>
> Going forward, if we are intellectually honest, all of this suggests
> that adding complexity to the driver with LSM controls makes little
> sense technically.  Since, by definition and economic intent, the
> technology provides tools and infrastructure that allows these
> controls to be evaded.
>
> The notion that entities with adversarial intent would not try and
> take advantage of this flies in the face of everything we know about
> security.
>
> > Andy is right to caution against playing games to squish in-kernel
> > things, but the virtualization snafu is a completely different
> > beast.  E.g. SGX doesn't require fiddling with CR4, won't corrupt
> > random memory across kexec(), doesn't block INIT, etc...  And I'm
> > not advocating long-term shenanigans, I just wanted to point out
> > that there are options for running out-of-tree drivers in the short
> > term, e.g. until proper policy controls land upstream.
>
> It appears that the distributions, at least IBM/RHEL, are going to
> compile this driver in and backport it as well.

The (Red Hat sponsored) Enarx project will continue building an
unofficial, unsupported version of the Fedora kernel with the SGX
patches[0] until such time as the patches are upstream. Once upstream,
I intend to propose that the feature be enabled in the stock Fedora
kernel.

Enarx requires EDMM support as a prerequisite to being production
ready. Therefore, we are likely to continue building this custom
Fedora kernel with the latest patches until such point as EDMM support
lands upstream. This also implies that I have no current plan to
request an SGX backport to a RHEL kernel until such time as it
supports our full needs.

Disclaimer: I do not control RHEL or Fedora kernel features. None of
the above constitutes a commitment to deliver anything.

[0]: https://copr.fedorainfracloud.org/coprs/npmccallum/enarx/package/kernel/

> What we would recommend at this point is that you and Jarkko do the
> Linux community and beyond a favor and wire up a simple kernel
> command-line parameter that controls the ability of the driver to be
> used, ie. enables/disables access to /dev/sgx/enclave.
>
> Distributions or others can set this command-line parameter by default
> to 'disable' and avoid any possibility of the technology being used
> for nefarious purposes.  Since the technology now appears to be
> focused only on the cloud providers they will certainly be capable of
> configuring their implementations to change the default.
>
> In essence, make the kernel's behavior secure by default.
>
> Best wishes for a pleasant weekend to everyone.
>
> Dr. Greg
>
> As always,
> Dr. Greg Wettstein, Ph.D, Worker      Artisans in autonomously
> Enjellic Systems Development, LLC     self-defensive IOT platforms
> 4206 N. 19th Ave.                     and edge devices.
> Fargo, ND  58102
> PH: 701-281-1686                      EMAIL: greg@enjellic.com
> ------------------------------------------------------------------------------
> "Intellectuals solve problems; geniuses prevent them."
>                                 -- Albert Einstein
>

