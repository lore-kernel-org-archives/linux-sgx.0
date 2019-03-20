Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C79FC43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 21:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C880C218B0
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 21:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfCTVDP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 17:03:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:52076 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727197AbfCTVDP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 17:03:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 14:03:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="143745849"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga002.jf.intel.com with ESMTP; 20 Mar 2019 14:03:13 -0700
Date:   Wed, 20 Mar 2019 14:03:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Message-ID: <20190320210313.GJ30469@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <CALCETrVKAUK-jZ7Knp7RetTL055p3iK1D8Wyr6=hPq5HkePkFg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C53D@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E85C53D@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 20, 2019 at 12:57:52PM -0700, Xing, Cedric wrote:
> > Using the untrusted stack as a way to exchange data is very convenient,
> > but that doesn't mean it's a good idea.  Here are some problems it
> > causes:
> > 
> >  - It prevents using a normal function to wrap enclave entry (as we're
> > seeing with this patch set).
> 
> It doesn't prevent.

Yes it does, keyword being "normal".  Though I guess we could do a bit of
bikeshedding on the definition of normal...

> >  - It makes quite a few unfortunate assumptions about the layout of the
> > untrusted stack.  It assumes that the untrusted stack is arbitrarily
> > expandable, which is entirely untrue in languages like Go.
> 
> I'm with you that stack is not always good thing, hence I'm NOT ruling
> out any other approaches for exchanging data. But is stack "bad" enough
> to be ruled out completely? The point here is flexibility because the
> stack could be "good" for its convenience. After all, only buffers of
> "reasonable" sizes will be exchanged in most cases, and in the rare
> exceptions of stack overflow they'd probably get caught in validation
> anyway. The point here again is - flexibility. I'd say it's better to
> leave the choice to the SDK implementers than to force the choice on them.

Actually, this series doesn't force anything on Intel's SDK, as there is
nothing in the documentation that states the vDSO *must* be used to enter
enclaves.  In other words, unless it's expressly forbidden, applications
are free to enter enclaves directly and do as they wish with the untrusted
stack.  The catch being that any such usage will need to deal with enclave
exceptions being delivered as signals, i.e. the vDSO implementation is a
carrot, not a stick.

AIUI, excepting libraries that want to manipulate the untrusted stack,
there is a general consensus that the proposed vDSO implementation is the
right approach, e.g. full x86_64 ABI compatibility was explored in the
past and was deemed to add unnecessary complexity and overhead.

The vDSO *could* be written in such a way that it supports preserving RBP
or RSP, but for all intents and purposes such an implementation would yield
two distinct ABIs that just happen to be implemented in a single function.
And *if* we want to deal with maintaining two ABIs, supporting the kernel's
existing signal ABI is a lot cleaner (from a kernel perspective) than
polluting the vDSO.

In other words, if there is a desire to support enclaves which modify
the untrusted stack, and it sounds like there is, then IMO our time is
better spent discussing whether or not to officially support the signal
ABI for enclaves.

> > It assumes that the untrusted stack isn't further constrained by various
> > CFI mechanisms (e.g. CET), and, as of last time I checked, the
> > interaction between CET and SGX was still not specified.  
> 
> I was one of the architects participating in the CET ISA definition.
> The assembly provided was crafted with CET in mind and will be fully
> compatible with CET.
> 
> > It also
> > assumes that the untrusted stack doesn't have ABI-imposed layout
> > restrictions related to unwinding, and, as far as I know, this means
> > that current enclaves with current enclave runtimes can interact quite
> > poorly with debuggers, exception handling, and various crash dumping
> > technologies.
> 
> Per comments from the patch set, I guess it's been agreed that this
> vDSO function will NOT be x86_64 ABI compatible. So I'm not sure why
> stacking unwinding is relevant here.

I think Andy's point is that a single PUSH (to save %rcx) won't break
unwinding, etc..., but unwinders and whantot will have a rough go of it
if %rsp points at complete garbage.

> However, I'm with you that we
> should take debugging/exception handling/reporting/crash dumping into
> consideration by making this vDSO API x86_64 ABI compatible. IMO it's
> trivial and the performance overhead in negligible (dwarfed by ENCLU
> anyway. I'd be more than happy to provide a x86_64 ABI compatible
> version if that's also your preference.

It's not just the performance cost, making __vdso_sgx_enter_enclave()
compatible with the x86_64 ABI adds complexity to both its code and its
documentation, e.g. to describe how data is marshalled to/from enclaves.
