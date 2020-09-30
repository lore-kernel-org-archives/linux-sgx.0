Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B847C4727C
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 17:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB97020754
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 17:01:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="Gr+Pg8AB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgI3RBc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 13:01:32 -0400
Received: from mail-dm6nam11on2128.outbound.protection.outlook.com ([40.107.223.128]:26305
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725355AbgI3RBc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Sep 2020 13:01:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKAWnFN7ZoPhFQDlu3MEja/wlLThU2Bcj+GsAwGsTG5jE7I7bxHE7nhrROjqEUVHZyoo5tyXY9wMmalUAKcyKISfvsu53RxZcdfgVsqkoEWvLaO1st0NyGyA18N0qenNZyNgHWQkllxQojGeKzO9oQ7pOs5PnysWzi2myBWyr1PzOlvwVg9KRjaeuCa/SnRHynxFE9EsExQkKdDb6tLEyhhipPJucNOUW9BmcFTs/9XUqTTLFAnFQ6930zE87sZcgzdRC8Z6gwZ1bwi6d0bPGHudiJDBTczS92KU7ofzF1oZZMtnIBi6zT3HqZ5J5qHCrYGCht5wzb0rbQ68fHIIaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5Jt2vUFKaXyM6BVIwujvFU6O5RLoeP4OYgos6g6Cfs=;
 b=ko9/GbsjHv6uIXuMzp6G/5dTYQMc8yvT2yZdmT3srv0v6X462a+IX05MJ4MJN7hzHh9obizCDaJS/nppwmXVoZ3NY/Nia7LIm6kRMrgSBZ+blNwlI9HSotpk0bR2zqd5mmldNsh0Gb+7Pa9UImnx0nF3yZwR78vfv+KYWQCYWUMOdSEn/pd1HX0yW0S7yiwVSX3+05u4imA/XEdDCflannqZB5ns1J7Kn0WiOnHkHjEDSLwvTFllLSmUWDv3d/KF0VBjzlWCGWfoCG5iVe761D48rSakyuHsLou9v9AC6Tv7RHGjqIb3rCj20K2CxO1a6nVqFIEseQ/Y6DWGO9f+Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5Jt2vUFKaXyM6BVIwujvFU6O5RLoeP4OYgos6g6Cfs=;
 b=Gr+Pg8AByRuflPoV3C367N+gtE93hLVGS9kAiqPaz09kgTueLyEwSKuCiYQ5tEBOk9IOa/IwCIvzpDvV0kTLluv2Lfuz5KVIO/wV/ml8FLdEc6rP7bG/gX6+5WURJpsXKF8DpPy4wi6QjyU975t/NYpkh5iKWuaz9ROhqdt8C7s=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3718.namprd11.prod.outlook.com (2603:10b6:a03:fd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Wed, 30 Sep
 2020 17:01:26 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 17:01:26 +0000
Subject: Re: [PATCH] x86/vdso: Remove retpoline from SGX vDSO call
To:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
References: <20200930140108.48075-1-jarkko.sakkinen@linux.intel.com>
 <92578646-83a4-606c-b251-4d80cb62399c@intel.com>
 <20200930142017.GA49393@linux.intel.com>
 <112ad81e-16ab-d6e0-09e7-3658874434f7@intel.com>
 <20200930152806.GA52739@linux.intel.com>
 <20200930154349.GB32672@linux.intel.com>
 <17231664-3735-2d57-fbfa-9af838e224ab@intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <f5021328-2fab-a404-108f-e28e26e6996c@fortanix.com>
Date:   Wed, 30 Sep 2020 19:01:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <17231664-3735-2d57-fbfa-9af838e224ab@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000305000800050009070309"
X-Originating-IP: [213.127.14.5]
X-ClientProxiedBy: AM0PR04CA0102.eurprd04.prod.outlook.com
 (2603:10a6:208:be::43) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.14.5) by AM0PR04CA0102.eurprd04.prod.outlook.com (2603:10a6:208:be::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35 via Frontend Transport; Wed, 30 Sep 2020 17:01:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1faf12e6-47e6-400c-8473-08d8656277d3
X-MS-TrafficTypeDiagnostic: BYAPR11MB3718:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3718C62CF9B7512D30B259ADAA330@BYAPR11MB3718.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /MorBrEW7U3AvzdfiSw0lrW2UExBa+XifUp4K7vE/t8hxzLZNgFaQUnv+sHPtkfh9LYyuovSCplLzk7J5Wlwe/oA1WaUwQ1Y5fpb85rKMyjN53Fz3I1BukwMBQn5i8DBEhdGvrL4YITFJR0eYnR2jbE/gFkczEmDB6rSBI12U+/OIuXYx9mXtFfQZKHwltR+PybSVA7ePklKMO0Xrb9yHV5eocTDzgZbf6rtOJBxaPhlqnMtswOYhYxq5VkGYYyJzOoTUHFXobE/LsFRkJJasvY+myBsm9YjuNmFWW1OwXAfMDxydvmKme/U36njARRTW8gYMdXf/Iws4GZlgZH69u6RHtXZYO1O2qim5FYv3sF+G0McdrOD6dsdHc7RGeJEAp8ZiZWy29biXul7qQynJ49XC7j0G+Qmbv8PSsz60/niTjAP/aPyxpyCN1ffPUaW9+0r5fSN9KmpB4rscIu6CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39840400004)(376002)(366004)(346002)(136003)(16576012)(31696002)(66476007)(66556008)(8676002)(66946007)(478600001)(31686004)(235185007)(316002)(52116002)(16526019)(186003)(110136005)(2906002)(4326008)(54906003)(33964004)(8936002)(83380400001)(2616005)(956004)(7416002)(966005)(86362001)(53546011)(6666004)(6486002)(26005)(5660300002)(83080400001)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: UavLfwsf8jYuL+wlS0khURJWtDHravZf4G+jevtALAtukyp/tOy8htpMoCOYjRdewvgPn87UCKMKTXxL+Cqc15a3JDWjPnAhZm1OAmD3wyl39iF5lI7THmgLGyaawN3fpxtwTF3sJ3YXjT5HkeQ3LJK9uN2Jw/8vQ2gIrCCYi5L1pDK1XEZuZtPGYDqBLFcE8jXI6L2CRHt0o+fBdobhl/jkDISQ+mK5F2ANIy6htxP7iE5ocu4J2h4DHduL+OvRxX6EygKH8tVZfzNEqa1RS21TmD/zUHLyp3WB/ulSUi7/vLPk5AbyZYXfEUt6tqoQo8NqyA+g6BblOA6WIpn6BL9TjmpRSYpgn2rUVIL1nqcJnCmou8mZ+532vio0zeaf1fmGDxxxT0x0ht/yU25iRiUdC5nyZd+0kYq/GoW+SeSO5FTxShnJUATC7m1bIyD55eaDt1lIsv1kf5W3CyPKhAZgP9kgCl++VFEyANhkg31B4smS9ASbpZjg1GTqZ8RjfQ0kHEKn1G1XIGgH7B4NGrG2CcLSE16/UxUnkGDWoP75oRwT7ZXMhymR0wLUqCz1QBHlh4rZNUpVclVEKD04p86PKgkmSx38yUv7GM0I+ZRA9TdPAT12yEAQtlGCMusD4dVev+Ffa0adSLPgNEmCjg==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1faf12e6-47e6-400c-8473-08d8656277d3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 17:01:26.6335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uu362sZEoVDloRVqwtGRa/npAprz4JGT1nPIj6Bu/Lwc4GZY1kfArFz5lUgXqy+68zkYww9J+u6TNWmc/PoiqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3718
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms000305000800050009070309
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-09-30 18:28, Dave Hansen wrote:
> On 9/30/20 8:43 AM, Sean Christopherson wrote:
>>>> Do you recall why you added it in the first place?  What was the
>>>> motivation for it?  Were you responding to a review comment?
>>> Absolutely cannot recall it :-) I even cannot recall the exact time w=
hen
>>> we landed the vDSO in the first place. Too much stuff has happend dur=
ing
>>> the long three year upstreaming cycle. I will try to backtrack this
>>> info.
>> It originated in a comment from Andy when we were discussing the legit=
imacy
>> of the callback.  From that point on it got taken as gospel that the i=
ndirect
>> call would be implemented as a retpoline.
>>
>> https://lkml.kernel.org/r/CALCETrVBR+2HjTqX=3DW4r9GOq69Xg36v4gmCKqK0wU=
jzAqBJnrw@mail.gmail.com
>=20
> OK, so that was Andy L. saying:
>=20
>> But I have a real argument for dropping exit_handler: in this new age
>> of Spectre, the indirect call is a retpoline, and it's therefore quite=

