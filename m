Return-Path: <SRS0=bD14=AL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDE8C433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 17:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 556EC2068F
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Jun 2020 17:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390283AbgF3RX3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:23:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:62758 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390282AbgF3RX2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 30 Jun 2020 13:23:28 -0400
IronPort-SDR: RyxdjboNfOtYfgJ2tVyG41C5M8cXaIW7ZRoFcJqKR1uJUQjXNWiXPehUAQkZiNyYubfrYULwGF
 y6CbBMsR271A==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="125950840"
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="125950840"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 10:23:05 -0700
IronPort-SDR: W+mmP8TYMf1/apOyssk6Ri4mYct5mOVaSAKhe3R5djAYh93yFp9VzXdXk3HMjAKgXjFgpD3mGz
 LZ+gZniJyIKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="481003583"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2020 10:23:05 -0700
Date:   Tue, 30 Jun 2020 10:23:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, "Xing, Cedric" <cedric.xing@intel.com>,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, kmoy@google.com,
        Christian Ludloff <ludloff@google.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>, npmccallum@redhat.com,
        puiterwijk@redhat.com, David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v33 15/21] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20200630172305.GG7733@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-16-jarkko.sakkinen@linux.intel.com>
 <20200629171022.GC32176@zn.tnic>
 <20200630060055.GS12312@linux.intel.com>
 <20200630084128.GA1093@zn.tnic>
 <CALCETrWUHw2WSDaJrxrwVrXSGz-zR0N2R3cT06esKBCpqyoZaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWUHw2WSDaJrxrwVrXSGz-zR0N2R3cT06esKBCpqyoZaQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 30, 2020 at 09:48:22AM -0700, Andy Lutomirski wrote:
> On Tue, Jun 30, 2020 at 1:41 AM Borislav Petkov <bp@alien8.de> wrote:
> >
> > On Mon, Jun 29, 2020 at 11:00:55PM -0700, Sean Christopherson wrote:
> > > E.g. the vDSO function should get the fixup even if userspace screws
> > > up mmap() and invokes __vdso_sgx_enter_enclave() without being tagged
> > > an SGX task.
> >
> > I sincerely hope you don't mean this seriously.
> >
> > Please add a member to task_struct which denotes that a task is an
> > sgx task, test that member where needed and forget real quickly about
> > running *any* *fixup* for unrelated tasks.
> 
> I don't see the problem.  If you call this magic vDSO function and get
> a fault, it gets handled.  What's the failure mode?
> 
> >
> > > No hard dependency, it's normal kernel code.  My reasoning for dropping it
> > > in .../vdso was largely to co-locate it with vdso/extable.h due to the
> > > dependency on the format of 'struct vdso_exception_table_entry'.
> >
> > A struct which you defined instead of simply using struct
> > exception_table_entry even if it has a handler member which would remain
> > unused?
> 
> Don't forget the cross-arch issue.  We need that structure to have
> constant layout so that the -m32 build from the vDSO has the same
> layout as in the kernel.
> 
> So my only actual objection to the patch is that there should probably
> be a comment above the structure reminding people that it needs to
> have the same layout on 32-bit, x32, and x86_64.  So maybe the entries
> should be s32 instead of int, although this doesn't really matter.

I highly doubt my past self thought about the cross-arch issue.  The main
reason I created 'struct vdso_exception_table_entry' is that interpretation
of the fields is different.  For the kernel, the fields contain offsets
that are relative to the address of the field itself, i.e. of the fixup
itself.  For vDSO, the offsets are relative to the base of the vDSO.

Reusing exception_table_entry felt like it would be all kinds of confusing.
