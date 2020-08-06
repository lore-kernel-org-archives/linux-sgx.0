Return-Path: <SRS0=kl42=BQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B17C433DF
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 19:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9385E206A2
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 19:07:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IjFaOu/k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgHFTHK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 15:07:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55196 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbgHFTHK (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Aug 2020 15:07:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076D2NLW005852;
        Thu, 6 Aug 2020 13:13:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=S15tYa3c//T2CmRl28NbdPwxaeeKPP3A7zXXBkj1DbE=;
 b=IjFaOu/kJbYSSbaCqdGEgOKERCBW6L6UieYN4Ea7t9IKLLCj5QtNdi1VFN8f1C+1Jy/X
 0aXeFQt34/VUKfbO0ERplG5hOBq5/aYIXCDSWIg0gtxQN2nBhcRnxtvdzlzZw3OhtjXT
 jgv+A4UtS0pwR6aIV8XyLQeiJzNGxnWAyo2Pcsv0wKc/MWE89pJMnsENxgDS9FAmN1wk
 BorfPUv0RwQwxXU4cwOQm4EsosVM9prx0EQrvlN2lxRAHjYxZjxFzQIENSqY5wjULvHd
 6ci1fLLaWjTXBkiUWcsRdxlY0Ji0okhF5VQO1iA8OP+a6j8dVjd9B5J5eBiJ4+Q4RNqN zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32r6fxjtb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 13:13:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076Cx8CY151634;
        Thu, 6 Aug 2020 13:13:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32qy8nbwn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 13:13:38 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 076DDYCB019275;
        Thu, 6 Aug 2020 13:13:34 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 06:13:34 -0700
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id CE325F047EA; Thu,  6 Aug 2020 14:13:28 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v36 01/24] x86/cpufeatures: x86/msr: Add Intel SGX
 hardware bits
