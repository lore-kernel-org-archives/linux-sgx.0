Return-Path: <SRS0=sUAi=DZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74110C433DF
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Oct 2020 09:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CA52208FE
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Oct 2020 09:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725320AbgJRJEu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 18 Oct 2020 05:04:50 -0400
Received: from wind.enjellic.com ([76.10.64.91]:57294 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbgJRJEt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 18 Oct 2020 05:04:49 -0400
X-Greylist: delayed 865 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Oct 2020 05:04:49 EDT
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 09I8nM6G019472;
        Sun, 18 Oct 2020 03:49:22 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 09I8nK1x019471;
        Sun, 18 Oct 2020 03:49:20 -0500
Date:   Sun, 18 Oct 2020 03:49:20 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
Message-ID: <20201018084920.GA19255@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200924202549.GB19127@linux.intel.com> <e25bfeaa-afb4-3928-eb80-50d90815eabb@intel.com> <20200924230501.GA20095@linux.intel.com> <b737fcab-bfde-90e1-1101-82d646a6f5b7@intel.com> <20200925000052.GA20333@linux.intel.com> <32fc9df4-d4aa-6768-aa06-0035427b7535@intel.com> <20200925194304.GE31528@linux.intel.com> <230ce6da-7820-976f-f036-a261841d626f@intel.com> <20200928005347.GB6704@linux.intel.com> <6eca8490-d27d-25b8-da7c-df4f9a802e87@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6eca8490-d27d-25b8-da7c-df4f9a802e87@intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sun, 18 Oct 2020 03:49:22 -0500 (CDT)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 28, 2020 at 07:04:38AM -0700, Dave Hansen wrote:

Good morning, I hope the weekend is going well for everyone.

> On 9/27/20 5:53 PM, Jarkko Sakkinen wrote:
> > On Fri, Sep 25, 2020 at 12:53:35PM -0700, Dave Hansen wrote:
> >> On 9/25/20 12:43 PM, Sean Christopherson wrote:
> >>>> That means that the intent argument (SGX_PROT_*) is currently unused.
> >>> No, the intent argument is used (eventually) by SGX's ->mprotect()
> >>> implementation, i.e. sgx_mprotect() enforces that the actual protections are a
> >>> subset of the declared/intended protections.
> >>>
> >>> If ->mprotect() is not merged, then it yes, it will be unused.
> >>
> >> OK, I think I've got it.
> >>
> >> I think I'm OK with adding ->mprotect().  As long as folks buy into the
> >> argument that intent needs to be checked at mmap() time, they obviously
> >> need to be checked at mprotect() too.
> >>
> >> Jarkko, if you want to try and rewrite the changelog, capturing the
> >> discussion here and reply, I think I can ack the resulting patch.  I
> >> don't know if that will satisfy the request from Boris from an ack from
> >> a "mm person", but we can at least start there. :)
> > 
> > I think what it needs, based on what I've read, is the step by step
> > description of the EMODPE scenarion without this callback and with it.
> 
> EMODPE is virtually irrelevant for this whole thing.  The x86 PTE
> permissions still specify the most restrictive permissions, which is
> what matters the most.
> 
> We care about the _worst_ the enclave can do, not what it imposes on
> itself on top of that.
> 
> > I think other important thing to underline is that an LSM or any other
> > security measure can only do a sane decision when the enclave is loaded.
> > At that point we know the source (vm_file).
> 
> Right, you know the source, but it can be anonymous or a file.

Or it could be loaded over the network in encrypted form by the
enclave itself.

Sean, admirably, wants to peer into the future and set the driver up
from an architectural perspective, to future proof it for the
imposition of security controls.  So it would seem helpful to peer a
bit.

If I can paraphrase/simplify the discussion to date; the best the
kernel can do with respect to SGX is to impose controls, via mprotect,
that limit the maximum permissions of an enclave page to whatever was
specified when the enclave was loaded/initialized.

So here is the question that would seem to need answering:

Is this even a relevant control if we cede the notion of dynamically
loadable enclave code, which is the objective of SGX2 hardware, which
will in all likelihood be the only relevant hardware implementation in
the future?

The answer to this could very well be yes if the objective is to
provide a method for a platform owner to explicitly block dynamically
loadable enclave code.  Since there seems to be a desire for immense
clarity in the changelogs surrounding all of this, framing the
discussion in something practical like this may be of assistance.

One of the desires of the SGX user community is to not allow
visibility into enclave code, this is one of the notions/objectives of
confidential computing.  The Protected Code Loader that was added by
Intel to their PSW is an acknowledgement of this fact.  EDMM and
dynamically loadable code makes doing this much more efficient so that
would seem to be the face of the future.

My apologies for 'delaying' the driver even more.  I was accused of
that about a year ago but it appears I didn't do too much
damage... :-)

Best wishes for a productive week.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If you get to thinkin' you're a person of some influence, try
 orderin' somebody else's dog around."
                                -- Cowboy Wisdom
