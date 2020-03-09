Return-Path: <SRS0=rVAO=42=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350CDC10F25
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Mar 2020 21:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C5B724671
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Mar 2020 21:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgCIV4X (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 Mar 2020 17:56:23 -0400
Received: from mga06.intel.com ([134.134.136.31]:3694 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgCIV4X (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 9 Mar 2020 17:56:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Mar 2020 14:56:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,534,1574150400"; 
   d="scan'208";a="245480360"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 09 Mar 2020 14:56:22 -0700
Date:   Mon, 9 Mar 2020 14:56:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v28 07/22] x86/cpu/intel: Detect SGX supprt
Message-ID: <20200309215622.GC19235@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-8-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303233609.713348-8-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

s/supprt/support

On Wed, Mar 04, 2020 at 01:35:54AM +0200, Jarkko Sakkinen wrote:
> @@ -123,13 +132,21 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
>  	}
>  
> +	/*
> +	 * Enable SGX if and only if the kernel supports SGX and Launch Control
> +	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
> +	 */
> +	if (cpu_has(c, X86_FEATURE_SGX) && cpu_has(c, X86_FEATURE_SGX_LC) &&
> +	    IS_ENABLED(CONFIG_INTEL_SGX))

This should probably check X86_FEATURE_SGX1 to handle the (unlikely) case
where SGX is supported but is soft disabled, e.g. due to a (corrected) #MC.

> +		msr |= FEAT_CTL_SGX_ENABLED | FEAT_CTL_SGX_LC_ENABLED;
> +
>  	wrmsrl(MSR_IA32_FEAT_CTL, msr);
>  
>  update_caps:
>  	set_cpu_cap(c, X86_FEATURE_MSR_IA32_FEAT_CTL);
>  
>  	if (!cpu_has(c, X86_FEATURE_VMX))
> -		return;
> +		goto update_sgx;
>  
>  	if ( (tboot && !(msr & FEAT_CTL_VMX_ENABLED_INSIDE_SMX)) ||
>  	    (!tboot && !(msr & FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX))) {
> @@ -142,4 +159,14 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  		init_vmx_capabilities(c);
>  #endif
>  	}
> +
> +update_sgx:
> +	if (!cpu_has(c, X86_FEATURE_SGX) || !cpu_has(c, X86_FEATURE_SGX_LC)) {

Same thing here for SGX1.  Since the checks are getting rather lengthy, it
probably makes sense to consolidate the logic using a local bool, e.g. as a
delta patch:

---
 arch/x86/kernel/cpu/feat_ctl.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index b16b71a6da74..ef4ddd6c8630 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -103,6 +103,7 @@ static void clear_sgx_caps(void)
 void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 {
 	bool tboot = tboot_enabled();
+	bool enable_sgx;
 	u64 msr;
 
 	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
@@ -111,6 +112,15 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 		return;
 	}
 
+	/*
+	 * Enable SGX if and only if the kernel supports SGX and Launch Control
+	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
+	 */
+	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
+		     cpu_has(c, X86_FEATURE_SGX1) &&
+		     cpu_has(c, X86_FEATURE_SGX_LC) &&
+		     IS_ENABLED(CONFIG_INTEL_SGX);
+
 	if (msr & FEAT_CTL_LOCKED)
 		goto update_caps;
 
@@ -132,12 +142,7 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
 	}
 
-	/*
-	 * Enable SGX if and only if the kernel supports SGX and Launch Control
-	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
-	 */
-	if (cpu_has(c, X86_FEATURE_SGX) && cpu_has(c, X86_FEATURE_SGX_LC) &&
-	    IS_ENABLED(CONFIG_INTEL_SGX))
+	if (enable_sgx)
 		msr |= FEAT_CTL_SGX_ENABLED | FEAT_CTL_SGX_LC_ENABLED;
 
 	wrmsrl(MSR_IA32_FEAT_CTL, msr);
@@ -161,11 +166,9 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 	}
 
 update_sgx:
-	if (!cpu_has(c, X86_FEATURE_SGX) || !cpu_has(c, X86_FEATURE_SGX_LC)) {
-		clear_sgx_caps();
-	} else if (!(msr & FEAT_CTL_SGX_ENABLED) ||
-		   !(msr & FEAT_CTL_SGX_LC_ENABLED)) {
-		if (IS_ENABLED(CONFIG_INTEL_SGX))
+	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
+	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
+		if (enable_sgx)
 			pr_err_once("SGX disabled by BIOS\n");
 		clear_sgx_caps();
 	}
-- 
2.24.1

> +		clear_sgx_caps();
> +	} else if (!(msr & FEAT_CTL_SGX_ENABLED) ||
> +		   !(msr & FEAT_CTL_SGX_LC_ENABLED)) {
> +		if (IS_ENABLED(CONFIG_INTEL_SGX))
> +			pr_err_once("SGX disabled by BIOS\n");
> +		clear_sgx_caps();
> +	}
>  }
> -- 
> 2.25.0
> 
