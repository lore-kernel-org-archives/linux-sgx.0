Return-Path: <SRS0=TAlT=6Q=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FD5C3A5A9
	for <linux-sgx@archiver.kernel.org>; Sat,  2 May 2020 23:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29DEE2072E
	for <linux-sgx@archiver.kernel.org>; Sat,  2 May 2020 23:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgEBXFz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 2 May 2020 19:05:55 -0400
Received: from wind.enjellic.com ([76.10.64.91]:42802 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbgEBXFz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 2 May 2020 19:05:55 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 042N5BfG028543;
        Sat, 2 May 2020 18:05:11 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 042N5AKR028542;
        Sat, 2 May 2020 18:05:10 -0500
Date:   Sat, 2 May 2020 18:05:10 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200502230510.GA28470@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com> <20200426165753.GA11046@wind.enjellic.com> <20200429052329.GD8452@linux.intel.com> <20200429151459.GC15992@linux.intel.com> <20200430035850.GC31820@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430035850.GC31820@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 02 May 2020 18:05:11 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 30, 2020 at 06:59:11AM +0300, Jarkko Sakkinen wrote:

Good afternoon, I hope the weekend is going well for everyone.

> On Wed, Apr 29, 2020 at 08:14:59AM -0700, Sean Christopherson wrote:
> > On Wed, Apr 29, 2020 at 08:23:29AM +0300, Jarkko Sakkinen wrote:
> > > On Sun, Apr 26, 2020 at 11:57:53AM -0500, Dr. Greg wrote:
> > > > On Wed, Apr 22, 2020 at 12:52:56AM +0300, Jarkko Sakkinen wrote:
> > >
> > > > > The current implementation requires that the firmware sets
> > > > > IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately
> > > > > the kernel can decide what enclaves it wants run. The
> > > > > implementation does not create any bottlenecks to support
> > > > > read-only MSRs later on.
> > >
> > > > It seems highly unlikely that a driver implementation with any type of
> > > > support for read-only launch control registers would ever get into the
> > > > kernel.  All one needs to do is review the conversations that Matthew
> > > > Garrett's lockdown patches engender to get a sense of that, ie:
> > > > 
> > > > https://lwn.net/Articles/818277/
> > > 
> > > We do not require read-only MSRs.
> > 
> > Greg is pointing out the opposite, that supporting read-only MSRs is highly
> > unlikely to ever be supported in the mainline kernel.

> In a nutshell, what is wrong in the current code changes and what
> *exactly* should we change? This is way too high level at the moment
> at least for my limited brain capacity.

In a nutshell, the driver needs our patch that implements
cryptographic policy management.

A patch that:

1.) Does not change the default behavior of the driver.

2.) Implements capabilities that are consistent with what the hardware
was designed to do, but only at the discretion of the platform owner.

3.) Has no impact on the driver architecture.

The only consumer for this driver are SGX runtimes.  To our knowledge,
there exist only two complete runtime implementations, Intel's and
ours.  It us unclear why our approach to the use of the technology
should be discriminated against when it doesn't impact the other user
community.

The Linux kernel that I have worked on and supported since 1992 has
always focused on technical rationale and meritocracy rather then
politics.  We would be interested in why our proposal for the driver
fails on the former grounds rather then the latter.

> /Jarkko

Best wishes for a productive week.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Artisans in autonomously
Enjellic Systems Development, LLC     self-defensive IOT platforms
4206 N. 19th Ave.                     and edge devices.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"The best way to predict the future is to invent it."
                                -- Alan Kay
