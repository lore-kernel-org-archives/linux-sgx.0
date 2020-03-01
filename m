Return-Path: <SRS0=23/H=4S=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83042C3F2D1
	for <linux-sgx@archiver.kernel.org>; Sun,  1 Mar 2020 10:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48ADB21775
	for <linux-sgx@archiver.kernel.org>; Sun,  1 Mar 2020 10:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgCAKmY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 1 Mar 2020 05:42:24 -0500
Received: from wind.enjellic.com ([76.10.64.91]:58834 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCAKmY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 1 Mar 2020 05:42:24 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 021Ag8cX017750;
        Sun, 1 Mar 2020 04:42:08 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 021Ag6Oq017749;
        Sun, 1 Mar 2020 04:42:06 -0600
Date:   Sun, 1 Mar 2020 04:42:06 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20200301104206.GA14547@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200218104243.GA13967@wind.enjellic.com> <8269DEFA-960C-47D0-A1E5-14C427F3CD23@amacapital.net> <20200222031607.GA29858@wind.enjellic.com> <CALCETrX2UhC-+p3nkTk47RjqCSa9=MKQC47DTXw5wgsiijr0Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX2UhC-+p3nkTk47RjqCSa9=MKQC47DTXw5wgsiijr0Rg@mail.gmail.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sun, 01 Mar 2020 04:42:08 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 21, 2020 at 09:41:24PM -0800, Andy Lutomirski wrote:

Good afternoon, I hope the weekend is going well for everyone.

> On Fri, Feb 21, 2020 at 7:16 PM Dr. Greg <greg@enjellic.com> wrote:
> > I should have been more precise, my apologies.
> >
> > When I was suggesting that DAC/MAC controls were not relevant, I was
> > referring to their relevance with respect to protecting the platform
> > from running code that does not have defined provenance or origin.

> Windows systems quite regularly get owned by code with "defined
> provenance or origin" in the sense that it was signed by a valid
> Authenticode certificate. :)

Excellent observation, signing is a metric of identity not
correctness.

Since the first HASP papers were published, Intel has been consistent
with respect to their guidance that buggy code inside of an enclave is
still buggy code.

Windows code signing is designed to provide a guarantee that code is
of known origin.  SGX signing serves the same purpose, the objective
of cryptographic launch control is to protect the platform from the
technology itself, through the use of cryptographic identity controls.

> > I'm certainly not argueing against defense in depth or the merits
> > of DAC/MAC controls.  I'm simply stating that they are irrelevant,
> > with respect to the concerns that you raised about code provenance
> > and origin, on flexible launch control platforms that support SGX2
> > and EDMM.  Platforms that by and large will be the primary target
> > for this driver.

> I have a little FLC platform on my desk.  What I don't have is an
> FLC platform with anything resembling a policy that helps here at
> all.

I believe you have a Gemini Lake SOC based NUC, presumably a NUC7CJYH
or NUC7PJYH.  In addition to FLC, that system has support for SGX2
instructions and thus EDMM.

So you have everything you need to demonstrate the ability to download
and execute code without the OS being able to pass judgement on the
code, other then the OS identity of the user accessing the device node
that loaded a bootstrap enclave.

> > I only bring up the issue in the interests of intellectual honesty
> > and the fact that I'm sure our exchanges will go down in the
> > annals of security history as being as important as the
> > Lincoln/Douglas debates.

> That would be amazing!

The driver initiative has hopefully benefited from a technically
honest discussion of the issues.

> > It is one of my jobs to follow the security literature closely.
> > Everyone who does so can easily envision a future abstract reading
> > something like the following:
> >
> > "Using an unmodified and stock DIST_OS kernel we were able to
> > demonstrate the download and execution of malicious code into an
> > enclave that bypasses all security controls in the Linux operating
> > system allowing us to recover XXXX information from the platform with
> > subsequent exfiltration of the information from the platform without
> > detection."

> Alas, the significance of this seems to depend on what XXXX is.  If
> XXXX is a detail of the specific machine (a derived provisioning key,
> a launch token, etc.), then the paper won't be terribly interesting.
> As root (or someone who can escalate to root or better) on a given
> system, I can extract *tons* of identifying details of the platform.
> If XXXX is a secret created by the user (a sealing key, something
> sealed by SGX, a private key or secret that allows one to pretend to
> be an enclave with MRSIGNER=YYY, etc), then launch control and DAC are
> essentially irrelevant to the discussion.  What actually happened is
> that some code signed by YYY screwed up.  And this is because launch
> control is not part of the SGX root of trust, nor is launch control
> even a necessary part of the SGX security model.  SGX with launch
> control deleted entirely would be just as useful, if potentially a bit
> more dangerous in terms of being able to make malware hard to
> analyze.

You are absolutely correct, cryptographic access control doesn't
influence the enclave security guarantees that SGX implements.  Launch
control is about imposing a cryptographic identity guarantee on the
origin of code executed in enclave context.

Windows Authenticode is about protecting the platform from an entity
attempting to execute malicious code on a platform.  SGX launch
control is about protecting a platform from malicious code running in
an enclave.

The challenge with an EDMM capable SGX platform is that anyone with
the ability to load, initialize and execute an enclave is capable of
bringing code that has potentially adversarial intent onto the
platform and to execute that code.  The executing code has full
visibility into the address space of the process that loaded the
enclave without the need for OCALL's.

I'm confident the security research community will come up with
interesting things that can be accomplished within the constraints of
this model.

The code being loaded onto the platform will be encrypted and
integrity protected so there will be no visibility into the code being
loaded.  By design, once loaded, the execution and functioning of the
code will also have no visibility by the platform, except possibly
through the use and analysis of various side channels.

