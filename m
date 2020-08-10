Return-Path: <SRS0=jFLL=BU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA72AC433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Aug 2020 22:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A08A920771
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Aug 2020 22:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgHJWXT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Aug 2020 18:23:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:40994 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgHJWXT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Aug 2020 18:23:19 -0400
IronPort-SDR: jpSUw0JUhL4fbTDqzvqaR/zcfpnsRgwBun7X8LXnrscs8QbHFJgIiWw3qjQpAi+2c0Fk9QaYJO
 7ek2D8Kiwe4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="217964118"
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="217964118"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 15:23:18 -0700
IronPort-SDR: 7+KrvBfTIme7Zi1E3P9lVDw9BZMKSX+w/7pcZDA1CRdd45fe869813rFS4tDVFnUK3yJ0RRiJQ
 kGvfDHQ2HJHw==
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="294530611"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 15:23:18 -0700
Date:   Mon, 10 Aug 2020 15:23:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>, kai.huang@intel.com,
        "Svahn, Kai" <kai.svahn@intel.com>, kmoy@google.com,
        ludloff@google.com, luto@kernel.org,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200810222317.GG14724@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 06, 2020 at 10:55:43AM -0400, Nathaniel McCallum wrote:
> In a past revision of this patch, I had requested a void *misc
> parameter that could be passed through vdso_sgx_enter_enclave_t into
> sgx_enclave_exit_handler_t. This request encountered some push back
> and I dropped the issue. However, I'd like to revisit it or something
> similar.
> 
> One way to create a generic interface to SGX is to pass a structure
> that captures the relevant CPU state from the handler so that it can
> be evaluated in C code before reentry. Precedent for this approach can
> be found in struct kvm_run[0]. Currently, however, there is no way to
> pass a pointer to such a structure directly into the handler.

The context switching aspect of kvm_run isn't a great template.  kvm_run
allows the VMM to get/set a limited amount of vCPU state without having to
invoke separate ioctls(), i.e. it's it's purely an optimization.  KVM also
needs to context switch guests state regardless of the ability to get/set
state via kvm_run, whereas this vDSO case doesn't _need_ to insert itself
between the runtime and its enclave.

The flow control and exit reporting aspect of kvm_run are relevant though.
More thoughts on that part at the end.

> This can be done implicitly by wrapping the struct
> sgx_enclave_exception in another structure and then using techniques
> like container_of() to find another field. However, this is made more
> difficult by the fact that the sgx_enclave_exit_handler_t is not
> really using the x86_64 sysv calling convention. Therefore, the
> sgx_enclave_exit_handler_t MUST be written in assembly.

What bits of the x86-64 ABI require writing the handler in assembly?  There
are certainly restrictions on what the handler can do without needing an
assembly trampoline, but I was under the impression that vanilla C code is
compatible with the exit handler patch.  Is Rust more picky about calling
convention?

Side topic, the documentation for vdso_sgx_enter_enclave_t is wrong, it
states the EFLAGS.DF is not cleared before invoking the handler, but that's
a lie.

> This also implies that we can't use techniques like container_of() and must
> calculate all the offsets manually, which is tedious, error prone and
> fragile.
> 
> This is further complicated by the fact that I'm using Rust (as are a
> number of other consumers), which has no native offsetof support (yes,
> there is a crate for it, but it requires a number of complex
> strategies to defeat the compiler which aren't great) and therefore no
> container_of() support.
> 
> We could design a standard struct for this (similar to struct
> kvm_run). But in order to keep performance in check we'd have to
> define a limited ABI surface (to avoid things like xsave) which
> wouldn't have the full flexibility of the current approach. This would
> allow for a kernel provided vDSO function with a normal calling
> convention, however (which does have some non-trivial value). I think
> this is a trade-off we should consider (perhaps making it optional?).
> 
> But at the least, allowing a pass-through void *misc would reduce the
> complexity of the assembly calculations.

I'm not opposed to adding a pass-through param, it's literally one line
and an extra PUSH <mem> in the exit handler path. 

Another thought would be to wrap sgx_enclave_exception in a struct to give
room for supporting additional exit information (if such a thing ever pops
up) and to allow the caller to opt in to select behavior, e.g. Jethro's
request to invoke the exit handler on IRQ exits.  This is basically the
equivalent of "struct kvm_run", minus the vCPU/enclave state.

Such a struct could also be used to avoid using -EFAULT for the "fault in
enclave" exit path, which I believe Andy isn't a fan of, by having an
explicit "exit_reason" field with arbitrary, dedicated exit codes, and
defining "success" as making it to ENCLU, i.e. returning '0' when there is
no exit handler if ENCLU is attempted.

E.g.:

struct sgx_enter_enclave {
        __u64 tcs;
        __u64 flags;

	__u32 exit_leaf;	/* output only */
	__u32 exit_reason;

	__u64 user_handler;
	__u64 user_data;

        union {
                struct sgx_enclave_exception {
                        __u16 trapnr;
                        __u16 error_code;
                        __u32 reserved32;
                        __u64 address;
                };

                __u8 pad[256];  /* 100% arbitrary */
        };
}

typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
                                        unsigned long rdx, unsigned int leaf,
                                        unsigned long r8,  unsigned long r9,
                                        struct sgx_enter_enclave *e);


The exit handler could then be:

typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
                                          long ursp, long r8, long r9,
                                          struct sgx_enter_enclave *e);

or if Rust doesn't like casting user_data:

typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
                                          long ursp, long r8, long r9,
                                          struct sgx_enter_enclave *e
					  void *user_data);
