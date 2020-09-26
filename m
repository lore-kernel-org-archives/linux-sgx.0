Return-Path: <SRS0=fqiI=DD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C4DC2D0A8
	for <linux-sgx@archiver.kernel.org>; Sat, 26 Sep 2020 09:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DB43238D6
	for <linux-sgx@archiver.kernel.org>; Sat, 26 Sep 2020 09:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="tvAhlBC3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIZJ15 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 26 Sep 2020 05:27:57 -0400
Received: from mail-bn8nam12on2125.outbound.protection.outlook.com ([40.107.237.125]:14560
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725208AbgIZJ14 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 26 Sep 2020 05:27:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZgcc5ddEsQf8ZBNesrr6vA5gLmeaIvOciO7f9/vhtkcQQhzAkWqkkhAmXxbDVa7RfD9P0lKTuUXG90MdvDOit9DwdMNzoGTzW3LDfdSr3yA34RFPfy6RVSSUG4WQYJ4CdgNJQCBDiayCVrujZ+y8g66HGXoAFy+QFlygz08A5R7ab/NovuG2zCyaGCRBdWaHBYN+lAKkJZ6AIrnIulKvgOGijy8qtIW+Av2GQng/6RNHUrAjY+HR6EsNTppk7Rasq+qnGxJYEp4ICL4RcgxwdmpsRrirgay55DEsSPLfVfYG4d3oIkwjLSO4uFsNlLlGCeUQrjl14CS1aNiZ/RBYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unpoks5D0LFL97heDu2IhpoHgTCqCjRnBzKNWCorJyI=;
 b=hpXa1SYbBD40GMrc4IV5eiEw13NuO42zKW2XQl56DXnmyesg25y1a6J7f79YT9TevkJ2aEF1TF0YITv5qT6GYtb38m/XETI0ADGhjTtojqDHAw/tmhRCjnFspN5Ukh9meF+oab5lkDJuC+wrWh/lOhsqD4+o6595Bc5/HNp84MisG3PI6/SI/cJuYxn3/Jrc/a4+2nt4TI0YHFfCFdPwl4U2VXQEFKZXXJaXMBCHzopjQA1kBgehT632Mx9BqFLFmYUfQgY8DGXk7po2YT7wE0TVBTWgbEW38Fxs3ZhscTyxxO+KPR2ZjhWRrnhWMZZH+TFXOxGwgFqZnIT33tvY9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unpoks5D0LFL97heDu2IhpoHgTCqCjRnBzKNWCorJyI=;
 b=tvAhlBC3LVwj268G8zHlfs+N/85u31gA3JJ68r6sC/VOxxDUaOMHB/JfBehBbTzUjPHJpL4GU029qopkOEsc+d58CHmYnte/SZc+u7ucSL1CTMYFieECHAFbQYAFtbAVVA1iP/Jyd1dcQ9nrFVx0g3rAc5k7ylIjnPmWEsl2NpE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3191.namprd11.prod.outlook.com (2603:10b6:a03:79::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Sat, 26 Sep
 2020 09:27:49 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3412.026; Sat, 26 Sep 2020
 09:27:49 +0000
Subject: Re: Can we credibly make vdso_sgx_enter_enclave() pleasant to use?
To:     Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
References: <CALCETrUhQjQQa-BqNHPgdDfD9GDJZXJWSQ_M0tDF_ri5RfyTsw@mail.gmail.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <8bd230a4-1199-4305-6e47-d2dff6245f9f@fortanix.com>
Date:   Sat, 26 Sep 2020 11:27:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALCETrUhQjQQa-BqNHPgdDfD9GDJZXJWSQ_M0tDF_ri5RfyTsw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050306050400050507020105"
X-Originating-IP: [213.127.124.128]
X-ClientProxiedBy: AM0PR10CA0047.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::27) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.128) by AM0PR10CA0047.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23 via Frontend Transport; Sat, 26 Sep 2020 09:27:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adc81672-d5c0-4e3d-4219-08d861fe6f1a
X-MS-TrafficTypeDiagnostic: BYAPR11MB3191:
X-Microsoft-Antispam-PRVS: <BYAPR11MB319132BA3882C3F995A53399AA370@BYAPR11MB3191.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+e190QXDP4vJJ28FPDx6FqOI/dhDn336ww6yDCxPInfMa4ijfgogbeemvVWvpQTM/MZA4yMCCjpfrO5WlcjqJBS0zS/kS6CnYtXIsw82g3l6lC+Rl7FS115vGOmiu2sk/f/D1MTuNqnWEC8hq4CjALVdStylldZ/BxncO87MuCs5u98ZYfWdTQs3xHsotNgka/BsNev89EcmTgcqqOgCLCuiA30somZzOPPdIvJgq0T0bm6wszx2Is+D/MzhNSQbmk7SoFCBj+6wc73eiz1d6CUvA05Ue8SYVDaH8Ucbl5Fak1mvnWaeajOZctaJ2+mgWaVvbBnaaU29ZolpsfN9S6gWKDSWVbqjQ0wbxUOLHoMd2ATB+99REASTXCqs6HLvvbbxvOgjrHY71xbhSiu/YGCIkTzF2iU9gLc2Q1u27p/6zHFO29kaOQ9ixUeKcwt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39840400004)(66556008)(66476007)(6486002)(186003)(31686004)(2906002)(478600001)(31696002)(5660300002)(86362001)(6666004)(956004)(2616005)(16526019)(235185007)(16576012)(110136005)(316002)(8936002)(53546011)(66946007)(8676002)(26005)(33964004)(36756003)(52116002)(83380400001)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jCc98+FPeIDdXsJUJkp0Wuz+nO8tieW0JVHN0O1+Ovo1kKQBfwei6fgsEV0P159sBipU1/5/F5wYnRjAHKTTS4YfoSCXIMkceohcX1E9eMegSlIKUbMw6HnLmK2WPzqLudO+An0CZ5w3YQ7z5jot1US3IX+IO44mL+pBzLQkVYJxsJxRDgrRUZ8hqFRsPSlPw7qBdYImK91oOpkFR2bNEzEmb0PrhGc2wXtVWejf8zCGC2VyYzjCmAazHh+EK8Im7FKgPVftN2ygqaVobpwjJIoIIeNKS4/Oy2MMLnusJN7y+Ix3hphChz8+sXYpz31FWGtLcsFcrGOsJx+DYlvCUkixVrUm2gqASTAedmT7HlWTqiKTZJ7qT274NtkXW60n8rGWO853/UUpUTHG1cGJaLaRjbKn2MSeOQiRUCvAchY6HOLcX2TElj23DRvyykUYb8nFT+VgjDgwlVkjpaaiUuGzJI6+dWqe9bIArDlZNzWKoGg1yNyDIA3r3Eo6nMN2M65wZXoXRsQpU165l+RxJBrKdyeksB04viHxnlu0lGIh+TTduFq3TaSKX7/xSiphqwIdq123KfKNnCPx7svL8sZ2dwoXo7bA7jPU0bkK5vbpPyCylftSdC5i0kjZA7Gf4mGtpCsdTyScqF/O3uSsBQ==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adc81672-d5c0-4e3d-4219-08d861fe6f1a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 09:27:48.8323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ig2cl3rAaVMXKuyEe1jFpFKg/7ZHoIf2IsqeHHVrLjFPMe9gyQHkR9YoYam20pflS6VTLe8/+j5m81VUZivKxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3191
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050306050400050507020105
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-09-25 18:55, Andy Lutomirski wrote:
> vdso_sgx_enter_enclave() sucks. I don't think anyone seriously likes
> it, but maybe it's the best we can do.

