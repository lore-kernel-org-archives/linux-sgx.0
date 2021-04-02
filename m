Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6D2C433ED
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 19:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFE9C61103
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 19:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhDBTiP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Apr 2021 15:38:15 -0400
Received: from mail-dm6nam11on2092.outbound.protection.outlook.com ([40.107.223.92]:19904
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229553AbhDBTiO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Apr 2021 15:38:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OC5cKJWgZzX+HOwLVqAJKVuu28x0y1xvayv5K3CmcxVITWqzjPhE5w+2L3t1jboohpkWctDxe02UXOsD1d/lodVxbRSazt74bRJVJGG67/UvwD3vNNSFy+Nm8sWG2xQNhgC09vvTkWGkxlSFcuQEHFhUOGBdN5xMuCU6eMP0aVMGUPkrzGxwa9Km7JWxtuEU3Zwa9NUp/NCb2iQ+XLQZZtZxHYYWjGqO/rwvFAmEOVW/ogwa9Z4IYfKuo8HZL1aLc7+jx43gO3+qrpNwVgrP8XklbWwZaR+3ezPkSQ8bL1FPDFL7PxiPivAtrIYV9YnTknLKdOfQEPi2UQ05hV9RNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFQ8nT/PTMR3KuYlr5yB4O9HRvFtkM1L8GUip9FYmvY=;
 b=gJIhQieUMu+/7mq3ESNtKAFKiGdr3qUvZifknJIFBQokeTQWekDQv48YHkvXJ5Sunqxms8SqpCQ6rEyVPf6cP/XluUDNH4qbTCDsiZrjLt2KmvQ779Wzux8a8EN818DFyZmQWuY3/S0ZGpzWfr4g8SQUizYBsG9uqlIr6t6YcIqd1fyyBpzMxRnvdtGQ6Mo9D2wIJpUE1Lb3FvFTx+SeZZhjbIJrHRYW+42EpJuJLWGBH8Z/f3ktBbYoDPbvG5u+ghj1e4WZm1gW/kED0R6u2Vw8jCXjSvBhhnwOb+Yn9BrPbRs0W2K/lBn6Qhfn25os+lQZLfc0Uu9Ks3WtM1QMow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFQ8nT/PTMR3KuYlr5yB4O9HRvFtkM1L8GUip9FYmvY=;
 b=hvvoLNUeJCY2RgSSrmzW9afcvpiTZ2LVYrOp7jpvqZ5v2GdNDmkqSkMOs7RcIiyuFm0QJMD30+IaF3bFmHRE4k1mfqwY7h52M9fBxADouHIM4NZ3ILOpRRbuezDR32EF0vtf6VXjPuecdMLR+Ue7BXZSD8RK2OJsZo8/fR5GxAY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4273.namprd11.prod.outlook.com (2603:10b6:a03:1c9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 2 Apr
 2021 19:38:10 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0%4]) with mapi id 15.20.3977.033; Fri, 2 Apr 2021
 19:38:10 +0000
Subject: Re: [PATCH RESEND 0/3] x86/sgx: eextend ioctl
To:     Dave Hansen <dave.hansen@intel.com>,
        Raoul Strackx <raoul.strackx@fortanix.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <9688abee-6ba7-e1d9-701e-a5cabac36269@fortanix.com>
 <c7b19652-3b5a-e864-1e0e-3e3d26944398@intel.com>
 <ece49a38-c84d-dba7-6039-b409511e7303@fortanix.com>
 <0498080e-6fdc-ed6d-8efa-d9c3265fe7e5@intel.com>
 <9d15aae0-078a-ed72-6c14-155cd1bf27c5@fortanix.com>
 <247ffbee-0ef6-1b6f-75aa-2dc06df42d5d@intel.com>
 <f94e05f7-e6d0-9253-d74c-09cd200702af@fortanix.com>
 <4a122198-054f-609e-e96c-b69ff941c8a7@intel.com>
 <9a841584-65e8-31e9-6bd4-0140b33434e8@fortanix.com>
 <5af533e2-5bfd-8edc-0eaa-6fd3ddebb211@intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <3a8cec45-87e6-9192-e556-2f3c85ec16dd@fortanix.com>
