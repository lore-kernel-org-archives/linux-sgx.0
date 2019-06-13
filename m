Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2717C31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B35E920644
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403982AbfFMQgg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:36:36 -0400
Received: from wind.enjellic.com ([76.10.64.91]:35228 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730675AbfFMH3B (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 03:29:01 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x5D7PfTQ001652;
        Thu, 13 Jun 2019 02:25:41 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x5D7PdX1001651;
        Thu, 13 Jun 2019 02:25:39 -0500
Date:   Thu, 13 Jun 2019 02:25:39 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Cedric Xing <cedric.xing@intel.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        jarkko.sakkinen@linux.intel.com, luto@kernel.org,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        eparis@parisplace.org, jethro@fortanix.com, dave.hansen@intel.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, nhorman@redhat.com,
        pmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, kai.huang@intel.com,
        rientjes@google.com, william.c.roberts@intel.com,
        philip.b.tricca@intel.com
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in SELinux
Message-ID: <20190613072539.GA1499@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <cover.1560131039.git.cedric.xing@intel.com> <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com> <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov> <20190611220243.GB3416@linux.intel.com> <20190612093221.GA24188@wind.enjellic.com> <20190612142557.GB20308@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612142557.GB20308@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 13 Jun 2019 02:25:42 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 12, 2019 at 07:25:57AM -0700, Sean Christopherson wrote:

Good morning, we hope the week continues to go well for everyone.

> On Wed, Jun 12, 2019 at 04:32:21AM -0500, Dr. Greg wrote:
> > With SGX2 we will, by necessity, have to admit the notion that a
> > platform owner will not have any effective visibility into code that
> > is loaded and executed, since it can come in over a secured network
> > connection in an enclave security context.  This advocates for the
> > simplest approach possible to providing some type of regulation to any
> > form of WX page access.

> I believe we're all on the same page in the sense that we all want
> the "simplest approach possible", but there's a sliding scale of
> complexity between the kernel and userspace.  We can make life
> simple for userspace at the cost of additional complexity in the
> kernel, and vice versa.  The disagreement is over where to shove the
> extra complexity.

Yes, we are certainly cognizant of and sympathetic to the engineering
tensions involved.

The purpose of our e-mail was to leaven the discussion with the notion
that the most important question is how much complexity should be
shoved in either direction.  With respect to SGX as a technology, the
most important engineering metric is how much effective security is
actually being achieved.

Given an admission that enclave dynamic memory management (EDMM/SGX2)
is the goal in all of this, there are only two effective security
questions to be answered:

1.) Should a corpus of known memory with executable permissions be
copied into to an enclave.

2.) Should a corpus of executable memory with unknown content be
available to an enclave.

Given the functionality that SGX implements, both questions ultimately
devolve to whether or not a platform owner trusts an enclave author.
Security relevant trust is conveyed through cryptographically mediated
mechanisms.

The decision has been made to take full hardware mediated
cryptographic trust off the table for the mainstream Linux
implementation.  Given that, the most pragmatic engineering solution
would seem to be to implement the least complex implementation that
allows a platform owner to answer the two questions above.

See below.

> > Current state of the art, and there doesn't appear to be a reason to
> > change this, is to package an enclave in the form of an ELF shared
> > library.  It seems straight forward to inherit and act on page
> > privileges from the privileges specified on the ELF sections that are
> > loaded.  Loaders will have a file descriptor available so an mmap of
> > the incoming page with the specified privileges should trigger the
> > required LSM interventions and tie them to a specific enclave.
> > 
> > The current enclave 'standard' also uses layout metadata, stored in a
> > special .notes section of the shared image, to direct a loader with
> > respect to construction of the enclave stack, heap, TCS and other
> > miscellaneous regions not directly coded by the ELF TEXT sections.  It
> > seems straight forward to extend this paradigm to declare region(s) of
> > an enclave that are eligible to be generated at runtime (EAUG'ed) with
> > the RWX protections needed to support dynamically loaded code.
> > 
> > If an enclave wishes to support this functionality, it would seem
> > straight forward to require an enclave to provide a single zero page
> > which the loader will mmap with those protections in order to trigger
> > the desired LSM checks against that specific enclave.

> This is effectively #1, e.g. would require userspace to pre-declare its
> intent to make regions W->X.

Yes, we understood that when we wrote our original e-mail.

This model effectively allows the two relevant security questions to
be easily answered and is most consistent with current enclave
formats, software practices and runtimes.  It is also largely
consistent with existing LSM practices.

There hasn't been any discussion with respect to backports of this
driver but we believe it it safe to conclude that the industry is
going to be at least two years away from any type of realistic
deployments of this driver.  By that time there will be over a half a
decade of software deployment of existing API's and enclave formats.

Expecting a 'flag day' to be successful would seem to be contrary to
all known history of software practice and would thus disadvantage
Linux as an effective platform for this technology.

Best wishes for a productive remainder of the week to everyone.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686            EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Sometimes I sing and dance around the house in my underwear,
 doesn't make me Madonna, never will.
                                -- Cyn
                                   Working Girl
