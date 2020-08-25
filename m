Return-Path: <SRS0=1rnR=CD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,RCVD_ILLEGAL_IP,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C895C433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Aug 2020 07:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 573182065F
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Aug 2020 07:41:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="tb7iU3sz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbgHYHlc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Aug 2020 03:41:32 -0400
Received: from mail-mw2nam10on2136.outbound.protection.outlook.com ([40.107.94.136]:44449
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726024AbgHYHlb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 25 Aug 2020 03:41:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgunTb9vyWczPxeX8dzn29eQYq/mps9WtZVqUYaE9T5rqF4UJ2rhr5+986UW3aifxjz+JftbXpnkECmNBwucMs4jXqBnwTEir5UYNtLHXQQFZGdYOVoGS4b9WToawEFaVyjfhCfiJNICzjQLqEndBZsXdV1dGJhfQrAs1jFXO1Cw1XFxVM6NQaldSiIxdViHCUvQ4j/PdYo98UVE2NrG3kBdAV8SvNwZWMLA/2IGCjCjEYEHFDp4HwOM/3agfS2trJdP4Tf6LvCUia0JUNtsC2K3sOpIVVuKw76IeVBLhugepsQq0/OPG/KH3Rkup4e6J3bNuK6rEeJ2tiRZ3Tq8nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7iubob1UYjE7VDHX4HRDuNEAk4uIyCikhJ1vDnQW9c=;
 b=kO5v/Sk4pb/cWJpqCdyWKGE9Cd6QA3+D7iH9zJWlfIswnHfdwerFw5RwHT78NK3Dea7tO9NZfUOxZS97FFNas6nk5RB++WA35QW63xjrDcwKIGPLVDHWvlDNll/FpgxQ5T+Vhf99ZLnyPRIBJvEpdXXftZIQeCc8RR0xj3y3iINkHfQuvaZgbpyK3v9VOk3eJdLoLLS0iq6jyD71BCPEhKtJkax3zoCkLa0YZ0Icxl5QF5PuHyeWNQgnNujYG77JVML8up8Lo9ztCOHeEDLuXTjU29SKavGtzUmHjYXNvt+p1EoybRi6mWxAkOBBUBznLvOAdZb+OZfewJM/UFqgNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7iubob1UYjE7VDHX4HRDuNEAk4uIyCikhJ1vDnQW9c=;
 b=tb7iU3szW6n2c1uAcbMW7F86znXE2fEkXhIRWx1EHYSjYdNAae44RU8bDZMdTCmdcDhggIE9V73O8PAGFOdM0mEGctpxlw2GtjIEalO3iuefy5b+qptJ9CwkWHXAh8BhQvzH8CCCbixqP36dJhTwv8yZHbV7wl8cK2os2nwioRQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4102.namprd11.prod.outlook.com (2603:10b6:a03:181::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Tue, 25 Aug
 2020 07:41:27 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 07:41:26 +0000
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
 <74e185a6-909a-af54-9a09-e8f9c8809703@fortanix.com>
 <20200824235458.GA15046@sjchrist-ice>
 <8acaeafb-ee45-7fda-1773-cc384bcbdf0e@fortanix.com>
 <20200825073848.GA2847@sjchrist-ice>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <46b2765c-1598-91ea-af4e-8c772aab0da0@fortanix.com>
Date:   Tue, 25 Aug 2020 09:41:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200825073848.GA2847@sjchrist-ice>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020901010106010904060803"
X-ClientProxiedBy: AM4PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:205::23)
 To BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by AM4PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:205::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Tue, 25 Aug 2020 07:41:24 +0000
X-Originating-IP: [213.127.112.210]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea681abd-b148-48bb-4c7c-08d848ca45dc
X-MS-TrafficTypeDiagnostic: BY5PR11MB4102:
X-Microsoft-Antispam-PRVS: <BY5PR11MB41021966EC9B4B57FDEF37DEAA570@BY5PR11MB4102.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QrWk3YIOsKoQE7VlcrwK8bMkZCAEVQALGGS90NnGgrzYW3JdVeoIJrz9iTN0Hd1qDayfbJLUDcplAaKyrQeP3nZQsc20v+PH+XFZlZnV89YGjeSP5S2SxOGMz3f/SKLtrjn1IDhi5SQH2U9Sbksh/gyldhFNpa9WdWNMwYfeTg89zyHRs4+K1iBrr3+u+uxeTiByqlKW4sHjuvWKS50yD4N/3zwqBSkGTVrpC6lqvRaa2Vm/+S4MIGTNeCtEkZGV7rgOVrhQ135ypT10gN7jHb5RovguyDaw63wKFO6SFk3IFwXwACVX6DJG2HDhJtvrWDzpMWf0jn2xva4BIvuseT93xgYnH9inubRka0A+nn/QY7oqTlAwX/E8J0nRb3c1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39840400004)(396003)(4326008)(235185007)(8676002)(36756003)(956004)(2616005)(478600001)(8936002)(5660300002)(86362001)(52116002)(31686004)(6666004)(33964004)(2906002)(66946007)(16576012)(316002)(54906003)(66556008)(6486002)(53546011)(186003)(26005)(66476007)(6916009)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: uxfcJYHeob+omJNpggh2gWZgT4EYyrIZeC//Ai/ukpGZZNXxqHOO6ANl5Sx/Sa4yDqKix1/BXurM05uAWcTNXRr5euxsVtuMT2zq/JBg8qZydIHrxseWd9Lc+EdDozKx5PZVKA/uRL48xHwLRqsESudWBj30+4DECgwS4xyFIVQo5OgI4CHcJa+OtlnNgJCqwcdtD+/LVEVgrBoKkcJcP5dJliKRzbi6te0MGpfrgZFbEmPFYADet5nVIlvgZvRNLZyfI1cjkhXiSr6RZC7uSHCnoky1l5hTJKvQm79dw4z+tUf8C4B68s9kl+qvt1ivsf/h24DUfS3kz51jWClaR/sDL0UI/MUnJ4mxWAMOjeF7sktQi6EZAoFnEqQVX5/HD6/+c2uxM7qe/tHhsEkabzbO0ThhcPcSwnLmH087NQLOhxGQ47UE6JxtHJ5a4NNqegHHv/k2rauqpUcwG4gWVzPuwp+nbUUp+qyGPntDlD9eGvVKhgyycMF+biW/G98o17gYwpTGFEfW9xFcaIMlpLsHgfrlGJ5ZyWYid0T7QV2XaQlSKqC8JOEBk+/xrA3OWKx+dSgjOgJ8fCeXlay+GeW0Hv6yXz0CwmdEu3mxn7QAx6fHuU0ntYWi3nyrE9+HrndkXKL/SZx2hPDzthOexQ==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea681abd-b148-48bb-4c7c-08d848ca45dc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 07:41:26.8002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PevxjJRbMx5WbfQsASe93me+Dma+Z4nDUoARM95ogUk4nTBoQgPg3701+YtOeKwLJMue07Cis0xw4FsCbtIZpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4102
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms020901010106010904060803
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-25 09:38, Sean Christopherson wrote:
> On Tue, Aug 25, 2020 at 09:36:15AM +0200, Jethro Beekman wrote:
>> On 2020-08-25 01:54, Sean Christopherson wrote:
>>> On Mon, Aug 24, 2020 at 03:36:11PM +0200, Jethro Beekman wrote:
>>>> On 2020-08-18 06:24, Sean Christopherson wrote:
>>>>>  /**
>>>>>   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
>>>>> @@ -119,16 +153,14 @@ typedef int (*sgx_enclave_exit_handler_t)(lon=
g rdi, long rsi, long rdx,
>>>>>   * @leaf:	ENCLU leaf, must be EENTER or ERESUME
>>>>>   * @r8:		Pass-through value for R8
>>>>>   * @r9:		Pass-through value for R9
>>>>> - * @tcs:	TCS, must be non-NULL
>>>>> - * @e:		Optional struct sgx_enclave_exception instance
>>>>> - * @handler:	Optional enclave exit handler
>>>>> + * @r:		struct sgx_enclave_run, must be non-NULL
>>>>>   *
>>>>>   * NOTE: __vdso_sgx_enter_enclave() does not ensure full complianc=
e with the
>>>>> - * x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT=
=2E  Except for
>>>>> - * non-volatile general purpose registers, preserving/setting stat=
e in
>>>>> - * accordance with the x86-64 ABI is the responsibility of the enc=
lave and its
>>>>> - * runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from =
C code
>>>>> - * without careful consideration by both the enclave and its runti=
me.
>>>>> + * x86-64 ABI, e.g. doesn't handle XSAVE state.  Except for non-vo=
latile
>>>>> + * general purpose registers, EFLAGS.DF, and RSP alignment, preser=
ving/setting
>>>>> + * state in accordance with the x86-64 ABI is the responsibility o=
f the enclave
>>>>> + * and its runtime, i.e. __vdso_sgx_enter_enclave() cannot be call=
ed from C
>>>>> + * code without careful consideration by both the enclave and its =
runtime.
>>>>>   *
>>>>>   * All general purpose registers except RAX, RBX and RCX are passe=
d as-is to
>>>>>   * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESU=
ME and are
>>>>> @@ -160,16 +192,12 @@ typedef int (*sgx_enclave_exit_handler_t)(lon=
g rdi, long rsi, long rdx,
>>>>>   * without returning to __vdso_sgx_enter_enclave().
>>>>>   *
>>>>>   * Return:
>>>>> - *  0 on success,
>>>>> + *  0 on success (ENCLU reached),
>>>>>   *  -EINVAL if ENCLU leaf is not allowed,
>>>>> - *  -EFAULT if an exception occurs on ENCLU or within the enclave
>>>>> - *  -errno for all other negative values returned by the userspace=
 exit handler
>>>>>   */
>>>>>  typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigne=
d long rsi,
>>>>>  					unsigned long rdx, unsigned int leaf,
>>>>>  					unsigned long r8,  unsigned long r9,
>>>>> -					void *tcs,
>>>>> -					struct sgx_enclave_exception *e,
>>>>> -					sgx_enclave_exit_handler_t handler);
>>>>> +					struct sgx_enclave_run *r);
>>>>> =20
>>>>>  #endif /* _UAPI_ASM_X86_SGX_H */
>>>>>
>>>>
>>>> I think this should return void now, not int? Then, the =E2=80=9Cret=
urn=E2=80=9D section of
>>>> the documentation is also no longer correct.
>>>
>>> No, it returns -EINVAL if the leaf is bogus (and if unsupported flags=
 are
>>> specified, if a @flags param is ever added).
>>>
>>
>> Ok, but if I read the code correctly, contrary to the docs, -EFAULT is=
 not
