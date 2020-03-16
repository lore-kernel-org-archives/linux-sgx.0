Return-Path: <SRS0=nADd=5B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E845C0044D
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 13:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E1B320575
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 13:59:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="KjZIRDkY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbgCPN7p (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:59:45 -0400
Received: from mail-co1nam11on2137.outbound.protection.outlook.com ([40.107.220.137]:18784
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731110AbgCPN7p (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Mar 2020 09:59:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYdDvid83nrpYTtAhaTUYBqNHbppxFKeYkQLSkJ4HtetffM+ZDFl6rNEp9RRKXfYYG5ok76ZKXuXd6C4aaUidepRYGDXL5hggfKi+i6RIK1m+7OTgJrEs1OldeCco7izbIzz4oCQ++iiWlZ1V8Xb7I+h+pvzSFoL3BqO0KwVXWZhPKH62F9pQxT6GFLQiHoiMmX7HpK79Co6atS52N8MxVAe6+lbzWErCr4bmgvoO7YSTwuQNOIMafIVXbf9TcbGSdI4bjpZQMSTlY/WZ5zUXJuVOM1BqIazi1vpp31KsptkykDL652iC+VYu9AJxbVL6SCJrvOc6iXGUHXQBbLkcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDeuwP6ngoU8Iil9/me5mHSm7MS+eJXp3ZPlp7Zp+5A=;
 b=H13eoZA8jg20nWEz1Loc3WLvOvNQjrt1M9OrUy2ieawU2ri/saA2Cf4fRF7agzpJheomTP+bRzGrrpmngRxH8m91A9r/oTrEME+Alu3P1mJMfSxEo+oK4jIouKLEmT2bAN1kJ1AW5Bo5hRubZ9Id2gvoAvfBgd0NXRo2Mu8iDm+EaHPOOt4E6PyWY/m5GIyGYYSyXF06PCsQF19Xv+5xIkHHz+eNePoFHth91bawRU0iGI3XLNgFg3yX89iDExc2X22NgYhGG04ZvOP7otwh3mnHklslLe6inPwh8k1rHa+vsNqpI3qYsA1J6aX66S1Pz2h5N57U4x2G6XN+jgdGUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDeuwP6ngoU8Iil9/me5mHSm7MS+eJXp3ZPlp7Zp+5A=;
 b=KjZIRDkYS/+KX1Pvo1oSg1zTEgXajFdY/7BXpruqZXGs0GReKNrFrhfYcekf5scppUHYT26qE70ygGXbc4u3CaDv4/4fjWcL6a17x2/EHAGlBtAHTZb8iuPRSRBzgHcSRpnXIuWcuLqfDhbYtr4B8qg5p3Jljy/kxL6ntUUZ5LY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BYAPR11MB3223.namprd11.prod.outlook.com (2603:10b6:a03:1b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Mon, 16 Mar
 2020 13:59:39 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::dc9c:f877:efd1:401a]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::dc9c:f877:efd1:401a%4]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 13:59:39 +0000
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        cedric.xing@intel.com, Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
 <20200315012523.GC208715@linux.intel.com>
 <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
 <7f9f2efe-e9af-44da-6719-040600f5b351@fortanix.com>
 <CAOASepNifZdBmg59sJcP1mqSYMW_C=KsdKq-fCmvAU_5iQ9DFw@mail.gmail.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <db12016d-8719-daa0-4742-7d7c43dd464d@fortanix.com>
Date:   Mon, 16 Mar 2020 14:59:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <CAOASepNifZdBmg59sJcP1mqSYMW_C=KsdKq-fCmvAU_5iQ9DFw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080905020202080706030502"
X-ClientProxiedBy: AM3PR07CA0088.eurprd07.prod.outlook.com
 (2603:10a6:207:6::22) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:a210:a441:3083:da8f:6fb9:9677:3d38] (2a02:a210:a441:3083:da8f:6fb9:9677:3d38) by AM3PR07CA0088.eurprd07.prod.outlook.com (2603:10a6:207:6::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Mon, 16 Mar 2020 13:59:33 +0000
X-Originating-IP: [2a02:a210:a441:3083:da8f:6fb9:9677:3d38]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a424fd62-0437-4707-1d39-08d7c9b24468
X-MS-TrafficTypeDiagnostic: BYAPR11MB3223:
X-Microsoft-Antispam-PRVS: <BYAPR11MB322326BD35709613C7243BA1AAF90@BYAPR11MB3223.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(376002)(39830400003)(136003)(199004)(52116002)(508600001)(4326008)(8676002)(8936002)(2906002)(235185007)(6916009)(7416002)(5660300002)(66556008)(86362001)(36756003)(16526019)(53546011)(2616005)(66946007)(6486002)(33964004)(81166006)(81156014)(316002)(54906003)(6666004)(186003)(31686004)(66476007)(31696002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB3223;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XHgoEPUCL5+bSYUjx9QtT3tWYUiCzwqLbF3NBQjMAMa94ZJUHlDeHUz+xvAahDe/4kpp59w5PEGy/xAH5oUld2/TaA2PVyLNLtaPekHUJaRYVFH5sCdSBwpahQn1ug0N0h+pRP4AQXu69J0ER30h6bXAJ6kTOJqaSlCOWJOVB4RUNGLCTHYtrfnZvf+LU2nck8zBazdHy25Pbqh9Pv1tY8jv+v5/b2qj7iGrV1bXUlqefvcn6lgrKjxn+2nGKiFvLNuHGHAX2gpqko5yNU0gzjFZG7RvjvmSdimo+bVKWzKhDKuXhy3Ogu534UwBai/98yqVH9bhjLnycJdk9cH0NSqclLRVlbMR8YxOFe20jW9WwSJLyMqRSLzu9Obum8p8M/KCLxj4q9HkX17YE5gBsKBxOCb5vHRXLTkJBE4Fahtmk+nsTe8+G2lKDYGCgnDM
X-MS-Exchange-AntiSpam-MessageData: kt5nHRrroIq+cZMY2PMaM+EWUmhXoB848u8PLavJ+LnlfcYK1dHEa2b976KOrB1XMy2wWn16DPxsls5DlsVzY7N8C4gcQNTQirqxf4wCJbBN7skjlxCy3CNqbZEBzaCACWn1Xv1OKFDPX2i6m7pD5K9SS2vh3mhu73r/O/ox6sS8QKh16jPP0si13xhf1SpbZwqecMd08L9dLU2uczT7Yg==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a424fd62-0437-4707-1d39-08d7c9b24468
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2020 13:59:38.9687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7AGLwNxTA85E70HxkW8R9UmE/2ppRs4FtlYOckxvJ0XtSynppEBkCrKd1cvVR+So17Ei5eEu7MnEgX3AAeSxbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3223
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080905020202080706030502
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-03-16 14:57, Nathaniel McCallum wrote:
> On Mon, Mar 16, 2020 at 9:32 AM Jethro Beekman <jethro@fortanix.com> wr=
ote:
>>
>> On 2020-03-15 18:53, Nathaniel McCallum wrote:
>>> On Sat, Mar 14, 2020 at 9:25 PM Jarkko Sakkinen
>>> <jarkko.sakkinen@linux.intel.com> wrote:
>>>>
>>>> On Wed, Mar 11, 2020 at 01:30:07PM -0400, Nathaniel McCallum wrote:
>>>>> Currently, the selftest has a wrapper around
>>>>> __vdso_sgx_enter_enclave() which preserves all x86-64 ABI callee-sa=
ved
>>>>> registers (CSRs), though it uses none of them. Then it calls this
>>>>> function which uses %rbx but preserves none of the CSRs. Then it ju=
mps
>>>>> into an enclave which zeroes all these registers before returning.
>>>>> Thus:
>>>>>
>>>>>   1. wrapper saves all CSRs
>>>>>   2. wrapper repositions stack arguments
>>>>>   3. __vdso_sgx_enter_enclave() modifies, but does not save %rbx
>>>>>   4. selftest zeros all CSRs
>>>>>   5. wrapper loads all CSRs
>>>>>
>>>>> I'd like to propose instead that the enclave be responsible for sav=
ing
>>>>> and restoring CSRs. So instead of the above we have:
>>>>>   1. __vdso_sgx_enter_enclave() saves %rbx
>>>>>   2. enclave saves CSRs
>>>>>   3. enclave loads CSRs
>>>>>   4. __vdso_sgx_enter_enclave() loads %rbx
>>>>>
>>>>> I know that lots of other stuff happens during enclave transitions,=

>>>>> but at the very least we could reduce the number of instructions
>>>>> through this critical path.
>>>>
>>>> What Jethro said and also that it is a good general principle to cut=

>>>> down the semantics of any vdso as minimal as possible.
>>>>
>>>> I.e. even if saving RBX would make somehow sense it *can* be left
>>>> out without loss in terms of what can be done with the vDSO.
>>>
>>> Please read the rest of the thread. Sean and I have hammered out some=

>>> sensible and effective changes.
>>
>> I'm not sure they're sensible? By departing from the ENCLU calling con=
vention, both the VDSO
>> and the wrapper become more complicated.
>=20
> For the vDSO, only marginally. I'm counting +4,-2 instructions in my
> suggestions. For the wrapper, things become significantly simpler.
>=20
>> The wrapper because now it needs to implement all
>> kinds of logic for different behavior depending on whether the VDSO is=
 or isn't available.
>=20
> When isn't the vDSO available?

When you're not on Linux. Or when you're on an old kernel.

--
Jethro Beekman | Fortanix


--------------ms080905020202080706030502
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
MBwGCSqGSIb3DQEJBTEPFw0yMDAzMTYxMzU5MjhaMC8GCSqGSIb3DQEJBDEiBCAWHEJaz3Ie
bBS6x+viJRB7L+zKdMek/7TzAnwgsUSkcTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAwo4P8qSlomDjcc9pr+1C65CipdvtKiHL86u1onlhxpU4yyx0iQ3AMroy
cKt1Io7UlR/BrefVBW6tWP6/1+Dxhypq13c6grwTl0ajpQ+fdglvaKux131xbXtruuSjRB5A
OJtOz2ma3Z0EREv8RTYnjKDSccUAtAZW4p1EsTBm/BWpcmNNU4WBK6n9RxLgaV/xLufwz6PY
ztgPJt16NLqEBgKG44AsbhdGCOv21mDJZtJBFWO5UiwI1kRfogtAqBE0v5m+w3CHI88c56AS
6kCdQHbajDwBndCkt9xgjH0S8xu5NFzN42IbVU+jgE/S4k34QW5Lw49eT+J+kZc/+ZXuOgAA
AAAAAA==

--------------ms080905020202080706030502--
