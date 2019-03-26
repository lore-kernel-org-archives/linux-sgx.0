Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265CEC43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 21:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E8D206DF
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 21:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbfCZV53 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 17:57:29 -0400
Received: from mga17.intel.com ([192.55.52.151]:60469 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfCZV53 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 17:57:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 14:57:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,274,1549958400"; 
   d="scan'208";a="156056825"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga004.fm.intel.com with ESMTP; 26 Mar 2019 14:57:27 -0700
Date:   Tue, 26 Mar 2019 14:57:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v19,RESEND 08/27] x86/cpu/intel: Detect SGX support and
 update caps appropriately
Message-ID: <20190326215727.GG3757@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-9-jarkko.sakkinen@linux.intel.com>
 <1553602654.17255.15.camel@intel.com>
 <20190326142719.GC3757@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989356F307D@PGSMSX112.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <105F7BF4D0229846AF094488D65A0989356F307D@PGSMSX112.gar.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 26, 2019 at 02:25:52PM -0700, Huang, Kai wrote:
> > 
> > That being said, this in no way impacts KVM's ability to virtualize SGX, e.g.
> > KVM can directly do CPUID and {RD,WR}MSR to probe the capabilities of the
> > platform as needed.
> 
> I am not following. KVM can do whatever it wants, but it cannot change the
> fact that KVM guest cannot run intel enclave if platform's MSRs are
> configured to 3rd party and locked.
> 
> Or am I misunderstanding?

What does that have to do with this patch?  The only thing this patch does
is clear a *software* bit that says "SGX LC is enabled" so that the kernel
can make the reasonable assumption that the MSRs are writable when
X86_FEATURE_SGX_LC=1.

> 
> > 
> > > My opition is we already have enough cases that violates HW behavior
> > > in SGX virtualization, let's not have one more.
> > 
> > What are the other cases?
> 
> One example is EPCM + EPC should be power of 2.

Again, that's a micro-architecture detail due to the use of range registers
to carve out the EPC.  The only thing the SDM states regarding size and
alignment is:

  The EPC is divided into EPC pages. An EPC page is 4KB in size and always
  aligned on a 4KB boundary.

> And EPC migration (sudden loss of EPC).

Unfortunate, yes, but it does not violate the architecture in any way.
You can argue that it adds a wrinkle that isn't explicitly documented
in the SDM, but virtualization is full of things like that.

> And if we apply some policy to restrict enclave during EINIT trap, etc.
>
> But those are not the point. I should probably have not mentioned them.
> 
> > 
> > > Besides, why do we "need an additional flag to track whether or not
> > > Launch Control is truly enabled"? Doesn't driver only need to know
> > > whether MSRs are writable?
> > 
> > Yes, and that's why we're overloading X86_FEATURE_SGX_LC to be set if and
> > only if SGX_LC is supported *and* enabled, e.g. so that the kernel can simply
> > check X86_FEATURE_SGX_LC without having to also probe the MSRs.
> 
> OK.
> 
> But IMO if what I mentioned above is correct, then that part should
> overweight the benefit you can get here.

Half dozen of one, six of the other.  If we clear the flag, then KVM has
to manually probe the MSRs.  If we don't clear the flag, then the driver
has to manually probe the MSRs.

Alternatively we could add another flag, but then we end up with
X86_FEATURE_SGX_LC and X86_FEATURE_SGX_LE_PUBKEY_HASH_WRITABLE, or maybe
X86_FEATURE_SGX_LC_REALLY_TRULY_ENABLED.

> 
> Anyway who cares to do less/more thing in driver probe?

Exactly.  KVM will probe the MSRs once during its own loading.
