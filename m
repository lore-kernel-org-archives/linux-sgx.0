Return-Path: <SRS0=odJq=OX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B305C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 15:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE59F206BA
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Dec 2018 15:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbeLNPMG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Dec 2018 10:12:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:20686 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730324AbeLNPMG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Dec 2018 10:12:06 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Dec 2018 07:12:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,353,1539673200"; 
   d="scan'208";a="109538652"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga008.fm.intel.com with ESMTP; 14 Dec 2018 07:12:04 -0800
Date:   Fri, 14 Dec 2018 07:12:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v4 5/5] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20181214151204.GA22063@linux.intel.com>
References: <20181213213135.12913-1-sean.j.christopherson@intel.com>
 <20181213213135.12913-6-sean.j.christopherson@intel.com>
 <cda13cff-1a56-a40f-7d69-f0f1ab752f8e@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cda13cff-1a56-a40f-7d69-f0f1ab752f8e@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 14, 2018 at 09:55:49AM +0000, Jethro Beekman wrote:
> On 2018-12-14 03:01, Sean Christopherson wrote:
> >+struct sgx_enclave_regs {
> >+	__u64 rdi;
> >+	__u64 rsi;
> >+	__u64 rdx;
> >+	__u64 r8;
> >+	__u64 r9;
> >+	__u64 r10;
> >+};
> 
> This is fine, but why not just cover all 13 normal registers that are not
> used by SGX?

Trying to balance flexibility/usability with unecessary overhead.  And I
think this ABI meshes well with the idea of requiring the enclave to be
compliant with the x86-64 ABI (see below).

> Minor comments below.
> 
> >+/**
> >+ * struct sgx_enclave_exception - structure to pass register in/out of enclave
> 
> Typo in struct name.

Doh, thanks.
 
> >+ *				  by way of __vdso_sgx_enter_enclave
> >+ *
> >+ * @rdi:	value of %rdi, loaded/saved on enter/exit
> >+ * @rsi:	value of %rsi, loaded/saved on enter/exit
> >+ * @rdx:	value of %rdx, loaded/saved on enter/exit
> >+ * @r8:		value of %r8, loaded/saved on enter/exit
> >+ * @r9:		value of %r9, loaded/saved on enter/exit
> >+ * @r10:	value of %r10, loaded/saved on enter/exit
> >+ */
> 
> >+	/* load leaf, TCS and AEP for ENCLU */
> >+	mov	%edi,      %eax
> >+	mov	%rsi,      %rbx
> >+	lea	1f(%rip),  %rcx
> 
> If you move this below the jump, you can use %rcx for @regs

EDI needs to be moved to EAX before it is potentially overwritten
below and I wanted the loading of the three registers used by hardware
grouped together.  And IMO using the same register for accessing the
structs in all flows improves readability.

> >+
> >+	/* optionally copy @regs to registers */
> >+	test	%rdx, %rdx
> >+	je	1f
> >+
> >+	mov	%rdx, %r11
> >+	mov	RDI(%r11), %rdi
> >+	mov	RSI(%r11), %rsi
> >+	mov	RDX(%r11), %rdx
> >+	mov	R8(%r11),  %r8
> >+	mov	R9(%r11),  %r9
> >+	mov	R10(%r11), %r10
> >+
> >+1:      enclu
> >+
> >+	/* ret = 0 */
> >+	xor	%eax, %eax
> >+
> >+	/* optionally copy registers to @regs */
> >+	mov	-0x8(%rsp), %r11
> >+	test	%r11, %r11
> >+	je	2f
> >+
> >+	mov	%rdi, RDI(%r11)
> >+	mov	%rsi, RSI(%r11)
> >+	mov	%rdx, RDX(%r11)
> >+	mov	%r8,  R8(%r11)
> >+	mov	%r9,  R9(%r11)
> >+	mov	%r10, R10(%r11)
> 
> Here you can use %rax for @regs and clear it at the end.

Clearing RAX early avoids the use of another label, though obviously
that's not exactly critical.  The comment about using the same register
for accessing structs applies here as well.

> >+2:	pop	%rbx
> >+	pop	%r12
> >+	pop	%r13
> >+	pop	%r14
> >+	pop	%r15
> >+	pop	%rbp
> >+	ret
> 
> x86-64 ABI requires that you call CLD here (enclave may set it).

Ugh.  Technically MXCSR and the x87 CW also need to be preserved.

What if rather than treating the enclave as hostile we require it to be
compliant with the x86-64 ABI like any other function?  That would solve
the EFLAGS.DF, MXCSR and x87 issues without adding unnecessary overhead.
And we wouldn't have to save/restore R12-R15.  It'd mean we couldn't use
the stack's red zone to hold @regs and @e, but that's poor form anyways.

> 
> --
> Jethro Beekman | Fortanix
> 

