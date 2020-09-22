Return-Path: <SRS0=HNuV=C7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803E7C2D0E2
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 12:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 289C92399A
	for <linux-sgx@archiver.kernel.org>; Tue, 22 Sep 2020 12:56:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="yMLVWm0d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgIVM4f (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 22 Sep 2020 08:56:35 -0400
Received: from mail-co1nam11on2107.outbound.protection.outlook.com ([40.107.220.107]:48736
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726566AbgIVM4f (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 22 Sep 2020 08:56:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxU/J31FEIK8QF40v0ZGDqzqoVNRcMfhOPeXOK3g3Ln5VnPtnVAcMpax1LMYwzWRL8JIC/0bEaB8yAC7Oq1xN9MPmIZZAX2yVkXBJ9861IwhkJsqicBHHj+4sJbHxOKwbyF8dySKBYK5mF9NVtzokup420Oh6crl8XQ5T5PMfbZYNIh7vc697ucJ4PN/EXZY/L1eBnON1DRC7Qz98jVfswsoJLNYcjMLjjht0thLrBc2GFGRdiX9aelYpI4ZdafAwYrvJimqMxszNV/73BsIV+oM1UDNZQ5kSDW8Av3jsD78GsVy93aK1y4B5kPfcjK6NUNdqFiKu7zQVsHIAj6kUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEy2x5zYgE9yHHjprBo8oICm9c+fJiuCuOn0uF2O3l0=;
 b=FqT7Ss+98B2k4GD8R4eD/oJfgdR1Rb8gY2ZuU3BK25pu1awTbwS/xWogDzuj7Wb03zEPPlgw4dweznpep6oeoYYsi39rAvXMKmDB5TJQHTuAecXEgkD04hhcPTnnd5f5tKfdrj1U8S0uXsyBVt9HGfYcK14RiqPGkzAy5/l/bXbWuVf/o1u71cfiimtLheWQX0/TkOPLbNcfjR0E5y4uZfjhaDK8yPOixq+9W5gDQBVzLxSOcFu4n1gyfNIfmgqNLJfY0HLTZtpjVa7Pwt3oaTlZUhEe7EOqt2DlSwvK21lTF70/d8glHF3QtPsNOIx6o/Tigks1iDkAUmn1157CiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEy2x5zYgE9yHHjprBo8oICm9c+fJiuCuOn0uF2O3l0=;
 b=yMLVWm0drqQyIRu8Vq7f+3w07htMiDpagy1HYaR0Dm1g28TeN1bgE6w+RCGei5mHb6oq9cE1lGpu2cGbTUl9g/67PYiTy3sV0TnU1xNsjqxOft64JNmJf+b47U6IWQ9+S30/Ax5mNSqBs2mM4h5e0kzFboUnKG2QomIt30/kUiI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3301.namprd11.prod.outlook.com (2603:10b6:a03:7f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Tue, 22 Sep
 2020 12:56:30 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3391.025; Tue, 22 Sep 2020
 12:56:30 +0000
Subject: Re: [PATCH v38 14/24] x86/sgx: Add SGX_IOC_ENCLAVE_INIT
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-15-jarkko.sakkinen@linux.intel.com>
 <20200921173514.GI5901@zn.tnic> <20200921181021.GA24481@linux.intel.com>
 <20200921182753.GK5901@zn.tnic> <20200921191658.GA24823@linux.intel.com>
 <20200922082918.GC22660@zn.tnic>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <a6f4d3e5-c128-fcd7-a1ca-5515a6c4c09a@fortanix.com>
Date:   Tue, 22 Sep 2020 14:56:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200922082918.GC22660@zn.tnic>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090203030607080409090803"
X-ClientProxiedBy: FRYP281CA0007.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::17)
 To BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.128) by FRYP281CA0007.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.19 via Frontend Transport; Tue, 22 Sep 2020 12:56:23 +0000
X-Originating-IP: [213.127.124.128]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2324d69c-a02b-4e35-1b21-08d85ef6ec9c
X-MS-TrafficTypeDiagnostic: BYAPR11MB3301:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3301AC1AAE11CF4AE38F7ABCAA3B0@BYAPR11MB3301.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9EsLJd7XxL6b/iB8aaoxHlo93ioTU5U8RmsKUNcF+qxkCXLJ4hSqn/bvYsYFBc6DSC9p7m8mqS02zKWKt8vHSQwg2tS6e11yHYeRoN58NLNk4zXchCHWX2hup/zip8ODDOxzTXVaFpIcvMCWS7TXehiuzfLwbCgHRSv7K2mN75uwzAyYpOEzdTkFxsxktL0SPx6Quy4xSSzQ5dpMO4qe3zvDwLLFVWWZ+4dsL7Nw0xzqZi0/5Uxl4gEuXX1M2GxfgEkV1Rx7rtoU66cp0HnJhWgJR8XIO8hWhMrMJ12S3IHmclhNYhNto3Xt+d7GCWWog98aIAOZcy3qULUDkiZAqFctk6VP77YuEedBPfccq3OfRCHZEk8UYT81xCodMiZxZBfUo5HwMhRZeFtyQgWMrV7zln83BYrBQKvcBWcMhmadA415URBhprRBBK0G0WLgDPcCzB8+6pveo4F7p6yGIfMvQ2HxZlUyykWDREu2hJAHC4OXX/T+Pv/hO3IrohCW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(376002)(346002)(136003)(366004)(396003)(2906002)(36756003)(86362001)(2616005)(66476007)(956004)(8936002)(186003)(4326008)(16526019)(53546011)(5660300002)(66946007)(26005)(66556008)(7406005)(16576012)(7416002)(6486002)(316002)(52116002)(235185007)(33964004)(966005)(478600001)(110136005)(31696002)(31686004)(8676002)(83380400001)(54906003)(6666004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ByaWuC/iO2bKx1iHF2de7PnSU0LDQvFZp4YMdKOOe1IvSgUqEeXPFZ/XlZlMZGGA7sbdgXippTSJl3s4buSFJ6EE9Pv6oivh8LSp1sNA+4lpv2Z+tlEXrXER409olb2htaELzaS5dGlIDguda/sW2lZktKjS3x/uYsmSlaFR/1SvJLp9zDYtGaC4XlrTVLfj0GCHm8xXAvC7Gpl7+EOkCsXP49tWdeg5019nMI3C0uwCX+sdjfCht2qTLrF4cMVDUe4v1aeGpKPkfAa4Y74xEEZB5i31BpAU5L9m29hu1BIEWnb8Qlja4M3Rt1o6KmAuy5JYpIGrASly1wNw4YOPL4OesIaVZevGnUcpFalLGbPDUWi27VLpqYKcRUa/Q/bBTXfYm20YCoYU+TSbvmPByGFmPu2RTpvJ2WGQcOQzdSPDz38A3DVesf+4GO4dmsodzmeT8Ft3eA/a63cb5QvEf67k3cL6bC7iOs5cd0coV5sY7nIP1Dh+CSSm0bmUncbWnnoSO65nrpANjRVdJRALaJEOkqFx3YfGtMjYtOIG4nmDHOePtEef0Jm8bWe+Kk9isFMRr9fiJEOuMUYnHiq+kYsK09r9hKiZI/Rstf6gK/7g11ZHgAI7qsHRVuMelPPdkj75kJz6Zw4RTlmo+Bn5fw==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2324d69c-a02b-4e35-1b21-08d85ef6ec9c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 12:56:30.1132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zH8kviRO1Ts/aoLw/jo64MY08uLtTmDkNMtc+kVYafsB0T0VfXrbakf9lxYXBFIy8PcbCWQYRYmw0Nw3tob9qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3301
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms090203030607080409090803
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-09-22 10:29, Borislav Petkov wrote:
> On Mon, Sep 21, 2020 at 12:17:00PM -0700, Sean Christopherson wrote:
>> That was effectively my original suggestion as well, check for a stale=
 cache
>> and retry indefinitely.  I capitulated because it did feel like I was =
being
>> overly paranoid.  I'm obviously ok going the retry indefinitely route =
:-).
>>
>> https://lkml.kernel.org/r/20180904163546.GA5421@linux.intel.com
>=20
> Right, so if EINIT is so expensive, why does it matter how many cyccles=

> WRMSR has? I.e., you don't really need to cache - you simply write the =
4
> MSRs and you're done. Simple.
>=20
> As to "indefinitely" - caller can increment a counter which counts
> how many times it returned SGX_INVALID_EINITTOKEN. I guess when it
> reaches some too high number which should not be reached during normal
> usage patterns, you can give up and issue a message to say that counter=

> reached max retries or so but other than that, you should be ok. That
> thing is running interruptible in a loop anyway...

I don't see why you'd need to retry indefinitely. Yes the MSRs may not ma=
tch the cached value for =E2=80=9Creasons=E2=80=9D, but if after you've w=
ritten them once it still doesn't work, clearly either 1) an =E2=80=9Cunh=
elpful=E2=80=9D VMM is actively messing with the MSRs which I'd say is at=
 best a VMM bug or 2) there was an EPC reset and your enclave is now inva=
lid anyway, so no need to EINIT.

--
Jethro Beekman | Fortanix


--------------ms090203030607080409090803
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDA5MjIxMjU2MTlaMC8GCSqGSIb3DQEJBDEiBCAL
ajrn45nwM3DqhgPyck0YDxtUWl0MhmBcfgiPH9b3+TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAGkak14SurYKS3Vn1hY+w73IJ8VYO8wI/PkAgFK0Kg3NL4F2cC/6
DFUGdeaDxPpQKQ2DwzSJqme2pfOsOKUF4PKtBYSq3ZC+CELehhkTcrDUG8rjNWqxiNsvd2K3
TG0LrpiBnMjBg8JfkwRgVmqva0XsZJRDnq+d8DkikRgznGiKKzrkshY8DkKhz9IKBQ7G9O1Q
ZtJgUUzxCg2xTQtemPBTG/1Efycq6wS3yz0gg5fR2TY1ff61MErzHPteKFipYMWrOeyf1N7o
DHLVpjCxHw9FZaaH0DK7rVhQs2w+fftMEPm4zR+Ll7LduY7aLzMbBR8U/Xxze+AjvKBnOUSI
9dgAAAAAAAA=

--------------ms090203030607080409090803--