These are all well understood issues.  Joanna Rutkowska was discussing
the implications of all this seven years ago:

https://blog.invisiblethings.org/2013/09/23/thoughts-on-intels-upcoming-software.html

Everyone seems to be in agreement that the LSM should be able to have
a 'look' at enclave code, although the initial driver implementation
won't have support for that.  If we pride ourselves on being
intellectually honest, we have to ask ourselves why we would even
spend time on adding LSM support given that it will largely amount to
security theater.

There is a high probability that taking advantage of this
functionality will be popular, given the fact that due to user demand,
Intel has implemented support for Protected Code Loading (PCL) in
their SDK.  Anyone that is interested, can look at the implementation
in the following directory of the Intel SGX SDK:

SampleCode/SampleEnclavePCL

The current model involves encrypting the enclave .so file with
subsequent decryption by a loader enclave.  An EDMM based solution
will be both more straight forward and secure from tampering.

There is a great deal of interest in a model where the system
administrators and/or platform deployers have no visibility into the
code or data being executed on the platform.  The Confidential
Computing Consortium (CCC), composed of all the 'bigs - The Linux
Foundation, IBM, Microsoft, GOOGLE, Tencent, Alibaba et.al', has been
put together to support this model.

I suspect a lot of the push to ship code and worry about some of these
pesky security details later arises from a desire to support this
initiative.

Russinovich, the CTO of Microsoft, has a discussion about all of this
on his blob, including a link to the CCC site:

https://cloudblogs.microsoft.com/opensource/2019/08/21/microsoft-partners-linux-foundation-announce-confidential-computing-consortium/

If you check the CCC site itself you will see a reference to the
possibility of this technology being used for nefarious purposes and
that there are research initiatives and best practices that will be
promoted to address this.

All of this dovetails, somewhat, with the 'Zero-Trust' initiative that
is all the rage these days.  All of this is ultimately converging on
the notion that trust needs to be based on a cryptographically secured
expression of identity.

> > > (Don't forget that, no matter how carefully your system might lock
> > > down the SGXPUBKEYHASH MSRs and control the associated keys, that
> > > lockdown is being done by non-enclave *software*, and a bad guy who
> > > gets root is quite likely to be able to unlock the registers by
> > > upgrading their root access to control the firmware.  Or get a launch
> > > token that can't be revoked because SGX doesn't have a token
> > > expiration mechanism.)
> >
> > Dispassionate observers would note that you make the case for locked
> > launch control registers.... :-)
> >
> > At an SGX engineering meeting in Israel last summer, we made the case
> > for the fact that locked vs. unlocked platforms should be a BIOS
> > configurable option.  With an additional option that specifying locked
> > also allows specification of what the identity modulus signature
> > should be.  That would seem to be the best of all worlds, we will see
> > what happens.
> >
> > One of the pushbacks we received, is that SGX is supposed to be immune
> > from firmware manipulation, which our suggested approach would open
> > the door for, which we noted was irrelevant given the trajectory that
> > the Linux kernel driver is on, ie. no cryptographic controls over code
> > origin and provenance.

> I don't believe I have ever said that Linux shouldn't support
> cryptographic verification of SGX code provenance or that Linux
> shouldn't eventually support locked launch control MSRs.  What I've
> said is that the initial upstream version of the driver doesn't need
> this, and that adding support for locked MSRs is tricky and needs
> some design work.

It would seem the consensus of opinion is to ship the driver and then
worry about the security details later.

By now everyone has seen a full discussion on the issues involved,
hopefully it will help to provide a framework for future refinements
to the driver.

In the meantime we will be announcing patches to add cryptographic
trust controls for the driver, so that will be an option for those who
have concerns about the issue until when and if there is consensus on
how to address these issues in the mainline driver.

> FWIW, I didn't expect upstreaming to take anywhere near this long.

I don't think anyone did.

> > Just to provide a frame of reference, our interest in SGX is with
> > respect to its guarantee of integrity of execution, for the
> > purposes of verifying that the kernel could not have executed code
> > that was outside a desired behavioral definition for the platform.

> SGX cannot and will never prevent the kernel from executing normal
> CPL0 code of any sort.  I'm not really sure what you're getting at
> here.  If you have magically trustworthy firmware and locked launch
> control registers, you can prevent the kernel from executing
> unapproved *enclave* code.  It's not entirely clear to me why you
> consider unapproved enclave code to be worse than any other sort of
> unapproved code.

I believe we have a full implementation and demonstration of the
ability of SGX to control what the kernel chooses to execute or
actions it conducts, at least within the framework of the controls
that the LSM provides.  I replied to the KRSI post with a brief
description of our work.

The ultimate future of an initiative such as the CCC is going to
depend on cloud clients being able to have some indication of what
trust to afford to the entire platform.  That will ultimately come
down to the ability to have a cryptographic statement, within modeling
limits, of what behaviors the platform has been allowed to express.

Given the implications of SGX2/EDMM, that will also include a
statement of what cryptographic identities have been able to execute
code in enclave context.

But we won't go down that rathole now.

Best wishes for a productive week.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D    Worker / Principal Engineer
IDfusion, LLC
4206 19th Ave N.            Specialists in SGX secured infrastructure.
Fargo, ND  58102
PH: 701-281-1686            CELL: 701-361-2319
EMAIL: gw@idfusion.org
------------------------------------------------------------------------------
"It would appear that we have reached the limits of what it is
 possible to achieve with computer technology, although one should be
 careful with such statements, as they tend to sound pretty silly in 5
 years."
                                -- John Von Neumann (ca. 1949)
