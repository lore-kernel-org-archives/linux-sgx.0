Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C204C2D0E4
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Nov 2020 18:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 292BF206E5
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Nov 2020 18:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390924AbgKXSlJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Nov 2020 13:41:09 -0500
Received: from wind.enjellic.com ([76.10.64.91]:33502 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390718AbgKXSlH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Nov 2020 13:41:07 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0AOIeekD023801;
        Tue, 24 Nov 2020 12:40:40 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0AOIed0m023800;
        Tue, 24 Nov 2020 12:40:39 -0600
Date:   Tue, 24 Nov 2020 12:40:39 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Mikko Ylinen <mikko.ylinen@intel.com>
Subject: Re: [PATCH v40 00/24] Intel SGX foundations
Message-ID: <20201124184039.GA22484@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com> <20201121151259.GA3948@wind.enjellic.com> <CALCETrXTjZSg-ccDKF7yX8y+vCCrcn9C_m6ZCGNdWHq73aUHQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXTjZSg-ccDKF7yX8y+vCCrcn9C_m6ZCGNdWHq73aUHQQ@mail.gmail.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 24 Nov 2020 12:40:40 -0600 (CST)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 21, 2020 at 10:36:58AM -0800, Andy Lutomirski wrote:

Good morning to everyone.

> Dr. Greg, I know you like sending these emails, but they're not
> really helpful for Linux kernel development.  Please see below.

I don't necessarily enjoy sending these e-mails and they take time
away from a major initiative that I'm taking on, which is why I wanted
to close all of this out.

Since we are establishing the last correspondence on these issues, I
just wanted to establish some final clarifications for everyone
reading along at home.

Andy, I've always publically recognized you as a gifted kernel
developer, but for the record, have you a-priori architected or
written either an SGX application stack or a trusted/untrusted runtime
stack that exceeded 65 KLOC in size?

I've done both, in the case of native SGX application stacks, multiple
times.  Including the first enclave<->enclave remote attestation and
communications framework that bypassed the need for an Attestation
Service Provider.

Intel SGX developer licensing requires that you provide application
recipients with a full and complete runtime along with the signed
application.  Our developer license allowed us to substitute our
runtime for Intel's.

I also spent 4+ years of back and forth with Washington, DC working to
establish the importance of this technology for the DOD, DHS and
various other groups that were interested in our national
cybersecurity posture.  Including demonstrations of the technology in
Faraday shielded rooms.

That doesn't make me an expert in kernel programming but it did make
me feel obligated to ask what I believe are legitimate technical
questions regarding the design and evolution of this driver.

> On Sat, Nov 21, 2020 at 7:13 AM Dr. Greg <greg@enjellic.com> wrote:
> >
> > On Wed, Nov 04, 2020 at 04:54:06PM +0200, Jarkko Sakkinen wrote:
> >
> > Good morning, I hope the weekend is going well for everyone.
> >
> > > Important Kernel Touch Points
> > > =============================
> > >
> > > This implementation is picky and will decline to work on hardware which
> > > is locked to Intel's root of trust.
> >
> > Given that this driver is no longer locked to the Intel trust root, by
> > virtue of being restricted to run only on platforms which support
> > Flexible Launch Control, there is no longer any legitimate technical
> > reason to not expose all of the functionality of the hardware.

> I read this three times, and I can't tell what functionality you're
> referring to.

Yes you do, as I mentioned to Dave in my last e-mail, we have been
disagreeing about this for a year.

You were at some kind of seminar where SGX was discussed.  Based on
that you developed a 'manifesto' regarding how Linux should implement
the technology.  That manifesto indicated there would be no place for
cryptographic policy control on enclaves.

A well taken and considered point on a locked launch control platform
but completely irrelevant for this driver, that only operates on
Flexible Launch Control platforms.  By demanding compliance with only
that vision you deny platform owners a final measure of defense
against anonymous code execution.

> > The patch that I am including below implements signature based policy
> > controls for enclave initialization.  It does so in a manner that is
> > completely transparent to the default behavior of the driver, which is
> > to initialize any enclave passed to it with the exception of enclaves
> > that set the PROVISION_KEY attribute bit.

> It's completely unreviewable.  It's an ABI patch, and it does not
> document what it does, nor does it document why it does it.  It's
> just a bunch of code.  NAK.

You can certainly NAK-away Andy[0]. I've had sufficent private
feedback from reasoned and informed individuals that I've made my
point that this isn't about technical considerations.

Here is the link, again, to the patch in 'git am' compliant format.

ftp://ftp.enjellic.com/pub/sgx/kernel/SFLC-v41.patch

I've been watching Linux patches go by for close to 30 years.  If this
is completely unreviewable garbage, legitimate concerns can be raised
about what is getting pushed into the kernel.

> To be crystal clear, I will not review, and I will NAK outright, any
> patches of this sort, until ALL of the following conditions are met:
> 
> a) Either a functioning SGX driver lands in a -rc kernel or there is
> an excellent justification for why a change of this sort is needed
> prior to a release.  Dr. Greg, you seem to be interested in SGX
> actually landing upstream, but these patches are just causing delays.
> Please stop.

For the record I am stopping, I've said everything that I can say and
the debate is not intellectually honest from a technical perspective,
continuing forward would be a waste of my time and that of others.

Everything is now publically documented for the decision makers.

As to delaying the driver. I was told a year ago that any
consideration of these security issues would hopelessly delay the
driver.  I was told six months ago, when I refreshed the patch against
the new driver design, that the release of the driver was imminent and
thus the issue couldn't be addressed.  Three months ago I was
admonished for my apparent attempt to delay the driver.

