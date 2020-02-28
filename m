Return-Path: <SRS0=4X3U=4Q=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3747C3F2CD
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Feb 2020 22:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A02D22469F
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Feb 2020 22:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgB1WEx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Feb 2020 17:04:53 -0500
Received: from wind.enjellic.com ([76.10.64.91]:58694 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgB1WEx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 28 Feb 2020 17:04:53 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 01SM2DVg008025;
        Fri, 28 Feb 2020 16:02:13 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 01SM2CkT008024;
        Fri, 28 Feb 2020 16:02:12 -0600
Date:   Fri, 28 Feb 2020 16:02:12 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v27 00/22] Intel SGX foundations
Message-ID: <20200228220212.GA7978@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200223172559.6912-1-jarkko.sakkinen@linux.intel.com> <20200224100932.GA15526@wind.enjellic.com> <20200224211317.GJ29865@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224211317.GJ29865@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Fri, 28 Feb 2020 16:02:13 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Feb 24, 2020 at 01:13:17PM -0800, Sean Christopherson wrote:

Hi, I hope the week is ending well for everyone.

> On Mon, Feb 24, 2020 at 04:09:32AM -0600, Dr. Greg wrote:
> > On Sun, Feb 23, 2020 at 07:25:37PM +0200, Jarkko Sakkinen wrote:
> > 
> > Good morning, I hope the week is starting well for everyone.
> > 
> > > Intel(R) SGX is a set of CPU instructions that can be used by
> > > applications to set aside private regions of code and data. The code
> > > outside the enclave is disallowed to access the memory inside the
> > > enclave by the CPU access control.
> > 
> > Do we misinterpret or is the driver not capable of being built in
> > modular form?

> Correct.

That is what we had concluded, thanks for the verification.

> > If not, it would appear that this functionality has been lost since
> > version 19 of the driver, admittedly some time ago.

> It was removed in v20[*].

We didn't see documentation of this in any of the v20 release bullet
points, hence the question.

> > > * Allow the driver to be compiled as a module now that it no code is using
> > >   its routines and it only uses exported symbols. Now the driver is
> > >   essentially just a thin ioctl layer.

> > Not having the driver available in modular form obviously makes
> > work on the driver a bit more cumbersome.

> Heh, depends on your development environment, e.g. I do 99% of my
> testing in a VM with a very minimal kernel that even an anemic
> system can incrementally build in a handful of seconds.

Lacking a collection of big beefy development machines with 256+
gigabytes of RAM isn't the challenge, rebooting to test functionality
on the physical hardware is what is a bit of a nuisance.

> > I'm assuming that the lack of module support is secondary to some
> > innate architectural issues with the driver?

> As of today, the only part of the driver that can be extracted into
> a module is effectively the ioctl() handlers, i.e. a module would
> just be an ioctl() wrapper around a bunch of in-kernel
> functionality.  At that point, building the "driver" as a module
> doesn't provide any novel benefit, e.g.  very little memory
> footprint savings, reloading the module wouldn't "fix" any bugs with
> EPC management, SGX can still be forcefully disabled via kernel
> parameter, etc...  And on the flip side, allowing it to be a module
> would require exporting a non-trivial number of APIs that really
> shouldn't be exposed outside of the SGX subsystem.
>
> As for why things are baked into the kernel:
> 
>   - EPC management: support for future enhancements (KVM and EPC cgroup).
> 
>   - Reclaim: don't add a unnecessary infrastructure, i.e. avoid a callback
>     mechanism for which there is a single implementation.
> 
>   - Tracking of LEPUBKEYHASH MSRs: KVM support.

I don't doubt the justifications, just a bit unusual for a driver, but
this driver is obviously a bit unusual.

It will be interesting to see if the distros compile it in.

Thank you for the clarifications, have a good weekend.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D    Worker / Principal Engineer
IDfusion, LLC
4206 19th Ave N.            Specialists in SGX secured infrastructure.
Fargo, ND  58102
PH: 701-281-1686            CELL: 701-361-2319
EMAIL: gw@idfusion.org
------------------------------------------------------------------------------
"We are confronted with insurmountable opportunities."
                                -- Walt Kelly
