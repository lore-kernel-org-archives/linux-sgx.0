Return-Path: <SRS0=GMJ6=D6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3380BC4363A
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 14:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 962562168B
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Oct 2020 14:24:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="V5i1TIAQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465185AbgJWOYL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Oct 2020 10:24:11 -0400
Received: from mail-dm6nam10on2090.outbound.protection.outlook.com ([40.107.93.90]:6881
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2901005AbgJWOYL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Oct 2020 10:24:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnoijIL13IM+sKVeATk9tqQVHgFp+2L0qHFTmkYWy//RhFYqi4MY4cgbaGMOdJCZTuBfj/Gu9EvH0O2TjJ0ZV3odnDdo0OvP1m01FWkhmTlnaEHU5Stu/LaB44rPdKtp9+kwuuZKcmP6Hi8SmnjxHZSu9L63S/H1Sa40eFm8iU6YsicZqLeCtmxUVPyfBlcdEXSudiYG8DbBGu/Pupk4vvditYyIYFokEeBQtsbXQHtO5vpH0sxY9HZLDOMkPk34BXBFPwr17RjLjYorCNH3Cu44h5pYuUPFItsWQJGqqiZeMzqn157gWIHnKM7tYcR9pIMx0tYVEA3giv433VBvyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7e5KmqSL+QUZDGqong2SFp8IG+ki9QKjGSVoi2KRj9A=;
 b=O/Uv5Co/+jU+CXArwXBWZnS0Dqdt9NYMd+wHJH1oaFyu8eS2HP+umH70VxZ5Rm7tORKww+DRrPlSYMwrR3ebegeNk7XXnttAoJO6DQEZTRvkMaCeoR7FLpxjHq3lqYWJzWzeGHUJN9UqDaZf74/ERBCCZoMFwx8iONEuNNslR5bbSv/rZrpIEhyLcKx4Ys0WA/Vps/wPCkmy6zfCREkHiziaQEOLeXEcV9Sc/udEbKPrbxK/Wgs3wkubOExf+2087fmgNardl3+dgZoDo5LbpaLFHt/JZrInXXtGqSP0Y9ByU/oxfkwYMbt+/VcGcDxKy1NeONlsc6bWFVZd2xeKSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7e5KmqSL+QUZDGqong2SFp8IG+ki9QKjGSVoi2KRj9A=;
 b=V5i1TIAQfwOXrdHoDCKv5GgCbHWgFq07dHXfm8ra4nZ63VR+e1cwhwwaYBgwDri5HAOb4Mqu9bYP/3/77n+pMWd4upNZThIf35Yyj4CtjoteqVNFM/+6Ej1IKSxqeRIMuAMH46Db+NkUlk+r7HIeX6RU/X2bbvSPLB1tjI7dGkg=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Fri, 23 Oct
 2020 14:24:07 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3477.028; Fri, 23 Oct 2020
 14:24:07 +0000
Subject: Re: [PATCH v39 15/24] x86/sgx: Add SGX_IOC_ENCLAVE_PROVISION
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-16-jarkko.sakkinen@linux.intel.com>
 <7bb4ff7b-0778-ad70-1fe0-6e1db284d45a@intel.com>
 <20201023101736.GG168477@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <5dc74a43-d738-3711-6967-59d8264a5ee4@fortanix.com>
Date:   Fri, 23 Oct 2020 16:23:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201023101736.GG168477@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020006000803040302070500"
X-Originating-IP: [213.127.16.47]
X-ClientProxiedBy: AM0PR06CA0144.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::49) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.16.47) by AM0PR06CA0144.eurprd06.prod.outlook.com (2603:10a6:208:ab::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22 via Frontend Transport; Fri, 23 Oct 2020 14:24:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb01218e-95c2-4da7-d483-08d8775f4cb6
X-MS-TrafficTypeDiagnostic: BYAPR11MB3256:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3256E1A765945C4FD672B926AA1A0@BYAPR11MB3256.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ysYrpoqUHhDeeS+jJHKqIJEoVVwzVxgvBtNuFaRl1KKOnCOjSReesCPHWhBYtN35ENyT013iZIkUueDB6qQCGr+UAa8lUXNmnmOeJPjU9UEdGz0CiIzAOpPVN9gWdCgOMZw9Htu9rVDMDuV4c213471qdl2kvPb1jU9SVhVfpk+FCK7gq3sUwODFY1EhOM0FYWV8DezViI5WhyXBRC12rEUyjB583KxWRDpPLD5FQCt1hFj1YFIOGm181U3IhT8PFY+uCI9jIrv7u4FnZZ64emLXSLAq2X/K7cjKpsAWoXxTpJ73xSie3FwPRfOsH4FwPxQOTVqaqaDF/cqQT6HoXmAuEQlWmoGmHi3z3Gia8GNuf85KON8vjegZfeEiMlqi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(39840400004)(396003)(86362001)(6666004)(31696002)(31686004)(2906002)(478600001)(8676002)(8936002)(36756003)(83380400001)(7416002)(4326008)(6486002)(26005)(54906003)(956004)(16526019)(186003)(2616005)(110136005)(53546011)(66556008)(33964004)(52116002)(16576012)(316002)(4001150100001)(66946007)(235185007)(5660300002)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jt6q7l1q6R7ujc1lIwyjBVExbj3HliRyll1bM1ByxFWwvUDcxCwO0fDvFOR1JiUm8jrgrohzgkwtaoFi+Lsgoa3SHmBPG9BdpQrpjzpzGIyHP0CXLCE4EuYHnTwQXKqyvSxSvQbXUw3gqymSnAw96i+zXXYlbLQi1SMvcQSW6SFx7RxsQQqJhmOymJ3E0vKMmgiKySsPzTDN653LVIjqQwOHqpho+9aIhSJmPFWE6hnQOoC28b+9fgeFYJ0P//OCWGyjw9Jvki37+OXPvL+2grjIQ1fO7grxfrzHb8roxDhfC/tbQcN08Z5xG6NLQbxBQGrYh+rGqeTHPPMKjHIOxrew1FGqkXWHWArtPyH51Ik69ul0LOLJLSqDEUdxeWRZ9miFcdjWrmj0tHNfM1PtEuxZ5HQXtEKZFeZj9LpQM1ES4ytA84pr+44MXQ0GTthsQ/i8+PVrmGIEQI8ya/DWfKprLEldM64z4IMkK40PfztJ6S3Y4lDT4y7wQPTqDuBk/xnoZQstmnfWvJPp/9iGUqH/blGiYQ6aDggnh3MrKi2w1K9dHHEUXYWMc0Sn45YLoP5g2zHIscZxjbO8Z1kb/eta4QGzFLtqc/EPis0iK19KDm+Gdby1rPwja9ysFBZ8v3wRR2BwqmZvGow0liwyCQ==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb01218e-95c2-4da7-d483-08d8775f4cb6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2020 14:24:06.9601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akSA3QuPCezl/ErNeYMXSOTvmvpe/N/JjlglRwFEvWjDRveLfpXQTmUJY7euGlpgysHhmohEcD6TQmTAFTOz6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3256
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms020006000803040302070500
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-10-23 12:17, Jarkko Sakkinen wrote:
> On Tue, Oct 20, 2020 at 02:19:26PM -0700, Dave Hansen wrote:
>> On 10/2/20 9:50 PM, Jarkko Sakkinen wrote:
>>> + * Failure to explicitly request access to a restricted attribute wi=
ll cause
>>> + * sgx_ioc_enclave_init() to fail.  Currently, the only restricted a=
ttribute
>>> + * is access to the PROVISION_KEY.
>>
>> Could we also justify why access is restricted, please?  Maybe:
>>
>> 	Access is restricted because PROVISION_KEY is burned uniquely
>> 	into each each processor, making it a perfect unique identifier
>> 	with privacy and fingerprinting implications.
>>
>> Are there any other reasons for doing it this way?
>=20
> AFAIK, if I interperet the SDM correctl, PROVISION_KEY and
> PROVISION_SEALING_KEY also have random salt added, i.e. they change
> every boot cycle.
>=20
> There is "RAND =3D yes" on those keys in Table 40-64 of Intel SDM volum=
e
> 3D :-)
>=20

