Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA961C433E2
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7B82065E
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbgIDKZU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 06:25:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:58523 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgIDKZK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 06:25:10 -0400
IronPort-SDR: gp8ItdPFM+mkpH/uDzRnI/e3nr5BkKeuzkFCpIePkITFNWnWbnp+mgAlN9f4J5/jRt7XhS/es+
 G1eE/UThXuRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="155221480"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="155221480"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 03:25:09 -0700
IronPort-SDR: wGuTtWR3xVOhcnkC0iDGbi7l1WI3gWK8E7soomQMBAN3CDAZ2gCovjrM2UpQdImBVzJGA2kxXQ
 r0DEZPjwVgWA==
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="342146562"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 03:25:08 -0700
Date:   Fri, 4 Sep 2020 03:25:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
Message-ID: <20200904102507.GA8435@sjchrist-ice>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
 <74e185a6-909a-af54-9a09-e8f9c8809703@fortanix.com>
 <20200824194941.GC7391@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200824194941.GC7391@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 24, 2020 at 10:49:41PM +0300, Jarkko Sakkinen wrote:
> On Mon, Aug 24, 2020 at 03:36:11PM +0200, Jethro Beekman wrote:
> > On 2020-08-18 06:24, Sean Christopherson wrote:
> > >  /**
> > >   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> > > @@ -119,16 +153,14 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
> > >   * @leaf:	ENCLU leaf, must be EENTER or ERESUME
> > >   * @r8:		Pass-through value for R8
> > >   * @r9:		Pass-through value for R9
> > > - * @tcs:	TCS, must be non-NULL
> > > - * @e:		Optional struct sgx_enclave_exception instance
> > > - * @handler:	Optional enclave exit handler
> > > + * @r:		struct sgx_enclave_run, must be non-NULL
> > >   *
> > >   * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance with the
> > > - * x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.  Except for
> > > - * non-volatile general purpose registers, preserving/setting state in
> > > - * accordance with the x86-64 ABI is the responsibility of the enclave and its
> > > - * runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C code
> > > - * without careful consideration by both the enclave and its runtime.
> > > + * x86-64 ABI, e.g. doesn't handle XSAVE state.  Except for non-volatile
> > > + * general purpose registers, EFLAGS.DF, and RSP alignment, preserving/setting
> > > + * state in accordance with the x86-64 ABI is the responsibility of the enclave
> > > + * and its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C
> > > + * code without careful consideration by both the enclave and its runtime.
> > >   *
> > >   * All general purpose registers except RAX, RBX and RCX are passed as-is to
> > >   * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME and are
> > > @@ -160,16 +192,12 @@ typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx,
> > >   * without returning to __vdso_sgx_enter_enclave().
> > >   *
> > >   * Return:
> > > - *  0 on success,
> > > + *  0 on success (ENCLU reached),
> > >   *  -EINVAL if ENCLU leaf is not allowed,
> > > - *  -EFAULT if an exception occurs on ENCLU or within the enclave
> > > - *  -errno for all other negative values returned by the userspace exit handler
> > >   */
> > >  typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned long rsi,
> > >  					unsigned long rdx, unsigned int leaf,
> > >  					unsigned long r8,  unsigned long r9,
> > > -					void *tcs,
> > > -					struct sgx_enclave_exception *e,
> > > -					sgx_enclave_exit_handler_t handler);
> > > +					struct sgx_enclave_run *r);
> > >  
> > >  #endif /* _UAPI_ASM_X86_SGX_H */
> > > 
> > 
> > I think this should return void now, not int? Then, the “return”
> > section of the documentation is also no longer correct.
> 
> This documentation should be moved to Documentation/x86/sgx.rst.
> 
> It is easier to read from there and then it will be included by kdoc
> to the kernel documentation. In here it is not addressed by kdoc and
> it is unnecessarily hard to read.

I'm confused, this is all picked up by kernel-doc.  What am I missing?
