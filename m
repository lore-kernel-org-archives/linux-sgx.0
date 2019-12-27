Return-Path: <SRS0=e0TB=2R=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C92C2D0C3
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Dec 2019 06:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFAC420CC7
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Dec 2019 06:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfL0GBJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Dec 2019 01:01:09 -0500
Received: from mga05.intel.com ([192.55.52.43]:5349 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfL0GBJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 27 Dec 2019 01:01:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Dec 2019 22:01:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,362,1571727600"; 
   d="scan'208";a="243150932"
Received: from psklarow-mobl.ger.corp.intel.com ([10.252.31.109])
  by fmsmga004.fm.intel.com with ESMTP; 26 Dec 2019 22:00:55 -0800
Message-ID: <05875955d6a4de39a2686ac62e7b2b8583450b49.camel@linux.intel.com>
Subject: Re: [PATCH v24 07/24] x86/cpu/intel: Detect SGX supprt
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
In-Reply-To: <20191223094614.GB16710@zn.tnic>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
         <20191129231326.18076-8-jarkko.sakkinen@linux.intel.com>
         <20191223094614.GB16710@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160
 Espoo
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Fri, 27 Dec 2019 08:00:50 +0200
User-Agent: Evolution 3.34.1-2 
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2019-12-23 at 10:46 +0100, Borislav Petkov wrote:
> On Sat, Nov 30, 2019 at 01:13:09AM +0200, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > When the CPU supports SGX, check that the BIOS has enabled SGX and SGX1
> > opcodes are available. Otherwise, all the SGX related capabilities.
> > 
> > In addition, clear X86_FEATURE_SGX_LC also in the case when the launch
> > enclave are read-only. This way the feature bit reflects the level that
> > Linux supports the launch control.
> > 
> > The check is done for every CPU, not just BSP, in order to verify that
> > MSR_IA32_FEATURE_CONTROL is correctly configured on all CPUs. The other
> > parts of the kernel, like the enclave driver, expect the same
> > configuration from all CPUs.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/intel.c | 41 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> > index c2fdc00df163..89a71367716c 100644
> > --- a/arch/x86/kernel/cpu/intel.c
> > +++ b/arch/x86/kernel/cpu/intel.c
> > @@ -624,6 +624,42 @@ static void detect_tme(struct cpuinfo_x86 *c)
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
> 
> One more thing - and we talked about this already - when the hash
> MSRs are not writable, the kernel needs to disable all SGX support by
> default. Basically, no SGX support is present.
> 
> If the user wants to run KVM guests with SGX enclaves, then she should
> probably boot with a special kvm param or so. Details on how can exactly
> control that can be discussed later - just making sure you guys are not
> forgetting this use angle.
> 
> Thx.

Sure.

Overally, I guess the right marching order is to hold on with the 
next version of SGX patch set up until Sean's other patch set is
ready to be merged.

/Jarkko



