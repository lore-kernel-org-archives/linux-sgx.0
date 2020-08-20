Return-Path: <SRS0=LqHz=B6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DDEC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 11:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4C0C20639
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 11:15:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="KS5++1P9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgHTLPR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Aug 2020 07:15:17 -0400
Received: from mail-co1nam11on2098.outbound.protection.outlook.com ([40.107.220.98]:42241
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729398AbgHTLOh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Aug 2020 07:14:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/kt3CKb3DSI6oPcyB2sVVoeADjzqJOEFQnfdjobvA/4CJ9fc9ai5pVZAKCQSAwj5/aCfVyvBemyU0rVrTiJFS9nAOJoVhCXdxPgWDhQ6oe6/C0/SoZbu+3Wh4X+qg84lujUguTY4r+RZfvMkQe3bpc8bnMRP9BD6Ppl88uEM1eKAFTseHlqH66XxEWe1Boge1wpHjYgOUNKsnw/4wST+RS1S6HrQ0tmz+3vJcyQ63WuiqVf5bakR57yjBsb4Bf8DsT7whRAX9alxf74FIy0KrRxBWZRQuRN9Gm+ZZbrX8bnh/SBaODkGV/dV9gO8zlmSOvdSX4cwrQwyLtKDGIm1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMSDzYGXqyCErRvJt4wIT1hHKzPDSuonJ8mORqNTnM8=;
 b=Eh/e2liKSu5bbJsQPKeWeXevscIllN1tvEy1oipYxW22jhzGMUW+C7wy8wDMWiITW0b15BOeqpcyLsWoDAhiKOvQGFnNuhWmISkglBGuaEhsbzuTlx6sBBIN3ETPEbiZY83/n+JjN3wFI0o7j34EV3f8v04FW+r8KpzleVTlD2oVMwsJBQHWaVFqNQkR9PbBmTaZJp6aAT8ZcrzssCRTBv/mrtbSlv6VrkH7Fzss4E8NPhYxzZ2tkxnfd7J7+y17fnFYWP8r8LWHkSae1esySLhOx/7BiQNWAbcEf5RZoUyY0a/M5jJQvGPVEFUVehX/tWEek5Y2wwTTVYvnx6/HLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMSDzYGXqyCErRvJt4wIT1hHKzPDSuonJ8mORqNTnM8=;
 b=KS5++1P9rNXqZXzd4hRz5+tfx5lMCmYouyvArkOH19HBi13g0KoyvhDy2q4t7g5D46WtwlPevpTdQQVTkr/gavzhfVno1cgFXqaMJOvRjV+DGkfOjACXgVRK93WIieJo1DlPFhVxZf/UKloZjp6bAWeX8WwUaiS2hRRpgxzK8w8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB2679.namprd11.prod.outlook.com (2603:10b6:a02:c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 11:13:49 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 11:13:49 +0000
Subject: Re: [RFC PATCH 1/4] x86/vdso: x86/sgx: Explicitly force 8-byte CMP
 for detecting user handler
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-2-sean.j.christopherson@intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <0fe4be8c-bdde-dd10-3ab3-2a0a0d8c58da@fortanix.com>
Date:   Thu, 20 Aug 2020 13:13:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200818042405.12871-2-sean.j.christopherson@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000306040804040200030001"
X-ClientProxiedBy: LNXP265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::13) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.195.0.246] (212.61.132.179) by LNXP265CA0001.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 11:13:47 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 381e055b-357c-45bb-b843-08d844fa1d03
X-MS-TrafficTypeDiagnostic: BYAPR11MB2679:
X-Microsoft-Antispam-PRVS: <BYAPR11MB2679A0ABD6C0202655DE4D85AA5A0@BYAPR11MB2679.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CLQ6SzFCTLfYH7EcDdZgIYyKo2M/VKqfOo2+NMOUV8cTFO7bxpGf64MoierS58VSNTiqNJYJicDi3FrImRsfEKcfJfHvPLMwkz0y7zfnPkRwBA/YrhP9xkxh0K/EMKtnCSJjb7l8d7fFSCLQ1AnXjm0WQ9hBvAzPpkzVyuGc4/hVZJiwMyzAhb5m3CS9+1RlX7XJkB9WGii37E3mMhka07feIMxWHOPlQrqgV4AAKw7baiATQXYS2OV22WkZT37R2hapsSskaNER5WfDYUV/rBcqhXuNvBolJBzkxhzgIEjdOFOyqFgBWonhk+HzRH2kpudNZg7lIr469QP3dK5RKImpT+VyfhxgT+L0PxoythIX0Uy8MZRVOlRaIaobqZIk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39840400004)(366004)(66556008)(54906003)(316002)(16576012)(52116002)(4326008)(110136005)(2906002)(33964004)(956004)(2616005)(86362001)(5660300002)(235185007)(26005)(66946007)(6666004)(66476007)(31696002)(186003)(16526019)(53546011)(83380400001)(31686004)(6486002)(8676002)(8936002)(478600001)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Q7zgXNaGgnB2On3jDSe2O2h29LQ3Wf4F/59n85p02KxRbdVLafKJalRWJ8XpFNFaGQm0fPrBQeGEHYWuPZruhghsdyGHx5jTmqRHb0ZkeqgUjaEn+d5KQPGNcKUX3bdFDXwxsQ9C15Ng8v2JjV8bGnT+mvvkzhOmKFIyoMWBssQmqRRMiO5EybN2L0YGRBPqeYAgeraNZZZIKUUxILNX0sHF4IcH6E8Sw5c/BGQJRBQzyELVAxEKyK9Isz5BQa7fMUJPKmytGTG6ldcqR2vxbnOjf+KqM6RA7oAxj3MY1pSW5SzAgoDOb3WiKMObUAWPWD0NeQc0KLzzHGdS4CTp7dnqEnNa4CXfdx/S9bbM28p/bV4Zs3szj06Eucibjr4gQL/WSh2h3ZUh4PM9JcsGLB3bIhMORaZILFppWHqYoOqKtb+yNju7skVCg4z1rqcPJAsG5oZkSJX8ClVveiJD1+qOVfdFsgs8PCDcfvqLHWn7bVc+/JZyxe1VYSmw5mvmTnuWRPJbvNs8YzZrOvzRYIB7OJK+B2RLMYqB8Ye3946XB9qaZF0mLdWMC1Uu8jNztA5ZSVYRr23dwepuAOoL7ZSjLAu+AKuMbQ5SdtQrhL2lWmkaWYuy3CA27NWlhqyt1XcAWs1IzQeQSzyforxc9A==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 381e055b-357c-45bb-b843-08d844fa1d03
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 11:13:49.4199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u0PxYdifBB9MVm5zcE10/xmldqzqDvJtrlbTRc5mDU0T/rLt3PRLe9BcQ2kkELyuCFYWSgwgosC4WDy1VfR4gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2679
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms000306040804040200030001
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Acked-by: Jethro Beekman <jethro@fortanix.com>

