Return-Path: <SRS0=Ypn8=AZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC06C433E2
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jul 2020 07:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B0D204EC
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jul 2020 07:30:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="nsmFCdAw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgGNHaU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:30:20 -0400
Received: from mail-mw2nam12on2128.outbound.protection.outlook.com ([40.107.244.128]:16832
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgGNHaT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 Jul 2020 03:30:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2459xA0c/HxFPxSuDRy6WlOnN/XN1r3kRDY/Wtq+k3AOpJd+usCTEfDOfL0hVtNx+S+U03a1hNK70WJ7DMLjbzr7w9JwRj29HE91zBP2N7WiBhURexHit0naDQvZ1T/TePcssC/eFyG42sWR3BZxknwzQnvxbceQ/NKeWqpaQBSG03yu/gvg7XMlhJxfujFNRobspdT6WbXRVBG/mlq80fLnpHvJNLj92Jg/Ej4d+d3lOvOJwdklhfEDX79/WXwMmbL2lKDrlvlGFOwJ0Y903io5GHhuuKKqbRT0gk8jkjdDgJ7QptxbPvJt3euCLEBij2M8KurTmod6vFcabYzfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+An4QI1bibmCJ+lheFaJIGCAsUGSNXz5YYWAXtmrSE=;
 b=D3K7qvbY/avWzWVn1fSQhbbE29tMlDyJcNDfNyV4LHWoaEIJmEvGbWhD6IriS70c6z5FX0R28luW2KeQPtbXyIw/DT6dHJmFJGcLSzcBFyeJ2AR1YW1W7jfKrs9plwAKRfPctZ9iEnX/fFxIFciEXSNdRAMHgTcdt5HggUmydUSJjsqa6TXIWpzcBVbAmkG9oJ/mQYXz7TX48RIxgCrzx72ldc9QFl0K4lCfRWQ0u9JtHWH3sXG449UXeN/FsRdhj/4NkkzMLPcFgHKsGaCOBm8F+plOjRpIc+8kvq1vVki+MvzaS+KNAlrmWuZWpsXPIj1Z4TihRY/Zqgbd0+Rfwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+An4QI1bibmCJ+lheFaJIGCAsUGSNXz5YYWAXtmrSE=;
 b=nsmFCdAwqrsLUV3Tzkccj0UOp3YLB1OC1YymW+/3SFb4jRGA8y28J0S/dJhVWfaUuyyzo6a8FYRhLz1DqUsbDLqUi6ShLpDJUDjn+bYbPiUutSLVjPqTWG+Ndu2ZTEuXj7Oc/WZfAu8CSDRqe6hpuaLbe1AdxXigoucA1sVVhgk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4323.namprd11.prod.outlook.com (2603:10b6:a03:1c2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Tue, 14 Jul
 2020 07:30:15 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::a894:6392:f99f:375c]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::a894:6392:f99f:375c%4]) with mapi id 15.20.3174.026; Tue, 14 Jul 2020
 07:30:14 +0000
Subject: Re: [PATCH v35 21/24] x86/vdso: Implement a vDSO for Intel SGX
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
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
References: <20200707033747.142828-1-jarkko.sakkinen@linux.intel.com>
 <20200707033747.142828-22-jarkko.sakkinen@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <dcebec2e-ea46-48ec-e49b-292b10282373@fortanix.com>
