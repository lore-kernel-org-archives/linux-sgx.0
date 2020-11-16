Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A7DC2D0A3
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Nov 2020 18:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1BF320731
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Nov 2020 18:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732785AbgKPSBd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:01:33 -0500
Received: from wind.enjellic.com ([76.10.64.91]:60792 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731501AbgKPSBd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Nov 2020 13:01:33 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0AGI0Pib001075;
        Mon, 16 Nov 2020 12:00:25 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0AGI0NEQ001074;
        Mon, 16 Nov 2020 12:00:23 -0600
Date:   Mon, 16 Nov 2020 12:00:23 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Mikko Ylinen <mikko.ylinen@intel.com>
Subject: Re: [PATCH v40 10/24] mm: Add 'mprotect' hook to struct vm_operations_struct
Message-ID: <20201116180023.GA32481@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com> <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com> <20201106174359.GA24109@wind.enjellic.com> <e70c9e92-0bd4-59a4-21b1-bccf8621c6bb@intel.com> <20201107150930.GA29530@wind.enjellic.com> <c7157bc6-8a65-11f4-e961-17163730df5d@intel.com> <20201112205819.GA9172@wind.enjellic.com> <5c22300c-0956-48ed-578d-00cf62cb5c09@intel.com> <CALCETrWaUDO1eG7PE_bpA2C_OVeNZ7VbEVaznkg2U7Qx=X=oEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWaUDO1eG7PE_bpA2C_OVeNZ7VbEVaznkg2U7Qx=X=oEw@mail.gmail.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Mon, 16 Nov 2020 12:00:25 -0600 (CST)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 12, 2020 at 02:41:00PM -0800, Andy Lutomirski wrote:

Good morning, I hope the week is starting well for everyone.

> On Thu, Nov 12, 2020 at 1:31 PM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > On 11/12/20 12:58 PM, Dr. Greg wrote:
> > > @@ -270,11 +270,10 @@ static int sgx_vma_mprotect(struct vm_area_struct *vma,
> > >                           struct vm_area_struct **pprev, unsigned long start,
> > >                           unsigned long end, unsigned long newflags)
> > >  {
> > > -     int ret;
> > > +     struct sgx_encl *encl = vma->vm_private_data;
> > >
> > > -     ret = sgx_encl_may_map(vma->vm_private_data, start, end, newflags);
> > > -     if (ret)
> > > -             return ret;
> > > +     if ( test_bit(SGX_ENCL_INITIALIZED, &encl->flags) )
> > > +             return -EACCES;
> > >
> > >       return mprotect_fixup(vma, pprev, start, end, newflags);
> > >  }
> >
> > This rules out mprotect() on running enclaves.  Does that break any
> > expectations from enclave authors, or take away capabilities that folks
> > need?

> It certainly prevents any scheme in which an enclave coordinates
> with the outside world to do W-and-then-X JIT inside.  I'm also not
> convinced it has any real effect at all unless there's some magic I
> missed to prevent someone from using mmap(2) to effectively change
> permissions.

The patch that I posted yesterday addresses the security issue for
both mmap and mprotect by trapping the permission change request at
the level of the sgx_encl_may_map() function.

With respect to the W-and-then-X JIT issue, the stated purpose of the
driver is to implement basic SGX functionality, which is SGX1
semantics, it has been stated formally for a year by the developers
themselves that they are not entertaining a driver that addresses any
of the issues associated with non-static memory permissions.

As I've noted previously, the hardware itself is capable of enforcing
that after initialization, if mmap/mprotect is blocked on hardware
that supports SGX2 instructions.

> Everyone, IMO this SGX1 - vs - SGX2 - vs - EDMM discussion is
> entirely missing the point and is a waste of everyone's time.  Let's
> pretend we're building a system that has nothing to do with SGX and
> requires no special hardware support at all.  It works like this:

I don't doubt there is a potential bigger vision here, quite frankly
it is probably an open question whether or not SGX is going to be a
part of this future, for a variety of reasons.  I also do not doubt
that you have the skills to define that vision.

Right now, however, the issue is not about pretending but rather one
of getting a driver into the kernel that provides a framework for
building whatever future SGX may have.  Given GKH's comments on LWN
last week in response to the RAPL vulnerability, I'm not sure if it is
a politically done deal that the driver will go in.

SGX has specific hardware characteristics that impact the driver, I
don't see how fitting it into a generic trusted execution model
advances the agenda immediately at hand.  Particularly given the fact
that I'm not even sure people understand the questions that need to be
answered about such a generic model.

> A user program opens /dev/xyz and gets back an fd that represents 16
> MB of memory.  The user program copies some data from disk (or
> network or whatever) into fd (using write(2) or ioctl(2) or mmap(2)
> and memcpy) and then mmaps some of the fd as R and some as RW and
> some as RX, and then the user program jumps into the RX mapping.

This is basically the SGX model in the new driver.  The important
defining characteristic of the driver, that we can't wave away, is
that the hardware requires a specific set of initial page permissions
to be implemented in order for initialization of the memory range
(enclave) to succeed.

This is inherent to the way SGX hardware was designed to work.  The
only difference between SGX1 and SGX2 is that the latter offers a
small number of additional instructions that allow the page
permissions to be dynamically manipulated after initialization is
complete.

From a security perspective, the issue at hand is that the executable
material is not going to come in through the fd, it is going to be
loaded by the enclave over the network.  This isn't fear mongering, it
is the stated intent of what people want to do with the technology as
a integral part of confidential computing.

I've had the opportunity to brief DOD and other entities concerned
with intelligence issues, about these type of potential capabilities.
It isn't hard to envision scenarios of where having potentially
sensitive code and data only ever handled and executed by a trusted
entity, in an environment that is inherently ephemeral with respect to
its persistence, is an important design characteristic.  Thermite has
also been known to play a role in some of these designs prior to the
greater elegance of trusted execution environments.

Ultimately, if you believe the Confidential Computing Consortium, it
is also what people want for their sensitive cloud workloads.  Absent
the thermite of course.

> If we replace /dev/xyz with /dev/zero, then this simply does not work
> under a reasonably strict W^X policy -- a lot of people think it's
> quite reasonable for an OS to prevent a user program from obtaining an
> X mapping containing anything other than a mapping from a file on
> disk.  To solve this, we can do one of at least three things:
> 
> a) You can't use /dev/xyz unless you have permission to create WX
> memory or to at least create W memory and then change it to X.
> 
> b) You can do whatever you want with /dev/xyz, and LSM policies are
> blatantly violated as a result.

