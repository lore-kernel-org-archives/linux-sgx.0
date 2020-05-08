Return-Path: <SRS0=hhxz=6W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F53C38A2A
	for <linux-sgx@archiver.kernel.org>; Fri,  8 May 2020 19:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD8CF2173E
	for <linux-sgx@archiver.kernel.org>; Fri,  8 May 2020 19:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgEHTDH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 8 May 2020 15:03:07 -0400
Received: from wind.enjellic.com ([76.10.64.91]:43394 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgEHTDG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 8 May 2020 15:03:06 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 048J2RVj001639;
        Fri, 8 May 2020 14:02:28 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 048J2QOk001638;
        Fri, 8 May 2020 14:02:26 -0500
Date:   Fri, 8 May 2020 14:02:26 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200508190226.GA31465@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com> <20200426165753.GA11046@wind.enjellic.com> <87d07gk24l.fsf@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d07gk24l.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Fri, 08 May 2020 14:02:28 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 07, 2020 at 02:41:30AM +0200, Thomas Gleixner wrote:

> Greg,

Good morning Thomas, I hope the week has gone well for you, the same
to everyone else reading this.

> "Dr. Greg" <greg@enjellic.com> writes:
> > As an aside, for those who haven't spent the last 5+ years of their
> > life working with this technology.  SGX2 hardware platforms have the
> > ability to allow unrestricted code execution in enclave context.

> Unrestricted code execution even before loaded? Unrestricted by
> priviledge levels?

The LSM/IMA infrastructure will have no visibility into code that will
be executed and data processed in enclave context, see immediately
below.

> > No amount of LSM or IMA interventions can provide any control over
> > that.

> They can restrict what is started and loaded before anything SGX
> happens.

At best, the visibility and inspection will be over a standard
bootstrap loader of some type is in no way related to the actual code
that will be executed or data processed in enclave context.
Furthermore, given what is becoming the excepted software architecture
for the SGX industry, that code will largely have full access to
system resources.

> If you want to make real technical arguments then please be specific
> and precise and spare us the handwaving marketing speak.

Thomas, you don't know me from boo, those that do know me and have
worked for me would tell you with absolute certainty that being a
'handwavy marketing type' is the complete antithesis of my character
and how I practice engineering.

Andy wanted to know why I felt the current driver disadvantaged our
work, I provided a technical summary, omitted completely in your
response, that indicated how we are using SGX technology in a manner
that is inherently different from the rest of the industry.

> > In fact, the Confidential Computing Consortium, sponsored by none
> > other then the Linux Foundation, has at its fundamental tenant,

> And that's relevant to the technical question in which way?

It speaks directly to the primary marketing objective that is driving
the economics of what this technology is going to turn into.  The
metaphor for objective, that now seems to be generally accepted, is
'Runtime Encryption'.

One of the most common threads on the SGX developer's list is how
developers can restrict the ability of other's to see what their
enclaves are doing or the code in them.  The standard response is
'nothing', a security context has to be established through remote
attestation and the confidential material then conveyed into the
enclave using appropriate confidentiality and integrity protections.

As further technical evidence for all of this, I would refer readers
to the following tag in the Intel Linux SGX SDK:

sgx_2.1.3

That tags the release that introduced the implementation of Protected
Code Loader (PCL) support.  This allows developers to create enclaves
that are encrypted at rest and then decrypted, loaded and executed by
a second bootstrap loader enclave that protects the confidentiality of
the first enclave.

SGX2 hardware support makes the concept of protected code loading, at
once, more practical, more efficient and closes a visibility
vulnerability that the current PCL model has.

The impact of this has to be viewed in the context of the economic
market forces that are driving 'runtime encryption'.

The original SGX programming model promoted by Intel was to partition
applications so that sensitive data, and the code that operated on it,
were inside of an enclave.  That approach was doomed by the economic
factors driving software development which are roughly as follows:

1.) Ease of development.

2.) Cost of development.

3.) Time to market.

4.) Return on investment.

