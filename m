Return-Path: <SRS0=ZtyI=YG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C57CC4360C
	for <linux-sgx@archiver.kernel.org>; Sun, 13 Oct 2019 15:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 175662085B
	for <linux-sgx@archiver.kernel.org>; Sun, 13 Oct 2019 15:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfJMPPk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 13 Oct 2019 11:15:40 -0400
Received: from wind.enjellic.com ([76.10.64.91]:45132 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbfJMPPk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 13 Oct 2019 11:15:40 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x9DFFPph013241;
        Sun, 13 Oct 2019 10:15:25 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x9DFFPcP013240;
        Sun, 13 Oct 2019 10:15:25 -0500
Date:   Sun, 13 Oct 2019 10:15:25 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH for_v23 0/7] x86/sgx: Improve add pages ioctl
Message-ID: <20191013151524.GA13191@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20191009044241.3591-1-sean.j.christopherson@intel.com> <op.z9fc9yu4wjvjmi@hhuan26-mobl.amr.corp.intel.com> <20191011143725.GA30935@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011143725.GA30935@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sun, 13 Oct 2019 10:15:25 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Oct 11, 2019 at 07:37:25AM -0700, Sean Christopherson wrote:

> +cc Jethro and Greg

Good morning, I hope everyone is having or has had a pleasant weekend.

> On Wed, Oct 09, 2019 at 10:28:36PM -0500, Haitao Huang wrote:
> > On Tue, 08 Oct 2019 23:42:34 -0500, Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > 
> > >Enhance the SGX_IOC_ENCLAVE_ADD_PAGE{S} ioctl so that userspace can add
> > >multiple pages to an enclave in a single syscall.  Also provide a flag
> > >that allows replicating a single source page to multiple target pages so
> > >that userspace doesn't need to allocate a giant chunk of memory when
> > >initializing things like the enlave's .bss, heap, etc...
> > >
> > >People that actually develop runtimes, please weigh in.  Jarkko also
> > >suggested going with a fully flexible ioctl, e.g. essentially creating an
> > >array of the existing struct so that mrmask and/or secinfo can be unique
> > >per page.  AFAICT that's overkill and more cumbersome to use as it forces
> > >userspace to allocate the full array.  My understanding is that the
> > >majority of enclaves will have contiguous blocks of pages with identical
> > >mrmask and secinfo, e.g. code segments, ro data, etc..., thus the less
> > >flexible but easier-in-theory to use approach proposed here.
> > >
> > We think using the same mask for all pages (solution in this patch set) is
> > reasonable. Although it seems odd that all pages would apply the same mask,
> > this allows enough flexibility we can foresee.

> Jethro, last time I brought this up you mentioned that it'd be nice to
> have an array of pages[*] instead of the repeat-for-each-page concept.
> Is there a use case where taking an array would provide a substantial
> benefit to userspace?  Taking an array has downsides, and I think would
> actually be worse for the vast majority of use cases.
>
> ... [ Example code removed ] ...
>
> The loop is mildly annoying, but the real killer is the array allocation.
> SECINFO is 64 bytes, which means each entry is 88 bytes or more, e.g. around
> 180kb to add an 8mb chunk of .bss or heap.
> 
> My intention is/was for the multi-page add to be an opportunistic
> optimization, not a way to add all enclave pages in a single ioctl.
> 
> [*] https://patchwork.kernel.org/patch/10977721/#22699225

The simpler the better from our perspective.

We would use the 'one-shot' method to initialize a block of pages with
a set of common characteristics.  Essentially constructing an image of
enclave page characteristics in userspace in order to load an enclave
image isn't something that we would envision doing.

> > Another option acceptable to us (Intel SGX runtime) is to change it to a
> > flag and have bit zero define whether the whole page is measured via
> > EEXTEND. This is simpler and allows other bits reserved for future usages.
> > However, it would fail any SGX runtime that is measuring partial page for
> > optimization purposes.

> This can be an orthogonal change.  I agree it makes sense to drop
> mrmask and instead have a SGX_ADD_PAGES_MEASURED flag to cover the
> whole page.  Hiding the 256-byte granualarity from userspace is a
> good idea as it's not intrinsically tied to the SGX architecture and
> exists only because of latency requirements.  And most of the kernel
> interfaces work on 4k granularity.

Specifying the ability to measure an entire page is also a straight
forward simplicity optimization that we would embrace.

Have a good week.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC               SGX secured infrastructure and
4206 N. 19th Ave.           autonomously self-defensive platforms.
Fargo, ND  58102
PH: 701-281-1686            EMAIL: greg@idfusion.net
------------------------------------------------------------------------------
"Thank heaven for startups; without them we'd never have any
 advances."
                                -- Seymour Cray
