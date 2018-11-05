Return-Path: <SRS0=4Rt9=NQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5383C0044C
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Nov 2018 14:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8FBF2085A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Nov 2018 14:31:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8FBF2085A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbeKEXvr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:51:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:5880 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbeKEXvr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Nov 2018 18:51:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2018 06:31:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,468,1534834800"; 
   d="scan'208";a="278451650"
Received: from smile.fi.intel.com (HELO smile) ([10.237.72.86])
  by fmsmga006.fm.intel.com with ESMTP; 05 Nov 2018 06:31:42 -0800
Received: from andy by smile with local (Exim 4.91)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1gJfum-0005l3-Gz; Mon, 05 Nov 2018 16:31:40 +0200
Date:   Mon, 5 Nov 2018 16:31:40 +0200
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>, davidwang@zhaoxin.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>,
        qianyue.zj@alibaba-inc.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 05/23] x86/cpu/intel: Detect SGX support and update
 caps appropriately
Message-ID: <20181105143140.GJ10650@smile.fi.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-6-jarkko.sakkinen@linux.intel.com>
 <CAHp75VcG4FtiS9bDM_pP216kxobFxkChDu6uxvuTsMHQ=YJ3Zg@mail.gmail.com>
 <20181105140933.GA24038@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105140933.GA24038@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181105143140.BOFWmVIUFHAK95C6UWyYQLwyuo-o1kfOXcx7Da-Wo0M@z>

On Mon, Nov 05, 2018 at 04:09:33PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 03, 2018 at 03:05:39PM +0200, Andy Shevchenko wrote:

> Agree. Would this be a more clean flow in the attached patch?

LGTM.

> From 3b863a7db00cefffc15df918a5132c35ea313c27 Mon Sep 17 00:00:00 2001
> From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Date: Mon, 5 Nov 2018 16:06:06 +0200
> Subject: [PATCH] x86/cpu/intel: clean up detect_sgx() flow
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/intel.c | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index bc52c52f7025..8a20a193d399 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -598,28 +598,36 @@ static void detect_tme(struct cpuinfo_x86 *c)
>  
>  static void detect_sgx(struct cpuinfo_x86 *c)
>  {
> -	bool unsupported = false;
>  	unsigned long long fc;
>  
>  	rdmsrl(MSR_IA32_FEATURE_CONTROL, fc);
>  	if (!(fc & FEATURE_CONTROL_LOCKED)) {
>  		pr_err_once("sgx: IA32_FEATURE_CONTROL MSR is not locked\n");
> -		unsupported = true;
> -	} else if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
> +		goto out_unsupported;
> +	}
> +
> +	if (!(fc & FEATURE_CONTROL_SGX_ENABLE)) {
>  		pr_err_once("sgx: not enabled in IA32_FEATURE_CONTROL MSR\n");
> -		unsupported = true;
> -	} else if (!cpu_has(c, X86_FEATURE_SGX1)) {
> +		goto out_unsupported;
> +	}
> +
> +	if (!cpu_has(c, X86_FEATURE_SGX1)) {
>  		pr_err_once("sgx: SGX1 instruction set not supported\n");
> -		unsupported = true;
> +		goto out_unsupported;
>  	}
>  
> -	if (unsupported) {
> -		setup_clear_cpu_cap(X86_FEATURE_SGX);
> -		setup_clear_cpu_cap(X86_FEATURE_SGX1);
> -		setup_clear_cpu_cap(X86_FEATURE_SGX2);
> +	if (!(fc & FEATURE_CONTROL_SGX_LE_WR)) {
> +		pr_info_once("sgx: launch control MSRs are not writable\n");
> +		goto out_msrs_rdonly;
>  	}
> -	if (unsupported || !(fc & FEATURE_CONTROL_SGX_LE_WR))
> -		setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> +
> +	return;
> +out_unsupported:
> +	setup_clear_cpu_cap(X86_FEATURE_SGX);
> +	setup_clear_cpu_cap(X86_FEATURE_SGX1);
> +	setup_clear_cpu_cap(X86_FEATURE_SGX2);
> +out_msrs_rdonly:
> +	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
>  }
>  
>  static void init_intel_energy_perf(struct cpuinfo_x86 *c)
> -- 
> 2.19.1
> 


-- 
With Best Regards,
Andy Shevchenko