This is nonsense. The whole point of sealing keys is that they don't chan=
ge every boot. If did they they'd have no value over enclave memory. RAND=
 means that the KEYID field from the KEYREQUEST is included in the deriva=
tion (as noted in the source row of the table you looked at).

--
Jethro Beekman | Fortanix


--------------ms020006000803040302070500
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMjMxNDIzNTVaMC8GCSqGSIb3DQEJBDEiBCBV
0YZa7gagXB/OvFIjcavUuyw0Ua5mzJyZHRxf2jotxjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAMerUssRVIRimk6273IZJQ8pkLQogyOY2CPI5/gU2gGF4jCJd8Mt
c7Xn6kLpIwxmnXxW56LMKOxyVnNbQ+QMUNwTozzzRvtqKDeNI/SX1yFUNVvBZd9fta07uNqD
a+zrYhSwHFkX1yak+VEiSPAJkMpyKiqCS3GKdx8MW3kXAdY6FJojdiY/xQHny5l2F1XiqyvZ
6WUJbLyU/iXiyo7txeT2gnRb6po2dsmL0/dHz0512ec4vL3Yz0B2UTzJpkwUKkA98fXvP7UV
LJFkzzpOT9MPZyNFib4PGJPwaESVO095MkinVEAbB+RtxWaQXJDO6aCzfa/1YoEyVsPd4kjE
CTkAAAAAAAA=

--------------ms020006000803040302070500--
