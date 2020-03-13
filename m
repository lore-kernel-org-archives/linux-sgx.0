Return-Path: <SRS0=tI1m=46=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20BEC10DCE
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 00:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A22ED20716
	for <linux-sgx@archiver.kernel.org>; Fri, 13 Mar 2020 00:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgCMAwy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Mar 2020 20:52:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:16259 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgCMAwy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Mar 2020 20:52:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 17:52:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="243215849"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 12 Mar 2020 17:52:53 -0700
Date:   Thu, 12 Mar 2020 17:52:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200313005252.GA1292@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepO2=KCzT+wdXWz2tUNvi6NyzNJ3KwvBMtH_P1TO8Yr_mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepO2=KCzT+wdXWz2tUNvi6NyzNJ3KwvBMtH_P1TO8Yr_mQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 11, 2020 at 03:30:44PM -0400, Nathaniel McCallum wrote:
> On Tue, Mar 3, 2020 at 6:40 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > + * The exit handler's return value is interpreted as follows:
> > + *  >0:                continue, restart __vdso_sgx_enter_enclave() with @ret as @leaf
> > + *   0:                success, return @ret to the caller
> > + *  <0:                error, return @ret to the caller
> > + *
> > + * The userspace exit handler is responsible for unwinding the stack, e.g. to
> > + * pop @e, u_rsp and @tcs, prior to returning to __vdso_sgx_enter_enclave().
> 
> Unless I misunderstand, this documentation...

Hrm, that does appear wrong.  I'm guessing that was leftover from a previous
incarnation of the code.  Or I botched the description, which is just as
likely.

> > + * The exit handler may also transfer control, e.g. via longjmp() or a C++
> > + * exception, without returning to __vdso_sgx_enter_enclave().
> > + *
> > + * Return:
> > + *  0 on success,
> > + *  -EINVAL if ENCLU leaf is not allowed,
> > + *  -EFAULT if an exception occurs on ENCLU or within the enclave
> > + *  -errno for all other negative values returned by the userspace exit handler
> > + */

...

> > +       /* Load the callback pointer to %rax and invoke it via retpoline. */
> > +       mov     0x20(%rbp), %rax
> > +       call    .Lretpoline
> > +
> > +       /* Restore %rsp to its post-exit value. */
> > +       mov     %rbx, %rsp
> 
> ... doesn't seem to match this code.
> 
> If the handler pops from the stack and then we restore the stack here,
> the handler had no effect.
> 
> Also, one difference between this interface and a raw ENCLU[EENTER] is
> that we can't pass arguments on the untrusted stack during EEXIT. If
> we want to support that workflow, then we need to allow the ability
> for the handler to pop "additional" values without restoring the stack
> pointer to the exact value here.

> Also, one difference between this interface and a raw ENCLU[EENTER] is
> that we can't pass arguments on the untrusted stack during EEXIT. If
> we want to support that workflow, then we need to allow the ability
> for the handler to pop "additional" values without restoring the stack
> pointer to the exact value here.

The callback shenanigans exist precisely to allow passing arguments on the
untrusted stack.  The vDSO is very careful to preserve the stack memory
above RSP, and to snapshot RSP at the time of exit, e.g. the arguments in
memory and their addresses relative to u_rsp live across EEXIT.  It's the
same basic concept as regular function calls, e.g. the callee doesn't pop
params off the stack, it just knows what addresses relative to RSP hold
the data it wants.  The enclave, being the caller, is responsible for
cleaning up u_rsp.

FWIW, if the handler reaaaly wanted to pop off the stack, it could do so,
fixup the stack, and then re-call __vdso_sgx_enter_enclave() instead of
returning (to the original __vdso_sgx_enter_enclave()).

> > +       /*
> > +        * If the return from callback is zero or negative, return immediately,
> > +        * else re-execute ENCLU with the postive return value interpreted as
> > +        * the requested ENCLU leaf.
> > +        */
> > +       cmp     $0, %eax
> > +       jle     .Lout
> > +       jmp     .Lenter_enclave
> > +
> > +.Lretpoline:
> > +       call    2f
> > +1:     pause
> > +       lfence
> > +       jmp     1b
> > +2:     mov     %rax, (%rsp)
> > +       ret
> > +       .cfi_endproc
> > +
> > +_ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
