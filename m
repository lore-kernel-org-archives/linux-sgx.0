Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DB3C4363D
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 11:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CFC82083B
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 11:44:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="yVDzkngt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgIYLoE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 07:44:04 -0400
Received: from mail-co1nam11on2119.outbound.protection.outlook.com ([40.107.220.119]:31073
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726368AbgIYLoE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Sep 2020 07:44:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeYGMlPScUWGWRZ+8pORns/FTkqEgE4Iiqs7NOMejK/JCGKEKUBGp61etKpGkQWFbp+hZZEzIESQrmZOXh3nYoqNt+mKmgyI0CCCM+GEyl+yUBzbFFTtaNyM/6iPEvQYUQGQJ2gNRzxHiknid9/w3b9DwezUnkke3YjtB99v+c8i8e5MkPVB2uC7TP87mOT53pONvPJ3rEtSngJQMtrF8fMWP2M3WxeUGHu90Bt+WBeJAMEosOkmQW4QmG3HRo8OGuzNKfZ7oCd6bBdYB4Z1Xa6ris/5/QY+IrhzmVbnSz27OX6KNo4vwr5PsBUVt/eaS5ZV7m8/RZoLsyQEq0nP8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YZKPoXad1rogMWnZ0rVrA+0M/+5XrAu91apF0nCf3k=;
 b=mjWDszf37RvVCicM9jjLzxbIIUr9AofwHv8a72e21p7aGz89OM1ILyFwXG4VIBpElr5Yx7p5cxKPQGb8+yarROv37+mPDSsaedHKQf/F5A0bsHB0nJ5p+n+oZk8iA+QxY0nhu0uiAljE58XhiwOcEFoLEOMr/4fKdDGj9A2GG+pVptdClZ8aiKcpIrsxO+bqUZh0SiU2AToXDPyLSuQjH+a5SdM/8CRtaqs+die1uyJa01TvDszWPReZn2q2c5byVX7fenJ3If78dCtRersMRVtsCcA/TPrzmlqpDccseLbCGLA9jaVRjiEZl9eeOteJFv18tS+RZWTRQlBED4DaBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YZKPoXad1rogMWnZ0rVrA+0M/+5XrAu91apF0nCf3k=;
 b=yVDzkngtRKdNXrO4aJfNvj6a1xw+yGBMcEpU0pyqtnAylYulc/vqx+SpilUvCCxezzd4Q2BdTUviCvv/ynIAXUFhXWhXJQqpcpyRVqcSmMSkwFaptu1fkJU8y32fUqJvtdOLgcrswBp5CNdoQGKhwplFrsqRjajujDUfMU7EjX0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3606.namprd11.prod.outlook.com (2603:10b6:a03:b5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Fri, 25 Sep
 2020 11:43:59 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 11:43:59 +0000
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-22-jarkko.sakkinen@linux.intel.com>
 <20200924180407.GO5030@zn.tnic> <20200925010031.GH119995@linux.intel.com>
 <bf65f1f7-f91b-721c-90c5-064df152f710@fortanix.com>
 <20200925111713.GD180915@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <124bfd37-2f1f-d1c7-88aa-5f325878f69a@fortanix.com>
Date:   Fri, 25 Sep 2020 13:43:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200925111713.GD180915@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080808000003010706040207"
X-Originating-IP: [213.127.124.128]
X-ClientProxiedBy: AM4PR0202CA0001.eurprd02.prod.outlook.com
 (2603:10a6:200:89::11) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.128) by AM4PR0202CA0001.eurprd02.prod.outlook.com (2603:10a6:200:89::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 11:43:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62b23424-4e0c-4587-9873-08d861484a13
X-MS-TrafficTypeDiagnostic: BYAPR11MB3606:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3606EA3ED0E3AF15B7651967AA360@BYAPR11MB3606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RcMlSht4zPDRZBJGWFKla1zwP88BKLKujLya2L8V8gad+96UVT/57cybhKB+qbVPi90g2kDBH+6lILavrcl7b3iajxHqvFYQzfpiKht3EqwhM9vU1ufMKhykyA+35RvhbI8dxyP1C/UL1erYkIiVQgw7HOk1nKnXccJHQp1NKxHlpwheJuN7q/9Za712chLXucIRJCnfW9WYL9kRB1U1ZaQjo4XdhRXD3uEq5PDFVSizxhXymvMQrS1XbZZAuYPufFYVCJFNGeSC0Lhh7+QEDsrNaYxroTXTCCozh/G+p0Urxw5DF9NWZn9M+r8dDH/1XjRdFvj//uGs0r7fqZUb22HuX+JFGzDe0EHcZ5hm+DQ8n4GWUcpccteEYWlMft6JdkzmBTrU3/fBF2ld21y+rV88Gw0A8xgDDRGbTVYFTnzC7mR7S3pwrEwZMTdUNL2gdSY5ifyZLyJUhSaBzsm+TQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39840400004)(366004)(52116002)(33964004)(53546011)(31686004)(2906002)(316002)(16576012)(6916009)(54906003)(6486002)(66946007)(966005)(36756003)(7416002)(83380400001)(4326008)(66476007)(478600001)(8936002)(86362001)(8676002)(31696002)(956004)(26005)(2616005)(16526019)(6666004)(186003)(66556008)(5660300002)(235185007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: GR336/CspYG9086+01oREN6yTnKcRDO9jiS6RN0uuHFPE8iIH0LJt+lr7JR7n4He5lE9V/WnbXP3M7AHc8Kzjsfe9tNB1nUgVqslNyXRQJSviIiXYxwrZCJ9DTWDEKKI+vs3tL7eDS69KMg/yAHvHfBNF6Sn1Xw5J88F9Be19/lF7oACzRN2Nh19HfRDT0qGXmlHvx5KdRtmLODAJpnr0nGhuEn4GBUtBSsYigMeNde6wVHi8Jz22Y7XSBPM+1eiPfwQZWM/W5txKnh01gCfolN8zdS/RtG1Wv89kggbAqBs5Kxj6ojUwIqlVLkbw6YYP4qqWiGIfytkQ4IaMn69IOgqw79tFnmp9woYoFBOdpWf7EIkMem3Sv+qFMNY00xNjOrr9G++3xB3MSKGaBdpKLfaqG/0PVFAPgp6EugTBtxfeOH2ZcwvnjQjl69Zd4nSvq1nEMZw2on0xCRECBshNA0CvERo5xJIUUNqfA0zXicMuye6Am3ZUL1aK6bgPwlRWX0z3ZGp9BtdY6pbYPvY0RqbrPxwx1r30UxZH8sgCjD4OyZxnYoU6clLmW4Csx55JBVz/RYu8PTTqUTNidxURf0KKIBvtz5IEekVA41UqCGD4dbY3momLEgIMNARUy91WVtiYYgFkL1sqiQWcL8Gcw==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b23424-4e0c-4587-9873-08d861484a13
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 11:43:59.0007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kk4okYbu+x6eGDt6ly8kRdmDUr7uilYlLSm5ShpF3hwcmO+G7bG/yOnjNJD9TuuQITO2JQmOXgUILeyKDDK1mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3606
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080808000003010706040207
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-09-25 13:17, Jarkko Sakkinen wrote:
> On Fri, Sep 25, 2020 at 10:39:58AM +0200, Jethro Beekman wrote:
>> On 2020-09-25 03:00, Jarkko Sakkinen wrote:
>>> End result:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git/=
tree/arch/x86/include/uapi/asm/sgx.h
>>>
>>> I'm wondering this sentence:
>>>
>>> "The calling convention is custom and does not follow System V x86-64=
 ABI."
>>>
>>> AFAIK, now the vDSO is fully C-callable but waiting for feedback befo=
re
>>> removing it.
>>
>> It's C-callable *iff your enclave follows the System V x86-64 ABI*. In=

>> addition, all registers not clobbered by the SGX ISA are passed to the=

>> enclave, not just those specified as parameter passing registers in
>> the ABI. This is intentional to make the vDSO function usable in
>> applications that use the current flexibility of ENCLU.
>=20
> Hold on, I really want to fix this bit of documentation before sending
> any new version, so I'll explain how I understand it.
>=20
> I think it is just SystemV ABI call with six parameters in the usual
> GPRs (rdi, rsi, rdx, rcx, r8, r9).
>=20
> I'm looking at vdso_sgx_enter_enclave.
>=20
> What I'm not getting?

This can't be observed from looking at the code in vdso_sgx_enter_enclave=
, because what makes this "custom" is the absence of code or code in the =
enclave.

If you call vdso_sgx_enter_enclave() from C but your enclave doesn't resp=
ect the ABI (for example, it clobbers callee-saved registers), your code =
will break. But if you call vdso_sgx_enter_enclave from assembly, you can=
 use enclaves with any ABI as long as your assembly and the enclave agree=
 on that ABI.

Alternatively, when using assembly, I can pass stuff to the enclave in re=
gisters besides rdi, rsi, rdx, rcx, r8, r9, just as if I were manually ca=
lling ENCLU from assembly.

The vDSO assembly has been carefully written to support both scenarios by=
 only using rax, rbx, rcx, rbp, rsp and passing rdi, rsi, rdx, r8, r9 (an=
d everything else).

> + * NOTE: __vdso_sgx_enter_enclave() does not ensure full compliance wi=
th the
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
> + *
> + * All general purpose registers except RAX, RBX and RCX are passed as=
-is to
> + * the enclave.  RAX, RBX and RCX are consumed by EENTER and ERESUME a=
nd are
> + * loaded with @leaf, asynchronous exit pointer, and @tcs respectively=
=2E

Perhaps this should be updated to read "All general purpose registers exc=
ept RAX, RBX, RCX, RBP and RSP ..."

--
Jethro Beekman | Fortanix


--------------ms080808000003010706040207
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
JTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJl
dm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVw
b3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUvpepqoS/gL8QU30JMvnh
LjIbz3cwDgYDVR0PAQH/BAQDAgEGMA0GCSqGSIb3DQEBCwUAA4ICAQAmm+cbWQ10sxID6edV
94SAhc1CwzthHFfHpuYS30gisWUfWpgp43Dg1XzG2in3VGV7XrzCCGZh4JM/XQWp+4oxmyV4
2Qjz9vc8GRksgo6X2nYObPYZzQjda9wxsCB38i4G3H33w8lf9sFvl0xm4ZXZ2s2bF/PdqvrK
0ZgvF51+MoIPnli/wJBw3p72xbk5Sb1MneSO3tZ293WFzDmz7tuGU0PfytYUkG7O6annGqbU
1I6CA6QVKUqeFLPodSODAFqJ3pimKD0vX9MuuSa0QinH7CkiPtZMD0mpwwzIsnSs3qOOl60t
IZQOTc0I6lCe1LLhrz7Q75J6nNL9N5zVwZ1I3o2Lb8Dt7BA13VFuZvZIzapUGV83R7pmSVaj
1Bik1nJ/R393e6mwppsT140KDVLh4Oenywmp2VpBDuEj9RgICAO0sibv8n379LbO7ARa0kw9
y9pggFzN2PAX25b7w0n9m78kpv3z3vW65rs6wl7E8VEHNfv8+cnb81dxN3C51KElz+l31zch
FTurD5HFEpyEhzO/fMS5AkweRJIzwozxNs7OL/S/SVTpJLJL1ukZ1lnHHX0d3xCzRy/5HqfK
3uiG22LPB5+RjNDobPAjAz2BKMfkF/+v0pzn8mqqkopQaJzEAbLbMpgQYHRCjvrUxxwjJyUF
b2Z+40UNtMF4MTK7zTGCA/MwggPvAgEBMIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwH
QmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBT
LnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBu
kmvE8GLB9+EYd88699DiMA0GCWCGSAFlAwQCAQUAoIICLTAYBgkqhkiG9w0BCQMxCwYJKoZI
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDA5MjUxMTQzNDdaMC8GCSqGSIb3DQEJBDEiBCBP
nthUzrNH9iSCPHRQQB6ISxpfV4q1XbRrgK15yKtWWzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBABIseEXJdeF66frikphHcP6p8QdL5qy+/uNAWknkMDSaFXyq/OrJ
oWbMBi5ZcmWzA+OfpsHB5Z18WALRuVb+dNL8+cp01tkcKF4NqvsBiNDQnH7M7LIWybwWygto
LFS2oOjcbmNNQPh/lgY7dWCeYKNG9gHlSldPieQ6pWeR19oj3V2WMfe1hUg1AygyCu/KQ4C0
aic+7N9S9KbSLUSDORxK2TCWn6KsnnFlnlEzlPbH3sVbEqGuU9dEbwWH7GpOx7ZxlAXclbNo
P4pI6BwR3oIohq6sG30wO9M8bfF65JbuBTpw2dN1/qb9zEKp2aJkL6/IYUkfZuRRlIaTpT4C
+PoAAAAAAAA=

--------------ms080808000003010706040207--
