Return-Path: <SRS0=IGRU=D7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FF4C2D0A3
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Oct 2020 14:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F75921D43
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Oct 2020 14:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762038AbgJXOiq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 24 Oct 2020 10:38:46 -0400
Received: from wind.enjellic.com ([76.10.64.91]:58122 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762037AbgJXOil (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 24 Oct 2020 10:38:41 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 09OEbjW2017748;
        Sat, 24 Oct 2020 09:37:45 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 09OEbiYO017747;
        Sat, 24 Oct 2020 09:37:44 -0500
Date:   Sat, 24 Oct 2020 09:37:44 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
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
Message-ID: <20201024143744.GA17727@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200925000052.GA20333@linux.intel.com> <32fc9df4-d4aa-6768-aa06-0035427b7535@intel.com> <20200925194304.GE31528@linux.intel.com> <230ce6da-7820-976f-f036-a261841d626f@intel.com> <20200928005347.GB6704@linux.intel.com> <6eca8490-d27d-25b8-da7c-df4f9a802e87@intel.com> <20201018084920.GA19255@wind.enjellic.com> <20201019213105.GE23072@linux.intel.com> <20201020100118.GA6957@wind.enjellic.com> <20201020163959.GB28909@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020163959.GB28909@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 24 Oct 2020 09:37:45 -0500 (CDT)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 20, 2020 at 09:40:00AM -0700, Sean Christopherson wrote:

Good morning, I hope the week has gone well for everyone.

> On Tue, Oct 20, 2020 at 05:01:18AM -0500, Dr. Greg wrote:
> >
> > With respect to the security issue at hand, the only relevant issue
> > would seem to be if a page had write permissions at one time in its
> > trajectory to having execute permisions, isn't this correct?

> No.  RW->RX has different properties than RWX.  E.g. an enclave that
> dynamically loads code is not the same thing as an enclave that
> allows simultaneously writing and executing a page.

Yes, it is certainly correct that a platform administrator may want to
restrict RWX, given that it makes an enclave susceptible to potential
arbitrary code execution if there is a programming error in the
enclave.

However, I think it is important for everyone interested in these
issues, to reflect back on what started all of this and that was
Andy's concern that the initial incantations of the driver allowed
execution of arbitrary memory without the ability of the LSM to get a
'look' at the code/memory.

My point in all of this is that a permissions trajectory for an
enclave that allows for write permissions on a path that terminates in
X permissions opens the door for arbitrary memory execution that the
platform security architect has no insight into or that the LSM will
have any control over.

There is no guarantee that dynamically loaded code has to come into
the enclave via anything that the operating system has visibility
into.  If the enclave can toggle RW->RX it is free to dynamically load
code, in encrypted form over the network and then execute it.

In fact, I would posit that this model will be a primary use for
dynamic code loading.  The SGX user community views 'confidential
computing' as much about protecting visibility into algorithms and
code as it is about data that is being operated on.  In certain
unnamed venues where I have consulted it is the primary concern.

So in the broadest sense, we have spent a year worrying about if and
how the LSM will have visibility into enclave based code and in the
end the only really relevant security mechanism available is limiting
page permission transitions that prevent dynamic code loading.  Modulo
of course the issue with RWX, where a platform owner may elect to try
and prevent an enclave writer from shooting themselves in the foot.

The issue at hand is that the primary security threat of the
technology is the same as what the user community wants to use it for.
Joanna Rutkowska called that out a half decade ago when she first
reviewed the technology.

> > The next paragraph of my reply wasn't included in your reply, but I
> > did state that the mprotect hook would be relevant if its purpose was
> > to disallow this permission trajectory and in the process disable
> > enclave dynamic code loading and execution.
> > 
> > So to assist everyone in understanding this issue and the security
> > implications involved, is the ultimate purpose of the mprotect hook to
> > disable dynamic code loading?

> No, it's to provide line of sight to enforcing granular LSM checks
> on enclave pages.  Jumping back to the RWX thing, as a defense in
> depth measure, a policy owner could set an SELinux policy to never
> allow RWX, even for enclaves that dynamically load code.
>
> Whether or not having per-page granluarity on enclave permission
> checks is valuable/interesting is debatable, e.g. it's why LSM
> integration is notably absent from the this series.  But, adding the
> ->mprotect() hook is relatively cheap and can always be removed if
> it's deemed unnecessary in the long run.  The reverse is not true;
> omitting ->mprotect() commits the kernel to an ABI that is either
> ugly and potentially painful (require all enclaves to declare full
> RWX permissions), or flat out prevents adding granular LSM support
> in the future (do nothing).

I believe your analysis with respect to the ability to remove
->mprotect is flawed.  The long standing consensus has been that
functionality never gets broken.  Once ->mprotect is a component of
the ABI it would have to be left intact since it could potentially
break things that elected to use it.  On the other hand there is a
long standing history of adding functionality.

I can't bring myself to believe that LSM's are going to be written
that will be making enclave security decisions on a page by page
basis.  Given what I have written above, I think all of this comes
down to giving platform administrators one of three decisions, in
order of most to least secure:

1.) Block dynamic code loading and execution.

2.) Block access to RWX pages.

3.) The wild west - no restrictions on enclave page protection manipulation.

From a security perspective I would argue for the wisdom of making
option 1 unconditional via a kernel command-line parameter.

It may be that ->mprotect is the right mechanism to implement this.
If that is the case, frame the discussion and documentation so that it
reflects the actual security threat and the consideration and means
for dealing with it.

Hopefully all of this is useful to the stakeholders in this
technology.

Have a good weekend.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 19th Ave. N.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Politics is the business of getting power and privilege without possessing
 merit."
                                -- P.J. O'Rourke
