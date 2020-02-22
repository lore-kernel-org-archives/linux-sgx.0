Return-Path: <SRS0=JhNk=4K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC12C35669
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Feb 2020 03:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06D7320722
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Feb 2020 03:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgBVDQa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Feb 2020 22:16:30 -0500
Received: from wind.enjellic.com ([76.10.64.91]:57852 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgBVDQa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Feb 2020 22:16:30 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 01M3G9Dn030938;
        Fri, 21 Feb 2020 21:16:09 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 01M3G8A6030937;
        Fri, 21 Feb 2020 21:16:08 -0600
Date:   Fri, 21 Feb 2020 21:16:08 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20200222031607.GA29858@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200218104243.GA13967@wind.enjellic.com> <8269DEFA-960C-47D0-A1E5-14C427F3CD23@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8269DEFA-960C-47D0-A1E5-14C427F3CD23@amacapital.net>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Fri, 21 Feb 2020 21:16:09 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 18, 2020 at 07:00:23AM -0800, Andy Lutomirski wrote:

Good evening Andy, always good to hear from you.

> > On Feb 18, 2020, at 2:43 AM, Dr. Greg Wettstein <gw@idfusion.org> wrote:
> > The fundamental issue, that there appears to be a reluctance to
> > discuss, is that DAC/MAC controls are not relevant to SGX,
> > particularly SGX2 based systems, which is what most of this stuff
> > will be running on.

> No, this isn't the fundamental issue, because DAC/MAC is just as
> relevant to systems with SGX and SGX2.  I'm sure that there will
> be systems that work with SGX and with everything running as root
> (or even SGX on a kernel without access control at all), but these
> will be a minority. Even if you have absolutely perfect protection
> of sensitive data, you sacrifice any sort of defense in depth
> against an attacker DoSing you in any number of amazing ways.  Or,
> for that matter, leaking keys derived from the provisioning key.

I should have been more precise, my apologies.

When I was suggesting that DAC/MAC controls were not relevant, I was
referring to their relevance with respect to protecting the platform
from running code that does not have defined provenance or origin.

The last time we had this conversation, it spurred you to make issue
of the fact that the current driver allows writable memory to be
executable, without the contents of the memory being properly vetted
by the LSM, without doubt an important issue.  LWN even ran an article
on the issue.

I'm certainly not argueing against defense in depth or the merits of
DAC/MAC controls.  I'm simply stating that they are irrelevant, with
respect to the concerns that you raised about code provenance and
origin, on flexible launch control platforms that support SGX2 and
EDMM.  Platforms that by and large will be the primary target for this
driver.

I have no illusions of convincing you or anyone else involved in the
development of this driver, of the merits of our concern.  However,
anyone who has worked on this technology at length, and is
intellectually honest, knows it is a legitimate security issue.

Bruce Schneier even weighed in on the issue, although from a somewhat
different perspective:

https://www.schneier.com/blog/archives/2017/03/using_intels_sg.html

I only bring up the issue in the interests of intellectual honesty and
the fact that I'm sure our exchanges will go down in the annals of
security history as being as important as the Lincoln/Douglas debates.

It is one of my jobs to follow the security literature closely.
Everyone who does so can easily envision a future abstract reading
something like the following:

"Using an unmodified and stock DIST_OS kernel we were able to
demonstrate the download and execution of malicious code into an
enclave that bypasses all security controls in the Linux operating
system allowing us to recover XXXX information from the platform with
subsequent exfiltration of the information from the platform without
detection."

:-)

FWIW, from your statement above, it is unclear how DAC/MAC controls of
any type or depth would prevent leaking keys derived from the
provisioning key.  One prevents leakage of provisioning derived keys
by implementing cryptographic provenance of code execution so that you
have some modicum of trust that enclave code that has access to the
provisioning key can be trusted to 'do the right thing'.

> (Don't forget that, no matter how carefully your system might lock
> down the SGXPUBKEYHASH MSRs and control the associated keys, that
> lockdown is being done by non-enclave *software*, and a bad guy who
> gets root is quite likely to be able to unlock the registers by
> upgrading their root access to control the firmware.  Or get a launch
> token that can't be revoked because SGX doesn't have a token
> expiration mechanism.)

Dispassionate observers would note that you make the case for locked
launch control registers.... :-)

At an SGX engineering meeting in Israel last summer, we made the case
for the fact that locked vs. unlocked platforms should be a BIOS
configurable option.  With an additional option that specifying locked
also allows specification of what the identity modulus signature
should be.  That would seem to be the best of all worlds, we will see
what happens.

One of the pushbacks we received, is that SGX is supposed to be immune
from firmware manipulation, which our suggested approach would open
the door for, which we noted was irrelevant given the trajectory that
the Linux kernel driver is on, ie. no cryptographic controls over code
origin and provenance.

Just to provide a frame of reference, our interest in SGX is with
respect to its guarantee of integrity of execution, for the purposes
of verifying that the kernel could not have executed code that was
outside a desired behavioral definition for the platform.

We namespaced a modified implementation of Linux IMA and our container
launch system pairs each behavioral canister with an SGX enclave that
introspects the namespace's behavior.  The enclave labels a process
attempting an extra-dimensional Turing event as a 'bad actor', subject
to appropriate discipline by a modified LSM.

So known cryptographic integrity and provenance of executed code
positions us to make a strong attestation statement regarding the
integrity of the platform as a whole.  There is a significant body of
interest in the ability to support such statements.

We also addressed the problem of perpetual launch tokens but that is
an issue for another time.

> No one wants to discuss your DAC-less model because, as far as I can
> tell, no one agrees with you.

Stating that no one, in a world of 7.7 billion people, agrees with us
on these issues would seem to make that contention vulnerable to any
finding of a defect in absolutism.

The number of downloads of our patch set and GIT pulls of our modified
version of Jarkko's driver speaks otherwise, and has convinced us to
expend the cycles needed to continue maintaining and making available
an approach that provides some notion of cryptographic based
provenance and origin of SGX based execution on FLC platforms.

We tend to take solace and energy from the fact that Henry Ford's
contemporaries criticized him for not spending his time breeding
faster horses that ate and drank less.

Best wishes for an enjoyable and productive weekend to everyone.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC               SGX secured infrastructure and
4206 N. 19th Ave.           autonomously self-defensive platforms.
Fargo, ND  58102
PH: 701-281-1686            EMAIL: greg@idfusion.net
------------------------------------------------------------------------------
"Now Ed, is there a need to be concerned about edging?"
                                -- Alan Biddison - Snowmass 2019
                                   Resurrection.
