Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B9CC43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 21:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B6752070D
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 21:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731644AbfCZVZ6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 17:25:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:14774 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727492AbfCZVZ6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 17:25:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 14:25:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,274,1549958400"; 
   d="scan'208";a="286124301"
Received: from kmsmsx153.gar.corp.intel.com ([172.21.73.88])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2019 14:25:53 -0700
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.114]) by
 KMSMSX153.gar.corp.intel.com ([169.254.5.176]) with mapi id 14.03.0415.000;
 Wed, 27 Mar 2019 05:25:52 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
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
Subject: RE: [PATCH v19,RESEND 08/27] x86/cpu/intel: Detect SGX support and
 update caps appropriately
Thread-Topic: [PATCH v19,RESEND 08/27] x86/cpu/intel: Detect SGX support and
 update caps appropriately
Thread-Index: AQHU3zky6JmIjy9D9kKUr6BC7GDLPqYdVzoAgAAkQICAAPek0A==
Date:   Tue, 26 Mar 2019 21:25:52 +0000
Message-ID: <105F7BF4D0229846AF094488D65A0989356F307D@PGSMSX112.gar.corp.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-9-jarkko.sakkinen@linux.intel.com>
 <1553602654.17255.15.camel@intel.com> <20190326142719.GC3757@linux.intel.com>
In-Reply-To: <20190326142719.GC3757@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWY1N2ZmNzMtZTgyOS00YTYyLTk1N2QtZjRiZDQxMWIzY2JlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiYnhmcit5QnRiMXVnNUU0Smp3Tm9QRk9kejBvT0F0UGtKalVoT202WVZ4aGc5ZzRBcnJuUklEUGcxRGc1Vk5pNiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> 
> On Tue, Mar 26, 2019 at 05:17:40AM -0700, Huang, Kai wrote:
> > On Wed, 2019-03-20 at 18:21 +0200, Jarkko Sakkinen wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > >
> > > Similar to other large Intel features such as VMX and TXT, SGX must
> > > be explicitly enabled in IA32_FEATURE_CONTROL MSR to be truly usable.
> > > Clear all SGX related capabilities if SGX is not fully enabled in
> > > IA32_FEATURE_CONTROL or if the SGX1 instruction set isn't supported
> > > (impossible on bare metal, theoretically possible in a VM if the VMM
> > > is doing something weird).
> > >
> > > Like SGX itself, SGX Launch Control must be explicitly enabled via a
> > > flag in IA32_FEATURE_CONTROL. Clear the SGX_LC capability if Launch
> > > Control is not fully enabled (or obviously if SGX itself is disabled).
> > >
> > > Note that clearing X86_FEATURE_SGX_LC creates a bit of a conundrum
> > > regarding the SGXLEPUBKEYHASH MSRs, as it may be desirable to read
> > > the MSRs even if they are not writable, e.g. to query the configured
> > > key, but clearing the capability leaves no breadcrum for discerning
> > > whether or not the MSRs exist.  But, such usage will be rare (KVM is
> > > the only known case at this time) and not performance critical, so
> > > it's not unreasonable to require the use of rdmsr_safe().  Clearing
> > > the cap bit eliminates the need for an additional flag to track
> > > whether or not Launch Control is truly enabled, which is what we
> > > care about the vast majority of the time.
> >
> > [Resend. Somehow my last reply doesn't show up in my mailbox so not
> > sure whether I sent it successfully or not. Sorry if you receving
> > duplicated mails.]
> >
> > However this is not consistent with HW behavior. If LC feature flag is
> > not present, then MSRs should have hash of Intel's key, which is not
> > always the case here, when you expose SGX to KVM. Enclave in KVM guest
> > will get unexpected EINIT error when launing Intel enclave, if on HW MSRs
> are configured to 3rd party value but locked to readonly.
> 
> Intel doesn't have a singular key.  The internal reset value of the LE pubkey
> hash MSRs is micro-architectural, i.e. can change without warning on any
> given processor.  All current processors with SGX support may use the same
> reset value, but it's not something that customers should/can rely on.

I don't think update of Intel hash would be frequent, like you said all current processors with SGX support may should be using the same value.

Thus I am expecting I can run Intel SDK on KVM guest if LC feature flag is cleared.

Even Intel has updated the key, SDK should mention those impacted machine should run SDK starting from some new version, so SDK should continue to run.

> 
> That being said, this in no way impacts KVM's ability to virtualize SGX, e.g.
> KVM can directly do CPUID and {RD,WR}MSR to probe the capabilities of the
> platform as needed.

I am not following. KVM can do whatever it wants, but it cannot change the fact that KVM guest cannot run intel enclave if platform's MSRs are configured to 3rd party and locked.

Or am I misunderstanding?

> 
> > My opition is we already have enough cases that violates HW behavior
> > in SGX virtualization, let's not have one more.
> 
> What are the other cases?

One example is EPCM + EPC should be power of 2. And EPC migration (sudden loss of EPC). And if we apply some policy to restrict enclave during EINIT trap, etc.

But those are not the point. I should probably have not mentioned them.

> 
> > Besides, why do we "need an additional flag to track whether or not
> > Launch Control is truly enabled"? Doesn't driver only need to know
> > whether MSRs are writable?
> 
> Yes, and that's why we're overloading X86_FEATURE_SGX_LC to be set if and
> only if SGX_LC is supported *and* enabled, e.g. so that the kernel can simply
> check X86_FEATURE_SGX_LC without having to also probe the MSRs.

OK.

But IMO if what I mentioned above is correct, then that part should overweight the benefit you can get here.

Anyway who cares to do less/more thing in driver probe?

Thanks,
-Kai
