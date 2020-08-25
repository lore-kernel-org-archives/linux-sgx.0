Return-Path: <SRS0=1rnR=CD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,RCVD_ILLEGAL_IP,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9C4C433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Aug 2020 07:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3622A204FD
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Aug 2020 07:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="lvuVWCCS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgHYHg3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Aug 2020 03:36:29 -0400
Received: from mail-bn7nam10on2106.outbound.protection.outlook.com ([40.107.92.106]:31666
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729399AbgHYHg1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 25 Aug 2020 03:36:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JilWmzw6C2fIDCNFA3k2P1YcdtUey1a2FsK1rEXIx5jklK32HKYibeSBfTUwm+g/facknx3F2kZSac0ZWsA/75bkXLMZp7Qq+IlcG2CKYXEufrA7COF72W+n3hHbgXgr6rNbj7Pxodu7Tz0YT9pYjNVcwWUzoDcY6VyGGQGis7DgzW0vFFfdkW+SEYgUdU2l4/JJdxcXGnTlv88rEq5a/3WDUiGxLQKeLSScWM7PrD1G2jihwNTyyR1FVqVW/nRWEAt+9BIT8fCwvA7FC8x0RiCTgM+ngsnZvhuircUwRy5eQEHzgdVxI2oPJXJCSVzJFQcTLj/k29oEJMb0iLRJLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csizjQAzx9xYtNEK/RZ2fWYb5CV9f0ojM3VkCf52Guo=;
 b=dzIpj3LpUwyethDEScbSCYV5PiQXU3Iupjuxm7e6ROIx2J8zAU1nlI+JuuhyHmQfckRgUxyopEAj3gmUzviGGlvt/EUvjG1sHqh7YzwQWTNPRV4U5dV3LW6Tywh32TK2jJvtee7RVxUraDtqAGmWOl9G/0KhL2d+iyAGusNYPxeVK2bdFuq/cj6gCS5x2inXqT/9L4HdPgPxI+QxpjqOyw03TCkiEEFjeoeiLcoCXPudhHorhNdt0koq8MHTkDXQKRFhzGC+YbZTL1RyVD0WU3lbjY/RrBwqkTHUEDfbDQS/alLmDYSwA9HJZO8AnctoRxyxIFhtW89SYFIpqyKZkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csizjQAzx9xYtNEK/RZ2fWYb5CV9f0ojM3VkCf52Guo=;
 b=lvuVWCCSj7HpcVGb2Wc3G8L6WQ0uKHQote6iaoMADTA1scZ3ujthWLLVmuTvyMaFnEgdubKa3OLBFy0wcg3LR4qjPsc+vzQgC//t4GIs6BAxkFaVer4FF4VNFHzYl0llmCbP7SV5R8U7THH3HjUuiny2dG7MjkicH6Kf2nwzMJ8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3479.namprd11.prod.outlook.com (2603:10b6:a03:1e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Tue, 25 Aug
 2020 07:36:23 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 07:36:23 +0000
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
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <8acaeafb-ee45-7fda-1773-cc384bcbdf0e@fortanix.com>
Date:   Tue, 25 Aug 2020 09:36:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200824235458.GA15046@sjchrist-ice>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080106010300030308010509"
X-ClientProxiedBy: AM0PR01CA0153.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::22) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by AM0PR01CA0153.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 07:36:20 +0000
X-Originating-IP: [213.127.112.210]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4b7cf40-1d6d-409a-964a-08d848c990c1
X-MS-TrafficTypeDiagnostic: BYAPR11MB3479:
X-Microsoft-Antispam-PRVS: <BYAPR11MB34796C603F587FB0CCBF1545AA570@BYAPR11MB3479.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3idqbkH4KOlVH4pOE83RUU93vUjNnSQfTUzxumwxAg0xJFhT/kDDwZKZzqynKAtP8qTmtpY8kCHlGXEnQ1qmhpTZAp+6r+8mIpfy4dgoNVySvaL1zTXN/5WOoyRm28/qazeu4LdRuMpQUo9WdmSGLaoNKxwNjoi1tVwnRRbsyBhC0RoFFBC+syep1mbt5gy2sTkVUWiPRbxMiHVb9IT9v3KbThsI/6ahxpXN46HdMjzIFK66+Swlxf+fqnxxyqRGpb2szhy6GzfvMKojQOLje6BX05WjHt0JErizKSfabc9UZE/nWrNbjvqNkOh4in+QESctD60pUVp8bTdaWrgW5q5chB4oqTpqBiqqiA0rnN+2q+a91fzcHtMz/gJ44Wlq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39840400004)(376002)(136003)(346002)(396003)(316002)(6916009)(186003)(2906002)(33964004)(2616005)(956004)(478600001)(31686004)(86362001)(36756003)(66946007)(52116002)(66556008)(4326008)(6666004)(8676002)(16576012)(66476007)(31696002)(235185007)(54906003)(8936002)(6486002)(53546011)(26005)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Civ1asGOSdkG+nLBZDkO9hoxd2yn+pPDmHeIuQNM+rIRYyExMBmc9GIMsVQjZHPO3nBTMl5spsdVAXlMXgVxqrvOjcTAvFKPN20kdelFQwTeMYdeeo2GsGbrKuPCS/NUAVV/DCn5fcNZxXgdLWem0h+kNSN5sIs34+22LFe73Wr8Gx5gBxhnQvEy2RClJPqVd+Ng+P7tj2wyXfDBP1a0/ge8dg1cyYHTypD1Jn7ob36d9NaIvyG/5Bf4B8J1E4RDgrUXpINbsrvGhChhoF/iPIFVAxS9ZOhx4OgQQkx7ZiooMB7wDlfeXMpgKxgudl5oX+QetnlUW+chBrybdnxwlQn7VMGLNUv+whX+RfpviPgocl+pTrFcJ+8CmAZmEOVEbe8+5vpAW2FxJlgArGGCM7jEv/Jn3+qfFywGWhkasuhQf2QdqfY1ZrnB7+rsmNzIa5xionCee1J6izEZoVi1l14+hdIYSelCljWrSGJeHFepFTyCMV5Vx7uhUN4aEa18s06o2HnmNwyvajeVr1P9XNOHw26uliMW7QAtHVA7TTcWuwpEokPGE2ru4kOlRQy1MK5FfCoRgq3ccWfMVOSxEONX8YoRTn/tJ52eHZISoOOb6QRxOBPPbqNhNwrwHrRK26RPvAhsMRIOSoeWIkTeOw==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b7cf40-1d6d-409a-964a-08d848c990c1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 07:36:22.9336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6iq0dA5rObYOOmixwYa1Wa6lqOcts4U24h3QJxZWo0Q5MZjo6FWO63n8G+tY5n1BPIpewG6G2GKGxer2B0zoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3479
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080106010300030308010509
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-25 01:54, Sean Christopherson wrote:
> On Mon, Aug 24, 2020 at 03:36:11PM +0200, Jethro Beekman wrote:
>> On 2020-08-18 06:24, Sean Christopherson wrote:
>>>  /**
>>>   * __vdso_sgx_enter_enclave() - Enter an SGX enclave
>>> @@ -119,16 +153,14 @@ typedef int (*sgx_enclave_exit_handler_t)(long =
rdi, long rsi, long rdx,
>>>   * @leaf:	ENCLU leaf, must be EENTER or ERESUME
>>>   * @r8:		Pass-through value for R8
>>>   * @r9:		Pass-through value for R9
>>> - * @tcs:	TCS, must be non-NULL
>>> - * @e:		Optional struct sgx_enclave_exception instance
>>> - * @handler:	Optional enclave exit handler
>>> + * @r:		struct sgx_enclave_run, must be non-NULL
>>>   *
>>>   * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance =
with the
>>> - * x86-64 ABI, e.g. doesn't explicitly clear EFLAGS.DF after EEXIT. =
 Except for
>>> - * non-volatile general purpose registers, preserving/setting state =
in
>>> - * accordance with the x86-64 ABI is the responsibility of the encla=
ve and its
>>> - * runtime, i.e. __vdso_sgx_enter_enclave() cannot be called from C =
code
>>> - * without careful consideration by both the enclave and its runtime=
=2E
>>> + * x86-64 ABI, e.g. doesn't handle XSAVE state.  Except for non-vola=
tile
>>> + * general purpose registers, EFLAGS.DF, and RSP alignment, preservi=
ng/setting
>>> + * state in accordance with the x86-64 ABI is the responsibility of =
the enclave
>>> + * and its runtime, i.e. __vdso_sgx_enter_enclave() cannot be called=
 from C
>>> + * code without careful consideration by both the enclave and its ru=
ntime.
>>>   *
>>>   * All general purpose registers except RAX, RBX and RCX are passed =
as-is to
>>>   * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME=
 and are
>>> @@ -160,16 +192,12 @@ typedef int (*sgx_enclave_exit_handler_t)(long =
rdi, long rsi, long rdx,
>>>   * without returning to __vdso_sgx_enter_enclave().
>>>   *
>>>   * Return:
>>> - *  0 on success,
>>> + *  0 on success (ENCLU reached),
>>>   *  -EINVAL if ENCLU leaf is not allowed,
>>> - *  -EFAULT if an exception occurs on ENCLU or within the enclave
>>> - *  -errno for all other negative values returned by the userspace e=
xit handler
>>>   */
>>>  typedef int (*vdso_sgx_enter_enclave_t)(unsigned long rdi, unsigned =
long rsi,
>>>  					unsigned long rdx, unsigned int leaf,
>>>  					unsigned long r8,  unsigned long r9,
>>> -					void *tcs,
>>> -					struct sgx_enclave_exception *e,
>>> -					sgx_enclave_exit_handler_t handler);
>>> +					struct sgx_enclave_run *r);
>>> =20
>>>  #endif /* _UAPI_ASM_X86_SGX_H */
>>>
>>
>> I think this should return void now, not int? Then, the =E2=80=9Cretur=
n=E2=80=9D section of
>> the documentation is also no longer correct.
>=20
> No, it returns -EINVAL if the leaf is bogus (and if unsupported flags a=
re
> specified, if a @flags param is ever added).
>=20