Date:   Fri, 2 Apr 2021 21:38:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <5af533e2-5bfd-8edc-0eaa-6fd3ddebb211@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020407000104070004070308"
X-Originating-IP: [213.127.124.30]
X-ClientProxiedBy: AM0PR06CA0084.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::25) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.30) by AM0PR06CA0084.eurprd06.prod.outlook.com (2603:10a6:208:fa::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Fri, 2 Apr 2021 19:38:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f4eca16-4857-4e0b-b9a5-08d8f60ed8ef
X-MS-TrafficTypeDiagnostic: BY5PR11MB4273:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR11MB4273EE7D25FD84A8CF2F428FAA7A9@BY5PR11MB4273.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6zlPIV+4E8Erkz2cecGbpGNlitWwC2xlsUzbsU3dJRYto2L7Dwku3xfTbjB33NXiTajPH6yJWPFe5miPbm8AmLC5JBEW4ehaXxUUfDtCuYq7VqT7kjf8vy11zwOGvvdp4HuJWFGAa73WpuMx5Mg9eOjkGxnCngwruRctDDaPCHGGIxr/xVEf1qUeVCieG9bMfn4xNY799TQguDvnI0W+wxRbug7/K4mKvx6ilCi0zAgBA5dkhwgX3+dcVsXWVo7Cx9ymu+FC330kGFBoxkmfaNJCXJ7/cDtpX7cnHqtjda1Rtqs1ey/jODM2EIfgvf7hvZmM4VO3f9+PB84TnhpRgCAbe3XcVceOlH8c9yVavKg9LUdUYbxZdZW7MJM5yjY1oxhPc7YA8RTfWvmgwKQucJjdr4a6NwJkCy6GbpL1P3uagMyWrOsVb1Vc7D3YsNcVSupQn1dfDqIw4uOSLSvHfVzIZF/iQYEmTA71mO8XSu/HgbYTSfbHf/jsnlIkesnwHhbQgoPSfPkapboX6DmrIRwh01tH73QFdOHTkDO8FZ1e+4aoozNAawrmMYXa7/CO9OvDhHW7cCAFuO76WEYfh9h/+oq3DUG1iFivQZDJV74ddaL+9vUAYQMdeilG4dMBy2YXdddLZtzNM7tNc64gN6uXqB7xxk+wQGA2UCsI0QoP6lDRLtGE6RevcaN4L3qlxmrOsgws2scYuMDP4oYwDGIfoxG2vjDhayF8zWWfKBo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(376002)(396003)(39830400003)(8936002)(52116002)(86362001)(31696002)(36756003)(33964004)(31686004)(5660300002)(53546011)(8676002)(110136005)(16526019)(186003)(66556008)(2906002)(316002)(16576012)(2616005)(956004)(6486002)(83380400001)(478600001)(38100700001)(7416002)(66946007)(66476007)(921005)(6666004)(235185007)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aVlCT3NpSlQ4NDdJWGxVWGtKYTNwOFBDRTBMYytSR1dHQ2FEQS95TkdKQWE4?=
 =?utf-8?B?Q0owZkJMSFZBMGhJRmJXWWNza3JwSmQxM29FSllEaDM0Qmt1N1crVUFHSU1a?=
 =?utf-8?B?V2ROS0xZWTJNS0djb3VOZERtN2c4WGZIVG04MEF6cXJvWkg1WTJKcEY5N1Vi?=
 =?utf-8?B?d042K3ZWK0tEUTA0S1RwNmZKczBuaXRHRFdvajNxTWhXZGF5ZDVhRGUyUjJX?=
 =?utf-8?B?NGpTMU9BSkVoaGwxNzlRb2ZKNGJ5dGtqSm9paExxc1pFclhvNnp6QXpwejBt?=
 =?utf-8?B?RXlJdHFnejFSMDFJOHo4bGtjQWxaNHBMYnluUVVQT0JKNXhJbTNMWTFMVHdt?=
 =?utf-8?B?ZlcyWkt3V1R0VWhoV010NlhEd0lzYTZyYjZHdWFJQXV4R3BrclpiNDYraXky?=
 =?utf-8?B?R09Wd0gxQ21XREVLK01JRGVRV1ZveUtOaVNDUTVmR21WMEZzdWpLR3hlMkM5?=
 =?utf-8?B?a2hVcDc3ZUljdnkzVWdDSkV3RzhkWmN2cDExdWFrM0ZWOURvejJJSFd3cGRM?=
 =?utf-8?B?WlpuZGhnQS9zekpEVkpvaDIyWTg0c3dYb2FBRExaQis4dVRuMW92TDZSR1g5?=
 =?utf-8?B?Tkl5cWJFdlhzb1dpK1ROcURZcnhZSDIzcElaYkZDekNzN3VSSWI4aEFvTWVo?=
 =?utf-8?B?Z3FxQmpmUEREbWpScTlITXVaN1lyMEVianpaMkg5N29TVTJkWlhUbUp1ZFJK?=
 =?utf-8?B?VUVHcWxWZEhXS0VlY2dBY3VFcm95Um1qRERibVRRNHE2eHdaTXlWekhMUFR2?=
 =?utf-8?B?dkNnWTFycy9sSzlMS1g5NGtEVCtJLzE2OTBwbjR2bGZMSmdtVG0wQXRxd2Rh?=
 =?utf-8?B?QmtXRXlJdlNCRGRQRHV6V2w5VXFRSU9YalBqcVlwRXRZZGpDeVRLNHpYc0Q1?=
 =?utf-8?B?cG05RmtPWVBhb0ErSXVHNk4zdU9FejZyeW05RTM1eXQxOGh6dENpdXgzTFRV?=
 =?utf-8?B?dTJhUzlIR2d0b01UNHBmYUIrdTVaemZCVm9aaXdIQll6d0xHaE5LSFova3Yy?=
 =?utf-8?B?TFNyK2NvaklmSVA2U1NucWMxc1I1cUtVd05zanNXTHp3a01pNEI5VWU0a1RM?=
 =?utf-8?B?MldCaEt0VjR2UEFaTytCMlBFOEFTTE5iT0p0eU5xc2NPWERmbUdnYVQyWFZn?=
 =?utf-8?B?SFdiMldneC91b3lqU2pjY2Z6Q290THlRY3E3NHZFYXZtWWhKVjlpSFFVMTdN?=
 =?utf-8?B?RlUyYlFOeWs4SGorQmh1M0tsWEpTemZPb21mbFc3YkRLc29wZVpRaHBXVkZm?=
 =?utf-8?B?ZkdRT3hmRWhSVTU2bEtwZUE4WWZKRFQ1ZURCME0yVEhkOTMyYThsUUNDc29s?=
 =?utf-8?B?MjkwWHN6ZVJBTk1jcEZaMytWeGxxNDFBNnM0bGNJRFR6SXZkSW1tQlJVbjZy?=
 =?utf-8?B?UHp0LzYvRmE0TnpKMnZvVXNPOWZRSkRxdEpHNFJUaUkrRjVlZ2pBWG9SYVpw?=
 =?utf-8?B?N3VqMzlqL1g5NEp3T0x5eHB2TldwaGtaYzJPbC9uTnFSZ3hPek9Zdng1d1JT?=
 =?utf-8?B?Vmc3N0ovRmUwWkp1VFNUQitXdGRPKzBTUGZtMVA3ZU92WWMycEJUeUo0SG9x?=
 =?utf-8?B?Q3dpWmllbUNnK2k1ZW0rcHd4ZkdYVkQweFlpVU1tQ3k1MWsxV0JIVjluV1hQ?=
 =?utf-8?B?eW4reWJiMUVyaE05M0tlU1hFeFVkQnRDaWhsRUtzZk12VGt1NXdQT1h4ZkVN?=
 =?utf-8?B?VC9WcHVTZzFOREFUYmNrcVo4UDFsV2cwRnExOTZTTVRZNnM1NmY0SGVORnRG?=
 =?utf-8?Q?Ii3C1iUrrPNhpD7Ito9Xrys5lvMk9eckm/M1BWg?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4eca16-4857-4e0b-b9a5-08d8f60ed8ef
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 19:38:10.4818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CSUKMb/xQcNES0gw+SWLpgxy1+jETlpwalvADXgmTrLPeRL10a1UxXiyY++CTaZNjkl4O4Cm2axQFEZjgyG5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4273
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms020407000104070004070308
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-04-02 20:42, Dave Hansen wrote:
> On 4/2/21 11:31 AM, Jethro Beekman wrote:
>> On 2021-04-02 17:53, Dave Hansen wrote:
>>> On 4/2/21 1:38 AM, Jethro Beekman wrote:
>>>>> So, we're talking here about pages that have been EEADDED, but for
>>>>> which we do not want to include the entire contents of the page?
>>>>> Do these contents always include the beginning of the page, or can
>>>>> the holes be anywhere?
>>>> Holes can be anywhere, and EEXTEND calls need not be sequential in
>>>> memory address or even relate to the most recently EADDed page.
>>>
>>> I think you're referring to the SGX architecture itself here.  The
>>> architecture permits this, right?
>>
>> Yes.
>>
>>> But, why would an enclave loader application ever do this?=20
>>
>> e.g. to save space
>=20
> How does this save space, exactly?  What space does it save?

With the current driver interface, if you want to communicate an applicat=
ion binary that has pages that are at least partially measured, you need =
to communicate the entire page (to ensure the same measurement for the en=
tire page), even though most of that page's contents are irrelevant to th=
e application.

>=20
> Let's say I want to add 4352 bytes of data to an enclave.  Today, I hav=
e
> to page-align the beginning and end of that 4352 bytes, and call the ad=
d
> ioctl() to add the two resulting pages.  It consumes two EPC pages.
>=20
> With EEXTEND, if I want to add the data, I only need to page-align the
> beginning of the data.  I call add_page on the first page, then eextend=

> on the 256 bytes.  It consumes two EPC pages.
>=20
> I guess you can argue that this saves padding out the second page, whic=
h
> would *theoretically* temporarily eat up one extra page of non-enclave
> memory and the cost of a 256-byte memcpy.
>=20
>>> Is this something we want to support in Linux?
>>
>> Why not? Is there a good reason to not fully support this part of the
>> CPU architecture?
>=20
> We don't blindly support CPU features in Linux.  They need to do
> something *useful*.  I'm still missing what this does which is useful.

Enclaves can only be loaded exactly as specified by the developer, this i=
s the whole point of the measurement architecture. By not supporting arbi=
trary EADD/EEXTEND flows, the SGX application ecosystem is effectively sp=
lit into two: SGX applications that run everywhere and SGX applications t=
hat run everywhere except on Linux. So, the "something useful" is being c=
ompatible. Linux has plenty of features that exist solely for compatibili=
ty with other systems, such as binfmt_misc.

>=20
> Does any actual, real-world enclave want this functionality?  Why?
>=20
> P.S. There are plenty of things you can do with the SGX architecture
> that we probably won't ever implement in Linux.
>=20

How so? Linux doesn't normally put arbitrary restrictions on what userspa=
ce does when it's not interacting with the kernel. Userspace is free to l=
oad its own memory contents and execute all the instructions it wants. AF=
AIK, besides this EEXTEND issue there is nothing of the SGX architecture =
that SGX applications may be using that's not supported.

--
Jethro Beekman | Fortanix


--------------ms020407000104070004070308
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DVUwggXgMIIDyKADAgECAhBukmvE8GLB9+EYd88699DiMA0GCSqGSIb3DQEBCwUAMIGBMQsw
CQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRy
bzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEczMB4XDTIwMDkxNjE2MDk1NloXDTIxMDkxNjE2MDk1NlowHjEc
MBoGA1UEAwwTamV0aHJvQGZvcnRhbml4LmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAOM9pWqcukwLqKxwz61HtRU+YK4w6EwrvjLtFeWi0T2qXSpA9ePS2c2PB2rCoqR6
VZehtzjp1FvE1X1Mry5j9Qb529a+wuhxrCH/ecULCOX3x1eGaYFIUbehmpztnvNkGowLCDWq
hsIU70LAa6KgAcQ7bcc9yR8jhLgF9S9+M74olvpKRYI7EH+biSPa4EhUJ5lvOo5uotEi7K19
zBqlZaz/d9U0YOL/19UxKx+0a7UHu1JC8cHZ5WiX680KyZhoHsHxitzRoumttYO+kZCKykVq
7mfpzWxedVTEARnMMtMFKDCjWoBZwNNLY/EyimgQpl82c9aaebavpxBngrm+88UCAwEAAaOC
AbQwggGwMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUvpepqoS/gL8QU30JMvnhLjIbz3cw
fgYIKwYBBQUHAQEEcjBwMDsGCCsGAQUFBzAChi9odHRwOi8vY2FjZXJ0LmFjdGFsaXMuaXQv
Y2VydHMvYWN0YWxpcy1hdXRjbGlnMzAxBggrBgEFBQcwAYYlaHR0cDovL29jc3AwOS5hY3Rh
bGlzLml0L1ZBL0FVVEhDTC1HMzAeBgNVHREEFzAVgRNqZXRocm9AZm9ydGFuaXguY29tMEcG
A1UdIARAMD4wPAYGK4EfARgBMDIwMAYIKwYBBQUHAgEWJGh0dHBzOi8vd3d3LmFjdGFsaXMu
aXQvYXJlYS1kb3dubG9hZDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwSAYDVR0f
BEEwPzA9oDugOYY3aHR0cDovL2NybDA5LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRIQ0wt
RzMvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUqK9FZHUTZ7vhJZAsuniSiMn24q4wDgYDVR0PAQH/
BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4ICAQDscghwA0YyWZ/w0dFhxfLbqpiHNx1UDWFp1GUi
BjZvpNEkKWtOPbBAkdShWBpLFsDH05PiladSagxxLPmdzRRytHwQ+LWxZhdMT1cz2ypVtKkq
3FiuDu41W4HoGhGn0fQc4FJzLEE0WJGTgP2zr7JcRISDgmFBHdinoVe3ZR+pbURoiuDcHK2D
BgcC4dguyxdVR5gLEyiqsCTNj+tfbopC0yAkInNMaAHS/IVH3GRyQ5xbXgczWu+agxxnOjU2
KuaQL+RNX7l3aPdp88DSxq7PFC3KOk5G4qz2Ts7nh/piR41vIh0q/Dfc1yCClWaTQqBgQvzT
uW8BQwq8mx5E7owmzj9IzZHRX69wkLGG2Yr7WinWp09yzmMNZRH2OrEI9BmKtafFpdr3me/k
lyv4RUlg8A+cNHAlL6cY6mHYrTu8xbzBlhOTicGB7JVhx+zLdL9TKI0P5ssPWfZOE4W76lSC
+pFr7Kb7z9037m31TKh2F3cZAh8Mg/XyPm6NTu97ItoOrl2BNn26P6jZlGuYCYUHqsxAc/pJ
Z8PiuTlLt1YX/pAXeCBHOmzbUTxdbG4tPvFmlI50c7GMW67Jto7Vf4XFa5NItqcQ4sXFT+tZ
3u6BEJ8P1hmvCwn5KSErm2kWLV5P5bkzBHajRsx0rE1VBALmHL25nbHGcOCQhaCgVgooHjCC
B20wggVVoAMCAQICEBcQPt49ihy1ygZRk+fKQ2swDQYJKoZIhvcNAQELBQAwazELMAkGA1UE
BhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUy
MDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlvbiBSb290IENBMB4XDTIwMDcw
NjA4NDU0N1oXDTMwMDkyMjExMjIwMlowgYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJn
YW1vMRkwFwYDVQQHDBBQb250ZSBTYW4gUGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5B
LjEsMCoGA1UEAwwjQWN0YWxpcyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzMwggIiMA0G
CSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDt5oeWocGktu3CQlX3Pw8PImBfE+CmQ4iGSZF5
HBsvGlAP3EYB7va6OobMUWHvxA+ACHEpWq0YfNh6rRUlULOGcIpEFtVf4nAiEvdQtiFQBmtW
JSn3naoMHqpMvmwZ4lL0Xr1U9JHmTqkU3DuYcNNO3S+hYWDZpWQbeSGibNVeiJ4kY6JDh0fv
qloK1BsuS3n2OgArPYGfAYtDjCvT2d+6Ym3kArHZjEcrZeBI+yVVnjPwbTSCKax8DtS2NP/C
J6RjpnRvuSwusRy84OdwdB71VKs1EDXj1ITcCWRZpkz+OhV6L8Zh+P0rmOSJF6KdHiaozfnc
URx4s54GFJNRGkx1DnCxcuL0NJMYG42/hrDYOjNv+oGWSEZO/CT3aaLSMB5wTbZKfcD1R+tT
anXD+5Gz5Mi15DTE7QH8naZjZxqqhyxL1KyuIgaVDxvQtPSjo5vTsoa09rn+Ui8ybHnvYO/a
/68OIQIHLGbUd2COnwm0TiZ3Jg/oYGxwnJPvU1nDXNcecWTIJvFF5qD2ppJH3HgJVVePUEOY
1E4Kp3k0B8hdRdhMV5n+O6RCKCTFcZaESF8sELgdrqnCLPP1+rX7DA8pxZoX0/9Jk64EOsbf
QyLIJlrrob2YS0Xlku6HisZ8qrHLhnkzF5y7O34xmatIp8oZ5c54QP+K5flnTYzWjuIxLwID
AQABo4IB9DCCAfAwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRS2Ig6yJ94Zu2J83s4
cJTJAgI20DBBBggrBgEFBQcBAQQ1MDMwMQYIKwYBBQUHMAGGJWh0dHA6Ly9vY3NwMDUuYWN0
YWxpcy5pdC9WQS9BVVRILVJPT1QwRQYDVR0gBD4wPDA6BgRVHSAAMDIwMAYIKwYBBQUHAgEW
JGh0dHBzOi8vd3d3LmFjdGFsaXMuaXQvYXJlYS1kb3dubG9hZDAdBgNVHSUEFjAUBggrBgEF
BQcDAgYIKwYBBQUHAwQwgeMGA1UdHwSB2zCB2DCBlqCBk6CBkIaBjWxkYXA6Ly9sZGFwMDUu
YWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRoZW50aWNhdGlvbiUyMFJvb3QlMjBDQSxv
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA0MDIxOTM4MDNaMC8GCSqGSIb3DQEJBDEiBCDk
p5NHQpn1h3iisOuhGcF+q6TapSmeWnsj3yATWK5dizBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBANrNQdrfnP7XHyEPorN2jJPkGCDVuP2aJb3JsbsnlFTjcwYBwcyq
Dls+UGmEYyxtyXX8Y6u2FB8GThp0+JJfG3ctkUjr9BpNNQ+FIFpQjPk/CqsEQ7OScEL7YeIB
a7A6FeJj1ZYQwNpQcESkbptH9nsK7xUXNYnNEbFtoa6gfvw8kE43mnZ6vO9PSKXG5e0RjaZV
AEdK6TMKlaGr3mclvhIV2itSD9R2kmKdvEGRlCSuKfTxoJWUdtiNl8qQkQDGAj9JK4KUIvjO
hBZl/xg1JcR9dqSwcRNnXpVzM3iWfV3vm2vDz4MPUFCOl0sssTMo44qQQrKXjNUZlKLQC7Sv
i4wAAAAAAAA=

--------------ms020407000104070004070308--
