Return-Path: <SRS0=kl42=BQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4895C433DF
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D333206B2
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:58:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V4GqZD3E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgHFR6K (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:58:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49682 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFR6K (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Aug 2020 13:58:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076D27CE176546;
        Thu, 6 Aug 2020 13:17:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=xeQh4UwI5BYb0rFkOfOqf85p8ALQ3Km95tWCw+dneU0=;
 b=V4GqZD3E80QaR3bTb+QGtayZjdsIoQKe5MeCDAW2nKaiOSWZb/GCKMD2eNBIaQKeT9Q1
 YXwYXaln8m7XAaQr54etsrv/obofZQbCIK9lWM7Gi+YtHKuiqpGxmf2J+uBisydwsSmW
 PcBWXVpV62OaJ3g4+bG2OKI7hPlSvRy6nfBrSp5cLB7aaw4rx8w+uKl5zf5ZWCJVn34J
 R+SUItZpWq00NrHAgY87XnHyZLZ5nbWAUi8cX23lLKDR4KQ4MoALI7M6zRdcC8AjPEKW
 0zLc8BhNX18GxGsJKoln9+ndvvhcpB4mNoDSubSWgD5rkV3FBRk/gAPfArXOGu5OCLQ3 xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32r6ep2uph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 13:17:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076Cwxmu172996;
        Thu, 6 Aug 2020 13:17:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32pdnwc24c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 13:17:56 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 076DHrHX018618;
        Thu, 6 Aug 2020 13:17:54 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 06:17:53 -0700
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id D1895F04A2B; Thu,  6 Aug 2020 14:17:47 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 06/24] x86/cpu/intel: Detect SGX support
In-Reply-To: <20200716135303.276442-7-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-7-jarkko.sakkinen@linux.intel.com>
Date:   Thu, 06 Aug 2020 14:17:47 +0100
Message-ID: <m2zh77rk04.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060094
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thursday, 2020-07-16 at 16:52:45 +03, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Configure SGX as part of feature control MSR initialization and update
> the associated X86_FEATURE flags accordingly.  Because the kernel will
> require the LE hash MSRs to be writable when running native enclaves,
> disable X86_FEATURE_SGX (and all derivatives) if SGX Launch Control is
> not (or cannot) be fully enabled via feature control MSR.
>
> The check is done for every CPU, not just BSP, in order to verify that
> MSR_IA32_FEATURE_CONTROL is correctly configured on all CPUs. The other
> parts of the kernel, like the enclave driver, expect the same
> configuration from all CPUs.
>
> Note, unlike VMX, clear the X86_FEATURE_SGX* flags for all CPUs if any
> CPU lacks SGX support as the kernel expects SGX to be available on all
> CPUs.  X86_FEATURE_VMX is intentionally cleared only for the current CPU
> so that KVM can provide additional information if KVM fails to load,
> e.g. print which CPU doesn't support VMX.  KVM/VMX requires additional
> per-CPU enabling, e.g. to set CR4.VMXE and do VMXON, and so already has
> the necessary infrastructure to do per-CPU checks.  SGX on the other
> hand doesn't require additional enabling, so clearing the feature flags
> on all CPUs means the SGX subsystem doesn't need to manually do support
> checks on a per-CPU basis.
>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

> ---
>  arch/x86/kernel/cpu/feat_ctl.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> index 29a3bedabd06..c3afcd2e4342 100644
> --- a/arch/x86/kernel/cpu/feat_ctl.c
> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> @@ -93,16 +93,35 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
>  }
>  #endif /* CONFIG_X86_VMX_FEATURE_NAMES */
>  
> +static void clear_sgx_caps(void)
> +{
> +	setup_clear_cpu_cap(X86_FEATURE_SGX);
> +	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> +	setup_clear_cpu_cap(X86_FEATURE_SGX1);
> +	setup_clear_cpu_cap(X86_FEATURE_SGX2);
> +}
> +
>  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  {
>  	bool tboot = tboot_enabled();
> +	bool enable_sgx;
>  	u64 msr;
>  
>  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
>  		clear_cpu_cap(c, X86_FEATURE_VMX);
> +		clear_sgx_caps();
>  		return;
>  	}
>  
> +	/*
> +	 * Enable SGX if and only if the kernel supports SGX and Launch Control
> +	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
> +	 */
> +	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> +		     cpu_has(c, X86_FEATURE_SGX1) &&
> +		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> +		     IS_ENABLED(CONFIG_INTEL_SGX);
> +
>  	if (msr & FEAT_CTL_LOCKED)
>  		goto update_caps;
>  
> @@ -124,13 +143,16 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
>  	}
>  
> +	if (enable_sgx)
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
> @@ -143,4 +165,12 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
>  		init_vmx_capabilities(c);
>  #endif
>  	}
> +
> +update_sgx:
> +	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
> +	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
> +		if (enable_sgx)
> +			pr_err_once("SGX disabled by BIOS\n");
> +		clear_sgx_caps();
> +	}
>  }
> -- 
> 2.25.1