5.) Security

In about that order, although there are probably a half dozen other
factors between 4 and 5.

As a result, the 'runtime encryption' industry moved to a library OS
model where unmodified applications can be run in an enclave along
along with full interpreter environments such as Java, Python,
Javascript and WASM.  In this architecture all of the requests for
operating system resources are shimmed through OCALL's to be serviced
by the OS.

If you combine all of these factors and influences, you end up with,
looking forward, to an architecture that will favor a small bootstrap
loader that downloads and executes code, over protected channels, that
has almost full access to operating system resources.  In this model
the only visibility that the platform owner has, and by extension the
LSM/IMA infrastructure, is the bootstrap loader itself.

This architecture will also be driven by how attractive the concept is
to the devops model and cloud orchestration in general.

Our technical arguement is that it does not seem unreasonable for the
Linux driver, at the discretion of the platform owner, to be able to
implement the equivalent of 2-factor authentication over the
initiation of such execution.

I apologize for the detail and hope it is at once both suitably
technical and 'non-hand-wavy'.

> > the notion of developing an eco-system that allows the execution of
> > code and processing of data, over which, the owner or administrator of
> > the platform has no visibility or control.  It would seem only logical
> > that adversarial interests would indulge themseleves in those
> > capabilities as well.
> >
> > With respect to SGX and these issues, cryptographic policy management
> > is important for the same reason that 2-factor authentication is now
> > considered standard practice in the security industry.
> >
> > We appreciate, Jarkko, that you feel that such infrastructure is
> > optional, like virtualization support, and is something that can go in
> > after the driver is mainlined.  As the diffstat for our patch points
> > out, the proposed support has virtually no impact on the driver, the
> > same cannot be said for virtualization capabilities.

> The diffstat of your patch is irrelevant. What's relevant is the
> fact that it is completely unreviewed and that it creates yet
> another user space visible ABI with a noticable lack of
> documentation.

A number of points on this issue.

If anyone cares to review the patch, it has a 73 line commit message
that describes how the architecture works.  That would obviously be
embellished and added to the general documentation.

We posted the initial concept implementation of this infrastructure 14
months ago.  Andy, rightly so, indicated the design was unclean.  The
simplification of the SGX driver at large over the last year allowed a
much more straight forward implementation of the patch.

This version of the patch has been posted twice in the last three
months, in response to the two major architectural revisions to the
driver that have occurred.

Jarkko indicated a year ago that our approach would 'bloat' the
driver.  A common criticism of patches in general on LKML is that they
complicate sub-systems.  I believe that diffstats are generally
recognized as cognitive indicators of the amount of bloat, complexity
and impact that a proposed patch introduces.

As to lack of review, we would certainly welcome technical and API
comments but we cannot force them.  Candidly, the only people capable
of working with the patch are groups that have full and complete
runtime implementations that they can modify and test and that group
is extremely limited.

> > Moreover, adding support for key based policy management later would
> > require the addition of another ioctl in order to avoid ABI
> > compatibility issues.

> And that's a problem because? 

See below.

> > The current initialization ioctl is best suited, from an engineering
> > perspective, to support this type of infrastructure.

> What's wrong with having IOCTL_INIT_TYPE_A and IOCTL_INIT_TYPE_B?
>
> Nothing at all. It's pretty straight forward and in fact a better
> solution than a duct taped multiplexing all in one IOCTL_INIT_PONIES
> approach.

I believe that a review of our patch would indicate that a 'duct taped
multplexing INIT_PONIES ioctl' is not a technically honest assessment
of what we are proposing.  There is no flag or multi-case variable
implementation, the patch simply re-adds a pointer to a structure that
was in the previously out of tree driver.

In fact, anyone who reviews the patch will see that the current driver
creates a pointer in the ioctl call to pass downward into the hardware
initialization routines.  Our code simply replaces that pointer with
one supplied by userspace.

