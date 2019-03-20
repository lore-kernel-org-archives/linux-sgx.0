Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B68C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 19:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 499DE20857
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 19:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfCTTmC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 15:42:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbfCTTmB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 15:42:01 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 749743001566;
        Wed, 20 Mar 2019 19:42:00 +0000 (UTC)
Received: from hmswarspite.think-freely.org (ovpn-121-76.rdu2.redhat.com [10.10.121.76])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 362351001E6B;
        Wed, 20 Mar 2019 19:41:56 +0000 (UTC)
Date:   Wed, 20 Mar 2019 15:41:53 -0400
From:   Neil Horman <nhorman@redhat.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Kai Huang <kai.huang@linux.intel.com>
Subject: Re: [PATCH v19,RESEND 01/27] x86/cpufeatures: Add Intel-defined SGX
 feature bit
Message-ID: <20190320194153.GS23302@hmswarspite.think-freely.org>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-2-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320162119.4469-2-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 20 Mar 2019 19:42:01 +0000 (UTC)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 20, 2019 at 06:20:53PM +0200, Jarkko Sakkinen wrote:
> From: Kai Huang <kai.huang@linux.intel.com>
> 
> X86_FEATURE_SGX reflects whether or not the CPU supports Intel's
> Software Guard eXtensions (SGX).
> 
> Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Reviewed-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/cpufeatures.h       | 1 +
>  arch/x86/include/asm/disabled-features.h | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 981ff9479648..a16325db4cff 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -236,6 +236,7 @@
>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
>  #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
>  #define X86_FEATURE_TSC_ADJUST		( 9*32+ 1) /* TSC adjustment MSR 0x3B */
> +#define X86_FEATURE_SGX			( 9*32+ 2) /* Software Guard Extensions */
>  #define X86_FEATURE_BMI1		( 9*32+ 3) /* 1st group bit manipulation extensions */
>  #define X86_FEATURE_HLE			( 9*32+ 4) /* Hardware Lock Elision */
>  #define X86_FEATURE_AVX2		( 9*32+ 5) /* AVX2 instructions */
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index a5ea841cc6d2..74de07d0f390 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -62,6 +62,12 @@
>  # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
>  #endif
>  
> +#ifdef CONFIG_INTEL_SGX
> +# define DISABLE_SGX_CORE	0
> +#else
> +# define DISABLE_SGX_CORE	(1 << (X86_FEATURE_SGX & 31))
> +#endif
> +
>  /*
>   * Make sure to add features to the correct mask
>   */
> @@ -74,7 +80,7 @@
>  #define DISABLED_MASK6	0
>  #define DISABLED_MASK7	(DISABLE_PTI)
>  #define DISABLED_MASK8	0
> -#define DISABLED_MASK9	(DISABLE_MPX|DISABLE_SMAP)
> +#define DISABLED_MASK9	(DISABLE_MPX|DISABLE_SMAP|DISABLE_SGX_CORE)
>  #define DISABLED_MASK10	0
>  #define DISABLED_MASK11	0
>  #define DISABLED_MASK12	0
> -- 
> 2.19.1
> 
Just out of curiosity, would it be worthwhile to separate out the cpufeature
patches here to post and integrate them separately?  It would at least reduce
the size of this patch set slightly, as these aren't controversial changes

Neil