>> slow.  So I'm not saying NAK, but I do think it's unnecessary.
>=20
> It sounds like we were never able to jettison the indirect call.  So,
> we've got a kernel-provided indirect call that's only ever executed by
> userspace.  A quick grep didn't show any other indirect branches in the=

> VDSO, so there might not be good precedent for what to do.
>=20
> The problem with the VDSO is that even if userspace is compiled to the
> gills with mitigations, this VDSO branch won't be mitigated since it
> comes from the kernel.
>=20
> So, here's the big question for me:  How does a security-sensitive
> userspace *binary* make mitigated indirect calls these days?
>=20
> Seems like the kind of thing for which Intel should have a good writeup=
=2E  :)
>=20

If by "these days" you mean also protecting against LVI, then it'd be lik=
e so, I think:

lfence=20
callq  *%rax

(at least this is what the LLVM LVI hardening pass does)

--
Jethro Beekman | Fortanix



--------------ms000305000800050009070309
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDA5MzAxNzAxMThaMC8GCSqGSIb3DQEJBDEiBCDC
F2FLZctxG1rMAVRM7ZrSSee9Dzc0ciEQQM07oB37GTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAACp0dUQIXdTEVzLBuXp5OBP8CtJp/WsLJP2NZ8kderWnLAPZtn5
pyqnYXR21SletuFnr/ajzpT3/RyzVzrj7gi21W3yTt5ZcKcoQYT5e9wmcHrVFvi7/tXJb24a
WhCscRjVGto9vI+mnQlub00zc2ApLG9MZYbZB5iEIyetV7eyLf8W/HX2qvmrMO15AYtAtw5o
cQqX/zB0iXd8xPQfYEMOC5qe/VI0393YQhy15+GAmFA/+IIagmq1g9M1UYGzxE5AEl1dqx5f
yQoga7Lx6k+kdd/UaoZT+bjCfizbDwF99SdsyCtF73FDpm/jEd+9ZH8JjrceFAapOd6iWZPi
9ykAAAAAAAA=

--------------ms000305000800050009070309--
