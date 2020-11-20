Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B2EC2D0E4
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Nov 2020 17:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6684422210
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Nov 2020 17:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgKTRcG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Nov 2020 12:32:06 -0500
Received: from wind.enjellic.com ([76.10.64.91]:33076 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728597AbgKTRcG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Nov 2020 12:32:06 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0AKHVCGT032122;
        Fri, 20 Nov 2020 11:31:13 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0AKHVB9g032121;
        Fri, 20 Nov 2020 11:31:11 -0600
Date:   Fri, 20 Nov 2020 11:31:11 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
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
Message-ID: <20201120173111.GA31178@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com> <20201106174359.GA24109@wind.enjellic.com> <e70c9e92-0bd4-59a4-21b1-bccf8621c6bb@intel.com> <20201107150930.GA29530@wind.enjellic.com> <c7157bc6-8a65-11f4-e961-17163730df5d@intel.com> <20201112205819.GA9172@wind.enjellic.com> <5c22300c-0956-48ed-578d-00cf62cb5c09@intel.com> <CALCETrWaUDO1eG7PE_bpA2C_OVeNZ7VbEVaznkg2U7Qx=X=oEw@mail.gmail.com> <20201116180023.GA32481@wind.enjellic.com> <op.0ua2t306wjvjmi@fgctuval.land.test>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0ua2t306wjvjmi@fgctuval.land.test>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Fri, 20 Nov 2020 11:31:13 -0600 (CST)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 18, 2020 at 07:39:50PM -0600, Haitao Huang wrote:

Good morning, I hope the week is ending well for everyone.

> On Mon, 16 Nov 2020 12:00:23 -0600, Dr. Greg <greg@enjellic.com> wrote:
> 
> >On Thu, Nov 12, 2020 at 02:41:00PM -0800, Andy Lutomirski wrote:
> >>It certainly prevents any scheme in which an enclave coordinates
> >>with the outside world to do W-and-then-X JIT inside.  I'm also not
> >>convinced it has any real effect at all unless there's some magic I
> >>missed to prevent someone from using mmap(2) to effectively change
> >>permissions.
> >
> >The patch that I posted yesterday addresses the security issue for
> >both mmap and mprotect by trapping the permission change request at
> >the level of the sgx_encl_may_map() function.
> >
> >With respect to the W-and-then-X JIT issue, the stated purpose of the
> >driver is to implement basic SGX functionality, which is SGX1
> >semantics, it has been stated formally for a year by the developers
> >themselves that they are not entertaining a driver that addresses any
> >of the issues associated with non-static memory permissions.

> The JIT issue is applicable even to SGX1 platforms. We can do EADD
> with EPCM.RWX in sec_info and with PTE.RW, EINIT, then mprotect to
> set PTE.RX when JIT is done.

Correct, which further underscores the point that I am trying make, it
is unclear what the current mmap/mprotect protection architecture is
accomplishing, since it only enforces EPCM permissions.  The hardware
is perfectly capable of doing so without assistance from the operating
system, in fact, the very reason it was designed was to provide
protections in the face of an adversarial operating system.

For precisely one year, as of next week, we have engaged in a
re-design of this driver, driven by the concern that the previous
driver allowed execution of code that bypassed the LSM.  So I'm
assuming the community has concerns about the possibility of anonymous
code execution.  If this is the case, the mmap/mprotect protection
code in the driver should be implementing some type of control over
the execution of anonymous memory, which our patch implements, very
simply and very understandably.

The other straight forward alternative is a knob that tells the driver
to disallow the addition of any page that attempts to set EPCM.XW
permissions.

As always, corrections gladly accepted if our analysis of the driver
or how the hardware itself works is incorrect.

> Haitao

Have a good weekend.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"My second remark is that our intellectual powers are rather geared to
 master static relations and that our powers to visualize processes
 evolving in time are relatively poorly developed."
                                -- Edsger W. Dijkstra
