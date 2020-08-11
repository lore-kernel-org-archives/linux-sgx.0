Return-Path: <SRS0=Le6A=BV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDDFC433E0
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Aug 2020 07:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84FAC20774
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Aug 2020 07:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="HglVHxhh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgHKHQp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Aug 2020 03:16:45 -0400
Received: from mail-bn7nam10on2099.outbound.protection.outlook.com ([40.107.92.99]:23425
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726397AbgHKHQo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Aug 2020 03:16:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dcr4m/7QGuzimGuavmblvi+rsMT4meFR6FynX1PsLQA++oIQv/DFwQqYMOisqjBq2nOCORpjpf0fQTjHqshPrdPCz5hVkCvzhPFG6hbrzZglfVCH95YDwAWgudUGMuZX5Rgqoy5Fc4tCr6qPv38PYxaK0Vcj4e+Whv98tOR+1qOmSwda1qhugkyulm0CT43RevlJYqfg0Bm24DsYhVzTL/gKTjari8BFT8mf/xUQ3Rv0bsD1R4COPOrdcq1DGuG11QR22HUgSOAYMEWI2Ly9KzfZiR12uEPOOZtkp8hjhsrLrKA1ZNDr5O5NsiwGf+Y2N3RWG2AuxmZcR1w8hVy/8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7VIaKamPFl/3nIlaPJu5aF+YmMSq8jJo0FZkqz5dRo=;
 b=As83dQBhMsfaU/N7+nIH1qlxdz30rANcb9MvcoZzQczEwTu8JJnhsGP9ehPxknsNemUhZMUgRUZQoR/WdOoYocW2Yy7a1m4aO7TNqMljXbQSNE7R1JQ+DJmxO0iZoeVVKMQMvPJ1CtYaWgGTitc+6NJFrDEHyqeNuVjQH9egKstq2MTpGqAzglOokA7I3et7O75AFoeJ6A2xNQKFdsnBe6JzO443KvxxU9Hvq9ck3nDk14UCBnDYtuHS2euGUY1m9hhteMafUloesqK2fCc2mdgEiAufeUwrj/6UDnmfyPjcp43p2q4y0s6GzjyoydJIQfb1DniBJjxRcdc8pwYJYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7VIaKamPFl/3nIlaPJu5aF+YmMSq8jJo0FZkqz5dRo=;
 b=HglVHxhhPvIObjIK6X8xgg1mnXNM0974q1a02n8GPztPD3PMl5gIGLXZWJ7HD41fd+ccgM457cihZASx64gtfiMASef0vvOTNNF3M1qePR7C7vqGS9mOboyjHs3gwZIuhJre1072GVzPdAO5TxPrYrDZFTW6HA2u2v5Tf96adFo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3560.namprd11.prod.outlook.com (2603:10b6:a03:f8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Tue, 11 Aug
 2020 07:16:39 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::7d6c:d61b:95de:2f7c]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::7d6c:d61b:95de:2f7c%6]) with mapi id 15.20.3261.024; Tue, 11 Aug 2020
 07:16:39 +0000
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>, kai.huang@intel.com,
        "Svahn, Kai" <kai.svahn@intel.com>, kmoy@google.com,
        ludloff@google.com, luto@kernel.org,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
 <20200810222317.GG14724@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <78ba0baf-8ffa-7221-4ac1-007dd9e7eb20@fortanix.com>
