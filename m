Return-Path: <SRS0=4/gY=64=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBF3C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 09:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A381620675
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 09:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgENJRK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 05:17:10 -0400
Received: from wind.enjellic.com ([76.10.64.91]:43910 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgENJRK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 05:17:10 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 04E9GcQO026356;
        Thu, 14 May 2020 04:16:38 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 04E9Gc1v026355;
        Thu, 14 May 2020 04:16:38 -0500
Date:   Thu, 14 May 2020 04:16:37 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200514091637.GA25156@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com> <20200426165753.GA11046@wind.enjellic.com> <87d07gk24l.fsf@nanos.tec.linutronix.de> <20200508190226.GA31465@wind.enjellic.com> <20200508195635.GR27052@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508195635.GR27052@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 14 May 2020 04:16:39 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 08, 2020 at 12:56:35PM -0700, Sean Christopherson wrote:

Good morning, I hope the week is proceeding well for everyone.

> On Fri, May 08, 2020 at 02:02:26PM -0500, Dr. Greg wrote:
> > On Thu, May 07, 2020 at 02:41:30AM +0200, Thomas Gleixner wrote:
> > > The diffstat of your patch is irrelevant. What's relevant is the
> > > fact that it is completely unreviewed and that it creates yet
> > > another user space visible ABI with a noticable lack of
> > > documentation.
> 
> ...
> 
> > As to lack of review, we would certainly welcome technical and API
> > comments but we cannot force them.

> Thomas' point isn't that your code needs to be reviewed, it's that
> trying to squeeze it into the initial merge will, not might, _will_
> push out the acceptance of SGX.  The same is true for other features
> we have lined up, e.g. KVM and cgroup support.  It's not a slight on
> your code, it's just reality at this point.

For the record and for whatever it is worth at this point.  The patch
has been available in its present form and function for around 14
months.

So there was plenty of time for its consideration and integration into
what is being prepared as the final merge candidate.

> > In fact, anyone who reviews the patch will see that the current driver
> > creates a pointer in the ioctl call to pass downward into the hardware
> > initialization routines.  Our code simply replaces that pointer with
> > one supplied by userspace.

> Personally, I'm in favor of adding a reserved placeholder for a
> token so as to avoid adding a second ioctl() in the event that
> something gets upstreamed that wants the token.  Ditto for a file
> descriptor for the backing store in sgx_enclave_create.

That would be a very low cost and forward looking addition.

> > At the very least a modular form of the driver should be
> > considered that would allow alternate implementations.  Sean
> > indicated that there was a 'kludgy' approach that would allow an
> > alternate modular implementation alongside the in-kernel driver.
> > I believe that Andy has already indicated that may not be an
> > advisable approach.

> Modularizing the the driver does nothing for your use case.  The
> "driver" is a relatively lightweight wrapper, removing that is akin
> to making /dev/sgx/enclave inaccessible, i.e. it doesn't make the
> EPC tracking and core code go away.  Modularizing the whole thing is
> flat out not an option, as doing so is not compatible with an EPC
> cgroup and adds unnecessary complexity to KVM enabling, both of
> which are highly desired features by pretty much everyone that plans
> on using SGX.

All well taken technical points, but they don't speak directly to the
issue at hand.  The potential security issue in all of this is access
to /dev/sgx/enclave, not the EPC tracking and core code.

Here in a nutshell is the paradox the kernel faces:

No one seems to be disputing the fact that the primary focus of this
driver will be to support the notion of 'runtime encryption' and
Confidential Computing.  The whole premise of the concept and economic
predicate of the initiative is that the owner/manager of the platform
has no visibility into what is being done on the platform.

If the Linux community believes that standard platform security
controls can make qualitatively good judgements on what enclave based
execution is doing, it is effectively making the statement that the
very concept of runtime encryption and by extension Confidential
Computing is invalid.

If we accept the concept that Confidential Computing is valid then we
admit the technology provides the opportunity for unsupervised code
execution and data manipulation.

Our premise in all of this is that one page of code implementing three
linked lists is a small price to pay to provide platform owners with
the opportunity to optionally implement what is effectively 2-factor
authentication over this process.

Going forward, if we are intellectually honest, all of this suggests
that adding complexity to the driver with LSM controls makes little
sense technically.  Since, by definition and economic intent, the
technology provides tools and infrastructure that allows these
controls to be evaded.

The notion that entities with adversarial intent would not try and
take advantage of this flies in the face of everything we know about
security.

> Andy is right to caution against playing games to squish in-kernel
> things, but the virtualization snafu is a completely different
> beast.  E.g. SGX doesn't require fiddling with CR4, won't corrupt
> random memory across kexec(), doesn't block INIT, etc...  And I'm
> not advocating long-term shenanigans, I just wanted to point out
> that there are options for running out-of-tree drivers in the short
> term, e.g. until proper policy controls land upstream.

It appears that the distributions, at least IBM/RHEL, are going to
compile this driver in and backport it as well.

What we would recommend at this point is that you and Jarkko do the
Linux community and beyond a favor and wire up a simple kernel
command-line parameter that controls the ability of the driver to be
used, ie. enables/disables access to /dev/sgx/enclave.

Distributions or others can set this command-line parameter by default
to 'disable' and avoid any possibility of the technology being used
for nefarious purposes.  Since the technology now appears to be
focused only on the cloud providers they will certainly be capable of
configuring their implementations to change the default.

In essence, make the kernel's behavior secure by default.

Best wishes for a pleasant weekend to everyone.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Artisans in autonomously
Enjellic Systems Development, LLC     self-defensive IOT platforms
4206 N. 19th Ave.                     and edge devices.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Intellectuals solve problems; geniuses prevent them."
                                -- Albert Einstein
