Return-Path: <SRS0=S/Hi=XT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9378C432C1
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 17:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 977A520872
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Sep 2019 17:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387559AbfIXRnN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 Sep 2019 13:43:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:16025 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732249AbfIXRnN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 24 Sep 2019 13:43:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Sep 2019 10:43:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,544,1559545200"; 
   d="scan'208";a="189433054"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 24 Sep 2019 10:43:11 -0700
Date:   Tue, 24 Sep 2019 10:43:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com
Subject: Re: [PATCH v22 04/24] x86/cpu/intel: Detect SGX supprt
Message-ID: <20190924174311.GB16218@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-5-jarkko.sakkinen@linux.intel.com>
 <20190924161301.GI19317@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924161301.GI19317@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 24, 2019 at 06:13:01PM +0200, Borislav Petkov wrote:
> On Tue, Sep 03, 2019 at 05:26:35PM +0300, Jarkko Sakkinen wrote:
> > +static void __maybe_unused detect_sgx(struct cpuinfo_x86 *c)
> > +{
> > +	unsigned long long fc;
> > +
> > +	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
> > +	if (!(fc & FEATURE_CONTROL_LOCKED)) {
> > +		pr_err_once("sgx: The feature control MSR is not locked\n");
> > +		goto err_unsupported;
> > +	}
> > +
> > +	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
> > +		pr_err_once("sgx: SGX is not enabled in IA32_FEATURE_CONTROL MSR\n");
> > +		goto err_unsupported;
> > +	}
> > +
> > +	if (!cpu_has(c, X86_FEATURE_SGX1)) {
> > +		pr_err_once("sgx: SGX1 instruction set is not supported\n");
> > +		goto err_unsupported;
> > +	}
> > +
> > +	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
> > +		pr_info_once("sgx: The launch control MSRs are not writable\n");

This should be pr_err_once.

> > +		goto err_msrs_rdonly;
> > +	}
> > +
> > +	return;
> > +
> > +err_unsupported:
> > +	setup_clear_cpu_cap(X86_FEATURE_SGX);
> > +	setup_clear_cpu_cap(X86_FEATURE_SGX1);
> > +	setup_clear_cpu_cap(X86_FEATURE_SGX2);
> > +
> > +err_msrs_rdonly:
> > +	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> > +}
> > +
> >  static void init_cpuid_fault(struct cpuinfo_x86 *c)
> >  {
> >  	u64 msr;
> > @@ -760,6 +796,9 @@ static void init_intel(struct cpuinfo_x86 *c)
> >  	if (cpu_has(c, X86_FEATURE_TME))
> >  		detect_tme(c);
> >  
> > +	if (IS_ENABLED(CONFIG_INTEL_SGX) && cpu_has(c, X86_FEATURE_SGX))
> > +		detect_sgx(c);
> 
> Looks to me like this should run only once on the BSP instead of on
> every CPU. The pr_*_once things above are a good sign for that, I'd say.
> 
> If so, define your own ->c_bsp_init function and run that from there
> instead.

The intent of running on every CPU is to verify MSR_IA32_FEATURE_CONTROL
is correctly configured on all CPUs.  It's extremely unlikely that
firmware would misconfigure or fail to write the MSR on only APs, but if
that does happen we'll spam dmesg and possibly panic or hang the kernel.

The severity of the fallout is why we're being paranoid.  KVM is similarly
paranoid about VMX enabling since it'll BUG() on an unexpected fault due
to a misconfigured FEATURE_CONTROL.
