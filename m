Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E67C433ED
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 17:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF74B611CE
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 17:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244074AbhDLRC4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Apr 2021 13:02:56 -0400
Received: from mail-dm6nam12on2134.outbound.protection.outlook.com ([40.107.243.134]:56180
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244115AbhDLRCK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Apr 2021 13:02:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8iXSNFjDKm/2AJ41pSHlhB3CrvY5HCa0CB/G6DE4yYlTag1n14qv8mIrZs7horRxBnKMSWh/LMMVPNzZ9jdEAFF9xShKCCcHAEYKNWnGB+pDPPDIz2L2f3g3fdytn7PKZuxIzX/P0Z9crjVXwscQa2kNwYvSV7+PE/kv31UT2MchJdV+U5pDzpG/B4qTwFjizmYkpgFo/UKItOdnIbGcEOMwNrRXcRBtQJRLwaudugu7gMQ6WQUT3H8mIHJCmB4B5WLY7RuDsSGsns1cMZh21FTsnOS+4vz5cE7MPVISDCabjlQRGgG6wdSkQ4C6e+TdlP/liWB1Y1X/F7gMlLeYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nj7t51V3sXli5bgoPIqviHzWUquuj3pHHQlMZzVFSEA=;
 b=UQ9nZJ7fXp8oF9AxRc5U5XFbqSOkbGtj/ybUESYpPt2DZssBYfzeo+YS0kpCqP8YrOcOqCEU2iQL0d6JohIpo6h0vXb+LUbSf9TkhQheSBzUmZs07WQRjsxTDBYhYYeRjN76VEEJtBi1BYd8aBi5Mi4SRh+DU9GTbwXo6lKA8NBD041lTWf+ctANLzwaP51C6C+rSUT8PZXpj1sjXFIXAVeKwzITS7uXQiXD0rutcxkJC0tpzRmhClF4oqY9SymD2/tSpH89pFPmYTqmju2yZD02X16Ve5jl244siVuAtaREnM+e+bB47vBKPevWIv+TRcRas8xFpxlbNleTGtUU+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nj7t51V3sXli5bgoPIqviHzWUquuj3pHHQlMZzVFSEA=;
 b=x1B7CRgq53Vhk5mXf5j5aufpprCSaaQfgfarxW+1Lve3cBGLqsdXh/HVaGlW0i+gBmQa1E39EDt+2eoh7gNcfu3lHgXuImJzDl70UQkFYOoPvz3OMkwF8cslOHZm8tCyctKM1Ef9RZe9UfgrgvaAV22aONYqTHO67g5jJHX2WRc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3768.namprd11.prod.outlook.com (2603:10b6:a03:fa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Mon, 12 Apr
 2021 17:01:49 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0%4]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 17:01:49 +0000
Subject: Re: [PATCH v2 0/3] x86/sgx: eextend ioctl
To:     Dave Hansen <dave.hansen@intel.com>,
        Raoul Strackx <raoul.strackx@fortanix.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <da7ae1e7-59b8-63db-a9f1-607b4e529639@fortanix.com>
 <a05d07dc-1623-012c-5120-e30f64decae7@intel.com>
 <f3366028-286a-8543-0604-3db6799364b5@fortanix.com>
 <ae4b4271-9e74-99e6-fa59-369863c891b5@intel.com>
 <29cbfb1b-848a-2e14-5c0f-5d39d372bfcf@fortanix.com>
 <1c8f5c58-6cea-7f43-81ed-fa165af2b59d@intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <4e478984-e692-3b6a-771b-8eb73f6d82a7@fortanix.com>
Date:   Mon, 12 Apr 2021 19:01:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1c8f5c58-6cea-7f43-81ed-fa165af2b59d@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030309000306060500010608"
X-Originating-IP: [213.127.124.30]
X-ClientProxiedBy: AM0PR02CA0031.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::44) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.30) by AM0PR02CA0031.eurprd02.prod.outlook.com (2603:10a6:208:3e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18 via Frontend Transport; Mon, 12 Apr 2021 17:01:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c91eb73-463c-4eda-6c5b-08d8fdd4a98c
X-MS-TrafficTypeDiagnostic: BYAPR11MB3768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR11MB3768EA541D245A946EFD50C7AA709@BYAPR11MB3768.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7nqD0x3g5ocGAxMycW8rZZkqL/z68UtYsYQzyYGwV0Mef/vekFPIdJReAQuZqc8TtvQtGk1dMvkSZtvURcbGzZ3lDE3xkSn2XNJqLndAXwGMeo63EjKOkRNPg2h32VAJNtOWn0UCUsectRX2pwHwQCigKyKHw7ouuiB3drHAtnu+ee6NnVzkp0EKov4F7CfCZFYbYrHxSSPxu2LEIwE+1D9Db2D7JH7VUNyj4VuT2NgFkT+OJRM5eCbiS7+cSyvvG+NE+mhf2BuJVdubWHLO4KeWFP/6+AU59sZb74Wywyllwmxi4MFeeDitdLeFuKFJ7QxcbfZc4Ne8o9jeDnSrYpvH7PPA2VjxZheL1RPlbaAzsqQNQT6/OgcHOJCmDPndAvR+H7Bf7eXX7mqb+hhZGQsykzVMuDdb/G5mC72yX2j/43O6kWZ2wictUq7Fr/oyZExeJXGFM87NY3ngxdtSt1Utl10FXzWDWPWkSsfQABxYRrFTfd9TeWDvcOw2bbHQsZGldpLiF0RfIx83W/6fV1FuSO9SKTx77n1+unwP5JqmX9GyGOCzpr9A9KflUFV3bDSTkYsWzB6rNfoGKO1lu7qXEKNfaN4KzZkKRHvB3eVoC01yLEyy/1yamKpuAW8CAK7cc6GwTzKv6+Zfd6mGZHvaW88zN8amixZERKstYFTCy5ByyIFPUSFSDYJy5JFfV07LfNfhAT1VveKJVSwg++EIVlVQenlO+XNUY8vqWO4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39840400004)(136003)(376002)(346002)(366004)(53546011)(36756003)(235185007)(5660300002)(66556008)(921005)(8676002)(66946007)(6486002)(2616005)(7416002)(478600001)(956004)(66476007)(16576012)(33964004)(52116002)(8936002)(31696002)(86362001)(6666004)(186003)(31686004)(2906002)(38350700002)(316002)(16526019)(38100700002)(26005)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eFFMVWlRUUMwR3pOMEgwMFQrU2psa2h0dEZkRXFuNmVabGpGR2c0ZmVxS3hW?=
 =?utf-8?B?Rm5MQ1k5S0pDcnhlL2lRc1o0U0xHcDRXYjNDMkx3SjNzN3hqeXBBUFlMSC9S?=
 =?utf-8?B?VGJGTjVIOVB3TGkrK3hiZENEUnpHcjFic2tQVE5vNG83Uks0SXVKUjFyVDVE?=
 =?utf-8?B?d1loTFVqc2RiZ0QzdVB4emRrdDI4QzJsOG5kbW02Vi81NEFkQWlISyt4dEE2?=
 =?utf-8?B?YXFRYitJR1JQeVN2aGxENUtzdnd2SkFQUFpPVDVwdjhTT2x1dVEyUGc1bVFx?=
 =?utf-8?B?S1ZtQkg3bXNHY3gxYTJUNkNJUFV6TW1PL2gwVERvU1F4TllJakFaZGlWTE9s?=
 =?utf-8?B?cjBPTjN4bHlhL0ZqakJSZjRUZ3hqeTZ1d00ybVNrVGZqR2h1RmRWUWM3WXIz?=
 =?utf-8?B?UFVBWlVWMXIwZjhzSi9vcXIvOUlaM2JrRU1uUTI4dHZvUk01dU94WG1WMk9Y?=
 =?utf-8?B?ZkZhcmNUUk9RQlpDZXNSR1VuY2t3dmxqY2k5MVlwRWxhaHU0YWxiYkgwQlVk?=
 =?utf-8?B?aWJ4REFmbGZ3QUo0S1MzekZ4RFNQcXBOcm5ReENLSnRaUnJQNWZaUUN5SlFj?=
 =?utf-8?B?VFJuTXlscWt3SkVnQy9PNDFnNTRYWUtITGZuS0RGTUpjN0lzRUhxMEdMRmpn?=
 =?utf-8?B?T0tJK2FFS2p6WXdhVUdzMlY1RmNlVXlHY0I2ZzVFbTF4eDY2MjdwNmx2VFhs?=
 =?utf-8?B?SHdYaWFyZVZEelIyMXg3WVdubVN3c3doR0YxcnFnbTdFUGc5b2o2aS9aT09x?=
 =?utf-8?B?TXgyTjJjN0ZoVVozdnJLWmZoNGk0UzAyQ2FMNjlSazJnWEdPNkVIQzRwUzU2?=
 =?utf-8?B?dGR3TGZHdVlOOUVSbHR0TmQ5VGdTc0hOWTJORVNLaVpucGZsM3pPKzFyVldv?=
 =?utf-8?B?WjlONW5IeUJLWnFkRVh5RUFFR0xIblkwdU9WaGtaWXZsRnh0YXc2UCtTb3RE?=
 =?utf-8?B?VzNqVG5BVEJQNS9mbjV1SlJES3JrcHhrOWZOWGU5czJyVVowRlpEVmZTTm05?=
 =?utf-8?B?eW0xK055YkUrQ1B2S05NVktMTzhKeVNMQzljOWVKWW9yYzdDMUtqU2VOdXd4?=
 =?utf-8?B?VWFwZlJlRTBIYmhyZ1A0WWtjQVdLczlwS2pFZC9UY3QrWlF2ZnhjeTVjektY?=
 =?utf-8?B?SklWdmJZNEUxbkRUU00xU0ZRbXlHRjNsSzB6SW54clFOUkUxa2QzNTNHbUVT?=
 =?utf-8?B?MWdCa3p4dExseGVEMGlNeDlGaldlRlV3cGZDUUVrYlhaWVl6YURkU20reHpU?=
 =?utf-8?B?dGRFT3JLS0FTMGFhckxyZGF4UU54dGlLSlRKYVdNM1NWelpuVzVqdE5WTnU3?=
 =?utf-8?B?cUM4NVk5V0hXRFJBdjdpMFZTeCtDSkFMWGd6WTY0TURnR21zUFAzbkxVa0Fm?=
 =?utf-8?B?cnk5VmZJZUQ1Zm5vMWd2WnNVanlZcGNiYjhWTWFKWGFoS2Q3dU5ZQ0JjaERq?=
 =?utf-8?B?WTZZU2RLUHlkYk9BU05BNy8wVGpBcjNrdWlzZXNITi8xWnI5ek15OVd5U2sy?=
 =?utf-8?B?YkVlcGlMSlQwZXczV0JGeUtIWFBROGY1UUkxWXFBMGRPR0VzRzBDU3dkeXpT?=
 =?utf-8?B?cGpTMWhBRGhKTGVCdmkzZFlLbGt0YW16c2V0UFB2bC9SMFBBOFBNSFpKMTFB?=
 =?utf-8?B?bkVXdUcydlQvY1d4RXNOSnBQQ09KNGhhTXpJOVh0bjRZTW5pTDBzM2FTemN4?=
 =?utf-8?B?VkZxWjZhTENqL1kzVHFISzRJUFdBRW14c29XZkFKcjhiQVpYU01tWHd0ZlZH?=
 =?utf-8?Q?Df2xr4fLsK+CTSo5/IHx7dkde1jlCVgWyGOIbp/?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c91eb73-463c-4eda-6c5b-08d8fdd4a98c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 17:01:49.3780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hKAmws41Yyk1S6bt4PF3yIL8U335z5QrpusSa393IkIah/fWEY+vKvGRw+s9R2veRv1H9Ccd0j5wJzPtonuSRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3768
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms030309000306060500010608
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-04-12 18:47, Dave Hansen wrote:
> On 4/12/21 9:41 AM, Jethro Beekman wrote:
>> Yes this still doesn't let one execute all possible ECREATE, EADD, EEX=
TEND, EINIT sequences.
>=20
> OK, so we're going in circles now.
>=20
> I don't believe we necessarily *WANT* or need Linux to support "all
> possible ECREATE, EADD, EEXTEND, EINIT sequences".  Yet, it's what is
> being used to justify this series without any other justification.
>=20
> It's going to be a different story if you bring me a real enclave that
> *REALLY* wants to do this for good reasons.
>=20

It's still not clear to me what your motivations are for trying to keep L=
inux incompatible with the rest of the world.

--
Jethro Beekman | Fortanix


--------------ms030309000306060500010608
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA0MTIxNzAxMzlaMC8GCSqGSIb3DQEJBDEiBCAC
7eIb2v6blE0afksIg4e5mu37W3wI5nHYJcDKOfL40DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAGd2nLl8//q0oxJXiCyw7/7JxMENYqAsd/saFYlHmCrNV41quO1A
f9Yf/Uj6Jhxy8e3iZyPwR2EsZAiKOd1h5uU5gyeio3sk7U05RceYx4HADLEGQLEguG3a8mxL
4yhXcmUMpjEFLFrnt5dihQ6gy4rO4nF8xJNZxQoSmC3/BA55rySE3GIny3aTCvITZBXuLNbe
pa+Eu7j+3q3DUdtNmiMjRo6wJLUnVV77rEApWV4KD7aiJ7nJe0z93knEC6V7NUPJszIMDvee
EAekQsGjXeEfh6y2WyfKwkTxbtWAdVSE2oqRncgkdwRzrEDit2ImdwnZjbGuA0BUp7XuMQg5
P9IAAAAAAAA=

--------------ms030309000306060500010608--
