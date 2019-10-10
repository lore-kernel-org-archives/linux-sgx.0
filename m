Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10169C10F14
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 23:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3F482190F
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 23:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfJJX7c (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 19:59:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:48032 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbfJJX7c (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 19:59:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 16:59:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="198534474"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 10 Oct 2019 16:59:31 -0700
Date:   Thu, 10 Oct 2019 16:59:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 16/16] x86/vdso: sgx: Rework
 __vdso_sgx_enter_enclave() to prefer "no callback"
Message-ID: <20191010235931.GI23798@linux.intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
 <20191008044613.12350-17-sean.j.christopherson@intel.com>
 <15c03e7e-cd98-5ea2-82a1-a11bec4abe2a@intel.com>
 <20191009191003.GD19952@linux.intel.com>
 <ff6afbe4-1fa9-a632-b5bf-2cdadbb50f37@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff6afbe4-1fa9-a632-b5bf-2cdadbb50f37@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 10, 2019 at 10:49:59AM -0700, Xing, Cedric wrote:
> On 10/9/2019 12:10 PM, Sean Christopherson wrote:
> >On Wed, Oct 09, 2019 at 11:00:55AM -0700, Xing, Cedric wrote:
> >>On 10/7/2019 9:46 PM, Sean Christopherson wrote:
> >>>-	/* Align stack per x86_64 ABI. The original %rsp is saved in %rbx to be
> >>>-	 * restored after the exit handler returns. */
> >>>+
> >>>+	/* Invoke userspace's exit handler if one was provided. */
> >>>+.Lhandle_exit:
> >>>+	cmp	$0, 0x20(%rbp)
> >>>+	jne	.Linvoke_userspace_handler
> >>>+
> >>>+.Lout:
> >>>+	leave
> >>>+	.cfi_def_cfa		%rsp, 8
> >>>+	ret
> >>>+
> >>>+.Linvalid_leaf:
> >>
> >>Please set frame pointer back to %rbp here, or stack unwinding will fail.
> >
> >Sorry, coffee isn't doing it's job, what's getting crushed, and where?
> 
> The frame pointer was %rbp but you changed it to %rsp 3 lines ago. That's
> correct after "leave" and execution won't pass "ret". But the unwinder
> doesn't know. So you have to restore frame pointer after "ret", by
> 	.cfi_def_cfa		%rbp, 16

Isn't the proper fix to move ".cfi_endproc" here?  Which I incorrectly
left after the RET for the retpoline.
 
> As you mentioned in the stack alignment case, we just can't rely on code
> review to catch such bugs. We need a test case to make sure all CFI
> directives are correct, which was also a request from Andy.

On the todo list...

> >>>+.Lhandle_exception:
> >>>+	mov	0x18(%rbp), %rcx
> >>>+	test    %rcx, %rcx
> >>>+	je	.Lskip_exception_info
> >>
> >>A single "jrcxz .Lskip_exception_info" is equivalent to the above 2
> >>instructions combined.
> >
> >Both implementations take a single uop on CPUs that support SGX.  IMO,
> >using the simpler and more common instructions is more universally
> >readable.
> 
> I'm not sure the processor could combine 2 instructions ("test"+"je") into
> just 1 uop. And "jrcxz" is also a broadly used instruction.

TEST+Jcc macrofusion has been supported since Merom (Core 2)[*].  CMP+Jcc
have also been fused since Merom, though not for all Jcc flavors (uarch
specific), whereas TEST can fuse with everything.  Sandy Bridge added
fusing of ADD, SUB, INC, DEC, AND and OR, with AND/OR following TEST
in terms of fusing capabilities, the rest following CMP behavior.

[*] https://en.wikichip.org/wiki/macro-operation_fusion

> >>>+	/* Push @e, u_rsp and @tcs as parameters to the callback. */
> >>>  	push	0x18(%rbp)
> >>>  	push	%rbx
> >>>  	push	0x10(%rbp)
> >>>-	/* Call *%rax via retpoline */
> >>>-	call	40f
> >>>-	/* Restore %rsp to its original value left off by the enclave from last
> >>>-	 * exit */
> >>>+
> >>>+	/* Pass the "return" value to the callback via %rcx. */
> >>>+	mov	%eax, %ecx
> >>
> >>@e (ex_info) is almost always needed by every callback as it also serves as
> >>the "context pointer". The return value on the other hand is insignificant
> >>because it could be deduced from @e->EX_LEAF anyway. So I'd retain %rcx and
> >>push %rax to the stack instead, given the purpose of this patch is to
> >>squeeze out a bit performance.
> >
> >Please take this up in patch 02/16, which actually introduced this change.
> 
> My apology but willing to pull all related discussions into a single thread.
> 
> If you adhere to the convention of "%rcx containing @e", then the code here
> could be
> 	push	%rax		// for stack alignment
> 	push	%rax		// return value
> 	push	%rbx		// u_rsp
> 	push	0x10(%rsp)	// tcs
> 				// %rcx left unchanged pointing to @e

Hmm, I still think it makes sense to have @e as the last parameters since
it's the one thing that's optional.  What if the callback prototype were
instead:

typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
					  long ursp, long r8, long r9,
					  void *tcs, int ret,
					  struct sgx_enclave_exception *e);

I.e. put @ret and @e next to each other since they go hand-in-hand.  For
me, that's visually easies to parse than burying 'int ret' or 'struct ... *e'
in the middle of the prototype.

And the relevant asm:
	/* Push @e, "return" value and @tcs as parameters to the callback. */
	push	0x18(%rbp)
	push	%eax
	push	0x10(%rbp)

	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
	mov	%ebx, %ecx

> >>>+	/* Clear RFLAGS.DF per x86_64 ABI */
> >>>+	cld
> >>>+
> >>>+	/* Load the callback pointer to %rax and invoke it via retpoline. */
> >>>+	mov	0x20(%rbp), %rax
> >>
> >>Per X86_64 ABI, %rsp shall be 16 bytes aligned before "call". But %rsp here
> >>doesn't look aligned properly.
> >
> >Argh, I probably botched it back in patch 02/16 too.  I'll see if I can
> >add a check to verify %rsp alignment in the selftest, verifying via code
> >inspection is bound to be error prone.
> >
> >>>+	call	.Lretpoline
