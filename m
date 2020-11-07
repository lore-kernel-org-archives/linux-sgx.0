Return-Path: <SRS0=duYL=EN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 832C1C55178
	for <linux-sgx@archiver.kernel.org>; Sat,  7 Nov 2020 15:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 583EC20719
	for <linux-sgx@archiver.kernel.org>; Sat,  7 Nov 2020 15:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgKGPKI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 7 Nov 2020 10:10:08 -0500
Received: from wind.enjellic.com ([76.10.64.91]:59880 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgKGPKI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 7 Nov 2020 10:10:08 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0A7F9XsO029629;
        Sat, 7 Nov 2020 09:09:33 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0A7F9UVw029628;
        Sat, 7 Nov 2020 09:09:30 -0600
Date:   Sat, 7 Nov 2020 09:09:30 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v40 10/24] mm: Add 'mprotect' hook to struct vm_operations_struct
Message-ID: <20201107150930.GA29530@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com> <20201104145430.300542-11-jarkko.sakkinen@linux.intel.com> <20201106174359.GA24109@wind.enjellic.com> <e70c9e92-0bd4-59a4-21b1-bccf8621c6bb@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e70c9e92-0bd4-59a4-21b1-bccf8621c6bb@intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 07 Nov 2020 09:09:33 -0600 (CST)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 06, 2020 at 09:54:19AM -0800, Dave Hansen wrote:

Good morning, I hope the weekend is going well for everyone, beautiful
weather out here in West-Cental Minnesota.

> On 11/6/20 9:43 AM, Dr. Greg wrote:
> > In light of this, given the decision by the driver authors to not
> > fully equip the driver with EDMM support, the mprotect protection
> > requirements are straight forward and minimalistic.  All that is
> > needed is a binary valued variable, set on the command-line, that
> > either allows or denies anonymous code execution by an enclave,
> > ie. access to page protection changes after initialization.

> To that, I say NAK.  We need more flexibility than a boot-time-fixed,
> system-wide switch.

To be clear, I wasn't referring to a global yes/no option in the code
that implements the mprotect callout method in the
vm_operations_struct.  I was referring to the implementation of the
hook in the SGX driver code.

In all of these discussions there hasn't been a refutation of my point
that the only reason this hook is needed is to stop the potential for
anonymous code execution on SGX2 capable hardware.  So we will assume,
that while unspoken, this is the rationale for the hook.

If you are NAK'ing a global enable/disable in the driver code, I think
there needs to be a discussion of why the driver, in its current
state, needs anything other then a yes/no decision on mprotect after
enclave initialization is complete.

At this point in time the driver has no intention of supporting EDMM,
so the simple belt-and-suspenders approach is to deny mprotect on
enclave virtual memory after initialization.  Absent mprotect, the
hardware is perfectly capable of enforcing page permissions that are
only consistent with the initial mapping of the enclave.

If and when EDMM is implemented there might be a rationale for per
page mprotect interrogation.  I won't waste people's time here but I
believe a cogent arguement can be made that there is little utility,
even under EDMM, of making per page permission decisions rather then a
'yes/no' decision by the platform owner as to whether or not they want
to allow anonymous code execution.

Hopefully all of this is a useful clarification.

Have a good weekend.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If you ever teach a yodeling class, probably the hardest thing is to
 keep the students from just trying to yodel right off. You see, we build
 to that."
                                -- Jack Handey
                                   Deep Thoughts
