Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1208DC43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 14:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0FB120857
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 14:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731595AbfCZO1V (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 10:27:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:17908 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfCZO1V (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 10:27:21 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 07:27:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,271,1549958400"; 
   d="scan'208";a="144036064"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Mar 2019 07:27:19 -0700
Date:   Tue, 26 Mar 2019 07:27:19 -0700
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
Message-ID: <20190326142719.GC3757@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-9-jarkko.sakkinen@linux.intel.com>
 <1553602654.17255.15.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553602654.17255.15.camel@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 26, 2019 at 05:17:40AM -0700, Huang, Kai wrote:
> On Wed, 2019-03-20 at 18:21 +0200, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Similar to other large Intel features such as VMX and TXT, SGX must be
> > explicitly enabled in IA32_FEATURE_CONTROL MSR to be truly usable.
> > Clear all SGX related capabilities if SGX is not fully enabled in
> > IA32_FEATURE_CONTROL or if the SGX1 instruction set isn't supported
> > (impossible on bare metal, theoretically possible in a VM if the VMM is
> > doing something weird).
> > 
> > Like SGX itself, SGX Launch Control must be explicitly enabled via a
> > flag in IA32_FEATURE_CONTROL. Clear the SGX_LC capability if Launch
> > Control is not fully enabled (or obviously if SGX itself is disabled).
> > 
> > Note that clearing X86_FEATURE_SGX_LC creates a bit of a conundrum
> > regarding the SGXLEPUBKEYHASH MSRs, as it may be desirable to read the
> > MSRs even if they are not writable, e.g. to query the configured key,
> > but clearing the capability leaves no breadcrum for discerning whether
> > or not the MSRs exist.  But, such usage will be rare (KVM is the only
> > known case at this time) and not performance critical, so it's not
> > unreasonable to require the use of rdmsr_safe().  Clearing the cap bit
> > eliminates the need for an additional flag to track whether or not
> > Launch Control is truly enabled, which is what we care about the vast
> > majority of the time.
> 
> [Resend. Somehow my last reply doesn't show up in my mailbox so not sure whether I sent it
> successfully or not. Sorry if you receving duplicated mails.]
> 
> However this is not consistent with HW behavior. If LC feature flag is not present, then MSRs should
> have hash of Intel's key, which is not always the case here, when you expose SGX to KVM. Enclave in
> KVM guest will get unexpected EINIT error when launing Intel enclave, if on HW MSRs are configured
> to 3rd party value but locked to readonly.

Intel doesn't have a singular key.  The internal reset value of the LE
pubkey hash MSRs is micro-architectural, i.e. can change without warning
on any given processor.  All current processors with SGX support may use
the same reset value, but it's not something that customers should/can
rely on.

That being said, this in no way impacts KVM's ability to virtualize SGX,
e.g. KVM can directly do CPUID and {RD,WR}MSR to probe the capabilities
of the platform as needed.

> My opition is we already have enough cases that violates HW behavior in
> SGX virtualization, let's not have one more.

What are the other cases?

> Besides, why do we "need an additional flag to track whether or not
> Launch Control is truly enabled"? Doesn't driver only need to know whether
> MSRs are writable?

Yes, and that's why we're overloading X86_FEATURE_SGX_LC to be set if
and only if SGX_LC is supported *and* enabled, e.g. so that the kernel
can simply check X86_FEATURE_SGX_LC without having to also probe the MSRs.
