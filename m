Return-Path: <SRS0=LqHz=B6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD511C433E1
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 11:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8602120855
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 11:14:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="UH0mq/vh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgHTLOL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Aug 2020 07:14:11 -0400
Received: from mail-co1nam11on2098.outbound.protection.outlook.com ([40.107.220.98]:42241
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729101AbgHTLNm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Aug 2020 07:13:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jedIogC6ktyTWsOMol90KumQu/NrnrSJDzz/sOZ239GuG4grujw+z2SL/XWDYyj9ipsEw2D2iGViGJU6wm8ammJ+EfKiWKBJy9BqLa2j5quVX2aoO+gvfcsthegihR1rB6YuHOYs+J/YoR7zGM++dwXrYngrxliU6g/eFslRgZR/TKDRolPce0p4Q0bAQTmeyASJVgkXmXMC93zPg9YD1UG1jNlPG7Nqjr8vrlhJ1adWTjKKrmlwx4Rdw0lACyrkuAvcHdw0Ti4j0MrPz39jGzlPeN6/sSG+clMOmFKTop/7YwwgEUhAOvukmuRTYn8LXCvt0M9Zc5VrTaJubsWchg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUNYdDxekW+sc7Lr/xN6oZMb0uoAVgNjg29kYVOKbQA=;
 b=R5GGwbB7A9H4i/oVqEJSCdIrx08V9mgjLmBWhv6B77FHJWyeyAIKrsIdPuRbRiMnxhltoXcV9ttsKiwDo25SJw7C7pfDtDFrl4UYHUP3g7U4lEzZSvK+HDy/bwUkoklzU1w50Vo8ZLuXiYhyBDoovHP+q8nMlVrRJwYCJNh4JrHGpjvWl9x6sDRmj7ZL0Jzp6FltNttpRnZp7qhY2hKnAJ4/cz0mOwFR2kgvOGFXl89jlFOXzor3QSTBlivm0R9CWhZe5kj4lwQTrFp5bGWoS+tFQg8Xkl2eJZQjlbMTtwl2W/LWe9DsywXOFfEd9TR2ARYRrX0OqO5cW6tNmQoS9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUNYdDxekW+sc7Lr/xN6oZMb0uoAVgNjg29kYVOKbQA=;
 b=UH0mq/vhhhkUyXiLXgGXVqLv/51CcmWQEG1rC82AqLGavG2yOpwLpF2kCu3BL5oFEcYd8JNIyN3Jh4eA+WC+cZc6jH49fCw53dwHl7CViKmA8dQcB72rSRd3XHzXkMmN6Xnzpv+ZhOujAa8JksIy+QEcF2ItaKZ5emaMdhBSCpw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB2679.namprd11.prod.outlook.com (2603:10b6:a02:c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 11:13:29 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 11:13:29 +0000
Subject: Re: [RFC PATCH 4/4] x86/vdso: x86/sgx: Allow the user to exit the
 vDSO loop on interrupts
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-5-sean.j.christopherson@intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <b71cf67d-e6d9-682f-f837-2fc506627cfb@fortanix.com>
Date:   Thu, 20 Aug 2020 13:13:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200818042405.12871-5-sean.j.christopherson@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020406050104020407050100"
X-ClientProxiedBy: LNXP265CA0017.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::29) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.195.0.246] (212.61.132.179) by LNXP265CA0017.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 11:13:27 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ae35cdc-0e9c-4313-b8e1-08d844fa10f3
X-MS-TrafficTypeDiagnostic: BYAPR11MB2679:
X-Microsoft-Antispam-PRVS: <BYAPR11MB2679FE02901EEB25C73D2F43AA5A0@BYAPR11MB2679.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DpgPdJQ9qRiCcSUFuAyTJTi00n2fW11uqdt1n/+0e/7rvdcqukY5qahikuNiU49D5gXHXYbGn9hr/RB9KrTmQjRdRLBtHhWSbOB7dkzLVTdpu0e/KL+B4fhV/qdLSI2hJotMadz9qlOi/NjAvC2cGrbplERvX/Z3mKipIszEyAqx1pf0fgVOcA+OcuM4jFjAgXeHIw7cCd2I4ntRD1yqCqfC2Y7onQG3M8PI1i9f0aRC9SxaRROQIEDNP8Pw8PjJ6uL736SErM7lqYziVm9ThOIrPuzztN5KZP1A/vgw3xsLqO153mhdWnVJ+aRraReESLRfsIqh2G66vahewtiyEFkguZptWdF1BqZYcJ7WNeaHTpNabh/nnPbW+xZmWm91
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39840400004)(366004)(66556008)(54906003)(316002)(16576012)(52116002)(4326008)(110136005)(2906002)(33964004)(956004)(2616005)(86362001)(5660300002)(235185007)(26005)(66946007)(6666004)(66476007)(31696002)(186003)(16526019)(53546011)(83380400001)(31686004)(6486002)(8676002)(8936002)(478600001)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +VqDMI0lXQ2nuTBzzjvgJ9K6AJpRsg2f+6j75qBmh/9wCGYTlml71845CxWyupzZcc9NlYzfcdD53zI7FZ+6QJyZzk/ilwG969nu41YsFC8UytG4HcEazMzrS6RpvxLHKkoXrX6kXZYB4c2M25ls8QpZ7uYFCFVwqCVaK5MCjuZEKhYi5rcZlJ2gGIJJ/YrkJecF4UnsJ+M/dOauCW9xmwKggeszGn0nzm2RIMc2Uoq/suDSaR/6M/d6zJiDvmtEUepovImGc2mn8ASIjeDhX3HKQvstAjLtJZ/tddjOKfgfq3/BqHTt287EhL6nDLon0kBfJJEmfBTrzK70/SbSmTJxYo/lF/rT6tih/Y/NERWeQMZtM9D/+61N2yt1ssyCCbRTJE5BduWePlJ5aak23ksNdLSQUdmIIffPouwNe+0j4zrBioJpeoNyttM/JabYr/cSAON0R9IAnezLYMKEjcLcp5wUnAL7GEgDbyUe5h+DV5vuA421aYfIS51+JWXLy4PG3FdFzkIJzDxqCfX8/AJrefDeFhDdpru9Lz3nddUt+3o3UGdsMplpjemmH+wx20HB+aLf+Ntkli1JhgwoFf+Mtt2XtJbL5a5w4VfFGYg0I5bASaef6oap3c9PUpuFI4euoE71B+1mJ/t59oseKA==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ae35cdc-0e9c-4313-b8e1-08d844fa10f3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 11:13:29.2034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hva7znIvMThKRRt4aeyisMtjj0e9ONnsRFjaolOeeCJoFAsQLMcalOjspG91gR+037BE8ZHpLAPtouE9fEv85g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2679
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms020406050104020407050100
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Tested-by: Jethro Beekman <jethro@fortanix.com>

