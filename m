Return-Path: <SRS0=VWZs=CC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,RCVD_ILLEGAL_IP,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66376C433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Aug 2020 13:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CDBA2065F
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Aug 2020 13:41:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="EdUh1kcm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHXNle (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Aug 2020 09:41:34 -0400
Received: from mail-bn7nam10on2102.outbound.protection.outlook.com ([40.107.92.102]:49761
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727769AbgHXNgZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Aug 2020 09:36:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ar5GO75jeu+qN+rUUklP0PIdxc4GS4W97D8i87kQvExPOxgQ3rM4cSvqPNVWWpuh0mkUhqpzx6mC3kLy/pEwlDajLMyVb5ytAQDQLGpcDoOVguQekHF7cbLtGm/EGvQtCAPxuL0mKGRYThlZtfLpr01eJVDw3v7D2QRzyoZ0DmgdDnRcT+8P32R8KnuoEbRmlPW8VXX//J+YzgsuGVM7RtobuJ33IBq0bVyBsdJ3GJFEaAAuzPrOqJ7tPo5nzs1tRne/h6yj+CsK0ZKmRp4OD4stPbbzRCadkTqh4w1y9RKt/GcJt8TDk8uqO0sjJHS5qUjc2YHjnHCAY3nUhaO5Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXnNIdNCmttMvej0lVmkVk8mKtLXieziw35RC613BpE=;
 b=nPWGWWfLoRnOGI7eDqGWrPmp1IMWsmCSSwjTgSiEVdszdqWtePdJT+kJFcDlrAiB69/jNt4mdUAoeCmQMM0hXbFxeoSu+T+IDWpLDcXVY83NDd1AUxpnRiv+q9n/dWV5DTLhahYJFj7nie8WFejxau5roOGcpYidXap5wvcK/a8PeWLY8T37isTccszcy1VMzXuMNbHqEEq0AvdC4Afj2de2SW3WSlMaB/Bpzo1gHg0Zm3xxZedTSlM0zFhljZLtjS4ibumJh+AbS5sh6WhqrjAV1RAJmxT6Nm60zzKQjiu2V84rJR+qX3UT5V34YX+iXvK8iANRMPCQxKyAZuW5Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXnNIdNCmttMvej0lVmkVk8mKtLXieziw35RC613BpE=;
 b=EdUh1kcmi0MJdjp9HelH1lyFj5jNuY7xZDX9G4KsuhBmhB4EajguJYJDYRrXNA2owpvi92og2Z/7uoVQd6GkS4GrXxkU7rGqrs+d/M07F1Ysb0YZWLztkzanWLgxfTJp2wcEuLrYqJdbhk9uWMABtTAI47Zu53uunnHCW9uS9Ho=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Mon, 24 Aug
 2020 13:36:20 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 13:36:20 +0000
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
Message-ID: <74e185a6-909a-af54-9a09-e8f9c8809703@fortanix.com>
Date:   Mon, 24 Aug 2020 15:36:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200818042405.12871-3-sean.j.christopherson@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080306030209070603090307"
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Mon, 24 Aug 2020 13:36:18 +0000
X-Originating-IP: [213.127.112.210]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9662cf1a-37b9-4fa1-326a-08d84832af2e
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:
X-Microsoft-Antispam-PRVS: <BYAPR11MB367213E5BF5AEBC3AA387B80AA560@BYAPR11MB3672.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Vs2Tzm+FYFq3S9RAfFeV9hIJiDWe6OLfAkh5d6rZR2+aYMz3M+pfuYboqB9thN4QGaMeD343knyi4VDItw/WnsnYlMTSWPKNLa7bZkgGGeZStzhRQa33Anuai8qPLkMfYl57YXJdo68uhGeZUbBfpOVPEnRJxSV2ELn0TSVaUpHEwpyGQymr6u7QoG4Rop38sz9y9H2Rur8jsRDdpUYpAieJZeM0PVMpOWbacBJ3J4bV+A2WmUXe4CTje4P9YrTTUENfDvqSpPauP65+NVJKdge6TtM0FiNW5fkseOqQLJecTda7U8AEQDG2gKb/CRRD3flMPBPZS4wG628m4ZBLqB1cLV29fmgdmC53TTjPASwcWPJ1eGNxUkzNCp0MiDb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(39830400003)(366004)(2616005)(6486002)(26005)(31696002)(956004)(53546011)(86362001)(54906003)(16576012)(2906002)(33964004)(8936002)(110136005)(6666004)(8676002)(186003)(4326008)(31686004)(66556008)(66476007)(316002)(66946007)(36756003)(235185007)(478600001)(5660300002)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: /7MSV/0ghowjajsZVWv+gLBhP6ryDOUaZXAtOopbhDftncE6CxUGCfl/rPVsDqOQvbVA3HLARGhtI9Ogq3JmYqEFEVukxRTb5QX9rOCwEdDKjw1tMz5kd5kXcEj6Ef3U2xsdPAWmY6kCNHOzLLKSdL+vuG91Zo/fp18/OGQQNJ/xzxWhUc0a6KBTgyggCnonKPtINukSzRsvtwRHFB04n5RDCnAeLVBZjqby5wTdG2vlc7G7aISALyoU2VYHWK+MIX2HGRvm52c0DeHzYpE9Y6/qxlBHxHuwtyFOkBlgKtNKyRs6G+Bs2K+r4bTYZz7LlNHLsF6t9JXgUkgykwbPsikC2nlIX7nXFGVsyYmfghzIocPX9Bi4H2YLsvjk8fthIsREbB8fnrAFqNN/K7q6Jxe6j869ZSaN8Ll6jCf/pRi4b6BH3b1/oKo6IKLEU5UUheSC2mN/cmsGRDzo4ESgrLu40j8tJO2ADlEUTACy040tt1wg+Ov9wh192WfYUdr+gfE8nvwpxmuVZn7OZiOXUd99oymeD65I42ZKwgdLIrv1bA2TjB7NPAE6c33Rj3Gqg9izxHvaPHgDDtWKSRCdFN2g3IA4EHSaYSoMsm/fkvj0WyMPbSnBUAonSPkXdqNWh0K0QLsPmBfQsF2NdjRFOg==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9662cf1a-37b9-4fa1-326a-08d84832af2e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2020 13:36:19.9289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FmwRKixR42x352KVt7ZDRyxy7DchHaFNMwuwU57KgPjCFxlxAwyitmGAhNs1pgyLxvcr7Pmdx6tITWGkdO7zeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3672
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080306030209070603090307
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-18 06:24, Sean Christopherson wrote:
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

I think this should return void now, not int? Then, the =E2=80=9Creturn=E2=
=80=9D section of the documentation is also no longer correct.

--
Jethro Beekman | Fortanix



--------------ms080306030209070603090307
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjQxMzM2MTFaMC8GCSqGSIb3DQEJBDEiBCB01aNxddnY
rJqinwVYV8A0reioj2VlRXsgbp4HTUOd0TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAK0hBWg/Po+fVuGO8xgzPK+2DChsrgjkclPrqDqDbz+u2kxSLSi8p1eIe
zucG6pL/BQIUmY1kOIte5uMoWYfADlRvKuVXZYyKGFAzbKb6lQZUA8H7nlUbVshU4X/DRlST
qjKegJFoP2v9k5E2VR6+q98qt07AlMlm9m23LyB7qC4c4qlwMKH9Utf7ok0gDcwzVV8ZrBNT
rWYAXAfzW4+Bon485Lkr6GRZwFsdNdJ2lXs2vJzZFJK4NiJiwJ1aYj/w7k6owNBohgp130H0
P6HtJTfmBkr8iGA4qZnBRt5nPD/hMUfSPr9xbXHzcpmr5iyJxS8QYq+SzA0WluqSiG2kvQAA
AAAAAA==

--------------ms080306030209070603090307--
