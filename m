Return-Path: <SRS0=sJTe=OQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE09C07E85
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 21:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CE8B2083D
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 21:26:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CE8B2083D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbeLGV0v (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Dec 2018 16:26:51 -0500
Received: from mga06.intel.com ([134.134.136.31]:56181 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbeLGV0u (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 7 Dec 2018 16:26:50 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Dec 2018 13:26:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,327,1539673200"; 
   d="scan'208";a="257733408"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga004.jf.intel.com with ESMTP; 07 Dec 2018 13:26:49 -0800
Date:   Fri, 7 Dec 2018 13:26:49 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-sgx@vger.kernel.org, haitao.huang@linux.intel.com,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20181207212649.GG10404@linux.intel.com>
References: <20181206221922.31012-1-sean.j.christopherson@intel.com>
 <20181206221922.31012-5-sean.j.christopherson@intel.com>
 <CALCETrXRJ645=08fyeoMQ949fLB1TvhsgERFVx5mAHdViEjq8Q@mail.gmail.com>
 <20181207165145.GB10404@linux.intel.com>
 <CALCETrVkEW82PzQZhJ5iS849DLY1gbd8YjH5F7P1J7hgjkjiOQ@mail.gmail.com>
 <20181207190257.GC10404@linux.intel.com>
 <EFA99261-BE93-49DA-9A8F-E6FD28069AFC@amacapital.net>
 <20181207200935.GE10404@linux.intel.com>
 <4CEB5945-9562-40FA-8CCA-A1675D55B001@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CEB5945-9562-40FA-8CCA-A1675D55B001@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 07, 2018 at 12:16:59PM -0800, Andy Lutomirski wrote:
> 
> 
> > On Dec 7, 2018, at 12:09 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> >> On Fri, Dec 07, 2018 at 11:23:10AM -0800, Andy Lutomirski wrote:
> >> 
> >> Ah, I see. You’re saying that, if the non-enclave stare is corrupted such
> >> that RIP  is okay and RSP still points somewhere reasonable but the return
> >> address is garbage, then we can at least get to the fault handler and print
> >> something?
> > 
> > Yep.  Even for something more subtle like GPR corruption it could dump the
> > entire call stack before attempting to return back up.
> > 
> >> This only works if the fault handler pointer itself is okay, though, which
> >> somewhat limits the usefulness, given that its pointer is quite likely to
> >> be on the stack very close to the return address.
> > 
> > Yeah, it's not a silver bullet by any means, but it does seem useful for at
> > least some scenarios.  Even exploding when invoking the handler instead of
> > at a random point might prove useful, e.g. "calling my exit handler exploded,
> > maybe my enclave corrupted the stack!".
> 
> Here’s another idea: calculate some little hash or other checksum of
> RSP, RBP, and perhaps a couple words on the stack, and do:

Corrupting RSP and RBP as opposed to the stack memory seems much less
likely since the enclave would have to poke into the save state area.
And as much as I dislike the practice of intentionally manipulating
SSA.RSP, preventing the user from doing something because we're "helping"
doesn't seem right.

> call __vdso_enclave_corrupted_state
> 
> If you get a mismatch after return. That function could be:
> 
> call __vdso_enclave_corrupted_state:
>   ud2
> 
> And now the debug trace makes it very clear what happened.
>
> This may or may not be worth the effort.

Running a checksum on the stack for every exit doesn't seem like it'd
be worth the effort, especially since this type of bug should be quite
rare, at least in production environments.

If we want to pursue the checksum idea I think the easiest approach
would be to combine it with an exit_handler and do a simple check on
the handler.  It'd be minimal overhead in the fast path and would flag
cases where invoking exit_handle() would explode, while deferring all
other checks to the user.

E.g. something like this:

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.c b/arch/x86/entry/vdso/vsgx_enter_enclave.c
index d5145e5c5a54..c89dd3cd8da9 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.c
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.c
@@ -42,10 +42,13 @@ enum sgx_enclu_leaf {
        SGX_EEXIT       = 4,
 };

+#define VDSO_MAGIC 0xa5a5a5a5a5a5a5a5UL
+
 notrace long __vdso_sgx_enter_enclave(u32 op, void *tcs, void *priv,
                                      struct sgx_enclave_exit_info *exit_info,
                                      sgx_enclave_exit_handler *exit_handler)
 {
+       volatile unsigned long hash;
        u64 rdi, rsi, rdx;
        u32 leaf;
        long ret;
@@ -53,6 +56,9 @@ notrace long __vdso_sgx_enter_enclave(u32 op, void *tcs, void *priv,
        if (!tcs || !exit_info)
                return -EINVAL;

+       /* Always hash the handler.  XOR is much cheaper than Jcc. */
+       hash = (unsigned long)exit_handler ^ VDSO_MAGIC;
+
 enter_enclave:
        if (op != SGX_EENTER && op != SGX_ERESUME)
                return -EINVAL;
@@ -107,6 +113,8 @@ notrace long __vdso_sgx_enter_enclave(u32 op, void *tcs, void *priv,
         * or to return (EEXIT).
         */
        if (exit_handler) {
+               if (hash != ((unsigned long)exit_handler ^ VDSO_MAGIC))
+                       asm volatile("ud2\n");
                if (exit_handler(exit_info, tcs, priv)) {
                        op = exit_info->leaf;
                        goto enter_enclave;

> But ISTM the enclave is almost as likely to corrupt the host state and
> the. EEXIT as it is to corrupt the host state and then fault.

Agreed, I would say even more likely.  But the idea is that the
exit_handler is called on any exit, not just exceptions.