Date:   Tue, 14 Jul 2020 09:30:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200707033747.142828-22-jarkko.sakkinen@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms040409030902020602070106"
X-ClientProxiedBy: AM0P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::19) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.127.58) by AM0P190CA0009.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Tue, 14 Jul 2020 07:30:08 +0000
X-Originating-IP: [213.127.127.58]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36e27cf9-9f6c-4ab9-9fba-08d827c7bf99
X-MS-TrafficTypeDiagnostic: BY5PR11MB4323:
X-Microsoft-Antispam-PRVS: <BY5PR11MB43234207974616AB952AA8F5AA610@BY5PR11MB4323.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mXCRVlpL2LspUAy0t+7+/X4bAX72+cJeHTfTuuFdkY/9Iu/LLHONc0GcppwfGuiUB0KxpG6eUwMhCRgUyQqcN8SVhRxdiiOf1SOR7Bk0X2LOdmPMWZOcO6TohDQ7g6BulnTQihHsSUQhA00d59grd27ZGRAq5QNJ02kDdT8Z2QHjnp/WeN1FmFM7teDJVWYaBBxBeHLhQoC3uyMFr4xRY1pQ116JQPgLmbBaaDdkdwNLcjuUkj8g6pHhF1hmaRo6zFz5uaVUQs5jeIXUOFy0Y6m1/sLW5sWjc1wj9jwitzAWryJNPnev1cWocJyx9MqtieBlxCTW/9zHDoxR07fYKBCIeY22t0lQtk7c1BO9glf3pjFpR2YLZ+xj9bY5ffKVobnaX4mILH9V8OuW0QaMGU5YYlwq3vdSu6+GeHBXEC7duAwnQNrdPnRK/fgBcPoprAxzhRcprpLPICZaFjAigw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(39840400004)(376002)(136003)(366004)(396003)(7416002)(8936002)(16576012)(956004)(2616005)(83380400001)(54906003)(4326008)(52116002)(186003)(966005)(6666004)(33964004)(6486002)(16526019)(26005)(31686004)(36756003)(66946007)(31696002)(8676002)(86362001)(66476007)(66556008)(53546011)(235185007)(2906002)(508600001)(316002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: h8AnmB6dS7wy8inez2hW+DQL0cIqQy2uCuaK+myvjzTmHr/A4ETK1jXohuke0GPyKkcWasjpqU9xMVCiB9ioscdY/5eOM7Zbp00ndUZgBZExHqU1u3gyEN+37G+vHnfvUGkgojeLS69NqV5mB8xX1dGNugF/r7r+jbKC+kxQvKX1GrZ9nt6t1+DSHNpp6QlO1Ld3lw2l9RA+EpVJdaupNL4RgtMgZ9aYxirDw+Op4Tog3WdCYZebog5bTCHQHo3PqeMWFqEBqOQTtwxA1hb4kCLMX20OjGkJHZh/e8hdhLM6o2/Knth6MmrnXEAROD8xP0CkWYmTugxEl26OtSrIl4nFF6Ys3pu9vzuOGTDWpHtqmlI4MthXUfFlU9R5qDLMMvHWgjizhUoScrnf2jvXXH+iMTerFf7HodC58/NJ6pJQNnDBHmdzqLfcESzDEOyh1V8ykQ8xzv0T+F3/D3TrWreGc3zom1PNaghZDdx2Pm4=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e27cf9-9f6c-4ab9-9fba-08d827c7bf99
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 07:30:14.5053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQj44vf5Oi6u7+kY0jYpziuz3Ps7vWGhGjN0ynAM03YwJpWm2Fv825tozlQ3dGhsszA1+lN7qg/dZJX68w7m9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4323
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms040409030902020602070106
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-07-07 05:37, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> An SGX runtime must be aware of the exceptions, which happen inside an
> enclave. Introduce a vDSO call that wraps EENTER/ERESUME cycle and retu=
rns
> the CPU exception back to the caller exactly when it happens.
>=20
> Kernel fixups the exception information to RDI, RSI and RDX. The SGX ca=
ll
> vDSO handler fills this information to the user provided buffer or
> alternatively trigger user provided callback at the time of the excepti=
on.
>=20
> The calling convention is custom and does not follow System V x86-64 AB=
I.
>=20
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Tested-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Cedric Xing <cedric.xing@intel.com>
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/entry/vdso/Makefile             |   2 +
>  arch/x86/entry/vdso/vdso.lds.S           |   1 +
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 131 +++++++++++++++++++++++=

>  arch/x86/include/asm/enclu.h             |   8 ++
>  arch/x86/include/uapi/asm/sgx.h          |  98 +++++++++++++++++
>  5 files changed, 240 insertions(+)
>  create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
>  create mode 100644 arch/x86/include/asm/enclu.h
>=20
> diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefil=
e
> index ebe82b7aecda..f71ad5ebd0c4 100644
> --- a/arch/x86/entry/vdso/Makefile
> +++ b/arch/x86/entry/vdso/Makefile
> @@ -29,6 +29,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)	:=3D y
>  vobjs-y :=3D vdso-note.o vclock_gettime.o vgetcpu.o
>  vobjs32-y :=3D vdso32/note.o vdso32/system_call.o vdso32/sigreturn.o
>  vobjs32-y +=3D vdso32/vclock_gettime.o
> +vobjs-$(VDSO64-y)		+=3D vsgx_enter_enclave.o
> =20
>  # files to link into kernel
>  obj-y				+=3D vma.o extable.o
> @@ -100,6 +101,7 @@ $(vobjs): KBUILD_CFLAGS :=3D $(filter-out $(GCC_PLU=
GINS_CFLAGS) $(RETPOLINE_CFLAGS
>  CFLAGS_REMOVE_vclock_gettime.o =3D -pg
>  CFLAGS_REMOVE_vdso32/vclock_gettime.o =3D -pg
>  CFLAGS_REMOVE_vgetcpu.o =3D -pg
> +CFLAGS_REMOVE_vsgx_enter_enclave.o =3D -pg
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
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/=
vdso/vsgx_enter_enclave.S
> new file mode 100644
> index 000000000000..be7e467e1efb
> --- /dev/null
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -0,0 +1,131 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include <linux/linkage.h>
> +#include <asm/export.h>
> +#include <asm/errno.h>
> +#include <asm/enclu.h>
> +
> +#include "extable.h"
> +
> +#define EX_LEAF		0*8
> +#define EX_TRAPNR	0*8+4
> +#define EX_ERROR_CODE	0*8+6
> +#define EX_ADDRESS	1*8
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
> +	/* EENTER <=3D leaf <=3D ERESUME */
> +	cmp	$EENTER, %eax
> +	jb	.Linvalid_leaf
> +	cmp	$ERESUME, %eax
> +	ja	.Linvalid_leaf
> +
> +	/* Load TCS and AEP */
> +	mov	0x10(%rbp), %rbx
> +	lea	.Lasync_exit_pointer(%rip), %rcx
> +
> +	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> +.Lasync_exit_pointer:
> +.Lenclu_eenter_eresume:
> +	enclu

After thinking about this some more, I'd like to come back to this setup.=
 Prior discussion at https://lkml.org/lkml/2018/11/2/597 . I hope I'm not=
 derailing the discussion so much as to delay the patch set :(

I previously mentioned =E2=80=9CUserspace may want fine-grained control o=
ver enclave scheduling=E2=80=9D as a reason userspace may want to specify=
 a different AEP, but gave a bad example. Here's a better example: If I'm=
 running my enclave in an M:N threading model (where M user threads run N=
 TCSs, with N > M), an AEX is a good oppurtunity to switch contexts. Yes,=
 I could implement this with alarm() or so, but that adds overhead while =
missing out on a lot of opportunities for context switching.

--
Jethro Beekman | Fortanix


--------------ms040409030902020602070106
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA3MTQwNzMwMDNaMC8GCSqGSIb3DQEJBDEiBCBHjsqGq1O5
ZT2ekHPxkrWHQQm4YOObXuovEdRA9QdSfzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEANpXh6yTU4GgavTh1SqPti6lv5alxpMgWmXcNdHyGKIoQ6JZg36aBMeIP
uRMr6tkXB+9DYA+HRy8GvoJLl5GP+WuEWKgwL0So+GoiZICw18M43+AeRZO7+2GLbr16vzfb
1wCkJP062AoGryoEYb/nXNIfIrFntgPc9ulOjpuM4LKTZrze8fbJKzZr+OTUXq9K/5+J5zD9
LedmQFP1YGdpKsJFVUdNaa0uS5+uICo0ZR7Kp86dCTahc4grsH7dTUex01msrwKhCIuZZ0Dz
/ySSRhZBge7jMJaznoHIbd9HTfjXca7Zy9v/n67gF9l9rAevbBJDwskJY9cnsbs7IfXU4AAA
AAAAAA==

--------------ms040409030902020602070106--
