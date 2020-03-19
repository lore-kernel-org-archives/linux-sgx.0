Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E63C4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 18:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18AD420789
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 18:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgCSSXA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 14:23:00 -0400
Received: from wind.enjellic.com ([76.10.64.91]:60700 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCSSXA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 14:23:00 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 02JIMKml023895;
        Thu, 19 Mar 2020 13:22:20 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 02JIMKkc023894;
        Thu, 19 Mar 2020 13:22:20 -0500
Date:   Thu, 19 Mar 2020 13:22:20 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>
Subject: Re: [PATCH v28 11/22] x86/sgx: Linux Enclave Driver
Message-ID: <20200319182219.GB22995@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com> <20200303233609.713348-12-jarkko.sakkinen@linux.intel.com> <20200305174015.GJ11500@linux.intel.com> <e445c2f8-fddd-5740-0e26-a03e023918bf@fortanix.com> <20200306190003.GF7472@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306190003.GF7472@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 19 Mar 2020 13:22:21 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 06, 2020 at 09:00:03PM +0200, Jarkko Sakkinen wrote:

Good afternoon, I hope the day is going well for everyone.

> > >> +/**
> > >> + * struct sgx_enclave_create - parameter structure for the
> > >> + *                             %SGX_IOC_ENCLAVE_CREATE ioctl
> > >> + * @src:	address for the SECS page data
> > >> + */
> > >> +struct sgx_enclave_create  {
> > >> +	__u64	src;
> > > 
> > > Would it make sense to add reserved fields to the structs so that new
> > > features can be added in a backwards compatible way?  E.g. if we want to
> > > allow userspace to control the backing store by passing in a file
> > > descriptor ENCLAVE_CREATE.

> > Reserving space for future fields is not necessary because the
> > size of the struct is encoded in the ioctl number. The kernel can
> > use this to differentiate between different call versions from
> > userspace.

> Sure but I still would never change the signature once a ioctl is
> added.

These reflections cause me to call, once again, what will be an
unpopular question, but if we pride ourselves on intellectual honesty
in our engineering practices we need to address it.

If we are locking ioctl's and ABI's down, then we need to address,
before the driver goes in, how we are going to handle support for
those of us that have engineering needs around launch token
technology.

On an FLC (unlocked) platform, which is the only thing the driver will
initialize on, there is no reason not to preserve the initialization
IOCTL argument structure that accepts a pointer to a launch token or
to disallow an enclave that has the attribute bit/mask set that allows
the enclave to have access to the launch key.  When presented with an
enclave with the launch bit set the driver can simply set the launch
control registers to the MRSIGNER value of that enclave.

It is a straight forward process to provide a root based mechanism
that allows the owner of the platform to control that behavior, if
there are concerns about how the platform is to be used, much like
what is currently being done with access to the provision key.

The ideological purity statement is made by the decision to limit what
hardware the driver will run on.  Once that statement is made, and the
driver firmly implements that decision, the owner of that platform
should be able to decide how they want to use and implement the
technology from there.

Unless someone else chirps up there are essentially only two complete
runtimes that are concerned with this issue.  Intel can enforce
enhanced ideological purity, if they desire, by simply disallowing
anyone to pass a non-null EINIT structure pointer through their
runtime to the driver, which leaves us to implement the behavior we
want without ABI concerns.

There is a fairly fundamental question here regarding 'software
freedom', maybe Jonathan Corbet and company will even pick up on
it.... :-)

> /Jarkko

Hopefully all of this makes sense and is reasonable.

Have a good remainder of the week, wherever you happen to be locked in
at.

We now return you to your regularly scheduled programming on the
register dance surrounding enclave entry.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      SGX secured infrastructure and
Enjellic Systems Development, LLC     autonomously self-defensive
4206 N. 19th Ave.                     platforms.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"More people are killed every year by pigs than by sharks, which shows
 you how good we are at evaluating risk."
                                -- Bruce Schneier
                                   Beyond Fear
