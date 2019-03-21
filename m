Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E9E7C43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 00:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE851218C3
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 00:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfCUAR4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 20:17:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:30624 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727551AbfCUAR4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 20:17:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 17:17:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,250,1549958400"; 
   d="scan'208";a="143791178"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga002.jf.intel.com with ESMTP; 20 Mar 2019 17:17:55 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.78]) by
 ORSMSX108.amr.corp.intel.com ([169.254.2.134]) with mapi id 14.03.0415.000;
 Wed, 20 Mar 2019 17:17:54 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
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
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: RE: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Topic: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Thread-Index: AQHU3zmquZHDGSY4XUWmggeyxtSmi6YU12fwgAB7nID//4szkIAAmViA//+j/nA=
Date:   Thu, 21 Mar 2019 00:17:53 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F4E85C6B5@ORSMSX116.amr.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <CALCETrVKAUK-jZ7Knp7RetTL055p3iK1D8Wyr6=hPq5HkePkFg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C53D@ORSMSX116.amr.corp.intel.com>
 <20190320210313.GJ30469@linux.intel.com>
In-Reply-To: <20190320210313.GJ30469@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODFjOGU2M2EtMjZlYy00YmQyLWI1ZWYtZjdiZDZhMGM3Y2Q1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibnd4UGYzbmVQaVBsT0JkbHRFMWd6UG05cGhmbko4R3NZRE5jUUxaMnpQektqRmNGSEN6QSt2cGVXTHRRTkppUSJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On Wed, Mar 20, 2019 at 12:57:52PM -0700, Xing, Cedric wrote:
> > > Using the untrusted stack as a way to exchange data is very
> > > convenient, but that doesn't mean it's a good idea.  Here are some
> > > problems it
> > > causes:
> > >
> > >  - It prevents using a normal function to wrap enclave entry (as
> > > we're seeing with this patch set).
> >
> > It doesn't prevent.
> 
> Yes it does, keyword being "normal".  Though I guess we could do a bit
> of bikeshedding on the definition of normal...

I don't understand what you mean by "normal". As I said, I tend to have a x86_64 ABI compliant version and by saying that I mean it'd be a 100% "normal" function callable from C. And the version I provided in this thread is a trimmed down version that doesn't preserve any registers except RSP/RBP so a C wrapper will be necessary. Other than that I'm not aware of any anomalies. Could you elaborate on what "abnormal" operations necessary to invoke this vDSO under what circumstances? And it'll be very helpful if you could present a "normal" function to demonstrate how your code could work with it while mine couldn't.

> Actually, this series doesn't force anything on Intel's SDK, as there is
> nothing in the documentation that states the vDSO *must* be used to
> enter enclaves.  In other words, unless it's expressly forbidden,
> applications are free to enter enclaves directly and do as they wish
> with the untrusted stack.  The catch being that any such usage will need
> to deal with enclave exceptions being delivered as signals, i.e. the
> vDSO implementation is a carrot, not a stick.

If you want to bike-shedding on *must*, well, no one *must* use *anything* from the *anyone*! But is that the expectation? Or if you don't expect your API to be used then what are you doing here?

Intel SDK doesn't have to use this API. But we (the SDK team) are truly willing to use this API because we share the same concern with you over signals and would like to move to something better.

> 
> AIUI, excepting libraries that want to manipulate the untrusted stack,
> there is a general consensus that the proposed vDSO implementation is
> the right approach, e.g. full x86_64 ABI compatibility was explored in
> the past and was deemed to add unnecessary complexity and overhead.
> 
> The vDSO *could* be written in such a way that it supports preserving
> RBP or RSP, but for all intents and purposes such an implementation
> would yield two distinct ABIs that just happen to be implemented in a
> single function.
> And *if* we want to deal with maintaining two ABIs, supporting the
> kernel's existing signal ABI is a lot cleaner (from a kernel perspective)
> than polluting the vDSO.

Disagreed! What I'm proposing is one ABI - enclave preserves RBP! No requirements on RSP. Of course RSP is still interpreted as the line between vacant and used parts of the stack, or nothing will work regardless the proposal.

The hosting process may have an agreement with the enclave to preserve RSP. But that would be completely between them, and would be just a coincidence instead of a consequence of the ABI from the perspective of this vDSO API.

> 
> In other words, if there is a desire to support enclaves which modify
> the untrusted stack, and it sounds like there is, then IMO our time is
> better spent discussing whether or not to officially support the signal
> ABI for enclaves.

Disagreed! We share the same concern over signals so let's work this out! 

> 
> > > It assumes that the untrusted stack isn't further constrained by
> > > various CFI mechanisms (e.g. CET), and, as of last time I checked,
> > > the interaction between CET and SGX was still not specified.
> >
> > I was one of the architects participating in the CET ISA definition.
> > The assembly provided was crafted with CET in mind and will be fully
> > compatible with CET.
> >
> > > It also
> > > assumes that the untrusted stack doesn't have ABI-imposed layout
> > > restrictions related to unwinding, and, as far as I know, this means
> > > that current enclaves with current enclave runtimes can interact
> > > quite poorly with debuggers, exception handling, and various crash
> > > dumping technologies.
> >
> > Per comments from the patch set, I guess it's been agreed that this
> > vDSO function will NOT be x86_64 ABI compatible. So I'm not sure why
> > stacking unwinding is relevant here.
> 
> I think Andy's point is that a single PUSH (to save %rcx) won't break
> unwinding, etc..., but unwinders and whantot will have a rough go of it
> if %rsp points at complete garbage.

The unwanders use CFI directives to determine frame pointers. RSP is the frame point by default but could be easily changed - e.g. by ".cfi_def_cfa_register %rbp". I could add proper CFI directives if so desired. I omitted them because you omitted them too in your code (in case you don't know, CFI directives are needed around push/pop %rcx in your code to stay compliant with ELF/DWARF spec), and I didn't want to confuse those who didn't understand CFI.

> 
> > However, I'm with you that we
> > should take debugging/exception handling/reporting/crash dumping into
> > consideration by making this vDSO API x86_64 ABI compatible. IMO it's
> > trivial and the performance overhead in negligible (dwarfed by ENCLU
> > anyway. I'd be more than happy to provide a x86_64 ABI compatible
> > version if that's also your preference.
> 
> It's not just the performance cost, making __vdso_sgx_enter_enclave()
> compatible with the x86_64 ABI adds complexity to both its code and its
> documentation, e.g. to describe how data is marshalled to/from enclaves.

Well, technically speaking an ABI compliant API should *reduce* documentation. But given how easy it is to write a C compliant wrapper, I think a custom ABI is perfectly fine.
