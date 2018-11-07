Return-Path: <SRS0=ssez=NS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77563C0044C
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Nov 2018 15:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4914420827
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Nov 2018 15:58:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4914420827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731286AbeKHB3W (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Nov 2018 20:29:22 -0500
Received: from mga14.intel.com ([192.55.52.115]:49344 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731255AbeKHB3W (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Nov 2018 20:29:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2018 07:58:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,475,1534834800"; 
   d="scan'208";a="98380993"
Received: from kaczmarx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.132])
  by orsmga003.jf.intel.com with ESMTP; 07 Nov 2018 07:58:15 -0800
Date:   Wed, 7 Nov 2018 17:58:13 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        David Wang <davidwang@zhaoxin.com>,
        "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>,
        Jia Zhang <qianyue.zj@alibaba-inc.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v16 06/22] x86/cpu/intel: Detect SGX support and update
 caps appropriately
Message-ID: <20181107155813.GA9730@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
 <20181106134758.10572-7-jarkko.sakkinen@linux.intel.com>
 <1541512681.7839.14.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1541512681.7839.14.camel@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 06, 2018 at 05:58:01AM -0800, Sean Christopherson wrote:
> On Tue, 2018-11-06 at 15:45 +0200, Jarkko Sakkinen wrote:
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
> > or not the MSRs exist.  But, such usage will be rare (KVM is the only
> > known case at this time) and not performance critical, so it's not
> > unreasonable to require the use of rdmsr_safe().  Clearing the cap bit
> > eliminates the need for an additional flag to track whether or not
> > Launch Control is truly enabled, which is what we care about the vast
> > majority of the time.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/intel.c | 37 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> > index fc3c07fe7df5..8a20a193d399 100644
> > --- a/arch/x86/kernel/cpu/intel.c
> > +++ b/arch/x86/kernel/cpu/intel.c
> > @@ -596,6 +596,40 @@ static void detect_tme(struct cpuinfo_x86 *c)
> >  	c->x86_phys_bits -= keyid_bits;
> >  }
> >  
> > +static void detect_sgx(struct cpuinfo_x86 *c)
> > +{
> > +	unsigned long long fc;
> > +
> > +	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
> > +	if (!(fc & FEATURE_CONTROL_LOCKED)) {
> > +		pr_err_once("sgx: IA32_FEATURE_CONTROL MSR is not locked\n");
> > +		goto out_unsupported;
> > +	}
> > +
> > +	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
> > +		pr_err_once("sgx: not enabled in IA32_FEATURE_CONTROL MSR\n");
> > +		goto out_unsupported;
> > +	}
> > +
> > +	if (!cpu_has(c, X86_FEATURE_SGX1)) {
> > +		pr_err_once("sgx: SGX1 instruction set not supported\n");
> > +		goto out_unsupported;
> > +	}
> > +
> > +	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
> 
> FEATURE_CONTROL_SGX_LE_WR isn't added until patch 13/22.  The patch
> can simply be moved earlier in the series if you want to introduce
> the full detect_sgx() in a single patch.  The only reason SGX_LE_WR
> was added later in the series was to bundle the Launch Control stuff
> together.

Ugh, sorry. Had this is mind when I started working on v16 changes :-(

/Jarkko
