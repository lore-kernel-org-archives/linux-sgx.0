Return-Path: <SRS0=4X3U=4Q=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424F6C3F2D2
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Feb 2020 22:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04086246B6
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Feb 2020 22:20:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bPLtlvGk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgB1WUB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Feb 2020 17:20:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38652 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726046AbgB1WUB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 28 Feb 2020 17:20:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582928399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bw5Jnhp7KqPb5r94FhJWL4ZVprMiJ57A5xuYCAkv6DM=;
        b=bPLtlvGkzkr5fo+m5hl7/lBLQc+PH/WkVvPYxC+PSr7xyKqUU0nRm7Ddb9Y4BMywoJGoiE
        /vM1s6fDUwbE+H4S+4J70ZQEta1kfnfG/eHZh2Frih0i4WU2ghLvwRx89bUVh6kApewIVZ
        MRWlMGhl+x+DuRiIPkmRhxFAW/fTy7g=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-v8q016CyOWGMWQWymO4veg-1; Fri, 28 Feb 2020 17:19:57 -0500
X-MC-Unique: v8q016CyOWGMWQWymO4veg-1
Received: by mail-il1-f198.google.com with SMTP id p7so4706140ilq.16
        for <linux-sgx@vger.kernel.org>; Fri, 28 Feb 2020 14:19:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bw5Jnhp7KqPb5r94FhJWL4ZVprMiJ57A5xuYCAkv6DM=;
        b=XkSsNDTZdWLPKhGrN9tqXR4XakqOlnPHeUSa9ehL9rQ4GG8wbv5zfimAnRa2wQOyci
         BHtMiEiTreHhoLOt/o0c0nPVyreBcpEyKp2wVkL+4jOXQwxSyibxE8PGhEtG4cLiQmWr
         9T2heB3OwgxQqQ7d2rIrPps3QXemS/JaBFT3rh4ztEzWcwoBLKoDn/h3A1KC+FRO7W8X
         qcjOEaLBZl2lXNMbP94fOXQWS4PNO66iJYCbLvwXGbcs7PbBMybj7ENPn5gzzXW8A7y5
         X73W7MItfkx/AwyzWVdPRVq3MpbncNONyZxxAP1C/08Twmz44BOx2RCwWKKPu2VJi4Oz
         g80A==
X-Gm-Message-State: APjAAAWMFr8WpQYo3MIAVh9bM7hI7qjTXTXeDEOxde2lmiHwpv/GPcNQ
        Q/758vf5uUL17dqzLJi+WrcIx1GDFjZUwW41336UMCIZJ1NrOW5aEhZ/xPYNf7JITb3Vifk6Vrr
        51JJ2ZAoIkmnLi6P/VWn5fQMtljWjOuieu9U4
X-Received: by 2002:a02:84ee:: with SMTP id f101mr5290806jai.7.1582928396002;
        Fri, 28 Feb 2020 14:19:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwOw4io9YQxYqs7muQh08Wi5KSyvP4Fx8ks9FOupRVElFoJFO/gjY7DAVMFEkm98oQfXCmYnmWSU5Uq/+CB9hE=
X-Received: by 2002:a02:84ee:: with SMTP id f101mr5290771jai.7.1582928395604;
 Fri, 28 Feb 2020 14:19:55 -0800 (PST)
MIME-Version: 1.0
References: <20200223172559.6912-1-jarkko.sakkinen@linux.intel.com>
 <20200224100932.GA15526@wind.enjellic.com> <20200224211317.GJ29865@linux.intel.com>
 <20200228220212.GA7978@wind.enjellic.com>
In-Reply-To: <20200228220212.GA7978@wind.enjellic.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Fri, 28 Feb 2020 17:19:45 -0500
Message-ID: <CAOASepMmFC5bmoETu_KP967u+vFkqb385JckU1uFHHaVKNVaFw@mail.gmail.com>
Subject: Re: [PATCH v27 00/22] Intel SGX foundations
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        Patrick Uiterwijk <puiterwijk@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 28, 2020 at 5:04 PM Dr. Greg <greg@enjellic.com> wrote:
>
> On Mon, Feb 24, 2020 at 01:13:17PM -0800, Sean Christopherson wrote:
>
> Hi, I hope the week is ending well for everyone.
>
> > On Mon, Feb 24, 2020 at 04:09:32AM -0600, Dr. Greg wrote:
> > > On Sun, Feb 23, 2020 at 07:25:37PM +0200, Jarkko Sakkinen wrote:
> > >
> > > Good morning, I hope the week is starting well for everyone.
> > >
> > > > Intel(R) SGX is a set of CPU instructions that can be used by
> > > > applications to set aside private regions of code and data. The code
> > > > outside the enclave is disallowed to access the memory inside the
> > > > enclave by the CPU access control.
> > >
> > > Do we misinterpret or is the driver not capable of being built in
> > > modular form?
>
> > Correct.
>
> That is what we had concluded, thanks for the verification.
>
> > > If not, it would appear that this functionality has been lost since
> > > version 19 of the driver, admittedly some time ago.
>
> > It was removed in v20[*].
>
> We didn't see documentation of this in any of the v20 release bullet
> points, hence the question.
>
> > > > * Allow the driver to be compiled as a module now that it no code is using
> > > >   its routines and it only uses exported symbols. Now the driver is
> > > >   essentially just a thin ioctl layer.
>
> > > Not having the driver available in modular form obviously makes
> > > work on the driver a bit more cumbersome.
>
> > Heh, depends on your development environment, e.g. I do 99% of my
> > testing in a VM with a very minimal kernel that even an anemic
> > system can incrementally build in a handful of seconds.
>
> Lacking a collection of big beefy development machines with 256+
> gigabytes of RAM isn't the challenge, rebooting to test functionality
> on the physical hardware is what is a bit of a nuisance.
>
> > > I'm assuming that the lack of module support is secondary to some
> > > innate architectural issues with the driver?
>
> > As of today, the only part of the driver that can be extracted into
> > a module is effectively the ioctl() handlers, i.e. a module would
> > just be an ioctl() wrapper around a bunch of in-kernel
> > functionality.  At that point, building the "driver" as a module
> > doesn't provide any novel benefit, e.g.  very little memory
> > footprint savings, reloading the module wouldn't "fix" any bugs with
> > EPC management, SGX can still be forcefully disabled via kernel
> > parameter, etc...  And on the flip side, allowing it to be a module
> > would require exporting a non-trivial number of APIs that really
> > shouldn't be exposed outside of the SGX subsystem.
> >
> > As for why things are baked into the kernel:
> >
> >   - EPC management: support for future enhancements (KVM and EPC cgroup).
> >
> >   - Reclaim: don't add a unnecessary infrastructure, i.e. avoid a callback
> >     mechanism for which there is a single implementation.
> >
> >   - Tracking of LEPUBKEYHASH MSRs: KVM support.
>
> I don't doubt the justifications, just a bit unusual for a driver, but
> this driver is obviously a bit unusual.
>
> It will be interesting to see if the distros compile it in.

We (Fedora) plan to as soon as it is merged. I even plan to ask for a backport.

> Thank you for the clarifications, have a good weekend.
>
> Dr. Greg
>
> As always,
> Dr. Greg Wettstein, Ph.D    Worker / Principal Engineer
> IDfusion, LLC
> 4206 19th Ave N.            Specialists in SGX secured infrastructure.
> Fargo, ND  58102
> PH: 701-281-1686            CELL: 701-361-2319
> EMAIL: gw@idfusion.org
> ------------------------------------------------------------------------------
> "We are confronted with insurmountable opportunities."
>                                 -- Walt Kelly
>