I don't agree that it sucks. I think it's pretty good. My goal is to 1) s=
upport existing enclaves and 2) have it as close to ENCLU as possible. Go=
al 2 since I want to use it in cross-platform code and other platforms do=
n't have this kind of call, so I'm forced to use assembly anyway.

The only concerns I have are that I need 256 bytes of memory (but I can p=
ut that on the stack I suppose) and the automatic restarting, but I've ag=
reed to postpone the latter issue post-merge.

Now I'm speaking from a perspective of someone who's not planning to use =
the callback/user stack, so perhaps people using those features might thi=
nk the current implementation is not that great.

>=20
> I'm wondering if it's worth trying to do better.  Here's what I'd like
> if I could wave a magic wand:
>=20
> struct sgx_enclave_run {
>        __u64 tcs;
>        __u32 flags;
>        __u32 exit_reason;
>=20
>     /*
>      * These values are exposed to the enclave on entry, and the values=

>      * left behind by the enclave are returned here.
>      * Some enclaves might write to memory pointed to by rsp.
>      */
>        __u64 rsp, rbp, r8, r9, r10, r11, r12, r13, r14, r15;
>        /* Maybe other regs too? */

I think it's fine to add a mechanism to pass rsp & rbp, and I support inn=
ovation in this space. But we should aim to keep the other register passi=
ng as close as possible to the instruction/what the current implementatio=
n does. For the other state, it certainly encompasses more than just the =
16 GPRs. There's also rflags, XMM, etc. Future processors might add even =
more state. Capturing all state in this structure seems unnecessary.

On 2020-09-25 21:09, Sean Christopherson wrote:
> For the code, given the constraints of SGX and the number of runtimes w=
e're
> enabling, I don't think it's bad at all.  It's not hard to maintain, th=
ere are
> no horrendous hacks, and it doesn't play games with the caller's state,=
 i.e.
> there's no additional magic required.  In other words, I really like th=
at we
> have in hand _works_, and works for a variety of runtimes and their ABI=
s.
>=20
> The API isn't glorious, but it's not awful either.

Yup.

On 2020-09-25 22:20, Andy Lutomirski wrote:
> On the other hand, if we had some confidence that the existing corpus
> of enclaves plays games with RSP but not RBP

Pretty sure this is the case.

> languages that aren't quite as C-like as C.  In a language with
> stackless coroutines or async/await or continuations or goroutines,
> this could all get quite awkward.  Sure, a really nice Rust or Go SGX
> untrusted runtime could just declare that it won't support enclaves
> that touch the stack, but that's a bit of an unfortunate restriction
> given that removing stack access from an existing enclave will
> inevitably change MRENCLAVE.

I can say with confidence that v38 proposal can be used by async Rust cod=
e if the enclave doesn't use the user stack.

> If everyone wants to tell me that what we have now (plus .cfi
> annotations and perhaps a CET fix) is good enough, then so be it.

Good enough for me.

On 2020-09-26 00:29, Sean Christopherson wrote:
> We do have this confidence, because it's required by the current versio=
n
> of the VDSO.

Do you mean =E2=80=9Cit's required by the current version of the VDSO=E2=80=
=9D and nobody has complained about it?

> But the callback is optional...

Yup.

--
Jethro Beekman | Fortanix


--------------ms050306050400050507020105
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDA5MjYwOTI3NDFaMC8GCSqGSIb3DQEJBDEiBCDg
oo1SrsACuWI5ObTg+PgzCxvRzpBQR4Pte3nv108NojBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBANZs4B3fuRTz0+RMaGRgw0fKjIyqtL8zCH+ly1fH9bW2FvE4go0k
9WwgSSUr2j2TkNgvaDlt37UUTOApRm6u5AineatKgII/pfTCt0C8I6APTrFtQbUzWmkUlM7S
xX5+8sTWEHruxuhieFCVvmGMLnfKphDI8U9ntzawjb2lNp5n2VXADAhO4DX0f5fiLxzzvt24
a4/Pqti2bJfgDEPDQZu3YtWgcecGhX2TdkHMFEJeCu720LaHH1Tg7hJrHfWGCwreC86VnIvs
3QmEDtu11l5nx/m7D9qSW8/u25jywzDMLm6Qzj45g0KI9uKru5DAjcfEWA/fTcFxir/qyadA
SRAAAAAAAAA=

--------------ms050306050400050507020105--
