Return-Path: <SRS0=k8LC=6S=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F75BC3A5A9
	for <linux-sgx@archiver.kernel.org>; Mon,  4 May 2020 09:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85D9C206D9
	for <linux-sgx@archiver.kernel.org>; Mon,  4 May 2020 09:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgEDJfD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 May 2020 05:35:03 -0400
Received: from wind.enjellic.com ([76.10.64.91]:42948 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726625AbgEDJfD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 May 2020 05:35:03 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0449YXRD005741;
        Mon, 4 May 2020 04:34:33 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0449YWfb005740;
        Mon, 4 May 2020 04:34:32 -0500
Date:   Mon, 4 May 2020 04:34:32 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200504093432.GA5382@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200502230510.GA28470@wind.enjellic.com> <BD424C59-0B02-451D-8DF0-74F92292A87C@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD424C59-0B02-451D-8DF0-74F92292A87C@amacapital.net>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Mon, 04 May 2020 04:34:33 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, May 02, 2020 at 05:48:30PM -0700, Andy Lutomirski wrote:

Good morning, I hope the week is starting well for everyone.

> > On May 2, 2020, at 4:05 PM, Dr. Greg <greg@enjellic.com> wrote:
> > In a nutshell, the driver needs our patch that implements
> > cryptographic policy management.
> > 
> > A patch that:
> > 
> > 1.) Does not change the default behavior of the driver.
> > 
> > 2.) Implements capabilities that are consistent with what the hardware
> > was designed to do, but only at the discretion of the platform owner.
> > 
> > 3.) Has no impact on the driver architecture.
> > 
> > The only consumer for this driver are SGX runtimes.  To our knowledge,
> > there exist only two complete runtime implementations, Intel's and
> > ours.  It us unclear why our approach to the use of the technology
> > should be discriminated against when it doesn't impact the other user
> > community.

> Can you clarify how exactly this patch set discriminates against
> your stack?

The driver has no provisions for implementing cryptographically based
SGX policy management of any type.

Our stack is extremely lightweight with no external dependencies and
is used in privacy and security sensitive applications, including
financial services of certain types.  There is a desire in this, and
other venues, to use cloud and edge resources with a strong guarantee
that the platforms have only had a known set of behaviors.  The
current DAC based controls in the driver are insufficient to provide
those guarantees.

I believe I have discussed our use of SGX previously.  In a nutshell,
we use SGX based modeling engines to supervise kernel based behavioral
namespaces, one enclave per namespace.  The closest equivalent work
that we have seen may be the IPE architecture advanced by Deven Bowers
at Microsoft but we address a number of issues that work does not,
including non-kernel based behavioral supervision.

We support the concern over hardware locked platforms and do not
disagree with the driver not supporting those platforms.  That being
said, there is no technical rationale for not providing cryptographic
policy management on FLC based platforms, as I believe our patch
demonstrates.

Best wishes for a productive week.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Artisans in autonomously
Enjellic Systems Development, LLC     self-defensive platforms.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Can't they?

 A 64bit number incremented every millisecond can grow for half a
 billion years.  As far as I'm concerned, that is forever."
                                -- Neil Brown
                                   linux-raid
