Return-Path: <SRS0=MviC=6O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8533CC83002
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Apr 2020 07:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 501D221973
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Apr 2020 07:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="fPomdM0P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgD3HUF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 Apr 2020 03:20:05 -0400
Received: from mail-dm6nam10on2139.outbound.protection.outlook.com ([40.107.93.139]:64572
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726692AbgD3HUE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 Apr 2020 03:20:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECZLtm9Lf24Ss4/O7GPzEdVeouk0TlC4fYTZC1hRQkr/jPFQEC1RZ+J0HvCspqL8NbgD1xKtXb1IgDPr4tMGGyoVjGvMEE0Ib1kKYpIino5YRBHvl2dznQ5v80i7XzeRCmQOx9fpfVcIjLevwOvKl+3TaSyijSGTE5GyE2xmRuRF9dCCpLQ3RH2UwuFqxkXlm0wAz57kKjFrQ3p5lCHIvRkLG1CmmF1bV6737X9S5BuTQFB4XMdygvSt8YCZEwZUyoWIYmwg9I5z1chVbZqhJqufzK4gFfa+WzIdm6IxV3W9iY3rDZskMBaujE2nJ/feLvXmhpaECjQA5km4Px/JaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rW3Gm1I3RNnHtHsyATEssZe6QX9sfZR7AUg57oS+8YA=;
 b=L0khLcLcKl0mgLWeeL3ImPksbGZMw2nmkDBs14JlyH7UJEUThenQJK/dDNtXAS7hrgGDKF2ClWKn6vRA46dE1oX1Vur4oLnsBucDf+BN1UDax0FoZsB3AvO9cSCD5aKQ2p8E0RNPdgnZWGwraM125y3SdWCVRV/+aO/MWvLphR+2mBnhhvWpCt9+5A7ZKvWPH4TrbpphyjsbY4Rk7kEJXWzTj/Z+eeCTSOTdCKSPf6tuVxFS6RT0gRwQ76anFURpfRMk9NK+GlgQmHRDbJmkUmXraMG51EXaq2f4PPlatxKP8QU3YkS/WyGvRUr7UeRyM01jONvhXRVdTf7qstpEKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rW3Gm1I3RNnHtHsyATEssZe6QX9sfZR7AUg57oS+8YA=;
 b=fPomdM0PYbPmRUZpspoupj7iyx1zIj8+hPG8vQ9DWmJRoDCNwNDn2zFzooZx2qf4o/grT6VzV9CoEoyFBmtcvTU5xaVG5yuKISqarLmxpPp0tOpFn0CGynpBXGqFPAC6LKXyUZM0WJxlVwNFSMmDi6Z8Fxyi76jqNwuwc+Bf69M=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4323.namprd11.prod.outlook.com (2603:10b6:a03:1c2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 07:19:58 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::48d6:af47:b6c8:fe6a]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::48d6:af47:b6c8:fe6a%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 07:19:58 +0000
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <07c1a36c-cebc-3a65-6f92-4a5498fcc369@fortanix.com>
 <20200430034651.GB31820@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <a9ff7817-32d1-e048-af05-862ca9f8aa46@fortanix.com>
Date:   Thu, 30 Apr 2020 09:19:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200430034651.GB31820@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010702010600080702080303"
X-ClientProxiedBy: AM6PR04CA0056.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::33) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.61.179) by AM6PR04CA0056.eurprd04.prod.outlook.com (2603:10a6:20b:f0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 07:19:53 +0000
X-Originating-IP: [213.127.61.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e704c3e-602b-4c25-f0e4-08d7ecd6e3bf
X-MS-TrafficTypeDiagnostic: BY5PR11MB4323:
X-Microsoft-Antispam-PRVS: <BY5PR11MB43233746B1B7C6A04F7BEC15AAAA0@BY5PR11MB4323.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1wTJsVNCvf5L7Nbz5yO3abiqpBfK5DoPazyqL8ZqG1Cj+G6Tgi+GKDIIZ+nQ10M8M8S3SD2m64O/OSsJf9ShKEI01utwcK0hH1jzpJTufxjjRljDPtXVM/NlFEP5p/ZDAIT99SqPaXgQpPYr99UKcKXZgNnhyAWQIHEMhxHDaaBq5n+OWaN4FMvSFXM7JsHjPsfpTbYz0eZFFyeQj6OEwMIs+E6M6JL2Yo4+hrGBE5MTqSLWuBk0H4LIEby2MTGJXzB3moY+JpnnqLHsghKexz86TCFBf2g0V8bJHcmIDf9xXm6cKIo42uuQzt6tLjYvlK75M6m6EWpwuGbtD6ghOYDWUj+wDaW6tpN6AauBqgaSWRQnL2N+Xl/lBg9Yhy7kSFOyLG/Gsa56v5zhX6KbHe5A43JYtuAmXAH8NgIzGMs+juBO9720GLWDlbof+jdB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(136003)(346002)(396003)(39840400004)(508600001)(31696002)(7416002)(26005)(16576012)(6486002)(86362001)(5660300002)(53546011)(186003)(6916009)(956004)(33964004)(316002)(52116002)(36756003)(16526019)(235185007)(8936002)(8676002)(2906002)(66946007)(6666004)(2616005)(4326008)(66556008)(66476007)(31686004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: P+5kmTuN5No7tYs01vV7PRBxjdP7tWOPLPbt13dB8NF0vyRU4LEsoQ78mieL17TmkVZmld4i34aMkomb24UJEjJj7gf/sZTDBbZFsWbDadZAqe7IlAOSqRCljp95VuTTkRK9NQ84EYs+wTj1O1dT51erthPdM0ZO4HC3oWMBUTyEq5lcoTivqSsnsVk9hBkFQpXtIC83n26RpJCvWxJuSNIKvu1uPo6u5gEpvOIEG98Aj+AJpBsICVeTL7WVm1oUr3AlnZ/cZAMDcWe/Jtd35ez3JX/AbYOY5/IRk4/4y4dPqGQCdTtIdjHgz1uDf0Xvq36ivdULLSLeZJJJErTLJo2Oihb+QDZ0tRSWMelAVdazs5eWty1dDm67wjrzpO574NGai+iRABfvTQmKRDeN8MLgpiER3KNA8TxCFroq7/5lb8SojQe95oSn8f5dzAQMtmCR49uuhpPS9Az/puQErJidmQ2d3O1qC0EUf4IUvpiy8gxM3aK99LZYChbXumYt3Z28VDODe1q39/+ZImyXj7hlinCrtFj3Yj4vkMFqaaCGFGIbVdSy1yCIUhLUgPHw/8dMLfp2byQ/EEivcJdXpxvJFe3O5Y73bsmTnRUiZcd3vH9Ebe8lTsUH5MQcFBQCgKO+ogGLjPGt1q4FUKLYP/p1u/8h8L0AIWJOo3UNcwa7LBIfQ5o0GAgf8V5l5ZMdwrrGXmsadPLpVIXXt7pFH3opKz/3z66Jy13/8nYGKwdaAZH4qAC6v70mx1ZKGlD0ZiiJSZeBRsGZqayaNmWNj4noF/KLJuoEtmhRWIweh40=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e704c3e-602b-4c25-f0e4-08d7ecd6e3bf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 07:19:58.7806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vLL2ESRX4/qxruYW7i15WBdWOXQMO8duyFljyOBM1A69HVJ0sP1Xp9hxV6ZLNlGvjZ75nsRl93sFwEH+Qfe9mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4323
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms010702010600080702080303
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-04-30 05:46, Jarkko Sakkinen wrote:
> On Wed, Apr 29, 2020 at 05:27:48PM +0200, Jethro Beekman wrote:
>> On 2020-04-21 23:52, Jarkko Sakkinen wrote:
>>> Intel(R) SGX is a set of CPU instructions that can be used by applica=
tions
>>> to set aside private regions of code and data. The code outside the e=
nclave
>>> is disallowed to access the memory inside the enclave by the CPU acce=
ss
>>> control.
>>>
>>> There is a new hardware unit in the processor called Memory Encryptio=
n
>>> Engine (MEE) starting from the Skylake microacrhitecture. BIOS can de=
fine
>>> one or many MEE regions that can hold enclave data by configuring the=
m with
>>> PRMRR registers.
>>>
>>> The MEE automatically encrypts the data leaving the processor package=
 to
>>> the MEE regions. The data is encrypted using a random key whose life-=
time
>>> is exactly one power cycle.
>>>
>>> The current implementation requires that the firmware sets
>>> IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel =
can
>>> decide what enclaves it wants run. The implementation does not create=

>>> any bottlenecks to support read-only MSRs later on.
>>>
>>> You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
>>>
>>> 	cat /proc/cpuinfo  | grep sgx
>>
>> Let's merge this.
>=20
> So can I tag reviewed-by's?
>=20

No, but you already have my tested-by's.

If it helps I can try to review some patches, but 1) I know nothing about=
 kernel coding guidelines and best practices and 2) I know little about m=
ost kernel internals, so I won't be able to review every patch.

--
Jethro Beekman | Fortanix


--------------ms010702010600080702080303
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA0MzAwNzE5NDhaMC8GCSqGSIb3DQEJBDEiBCDprLGucF0L
t2p2UATqEjuqNLav0KVD3I3+U0IyQtx17jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAWwKEQvR6kP295ClAz0ZaAA8qBtLW9Hh/YNMrzRaVCvfVUzngF/GTw2ki
Piy1MBbPLycVOVyMiRisU66qgcxK7JK0CAjS89uR6/TT1Y3M2IU7XkLJ8gRUWeh7xSU9j4te
vSeOG8Uu0+WKrqLSOR62eoxuqIEl+0a2VoHrGCrnneT2aAnVux+bP7A+w70Do9rMt9urTm/M
iaDLrGJ4H+oEZFbeiaGhiAvaSmEJqTBZLyT/rOK9Cfyfhv4JEOp7puh/TAEQqfNki/2jGOZA
8rObP0tsRCXo3dl5i5ltlZD3WefdgLXFzLHF8SbhVyspwEKFRCPKrKeVZnvBOWpAyD6WHwAA
AAAAAA==

--------------ms010702010600080702080303--