>> returned but passed in struct sgx_enclave_run:
>=20
> The -EFAULT and -errno lines are removed from the "Return:" section of =
the
> above documentation.  Did I miss one?
>=20

No, I'm just bad at reading patches without syntax highlighting. This is =
fine as is. Sorry for the confusion.

--
Jethro Beekman | Fortanix



--------------ms020901010106010904060803
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjUwNzQxMTlaMC8GCSqGSIb3DQEJBDEiBCAj7zlkpOGb
gNTNc+2ruPpaIFdvVjBoUC7kpfKGUhaRGjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAfOmrBJkxl1ylOTmgipZzaWDC/EVnJsPJo2igU077FCeBvjjT+nGUgtLk
XtRaNH0mxrUnWZ0pNMpouACEWyJsdG+ocaT+4YhT7LDm50XID4cYg+Xqkqurz5z7B807v5oh
amx+2NyQvzxrNCa5cu3ojN6YS7KZqjGJ2pT3paLh142nYpzU3tEyyr8K7x1uLO3p9yWxEATO
MVx2gV5F4PFNqfB/VSqUepR6dvNpphuBjtMl8rrNQrMX7yEy8d5uIJViSU6MQt1Pq+lnnwPA
I92Snan4nhvCs0peZdbulqYu41FExxGaNIsZAg3Ud+F2UWtrjawYca2wFjNVz8WcXV9W+AAA
AAAAAA==

--------------ms020901010106010904060803--
