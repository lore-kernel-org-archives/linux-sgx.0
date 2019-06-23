Return-Path: <SRS0=71a1=UW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_DR,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21F2C4646B
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Jun 2019 17:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B504420656
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Jun 2019 17:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfFWRRY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Jun 2019 13:17:24 -0400
Received: from wind.enjellic.com ([76.10.64.91]:36178 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbfFWRRY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 23 Jun 2019 13:17:24 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x5NHGScC025697;
        Sun, 23 Jun 2019 12:16:28 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x5NHGQhc025696;
        Sun, 23 Jun 2019 12:16:26 -0500
Date:   Sun, 23 Jun 2019 12:16:26 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     James Morris <jmorris@namei.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, casey.schaufler@intel.com,
        william.c.roberts@intel.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [RFC PATCH v3 09/12] LSM: x86/sgx: Introduce ->enclave_load() hook for Intel SGX
Message-ID: <20190623171626.GA25683@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com> <20190617222438.2080-10-sean.j.christopherson@intel.com> <0c4f75a0ae2fdeee6db07f3a224918f321163d56.camel@linux.intel.com> <alpine.LRH.2.21.1906200702040.28119@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1906200702040.28119@namei.org>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sun, 23 Jun 2019 12:16:28 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 20, 2019 at 07:13:50AM +1000, James Morris wrote:

Good morning, I hope the weekend has been going well for everyone.

> On Wed, 19 Jun 2019, Jarkko Sakkinen wrote:
> 
> > Can LSM callbacks ever non-generic when it comes to hardware? This is
> > the very first time I ever see such callbacks being introduced.
> > 
> > I suspect that from maintainers perspective, accepting such changes for
> > Intel hardware, could open a pandoras box.

> If there's a major distro/userbase committing to ship with these
> hooks enabled via a supported in-tree LSM, the case for inclusion is
> clear.

I see that Jarkko responded down thread that there may be a major
distribution already committed to SGX specific LSM hooks.  My
apologies for providing these reflections if that is the case and
there is some type of 'deal' in place with respect to all of this.

> If the hooks could be generalized beyond just SGX, that would be
> ideal, but it's not clear if that's feasible.

We believe there is some degree of commonality that can be addressed
with respect to implementing LSM enforcement over SGX enclaves.

However, big picture, here is the challenge that we see with respect
to these conversations surrounding the integration of the SGX driver
with the LSM:

As a technology, SGX was designed to enable software to protect itself
from an adversarial operating system and hardware platform.  Given
that, if we are intellectually honest, how effective can the LSM/OS be
with respect to controlling the actions of an enclave?

Without question, being able to regulate and control which identities
can intersect to load executable content into an enclave is important.
All of the infrastructure appears to be already there to accomplish
that, given the default model of a shared library implementation of an
enclave and requiring the loader to mmap file backed TEXT pages RX.

The most relevant and important control with respect to whether or not
an enclave should be allowed to execute is evaluation of the
SIGSTRUCT.  Given the trajectory that platform security is on, SGX is
not going to be the last technology of its type nor the only
technology that makes use of cryptographically based code provenance.

As a result, if we are content with handing an opaque pointer of a
descriptive struture to an LSM routine, a generic hook that is tasked
with verifying code or execution environment provenance doesn't seem
like it would need to be technology specific nor controversial.

That leaves as the last thorny issue the question of dynamic
allocation of memory for executable content.  As we have stated
before, and at the outset of this note, from a security perspective
this is only, effectively, a binary question for the platform owner as
to whether or not the concept should be allowed.

A generic LSM hook, appropriately named, could execute that decision
without being SGX specific.  Arguably, the hook should be named to
indicate that it is seeking approval for allocating memory to be used
for anonymous executable content, since that is what it would be
effectively requesting approval for, in the case of SGX.

For completeness a third generic hook may be useful.  The purpose of
that hook would be to verify a block of memory as being
measured or signed for consideration as executable content.  Arguably
that will have utility far beyond SGX.

In the case of SGX it would address the issue as to whether or not a
block of executable content in untrusted space is eligible for
anonymous execution.  That may be a useful security measure in order
to provide some control over an enclave being used as a random
execution oracle.

It obviously has no security utility against the enclave author since,
as we have noted before, it is possible for the enclave author to
simply pull whatever code is desired over an encrypted network
connection.

> James Morris

Hopefully these comments are a useful basis for further discussion.

Best wishes for a productive week to everyone.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC
4206 N. 19th Ave.           Implementing measured information privacy
Fargo, ND  58102            and integrity architectures.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: gw@idfusion.org
------------------------------------------------------------------------------
"My thoughts on trusting Open-Source?  A quote I once saw said it
 best: 'Remember, Amateurs built the ark.  Professionals built the
 Titanic.'  Perhaps most significantly the ark was one guy, there were
 no doubt committees involved with the Titanic project."
                                -- Dr. G.W. Wettstein
                                   Resurrection
