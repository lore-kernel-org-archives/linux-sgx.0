Return-Path: <SRS0=VsxJ=SW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107BDC282DD
	for <linux-sgx@archiver.kernel.org>; Sat, 20 Apr 2019 16:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCFA520651
	for <linux-sgx@archiver.kernel.org>; Sat, 20 Apr 2019 16:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfDTQDY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 20 Apr 2019 12:03:24 -0400
Received: from wind.enjellic.com ([76.10.64.91]:58636 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfDTQDY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 20 Apr 2019 12:03:24 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x3KG2nBD017520;
        Sat, 20 Apr 2019 11:02:49 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x3KG2lfU017519;
        Sat, 20 Apr 2019 11:02:47 -0500
Date:   Sat, 20 Apr 2019 11:02:47 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Message-ID: <20190420160247.GA17291@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com> <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de> <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com> <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net> <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com> <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net> <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com> <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de> <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com> <alpine.DEB.2.21.1904200727410.3174@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904200727410.3174@nanos.tec.linutronix.de>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 20 Apr 2019 11:02:49 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Apr 20, 2019 at 07:42:13AM +0200, Thomas Gleixner wrote:

Good morning/weekend to everyone.

> On Fri, 19 Apr 2019, Jethro Beekman wrote:
> > On 2019-04-19 14:34, Thomas Gleixner wrote:
> > > And how so? You create writeable AND executable memory. That's a nono and
> > > you can argue in circles, that's not going to change with any of your
> > > proposed changes.

> > On 2019-04-19 14:38, Thomas Gleixner wrote:
> > > You are working around LSM nothing else and that's just not going to fly.
> > 
> > Based on your comments, I'm still unsure if we're on the same page with
> > regards to what I'm proposing.
> > 
> > Here's a regular non-SGX flow that LSM would likely prevent:
> > 
> > mmap(PROT_READ|PROT_WRITE)
> > memcpy()
> > mmap(PROT_READ|PROT_EXEC) <-- denied by LSM
> > 
> > Or just something based on regular PT permissions:
> > 
> > mmap(PROT_READ|PROT_EXEC)
> > memcpy() <-- SIGSEGV
> > 
> > Now, the equivalent for SGX:
> > 
> > mmap(PROT_READ|PROT_WRITE)
> > ioctl(EADD)
> > mmap(PROT_READ|PROT_EXEC) <-- denied by LSM

> This is completely irrelevant, really.
>
> The point is that the SGX driver loads and executes arbitrary data
> which is handed in from user space via an ioctl w/o any chance of
> verifying where that comes from.
>
> What Andy proposed is to open a file with the SGX payload and hand
> in the file descriptor. That way LSM can decide whether this is
> allowed or denied based on the file descriptor and whatever the
> security model/policy is in a particular setup.
>
> Right know the SGX driver and its proposed API prevent any form of
> LSM auditing and whatever permission checks you had in mind won't
> change that at all.

I don't even want to remotely get in the middle of this arguement,
since we are probably already persona-non-grata for having stimulated
a discussion that has slowed upstreaming, but some comments to assist
and clarify further progress on the driver.

We understand and support the need for the LSM to trap these events,
but what does LSM provenance mean if the platform is compromised?
That is, technically, the target application for SGX technology.

This issue is what drove our concern for having ring-0 based
enforcement of who can initialize an enclave.  As Andy has pointed
out, the mmap semantics of the SGX driver allow the introduction of
executable code that bypasses LSM enforcement, but the platform owner,
with appropriate enforcements on an FLC platform, has cryptographic
verification and trust for the origin and provenance of that executable
code.

It may be possible to load the executable code into enclave memory but
the processor will refuse to access the memory until the EINIT
instruction validates that the loaded code is compliant with the
enclave metadata and measurement.  That is why we were argueing for,
simple, ring-0 based verification of the key signature that authorizes
the EINIT instruction to complete.

From a more practical perspective, an enclave shared image is a rather
complex beast, that contains a lot of metadata.  An application has to
open the shared image file and parse the metadata in order to properly
construct the enclave image from the text in the image file.  I
believe in practice that will effectively activate LSM recognition of
the executable code.

That obviously leaves a cunning adversary an opportunity to teleport a
simple binary file or network stream onto a platform and load and
execute the contents.  But that takes us back to the need for ring-0
enforcement of enclave initialization... :-)

We wrote a major enhancement to the Linux IMA architecture to
implement introspection of behavioral namespaces.  The actor/subject
events get forwarded up into a modeling engine running inside of a
namespace specific SGX enclave instance that issues a system call to
instruct an LSM that we wrote, and that pairs with the IMA extension,
to 'discipline' the process if it is acting outside its behavioral
specification.

We will verify with Jarkko's current HEAD, but I believe it is
consistently trapping access to the shared image file and hence the
text of the enclave.

> Thanks,
> 
> 	tglx

Have a good weekend.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Simplicity is prerequisite for reliability."
                                -- Edsger W. Dijkstra
