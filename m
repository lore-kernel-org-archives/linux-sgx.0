Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AE1C4727E
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 22:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C5602087D
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 22:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgIYW3m (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 18:29:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:48559 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgIYW3m (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Sep 2020 18:29:42 -0400
IronPort-SDR: migZr3Hjx89bQ+7TkT5LEWu5OD4+02GsXeoDjLVAaLW19mKIyZj2YCkp58274997NoClJOhak7
 6s2ZefOhBNWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="246438936"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="246438936"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 15:29:41 -0700
IronPort-SDR: 1I8kzUkRAAmMjTskZILJrbswoafdRzLxrxgt/NQHuSZ5VBDIpm7a2xS3SQ1TQgVv1zh0SAIKrz
 AGK9FUvGfTuQ==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="512407840"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 15:29:41 -0700
Date:   Fri, 25 Sep 2020 15:29:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org
Subject: Re: Can we credibly make vdso_sgx_enter_enclave() pleasant to use?
Message-ID: <20200925222938.GI31528@linux.intel.com>
References: <CALCETrUhQjQQa-BqNHPgdDfD9GDJZXJWSQ_M0tDF_ri5RfyTsw@mail.gmail.com>
 <20200925190915.GD31528@linux.intel.com>
 <CALCETrWDgb_mVPDmKy_7oFg03cOxO-GAUS8kOFrfGiPp9RjboA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWDgb_mVPDmKy_7oFg03cOxO-GAUS8kOFrfGiPp9RjboA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 25, 2020 at 01:20:03PM -0700, Andy Lutomirski wrote:
> On Fri, Sep 25, 2020 at 12:09 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > But where would the vDSO get memory for that little data structure?  It can't
> > be percpu because the current task can get preempted.  It can't be per instance
> > of the vDSO because a single mm/process can have multiple tasks entering an
> > enclave.  Per task might work, but how would the vDSO get that info?  E.g.
> > via a syscall, which seems like complete overkill?
> 
> The stack.

Duh.

> The vDSO could, logically, do:
> 
> struct sgx_entry_state {
>   unsigned long real_rbp;
>   unsigned long real_rsp;
>   unsigned long orig_fsbase;
> };
> 
> ...
> 
>   struct sgx_entry_state state;
>   state.rbp = rbp;  [ hey, this is pseudocode.  the real code would be in asm.]
>   state.rsp = rsp;
>   state.fsbase = __rdfsbase();
>   rbp = arg->rbp;
> 
>   /* set up all other regs */
>   wrfsbase %rsp
>   movq enclave_rsp(%rsp), %rsp

I think this is where there's a disconnect with what is being requested by the
folks writing run times.  IIUC, they want to use the untrusted runtime's stack
to pass params because it doesn't require additional memory allocations and
automagically grows as necessary (obviously to a certain limit).  I.e. forcing
the caller to provide an alternative "stack" defeats the purpose of using the
untrusted stack.

>   enclu
>   rdfsbase %rsp
>
> Expressing this abomination using DWARF is surely entirely impossible,
> so instead we would want to make sure that user code simply cannot
> observe the state between the wrfsbase and the rdfsbase.  This would
> require three exception hooks, which is more than we have now but is
> not actually unmanageable.  And it would be possible to write a test
> case to make sure we got it right.  A downside is that single-stepping
> this mess would probably not work in any sensible way.
> 
> This could also be handled more slowly by introducing an actual
> syscall so the kernel could help out.  This would also be pretty ugly.
> 
> On the other hand, if we had some confidence that the existing corpus
> of enclaves plays games with RSP but not RBP, we could handle this
> much more straightforwardly and even likely perserve DWARF support,
> although we'd still have strange artifacts if we got a signal in the
> wrong place.

Heh, I had exactly that typed out, then I reread this paragraph :-)

We do have this confidence, because it's required by the current version
of the VDSO.

> (If we have CET, we could do truly unspeakable things involving saving
> our state on the shadow stack.  Don't think too hard about this.)
> 
> >
> > So, no?
> >
> > If we truly want to provide a "better" vDSO, my vote would be to disallow using
> > the runtime's stack from within the enclave.  But I'm guessing that would cause
> > more than a few aneurysms for the folks that are cc'd :-)
> 
> Indeed.
> 
> My real problem with the callback is that it forces the untrusted
> runtime to use a C-like stack model and to keep the vDSO entry on the
> stack while handling the OCALL or whatever you want to call it.

But the callback is optional...  It's effectively mandatory if you want to
invoke the vDSO from anything but assembly, but it's not required.

> This is fine for those of us who exclusively program in C, aren't doing
> anything fancy, and want to think of enclaves as just more C code.  But
> enclaves aren't just more C code -- they're more-or-less-immutable blobs, and
> they can't easily evolve with the untrusted code that invokes them.  And the
> world is slowly but surely moving toward languages that aren't quite as
> C-like as C.  In a language with stackless coroutines or async/await or
> continuations or goroutines, this could all get quite awkward.  Sure, a
> really nice Rust or Go SGX untrusted runtime could just declare that it won't
> support enclaves that touch the stack, but that's a bit of an unfortunate
> restriction given that removing stack access from an existing enclave will
> inevitably change MRENCLAVE.

But if these use cases come along (using a modern runtime to run existing
enclaves that do stupid things), and we didn't want to foist the effort of
writing an assembly wrapper onto the runtimes, couldn't we simply add a flag to
opt into saving non-volatile registers and/or loading an alternative RSP?  E.g.

test	$1,	SGX_ENCLAVE_RUN_FLAGS(%rcx)
	jz	.Lload_tsc
	mov	%rsp, SGX_SAVED_RSP(%rbp)
	mov	SGX_ENCLAVE_RUN_RSP(%rcx), %rsp

	/* Load TCS and AEP */
.Lload_tsc:
	mov	SGX_ENCLAVE_RUN_TCS(%rcx), %rbx
	lea	.Lasync_exit_pointer(%rip), %rcx

	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
.Lasync_exit_pointer:
.Lenclu_eenter_eresume:
	enclu

	/* EEXIT jumps here unless the enclave is doing something fancy. */
	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
	test	$1, SGX_ENCLAVE_RUN_FLAGS(%rbx)
	jz	.Lblahblahblah

	mov	%rsp, SGX_ENCLAVE_RUN_RSP(%rbx)
	mov	SGX_SAVED_RSP(%rbp), %rsp

.Lblahblahblah:

> If I thought there was a straightforward way to support all existing
> enclaves without callbacks in the vDSO, I would be all for it.  I'm
> wondering if doing so even unstraightforwardly would still be
> worthwhile.

Hmm, so IIUC, your pie in the sky goal is providing a vDSO that:

  a) is callable from C
  b) supports all existing enclaves
  c) doesn't require a callback

The problem is (c) conflicts the aforementioned desire to use the runtime's 
_stack_, not simply whatever SSA.RSP points at.  We can play games to allow
using the stack as is without a callback, but that would add some non-trivial
nastiness in the caller to avoid clobbering the "enclave's" stack, especially
for runtimes/enclaves that are reentrant.

> If everyone wants to tell me that what we have now (plus .cfi
> annotations and perhaps a CET fix) is good enough, then so be it.  But
> I figured I'd ask.
