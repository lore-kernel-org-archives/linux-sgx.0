Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D110C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 19:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EAA120850
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 19:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfCTTNV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 15:13:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:8939 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfCTTNU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 15:13:20 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 12:13:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="330415797"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga005.fm.intel.com with ESMTP; 20 Mar 2019 12:13:18 -0700
Date:   Wed, 20 Mar 2019 12:13:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add
 __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Message-ID: <20190320191318.GF30469@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 20, 2019 at 11:30:26AM -0700, Xing, Cedric wrote:
> > +/**
> > + * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> > + *
> > + * %eax:        ENCLU leaf, must be EENTER or ERESUME
> > + * %rbx:        TCS, must be non-NULL
> > + * %rcx:        Optional pointer to 'struct sgx_enclave_exception'
> > + *
> > + * Return:
> > + *  0 on a clean entry/exit to/from the enclave
> > + *  -EINVAL if ENCLU leaf is not allowed or if TCS is NULL
> > + *  -EFAULT if ENCLU or the enclave faults
> > + *
> > + * Note that __vdso_sgx_enter_enclave() is not compliant with the x86-
> > 64 ABI.
> > + * All registers except RSP must be treated as volatile from the
> > +caller's
> > + * perspective, including but not limited to GPRs, EFLAGS.DF, MXCSR,
> > FCW, etc...
> > + * Conversely, the enclave being run must preserve the untrusted RSP
> > and stack.
> 
> By requiring preservation of RSP at both AEX and EEXIT, this precludes
> the possibility of using the untrusted stack as temporary storage by
> enclaves. While that looks reasonable at first glance, I'm afraid it
> isn't the case in reality. The untrusted stack is inarguably the most
> convenient way for data exchange between an enclave and its enclosing
> process,

I vehemently disagree with "inarguably".  IMO, passing data via registers
is much more convenient.

Even if you qualify your assertion with "data of arbitrary size unknown
at build time", I still disagree.  Using the untrusted stack allows for
trickery when a debugger is involved, other than that I see no advantages
over allocating virtual memory and handing the pointer to the enclave
at launch time.  Sure, it requires a few more lines of code to setup,
but it's literally ~20 LoC out of thousands required to sign, build and
launch an enclave, but it doesn't require playing games with the stack.

Not to mention that the entire concept of using the untrusted stack is
based on the assumption that the enclave is making ocalls, e.g. stateless
enclaves or libraries that use a message queue have zero need/benefit
for using the untrusted stack.

> and is in fact being used for that purpose by almost all existing enclaves
> to date.

That's a bit misleading, since almost all existing enclaves are built
against Intel's SDK, which just so happens to unconditionally use the
untrusted stack.  It's not like all enclave developers made a concious
decision to use the untrusted stack.  If Intel rewrote the SDK to use
a different method then one could argue that the new approach is the
most common method of passing data.

> Given the expectation that this API will be used by all future SGX
> application, it looks unwise to ban the most convenient and commonly
> used approach for data exchange.
> 
> Given an enclave can touch everything (registers and memory) of the
> enclosing process, it's reasonable to restrict the enclave by means
> of "calling convention" to allow the enclosing process to retain its
> context. And for that purpose, SGX ISA does offer 2 registers (i.e.
> RSP and RBP) for applications to choose. Instead of preserving RSP,
> I'd prefer RBP, which will end up with more flexibility in all SGX
> applications in future.

I disagree that the SGX ISA intends for applications to choose between
preserving RSP and RBP, e.g. the SDM description of SSA.UR{B,S}P states:

  Non-Enclave (outside) {RBP,stack} pointer. Saved by EENTER, restored on AEX.

To me, the "Saved/restored" wording implies that URBP and URSP should
*never* be touched by the enclave.  Sure, the proposed vDSO interface
doesn't require RBP to be preserved, but only because the goal was to
deviate from hardware as little as possible, not because anyone wants
to encourage enclaves to muck with RBP.
