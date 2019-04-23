Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BE6C10F14
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 09:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88445206A3
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 09:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfDWJM0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:12:26 -0400
Received: from wind.enjellic.com ([76.10.64.91]:59056 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfDWJM0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Apr 2019 05:12:26 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x3N9Bm67006793;
        Tue, 23 Apr 2019 04:11:48 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x3N9BlHl006792;
        Tue, 23 Apr 2019 04:11:47 -0500
Date:   Tue, 23 Apr 2019 04:11:47 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20190423091147.GA6404@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com> <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de> <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com> <alpine.DEB.2.21.1904200727410.3174@nanos.tec.linutronix.de> <20190420160247.GA17291@wind.enjellic.com> <20190422150119.GA1236@linux.intel.com> <20190422162411.GA27389@wind.enjellic.com> <20190422164827.GC1236@linux.intel.com> <CAHk-=wjmT=uC1=18ZYV1CMfP_FBUEjh9_rabH0g+a0z-L0cgHg@mail.gmail.com> <20190422171714.GE1236@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190422171714.GE1236@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 23 Apr 2019 04:11:49 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 22, 2019 at 10:17:15AM -0700, Sean Christopherson wrote:

Good morning to everyone.

> On Mon, Apr 22, 2019 at 09:55:47AM -0700, Linus Torvalds wrote:
> > On Mon, Apr 22, 2019 at 9:48 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > Right, and loading a malicious enclave doesn't change those guarantees
> > > (for other enclaves).  Ergo, restricting which enclaves can execute is
> > > orthogonal to the security provided by SGX.
> > 
> > But it is absolutely worth noting that TSX made a lot of attacks both
> > easier to _do_, and also easier to _hide_.
> > 
> > All while being basically completely worthless technology to everybody
> > except for some silly SAP benchmark.
> > 
> > So it is definitely worth at least discussing the downsides of SGX. If
> > it ends up being another technology that makes it easier to create
> > malware, without actually having a lot of _good_ software use it, the
> > patches to enable it should make damn sure that the upsides actually
> > outweigh the downsides.
> > 
> > And if the current setup basically is "you have to disable reasonable
> > SElinux protections that lots of distros use today", I think it's
> > entirely reasonable saying "the downsides are bigger than the
> > upsides".

> I'm not arguing against SGX playing nice with SELinux/LSMs, actually
> the opposite.  I completely agree that enclaves should be subject to
> LSM restrictions.

As do we.

The point we have been making is that depending on the LSM's are
depending on the fact that the platform has not been compromised.  SGX
is designed to provide a trusted execution environment in the face of
a compromised platform.

> AIUI, Dr. Greg is proposing a framework that uses SGX's launch
> control mechanism to restrict what enclaves can run.  My point is
> that restricting what enclaves can run is about protecting the
> kernel and/or platform, not the enclaves themselves, i.e. using
> launch control instead of, or in addition to, LSMs doesn't change
> the security guarantees of SGX.

I believe current research suggests that this is not the case.

From the paper we have previously cited:

https://arxiv.org/pdf/1702.08719.pdf

In the second paragraph of the abstract:

"In this paper, we demonstrate fine-grained software-based
side-channel attacks from a malicious SGX enclave targeting co-located
enclaves.  Our attack is the first malware running on real SGX
hardware, abusing SGX protection features to conceal itself.
Furthermore, we demonstrate our attack both in a native environment
and across multiple Docker containers".

To be perfectly clear, Dr. Greg, technically IDfusion, is not
proposing the use of SGX's launch control to restrict which enclaves
can run, although there are perfectly legitimate and required use
cases for that technology.

Dr. Greg is proposing that the kernel driver expend 1.2 pages of
kernel memory to implement, at the discretion of the platform owner,
cryptographically verified enclave initialization.  The design we
proposed is the strongest guarantee that a platform owner can
implement, on FLC hardware, that only code and data of known
provenance can be loaded and executed.

There are only two companies that have written the entire stack of
software needed to make practical SGX applications work, us and Intel.
We can go into intimate detail on the issues involved but will embrace
bevity at this point.

Have a good day.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Because the innovator has for enemies all those who have done well
 under the old conditions, and lukewarm defenders in those who may do
 well under the new."
                                 -- Niccolo Machiavelli
                                    _The Prince_, Chapter VI