--
Jethro Beekman | Fortanix

On 2020-08-18 06:24, Sean Christopherson wrote:
> Allow userspace to exit the vDSO on interrupts that are acknowledged
> while the enclave is active.  This allows the user's runtime to switch
> contexts at opportune times without additional overhead, e.g. when usin=
g
> an M:N threading model (where M user threads run N TCSs, with N > M).
>=20
> Suggested-by: Jethro Beekman <jethro@fortanix.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 27 ++++++++++++++++++++----=

>  arch/x86/include/uapi/asm/sgx.h          |  3 +++
>  2 files changed, 26 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/=
vdso/vsgx_enter_enclave.S
> index b09e87dbe9334..33428c0f94b0d 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -21,6 +21,9 @@
> =20
>  #define SGX_SYNCHRONOUS_EXIT	0
>  #define SGX_EXCEPTION_EXIT	1
> +#define SGX_INTERRUPT_EXIT	2
> +
> +#define SGX_EXIT_ON_INTERRUPTS	1
> =20
>  /* Offsets into sgx_enter_enclave.exception. */
>  #define EX_TRAPNR	0*8
> @@ -51,12 +54,17 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> =20
>  	mov	RUN_OFFSET(%rbp), %rcx
> =20
> -	/* No flags are currently defined/supported. */
> -	cmpq	$0, FLAGS_OFFSET(%rcx)
> -	jne	.Linvalid_input
> -
>  	/* Load TCS and AEP */
>  	mov	TCS_OFFEST(%rcx), %rbx
> +
> +	/* Use the alternate AEP if the user wants to exit on interrupts. */
> +	mov	FLAGS_OFFSET(%rcx), %rcx
> +	cmpq	$SGX_EXIT_ON_INTERRUPTS, %rcx
> +	je	.Lload_interrupts_aep
> +
> +	/* All other flags are reserved. */
> +	test	%rcx, %rcx
> +	jne	.Linvalid_input
>  	lea	.Lasync_exit_pointer(%rip), %rcx
> =20
>  	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
> @@ -93,6 +101,17 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	mov	$(-EINVAL), %eax
>  	jmp	.Lout
> =20
> +.Lload_interrupts_aep:
> +	lea	.Lhandle_interrupt(%rip), %rcx
> +	jmp	.Lenclu_eenter_eresume
> +
> +.Lhandle_interrupt:
> +	mov	RUN_OFFSET(%rbp), %rbx
> +
> +	/* Set the exit_reason and exception info. */
> +	movl	$SGX_INTERRUPT_EXIT, EXIT_REASON_OFFSET(%rbx)
> +	jmp	.Lhandle_exit
> +
>  .Lhandle_exception:
>  	mov	RUN_OFFSET(%rbp), %rbx
> =20
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/as=
m/sgx.h
> index 80a8b7a949a23..beeabfad6eb81 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -76,6 +76,7 @@ struct sgx_enclave_set_attribute {
> =20
>  #define SGX_SYNCHRONOUS_EXIT	0
>  #define SGX_EXCEPTION_EXIT	1
> +#define SGX_INTERRUPT_EXIT	2
> =20
>  struct sgx_enclave_run;
> =20
> @@ -116,6 +117,8 @@ struct sgx_enclave_exception {
>  	__u64 address;
>  };
> =20
> +#define SGX_EXIT_ON_INTERRUPTS	(1ULL << 0)
> +
>  /**
>   * struct sgx_enclave_run - Control structure for __vdso_sgx_enter_enc=
lave()
>   *
>=20


--------------ms020406050104020407050100
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjAxMTEzMjNaMC8GCSqGSIb3DQEJBDEiBCBcE4ZlKkoi
yIOYuePDvadv0vxV7pq/5Gd0r00OxZ+36TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEArf5UBCA09JA2YQvVKEM1QuuKXh121tNEotET6YDUsGIKp+s9yrFXCJEg
AuTvdZrsqjowsFsu4lt/yuJjcuIfj++4krkZtcK29vl8M2abxMY55puCBoG5IEHe+PuimVI8
OEQMKtVXqvCDbJdvzxL2k2Wp5znDOhlFRNlZWAoRYF0jVUvpC8jba/0bpo04rHBXgC9IyRpH
zT83WT+HKU055iCC/ohrAwPc7Qo4HGTjQ6hYEXNSKn2ujXp78ZKI1/eiO7p3A64ds6YrSHwh
0+sl0YMh8Q5651yusZu17DLWpS7CVwVlnwa1oEdxu2H8nah5n5oOqGV/spLAHqXCTMcyOQAA
AAAAAA==

--------------ms020406050104020407050100--
