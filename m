Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A514C4332B
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58B6C20768
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgCSBDJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 21:03:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:15997 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSBDI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 21:03:08 -0400
IronPort-SDR: UDarT0/D/mTUCwecBuFy32V5q6u2OVguKKwZO/R5comHwo7QHJFjRJzkXUgig5dXe+4XWRoNTG
 4AT+xjx+B/Dw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 18:03:07 -0700
IronPort-SDR: CGUYWfkphOuI4TIm7YiOkLmPVqj85z7yp25k0oamOOD/R+j1F8nhSgN8bm9EUnvY4ZnaYA4Y3C
 1ot4B9TZezhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="238348272"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 18 Mar 2020 18:03:06 -0700
Date:   Wed, 18 Mar 2020 18:03:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200319010306.GA8347@linux.intel.com>
References: <254f1e35-4302-e55f-c00d-0f91d9503498@fortanix.com>
 <CAOASepOm8-2UCdEnVMopEprMGWjkYUbUTX++dHaqCafi2ju8mA@mail.gmail.com>
 <20200313164622.GC5181@linux.intel.com>
 <CAOASepN1hxSgxVJAJiAbSmuCTCHd=95Mnvh6BKNSPJs=EpAmbQ@mail.gmail.com>
 <20200313184452.GD5181@linux.intel.com>
 <CAOASepP_oGOenjCvAvLg+e+=fz4H0X=cyD+v5ywD0peeXEEmYg@mail.gmail.com>
 <20200313220820.GE5181@linux.intel.com>
 <CAOASepMicT6CrYyDkoYizh4nAZ+1Zn4rGQh7QjfzSK72Fj6u_g@mail.gmail.com>
 <20200318234057.GE26164@linux.intel.com>
 <858d19ed-868b-b4be-cbac-6cb92349d8fb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <858d19ed-868b-b4be-cbac-6cb92349d8fb@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 18, 2020 at 05:38:29PM -0700, Xing, Cedric wrote:
> On 3/18/2020 4:40 PM, Sean Christopherson wrote:
> %rbx can always be restored as long as it is saved at a fixed offset from
> %rbp. For example, given the standard prolog below:
> 
> 	push	%rbp
> 	mov	%rsp, %rbp
> 	push	%rbx
> 
> It can be paired with the following standard epilog:
> 
> 	mov	-8(%rbp), %rbx
> 	leave
> 	ret
> 
> Alternatively, given "red zone" of 128 bytes, the following epilog will also
> work:
> 
> 	leave
> 	mov	-0x10(%rsp), %rbx
> 	ret
> 
> In no cases do we have to worry about enclave mucking the stack as long as
> %rbp is preserved.
> 
> >>>>While this is more work, it is standard calling convention work that
> >>>>doesn't require internal knowledge of __vdso..(). Alternatively, if we
> >>>>don't like the extra work, we can document the %rbx hack explicitly
> >>>>into the handler documentation and make it part of the interface. But
> >>>>we need some explicit way for the handler to pop enclave output stack
> >>>>params that doesn't depend on internal knowledge of the __vdso...()
> >>>>invariants.
> >>>
> >>>IIUC, this is what you're suggesting?  Having to align the stack makes this
> >>>a bit annoying, but it's not bad by any means.
> >>>
> >>>diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >>>index 94a8e5f99961..05d54f79b557 100644
> >>>--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >>>+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> >>>@@ -139,8 +139,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> >>>         /* Pass the untrusted RSP (at exit) to the callback via %rcx. */
> >>>         mov     %rsp, %rcx
> >>>
> >>>-       /* Save the untrusted RSP in %rbx (non-volatile register). */
> >>>+       /* Save the untrusted RSP offset in %rbx (non-volatile register). */
> >>>         mov     %rsp, %rbx
> >>>+       and     $0xf, %rbx
> >>>
> >>>         /*
> >>>          * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned
> >>>@@ -161,8 +162,8 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> >>>         mov     0x20(%rbp), %rax
> >>>         call    .Lretpoline
> >>>
> >>>-       /* Restore %rsp to its post-exit value. */
> >>>-       mov     %rbx, %rsp
> >>>+       /* Undo the post-exit %rsp adjustment. */
> >>>+       lea     0x20(%rsp,%rbx), %rsp
> >>>
> 
> Per discussion above, this is useful only if the enclave has problem
> cleaning up its own mess left on the untrusted stack, and the exit handler
> wants to EENTER the enclave again by returning to __vdso...(). It sounds
> very uncommon to me, and more like a bug than an expected behavior. Are
> there any existing code doing this or any particular application that needs
> this. If no, I'd say not to do it.

Ya, I'm on the fence as well.  The only counter-argument is that doing:

	push	%rbp
	mov	%rsp, %rbp
	push	%rbx

	...

	pop	%rbx
	leave
	ret

with the relative adjustment would allow the exit handler (or enclave) to
change %rbx.  I'm not saying that is remote sane, but if we're going for
maximum flexibility...

Anyways, patches incoming, let's discuss there.
