Return-Path: <SRS0=GKs3=4G=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961D1C34026
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Feb 2020 10:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 738FE206E2
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Feb 2020 10:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgBRKnC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Feb 2020 05:43:02 -0500
Received: from wind.enjellic.com ([76.10.64.91]:57382 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgBRKnC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Feb 2020 05:43:02 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 01IAghfV014422;
        Tue, 18 Feb 2020 04:42:43 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 01IAghZ8014421;
        Tue, 18 Feb 2020 04:42:43 -0600
Date:   Tue, 18 Feb 2020 04:42:43 -0600
From:   "Dr. Greg Wettstein" <gw@idfusion.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20200218104243.GA13967@wind.enjellic.com>
Reply-To: "Dr. Greg Wettstein" <gw@idfusion.org>
References: <20191010113745.GA12842@linux.intel.com> <a657081e-cdaf-7c9d-2695-23c9c07bcfbf@fortanix.com> <20191011181550.GB30935@linux.intel.com> <8dc2ab24-baf1-5e57-3906-35e7286f7ffe@fortanix.com> <20191017175735.GD20903@linux.intel.com> <eaf66973-9c9b-b06c-4b96-134e41c18d80@fortanix.com> <20200215072406.GA9958@linux.intel.com> <ed49f988-e4e5-b2b9-0108-f489e9b5f449@fortanix.com> <20200217185512.GA7677@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217185512.GA7677@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 18 Feb 2020 04:42:44 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Feb 17, 2020 at 08:55:26PM +0200, Jarkko Sakkinen wrote:

Good morning, I hope the week is starting well for everyone.

> On Mon, Feb 17, 2020 at 09:52:25AM +0100, Jethro Beekman wrote:
> > On 2020-02-15 08:24, Jarkko Sakkinen wrote:
> > > On Thu, Feb 13, 2020 at 03:10:24PM +0100, Jethro Beekman wrote:
> > >>>> There are other scenarios where it's not just the permissions on
> > >>>> /dev/sgx/enclave that are the problem but using the filesystem in general
> > >>>> that is. Maybe you've used seccomp to disable file operations, etc.
> > >>>
> > >>> Andy and Jarkko, thoughts?
> > >>
> > >> Folks, any more thoughts on how to resolve the issue that you need to
> > >> call open() for every enclave?
> > > 
> > > Why is it an issue?
> > 
> > Already discussed in https://www.spinics.net/lists/linux-sgx/msg02075.html

I believe an accurate summary of Dr. Beekman's concerns are as
follows:

1.) He envisions a need for an enclave orchestrator that uses root
privileges to open the SGX driver device and then drop privileges,
presumably in a permanent fashion.  The orchestrator would then use
the filehandle to load and initialize multiple enclaves on request.

2.) The enclave orchestrator may be run in an environment that has
SECCOMP limitations on the ability to conduct filesystem operations.

> Not everyone has to have access to open /dev/sgx/enclave in order to
> use enclaves.

That depends on the architecture of the runtime.

The Intel PSW has a model where the AESM daemon orchestrates
activities for applications that wish to use enclaves.

Our Secure Runtime Development Environment (SRDE), on the other hand,
uses a model where each application independently manages its use of
enclaves.  In our model, the SGX driver needs to be accessible by
whatever privilege level an application chooses to run at.

As a result of this model, our SRDE has around an order of magnitude
less complexity then the AESM model and virtually no external
dependencies.  At last count the AESM depends on about 35 separate
shared library systems.

Our model allows us to build applications that are statically linked
and completely self-contained.  A concept of reasonable utility for
containerized environments and embedded systems.  We also avoid C++
that allows us to build MUSL based security stacks.

> It is as much a problem as for practically any driver that provides
> devices for some use.

The only customers of this driver are the runtime developers and that
is currently an extremely limited spectrum of users.

I will concede that I don't understand the SECCOMP issue.  Jethro may
or may not be able to discuss an architecture that would not have
basic filesystem operations available to it.

The fundamental issue, that there appears to be a reluctance to
discuss, is that DAC/MAC controls are not relevant to SGX,
particularly SGX2 based systems, which is what most of this stuff
will be running on.

> /Jarkko

Have a good day.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D    Worker / Principal Engineer
IDfusion, LLC
4206 19th Ave N.            Specialists in SGX secured infrastructure.
Fargo, ND  58102
PH: 701-281-1686            CELL: 701-361-2319
EMAIL: gw@idfusion.org
------------------------------------------------------------------------------
"... remember that innovation is saying 'no' to 1000 things."
                                -- Moxie Marlinspike
