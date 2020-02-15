Return-Path: <SRS0=Eu7F=4D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F0CC7114E
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Feb 2020 18:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F48E2083B
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Feb 2020 18:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgBOSed (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 15 Feb 2020 13:34:33 -0500
Received: from wind.enjellic.com ([76.10.64.91]:57132 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgBOSed (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 15 Feb 2020 13:34:33 -0500
X-Greylist: delayed 1678 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Feb 2020 13:34:32 EST
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 01FI5tpD026045;
        Sat, 15 Feb 2020 12:05:55 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 01FI5sx3026044;
        Sat, 15 Feb 2020 12:05:54 -0600
Date:   Sat, 15 Feb 2020 12:05:54 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
Message-ID: <20200215180554.GA25482@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com> <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com> <d17c50a7-6900-731b-43a2-d6e49b8eb44d@fortanix.com> <20200213180737.GC18610@linux.intel.com> <a4d9a58d-6984-5894-f6c8-73f2b2b466aa@fortanix.com> <20200214171146.GD20690@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214171146.GD20690@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 15 Feb 2020 12:05:55 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 14, 2020 at 09:11:46AM -0800, Sean Christopherson wrote:

Good morning to everyone, I hope the weekend is going well.

> On Fri, Feb 14, 2020 at 10:24:10AM +0100, Jethro Beekman wrote:
> > On 2020-02-13 19:07, Sean Christopherson wrote:
> > > On Thu, Feb 13, 2020 at 02:59:52PM +0100, Jethro Beekman wrote:
> > >> On 2020-02-09 22:25, Jarkko Sakkinen wrote:
> > >>> +/**
> > >>> + * struct sgx_enclave_add_pages - parameter structure for the
> > >>> + *                                %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> > >>> + * @src:	start address for the page data
> > >>> + * @offset:	starting page offset
> > >>> + * @length:	length of the data (multiple of the page size)
> > >>> + * @secinfo:	address for the SECINFO data
> > >>> + * @flags:	page control flags
> > >>> + * @count:	number of bytes added (multiple of the page size)
> > >>> + */
> > >>> +struct sgx_enclave_add_pages {
> > >>> +	__u64	src;
> > >>> +	__u64	offset;
> > >>> +	__u64	length;
> > >>> +	__u64	secinfo;
> > >>> +	__u64	flags;
> > >>> +	__u64	count;
> > >>> +};
> > >>
> > >> Compared to the last time I looked at the patch set, this API
> > >> removes the ability to measure individual pages chunks. That is
> > >> not acceptable.
> > >
> > > Why is it not acceptable?  E.g. what specific use case do you
> > > have that _requires_ on measuring partial 4k pages of an
> > > enclave?
> >
> > The use case is someone gives me an enclave and I want to load
> > it. If I don't load it exactly as the enclave author specified,
> > the enclave hash will be different, and it won't work.

> And if our ABI says "thou shall measure in 4k chunks", then it's an
> invalid enclave if its author generated MRENCLAVE using a different
> granularity.

The enclave isn't invalid with respect to the hardware ISA or a
potential application or business case need.  It is only invalid with
respect to how a small group of kernel developers have decided that
runtime/application developers, and ultimately their users, should use
hardware that they have purchased and own.

Interestingly, the very antithesis of what started the open source
movement.

If Jethro/Fortanix have a business case for measuring partial pages,
which incidentally he may not be able to divulge at this time, it
seems the driver should support it if the hardware does.

An interesting phenomenon is evolving with respect to Linux.  With
secure boot, kernel module signing, and now the lockdown patches; the
major Linux vendors are in a position to use cryptographic constraints
to limit what the general Linux user community has available to it,
and particularly in the case of SGX, how the Linux application
eco-system can evolve.

I find this situation particularly fascinating.

Intel has choreographed 30+ million dollars of capital investment in
Fortanix in order to advance the development of an SGX software
eco-system.  Given who is authoring the driver, one would think that
the Fortanix engineering desires/needs would be given careful
consideration before the hardware capabilities are limited by the
driver ABI, an ABI that will be subsequently cryptographically
constrained from innovation.

My apologies in advance for any intended or perceived indelicacies on
these issues.

Have a good weekend.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC               SGX secured infrastructure and
4206 N. 19th Ave.           autonomously self-defensive platforms.
Fargo, ND  58102
PH: 701-281-1686            EMAIL: greg@idfusion.net
------------------------------------------------------------------------------
"Snow removal teaches all the important elements of succesful corporate
 politics:  1.) Be the first one to work.  2.) Always signal your
 intentions before moving.  3.) Be damn sure you're driving something
 big enough to deal with anything that decides not to get out of your way."
                                -- Dr. G.W. Wettstein
                                   Guerrilla Tactics for Corporate Survival
