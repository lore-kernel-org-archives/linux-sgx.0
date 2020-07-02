Return-Path: <SRS0=iBWu=AN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FFFC433E2
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jul 2020 21:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E7D20936
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jul 2020 21:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgGBVEm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Jul 2020 17:04:42 -0400
Received: from wind.enjellic.com ([76.10.64.91]:48392 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgGBVEm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Jul 2020 17:04:42 -0400
X-Greylist: delayed 1010 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2020 17:04:41 EDT
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 062KlAFL022258;
        Thu, 2 Jul 2020 15:47:10 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 062KlAIo022257;
        Thu, 2 Jul 2020 15:47:10 -0500
Date:   Thu, 2 Jul 2020 15:47:10 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 12/21] x86/sgx: Allow a limited use of ATTRIBUTE.PROVISIONKEY for attestation
Message-ID: <20200702204709.GA21504@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com> <20200617220844.57423-13-jarkko.sakkinen@linux.intel.com> <20200629160242.GB32176@zn.tnic> <20200629220400.GI12312@linux.intel.com> <20200630084956.GB1093@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630084956.GB1093@zn.tnic>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 02 Jul 2020 15:47:11 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Good afternoon, I hope the week is progressing productively to an end
for everyone.

I think it was almost two months ago now that Thomas Gleixner
indicated that security and privacy issues that we were raising with
respect to this driver, with what we believe is legitimate domain
expertise, threatened the upstreaming of the driver.  I think the case
can be made that those claims were somewhat specious given a fast
forward to today and the continued uncertainty regarding the
architecture of this driver.

So I will take that risk once again in order to provide some context
for this thread.

On Tue, Jun 30, 2020 at 10:49:56AM +0200, Borislav Petkov wrote:
> On Mon, Jun 29, 2020 at 03:04:00PM -0700, Sean Christopherson wrote:
> > > I don't see this acronym resolved anywhere in the whole patchset.
> > 
> > Quoting Enclave.

> Yah, pls add it somewhere.

For the benefit of everyone not deeply involved with this and perhaps
something that Jarkko can cut and paste if he desires.

The Quoting Enclave (QE) is the trusted endpoint that is responsible
for signing the report of an enclave's initialized status on a
platform.

In Enhanced Privacy ID (EPID) based attestation, the QE is the
custodian of one of the private EPID group keys that is provisioned to
the platform by the Intel Attestation Service (IAS).  The quoting
enclave generates a signature over the attesting enclave's report
structure using that key.  The IAS uses its public copy of the group
key to verify that the signature is from a trusted endpoint running on
a member of the group.

The EPID provisioning process 'trusts' that the platform, to which the
private group key is being delegated to, is a known Intel platform by
virtue of the fact that the Platform Certification Enclave (PCE) is
able to generate an identifier that could only be generated by having
access to a specific symmetric encryption key.  A key that is
available only to enclaves that have been initialized with the
PROVISION_KEY attribute bit.

The QE encrypts the private group key using a signer specific
(MRSIGNER) symmetric encryption key that only the QE can generate
while in a trusted initialization state.  That provides a mechanisum
for persisting this chain of trust outside the context of execution of
the QE.

Things are slightly different from a mechanistic perspective when the
Data Center Attestation Protocol (DCAP) is being used, but
conceptually the same.  In that attestation variant, the QE carries
the PROVISION_KEY attribute so that it can certify that the report
signature, generated with the Elliptic Curve Digital Signature
Algorithm (ECDSA) rather then EPID, is from a known platform.

> > /dev/sgx/provision is root-only by default, the expectation is
> > that the admin will configure the system to grant only specific
> > enclaves access to the PROVISION_KEY.

> Uuh, I don't like "the expectation is" - the reality happens to turn
> differently, more often than not.

Indeed, which is why we have consistently maintained that the platform
owner should be allowed to use cryptographic access controls over
which enclaves can possess the PROVISION_KEY attribute.

Given the security threat on a platform that is capable of supporting
Enclave Dynamic Memory Management (EDMM), the ability to initialize an
enclave is also a legitimate candidate for cryptographic access
control.

We can bikeshed the significance of these issues all day, but for the
record, access to the PROVISION_KEY allows platforms to be absolutely
and precisely fingerprinted for their entire lifespan.

Initialized enclaves on an EDMM capable platform have the ability to
execute arbitrary code, over which the kernel security infrastructure
has no visibility into or control over.

There is little doubt that EDMM will be a mainstay of the Confidential
Computing Initiative (CCI), which is the target of this driver.  A
review of the archives will indicate that RedHat/IBM has already
confirmed that their candidate for this infrastructure (Enarx)
requires EDMM.

To refresh everyone further, the last version of the SFLC patches that
we proposed, allows a platform owner to run the driver in a default
mode, which uses the proposed DAC controls over all of this or to opt
for stronger cryptographic controls.  The approach that we took has
virtually no impact on the architecture and footprint of the driver.

> > In this series, access is fairly binary, i.e. there's no
> > additional kernel infrastructure to help userspace make
> > per-enclave decisions.  There have been more than a few proposals
> > on how to extend the kernel to help provide better granularity,
> > e.g. LSM hooks, but it was generally agreed to punt that stuff to
> > post-upstreaming to keep things "simple" once we went far enough
> > down various paths to ensure we weren't painting ourselves into a
> > corner.

> So this all sounds to me like we should not upstream
> /dev/sgx/provision now but delay it until the infrastructure for
> that has been made more concrete. We can always add it
> then. Changing it after the fact - if we have to and for whatever
> reason - would be a lot harder for a user-visible interface which
> someone has started using already.
>
> So I'd leave that out from the initial patchset.

Without access to the PROVISION_KEY attribute, the two standard
mechanisms for attestation will not function, the technology is
arguably useless for its intended purposes without attestation.

Once again, I will leave it to community bike shedding as to whether
or not Linux wants the ability to support unfettered deterministic
platform fingerprinting that can be conducted for the physical
lifespan of the platform.

Once again, for the record, our approach affords compatibility with
the now 6+ year old out-of-tree user interface, without requiring its
use.  I would argue that the continually voiced concerns about
'painting ourselves into a corner', with respect to access
authorization, is significantly less of a problem with our approach
rather then without it.

> > If you want super gory details, Intel's whitepaper on attestation
> > in cloud environments is a good starting point[*], but I don't
> > recommended doing much more than skimming unless you really like
> > attestation stuff or are masochistic, which IMO amount to the same
> > thing :-)

> No thanks. :)

Interesting reflections and perhaps worthy of some introspection by
the Linux development community.

I will concede that there are a lot of musty corners that need to be
explored in order to understand how all of this works and the
security/privacy issues involved.  I certainly wouldn't wish
exploration on those corners on anyone.

I think everyone will concede that my ideas and suggestions on these
issues have been deemed to be unpopular, if not without merit.  They
do, however, come from the perspective of someone who directed a
complete and independent implementation of all of this infrastructure.

A process which has left me with no uncertainty whatsoever with
respect to the issues involved in all of this.

> Regards/Gruss,
>     Boris.

Best wishes for a pleasant and productive weekend to everyone.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"I suppose that could happen but he wouldn't know a Galois Field
 if it kicked him in the nuts."
                                -- Anonymous mathematician
                                   Resurrection.