Date:   Tue, 11 Aug 2020 09:16:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200810222317.GG14724@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060609020707000509080703"
X-ClientProxiedBy: LO2P265CA0055.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::19) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.195.0.246] (212.61.132.179) by LO2P265CA0055.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:60::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Tue, 11 Aug 2020 07:16:32 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8fce881-87a7-4ab3-4752-08d83dc67d2c
X-MS-TrafficTypeDiagnostic: BYAPR11MB3560:
X-Microsoft-Antispam-PRVS: <BYAPR11MB356083787160B4CD2DF5300BAA450@BYAPR11MB3560.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Boa5kVwROyOpMIzfDSnfEozaRtRt9fpqssRQ3gb4UBJvyOUTe6g5pEijdyWmjdNEiUIS8VOQUom0nB4KN+pdq379nohuKK1ymfYgC/GqLLxItJv7/QdUbv4qSnM5pxN3Ym1GhhIW3RNXTpgaAZ65dmQyUyLSPJdR7Wy0OHXSgLG/cZObkxlS0K5/7ofz2kvQAL1J56qg6qxN1iRPcHN0xxMRblWDqORTFV8h8KYwrcDBpIshRysePyD8Mk+/Euldwzlq9n2WhF4LX2l8aynAp1ycvkanG7GeHYranfXeU490elmYpGG5U1cRCLHs632n71r2ESMafQFPTPyzolMHUqw0jgawjolYVDSpFdxKV9r7KTHQiPEYYJxdXTYXmcdt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39840400004)(366004)(346002)(136003)(396003)(8676002)(83380400001)(66556008)(66946007)(66476007)(33964004)(6486002)(31686004)(52116002)(36756003)(86362001)(4326008)(16526019)(2616005)(6666004)(53546011)(508600001)(235185007)(5660300002)(31696002)(7416002)(2906002)(16576012)(316002)(110136005)(26005)(956004)(54906003)(186003)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lesJvYX+vqmUnFeaXhQQwqnkB0IyB2QeS3w1uDoXXVtEpQkfn7VTcoGyETmy4ATdFdm+W9fmuHeIBkmW3L4J3JNzX84T1dwGKPNIv3fHuA7vUChXu+RVAwLFV2sCyoMSCv9SS6k32I9/CjncX29TTFBYKmmHigdpxbKbF+fy0q0xte2C+ndWCIhyEr6BDyBoYIkhWFGzoTd3OlDEsZ+tVaBlX0ZUqp9/07W0YFF3bNDB/h1OuDEArG7zJa9pnVMPC03KPMsdpqQ4ajZlv8V5k1wGT6ZhJJFzK7Xrx5TcpMDJsUFnmmKsxAbaYB4RUvKfVYG1AZ3WEz4kVO6Bm1D+mcGUmFkeuIUr6377rmz0wPd0p/pEBnTa7NlvNzw6Auxtj4f6Y9+UJz+gK/btZrwL04FgmGvwK/r+zhD8MT4r25R5ejCFoxE4keBaziGUIP4GYIGavKghvNHXYXRiYmWId5w7l1cFkUirsLgsOYUfjQ9UpkRa4zIYh+B1eHgQZk8syIPxSw+5oSLariD3SrKVvUpFMwabPKZi6B6HcTR5GJw0YviOkwdcs0ImYK1DnYWtoeoxFTJMB3oZVKSj56nekuv2V1CMdw+x9N6Dy5f6jkV08no97M/5HRAAUmREo3gLtjTUh6KdLzCcftKIbVjo2g==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8fce881-87a7-4ab3-4752-08d83dc67d2c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2020 07:16:38.9855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5pj6dmeex3nnq6PODCCv/ZIHyyeNN4tmy5UJJ4K2UbLFFexEVwA2J9vzc6g67HdZMb5jvzEbhyDc5hksKSByKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3560
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms060609020707000509080703
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-11 00:23, Sean Christopherson wrote:
> Another thought would be to wrap sgx_enclave_exception in a struct to g=
ive
> room for supporting additional exit information (if such a thing ever p=
ops
> up) and to allow the caller to opt in to select behavior, e.g. Jethro's=

> request to invoke the exit handler on IRQ exits.  This is basically the=

> equivalent of "struct kvm_run", minus the vCPU/enclave state.

Actually, the flag I need is =E2=80=9Creturn from the vdso on IRQ exits=E2=
=80=9D (See Andy's email about preferring returns over callbacks). But ma=
ybe the flag should be =E2=80=9Cinterpret IRQ exit as a normal exit=E2=80=
=9D and let it be handled the same as any other exit based on whether an =
exit handler fnptr was passed or not.

--
Jethro Beekman | Fortanix




--------------ms060609020707000509080703
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MTEwNzE2MjhaMC8GCSqGSIb3DQEJBDEiBCC5KPysMOy7
QmNgDjOcs0EpEpW0RuxAySwJJbuF/NcJLjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAbAFtBn/88wswtv2XfUN7gdlUx6JWmza0SqwJc11TRvfdKNq05zMiGuWX
VqCey/uTQkgSE9ztBK/MrRbhTQrT4fZKkA55YZEFPkRStLPApLY3tj4VpIjoNbcwjY4AcP9X
QnzhJmFSc5encsL24qmt9imlscQBRu0vG0gsmi8EMvHPmbFPBLppn5hUm4MVeUj/X7LYwELe
F85eIgb+KoSwha3I2kP9jCkMXqioz3hhYSJScGsV1B6tq0otFIvA7tn6N01ZvZipDcDnoS8c
0HfVtXcjK1cuXJ+8JSS1h+/fultW3BE1hpgk9aAjuU8bmfEn/aooyIewzNE21NWGfBoIEQAA
AAAAAA==

--------------ms060609020707000509080703--
