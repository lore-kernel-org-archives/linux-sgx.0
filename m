Return-Path: <SRS0=duYL=EN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA43C388F7
	for <linux-sgx@archiver.kernel.org>; Sat,  7 Nov 2020 15:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31B11206DB
	for <linux-sgx@archiver.kernel.org>; Sat,  7 Nov 2020 15:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgKGP2a (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 7 Nov 2020 10:28:30 -0500
Received: from wind.enjellic.com ([76.10.64.91]:59914 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgKGP2a (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 7 Nov 2020 10:28:30 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0A7FRxAi029719;
        Sat, 7 Nov 2020 09:27:59 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0A7FRwYv029718;
        Sat, 7 Nov 2020 09:27:58 -0600
Date:   Sat, 7 Nov 2020 09:27:58 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v40 10/24] mm: Add 'mprotect' hook to struct vm_operations_struct
Message-ID: <20201107152758.GB29530@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com> <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com> <20201106174359.GA24109@wind.enjellic.com> <20201106211311.GT17076@casper.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106211311.GT17076@casper.infradead.org>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 07 Nov 2020 09:28:00 -0600 (CST)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 06, 2020 at 09:13:11PM +0000, Matthew Wilcox wrote:
> On Fri, Nov 06, 2020 at 11:43:59AM -0600, Dr. Greg wrote:
> > The 900 pound primate in the room, that no one is acknowledging, is
> > that this technology was designed to not allow the operating system to
> > have any control over what it is doing.  In the mindset of kernel
> > developers, the operating system is the absolute authority on
> > security, so we find ourselves in a situation where the kernel needs
> > to try and work around this fact so any solutions will be imperfect at
> > best.
> > 
> > As I've noted before, this is actually a primary objective of enclave
> > authors, since one of the desires for 'Confidential Computing' is to
> > hide things like proprietary algorithms from the platform owners.  I
> > think the driver needs to acknowledge this fact and equip platform
> > owners with the simplest and most effective security solutions that
> > are available.

> Or we need to not merge "technology" that subverts the owner of the
> hardware.  Remember: root kit authors are inventive buggers.

That will be an interesting philosophical argument for Linux moving
forward.  I've often stated that there is going to be a natural
political tension between the objectives of open-source and advances
in platform security.  By definition, advancing the latter will result
in technology that contrains what can be done with a platform.

It may have made more sense for the SGX driver to be mainline when the
technology was going to be ubiquitous.  Given the decision by Intel to
monetize the platform, by limiting its implementation to high end
server platforms, the case could be made that it is a driver best
supported by the distributions or cloud providers.

I'm neither for or against inclusion, I'm simply advocating that we
make informed decisions on the driver implementation that benefits the
user community.  FWIW, based on knowledge that has come from building
application stacks on top of the technology for a half decade now.

Have a good weekend.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Atilla The Hun's Maxim: If you're going to rape, pillage and burn, be sure
 to do things in that order."
                                -- P.J. Plauger
                                   Programming On Purpose