--
Jethro Beekman | Fortanix

On 2020-08-18 06:24, Sean Christopherson wrote:
> Use 'cmpq' to force an 8-byte CMP when checking for a user provided exi=
t
> handler.  The handler is a pointer, which is guaranteed to be an 8-byte=

> value since SGX is 64-bit mode only, and gcc defaults to 'cmpl' given a=

> bare 'cmp', i.e. is only checking the lower 32 bits.  This could cause
> a false negative when detecting a user exit handler.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/=
vdso/vsgx_enter_enclave.S
> index be7e467e1efb3..2d88acd408d4e 100644
> --- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
> @@ -48,7 +48,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
> =20
>  	/* Invoke userspace's exit handler if one was provided. */
>  .Lhandle_exit:
> -	cmp	$0, 0x20(%rbp)
> +	cmpq	$0, 0x20(%rbp)
>  	jne	.Linvoke_userspace_handler
> =20
>  .Lout:
>=20


--------------ms000306040804040200030001
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjAxMTEzNDJaMC8GCSqGSIb3DQEJBDEiBCDDbN6wcO+i
4VDg6JnIYLBdmfS7LiHbD822NNbt7f8kLTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAX1jBVCWxe6JeCrq/vxaR5ucGu8iOj0SnNP5dERziwu/JD9m5LyVqQiDb
DbLnY6uRTRmmwjEiOChTQ7gkxJsrwE6Z0JRpuvEQv7oLmF3cL0eqEKnbOi/UFN/t+6FSGjex
lgWgG1UbFyKgdBtKWT0jfaRmNlO3g8yiSUwu1ETwQDSqytPx6GIPX7Z2LbRWSjoS9x7m56W9
cxIpthQi7arRvJQFxRVcjyMvQ6ngXuNrYZpjD7teVNektu1X1LlsoCCpmmCAHNRgslEhvSTP
fHZbnQsGQNI5EH0v2qZsNdfFD+SK5QNw8U85M1DtxuxSRJdk7lOKRcd9NSGbzbJHAiymrAAA
AAAAAA==

--------------ms000306040804040200030001--
