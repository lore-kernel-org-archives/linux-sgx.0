Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244FEC4727F
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 22:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD2E321775
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 22:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgIYWhA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 18:37:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:7317 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgIYWhA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Sep 2020 18:37:00 -0400
IronPort-SDR: I7Qx0bLPtEP4adOzMcNc5nnU5AgKbhWmVYaoNpaHZlDfydqWKAAQWEU3Sh5/5h510aVlz2kOTX
 XlLZq3wai3UA==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="179709977"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="179709977"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 12:09:18 -0700
IronPort-SDR: IXVtPX0NNpvi12RT6yA0+ZjIkN14Y5TI1JI77IKFClWOHXNBb11cn+XVOGv70+YcstuUC4HB1s
 wUin9vuHkwfA==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="455961811"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 12:09:18 -0700
Date:   Fri, 25 Sep 2020 12:09:17 -0700
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
Message-ID: <20200925190915.GD31528@linux.intel.com>
References: <CALCETrUhQjQQa-BqNHPgdDfD9GDJZXJWSQ_M0tDF_ri5RfyTsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUhQjQQa-BqNHPgdDfD9GDJZXJWSQ_M0tDF_ri5RfyTsw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

+Nathaniel, Cedric and linux-sgx

On Fri, Sep 25, 2020 at 09:55:00AM -0700, Andy Lutomirski wrote:
> vdso_sgx_enter_enclave() sucks. I don't think anyone seriously likes
> it, but maybe it's the best we can do.

The code itself sucks, or the API sucks?

For the code, given the constraints of SGX and the number of runtimes we're
enabling, I don't think it's bad at all.  It's not hard to maintain, there are
no horrendous hacks, and it doesn't play games with the caller's state, i.e.
there's no additional magic required.  In other words, I really like that we
have in hand _works_, and works for a variety of runtimes and their ABIs.

The API isn't glorious, but it's not awful either.

> I'm wondering if it's worth trying to do better.  Here's what I'd like
> if I could wave a magic wand:
> 
> struct sgx_enclave_run {
>        __u64 tcs;
>        __u32 flags;
>        __u32 exit_reason;
> 
>     /*
>      * These values are exposed to the enclave on entry, and the values
>      * left behind by the enclave are returned here.
>      * Some enclaves might write to memory pointed to by rsp.
>      */
>        __u64 rsp, rbp, r8, r9, r10, r11, r12, r13, r14, r15;
>        /* Maybe other regs too? */
> 
>        union {
>                struct sgx_enclave_exception exception;
> 
>                /* Pad the entire struct to 256 bytes. */
>                __u8 pad[256 - 32];
>        };
> };
> 
> long vdso_sgx_enter_enclave(unsigned int leaf, struct sgx_enclave_run *r);
> 
> No callback, no asm wrapper needed, no nastiness from the perspective
> of the caller.
> 
> So here are my questions.  First, do people agree with me that this
> would be better?

No?

From a user perspective, I don't find the callback particularly onerous.
Avoiding the callback would yield prettier code for the caller, but IMO it
doesn't fundamentally make the code easier to maintain.  Implementing the
callback is a one-time cost for a relatively small number of people, and it's
not even all that difficult to write, especially compared to all the other crud
that needs to be done to enable SGX.

As for requiring assembly to pass state in r10-r15, IMO that's a non-issue as
it's trivially easy for the runtime/enclave ABI to pass its own params struct,
e.g. my runtime for testing basically does:

int enter_enclave(const long fn, void *params, tcs_t *tcs)
{
	...

	ret = __enter_enclave(fn, (unsigned long)params, 0, EENTER, 0, 0, &run);

	...
}

where __enter_enclave is a function pointer to the vDSO.  The enclave side
looks very similar, e.g. there's a small amount of asm trampoline to invoke
a C function that looks like:

int eenter_handler(const long fn, void *params, void *tcs, int ssa)
{
	...
}

where @params is eventually passed down to the function referenced by @fn.

Actually consuming r10-r15 without assembly of some form is impossible (unless
there's compiler magic of which I'm unaware).  Not to mention that r10-r15 are
especially painful to use because they don't have dedicated input/output
constraints for inline asm.

In other words, I don't see any value in making it easier for the caller to
pass state in r10-r15 (I'm intentionally omitting r8 and r9, because those can
be passed as parameters to the vDSO function, I have no idea why we'd want to
move them into sgx_enclave_run).

So it really comes down to context switching versus using a callback.  Not that
this is exactly a hot path, but for me having to implement a callback versus
bloating the vDSO with state save and restore is a mostly a wash.

> Second, could this be implemented in a way that doesn't utterly suck?  The
> best I've come up with so far is abusing WRFSBASE to shove a little data
> structure containing the real user RSP or RBP along with the old FSBASE into
> FSBASE, do EENTER, and then undo the FSBASE dance.  We'd also need some
> additional exception fixup magic to prevent a signal or ptrace() from
> observing the intermediate states and getting extremely confused.

But where would the vDSO get memory for that little data structure?  It can't
be percpu because the current task can get preempted.  It can't be per instance
of the vDSO because a single mm/process can have multiple tasks entering an
enclave.  Per task might work, but how would the vDSO get that info?  E.g.
via a syscall, which seems like complete overkill?

So, no?

If we truly want to provide a "better" vDSO, my vote would be to disallow using
the runtime's stack from within the enclave.  But I'm guessing that would cause
more than a few aneurysms for the folks that are cc'd :-)
