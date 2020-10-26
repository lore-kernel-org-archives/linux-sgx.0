Return-Path: <SRS0=89p6=EB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B42C55178
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Oct 2020 10:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BD8522403
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Oct 2020 10:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771846AbgJZKwT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Oct 2020 06:52:19 -0400
Received: from wind.enjellic.com ([76.10.64.91]:58370 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1771748AbgJZKwT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Oct 2020 06:52:19 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 09QApT06030457;
        Mon, 26 Oct 2020 05:51:30 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 09QApSXE030456;
        Mon, 26 Oct 2020 05:51:28 -0500
Date:   Mon, 26 Oct 2020 05:51:28 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
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
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20201026105128.GA30004@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201024143744.GA17727@wind.enjellic.com> <3655FF47-15D7-4433-81B7-FC070E32B541@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3655FF47-15D7-4433-81B7-FC070E32B541@amacapital.net>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Mon, 26 Oct 2020 05:51:30 -0500 (CDT)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 24, 2020 at 08:33:21AM -0700, Andy Lutomirski wrote:

Good morning, I hope the week is starting well for everyone.

> > On Oct 24, 2020, at 7:38 AM, Dr. Greg <greg@enjellic.com> wrote:
> > I can't bring myself to believe that LSM's are going to be written
> > that will be making enclave security decisions on a page by page
> > basis.  Given what I have written above, I think all of this comes
> > down to giving platform administrators one of three decisions, in
> > order of most to least secure:
> > 
> > 1.) Block dynamic code loading and execution.

> I don't understand what you're trying to say. Unless we're going to
> split enclaves into multiple VMAs with different permissions, how do
> you expect to block dynamic code loading unless you have separate RW
> and RX pages?  That would be ???page-by-page???, right?

I believe that there are multiple knobs that can be manipulated to
achieve the effects that are desired.  I am advocating that we have a
clear and reasoned understanding, with appropriate documentation, as
to what we are doing and why we are doing it.

To advance this understanding, I would advocate that anyone interested
in these issues review the papers that describe the design and use of
the SGX2 architecture instructions.  Fore convenience we have them
available on our FTP server via the following links:

ftp://ftp.enjellic.com/pub/sgx/docs/hasp4.pdf

ftp://ftp.enjellic.com/pub/sgx/docs/hasp5.pdf

They are both from HASP 2016 and are readily available elsewhere as
well.

The first paper discusses the SGX2 architecture instructions and why
they were implemented.  The second paper discusses how Enclave Dynamic
Memory Management (EDMM) can be implemented from the OS perspective
using these instructions.

Full disclosure, I've had the opportunity to have direct exchanges
with a number of the authors on those papers.

The design of all this was heavily influenced by Marcus Peinado's
group at Microsoft.  They did the first implementation of an SGX
library OS (Haven) and in the process addressed the issue of dynamic
memory and code loading.  Their work also resulted in the
documentation of a number of errata in the SGX silicon implementation.

Like the company or not, I don't think the case can be made that they
don't understand operating system design and theory.  It would thus
seem prudent to understand the prior art that went into the design of
all this.

To summarize at a high level, EDMM requires a rather intricate
choreography between enclave code and the device driver, the latter of
which needs to execute ring-0 privileged instructions in order to
expand the virtual address space of an enclave.

The easiest way to generically block dynamic code loading is to not
allow the ENCLS[EAUG] instruction to be executed, the purpose of which
is to augment a defined but sparse ELRANGE with additional physical
pages from the EPC.  It doesn't require ->mprotect or anything else,
just a physical decision by the OS to not allow execution of that
instruction.

All of which is consistent with my recomendation for a global disable
knob on the kernel command-line for sites that do not want to tolerate
completely anonymous code execution.

Since this driver does not yet support EDMM, the most immediate
situation that we are dealing with are the potential security
implications of SGX2 ENCLU instructions being executed inside of an
enclave.  The most principal issue is the ENCLU[EMODPE] instruction
that allows a running enclave to extend the current permissions of a
page.

I've been assuming that Sean's desire for ->mprotect is to block the
ability of an initialized enclave, on a non-EDMM enabled driver, to
collaborate with its untrusted component to self-modify its page
permissions and thus allow execution of code that the operating system
has no visibility into.  That would make far more sense then the
notion of someone trying to create an LSM that makes page by page
security decisions.

The open question in all of this is that the EDMM paper, as well as
the SDM, indicate the effects of an ENCLU[EMODPE] are immediate inside
of a running enclave.  I'm assuming that this does NOT mean that once
a context of execution is running in enclave mode it would be capable
of evading standard page protections but the 'immediate' is somewhat
disquieting and probably deserves clarification, despite Dave Hansen's
adament concerns about discussing the instruction... :-)

At the risk of being widely unpopular, it may be worth calling the
question if we shouldn't bite the bullet and implement full SGX2
support in the driver.  Given the trajectory that SGX is on it is what
everyone wants and will be using.  We are currently in somewhat of a
bad place since we have to be cognizant of the implications of SGX2
hardware, which is going to be the only relevant platform for this
driver, without actually addressing all of the issues it brings to the
table.

Hopefully all of the above helps advance an understanding of the
issues at hand.

Have a good day.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: dg@enjellic.com
------------------------------------------------------------------------------
"Five year projections, are you kidding me.  We don't know what we are
 supposed to be doing at the 4 o'clock meeting this afternoon."
                                -- Terry Wieland
                                   Resurrection
