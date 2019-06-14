Return-Path: <SRS0=rFfE=UN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_DR,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF0FC31E53
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 23:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E88421848
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 23:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbfFNXUY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Jun 2019 19:20:24 -0400
Received: from wind.enjellic.com ([76.10.64.91]:35396 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfFNXUX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Jun 2019 19:20:23 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x5ENJIrC021982;
        Fri, 14 Jun 2019 18:19:18 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x5ENJG6h021981;
        Fri, 14 Jun 2019 18:19:16 -0500
Date:   Fri, 14 Jun 2019 18:19:16 -0500
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
Message-ID: <20190614231916.GA21593@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <cover.1560131039.git.cedric.xing@intel.com> <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com> <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov> <20190611220243.GB3416@linux.intel.com> <8d99d8fb-a921-286a-8cf0-cd522e09b37c@tycho.nsa.gov> <20190614004600.GF18385@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614004600.GF18385@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Fri, 14 Jun 2019 18:19:18 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 13, 2019 at 05:46:00PM -0700, Sean Christopherson wrote:

Good afternoon, I hope the week is ending well for everyone.

> On Thu, Jun 13, 2019 at 01:02:17PM -0400, Stephen Smalley wrote:
> > Given the complexity tradeoff, what is the clear motivating
> > example for why #1 isn't the obvious choice? That the enclave
> > loader has no way of knowing a priori whether the enclave will
> > require W->X or WX?  But aren't we better off requiring enclaves
> > to be explicitly marked as needing such so that we can make a more
> > informed decision about whether to load them in the first place?

> Andy and/or Cedric, can you please weigh in with a concrete (and
> practical) use case that will break if we go with #1?  The auditing
> issues for #2/#3 are complex to say the least...

So we are back to choosing door 1, door 2 or door 3.

That brings us back to our previous e-mail, where we suggested that
the most fundamental question to answer with the LSM issue is how much
effective security is being purchased at what complexity cost.

We are practical guys at our company, we direct the development and
deployment of practical SGX systems, including an independent
implementation of SGX runtime/attestation/provisioning et.al.  Our
comments, for whatever they are worth, are meant to reflect the real
world deployment of this technology.

Lets start big picture.

One of the clients we are consulting with on this technology is
running well north of 1400 Linux systems.  Every one of which has
selinux=0 in /proc/cmdline and will do so until approximately the heat
death of the Universe.

Our AI LSM will use any SGX LSM driver hooks that eventuate from these
discussions, so we support the notion of the LSM getting a look at
permissions of executable code.  However, our client isn't unique in
their configuration choice, so we believe this fact calls the question
as to how much SGX specific complexity should be injected into the
LSM.

So, as we noted in our previous e-mail, there are only two relevant
security questions the LSM needs to answer:

1.) Should a page of memory with executable content be allowed into an
enclave?

2.) Should an enclave be allowed to possess one or more pages of
executable memory which will have WX permissions sometime during its
lifetime?

Sean is suggesting the strategy of an ioctl to call out pages that
conform to question 2 (EAUG'ed pages).  That doesn't seem like an
onerous requirement, since all of the current enclave loaders already
have all of the metadata infrastructure to map/load page ranges.  The
EAUG WX range would simply be another layout type that gets walked
over when the enclave image is built.

Given that, we were somewhat surprised to hear Sean say that he had
been advised that door 1 was a non-starter.  Presumably this was
because of the need to delineate a specific cohort of pages that will
be permitted WX.  If that is the case, the question that needs to be
called, as Stephen alludes to above, is whether or not WX privileges
should be considered a characterizing feature of the VMA that defines
an enclave rather then a per page attribute.

Do we realistically believe that an LSM will be implemented that
reacts differently when the 357th page of WX memory is added as
opposed to the first?  The operative security question is whether or
not the platform owner is willing to allow arbitrary executable code,
that they may have no visibility into, to be executed on their
platform.

We talk to people that, as a technology, SGX is about building
'security archipelagos', islands of trusted execution on potentially
multiple platforms that interact to deliver a service, all of which
consider their surrounding platforms and the network in between them
as adversarial.  This model is, by definition, adverserial to the
notion and function of the LSM.

With respect to SGX dynamic code loading, the future for security
concious architectures, will be to pull the code from remotely
attested repository servers over the network.  The only relevant
security question that can be answered is whether or not a platform
owner feels comfortable with that model.

Best wishes for a pleasant weekend to everyone.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"My spin on the meeting?  I lie somewhere between the individual who
 feels that we are all going to join hands and march forward carrying
 the organization into the information age and Dr. Wettstein.  Who
 feels that they are holding secret meetings at 6 o'clock in the
 morning plotting strategy on how to replace our system."
                                -- Paul S. Etzell, M.D.
                                   Medical Director, Roger Maris Cancer Center