In-Reply-To: <20200716135303.276442-2-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-2-jarkko.sakkinen@linux.intel.com>
Date:   Thu, 06 Aug 2020 14:13:28 +0100
Message-ID: <m2ft8zsyrr.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9704 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 suspectscore=1 spamscore=0 clxscore=1011 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060094
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thursday, 2020-07-16 at 16:52:40 +03, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> Add X86_FEATURE_SGX from CPUID.(EAX=3D7, ECX=3D1), which informs whether =
the
> CPU has SGX.
>
> Add X86_FEATURE_SGX1 and X86_FEATURE_SGX2 from CPUID.(EAX=3D12H, ECX=3D0),
> which describe the level of SGX support available [1].
>
> Add IA32_FEATURE_CONTROL.SGX_ENABLE. BIOS can use this bit to opt-in SGX
> before locking the feature control MSR [2].
>
> [1] Intel SDM: 36.7.2 Intel=C2=AE SGX Resource Enumeration Leaves
> [2] Intel SDM: 36.7.1 Intel=C2=AE SGX Opt-In Configuration
>
> Reviewed-by: Borislav Petkov <bp@alien8.de>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/include/asm/cpufeature.h        |  5 +++--
>  arch/x86/include/asm/cpufeatures.h       |  7 ++++++-
>  arch/x86/include/asm/disabled-features.h | 18 +++++++++++++++---
>  arch/x86/include/asm/msr-index.h         |  1 +
>  arch/x86/include/asm/required-features.h |  2 +-
>  arch/x86/kernel/cpu/common.c             |  4 ++++
>  6 files changed, 30 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpu=
feature.h
> index 59bf91c57aa8..efbdba5170a3 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -30,6 +30,7 @@ enum cpuid_leafs
>  	CPUID_7_ECX,
>  	CPUID_8000_0007_EBX,
>  	CPUID_7_EDX,
> +	CPUID_12_EAX,
>  };
>=20=20
>  #ifdef CONFIG_X86_FEATURE_NAMES
> @@ -89,7 +90,7 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
>  	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 17, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
>  	   REQUIRED_MASK_CHECK					  ||	\
> -	   BUILD_BUG_ON_ZERO(NCAPINTS !=3D 19))
> +	   BUILD_BUG_ON_ZERO(NCAPINTS !=3D 20))
>=20=20
>  #define DISABLED_MASK_BIT_SET(feature_bit)				\
>  	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
> @@ -112,7 +113,7 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
>  	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 17, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
>  	   DISABLED_MASK_CHECK					  ||	\
> -	   BUILD_BUG_ON_ZERO(NCAPINTS !=3D 19))
> +	   BUILD_BUG_ON_ZERO(NCAPINTS !=3D 20))
>=20=20
>  #define cpu_has(c, bit)							\
>  	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cp=
ufeatures.h
> index 02dabc9e77b0..545ac3e0e269 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -13,7 +13,7 @@
>  /*
>   * Defines x86 CPU feature bits
>   */
> -#define NCAPINTS			19	   /* N 32-bit words worth of info */
> +#define NCAPINTS			20	   /* N 32-bit words worth of info */
>  #define NBUGINTS			1	   /* N 32-bit bug flags */
>=20=20
>  /*
> @@ -238,6 +238,7 @@
>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
>  #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE=
, WRGSBASE instructions*/
>  #define X86_FEATURE_TSC_ADJUST		( 9*32+ 1) /* TSC adjustment MSR 0x3B */
> +#define X86_FEATURE_SGX			( 9*32+ 2) /* Software Guard Extensions */
>  #define X86_FEATURE_BMI1		( 9*32+ 3) /* 1st group bit manipulation exten=
sions */
>  #define X86_FEATURE_HLE			( 9*32+ 4) /* Hardware Lock Elision */
>  #define X86_FEATURE_AVX2		( 9*32+ 5) /* AVX2 instructions */
> @@ -373,6 +374,10 @@
>  #define X86_FEATURE_CORE_CAPABILITIES	(18*32+30) /* "" IA32_CORE_CAPABIL=
ITIES MSR */
>  #define X86_FEATURE_SPEC_CTRL_SSBD	(18*32+31) /* "" Speculative Store By=
pass Disable */
>=20=20
> +/* Intel-defined SGX features, CPUID level 0x00000012:0 (EAX), word 19 */
> +#define X86_FEATURE_SGX1		(19*32+ 0) /* SGX1 leaf functions */
> +#define X86_FEATURE_SGX2		(19*32+ 1) /* SGX2 leaf functions */
> +
>  /*
>   * BUG word(s)
>   */
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/=
asm/disabled-features.h
> index 4ea8584682f9..dbe534d5153f 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -28,13 +28,18 @@
>  # define DISABLE_CYRIX_ARR	(1<<(X86_FEATURE_CYRIX_ARR & 31))
>  # define DISABLE_CENTAUR_MCR	(1<<(X86_FEATURE_CENTAUR_MCR & 31))
>  # define DISABLE_PCID		0
> +# define DISABLE_SGX1		0
> +# define DISABLE_SGX2		0
>  #else
>  # define DISABLE_VME		0
>  # define DISABLE_K6_MTRR	0
>  # define DISABLE_CYRIX_ARR	0
>  # define DISABLE_CENTAUR_MCR	0
>  # define DISABLE_PCID		(1<<(X86_FEATURE_PCID & 31))
> -#endif /* CONFIG_X86_64 */
> +# define DISABLE_SGX1		(1<<(X86_FEATURE_SGX1 & 31))
> +# define DISABLE_SGX2		(1<<(X86_FEATURE_SGX2 & 31))
> + #endif /* CONFIG_X86_64 */
> +
>=20=20
>  #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
>  # define DISABLE_PKU		0
> @@ -56,6 +61,12 @@
>  # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
>  #endif
>=20=20
> +#ifdef CONFIG_INTEL_SGX
> +# define DISABLE_SGX	0
> +#else
> +# define DISABLE_SGX	(1 << (X86_FEATURE_SGX & 31))
> +#endif
> +
>  /*
>   * Make sure to add features to the correct mask
>   */
> @@ -68,7 +79,7 @@
>  #define DISABLED_MASK6	0
>  #define DISABLED_MASK7	(DISABLE_PTI)
>  #define DISABLED_MASK8	0
> -#define DISABLED_MASK9	(DISABLE_SMAP)
> +#define DISABLED_MASK9	(DISABLE_SMAP|DISABLE_SGX)
>  #define DISABLED_MASK10	0
>  #define DISABLED_MASK11	0
>  #define DISABLED_MASK12	0
> @@ -78,6 +89,7 @@
>  #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_=
UMIP)
>  #define DISABLED_MASK17	0
>  #define DISABLED_MASK18	0
> -#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS !=3D 19)
> +#define DISABLED_MASK19	(DISABLE_SGX1|DISABLE_SGX2)
> +#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS !=3D 20)
>=20=20
>  #endif /* _ASM_X86_DISABLED_FEATURES_H */
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-=
index.h
> index e8370e64a155..18e08da19f16 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -582,6 +582,7 @@
>  #define FEAT_CTL_LOCKED				BIT(0)
>  #define FEAT_CTL_VMX_ENABLED_INSIDE_SMX		BIT(1)
>  #define FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX	BIT(2)
> +#define FEAT_CTL_SGX_ENABLED			BIT(18)
>  #define FEAT_CTL_LMCE_ENABLED			BIT(20)
>=20=20
>  #define MSR_IA32_TSC_ADJUST             0x0000003b
> diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/=
asm/required-features.h
> index 6847d85400a8..039e58be2fe6 100644
> --- a/arch/x86/include/asm/required-features.h
> +++ b/arch/x86/include/asm/required-features.h
> @@ -101,6 +101,6 @@
>  #define REQUIRED_MASK16	0
>  #define REQUIRED_MASK17	0
>  #define REQUIRED_MASK18	0
> -#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS !=3D 19)
> +#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS !=3D 20)
>=20=20
>  #endif /* _ASM_X86_REQUIRED_FEATURES_H */
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 95c090a45b4b..7aecf5d07c70 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -914,6 +914,10 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
>  		c->x86_capability[CPUID_D_1_EAX] =3D eax;
>  	}
>=20=20
> +	/* Additional Intel-defined SGX flags: level 0x00000012 */
> +	if (c->cpuid_level >=3D 0x00000012)
> +		c->x86_capability[CPUID_12_EAX] =3D cpuid_eax(0x00000012);
> +
>  	/* AMD-defined flags: level 0x80000001 */
>  	eax =3D cpuid_eax(0x80000000);
>  	c->extended_cpuid_level =3D eax;
> --=20
> 2.25.1
