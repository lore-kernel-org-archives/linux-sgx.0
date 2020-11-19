Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D72C2D0E4
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 07:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 799E224698
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 07:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="Ve9NGD+8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgKSHXp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Nov 2020 02:23:45 -0500
Received: from mail-bn8nam12on2135.outbound.protection.outlook.com ([40.107.237.135]:12640
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726107AbgKSHXo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Nov 2020 02:23:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fboNWPxeWWzoToka+pD2dBHDEx8yX8m9LcIDHYoaSGqU/ipSp8b78Z01wG0mIl30jgm9b+1V/gX7ewehm2MpJiP4SvbBMfu/X86CRQXrlT2vrC1apVJ5YoSZTnAFt5/t7wrQ7QFj2i+0HdXcg6cIxUFvtSoaRsWYzY12N1E6r+gdzpfDnJb0Iw5D/qEns0sJf6YXZUXxOHVUzmYI/6N0CgQcF3JdxQSOnQdinJGEMe17th8X4hdJFNNhl+lYR1JztOPXhgXKLwBsG4brpa0kH4GgzrrCl3OxLhq74APnxN781TQdeFbS5thPbPX7tRG0vdKHqeRGuENrjDILesC4bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HbN6XE2Dc8Ih4eZWves30wn9Nij9ZvKCuKEL2t0vtY=;
 b=dFk8LaHamBoMIEkaqHUT4H4+GdsskpQr69CXPqYO5nzmilMo8PrH24ttI1X8X0Jt5Kyoii0rq7CjaCfEfPyl1Ic3nBjR8YEdpluuKlMeNlpdHIi39ESGRfuUMAPIHHBbg0TBW/aJASarr7Y69hH/VhSIAJh7u8kDFbQhbwToE4603VFq6GG3/QXVVV2xcDsNwNLcN1IAuhB28H+NUK0BjEitMZ+YcXdnhILknqqoraddCBaufyJbRV1mw8Ph0NCWj1DGfkugC+e79peQhpiMUZGUX9CRZ4QxHegFC66Xxyrunqc8uNQlbaWm9UtUjBIM0iKv6V9vvt2p6pbFzQcdJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HbN6XE2Dc8Ih4eZWves30wn9Nij9ZvKCuKEL2t0vtY=;
 b=Ve9NGD+8en+cBg5B4EAYnLnsDj9JTU2SrNUQOpLRTmWIpCl77X2WQrVzEZVEKr21BzewSDyBnIYrgRGrCxQIel6rYYbZhmuaOhFc1T4ob0qcRWA/Xs6fnRPD8b6odgXr2N64lHOffMRju0aBC4UYqGMwT+Of2l1wtxBgCMp7Sxk=
Authentication-Results: decadent.org.uk; dkim=none (message not signed)
 header.d=none;decadent.org.uk; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4435.namprd11.prod.outlook.com (2603:10b6:a03:1ce::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Thu, 19 Nov
 2020 07:23:38 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::84e0:4df6:7a70:eee5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::84e0:4df6:7a70:eee5%6]) with mapi id 15.20.3564.033; Thu, 19 Nov 2020
 07:23:38 +0000
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <4cd754dd-7230-be12-fd55-f2d45c68e0d9@fortanix.com>
Date:   Thu, 19 Nov 2020 08:23:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010209050907040807020204"
X-Originating-IP: [213.127.125.17]
X-ClientProxiedBy: FRYP281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::23)
 To BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.125.17) by FRYP281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.9 via Frontend Transport; Thu, 19 Nov 2020 07:23:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0feabb2e-a043-4c57-aa44-08d88c5c0817
