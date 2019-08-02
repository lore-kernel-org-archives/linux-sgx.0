Return-Path: <SRS0=d5Cv=V6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42991C32750
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Aug 2019 20:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19BAC20880
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Aug 2019 20:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbfHBUsZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Aug 2019 16:48:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:23759 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727848AbfHBUsZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Aug 2019 16:48:25 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 13:48:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,339,1559545200"; 
   d="scan'208";a="178256598"
Received: from psathya-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.36.242])
  by orsmga006.jf.intel.com with ESMTP; 02 Aug 2019 13:48:18 -0700
Date:   Fri, 2 Aug 2019 23:48:17 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v21 08/28] x86/cpu/intel: Detect SGX support and update
 caps appropriately
Message-ID: <20190802204754.gw4elehzvnjh33jq@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-9-jarkko.sakkinen@linux.intel.com>
 <20190724193542.GD25376@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724193542.GD25376@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 24, 2019 at 12:35:42PM -0700, Sean Christopherson wrote:
> On Sat, Jul 13, 2019 at 08:07:44PM +0300, Jarkko Sakkinen wrote:
> >  arch/x86/kernel/cpu/intel.c | 71 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 71 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> > index 8d6d92ebeb54..1503b251d10f 100644
> > --- a/arch/x86/kernel/cpu/intel.c
> > +++ b/arch/x86/kernel/cpu/intel.c
> > @@ -623,6 +623,72 @@ static void detect_tme(struct cpuinfo_x86 *c)
> >  	c->x86_phys_bits -= keyid_bits;
> >  }
> >  
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
> > +static void init_intel_energy_perf(struct cpuinfo_x86 *c)
> > +{
> > +	u64 epb;
> > +
> > +	/*
> > +	 * Initialize MSR_IA32_ENERGY_PERF_BIAS if not already initialized.
> > +	 * (x86_energy_perf_policy(8) is available to change it at run-time.)
> > +	 */
> > +	if (!cpu_has(c, X86_FEATURE_EPB))
> > +		return;
> > +
> > +	rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
> > +	if ((epb & 0xF) != ENERGY_PERF_BIAS_PERFORMANCE)
> > +		return;
> > +
> > +	pr_warn_once("ENERGY_PERF_BIAS: Set to 'normal', was 'performance'\n");
> > +	pr_warn_once("ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)\n");
> > +	epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
> > +	wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
> > +}
> > +
> > +static void intel_bsp_resume(struct cpuinfo_x86 *c)
> > +{
> > +	/*
> > +	 * MSR_IA32_ENERGY_PERF_BIAS is lost across suspend/resume,
> > +	 * so reinitialize it properly like during bootup:
> > +	 */
> > +	init_intel_energy_perf(c);
> > +}
> > +
> >  static void init_cpuid_fault(struct cpuinfo_x86 *c)
> >  {
> >  	u64 msr;
> > @@ -760,6 +826,11 @@ static void init_intel(struct cpuinfo_x86 *c)
> >  	if (cpu_has(c, X86_FEATURE_TME))
> >  		detect_tme(c);
> >  
> > +	if (IS_ENABLED(CONFIG_INTEL_SGX) && cpu_has(c, X86_FEATURE_SGX))
> > +		detect_sgx(c);
> > +
> > +	init_intel_energy_perf(c);
> 
> All of the energy_perf additions are bogus, looks like a rebase gone wrong.

Thanks for catching this.

/Jarkko
