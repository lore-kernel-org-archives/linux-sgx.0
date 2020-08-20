Return-Path: <SRS0=LqHz=B6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 637A1C433E1
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 11:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30A5A2078D
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 11:25:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="SvZTZk5P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgHTLZD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Aug 2020 07:25:03 -0400
Received: from mail-dm6nam10on2106.outbound.protection.outlook.com ([40.107.93.106]:35808
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729640AbgHTLYI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Aug 2020 07:24:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuOOjXmuxrWZ7BQ+k1T4GXXT48iEaTFifemYKfCWLbJ9pGMmLy//Y84HxT5Kp81DoBPYk/xRWiRYLwBmbMj5GPx30x4TwSrC1ZoFF/kQgwfXKDvbi2eHBGIoi8mGXTOZlublort5Ad1ZtdOqjHAREKwlIhYWzkJh91Q2SfGUYyzmjeGO28aorjKkvinbnz3VuO/aYr2xsAVL5oN8GmL/cI4GmeM6mCAFFF3wgvAJrIeIN7dFvoVQW4ZB/wB3tk2LSSQaJ4sWh0v4vPBiv2OWu4GHgG9keHWnwo1r9l5rT3eu+dmsUj3gYsVySMPmMmIcAJBApERFpgZHjWzxjcYiNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvvZZMZ/7q6f967ZIgH1ix89gBK0BEIedC2+IqwK7hA=;
 b=bvHFkQj8IVaVy7GrJKpGucqBUScuQaMsrlVseqfshDDQxOvZ0uAAFayetWOeyuoSvDd0HkotmgttL5fp7FLZKaz8rRxqGKgdnG3R2B9JyqSYmmBcercUHH8g5jzJok4TwJZ9uh0GqgO7TaS/BYHZ1s2g942tImsLh5BPUzf+rJA1qmv+LnMIF5N3fRSn664cY3e06MoxsIOeayIcaXAnqNUV8S0Djbq3Uicrb2pmhy2sxLQ4LK5YyX9iYLdRxnrrX6b29voOsER1jkOXrehg+fBWLfCDZ3AaBD93GUxTg/wBTEaNoodeOsiKNh1U++Rb3lobPJ400CoG5AM16COTaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvvZZMZ/7q6f967ZIgH1ix89gBK0BEIedC2+IqwK7hA=;
 b=SvZTZk5P4Gz2iVWeUw3PI6gyRnMtOuePerNAk8aSmDnNTNWLWIt73q9NE8MhHDacCmH+xG0RgoBShz8iYPNtlKViS17pyIM/E32ddlRi7WpGXgzKbep23wXebatJhB4D6ce1Jlusyu+1rR84Wx3D+XXqUaoGRsaEfbCInfgaQSM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4259.namprd11.prod.outlook.com (2603:10b6:a03:1be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 11:24:03 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 11:24:03 +0000
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <89d6a1fc-ca83-6a7e-f10c-5160ebdcb794@fortanix.com>
Date:   Thu, 20 Aug 2020 13:23:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200818042405.12871-3-sean.j.christopherson@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070300000004000703000600"
X-ClientProxiedBy: LO2P265CA0287.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::35) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.195.0.246] (212.61.132.179) by LO2P265CA0287.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a1::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 11:24:01 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fa4c71d-79d0-445a-6a6c-08d844fb8a9d
X-MS-TrafficTypeDiagnostic: BY5PR11MB4259:
X-Microsoft-Antispam-PRVS: <BY5PR11MB42591D8390C94F8C68510381AA5A0@BY5PR11MB4259.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f+8WfLLIVf+T0HdxBGNuYQuJWiDMzp5yrC6oZAir3qkC74gPGFVOCs94Ms7fK4X7gtKSemU3DsRhlbMivhHs7sHNODty/Xm9qeF17bZRuNkZ9XlnLGaSBucW6oPITD13QZ9+YTbst+mkjFDarmmIDBE10f5c/pkb0bI7QcCwZnHmWAs0bViq9DwpY6Vob1YUZsbHFZHalf9ux8eMYkbFAAqBl1gnTMb+I9GUVlCDvhxP0NzrzYxOFQapNhmFPW8EYlZBhxmLnVhxAZkzNQPhwUTGGJINwPPoS4hS1peC3o0/KgdNaqv/KFh/GXJQ86RBwOJbaVnpdoqAz2HE4B6CSzdBh+AimTrzMVbaZ107gTr570XgwnPv9s25V+WcYD+w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(396003)(136003)(376002)(346002)(4326008)(6666004)(83380400001)(8676002)(26005)(16526019)(186003)(2906002)(36756003)(54906003)(6486002)(110136005)(16576012)(86362001)(316002)(478600001)(33964004)(8936002)(5660300002)(31696002)(235185007)(66946007)(53546011)(66476007)(66556008)(2616005)(956004)(52116002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: LsRsQ0eA1iXRFfMy26+1Tq4YQ6plG5Bo6Cn7kWJ4ZH2NcdhdeXtSE13hqPPl7LuiI016TskA3wNzywtIqEudYwjSROOF6XIaXuuWZTEUYjo51E5icxbdCO0dd5PQBkAwJ5re8GX4wU6blb22cBI5aMAalsA/3625Rl3FWE64Vp7aYLTaYXq9R5fYcUsJAMDerRvvVIF0qVFdnGN6FiyFqBckus+4ljBVlW1k6S07eqoWPpTrGE5B+7xHMaKAhVl2cHssLcIyyGwhWNRwNW2di6ETUTFThbRdnNuqDxB82wyN1TMzcQF9zzrZ5hEJmLxgJGi9QBLbo1Lnbeq14WVIJsak2yF1b00jIiHYziX8rjCFs+IvuWDETCX4J0aoNiXtDSxYKk40RYdZ7Mm1o4ShyCeEf38VsWFB1SPAE58rTklVQbTfKCHiUe3PL+xbhHFhvKMeFlyiM8S+17NdX3PQWTQjwUjSvUcBnMW2RTTi9VcIMJrY/fMEls/HFiF2qiFWPussn6sPquIBcXU/0Bflhja8JJQqdpA7jbozXxExyJcR+HvX1jBXxH1FO+unrQJXDsYxX5S+f8JLZYfoVIVWs0gkMH4AnMqqoWDs374ZNmCiQuDOv252WLxXNASA6PrzZcliA/6ayQ2Y7Y4sn6npvA==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa4c71d-79d0-445a-6a6c-08d844fb8a9d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 11:24:03.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hdrNLBdJTNXDeBNGyYFb0OCyR+yxGoATlSY6TYWS2SEpLl/dk4he2btCSk9684P6j7hEXmllDFG2o+mD+lBsMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4259
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms070300000004000703000600
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Tested-by: Jethro Beekman <jethro@fortanix.com>

--
Jethro Beekman | Fortanix

On 2020-08-18 06:24, Sean Christopherson wrote:
> Rework __vdso_sgx_enter_enclave() to use a struct to hold the input and=

> output params.  In the new struct, add an opaque "user_data" that can b=
e
> used to pass context across the vDSO, and an explicit "exit_reason" to
> avoid overloading the return value.
>=20
> Moving the params into a struct will also make it less painful to use
> dedicated exit reasons, and to support exiting on interrupts in future
> patches.
>=20
> Cc: Nathaniel McCallum <npmccallum@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 72 ++++++++++++-------
>  arch/x86/include/uapi/asm/sgx.h          | 90 ++++++++++++++++--------=

>  2 files changed, 107 insertions(+), 55 deletions(-)
>=20
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/=
vdso/vsgx_enter_enclave.S
> index 2d88acd408d4e..aaae6d6e28ac3 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -7,9 +7,21 @@
> =20
>  #include "extable.h"
> =20
> -#define EX_LEAF		0*8
> -#define EX_TRAPNR	0*8+4
> -#define EX_ERROR_CODE	0*8+6
> +/* Offset of 'struct sgx_enter_enclave' relative to %rbp. */
> +#define RUN_OFFSET	2*8
> +
> +/* Offsets into 'struct sgx_enter_enclave'. */
> +#define TCS_OFFEST		0*8
> +#define FLAGS_OFFSET		1*8
> +#define EXIT_LEAF_OFFSET	2*8
> +#define EXIT_REASON_OFFSET	2*8 + 4
> +#define USER_HANDLER_OFFSET	3*8
> +/* #define USER_DATA_OFFSET	4*8 */
> +#define EXCEPTION_OFFSET	5*8
> +
> +/* Offsets into sgx_enter_enclave.exception. */
> +#define EX_TRAPNR	0*8
> +#define EX_ERROR_CODE	0*8+2
>  #define EX_ADDRESS	1*8
> =20
>  .code64
> @@ -30,12 +42,18 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  .Lenter_enclave:
>  	/* EENTER <=3D leaf <=3D ERESUME */
>  	cmp	$EENTER, %eax
> -	jb	.Linvalid_leaf
> +	jb	.Linvalid_input
>  	cmp	$ERESUME, %eax
> -	ja	.Linvalid_leaf
> +	ja	.Linvalid_input
> +
> +	mov	RUN_OFFSET(%rbp), %rcx
> +
> +	/* No flags are currently defined/supported. */
> +	cmpq	$0, FLAGS_OFFSET(%rcx)
> +	jne	.Linvalid_input
> =20
>  	/* Load TCS and AEP */
> -	mov	0x10(%rbp), %rbx
> +	mov	TCS_OFFEST(%rcx), %rbx
>  	lea	.Lasync_exit_pointer(%rip), %rcx
> =20
>  	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> @@ -44,13 +62,21 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	enclu
> =20
>  	/* EEXIT jumps here unless the enclave is doing something fancy. */
> -	xor	%eax, %eax
> +	mov	RUN_OFFSET(%rbp), %rbx
> +
> +	/* Set exit_reason. */
> +	movl	$0, EXIT_REASON_OFFSET(%rbx)
> =20
>  	/* Invoke userspace's exit handler if one was provided. */
>  .Lhandle_exit:
> -	cmpq	$0, 0x20(%rbp)
> +	mov	%eax, EXIT_LEAF_OFFSET(%rbx)
> +
> +	cmpq	$0, USER_HANDLER_OFFSET(%rbx)
>  	jne	.Linvoke_userspace_handler
> =20
> +	/* Success, in the sense that ENCLU was attempted. */
> +	xor	%eax, %eax
> +
>  .Lout:
>  	pop	%rbx
>  	leave
> @@ -60,28 +86,28 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	/* The out-of-line code runs with the pre-leave stack frame. */
>  	.cfi_def_cfa		%rbp, 16
> =20
> -.Linvalid_leaf:
> +.Linvalid_input:
>  	mov	$(-EINVAL), %eax
>  	jmp	.Lout
> =20
>  .Lhandle_exception:
> -	mov	0x18(%rbp), %rcx
> -	test    %rcx, %rcx
> -	je	.Lskip_exception_info
> +	mov	RUN_OFFSET(%rbp), %rbx
> =20
> -	/* Fill optional exception info. */
> -	mov	%eax, EX_LEAF(%rcx)
> -	mov	%di,  EX_TRAPNR(%rcx)
> -	mov	%si,  EX_ERROR_CODE(%rcx)
> -	mov	%rdx, EX_ADDRESS(%rcx)
> -.Lskip_exception_info:
> -	mov	$(-EFAULT), %eax
> +	/* Set the exit_reason and exception info. */
> +	movl	$(-EFAULT), EXIT_REASON_OFFSET(%rbx)
> +
> +	mov	%di,  (EXCEPTION_OFFSET + EX_TRAPNR)(%rbx)
> +	mov	%si,  (EXCEPTION_OFFSET + EX_ERROR_CODE)(%rbx)
> +	mov	%rdx, (EXCEPTION_OFFSET + EX_ADDRESS)(%rbx)
>  	jmp	.Lhandle_exit
> =20
>  .Linvoke_userspace_handler:
>  	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
>  	mov	%rsp, %rcx
> =20
> +	/* Save @e, %rbx is about to be clobbered. */
> +	mov	%rbx, %rax
> +
>  	/* Save the untrusted RSP offset in %rbx (non-volatile register). */
>  	mov	%rsp, %rbx
>  	and	$0xf, %rbx
> @@ -93,20 +119,18 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	and	$-0x10, %rsp
>  	push	%rax
> =20
> -	/* Push @e, the "return" value and @tcs as params to the callback. */=

> -	push	0x18(%rbp)
> +	/* Push @e as a param to the callback. */
>  	push	%rax
> -	push	0x10(%rbp)
> =20
>  	/* Clear RFLAGS.DF per x86_64 ABI */
>  	cld
> =20
>  	/* Load the callback pointer to %rax and invoke it via retpoline. */
> -	mov	0x20(%rbp), %rax
> +	mov	USER_HANDLER_OFFSET(%rax), %rax
>  	call	.Lretpoline
> =20
>  	/* Undo the post-exit %rsp adjustment. */
> -	lea	0x20(%rsp, %rbx), %rsp
> +	lea	0x10(%rsp, %rbx), %rsp
> =20
>  	/*
>  	 * If the return from callback is zero or negative, return immediatel=
y,
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/as=
m/sgx.h
> index 3760e5d5dc0c7..d3b107aac279d 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -74,6 +74,28 @@ struct sgx_enclave_set_attribute {
>  	__u64 attribute_fd;
>  };
> =20
> +struct sgx_enclave_run;
> +
> +/**
> + * typedef sgx_enclave_exit_handler_t - Exit handler function accepted=
 by
> + *					__vdso_sgx_enter_enclave()
> + *
> + * @rdi:	RDI at the time of enclave exit
> + * @rsi:	RSI at the time of enclave exit
> + * @rdx:	RDX at the time of enclave exit
> + * @ursp:	RSP at the time of enclave exit (untrusted stack)
> + * @r8:		R8 at the time of enclave exit
> + * @r9:		R9 at the time of enclave exit
> + * @r:		Pointer to struct sgx_enclave_run (as provided by caller)
> + *
> + * Return:
> + *  0 or negative to exit vDSO
> + *  positive to re-enter enclave (must be EENTER or ERESUME leaf)
> + */
> +typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx=
,
> +					  long ursp, long r8, long r9,
> +					  struct sgx_enclave_run *r);
> +
>  /**
>   * struct sgx_enclave_exception - structure to report exceptions encou=
ntered in
>   *				  __vdso_sgx_enter_enclave()
> @@ -85,31 +107,43 @@ struct sgx_enclave_set_attribute {
>   * @reserved:	reserved for future use
>   */
>  struct sgx_enclave_exception {
> -	__u32 leaf;
>  	__u16 trapnr;
>  	__u16 error_code;
> +	__u32 reserved;
>  	__u64 address;
> -	__u64 reserved[2];
>  };
> =20
>  /**
> - * typedef sgx_enclave_exit_handler_t - Exit handler function accepted=
 by
> - *					__vdso_sgx_enter_enclave()
> + * struct sgx_enclave_run - Control structure for __vdso_sgx_enter_enc=
lave()
>   *
> - * @rdi:	RDI at the time of enclave exit
> - * @rsi:	RSI at the time of enclave exit
> - * @rdx:	RDX at the time of enclave exit
> - * @ursp:	RSP at the time of enclave exit (untrusted stack)
> - * @r8:		R8 at the time of enclave exit
> - * @r9:		R9 at the time of enclave exit
> - * @tcs:	Thread Control Structure used to enter enclave
> - * @ret:	0 on success (EEXIT), -EFAULT on an exception
> - * @e:		Pointer to struct sgx_enclave_exception (as provided by caller=
)
> + * @tcs:		Thread Control Structure used to enter enclave
> + * @flags:		Control flags
> + * @exit_leaf:		ENCLU leaf from \%eax at time of exit
> + * @exit_reason:	Cause of exit from enclave, e.g. EEXIT vs. exception
> + * @user_handler:	User provided exit handler (optional)
> + * @user_data:		User provided opaque value (optional)
> + * @exception:		Valid on exit due to exception
>   */
> -typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx=
,
> -					  long ursp, long r8, long r9,
> -					  void *tcs, int ret,
> -					  struct sgx_enclave_exception *e);
> +struct sgx_enclave_run {
> +	__u64 tcs;
> +	__u64 flags;
> +
> +	__u32 exit_leaf;
> +	__u32 exit_reason;
> +
> +	union {
> +		sgx_enclave_exit_handler_t user_handler;
> +		__u64 __user_handler;
> +	};
> +	__u64 user_data;
> +
> +	union {
> +		struct sgx_enclave_exception exception;
> +
> +		/* Pad the entire struct to 256 bytes. */
> +		__u8 pad[256 - 40];
> +	};
> +};
> =20
>  /**
>   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
> @@ -119,16 +153,14 @@ typedef int (*sgx_enclave_exit_handler_t)(long rd=
i, long rsi, long rdx,
>   * @leaf:	ENCLU leaf, must be EENTER or ERESUME
>   * @r8:		Pass-through value for R8
>   * @r9:		Pass-through value for R9
> - * @tcs:	TCS, must be non-NULL
> - * @e:		Optional struct sgx_enclave_exception instance
> - * @handler:	Optional enclave exit handler
> + * @r:		struct sgx_enclave_run, must be non-NULL
>   *
>   * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance wi=
th the
> - * x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT.  E=
xcept for
> - * non-volatile general purpose registers, preserving/setting state in=

> - * accordance with the x86-64 ABI is the responsibility of the enclave=
 and its
> - * runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C co=
de
> - * without careful consideration by both the enclave and its runtime.
> + * x86-64 ABI, e.g. doesn't handle XSAVE state.  Except for non-volati=
le
> + * general purpose registers, EFLAGS.DF, and RSP alignment, preserving=
/setting
> + * state in accordance with the x86-64 ABI is the responsibility of th=
e enclave
> + * and its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called f=
rom C
> + * code without careful consideration by both the enclave and its runt=
ime.
>   *
>   * All general purpose registers except RAX, RBX and RCX are passed as=
-is to
>   * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME a=
nd are
> @@ -160,16 +192,12 @@ typedef int (*sgx_enclave_exit_handler_t)(long rd=
i, long rsi, long rdx,
>   * without returning to __vdso_sgx_enter_enclave().
>   *
>   * Return:
> - *  0 on success,
> + *  0 on success (ENCLU reached),
>   *  -EINVAL if ENCLU leaf is not allowed,
> - *  -EFAULT if an exception occurs on ENCLU or within the enclave
> - *  -errno for all other negative values returned by the userspace exi=
t handler
>   */
>  typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned lo=
ng rsi,
>  					unsigned long rdx, unsigned int leaf,
>  					unsigned long r8,  unsigned long r9,
> -					void *tcs,
> -					struct sgx_enclave_exception *e,
> -					sgx_enclave_exit_handler_t handler);
> +					struct sgx_enclave_run *r);
> =20
>  #endif /* _UAPI_ASM_X86_SGX_H */
>=20