X-MS-TrafficTypeDiagnostic: BY5PR11MB4435:
X-Microsoft-Antispam-PRVS: <BY5PR11MB44359CCF62FB43E869FE2692AAE00@BY5PR11MB4435.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qs0HOD0c4CiW/5rcSol+zPQB50JoUlI5NcWUs43BLHgMcYILQ1BU7eziQSQqzP0tiYGbx8JAwj4Rd0dRCiPLEjhTSSViKqbit6J0/RrtGGwAhCy7+5mtNV8yDP2aLRxdAGYJCuaIiR9PaBvWC3HQPhbJFCqfkmgUuS2F0ZPg7KL0DHqbWkbilCJKp3PG+hC+knq6uwdlIgnp9gbxdO0M/FrBeGnCFNlWUh++Rkl3iSA4JpIXPt382rEaJVKJm3jDQ9Esbqx2z9vQn4gzQ8L8wQ0oTGwggog7/CPZ4zFrZqqRCyWbHKFdslKglOmhJD5z2mMKSWqhoBcRmJmZ2MKZDzRNxrW0wMHqYuaEDHHrRdFGh6MIP9vIyh5qOjHM1tYl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39840400004)(396003)(136003)(346002)(316002)(66476007)(33964004)(8936002)(2906002)(86362001)(66946007)(2616005)(31686004)(6486002)(7416002)(66556008)(31696002)(36756003)(83380400001)(186003)(16526019)(53546011)(6666004)(54906003)(478600001)(5660300002)(16576012)(4326008)(52116002)(8676002)(26005)(110136005)(956004)(235185007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: wKWD8xLREBtzgvJN4BHMJHkcHmA8+2GsDvqoJB2OblXhz6PJ058PLqHpR1rYYeP+KHfdWHKA9sRvxAiScY3qxuIzaTQAm06/fQY5Xn9ZQha+XfYzLxrc4jMx3BXX+fGf/LN7PnQF1FaZujcZhUNG+j7Ib5RkAzfB7joEZQmWLjqAwzKAK9xo4zSn0maV0jPBw5hJsPj/HxWcLWxwjKl+rDkXfRU7/QC5IMQbfJ6tIv4zKgsTJlCNLiysiBqfKKnH8Oo+LLyUXdJfCldH01zv7aUvHkYpMR3RrptJHkH7TmrKjQLFJw6dtc3FEFBjmuFVCRlnC2K9KrwZ/gQ1kfJqd4CIk5zlfl/AE7HCo89wwHUubyj5AjYPMywiRo5Jp1X40FIfZW+VrCVIW98BpKaLdSWT9McfYGsVRV2b3j0Jrh4s548xsdFypb2NHwTNrWKlSSsL1A3GXUJJIuXpNedUIL+CQ6pZ+/K9XKHonN/mAfKtU51y5NiFWTbaKSezgCG0YPxDh+mO3lpb+sqlb9cQUJjIjGz+SxSPAXvgokVf2pAMy3Mkv2B4VKsaRtrov981BCvMFIxBXClJb1ZWnsCIu0m9bLVEsQ/T4haSNkJ1bI6r108HdFMhyuyXITgqC/Gl0jhDccRiCLr4Rvvq69PRTw==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0feabb2e-a043-4c57-aa44-08d88c5c0817
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 07:23:37.9340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nYsBFPmMx78Ava1WizSIhZdtg2e2pvOBMHMhx0ZNEPrF15c0M4Ng7XZ2TETipfT6j8TrxM+S5iZDBfPMinVL7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4435
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms010209050907040807020204
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-04-06 21:53, Andy Lutomirski wrote:
>=20
>=20
>> On Apr 6, 2020, at 11:55 AM, Jarkko Sakkinen <jarkko.sakkinen@linux.in=
tel.com> wrote:
>>
>> =EF=BB=BFOn Mon, Apr 06, 2020 at 09:44:19AM -0700, Andy Lutomirski wro=
te:
>>>
>>>>> On Apr 6, 2020, at 4:01 AM, Topi Miettinen <toiwoton@gmail.com> wro=
te:
>>>>
>>>> =EF=BB=BFOn 6.4.2020 9.42, Jethro Beekman wrote:
>>>>> On 2020-04-04 09:27, Topi Miettinen wrote> Then initramfs should ma=
ke a similar exception as with v86d and grant exec to /dev.
>>>>> I'm not sure this is a reasonable approach. Expect most devices wit=
h an Intel processor will have the SGX device going forward. Then, no one=
 is using noexec, so why have this logic at all?
>>>>
>>>> Intel does not control the whole market yet, does AMD also offer SGX=
 or similar? Will SGX be also available for consumer devices? Are distros=
 going to enable SGX, will it benefit their users somehow?
>>>>
>>>> Perhaps the sgxfs approach or something else (system call?) would be=
 better after all in order to not force exec just because of one device. =
/dev is usually writable, so allowing exec means breaking the W^X princip=
le for filesystems.
>>>>
>>>>
>>>
>>> It=E2=80=99s *possible* to create a tmpfs, create the sgx nodes on it=
,
>>> bind-mount to /dev/sgx/..., and lazy-unmount the tmpfs.
>>>
>>> I don=E2=80=99t know whether udev would be willing to support such a =
thing.
>>
>> sgxfs is somewhat trivial to implement and has one stakeholder less to=

>> worry about. It is not really a huge stretch.
>>
>> Overally, I think it is something that we could live with. At least it=

>> is something that does not step on others toes.
>>
>> Haitao: If we go with sgxfs route, then you can for the moment do what=

>> Andy suggested: bind mount it to /dev/sgx.
>=20
> That also needs userspace support.
>=20
> I=E2=80=99ll start a thread on the udev list.

Andy, can you send a link to this thread?

--
Jethro Beekman | Fortanix


--------------ms010209050907040807020204
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMTkwNzIzMjlaMC8GCSqGSIb3DQEJBDEiBCDz
M6X28WZZxuqopQO72oaeliYDrT9OkBolEnQVGUtKjDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBABCf3KcYdiuuoXlMa2Y5PYa1Q/mGtoe2uNaEcrYCV4GwGGzEyc4B
BedeaFFouSXkcK8przyvDQ/+kCMflpk0PTQEFSjni02Kk7f6h06HWrcq7WGieOjRYI1Heb14
T4oaT5zsoXzcWTh1yslRD0gtgfggfG89O8lboo2377pJCjcKE3VqLAnEcLn4CR37O+hukJeg
p/XHsXJbAzQKJcxeZ29hgmUGpp0fs+FZCSpWWrxSjFAdzjMgBeikS5OvT/UKc7hOAv6jRl0M
iXhOJ7pZYqNCcoyXVRA7RU8Dg2mZHDGzREaNccRZsTiFZrT1Ut8kzmeDlLHmsH2XD/XiT6hv
yMwAAAAAAAA=

--------------ms010209050907040807020204--
