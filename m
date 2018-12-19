Return-Path: <SRS0=HOZE=O4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D01BCC43387
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 09:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1504217D9
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 09:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbeLSJVT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Dec 2018 04:21:19 -0500
Received: from mga03.intel.com ([134.134.136.65]:52545 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbeLSJVS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Dec 2018 04:21:18 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2018 01:21:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,372,1539673200"; 
   d="scan'208";a="119619683"
Received: from quwen-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.254.215])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Dec 2018 01:21:09 -0800
Date:   Wed, 19 Dec 2018 11:21:09 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v5 5/5] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20181219092109.GA6183@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <20181214215729.4221-6-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181214215729.4221-6-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 14, 2018 at 01:57:29PM -0800, Sean Christopherson wrote:
> Intel Software Guard Extensions (SGX) SGX introduces a new CPL3-only
> enclave mode that runs as a sort of black box shared object that is
> hosted by an untrusted normal CPL3 process.
> 
> Enclave transitions have semantics that are a lovely blend of SYCALL,
> SYSRET and VM-Exit.  In a non-faulting scenario, entering and exiting
> an enclave can only be done through SGX-specific instructions, EENTER
> and EEXIT respectively.  EENTER+EEXIT is analogous to SYSCALL+SYSRET,
> e.g. EENTER/SYSCALL load RCX with the next RIP and EEXIT/SYSRET load
> RIP from R{B,C}X.
> 
> But in a faulting/interrupting scenario, enclave transitions act more
> like VM-Exit and VMRESUME.  Maintaining the black box nature of the
> enclave means that hardware must automatically switch CPU context when
> an Asynchronous Exiting Event (AEE) occurs, an AEE being any interrupt
> or exception (exceptions are AEEs because asynchronous in this context
> is relative to the enclave and not CPU execution, e.g. the enclave
> doesn't get an opportunity to save/fuzz CPU state).
> 
> Like VM-Exits, all AEEs jump to a common location, referred to as the
> Asynchronous Exiting Point (AEP).  The AEP is specified at enclave entry
> via register passed to EENTER/ERESUME, similar to how the hypervisor
> specifies the VM-Exit point (via VMCS.HOST_RIP at VMLAUNCH/VMRESUME).
> Resuming the enclave/VM after the exiting event is handled is done via
> ERESUME/VMRESUME respectively.  In SGX, AEEs that are handled by the
> kernel, e.g. INTR, NMI and most page faults, IRET will journey back to
> the AEP which then ERESUMEs th enclave.
> 
> Enclaves also behave a bit like VMs in the sense that they can generate
> exceptions as part of their normal operation that for all intents and
> purposes need to handled in the enclave/VM.  However, unlike VMX, SGX
> doesn't allow the host to modify its guest's, a.k.a. enclave's, state,
> as doing so would circumvent the enclave's security.  So to handle an
> exception, the enclave must first be re-entered through the normal
> EENTER flow (SYSCALL/SYSRET behavior), and then resumed via ERESUME
> (VMRESUME behavior) after the source of the exception is resolved.
> 
> All of the above is just the tip of the iceberg when it comes to running
> an enclave.  But, SGX was designed in such a way that the host process
> can utilize a library to build, launch and run an enclave.  This is
> roughly analogous to how e.g. libc implementations are used by most
> applications so that the application can focus on its business logic.
> 
> The big gotcha is that because enclaves can generate *and* handle
> exceptions, any SGX library must be prepared to handle nearly any
> exception at any time (well, any time a thread is executing in an
> enclave).  In Linux, this means the SGX library must register a
> signal handler in order to intercept relevant exceptions and forward
> them to the enclave (or in some cases, take action on behalf of the
> enclave).  Unfortunately, Linux's signal mechanism doesn't mesh well
> with libraries, e.g. signal handlers are process wide, are difficult
> to chain, etc...  This becomes particularly nasty when using multiple
> levels of libraries that register signal handlers, e.g. running an
> enclave via cgo inside of the Go runtime.
> 
> In comes vDSO to save the day.  Now that vDSO can fixup exceptions,
> add a function, __vdso_sgx_enter_enclave(), to wrap enclave transitions
> and intercept any exceptions that occur when running the enclave.
> 
> __vdso_sgx_enter_enclave() does NOT adhere to the x86-64 ABI and instead
> uses a custom calling convention.  The primary motivation is to avoid
> issues that arise due to asynchronous enclave exits.  The x86-64 ABI
> requires that EFLAGS.DF, MXCSR and FCW be preserved by the callee, and
> unfortunately for the vDSO, the aformentioned registers/bits are not
> restored after an asynchronous exit, e.g. EFLAGS.DF is in an unknown
> state while MXCSR and FCW are reset to their init values.  So the vDSO
> cannot simply pass the buck by requiring enclaves to adhere to the
> x86-64 ABI.  That leaves three somewhat reasonable options:
> 
>   1) Save/restore non-volatile GPRs, MXCSR and FCW, and clear EFLAGS.DF
> 
>      + 100% compliant with the x86-64 ABI
>      + Callable from any code
>      + Minimal documentation required
>      - Restoring MXCSR/FCW is likely unnecessary 99% of the time
>      - Slow
> 
>   2) Save/restore non-volatile GPRs and clear EFLAGS.DF
> 
>      + Mostly compliant with the x86-64 ABI
>      + Callable from any code that doesn't use SIMD registers
>      - Need to document deviations from x86-64 ABI, i.e. MXCSR and FCW
> 
>   3) Require the caller to save/restore everything.
> 
>      + Fast
>      + Userspace can pass all GPRs to the enclave (minus EAX, RBX and RCX)
>      - Custom ABI
>      - For all intents and purposes must be called from an assembly wrapper
> 
> __vdso_sgx_enter_enclave() implements option (3).  The custom ABI is
> mostly a documentation issue, and even that is offset by the fact that
> being more similar to hardware's ENCLU[EENTER/ERESUME] ABI reduces the
> amount of documentation needed for the vDSO, e.g. options (2) and (3)
> would need to document which registers are marshalled to/from enclaves.
> Requiring an assembly wrapper imparts minimal pain on userspace as SGX
> libraries and/or applications need a healthy chunk of assembly, e.g. in
> the enclave, regardless of the vDSO's implementation.
> 
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Haitao Huang <haitao.huang@linux.intel.com>
> Cc: Jethro Beekman <jethro@fortanix.com>
> Cc: Dr. Greg Wettstein <greg@enjellic.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Looks good to me but without testing too early for reviewed-by.This is
fairly easy patch to give it because all the details are  in the
underlying patches.

I think I will test the patch set as soon as I'm done with the new API
changes for v19 i.e. make an updated version of my smoke test program
with the use of this vDSO and the new enclave ioctl API. If that works
I'll give this patch tested-by at that point.

/Jarkko