I think the important issue at hand is that classic LSM policies
simply are not relevant with respect to how this technology was
designed to operate, and perhaps more importantly, how people want to
use it.

That is why I have consistently stated that I think the only relevant
knob is a binary decision as to whether or not a platform owner wants
to entertain completely anonymous code execution.

> c) The /dev/xyz API is clever and tracks, page-by-page, whether the
> user intends to ever write and/or execute that page, and behaves
> accordingly.
>
> This patchset takes the approach (c).  The actual clever policy
> isn't here yet, and we don't really know whether it will ever
> appear, but the API is set up to enable such a policy to be written.
> This appears to be a win for everyone, since the code is pretty
> clean and the API is straightforward.

I believe I have been clear in stating that I have never doubted the
cleverness of the approach or its potential utility for the future.

The issue at hand is that it simply isn't relevant at this stage of
the driver.  Getting this new vision right is something that would
benefit from a lot of conversations between runtime and kernel
developers.  Arguably, the case can be made that it should have a
second type of implementation to ensure that the approach is generic,
extensible and most importantly secure.

The 'cleverness' of the policy needs to be evaluated in the context of
what does it mean with respect to the risk arbitration decisions that
we are trying to support.  The open question comes down to, in
essence, asking ourselves whether or not we believe that it makes
sense to say that 15 pages of RWX memory is a security threat but 5
are not.

> Now, back to SGX.  There are only two things that are remotely
> SGX-specific here.  First, SGX requires this unusual memory model in
> which there is an executable mapping of (part of) a device node. [0]
> Second, early SGX hardware had this oddity that the kernel could set
> a per-backing-page (as opposed to per-PTE) bit to permanently
> disable X on a given /dev/sgx page.  Building a security model
> around that would have been a hack, and it DOES NOT WORK on new
> hardware.  So can we please stop discussing it?  None of the actual
> interesting parts of this have much to do with SGX per se and have
> nothing whatsoever to do with EDMM or any other Intel buzzword.

Just a clarification for everyone sitting in their recliners eating
popcorn and following along at home.

As I've stated before, I don't argue the potential utility of some new
model, SGX however, has hardware characteristics that cannot be waved
away in this discussion.  The technology was designed to have a
cryptographic measurement that controls whether or not the memory
image is suitable for execution.  The description of that image is
defined by the enclave author when the enclave is signed.

This is why the current EDMM implementation requires that a maximum
aperture range be defined for dynamic memory regions.  Since the
linear address of each page address in the enclave is encoded into the
measurement, enclave initialization will fail unless the loaded memory
image is consistent with the wishes of the enclave signer.  Having 40
pages of potential heap memory when the author called for 39 would be
considered an initialization defect that would be enforced by the
hardware.

The desired page permissions are also encoded into the enclave
measurement.  Since the current implementation takes the maximum
scoped permissions from the security information encoded in the
enclave, it would require that the enclave encode for RWX permissions
if the intent was to dynmically load executable or JIT code after the
enclave was initialized.  If I understand your above analysis
correctly, this would be problematic for current security
models/practices.

Obviously an API could be proposed that allowed this permissable
memory map to be defined independently from the enclave.  This notion,
based on my read of the security risk considerations that went into
the design of SGX, would be problematic, since it would allow an
untrusted party to modify the characteristics that were desired by the
enclave author for the executable image.

> Heck, if anyone actually cared to do so, something with essentially
> the same semantics could probably be built using SEV hardware
> instead of SGX, and it would have exactly the same issue if we
> wanted it to work for tasks that didn't have access to /dev/kvm.

As I noted above, perhaps whatever this driver may become in the
future would benefit from the community creating something like this
as a second reference to build an API on top of.

> [0] SGX doesn't *really* require this.  We could set things up so that
> you do mmap(..., MAP_ANONYMOUS, fd, ...) and then somehow introduce
> that mapping to SGX.  I think the result would be too disgusting to
> seriously consider.

Let me be clear, I certainly would not advocate doing anything too
disgusting to consider.

Hopefully our proposal for simplifying the security model for the
driver, while still allowing the framework for a still unspecified
future pathway, doesn't fit this description.

Best wishes for a productive week to everyone.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Boy, it must not take much to make a phone work.  Looking at
 everthing else here it must be the same way with the INTERNET."
                                -- Francis 'Fritz' Wettstein
