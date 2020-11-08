Return-Path: <SRS0=Aco+=EO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14445C388F9
	for <linux-sgx@archiver.kernel.org>; Sun,  8 Nov 2020 20:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB45220731
	for <linux-sgx@archiver.kernel.org>; Sun,  8 Nov 2020 20:20:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="S9HKyrCr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgKHUUu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 8 Nov 2020 15:20:50 -0500
Received: from mail-dm6nam12on2131.outbound.protection.outlook.com ([40.107.243.131]:11905
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727570AbgKHUUu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 8 Nov 2020 15:20:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJMcMII5RqEa2JVoEkpLLR7rIvnUFDNw4HR4qZ9/dvA1UvscoraJh8FrORc+PZFaEhP0NFkgtFEHlJPAQ+Qb5vJ9t6wrJVUlvmZ1Q0mvhBCo5Q2l7B+JwUcTT/Dbixvjpr5gHel8XG4QKSBzexPMzB0Y8TDUSiJde/3f9pSeb/N69lnSzU6+34suj379BrHIgFTjBYQopNEI4BzotASNvGZ4jBU49rENPBdYGcqShLOfBa4k+bGL0F88ukj77k73u7Cec9G6+wg/1SR5/Y/Nczd36GlyYMJdkRvvjkQj4OPW3085Ql6MJPjp2hZPTqzWbYFbN7PP3E0r8EfBQWdxog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35njGz+MPNWb3vB2nlan+jdTcdhf1TW8aO/cijr26gY=;
 b=a12vn77tZZamI7BOohj5ekuTxHgFtWc6JaX551qe/EULNrJVO9SI0/odAl40AHoqqzgD+K0j2nvWaWwqho5l1MIBMMcxzQbXpzCXE+ukYr7duw+gDwknuadYkUNdfNMAiqs6GZrIXTTvp7akwz17pnT/XKQWhzjRuAxk7fTWwCwDgbB20eSC63hItz5QxDc+17sU/3vwFvWAtT2MTvhOOrMSZS9DjYq3cUveQQ37l9jH2tzyJzAC417SrF4SZ+PjE+xG2JlmiEDi+7xg5mEh6s7RR1gVKv6jmzvjaS9hscNcjaTGsikLjDmSxp5pDuqDNX4V1TYP+HLiMYJeqvjlSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35njGz+MPNWb3vB2nlan+jdTcdhf1TW8aO/cijr26gY=;
 b=S9HKyrCrMgxwNrqr7q/7L+PrpumhapAHgM1xMDGVZOKqPWw/fBbDtL353ofYdBJqh14+BPYaoAY0MYRmwyo3nWZ1WO2/nESWjjowzgZsfHBp5tj1i4p4TTFbU+ntzwRosyOlQ2r85q4JxYfKSGe6NP6+Ps+wKyg9Y+ZIZbFPmLg=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fortanix.com;
Received: from CH2PR11MB4262.namprd11.prod.outlook.com (2603:10b6:610:42::13)
 by CH2PR11MB4343.namprd11.prod.outlook.com (2603:10b6:610:3e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Sun, 8 Nov
 2020 20:20:45 +0000
Received: from CH2PR11MB4262.namprd11.prod.outlook.com
 ([fe80::c4d:afdf:4dfe:2706]) by CH2PR11MB4262.namprd11.prod.outlook.com
 ([fe80::c4d:afdf:4dfe:2706%4]) with mapi id 15.20.3499.032; Sun, 8 Nov 2020
 20:20:45 +0000
Subject: Re: [PATCH v40 19/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
 <20201104145430.300542-20-jarkko.sakkinen@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <c62851f0-c4fe-cc61-4e97-8e614b72e47d@fortanix.com>
Date:   Sun, 8 Nov 2020 21:20:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201104145430.300542-20-jarkko.sakkinen@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020202050902090705010100"
X-Originating-IP: [213.127.125.17]
X-ClientProxiedBy: AM0PR03CA0047.eurprd03.prod.outlook.com (2603:10a6:208::24)
 To CH2PR11MB4262.namprd11.prod.outlook.com (2603:10b6:610:42::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.125.17) by AM0PR03CA0047.eurprd03.prod.outlook.com (2603:10a6:208::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Sun, 8 Nov 2020 20:20:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de758f28-0e2c-4467-6463-08d88423c606
X-MS-TrafficTypeDiagnostic: CH2PR11MB4343:
X-Microsoft-Antispam-PRVS: <CH2PR11MB4343298F08060392F3A0B978AAEB0@CH2PR11MB4343.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3/SKiK86LbS+0C3YNHI8jrS6PmwZhf5kyEBAPkUQFmZvHog/2UQ97An3OjeSBVO4QWGknbdyChrQJGv5uWIDiQ2xwGELKKnUxJw2Al2pYka4tYCEo+YMSWbplyneqltJl4Oc4hq/4/ibuc3G5zSF8jRdWBroOogMyOBzcyOL98HhLdBqAahpPNVLXQc00KIiJtoEaPHhNLddUqPbr8egiqQUmLyHhVJ+RHVSqBEf62/L/ee0kicEP3vqhDQcOiznP52YOdGc4FRs9Uye8bzmuZiV6c0SQO6y84YOpyl/2wWqWdNhATVkwQeLQsw6B30PWQdVyOdu1BwBVpQrnxg1uhziqC3EEDHrGk+hd6YG6Efo0xx5amW6ma88iyexnj+R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR11MB4262.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39830400003)(346002)(136003)(366004)(956004)(6486002)(8936002)(5660300002)(8676002)(2906002)(83380400001)(66946007)(66556008)(7416002)(235185007)(33964004)(52116002)(2616005)(66476007)(478600001)(6666004)(31696002)(186003)(86362001)(26005)(36756003)(4326008)(53546011)(31686004)(316002)(16576012)(54906003)(16526019)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: o7kN+3bWEhHGQxWxzSgg4ISTf0g7BnrHfS9Qv0uX9aDktmfWBCT+FqifdxVKzrKnU1lWsgdXnH49MJaFbjdbTv4srdbUXEYtcuc5qz6rDXO3T63ELDDi0R8VtA6ZGa7xD4Bp8Ld+P9TEcKeUDK/Bd2K12NnQTty3gZh78qXK2IIpoBstcXCZ8aTrwgzE4RmOrt02izpQ+SiIGEaUdP0CIozb5pPztaRZD4DcvWZPxbzWXVNJE9/Vw9lmHhZs2fcuiimC4montpnj9BvQmEYKN+oChx5KyJhclGUwWrrf9aM2+ZD3qcXP28M9eO9cNNkmHjJkSDVPCdEkF5JGUwYzIU3YChT8JVEpudIvhmQ2WwfLDoIF2laPjKXvahJvttB6ig2uC+OjRv3FtxWsJGtGMaUsrkZ5fpFbYbUMqfhB2PMmjaus2qyCgSJYbgIe8XUYlm18gzOSJ04VTC80A3D2IR3SaiOQMqU0a//lOdzusFfmXh9NUfBsh9oXtZH+g0eerB7gWMhT5Gxfv5Nzhz5vJ6ETATi3sRpFAp0yBvEe02+hejFKV+/b6aXQPu0WbNBgfd+66hmTSY6+Yd2wCIcebvjtNTXChv2X60OY29eouY0zyUti9HpRrOVDdElwVjxAH9ug1gIma7T+IHqOQkHQ+Q==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de758f28-0e2c-4467-6463-08d88423c606
X-MS-Exchange-CrossTenant-AuthSource: CH2PR11MB4262.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2020 20:20:45.5823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YixjljXA4K+i5cpDMnEJVMI0t99bHZ+gum6L74zOmgNHwBBhljrN29y4mE8cO1+8q1olAltgcnZjveZXhiAmvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4343
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms020202050902090705010100
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-11-04 15:54, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> Enclaves encounter exceptions for lots of reasons: everything from encl=
ave
> page faults to NULL pointer dereferences, to system calls that must be
> =E2=80=9Cproxied=E2=80=9D to the kernel from outside the enclave.
>=20
> In addition to the code contained inside an enclave, there is also
> supporting code outside the enclave called an =E2=80=9CSGX runtime=E2=80=
=9D, which is
> virtually always implemented inside a shared library.  The runtime help=
s
> build the enclave and handles things like *re*building the enclave if i=
t
> got destroyed by something like a suspend/resume cycle.
>=20
> The rebuilding has traditionally been handled in SIGSEGV handlers,
> registered by the library.  But, being process-wide, shared state, sign=
al
> handling and shared libraries do not mix well.
>=20
> Introduce a vDSO function call that wraps the enclave entry functions
> (EENTER/ERESUME functions of the ENCLU instruciton) and returns informa=
tion
> about any exceptions to the caller in the SGX runtime.
>=20
> Instead of generating a signal, the kernel places exception information=
 in
> RDI, RSI and RDX. The kernel-provided userspace portion of the vDSO han=
dler
> will place this information in a user-provided buffer or trigger a
> user-provided callback at the time of the exception.
>=20
> The vDSO function calling convention uses the standard RDI RSI, RDX, RC=
X,
> R8 and R9 registers.  This makes it possible to declare the vDSO as a C=

> prototype, but other than that there is no specific support for SystemV=

> ABI. Things like storing XSAVE are the responsibility of the enclave an=
d
> the runtime.

I suppose this may be covered under "no specific support for SystemV ABI"=
 but with sgx_enclave_run.user_handler=3DNULL, R12~R15 *will* get clobber=
ed when __vdso_sgx_enter_enclave returns from an SGX AEX. IMO this makes =
the whole "try to be like System V ABI" rather useless, but I suppose it =
doesn't matter too much.

--
Jethro Beekman | Fortanix


--------------ms020202050902090705010100
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDgyMDIwMzdaMC8GCSqGSIb3DQEJBDEiBCAU
XRNrVFQTYj2LEE/n2yz+coJjsfcJypjJwAS47PiVTzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAGenVb6v8tYEi9Dh4hAbRrBis0ag9SZJD0GfNk229a6pCPIEHYlc
Bi4lMoWArSvL85clTR+l+4pdIZFZ983wDTki4l3jVfjkIVixHjiAZqHj3lqXYc4DnBSgGGQe
/9sXgr/HEJPTTevybrnqf2dtNDgYpdpLdRHJvoVAGCVQDH0m5pxO8+Y60DvqgYT0nbvkjVB7
0XRpLyELHAqmhHyyjVL2pdkkxbFTbrpwbDWn7W6E69wLfYXFp++2Hc7RsBS9d/C+R3r9JpnN
mg5sgYoKxK7euUDV9sPkXFrRDny/XNZSzN7qZ1h7+v7nT1/r65sAm3FrQlHPUjKy8w/dvc7i
76cAAAAAAAA=

--------------ms020202050902090705010100--
