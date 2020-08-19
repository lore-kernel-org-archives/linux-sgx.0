Return-Path: <SRS0=I8pg=B5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CFBC433E1
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 14:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B5C020639
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 14:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="CTWaG7Bs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgHSOVW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Aug 2020 10:21:22 -0400
Received: from mail-dm6nam11on2137.outbound.protection.outlook.com ([40.107.223.137]:52961
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726560AbgHSOVU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Aug 2020 10:21:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/veT09LlQcLFRe9AxF86iJ6mu7KG42ac+TK6PaDojwiJOrsXYazeFQsnwUCOzgug6C9WCqTG79XhxkextO2k/7x4tb1Ta+Er+rp5d7shpNtby9HGuIJuMhfZDu1HX0W38cdZQpFosv3VOOTx0DjFN8And0EA0+xdPulmBU1rPC3Lh6PzS+2BvH53eOX+aVv34FpI2oOtkHFkLVTyRONzS6JK2MBTVWAiIT6m0Wi6F9ppIearhRYO2dBhwmIGy7KwUbKseFlZOkOm6qbR4YUuzEpgRDi8KR9v2ZE0DkwdWfXY4hAAYgi283TJ4n453rtd/5f59Tpar92tnjudFpVBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPz2se7jl7KpGQm9DJSwfLE3aluz0o8v/B8J6N3cO8Q=;
 b=cCHu2KpUM04iXdcGoFkiqjoJD/i0FvRXTDTZCMDAbXnFeVeIG3jO6ttyjvtRljUnXlpLHlZhFUgn72g8Ah52SKokssc9eNuJmEOa8bGJhdC1Q6DtQ2wO9Ad3pJbz5dXOD3eBnxrgNtVeV3bf8PSCLMorBYd/OMK4goYOs1A9M6bX3sDRMkWNu81rDFK5NdRMjsYUisFxWRIvGJOTvTW1ci4vlf+tzmzEhGonq7qlYq3mFSIyCFc+rzvMGPuPSIEWvOYjp1yJGUyLdZrOVCfX1DBRfmiok+fETjRypxhHRBIzf4Hi2ZBQ+YS0/xoav0zmiZZ/qsQ2nGCMBCiDtBnQ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPz2se7jl7KpGQm9DJSwfLE3aluz0o8v/B8J6N3cO8Q=;
 b=CTWaG7BsSk+bWVzeNXAkhKYK1BS1pbaZSlpjZRtsFdEEZg9KYqJ6Z/0JPsG378N1lq4ali6P9nPO7AfuVK0yx3LWXzlutBkc+Q91GdVVx1l1vmZE3DCWbLdlTr9rENfAVZZEg6oeqMaAFg9HmJ01UjxUdaGIqw+84icy8LsdzaM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4353.namprd11.prod.outlook.com (2603:10b6:a03:1b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.23; Wed, 19 Aug
 2020 14:21:15 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 14:21:15 +0000
Subject: Re: [RFC PATCH 4/4] x86/vdso: x86/sgx: Allow the user to exit the
 vDSO loop on interrupts
To:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-5-sean.j.christopherson@intel.com>
 <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <6109f3e1-0579-67c6-0a02-f9b931ba1fac@fortanix.com>
Date:   Wed, 19 Aug 2020 16:21:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030603090703020505040202"
X-ClientProxiedBy: LO2P265CA0137.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::29) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.195.0.246] (212.61.132.179) by LO2P265CA0137.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Wed, 19 Aug 2020 14:21:13 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5f855c2-23c0-4183-eddf-08d8444b21b6
X-MS-TrafficTypeDiagnostic: BY5PR11MB4353:
X-Microsoft-Antispam-PRVS: <BY5PR11MB43539A5DFD0824CD5A27950CAA5D0@BY5PR11MB4353.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wa3XwRibd1m4AhV0AOZBLByxwBXcAH1ObrwWHw5WQdl2GKR4UiI0EAR6szu9ILssA4EiJ8s07yaZQSla8UpdCjMwKwwn9WWKdlV0i6buBcHrqU9XYNVkleyoyj7Ph8Qh7poqAvzHPPQksHKF1k9XacUPxIRdnmh55jvbYVv+XT/473XsUNdGlfa4W8X2UBeYmpXRpMCtoobJBZkwKkc+D8sJ8ZGZr2nZks36Nu9a1IIle9mFLuPMSBtel8ORhZ3pHQAuDTtQhACucWZIMfMmu0rROtGC3RGPYP1mmyRU+JrRN8qd92rzwOSWOnkj0ty3n4x2N6jAp2wsZ1XKeTO1duSU5JrS2al+aBUnwXudjAcumuvnfKWtX6U4QdkqXWz1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(6666004)(2906002)(86362001)(31686004)(110136005)(36756003)(83380400001)(16526019)(235185007)(53546011)(54906003)(5660300002)(186003)(52116002)(26005)(16576012)(33964004)(8936002)(508600001)(2616005)(31696002)(66946007)(6486002)(66476007)(66556008)(8676002)(4326008)(956004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: VUlc0lLH1trUq0pYo94AK6/RwoF9Vkqy2PfFkgSoJx/uq+0DzdF0AUCDbKeW9EaFhfOM494wWpnqEH7CXWd3JTx+RTlCnRmDqu51iOHuKWVLnkMq070WvgqgVjYvR5mLW8ZFWBe0LUaQ6+/+s8be+h2ySneeJrd96ON5BOd9ffTehcmGpqZDFZEYTWe8AaEFVFGvxMjU6g/Kyjoaso3uf0FQw7R2kuopRdJnRY2SH4hcxHOwRSbYw80eHVsck8jqeaTmwWuBcvdW2Ph7j4gaxZfauxFUJ5czaVi4QcmwfQo7BdxcutNnrm34FutCDZNBeyM9mZwBbdhm4LZtPAysZFpENOvChCE3T2oxnbc64waHeNZO84bv6GObM3akegQ1zLDcBYnsWO2dT+7ybV8PEXfcTQO3WwAJrV/cs7hdMURcL7LoGzVl2OctXZmVSoTxXQhGo42dGHvdgmUEq7+JtwZIZR7FgRkpYG+1vG29SBnL+dhTecbyH+mqLa2T+ddtIBKYLlGG6hpbZCTaZkzN8CBGe5pWOY74+uzxC7yIhczGoEB32ySyzfwOAenNq0pAE1UfoUKycNJbdeqVcvKLIIXsi7MycUM0s2zs1dX7gYxpz7coshvPXVsWzT6Iok7/HTXqBvl2K2BmWGlhg1A7AA==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f855c2-23c0-4183-eddf-08d8444b21b6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 14:21:15.4146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tE2Q8bqn8jwFsIDChxxUMyMtTEi03nZ3eL+7Tr2P+bEO5PjXcAI//6Igf2zX58/dtiO0pMlF4ybR2dJ4MDvrZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4353
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms030603090703020505040202
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-18 19:15, Andy Lutomirski wrote:
> On Mon, Aug 17, 2020 at 9:24 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>>
>> Allow userspace to exit the vDSO on interrupts that are acknowledged
>> while the enclave is active.  This allows the user's runtime to switch=

>> contexts at opportune times without additional overhead, e.g. when usi=
ng
>> an M:N threading model (where M user threads run N TCSs, with N > M).
>=20
> This is IMO rather odd.  We don't support this type of notification on
> interrupts for normal user code.  The fact user code can detect
> interrupts during enclave execution is IMO an oddity of SGX, and I
> have asked Intel to consider replacing the AEX mechanism with
> something more transparent to user mode.  If this ever happens, this
> mechanism is toast.

Let's design the current interface for the current architecture. We can d=
eal with a new architecture if and when Intel provides it.

> Even without architecture changes, building a *reliable* M:N threading
> mechanism on top of this will be difficult or impossible, as there is
> no particular guarantee that a thread will get timing interrupts at> al=
l or that these interrupts will get lucky and hit enclave code, thus
> triggering an AEX.  We certainly don't, and probably never will,
> support any corresponding feature for non-enclave code.

There's no guarantee, but this vDSO exit mechanism is a prerequisite. Bot=
h for context switching and aborting an enclave, userspace *must* have a =
way to trigger exit from enclave mode *and* recover the user stack in a s=
ane manner. Userspace *should* also be able to do this in a way that's co=
mpatible with library use, so calling timer_create or pthread_kill to del=
iver a signal would be ok, but installing a signal handler should be avoi=
ded (the whole reason behind this vDSO call).

> So this seems like an odd, and possibly unsupportable, feature to add.

I can implement all this without the vDSO call today, so why not support =
it? That just means not everyone is going to use the vDSO call, again res=
ulting in potential problems when multiple libraries want to use enclaves=
=2E

> --Andy
>=20

--
Jethro Beekman | Fortanix


--------------ms030603090703020505040202
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MTkxNDIxMDhaMC8GCSqGSIb3DQEJBDEiBCArlppzkowq
NK3lc1O8IWKFMekIplLg17p3k3uzwQTmwzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEACwboFvF9+pUVJ9gPX5GJo2v7d8Y4+JaP8L95ArkAnbU78J4iCcL6mRqM
EBwqQShqZ4odOHv35SIQ3t1Flyg3TZ+qD/7H24aBg2PKLv08IMwwn4CtM9jcsKw3cpIgyTpK
kqBaljyFnOVXa0g/g7p6WkzbBWcXZHSHU1b3b2EI0HCak007RmCvgBNtH2d52n7sa3Spl5c5
SPwqRUPATuxEUcyM10r9r0BH7ZsiPvCxFRi+YGT4so9jkJsvv+0+343Pf8ou1iyNue6YcX+k
ztweZ7SxGtFXgz3ROLn77T6kW7kaHAMpq5I9rFk5mwM1lVRUSXz7kE75PvbW3hA1gwve4gAA
AAAAAA==

--------------ms030603090703020505040202--