Ok, but if I read the code correctly, contrary to the docs, -EFAULT is no=
t returned but passed in struct sgx_enclave_run:

-.Lskip_exception_info:
-	mov	$(-EFAULT), %eax
+	/* Set the exit_reason and exception info. */
+	movl	$(-EFAULT), EXIT_REASON_OFFSET(%rbx)

--
Jethro Beekman | Fortanix


--------------ms080106010300030308010509
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjUwNzM2MTVaMC8GCSqGSIb3DQEJBDEiBCBc/C+9xlpe
DV2wJ0Up/PQOv0meo8TxNXb+nMPyD7sPkTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAgQf3nW1/cbJ4rfId9NkcBIOWyxNCl8WSP1ELfWaBxQf5n/wXulkzSM9G
vF0AuZe9y94wLYAhgaWp+QnHh2tRcJXkvOREtZm7/4gEu3b7AhQrhjtMkiaQizA2uAUuNfPv
DZFxB1yIqQFdgyA5ERPuRscyp9Hgb0jEOHtDjvCErrlevd3et7uqFMrJ01bwTFjhha5a9izI
ACpchOqYBlGzvNFDhqyMbAl7eaIbdNYPFx6XB9wMmJa+cCSag+OHlCbsu0LOtxHwOW2VD+KH
1yX6WEXwBD+L88M/GAXv0RCsVY0d+yjwhrkDP5pFPX6xufX4Tpc5U8vgSoTyIYkoF6YAzwAA
AAAAAA==

--------------ms080106010300030308010509--