That being said, we could certainly wire up a second ioctl and use
that.  Candidly, under normal circumstances, that would arguably raise
a bloat accusation, since why would a second ioctl be implemented when
there is an already fully functional and mono-purpose ioctl that
triggers enclave initialization.

> > In fact, the necessary support was removed from the ioctl for
> > political reasons rather then for any valid engineering rationale on
> > flexible launch control platforms, particularly with our patch or an
> > equivalent approach.

> You're surely making a convincing technical argument by claiming
> that this was a political decision. The amount of non-technical,
> i.e.  political arguments in your mail is definitely larger than the
> technical content.

There is the adage out here in the Upper Midwest, shared elsewhere,
that you shouldn't bring a knife to a gunfight, to date the issue of
cryptographic policy management has been exclusively political and
decidedly non-technical.

We have tried to respond by demonstrating, with code, that a minimum
impact technical approach is possible.  To date the only response has
been that we need to get this driver into the kernel as fast as we
can and then deal with other issues.

Candidly, this is equivalent to, 'lets hurry up and ship it and then
we can worry about bugs and security issues', that plagues the rest of
the software industry.

> > Hopefully this is a reasoned technical approach to what has been a
> > long standing issue surrounding this technology.

> It's an approach which guarantees that the driver will miss the next
> merge window. If that's your intention, then please let us know.

I believe that a dispassionate observer, reviewing the last 2-3 years
of LKML conversations surrounding SGX, would not conclude that our
actions have delayed the driver.

Candidly, the issue may be coming down to a question as to whether or
not the driver should go into the kernel.

I pride myself on extreme technical honesty, I assume everyone else
does, so it probably needs to be taken into consideration that it is
now common knowledge that Intel is dropping support for SGX, at least
on the client side:

https://software.intel.com/en-us/forums/intel-software-guard-extensions-intel-sgx/topic/850599

https://www.techspot.com/news/84506-leaked-intel-rocket-lake-s-diagram-highlights-platform.html

My understanding is that getting SGX enabled on Comet Lake platforms
requires a discussion with vendors regarding a customized
BIOS/firmware implementation for the platform that enables the SGX
technology that is now being left silent on the chip/firmware.

A pity really, the technology arguably had a lot of legs with respect
to the capabilities that it brought to edge security but that is
another topic in and of itself.

SGX takes a lot of expensive silicon real estate.  Whether or not that
price continues to get paid is going to depend on whether or not there
is sufficient market 'pull' from entities who want to push code and
data up into the cloud so that it can be executed without anyone
knowing what it is doing.

Hence our continued advocacy for a driver architecture that allows
stronger protections to be applied to that process, without affecting
the default behavior of the driver.

At the very least a modular form of the driver should be considered
that would allow alternate implementations.  Sean indicated that there
was a 'kludgy' approach that would allow an alternate modular
implementation alongside the in-kernel driver.  I believe that Andy
has already indicated that may not be an advisable approach.

> Merging the current set of patches does not prevent anything you want to
> be added. It's an extension to the base implementation and not a
> prerequisite.

My response to that is that a method for the driver to implement the
equivalent of 2-factor authentication over unrestricted code execution
and data manipulation, that does not affect the standard driver
behavior, needs to be part of the base implementation.

> > Best wishes for a productive week.
> >
> > Dr. Greg

> Thanks a lot for the best wishes. Unfortunately reading this email was
> not necessarily productive for me, but I surely wish that you can make
> productive use of my reply.

I'm sorry that you found reading my e-mail to be a waste of your time,
hopefully the time you took to respond has now allowed everyone
reading along at home to enjoy a thorough review of the issues at
hand.

In a precise and non-handwavy sort of fashion....

> Thanks,
> 
> 	tglx

At the risk of wasting more of everyone's time, best wishes for a
productive weekend.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Developers of autonomously
Enjellic Systems Development, LLC     self-defensive IOT platforms
4206 N. 19th Ave.                     and edge devices.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Don't worry about people stealing your ideas.  If your ideas are any
 good, you'll have to ram them down people's throats."
                                -- Howard Aiken
