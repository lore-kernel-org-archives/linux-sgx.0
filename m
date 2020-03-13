Return-Path: <SRS0=tI1m=46=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B6FC2BB1D
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 16:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 914622072C
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 16:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgCMQqX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 13 Mar 2020 12:46:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:18929 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbgCMQqX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 13 Mar 2020 12:46:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Mar 2020 09:46:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,549,1574150400"; 
   d="scan'208";a="243428918"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 13 Mar 2020 09:46:22 -0700
Date:   Fri, 13 Mar 2020 09:46:22 -0700
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
Message-ID: <20200313164622.GC5181@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <254f1e35-4302-e55f-c00d-0f91d9503498@fortanix.com>
 <CAOASepOm8-2UCdEnVMopEprMGWjkYUbUTX++dHaqCafi2ju8mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepOm8-2UCdEnVMopEprMGWjkYUbUTX++dHaqCafi2ju8mA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 13, 2020 at 11:48:54AM -0400, Nathaniel McCallum wrote:
> Thinking about this more carefully, I still think that at least part
> of my critique still stands.
> 
> __vdso_sgx_enter_enclave() doesn't use the x86-64 ABI. This means that
> there will always be an assembly wrapper for
> __vdso_sgx_enter_enclave(). But because __vdso_sgx_enter_enclave()
> doesn't save %rbx, the wrapper is forced to in order to be called from
> C.
> 
> A common pattern for the wrapper will be to do something like this:
> 
> # void enter_enclave(rdi, rsi, rdx, unused, r8, r9, @tcs, @e,
> @handler, @leaf, @vdso)
> enter_enclave:
>     push %rbx
>     push $0 /* align */
>     push 0x48(%rsp)
>     push 0x48(%rsp)
>     push 0x48(%rsp)
> 
>     mov 0x70(%rsp), %eax
>     call *0x68(%rsp)
> 
>     add $0x20, %rsp
>     pop %rbx
>     ret
> 
> Because __vdso_sgx_enter_enclave() doesn't preserve %rbx, the wrapper
> is forced to reposition stack parameters in a performance-critical
> path. On the other hand, if __vdso_sgx_enter_enclave() preserved %rbx,
> you could implement the above as:
> 
> # void enter_enclave(rdi, rsi, rdx, unused, r8, r9, @tcs, @e,
> @handler, @leaf, @vdso)
> enter_enclave:
>     mov 0x20(%rsp), %eax
>     jmp *0x28(%rsp)
> 
> This also implies that if __vdso_sgx_enter_enclave() took @leaf as a
> stack parameter and preserved %rbx, it would be x86-64 ABI compliant
> enough to call from C if the enclave preserves all callee-saved
> registers besides %rbx (Enarx does).
> 
> What are the downsides of this approach? It also doesn't harm the more
> extended case when you need to use an assembly wrapper to setup
> additional registers. This can still be done. It does imply an extra
> push and mov instruction. But because there are currently an odd
> number of stack function parameters, the push also removes an
> alignment instruction where the stack is aligned before the call to
> __vdso_sgx_enter_enclave() (likely). Further, the push and mov are
> going to be performed by *someone* in order to call
> __vdso_sgx_enter_enclave() from C.
> 
> Therefore, I'd like to propose that __vdso_sgx_enter_enclave():
>   * Preserve %rbx.

At first glance, that looks sane.  Being able to call __vdso... from C
would certainly be nice.

>   * Take the leaf as an additional stack parameter instead of passing
> it in %rax.

Does the leaf even need to be a stack param?  Wouldn't it be possible to
use %rcx as @leaf instead of @unusued?  E.g.

int __vdso_sgx_enter_enclave(unsigned long rdi, unsigned long rsi,
			     unsigned long rdx, unsigned int leaf,
			     unsigned long r8,  unsigned long r9,
			     void *tcs, struct sgx_enclave_exception *e,
			     sgx_enclave_exit_handler_t handler)
{
	push	%rbp
	mov	%rsp, %rbp
	push	%rbx

	mov	%ecx, %eax
.Lenter_enclave
	cmp	$0x2, %eax
	jb	.Linvalid_leaf
	cmp	$0x3, %eax
	ja	.Linvalid_leaf

	mov	0x0x10(%rbp), %rbx
	lea	.Lasync_exit_pointer(%rip), %rcx

.Lasync_exit_pointer:
.Lenclu_eenter_eresume:
	enclu

	xor	%eax, %eax

.Lhandle_exit:
	cmp	$0, 0x20(%rbp)
	jne	.Linvoke_userspace_handler

.Lout
	pop	%rbx
	leave
	ret
}
		

> Then C can call it without additional overhead. And people who need to
> "extend" the C ABI can still do so.
> 
