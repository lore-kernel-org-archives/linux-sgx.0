Return-Path: <SRS0=LqHz=B6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E27C433E1
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 11:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC7F2078D
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 11:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="OuGJeL/u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgHTLOk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Aug 2020 07:14:40 -0400
Received: from mail-co1nam11on2098.outbound.protection.outlook.com ([40.107.220.98]:42241
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729648AbgHTLOJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Aug 2020 07:14:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNegZ+uu/1+UtB3cOrmxKYUS2L4ujRBooWNxfQ3Sr6gJrmRaT1sWdBayyLeuNp5URrh9uMkuS+xQlIBCekimsu3y99g65unrJkfjnnQgXlZl4NcvMWuxTE572gyvCSk5S9ZVv2PAj7I6m2lTEwBSjxAeAeUQTksjDIRx4dxtkvsfnTk5OYrP50Zys3iLNlamtK9183HS9xZnVtI4XfaQX1H3wO6bWfF0t0wt2mPC7VliVJE5yhipgcvp/fLnbDEO6RHWuFlXUT8OfyZlabrgYMrXxDVyv+xSJ8eMG2d+mujf7AonA39V4VTLa1juHhQgo5m/UJbi4NNiRNC2nyI86g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEhW27d6S91ShxbWXUJen6/yfUveJOTQntvDbR6PfhA=;
 b=iN6gzSithc0pQC0nub03kjxnEhjDRC7EjhKSXho0COvTlp+S0oDkkaFeINnYygwnJ6P4I2lGn6L54flSfr1ROazFUuzCus4qfWb/vCY9K7hE2F7TImKgrzHdxK8+CxZjbc+Ge2gAg3gxhDfPOR/N8Vru6wo2iSCiOqkkQhqS3TdaynontOcMBjBr3d6bel2Hk4e9YIaArhBzYPv1Y24GBCp55Dkimr0TBxGCBKOYpEzNQ48oXZ6K6guACJIn0A8s19m1hw90VgIoQVsyJUKxoT0t8hpEUXBV2t4PDbhBpL47lwFtTgggYvHw3H6qQKPyeaB90ei0SWsHkviPFELBiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEhW27d6S91ShxbWXUJen6/yfUveJOTQntvDbR6PfhA=;
 b=OuGJeL/u007yx3Q8UKSQPCfmuZfer0b3ds1rzdB98SfaqexfpOFyOt9ImEAgMeoe6Y8Xc5IJgnANmNG4A6PY5+kHL9S50dpVlZX755ZhjsAVmul9iNBiQ0M4tEYPy3GIn7gSU4vEbks8wCP+own792ApFI1DfDL7S7IZcyHQGss=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB2679.namprd11.prod.outlook.com (2603:10b6:a02:c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 11:13:43 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 11:13:43 +0000
Subject: Re: [RFC PATCH 3/4] x86/vdso: x86/sgx: Introduce dedicated SGX exit
 reasons for vDSO
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-4-sean.j.christopherson@intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <ac084e30-b1f0-7d75-0e79-7de5a8432ab5@fortanix.com>
Date:   Thu, 20 Aug 2020 13:13:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200818042405.12871-4-sean.j.christopherson@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070504030605060800090801"
X-ClientProxiedBy: LNXP265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::17) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.195.0.246] (212.61.132.179) by LNXP265CA0005.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5e::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 11:13:41 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46279551-feb9-4b41-f074-08d844fa1919
X-MS-TrafficTypeDiagnostic: BYAPR11MB2679:
X-Microsoft-Antispam-PRVS: <BYAPR11MB26797033BE56974C1AE6E781AA5A0@BYAPR11MB2679.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3UCy0jeKgzn6LH+qodO6hg2k4cGZMYrnOfUTQnI3J9ebeFxGED8GNE5zMPR16hbl+JWjcpgxd1sK47XVhSCz+cwydq6HYwqV9dadqdw4fHdRSFecxD6R+xNKylPVw4cKKJf4UhfGQ96aUsxLNco8Gi751lPqat+cXQ8Y9i/DYTMCn/5V4ifDPDMCQlp52E5r0hVPpTov8GZV4cisYPqzqPHwc3CxRaV8fquaec/iQlo5Rc+n0O8rvY2FRX5WrzNipkXKNU8berLuge1TDXTy5epqFuEQfuxtbbosgzBoTOfQS208T9kz/WyECRt7+nD29foGaJ6Mp5oGT5G9PWXBsWwkW7U48EdZYRtBCsFnPzks4Wtf477gAkP8KfyKhsQU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39840400004)(366004)(66556008)(54906003)(316002)(16576012)(52116002)(4326008)(110136005)(2906002)(33964004)(956004)(2616005)(86362001)(5660300002)(235185007)(26005)(66946007)(6666004)(66476007)(31696002)(186003)(16526019)(53546011)(83380400001)(31686004)(6486002)(8676002)(8936002)(478600001)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6/klkZjunSMzKYn+g86u0HfGpWpQWbFeLoAOqlUR7rDOsAEZBCEmlE3sspfRvvtegq3dL3OQd4FDyYVxm7buELW/3mQwY6e9oMbHJw5fPO9KLHD6dZri1OksrbI6vDePtXx4XUn/o4e+EckPwQ0sgqaq21MXDHsyLTgQHj3sdFMJiQZWRlhONaB2Yo11AgIfEOARzSZC7jxLwUGXKAE5Sx3IhImWxgtt78JECmnvdSbtY7b36czxtshVkZuXX+oiNBTUpzOSQoE2wRz0JhttaQj7/9sdhVOlHSaXYV77XlQiupAU/vkcN7G0AfVkEMvsoI6VZkKVMeRBw9hX6baizxexOMtPBpLlGdDwyGTqebxfSYVFIuFFkfZ1N4X91YntU6JTPhMM2j/AtK9x2cocVQHkKtHOGqOteutq/CV20D74N/ydEgg29sYDVTiskE5FTkvufuuE0PTwzmEQW1Sx01jx3kElaGfbNgHJbZqfWQwlIPxgO4fBlXUgcAdkpfsB5He6oROSK8P6kGYRCqHYrPFvNhHFGAiF65at3iBn2sL2VEY+TC2hHM1n94SCb1RM86Haqinxxhoh+lRaLcBYbePAqZrcZ6XX4AyYGKFU2kpYaXQY72XnM+hbtXf93E00jW/JKqtmNaLiuoNple8CVg==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46279551-feb9-4b41-f074-08d844fa1919
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 11:13:42.9696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fmxf+C5DK4ObkcfqnogVUxf0Kyk1JtJBb9taUbhICrhAyfTo3HwXqatsTRSTAfZEx5auAwEoL+sxOXYssFMJEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2679
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms070504030605060800090801
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Acked-by: Jethro Beekman <jethro@fortanix.com>

