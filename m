Return-Path: <SRS0=VWZs=CC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027DDC433E1
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Aug 2020 19:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00BB20738
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Aug 2020 19:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgHXTtp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Aug 2020 15:49:45 -0400
Received: from mga07.intel.com ([134.134.136.100]:61479 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgHXTtp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Aug 2020 15:49:45 -0400
IronPort-SDR: ZJuub4AvF2Mgnzs1e4Hm4+1JLidOXCOkP4cAXGQYvXeD/0zzvfgGpmhaPecemZgsWTq5GH5bL2
 G5UYuETtJ5cg==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="220246904"
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="220246904"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 12:49:44 -0700
IronPort-SDR: JKgUgdZEoko5dHOhsIlKkreqI7izLetk5egI1o+s7O5I4w7kHggrL/F0bpqid5B+BSTL149vOw
 uI6+9pGissfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="322463095"
Received: from skapitza-mobl.ger.corp.intel.com (HELO localhost) ([10.252.54.25])
  by fmsmga004.fm.intel.com with ESMTP; 24 Aug 2020 12:49:43 -0700
Date:   Mon, 24 Aug 2020 22:49:41 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
Message-ID: <20200824194941.GC7391@linux.intel.com>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
 <74e185a6-909a-af54-9a09-e8f9c8809703@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74e185a6-909a-af54-9a09-e8f9c8809703@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 24, 2020 at 03:36:11PM +0200, Jethro Beekman wrote:
> On 2020-08-18 06:24, Sean Christopherson wrote:
> >  /**
> >   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> > @@ -119,16 +153,14 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
> >   * @leaf:	ENCLU leaf, must be EENTER or ERESUME
> >   * @r8:		Pass-through value for R8
> >   * @r9:		Pass-through value for R9
> > - * @tcs:	TCS, must be non-NULL
> > - * @e:		Optional struct sgx_enclave_exception instance
> > - * @handler:	Optional enclave exit handler
> > + * @r:		struct sgx_enclave_run, must be non-NULL
> >   *
> >   * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance with the
> > - * x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.  Except for
> > - * non-volatile general purpose registers, preserving/setting state in
> > - * accordance with the x86-64 ABI is the responsibility of the enclave and its
> > - * runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
> > - * without careful consideration by both the enclave and its runtime.
> > + * x86-64 ABI, e.g. doesn't handle XSAVE state.  Except for non-volatile
> > + * general purpose registers, EFLAGS.DF, and RSP alignment, preserving/setting
> > + * state in accordance with the x86-64 ABI is the responsibility of the enclave
> > + * and its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C
> > + * code without careful consideration by both the enclave and its runtime.
> >   *
> >   * All general purpose registers except RAX, RBX and RCX are passed as-is to
> >   * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME and are
> > @@ -160,16 +192,12 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
> >   * without returning to __vdso_sgx_enter_enclave().
> >   *
> >   * Return:
> > - *  0 on success,
> > + *  0 on success (ENCLU reached),
> >   *  -EINVAL if ENCLU leaf is not allowed,
> > - *  -EFAULT if an exception occurs on ENCLU or within the enclave
> > - *  -errno for all other negative values returned by the userspace exit handler
> >   */
> >  typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
> >  					unsigned long rdx, unsigned int leaf,
> >  					unsigned long r8,  unsigned long r9,
> > -					void *tcs,
> > -					struct sgx_enclave_exception *e,
> > -					sgx_enclave_exit_handler_t handler);
> > +					struct sgx_enclave_run *r);
> >  
> >  #endif /* _UAPI_ASM_X86_SGX_H */
> > 
> 
> I think this should return void now, not int? Then, the “return”
> section of the documentation is also no longer correct.

This documentation should be moved to Documentation/x86/sgx.rst.

It is easier to read from there and then it will be included by kdoc
to the kernel documentation. In here it is not addressed by kdoc and
it is unnecessarily hard to read.

> --
> Jethro Beekman | Fortanix

/Jarkko