--------------ms070300000004000703000600
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
C54wggVPMIIEN6ADAgECAhAFFr+cC0ZYZTtbKgQCBwyyMA0GCSqGSIb3DQEBCwUAMIGCMQsw
CQYDVQQGEwJJVDEPMA0GA1UECAwGTWlsYW5vMQ8wDQYDVQQHDAZNaWxhbm8xIzAhBgNVBAoM
GkFjdGFsaXMgUy5wLkEuLzAzMzU4NTIwOTY3MSwwKgYDVQQDDCNBY3RhbGlzIENsaWVudCBB
dXRoZW50aWNhdGlvbiBDQSBHMTAeFw0xOTA5MTYwOTQ3MDlaFw0yMDA5MTYwOTQ3MDlaMB4x
HDAaBgNVBAMME2pldGhyb0Bmb3J0YW5peC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDHWEhcRGkEl1ZnImSqBt/OXNJ4AyDZ86CejuWI9jYpWbtf/gXBQO6iaaEKBDlj
Vffk2QxH9wcifkYsvCYfxFgD15dU9TABO7YOwvHa8NtxanWr1xomufu/P1ApI336+S7ZXfSe
qMnookNJUMHuF3Nxw2lI69LXqZLCdcVXquM4DY1lVSV+DXIwpTMtB+pMyqOWrsgmrISMZYFw
EUJOqVDvtU8KewhpuGAYXAQSDVLcAl2nZg7C2Mex8vT8stBoslPTkRXxAgMbslDNDUiKhy8d
E3I78P+stNHlFAgALgoYLBiVVLZkVBUPvgr2yUApR63yosztqp+jFhqfeHbjTRlLAgMBAAGj
ggIiMIICHjAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFH5g/Phspz09166ToXkCj7N0KTv1
MEsGCCsGAQUFBwEBBD8wPTA7BggrBgEFBQcwAoYvaHR0cDovL2NhY2VydC5hY3RhbGlzLml0
L2NlcnRzL2FjdGFsaXMtYXV0Y2xpZzEwHgYDVR0RBBcwFYETamV0aHJvQGZvcnRhbml4LmNv
bTBHBgNVHSAEQDA+MDwGBiuBHwEYATAyMDAGCCsGAQUFBwIBFiRodHRwczovL3d3dy5hY3Rh
bGlzLml0L2FyZWEtZG93bmxvYWQwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMIHo
BgNVHR8EgeAwgd0wgZuggZiggZWGgZJsZGFwOi8vbGRhcDA1LmFjdGFsaXMuaXQvY24lM2RB
Y3RhbGlzJTIwQ2xpZW50JTIwQXV0aGVudGljYXRpb24lMjBDQSUyMEcxLG8lM2RBY3RhbGlz
JTIwUy5wLkEuLzAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRI
Q0wtRzEvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUAXkM7yNq6pH6j+IC/7IsDPSTMnowDgYDVR0P
AQH/BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4IBAQC8z+2tLUwep0OhTQBgMaybrxTHCxRZ4/en
XB0zGVrry94pItE4ro4To/t86Kfcic41ZsaX8/SFVUW2NNHjEodJu94UhYqPMDUVjO6Y14s2
jznFHyKQdXMrhIBU5lzYqyh97w6s82Z/qoMy3OuLek+8rXirwju9ATSNLsFTzt2CEoyCSRtl
yOmR7Z9wgSvD7C7XoBdGEFVdGCXwCy1t9AT7UCIHKssnguVaMGN9vWqLPVKOVTwc4g3RAQC7
J1Aoo6U5d6wCIX4MxEZhICxnUgAKHULxsWMGjBfQAo3QGXjJ4wDEu7O/5KCyUfn6lyhRYa+t
YgyFAX0ZU9Upovd+aOw0MIIGRzCCBC+gAwIBAgIILNSK07EeD4kwDQYJKoZIhvcNAQELBQAw
azELMAkGA1UEBhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3RhbGlzIFMucC5B
Li8wMzM1ODUyMDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlvbiBSb290IENB
MB4XDTE1MDUxNDA3MTQxNVoXDTMwMDUxNDA3MTQxNVowgYIxCzAJBgNVBAYTAklUMQ8wDQYD
VQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4v
MDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENB
IEcxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwPzBiVbZiOL0BGW/zQk1qygp
MP4MyvcnqxwR7oY9XeT1bES2DFczlZfeiIqNLanbkyqTxydXZ+kxoS9071qWsZ6zS+pxSqXL
s+RTvndEaWx5hdHZcKNWGzhy5FiO4GZvGlFInFEiaY+dOEpjjWvSeXpvcDpnYw6M9AXuHo4J
hjC3P/OK//5QFXnztTa4iU66RpLteOTgCtiRCwZNKx8EFeqqfTpYvfEb4H91E7n+Y61jm0d2
E8fJ2wGTaSSwjc8nTI2ApXujoczukb2kHqwaGP3q5UuedWcnRZc65XUhK/Z6K32KvrQuNP32
F/5MxkvEDnJpUnnt9iMExvEzn31zDQIDAQABo4IB1TCCAdEwQQYIKwYBBQUHAQEENTAzMDEG
CCsGAQUFBzABhiVodHRwOi8vb2NzcDA1LmFjdGFsaXMuaXQvVkEvQVVUSC1ST09UMB0GA1Ud
DgQWBBR+YPz4bKc9Pdeuk6F5Ao+zdCk79TAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaA
FFLYiDrIn3hm7YnzezhwlMkCAjbQMEUGA1UdIAQ+MDwwOgYEVR0gADAyMDAGCCsGAQUFBwIB
FiRodHRwczovL3d3dy5hY3RhbGlzLml0L2FyZWEtZG93bmxvYWQwgeMGA1UdHwSB2zCB2DCB
lqCBk6CBkIaBjWxkYXA6Ly9sZGFwMDUuYWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRo
ZW50aWNhdGlvbiUyMFJvb3QlMjBDQSxvJTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIw
OTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0
cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAO
BgNVHQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQELBQADggIBAE2TztUkvkEbShZYc19lifLZej5Y
jLzLxA/lWxZnssFLpDPySfzMmndz3F06S51ltwDe+blTwcpdzUl3M2alKH3bOr855ku9Rr6u
edya+HGQUT0OhqDo2K2CAE9nBcfANxifjfT8XzCoC3ctf9ux3og1WuE8WTcLZKgCMuNRBmJt
e9C4Ug0w3iXqPzq8KuRRobNKqddPjk3EiK+QA+EFCCka1xOLh/7cPGTJMNta1/0u5oLiXaOA
HeALt/nqeZ2kZ+lizK8oTv4in5avIf3ela3oL6vrwpTca7TZxTX90e805dZQN4qRVPdPbrBl
WtNozH7SdLeLrcoN8l2EXO6190GAJYdynTc2E6EyrLVGcDKUX91VmCSRrqEppZ7W05TbWRLi
6+wPjAzmTq2XSmKfajq7juTKgkkw7FFJByixa0NdSZosdQb3VkLqG8EOYOamZLqH+v7ua0+u
lg7FOviFbeZ7YR9eRO81O8FC1uLgutlyGD2+GLjgQnsvneDsbNAWfkory+qqAxvVzX5PSaQp
2pJ52AaIH1MN1i2/geRSP83TRMrFkwuIMzDhXxKFQvpspNc19vcTryzjtwP4xq0WNS4YWPS4
U+9mW+U0Cgnsgx9fMiJNbLflf5qSb53j3AGHnjK/qJzPa39wFTXLXB648F3w1Qf9R7eZeTRJ
fCQY/fJUMYID9jCCA/ICAQEwgZcwgYIxCzAJBgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8x
DzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5Njcx
LDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZY
ZTtbKgQCBwyyMA0GCWCGSAFlAwQCAQUAoIICLzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjAxMTIzNTZaMC8GCSqGSIb3DQEJBDEiBCD3NJtR9/zM
en0NgV+UHenjbzeeeKnCYNsTQaYU+BZqKTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAOAcDmX9ZxV25MjEPEMGztSEW2nd1UmM9iR0rwSWvti0U+Kj0X+GA/oL6
agsoJV1SVOy2y/4JPRQmiPaGEpIFriep5Wsgrjehpzo8nlkfbj2XHy2fsClpC8aM8MBeSvZZ
yGxWEoBSEM2gFhQMVEdrbz4KyhOxYRPDnYo7dB3Dp8cn6RoDbapD8/U/PqMNG2K8xjiy/azV
TzwfJdLsiU+8JovWi4bqM1QFcx+X0c7UiF5+EO/IN8fqZ+l+WXTkoE6V9vWyxUu7XIVwAdlx
g/udt3Hb29/UQfIg3YSPPSFQzP0JmVVGgeDnqestQ2O8RbfRxKYLkxJhmw+rgt7iz9nUEgAA
AAAAAA==

--------------ms070300000004000703000600--
