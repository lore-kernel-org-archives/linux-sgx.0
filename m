Return-Path: <SRS0=tI1m=46=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD33C4CECE
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 18:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91BAB2074A
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 18:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgCMSoz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 13 Mar 2020 14:44:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:5934 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgCMSoz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 13 Mar 2020 14:44:55 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Mar 2020 11:44:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,549,1574150400"; 
   d="scan'208";a="442509038"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 13 Mar 2020 11:44:53 -0700
Date:   Fri, 13 Mar 2020 11:44:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        cedric.xing@intel.com, Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200313184452.GD5181@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <254f1e35-4302-e55f-c00d-0f91d9503498@fortanix.com>
 <CAOASepOm8-2UCdEnVMopEprMGWjkYUbUTX++dHaqCafi2ju8mA@mail.gmail.com>
 <20200313164622.GC5181@linux.intel.com>
 <CAOASepN1hxSgxVJAJiAbSmuCTCHd=95Mnvh6BKNSPJs=EpAmbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepN1hxSgxVJAJiAbSmuCTCHd=95Mnvh6BKNSPJs=EpAmbQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 13, 2020 at 02:32:29PM -0400, Nathaniel McCallum wrote:
> On Fri, Mar 13, 2020 at 12:46 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, Mar 13, 2020 at 11:48:54AM -0400, Nathaniel McCallum wrote:
> > > Therefore, I'd like to propose that __vdso_sgx_enter_enclave():
> > >   * Preserve %rbx.
> >
> > At first glance, that looks sane.  Being able to call __vdso... from C
> > would certainly be nice.
> 
> Agreed. I think ergonomically we want __vdso...() to be called from C
> and the handler to be implemented in asm (optionally); without
> breaking the ability to call __vdso..() from asm in special cases.
> 
> I think all ergonomic issues get solved by the following:
>    * Pass a void * into the handler from C through __vdso...().
>    * Allow the handler to pop parameters off of the output stack without hacks.
> 
> This allows the handler to pop extra arguments off the stack and write
> them into the memory at the void *. Then the handler can be very small
> and pass logic back to the caller of __vdso...().
> 
> Here's what this all means for the enclave. For maximum usability, the
> enclave should preserve all callee-saved registers (except %rbx, which
> is preserved by __vdso..()). For each ABI rule that the enclave
> breaks, you need logic in a handler to fix it. So if you push return
> params on the stack, the handler needs to undo that.

Or the untrusted runtime needs to wrap the __vdso() to save state that is
clobbered by the enclave.  Just want to make it crystal clear that using a
handler is only required for stack shenanigans.

> This doesn't compromise the ability to treat __vsdo...() like ENCLU if
> you need the full power. But it does make it significantly easier to
> consume when you don't have special needs. So as I see it, __vdso...()
> should:
> 
> 1. preserve %rbx
> 2. take leaf in %rcx
> 3. gain a void* stack param which is passed to the handler

Unless I'm misunderstanding the request, this already exists.  %rsp at the
time of EEXIT is passed to the handler.

> 4. sub/add to %rsp rather than save/restore

Can you elaborate on why you want to sub/add to %rsp instead of having the
enclave unwind the stack?  Preserving %rsp across EEXIT/ERESUME seems more
in line with function call semantics, which I assume is desirable?  E.g.

  push param3
  push param2
  push param1

  enclu[EEXIT]

  add $0x18, %rsp

> That would make this a very usable and fast interface without
> sacrificing any of its current power.