Jethro Beekman | Fortanix

On 2020-08-18 06:24, Sean Christopherson wrote:
> Use dedicated exit reasons, e.g. SYNCHRONOUS and EXCEPTION, instead of
> '0' and '-EFAULT' respectively.  Using -EFAULT is less than desirable a=
s
> it usually means "bad address", which may or may not be true for a faul=
t
> in the enclave or on ENCLU.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 7 +++++--
>  arch/x86/include/uapi/asm/sgx.h          | 3 +++
>  2 files changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/=
vdso/vsgx_enter_enclave.S
> index aaae6d6e28ac3..b09e87dbe9334 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -19,6 +19,9 @@
>  /* #define USER_DATA_OFFSET	4*8 */
>  #define EXCEPTION_OFFSET	5*8
> =20
> +#define SGX_SYNCHRONOUS_EXIT	0
> +#define SGX_EXCEPTION_EXIT	1
> +
>  /* Offsets into sgx_enter_enclave.exception. */
>  #define EX_TRAPNR	0*8
>  #define EX_ERROR_CODE	0*8+2
> @@ -65,7 +68,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	mov	RUN_OFFSET(%rbp), %rbx
> =20
>  	/* Set exit_reason. */
> -	movl	$0, EXIT_REASON_OFFSET(%rbx)
> +	movl	$SGX_SYNCHRONOUS_EXIT, EXIT_REASON_OFFSET(%rbx)
> =20
>  	/* Invoke userspace's exit handler if one was provided. */
>  .Lhandle_exit:
> @@ -94,7 +97,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
>  	mov	RUN_OFFSET(%rbp), %rbx
> =20
>  	/* Set the exit_reason and exception info. */
> -	movl	$(-EFAULT), EXIT_REASON_OFFSET(%rbx)
> +	movl	$SGX_EXCEPTION_EXIT, EXIT_REASON_OFFSET(%rbx)
> =20
>  	mov	%di,  (EXCEPTION_OFFSET + EX_TRAPNR)(%rbx)
>  	mov	%si,  (EXCEPTION_OFFSET + EX_ERROR_CODE)(%rbx)
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/as=
m/sgx.h
> index d3b107aac279d..80a8b7a949a23 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -74,6 +74,9 @@ struct sgx_enclave_set_attribute {
>  	__u64 attribute_fd;
>  };
> =20
> +#define SGX_SYNCHRONOUS_EXIT	0
> +#define SGX_EXCEPTION_EXIT	1
> +
>  struct sgx_enclave_run;
> =20
>  /**
>=20


--------------ms070504030605060800090801
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjAxMTEzMzZaMC8GCSqGSIb3DQEJBDEiBCAMFJi4iggO
8KbO2p6yHjSWlGM0Dlmx0nf+r2btslUMTzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAZJ0GD/nHoD1Tckvo0l3yNc+mfFtn9O/0yWePCH/JJgurnAkk7XzM/t0m
aDFzSDB0+bFNdNQ85Dy/Ti2Pp1JDDHvCgQ1A9v4EDMlZvgJMHVqiohZDnhOLvNSD5PeC+DnP
eDG9xTFPfmyDG2QwUqzPIbkBHYzOS6mbCh74MRPZlP/AjtD5EPPO6Pk627tM+dGrdLT+DmVb
gqBU4MZ/PKAG2zqQ21lHSNpMnbmV1pR3eYwCxn6KcD8mCnCRjJbLltXtaboPHvMiONONAeOE
+Q7kz1UcAFXjtv9iU4V7D+JydU0/7TA9zenyejHdVXEQ0pWgXmd7TtSp/VokrZBHb8wM9gAA
AAAAAA==

--------------ms070504030605060800090801--