It is now a year later and we are patching grammar and noun
possessiveness issues in the driver, so I don't think it is
intellectually honest to suggest I've delayed the driver, more on that
below.

> b) The patch needs to explain what problem it solves and why it is a
> good solution to that problem.

For the official record let me see if I can frame why I think we have
not been intellectually honest with respect to this driver nor my
suggested delay of it.

1.) SGX/TEE's are designed to be secure to an adversarial operating
system or application space, ie. an IAGO threat model.  Major players
financing Linux development believe there is a commercial opportunity
available in this capability.

2.) One year ago you indicated that the then current driver
implementation was deficient, since it allowed executable code from
anonymous memory, ie. executable code that was not surveilled by the
LSM.

3.) At that time I pointed out that this makes little difference since
the technology was perfectly capable of dynamically loading any
executable code or data that it wanted to, using integrity and
confidentiality protections that would prevent any inspection or
control by the operating system, see point 1.

4.) This only leaves reputational or identity based security as a
final and ultimate check as to who can execute code on a platform.
Our patch provides that without requiring it.

You and Dave have both indicated, in response to my concerns, that
there is minimal threat to enclave based code.  If that is the case we
have needlessly delayed the driver for a year engineering a solution
to what is a non-existent threat.

> c) The patch needs to explain, either in a changelog or in a text
> file in the patch, *exactly* what it does.  Imagine MSDN-like
> documentation in the good old days.  The documentation needs to be
> sufficiently clear that a userspace programmer could use your
> mechanism without reference to your implementation and that a kernel
> programmer could, in principle, re-implement your code from the
> description.

I will let the patch speak for itself, if I honestly believed that
writing a monograph on the design would make any difference I would,
but I think we can all agree that is not the case.

For the record, this is infrastructure for a system administrator, a
userspace programmer would have no involvement in it whatsoever.

As I indicated in my mail to Dave, the changelog was designed for
someone who has a working knowledge of SGX and basic kernel
fundamentals such as linked lists and readable/writable /sysfs files.

> Unless all three of these are met, your patch is going nowhere, and
> I think no one should waste their time trying to read it.

It is fine if it doesn't go anywhere, I've made my point, my intention
in all of this was to provide what I believed to be an informed
viewpoint on relevant technical issues.

> > Secondary to the discussions that have been ongoing regarding the
> > restriction of mmap/mprotect, this patch has been extended to
> > implement signature based controls on dynamic enclaves.  The default
> > behavior of the driver under this patch is to reject mmap/mprotect on
> > initialized enclaves, unless the platform owner has elected to allow
> > the enclave signer the option to implement 'dynamic' enclaves,
> > ie. enclaves that are allowed to modify their page permissions after
> > initialization.

> You have sent this change repeatedly, and now for some reason you're
> sending it mixed in with unrelated changes.  Please stop.  At no
> point have you explained why this approach is better than anything
> else.

In the discussion surrounding the mmap/mprotect based introspection of
page permissions implemented by the SGX driver, you indicated that we
should 'pretend' that some potential security model could be built on
top of the EPCM page permission walking infrastructure.  I believe we
do significantly better than that.

There are currently no controls over dynamic enclave behavior.  Given
that our patch implements a generic policy control framework we could
implement this naturally and with little cost or complexity.

For the LKML record, absent our patch the driver has an open security
issue with respect to anonymous code execution that should be
addressed, if that issue is indeed of any concern.

In the vm_ops->mprotect thread, Haitao Huang elegantly described how
this can be achieved, even without EDMM instructions, in a manner that
would never allow the LSM to see WX permissions on a page.  In fact
the current page permission introspection infrastructure enables that
behavior.

> It has the obnoxious side effect that you can't usefully
> SCM_RIGHTS an enclave to a different process with your patch
> applied, which is at least a minor disadvantage.  You have not
> explained any advantage to your patch at all.

I guess I don't understand the SCM_RIGHTS issue.  The policy controls
are implemented after the ioctl resolves the enclave control structure
from the file descriptor and just prior to enclave initialization.  It
isn't clear how this would affect or inhibit a process that has
possession of the file descriptor.

The only thing that I can think of is that you disagree with the
optional capability of blocking the enclave from implementing
anonymously executable memory.  Absent that ability there is the
security issue that has now been extensively discussed.

The current EPCM page permission walking code only enforces the wishes
of the enclave signer not the platform owner.  As I've noted multiple
times, the SGX hardware itself is perfectly capable of enforcing those
wishes.  The security threat comes from the enclave conspiring with
the untrusted component of the application, the current code only
endorses what the enclave wants to do, not necessarily the wishes of
the platform owner.

Beyond that it is unclear where the issue of SCM_RIGHTS comes from.  I
know for certain our runtime doesn't use the concept nor does
Intel's.  The only reference that GOOGLE has is of you saying it would
be nice to have if the system administrator wanted to enforce
restrictions on what can be executed inside of an enclave and then
give the enclave to another process.

As has been discussed, this is largely irrelevant as the new process
owner of the enclave handle (fd) can choose to load whatever code they
are interested in without any inspection or controls.

In fact, this is an often stated desire of the SGX user community in
order to protect their algorithms in a cloud environment.

> Dr Greg, before you hit send on further emails about SGX, could you
> kindly try to imagine you're a kernel maintainer, read your own
> email, and consider whether how to make it add something useful to
> the discussion?

You can breath a sign of relief as I won't be hitting send anymore.

> Thanks,
> Andy

Have a good day.

Dr. Greg

[0]: If you have the facts on your side pound on the facts, if you have
the law on your side pound on the law, if you have neither pound
on the table.

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"There is no safe haven from irresponsible leadership."
                                -- Lou Dobbs
