Return-Path: <SRS0=bk6Q=2J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB61AC43603
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Dec 2019 00:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8894D222C2
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Dec 2019 00:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfLSAm2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Dec 2019 19:42:28 -0500
Received: from mga04.intel.com ([192.55.52.120]:27288 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfLSAm2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Dec 2019 19:42:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 16:42:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="228071463"
Received: from jtreacy-mobl1.ger.corp.intel.com ([10.251.82.127])
  by orsmga002.jf.intel.com with ESMTP; 18 Dec 2019 16:42:20 -0800
Message-ID: <c956ba52a9f0b54cd8ab3ec034246662e792ac14.camel@linux.intel.com>
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
Date:   Thu, 19 Dec 2019 02:42:20 +0200
In-Reply-To: <20191217151744.GG28788@zn.tnic>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
         <20191129231326.18076-8-jarkko.sakkinen@linux.intel.com>
         <20191217151744.GG28788@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2019-12-17 at 16:17 +0100, Borislav Petkov wrote:
> On Sat, Nov 30, 2019 at 01:13:09AM +0200, Jarkko Sakkinen wrote:
> 
> Typo in the subject:
> 
> Subject: Re: [PATCH v24 07/24] x86/cpu/intel: Detect SGX supprt
> 							 ^^^^^^
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
> 
> ...
> 
> > @@ -761,6 +797,11 @@ static void init_intel(struct cpuinfo_x86 *c)
> >  	if (cpu_has(c, X86_FEATURE_TME))
> >  		detect_tme(c);
> >  
> > +#ifdef CONFIG_INTEL_SGX
> > +	if (cpu_has(c, X86_FEATURE_SGX))
> > +		detect_sgx(c);
> > +#endif
> 
> You can remove the ifdeffery here and put the ifdef around the function
> body and drop the __maybe_unused tag:

OK, so I remember getting feedback on some unrelated to SGX stuff
that I should use __maybe_unused in the past. That is why I used
it here instead of ifdeffery.

It is used in bunch of places in the kernel. I'm a bit confused
when using it is a right thing and when it should be avoided.

/Jarkko


