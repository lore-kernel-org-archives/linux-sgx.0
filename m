Return-Path: <SRS0=nADd=5B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9018C18E5B
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 13:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9411820663
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Mar 2020 13:31:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="MHk2U6Rq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731330AbgCPNby (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:31:54 -0400
Received: from mail-mw2nam10on2124.outbound.protection.outlook.com ([40.107.94.124]:13889
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731193AbgCPNby (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Mar 2020 09:31:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVIQhH29DzPhMn44oAtYDQJlf57DwEyz8CK2IugtOR9J0/uFu6WVFUP2L1ks1OMF9lHdAT7pKbyWdi2SMWVsF1ORgWkyYPKG2yzfl3MQHg1nZT6G5XZLuGgDzQS22MdsevIKyfFC/W8WUWFhGqwVBZSENBrW3EKUPUnxDXikyuu593JATgkubW8puHHFqvMVwjjwVbNDtLl/MC2DN21VOiH8+PzVWZbJUTvW/MAEWwXLBcPQVyQ3oE6iG04ShYi1DQAMpzt40Tec8NHW/vAV4S6cqeSMX7qFgIrxJPy2Rc9uAslNkTK0IYawrNNPWYQe9gb5nabJEmslX7GgpD79gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnrvfiaqG02l8c88xKtoaV70GvjdkXiVAi0Z6W3JqjQ=;
 b=DzbilITA+Hyxb8wAJ6UEWqg/lRXlANGU53+df1LV70sdAbtKKoiurLVA0nz27rl3XwQTF/3cgmFk6f3z5WfHA6U2YLZ/sBNIC78qB7LxXcwbT7jd820qmc/8vNdb/xAhKPVHEIj2WHcgetdF38rwRvfYbukQY+PVrt3NlcdPJcMFtQBf0F2sG9l5nEVP0aT+jW6mBeeyzsZYgRR43kRrXcxEOAd/oYLF0qpTWn9WyBhnPIvjn5RvCaZ7GkSdw68C95d4KVQVfjxPBYdt/m/qle1BBaPROXN1mFkoy2aYhb0740isDloRGXiR4ph+x31J9iIBLXbUq7/PBK85PqRYsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnrvfiaqG02l8c88xKtoaV70GvjdkXiVAi0Z6W3JqjQ=;
 b=MHk2U6RqElJNsXj0rTaexdFEiMdIpyS2TAFaeAOixLWy9TYTiyWF2Q1zK8R7LCSfaUvSaTZbYGFRg8QvxUhWy3MlkO8hGaB0nOAarEz4u1B7dqXZhMV5ci0sqrdQFPQPJPhaaFwK90n1F1aCq+6W94wvKC6JLzPBcXqDMNn37V0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BYAPR11MB3496.namprd11.prod.outlook.com (2603:10b6:a03:8b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Mon, 16 Mar
 2020 13:31:46 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::dc9c:f877:efd1:401a]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::dc9c:f877:efd1:401a%4]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 13:31:46 +0000
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Nathaniel McCallum <npmccallum@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
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
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <7f9f2efe-e9af-44da-6719-040600f5b351@fortanix.com>
Date:   Mon, 16 Mar 2020 14:31:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050603020801070004040207"
X-ClientProxiedBy: AM0PR02CA0097.eurprd02.prod.outlook.com
 (2603:10a6:208:154::38) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:a210:a441:3083:da8f:6fb9:9677:3d38] (2a02:a210:a441:3083:da8f:6fb9:9677:3d38) by AM0PR02CA0097.eurprd02.prod.outlook.com (2603:10a6:208:154::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19 via Frontend Transport; Mon, 16 Mar 2020 13:31:40 +0000
X-Originating-IP: [2a02:a210:a441:3083:da8f:6fb9:9677:3d38]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88c34caa-f767-4ff4-61a8-08d7c9ae5f38
X-MS-TrafficTypeDiagnostic: BYAPR11MB3496:
X-Microsoft-Antispam-PRVS: <BYAPR11MB34962D815D2CD5D73DC5FABEAAF90@BYAPR11MB3496.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(136003)(39840400004)(396003)(199004)(31696002)(53546011)(31686004)(508600001)(86362001)(5660300002)(6486002)(52116002)(2906002)(316002)(235185007)(36756003)(8936002)(4326008)(8676002)(16526019)(54906003)(7416002)(81156014)(81166006)(6666004)(110136005)(2616005)(66476007)(33964004)(66946007)(66556008)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB3496;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/zPYx3DkX9ZGH5RqCXFSDvEJeDkzNxVfWFfOGPsDXULVKR25NeTvhbSfCCT3OiOBaeP6V9cwCFinIG3vAM4bKLwfshGPT4ddBvg1GQq6w4VJ/+bqOkytWOPESMZ0wWy8NTaB/XFKJfaQYbS7UxJbZYF3q0zk1OYZHN7gp2dP799/u5YcujfS8P57HqORJZRT6sYrZBQyx45cEgdaJW0Hd7a0JrQc4qhfdXFS0yahRd+3AndMA2PLAjKysTj2peVrVIwvuZIh8ewyIPCOwuevQlrm+F8kKiYCxJMSOARU6qcVLf+MsvhSRAGb3ehnFS8AZfmAtLV4D8ChiAv7N5yedmze5cG0ie3rdouq+hJ0Ch1B+w0tikZhDrwUvkQbF0xqlyClN9gTM/Kj/QmHmBksYN70Tz5hjQBBMBQIp4wRmNFIksOGEhIND7hfIMR8Rpl
X-MS-Exchange-AntiSpam-MessageData: 6Jem2qZ5R/+gqavBD99bjVAwtTh4zzy4bD5ow9UL4bIwf5XC1aFIkpXacuR0+01i7jK8p09u+422+t/ikAWF/CQKZru5PbqjiFqHrYV/B/Y3jyFnB7CrM2J85foCiQinAXwh0hoZ5iB4M8V2iGzRP5JYHTQV0TOyj3frrzxrWzYlWaxdSED0G//y8pXdWluMh/4U+VlSFlHf2DGfCaEmEA==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c34caa-f767-4ff4-61a8-08d7c9ae5f38
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2020 13:31:45.8575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kL7918jBZnIT3CJd5TN/nI6q20GlHDDB/XSLFLJr5WfBAKhuJxemqDqKLP1z2aWy7B1OXFdxAMH4Jh1VyL4R2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3496
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050603020801070004040207
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-03-15 18:53, Nathaniel McCallum wrote:
> On Sat, Mar 14, 2020 at 9:25 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
>>
>> On Wed, Mar 11, 2020 at 01:30:07PM -0400, Nathaniel McCallum wrote:
>>> Currently, the selftest has a wrapper around
>>> __vdso_sgx_enter_enclave() which preserves all x86-64 ABI callee-save=
d
>>> registers (CSRs), though it uses none of them. Then it calls this
>>> function which uses %rbx but preserves none of the CSRs. Then it jump=
s
>>> into an enclave which zeroes all these registers before returning.
>>> Thus:
>>>
>>>   1. wrapper saves all CSRs
>>>   2. wrapper repositions stack arguments
>>>   3. __vdso_sgx_enter_enclave() modifies, but does not save %rbx
>>>   4. selftest zeros all CSRs
>>>   5. wrapper loads all CSRs
>>>
>>> I'd like to propose instead that the enclave be responsible for savin=
g
>>> and restoring CSRs. So instead of the above we have:
>>>   1. __vdso_sgx_enter_enclave() saves %rbx
>>>   2. enclave saves CSRs
>>>   3. enclave loads CSRs
>>>   4. __vdso_sgx_enter_enclave() loads %rbx
>>>
>>> I know that lots of other stuff happens during enclave transitions,
>>> but at the very least we could reduce the number of instructions
>>> through this critical path.
>>
>> What Jethro said and also that it is a good general principle to cut
>> down the semantics of any vdso as minimal as possible.
>>
>> I.e. even if saving RBX would make somehow sense it *can* be left
>> out without loss in terms of what can be done with the vDSO.
>=20
> Please read the rest of the thread. Sean and I have hammered out some
> sensible and effective changes.

I'm not sure they're sensible? By departing from the ENCLU calling conven=
tion, both the VDSO and the wrapper become more complicated. The wrapper =
because now it needs to implement all kinds of logic for different behavi=
or depending on whether the VDSO is or isn't available.

I agree with Jarkko that everything should be kept small and simple. Call=
ing a couple extra instructions is going to have a negligible effect comp=
ared to the actual time EENTER/EEXIT take.=20

Can someone remind me why we're not passing TCS in RBX but on the stack?

--
Jethro Beekman | Fortanix


--------------ms050603020801070004040207
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
MBwGCSqGSIb3DQEJBTEPFw0yMDAzMTYxMzMxMzZaMC8GCSqGSIb3DQEJBDEiBCDFUclM3xeY
pXjOB1q6Wev7GTSer7cuSyIzhzGNXmJ3WDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAW0mbbh/fll3wP+4yZxXkdqb5+gJ3hb2dTaO5CfIuoZykp/AEp3GG6vVz
nl1vJepvyFLVsF7Ssa9Osi7BuwNpq7CKJGJx6v53jQgwEnUCb+0gS/+rSCZJTVee7Jvf/3Oi
U3Tab7Jv47lm0uyDva3wi56uXuW/Haw3fVHGsrDNN1Fu5RyBFNIhM87P4C/FPlDTYtbLH9T/
RNgAFyW31/VMpyVhsd/8HkwnRNTd3bUZypWGFuKNIxrsaW/4PnKQVumO0TAwU6dlFzgaUdJA
ZArmAFFS8YYWtx3f7LBTdGTBRjs8mZ8YrMAFljrsr3Od0J7T/rnZnsfYzrOV9cjDGlUWbwAA
AAAAAA==

--------------ms050603020801070004040207--
