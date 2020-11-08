Return-Path: <SRS0=Aco+=EO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85AAC388F9
	for <linux-sgx@archiver.kernel.org>; Sun,  8 Nov 2020 20:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7431420731
	for <linux-sgx@archiver.kernel.org>; Sun,  8 Nov 2020 20:08:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="FTFsiHXU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgKHUIz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 8 Nov 2020 15:08:55 -0500
Received: from mail-bn8nam08on2121.outbound.protection.outlook.com ([40.107.100.121]:13728
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728006AbgKHUIz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 8 Nov 2020 15:08:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXejhx3CybKI4/y1c7tDimM5hSsBcY4WtZ260q1q4yuEqLcnvyH+Px1B/7L1FqLmsdG1L0xg0oF1EVss0xDd/klWnrprP0zMh00Tc7+/VLXnHtTn7oPatFovJZUchPTcbUt83ydIY342xq3+RyQHydGHLlWyQMKeZFT59ehkzRSVfPG1KMpqCZeX7tXvWDUv93PHthAliZLIhwyh/JUQsmPr6iZi+NfVJvy1PX8eF2dqQXJ+PYKyEGP9Hg7elk57NgF2E0FXuoEfhrffrNsSto4MQGwiGr2nToUDieRYAeVg6do8Ok+hYKngmnGGlf030SKScLW7d2g38vSELupRng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRk1flmRCaW2nS5gDE4Scm5RAvqDB7YG0i3Gt3+At7E=;
 b=OlvDOpMjo55QgDFVxxfguNpcso5ImD/VJpHjqrt2fUdBe/CQ0WVNeIYjTozHAoohDNDFLhSONGabVwqLeU1dBE53DF18cKj1jC75HPNdxO/ub7OQaKhyVTZL8Z7bTXWzF3QTnrgZy/qOLMxCdvF6CUs4x5ASdJNBDl1ml5aMUX5evm9rPoroiX1lenZvI+ZEf2bHlOY/a1AWAIZw7K/NnXwGFIlJOBCezketqeTwv89Hw0ZBk9dP24W2pfc2QGQHiRXKV+WWrdNM1wgrPTu/nPiy0U3zh0Y65UaA78XWrxkBvAKLzoWT3225FzGTtVRMIZQ5RSi5V88dKONPUtOsbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRk1flmRCaW2nS5gDE4Scm5RAvqDB7YG0i3Gt3+At7E=;
 b=FTFsiHXUsoRhsryx0nvBBxS6FzXc9Ry6N+tKjr/kQUkEcn3SLLV4XF5zTf7mIIq50z2e92YzK5irHNxoZkznP/8opphiwRbkyR2K4QXh8dvWHU9yjGnQpyMS2OGHkGeJMgA167AYnC63auFfzOFD+HmyXh454Rv8ST3lveRlnI0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fortanix.com;
Received: from CH2PR11MB4262.namprd11.prod.outlook.com (2603:10b6:610:42::13)
 by CH2PR11MB4341.namprd11.prod.outlook.com (2603:10b6:610:3c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Sun, 8 Nov
 2020 20:08:49 +0000
Received: from CH2PR11MB4262.namprd11.prod.outlook.com
 ([fe80::c4d:afdf:4dfe:2706]) by CH2PR11MB4262.namprd11.prod.outlook.com
 ([fe80::c4d:afdf:4dfe:2706%4]) with mapi id 15.20.3499.032; Sun, 8 Nov 2020
 20:08:49 +0000
Subject: Re: [PATCH v40 19/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-20-jarkko.sakkinen@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <aa60d492-b902-5ff2-38a0-306a31b0eaf5@fortanix.com>
Date:   Sun, 8 Nov 2020 21:08:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201104145430.300542-20-jarkko.sakkinen@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070202020800020606060102"
X-Originating-IP: [213.127.125.17]
X-ClientProxiedBy: AM4PR0302CA0002.eurprd03.prod.outlook.com
 (2603:10a6:205:2::15) To CH2PR11MB4262.namprd11.prod.outlook.com
 (2603:10b6:610:42::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.125.17) by AM4PR0302CA0002.eurprd03.prod.outlook.com (2603:10a6:205:2::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Sun, 8 Nov 2020 20:08:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc0e83b7-a368-42b4-b9b3-08d884221aac
X-MS-TrafficTypeDiagnostic: CH2PR11MB4341:
X-Microsoft-Antispam-PRVS: <CH2PR11MB434114537D22DF5A6C0DDCBFAAEB0@CH2PR11MB4341.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LUmL/1AX9LU6SR5rQGrf/pCn+86IjRrjX34WgBKNSNZm2c89WibC+VPLk10z8dMBKQGsojyKUMRi+g4qmrKI2l9fnVCwNUSSn1T8p7JV0ZHrD7MNMpOVkJPCY4KPDQqnKtZN6pVgwK8zDwjwXC3/f1aAOwL4J+4RkCjYUKsCUMF/4NypkZGpRcZ2tv71ThwphjySt7RQVucvGNXB0INARXdelF91ljdyDAqfqCr0sn+wc91LzaYbDeYAqC3GHPzA2yLbYgfuKCyKHZTGFeWggW0qGYzbDFdvKjbw8nBBwvrAQf7+YmeRPKXl8eDqTYHha7tBvt+M/mibKBJo7b4qO35ZoO76iJhC0A3Cp+2EA332vFZPCelc6qUlv9zhoFcQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR11MB4262.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39830400003)(2616005)(8936002)(26005)(6486002)(86362001)(52116002)(66476007)(478600001)(66946007)(6666004)(66556008)(31686004)(2906002)(4326008)(31696002)(186003)(16526019)(33964004)(36756003)(16576012)(83380400001)(7416002)(53546011)(54906003)(8676002)(235185007)(316002)(30864003)(5660300002)(956004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: r/jNaeFBQDu/ErBpIpMGbDfzJ0PAbGRPWWGF90E+dFb7YFLNWdt/VdYbacDm39i/d0XGV1x5MgZmxi6vr2OvS6u7Q2lXASn+MOoruosy11LFSQ/TOnNtgAeKpmYNSjYFleWvwzR53Kk8KuNlLszpv0oO0sWCBbZbxKD5fGPXUJHNmTJj2Ll9nDWJU3553EPHdxDOnsOpr4Gzk+/R7cxWHFQj848uwLipTscveh3M4ylW+/s8BpZyijUwoErai3o9Ywh0H2PZxrb0hea8aWsxummsu0ZqnYxjthrGPHucUpQEiJEykmAuADivTpSMkU7Ca+cjXa3BNbX+dgbrDtOVVluu/iajQttczNdmxVeu1jebWvQinFeV0WglEmRMK7pUVhWGvyRdlatG5MskM92pm5pfGNC7bIvI7h0NpnzAXsvZ9OCfBufdFT4QzSA6C9Jn5LwH9MzTDhNoeaf6lRH/bWZaYH4gjLOnQPCQvBBUW/eVaFR/Sc7/U4DhBlmFt7uq0LpcoLIy3SRjaG4kfI6aa+uIKhEEr5ou2x/Cl/QAJEm8VhiySjS7l/XhLAw2O0ffe/OcYO7QhIiRajYcebIrDQxR1mHRJhoTJ/JjU882jIzfwJ3JsXisiepuFqY4CV0uEB/xUrSbAPluo9qJgBeCDg==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0e83b7-a368-42b4-b9b3-08d884221aac
X-MS-Exchange-CrossTenant-AuthSource: CH2PR11MB4262.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2020 20:08:48.9993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lkt7J8FO8JwOluHAuoWkmivOkkgAzx3qsVu+ntw7iMNDjG+XyNAnFumRwoan1a0WG1jyKoRXC+lmZOvsbxYYuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4341
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms070202020800020606060102
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-11-04 15:54, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> Enclaves encounter exceptions for lots of reasons: everything from encl=
ave
> page faults to NULL pointer dereferences, to system calls that must be
> =E2=80=9Cproxied=E2=80=9D to the kernel from outside the enclave.
>=20
> In addition to the code contained inside an enclave, there is also
> supporting code outside the enclave called an =E2=80=9CSGX runtime=E2=80=
=9D, which is
> virtually always implemented inside a shared library.  The runtime help=
s
> build the enclave and handles things like *re*building the enclave if i=
t
> got destroyed by something like a suspend/resume cycle.
>=20
> The rebuilding has traditionally been handled in SIGSEGV handlers,
> registered by the library.  But, being process-wide, shared state, sign=
al
> handling and shared libraries do not mix well.
>=20
> Introduce a vDSO function call that wraps the enclave entry functions
> (EENTER/ERESUME functions of the ENCLU instruciton) and returns informa=
tion
> about any exceptions to the caller in the SGX runtime.
>=20
> Instead of generating a signal, the kernel places exception information=
 in
> RDI, RSI and RDX. The kernel-provided userspace portion of the vDSO han=
dler
> will place this information in a user-provided buffer or trigger a
> user-provided callback at the time of the exception.
>=20
> The vDSO function calling convention uses the standard RDI RSI, RDX, RC=
X,
> R8 and R9 registers.  This makes it possible to declare the vDSO as a C=

> prototype, but other than that there is no specific support for SystemV=

> ABI. Things like storing XSAVE are the responsibility of the enclave an=
d
> the runtime.
>=20
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Tested-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Cedric Xing <cedric.xing@intel.com>
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
> Changes from v39:
> * Relayout out the user handler documentation: return values are descri=
bed
>   in sgx_enclave_user_handler_t keneldoc and broad description is given=

>   in struct sgx_enclave_run kerneldoc.
> * Rename @leaf as @function, given that we want to speak consistently
>   about ENCLS and ENCLU functions.
> * Reorder user_handler and user_data as the last fields in
>   sgx_enclave_run, as they are an extension to the basic functionality.=

>=20
>  arch/x86/entry/vdso/Makefile    |   2 +
>  arch/x86/entry/vdso/vdso.lds.S  |   1 +
>  arch/x86/entry/vdso/vsgx.S      | 151 ++++++++++++++++++++++++++++++++=

>  arch/x86/include/asm/enclu.h    |   9 ++
>  arch/x86/include/uapi/asm/sgx.h |  91 +++++++++++++++++++
>  5 files changed, 254 insertions(+)
>  create mode 100644 arch/x86/entry/vdso/vsgx.S
>  create mode 100644 arch/x86/include/asm/enclu.h
>=20
> diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefil=
e
> index 2ad757fb3c23..9915fbd34264 100644
> --- a/arch/x86/entry/vdso/Makefile
> +++ b/arch/x86/entry/vdso/Makefile
> @@ -27,6 +27,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)	:=3D y
>  vobjs-y :=3D vdso-note.o vclock_gettime.o vgetcpu.o
>  vobjs32-y :=3D vdso32/note.o vdso32/system_call.o vdso32/sigreturn.o
>  vobjs32-y +=3D vdso32/vclock_gettime.o
> +vobjs-$(VDSO64-y)		+=3D vsgx.o
> =20
>  # files to link into kernel
>  obj-y				+=3D vma.o extable.o
> @@ -98,6 +99,7 @@ $(vobjs): KBUILD_CFLAGS :=3D $(filter-out $(GCC_PLUGI=
NS_CFLAGS) $(RETPOLINE_CFLAGS
>  CFLAGS_REMOVE_vclock_gettime.o =3D -pg
>  CFLAGS_REMOVE_vdso32/vclock_gettime.o =3D -pg
>  CFLAGS_REMOVE_vgetcpu.o =3D -pg
> +CFLAGS_REMOVE_vsgx.o =3D -pg
> =20
>  #
>  # X32 processes use x32 vDSO to access 64bit kernel data.
> diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vdso.=
lds.S
> index 36b644e16272..4bf48462fca7 100644
> --- a/arch/x86/entry/vdso/vdso.lds.S
> +++ b/arch/x86/entry/vdso/vdso.lds.S
> @@ -27,6 +27,7 @@ VERSION {
>  		__vdso_time;
>  		clock_getres;
>  		__vdso_clock_getres;
> +		__vdso_sgx_enter_enclave;
>  	local: *;
>  	};
>  }
> diff --git a/arch/x86/entry/vdso/vsgx.S b/arch/x86/entry/vdso/vsgx.S
> new file mode 100644
> index 000000000000..86a0e94f68df
> --- /dev/null
> +++ b/arch/x86/entry/vdso/vsgx.S
> @@ -0,0 +1,151 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include <linux/linkage.h>
> +#include <asm/export.h>
> +#include <asm/errno.h>
> +#include <asm/enclu.h>
> +
> +#include "extable.h"
> +
> +/* Relative to %rbp. */
> +#define SGX_ENCLAVE_OFFSET_OF_RUN		16
> +
> +/* The offsets relative to struct sgx_enclave_run. */
> +#define SGX_ENCLAVE_RUN_TCS			0
> +#define SGX_ENCLAVE_RUN_LEAF			8
> +#define SGX_ENCLAVE_RUN_EXCEPTION_VECTOR	12
> +#define SGX_ENCLAVE_RUN_EXCEPTION_ERROR_CODE	14
> +#define SGX_ENCLAVE_RUN_EXCEPTION_ADDR		16
> +#define SGX_ENCLAVE_RUN_USER_HANDLER		24
> +#define SGX_ENCLAVE_RUN_USER_DATA		32	/* not used */
> +#define SGX_ENCLAVE_RUN_RESERVED_START		40
> +#define SGX_ENCLAVE_RUN_RESERVED_END		256
> +
> +.code64
> +.section .text, "ax"
> +
> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
> +	/* Prolog */
> +	.cfi_startproc
> +	push	%rbp
> +	.cfi_adjust_cfa_offset	8
> +	.cfi_rel_offset		%rbp, 0
> +	mov	%rsp, %rbp
> +	.cfi_def_cfa_register	%rbp
> +	push	%rbx
> +	.cfi_rel_offset		%rbx, -8
> +
> +	mov	%ecx, %eax
> +.Lenter_enclave:
> +	/* EENTER <=3D function <=3D ERESUME */
> +	cmp	$EENTER, %eax
> +	jb	.Linvalid_input
> +	cmp	$ERESUME, %eax
> +	ja	.Linvalid_input
> +
> +	mov	SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rcx
> +
> +	/* Validate that the reserved area contains only zeros. */
> +	mov	$SGX_ENCLAVE_RUN_RESERVED_START, %rbx
> +1:
> +	cmpq	$0, (%rcx, %rbx)
> +	jne	.Linvalid_input
> +	add	$8, %rbx
> +	cmpq	$SGX_ENCLAVE_RUN_RESERVED_END, %rbx
> +	jne	1b
> +
> +	/* Load TCS and AEP */
> +	mov	SGX_ENCLAVE_RUN_TCS(%rcx), %rbx
> +	lea	.Lasync_exit_pointer(%rip), %rcx
> +
> +	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> +.Lasync_exit_pointer:
> +.Lenclu_eenter_eresume:
> +	enclu
> +
> +	/* EEXIT jumps here unless the enclave is doing something fancy. */
> +	mov	SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rbx
> +
> +	/* Set exit_reason. */
> +	movl	$EEXIT, SGX_ENCLAVE_RUN_LEAF(%rbx)
> +
> +	/* Invoke userspace's exit handler if one was provided. */
> +.Lhandle_exit:
> +	cmpq	$0, SGX_ENCLAVE_RUN_USER_HANDLER(%rbx)
> +	jne	.Linvoke_userspace_handler
> +
> +	/* Success, in the sense that ENCLU was attempted. */
> +	xor	%eax, %eax
> +
> +.Lout:
> +	pop	%rbx
> +	leave
> +	.cfi_def_cfa		%rsp, 8
> +	ret
> +
> +	/* The out-of-line code runs with the pre-leave stack frame. */
> +	.cfi_def_cfa		%rbp, 16
> +
> +.Linvalid_input:
> +	mov	$(-EINVAL), %eax
> +	jmp	.Lout
> +
> +.Lhandle_exception:
> +	mov	SGX_ENCLAVE_OFFSET_OF_RUN(%rbp), %rbx
> +
> +	/* Set the exception info. */
> +	mov	%eax, (SGX_ENCLAVE_RUN_LEAF)(%rbx)
> +	mov	%di,  (SGX_ENCLAVE_RUN_EXCEPTION_VECTOR)(%rbx)
> +	mov	%si,  (SGX_ENCLAVE_RUN_EXCEPTION_ERROR_CODE)(%rbx)
> +	mov	%rdx, (SGX_ENCLAVE_RUN_EXCEPTION_ADDR)(%rbx)
> +	jmp	.Lhandle_exit
> +
> +.Linvoke_userspace_handler:
> +	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
> +	mov	%rsp, %rcx
> +
> +	/* Save struct sgx_enclave_exception %rbx is about to be clobbered. *=
/
> +	mov	%rbx, %rax
> +
> +	/* Save the untrusted RSP offset in %rbx (non-volatile register). */
> +	mov	%rsp, %rbx
> +	and	$0xf, %rbx
> +
> +	/*
> +	 * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned=

> +	 * _after_ pushing the parameters on the stack, hence the bonus push.=

> +	 */
> +	and	$-0x10, %rsp
> +	push	%rax
> +
> +	/* Push struct sgx_enclave_exception as a param to the callback. */
> +	push	%rax
> +
> +	/* Clear RFLAGS.DF per x86_64 ABI */
> +	cld
> +
> +	/*
> +	 * Load the callback pointer to %rax and lfence for LVI (load value
> +	 * injection) protection before making the call.
> +	 */
> +	mov	SGX_ENCLAVE_RUN_USER_HANDLER(%rax), %rax
> +	lfence
> +	call	*%rax
> +
> +	/* Undo the post-exit %rsp adjustment. */
> +	lea	0x10(%rsp, %rbx), %rsp
> +
> +	/*
> +	 * If the return from callback is zero or negative, return immediatel=
y,
> +	 * else re-execute ENCLU with the postive return value interpreted as=

> +	 * the requested ENCLU function.
> +	 */
> +	cmp	$0, %eax
> +	jle	.Lout
> +	jmp	.Lenter_enclave
> +
> +	.cfi_endproc
> +
> +_ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
> +
> +SYM_FUNC_END(__vdso_sgx_enter_enclave)
> diff --git a/arch/x86/include/asm/enclu.h b/arch/x86/include/asm/enclu.=
h
> new file mode 100644
> index 000000000000..b1314e41a744
> --- /dev/null
> +++ b/arch/x86/include/asm/enclu.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_X86_ENCLU_H
> +#define _ASM_X86_ENCLU_H
> +
> +#define EENTER	0x02
> +#define ERESUME	0x03
> +#define EEXIT	0x04
> +
> +#endif /* _ASM_X86_ENCLU_H */
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/as=
m/sgx.h
> index c32210235bf5..791e45334a4a 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -74,4 +74,95 @@ struct sgx_enclave_provision {
>  	__u64 fd;
>  };
> =20
> +struct sgx_enclave_run;
> +
> +/**
> + * typedef sgx_enclave_user_handler_t - Exit handler function accepted=
 by
> + *					__vdso_sgx_enter_enclave()
> + * @run:	The run instance given by the caller
> + *
> + * The register parameters contain the snapshot of their values at enc=
lave
> + * exit. An invalid ENCLU function number will cause -EINVAL to be ret=
urned
> + * to the caller.
> + *
> + * Return:
> + * - <=3D 0:	The given value is returned back to the caller.
> + * - > 0:	ENCLU function to invoke, either EENTER or ERESUME.
> + */
> +typedef int (*sgx_enclave_user_handler_t)(long rdi, long rsi, long rdx=
,
> +					  long rsp, long r8, long r9,
> +					  struct sgx_enclave_run *run);
> +
> +/**
> + * struct sgx_enclave_run - the execution context of __vdso_sgx_enter_=
enclave()
> + * @tcs:			TCS used to enter the enclave
> + * @function:			The last seen ENCLU function (EENTER, ERESUME or EEXIT=
)
> + * @exception_vector:		The interrupt vector of the exception
> + * @exception_error_code:	The exception error code pulled out of the s=
tack
> + * @exception_addr:		The address that triggered the exception
> + * @user_handler:		User provided callback run on exception
> + * @user_data:			Data passed to the user handler
> + * @reserved			Reserved for future extensions
> + *
> + * If @user_handler is provided, the handler will be invoked on all re=
turn paths
> + * of the normal flow.  The user handler may transfer control, e.g. vi=
a a
> + * longjmp() call or a C++ exception, without returning to
> + * __vdso_sgx_enter_enclave().
> + */
> +struct sgx_enclave_run {
> +	__u64 tcs;
> +	__u32 function;
> +	__u16 exception_vector;
> +	__u16 exception_error_code;
> +	__u64 exception_addr;
> +	__u64 user_handler;
> +	__u64 user_data;
> +	__u8  reserved[216];
> +};
> +
> +/**
> + * typedef vdso_sgx_enter_enclave_t - Prototype for __vdso_sgx_enter_e=
nclave(),
> + *				      a vDSO function to enter an SGX enclave.
> + * @rdi:	Pass-through value for RDI
> + * @rsi:	Pass-through value for RSI
> + * @rdx:	Pass-through value for RDX
> + * @function:	ENCLU function, must be EENTER or ERESUME
> + * @r8:		Pass-through value for R8
> + * @r9:		Pass-through value for R9
> + * @run:	struct sgx_enclave_run, must be non-NULL
> + *
> + * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance wi=
th the
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
> + *
> + * All general purpose registers except RAX, RBX and RCX are passed as=
-is to the
> + * enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME and a=
re loaded
> + * with @function, asynchronous exit pointer, and @run.tcs respectivel=
y.
> + *
> + * RBP and the stack are used to anchor __vdso_sgx_enter_enclave() to =
the
> + * pre-enclave state, e.g. to retrieve @run.exception and @run.user_ha=
ndler
> + * after an enclave exit.  All other registers are available for use b=
y the
> + * enclave and its runtime, e.g. an enclave can push additional data o=
nto the
> + * stack (and modify RSP) to pass information to the optional user han=
dler (see
> + * below).
> + *
> + * Most exceptions reported on ENCLU, including those that occur withi=
n the
> + * enclave, are fixed up and reported synchronously instead of being d=
elivered
> + * via a standard signal. Debug Exceptions (#DB) and Breakpoints (#BP)=
 are
> + * never fixed up and are always delivered via standard signals. On sy=
nchrously
> + * reported exceptions, -EFAULT is returned

This part about EFAULT is also bogus.

--
Jethro Beekman | Fortanix


--------------ms070202020800020606060102
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
JTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJl
dm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVw
b3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUvpepqoS/gL8QU30JMvnh
LjIbz3cwDgYDVR0PAQH/BAQDAgEGMA0GCSqGSIb3DQEBCwUAA4ICAQAmm+cbWQ10sxID6edV
94SAhc1CwzthHFfHpuYS30gisWUfWpgp43Dg1XzG2in3VGV7XrzCCGZh4JM/XQWp+4oxmyV4
2Qjz9vc8GRksgo6X2nYObPYZzQjda9wxsCB38i4G3H33w8lf9sFvl0xm4ZXZ2s2bF/PdqvrK
0ZgvF51+MoIPnli/wJBw3p72xbk5Sb1MneSO3tZ293WFzDmz7tuGU0PfytYUkG7O6annGqbU
1I6CA6QVKUqeFLPodSODAFqJ3pimKD0vX9MuuSa0QinH7CkiPtZMD0mpwwzIsnSs3qOOl60t
IZQOTc0I6lCe1LLhrz7Q75J6nNL9N5zVwZ1I3o2Lb8Dt7BA13VFuZvZIzapUGV83R7pmSVaj
1Bik1nJ/R393e6mwppsT140KDVLh4Oenywmp2VpBDuEj9RgICAO0sibv8n379LbO7ARa0kw9
y9pggFzN2PAX25b7w0n9m78kpv3z3vW65rs6wl7E8VEHNfv8+cnb81dxN3C51KElz+l31zch
FTurD5HFEpyEhzO/fMS5AkweRJIzwozxNs7OL/S/SVTpJLJL1ukZ1lnHHX0d3xCzRy/5HqfK
3uiG22LPB5+RjNDobPAjAz2BKMfkF/+v0pzn8mqqkopQaJzEAbLbMpgQYHRCjvrUxxwjJyUF
b2Z+40UNtMF4MTK7zTGCA/MwggPvAgEBMIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwH
QmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBT
LnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBu
kmvE8GLB9+EYd88699DiMA0GCWCGSAFlAwQCAQUAoIICLTAYBgkqhkiG9w0BCQMxCwYJKoZI
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDgyMDA4NDFaMC8GCSqGSIb3DQEJBDEiBCDo
VJGZcoONmOeAA90GLdwY5z26x6JEd8MK3eIp02QdtzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAIVR11nooTqWEaCumvQI4ENthjIrl9pKi5Xrvldb2cK21A3Dosi+
BmkmLYQZhoBNTNhj6hKbhb+jrhdYgZ11hM5FHnTVwII6d22wcdwe4SYB5z6xjuGQ2Ile2rDr
jsR0kj/b6gMh9RiM0lRG1ZAL824YKwYBQgxtcwr1GtoTrXLd+0fFvkePth5STywgaOEfzV9h
VYHO8tkg7a/bP2tZbqX/z41raL/wfx2VJx+X4z9dSHIX8A2NBhbjN7AqrYE2JrabbgLvCUSw
YYgpFjRcrWe6Sa6CQ4FuLle0u+a21Nj3DsPujbeDUUdKiKbjbvS4mdy/sFwNVo4CTm8prTMQ
9AwAAAAAAAA=

--------------ms070202020800020606060102--
