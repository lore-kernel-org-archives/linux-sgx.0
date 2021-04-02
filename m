Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E619C433ED
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 08:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB8A9610E8
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 08:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhDBIie (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Apr 2021 04:38:34 -0400
Received: from mail-eopbgr690100.outbound.protection.outlook.com ([40.107.69.100]:6310
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229522AbhDBIic (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Apr 2021 04:38:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e84+dJdpHRwkCxr4myeDUJLyqCZ+frjZ8Nu0W4gZp3Lsa/EAVQgeeQVgsGW0NEH6yMfbYoPeZ6DmioKRFWW0hd1cdhUFJk2GQB0cpSPpyP2QtG67BWwkVRFGZYd7/8jy2GBwg9OTBNKgLEwZczsfFREy2gHmLlQxLIdwlKN7yIzUC8tNpjkSpA0+uxudS7WOcxv4MIbbhrpOALnYaLZ5t+PuYlAQUhW3pNU9oj8HCKJ8LIIvNhKHvqo/Fwt5i5Erda2XzZDWJmvXK9zEa7f0HfDswgoEbJJ1IMSJf4u8PWhyQ5/cnHibtHX/AeWBIAYkAlTphu+PCf2lpK+xsyqbIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+IXJg2oPtNRvsOeLp/stybsL8wnXfSdrf6k+h4/REg=;
 b=SVR4uyn5hKIBkzj8kWnS2t9Aa3p5dh8pbbYsGDQFisMQH0AMwP4EMRy4+vL4370PTUPpDIO9/a+E3GrgqYoCANtw0CVMaEEev393MqXVYMDyf4X/VgKCOyeA3VLzGCDqjwMJOrb/VWlvpK/yOypBTbltidrxICheumFzqB6tTut2B3AJ9GgQV6q4bekMJQMsRa0dW3ZUdft/rInXlrheLH9EQG4+7tpR4FTMAtTQVeCrV2gUH86BsVMpoWRv1BZUc03DkFMc5EeK5W+VQo6IYCzZJVEdahzAXbSvKXyZiRuh+u8/oZl/6ygt7MqIwCFW0ZIzg3d/Xz165yX9lMriEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+IXJg2oPtNRvsOeLp/stybsL8wnXfSdrf6k+h4/REg=;
 b=e6PJV1dtKdTXTXO7cD9SkHn88+jw3GKYAx9XIM04rJQjtmLPrRmqLZKb6PQUPBV16+XnNlIMWVolxAIPs7edRnRWT/chP1j3nADtNOgoU8My7hoJyY+ydd1uYQljjJrdBBZXCX21krEfwwzGwRaJiwD7cUz+jhXhLnKHGdvosus=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by SJ0PR11MB4784.namprd11.prod.outlook.com (2603:10b6:a03:2da::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 08:38:29 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0%4]) with mapi id 15.20.3977.033; Fri, 2 Apr 2021
 08:38:29 +0000
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
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <f94e05f7-e6d0-9253-d74c-09cd200702af@fortanix.com>
Date:   Fri, 2 Apr 2021 10:38:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <247ffbee-0ef6-1b6f-75aa-2dc06df42d5d@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms040403060606040705060809"
X-Originating-IP: [213.127.124.30]
X-ClientProxiedBy: AM0PR03CA0099.eurprd03.prod.outlook.com
 (2603:10a6:208:69::40) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.30) by AM0PR03CA0099.eurprd03.prod.outlook.com (2603:10a6:208:69::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Fri, 2 Apr 2021 08:38:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11994c6a-a8a2-4067-58fb-08d8f5b2b0ea
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4784:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR11MB4784326249B54845679B536CAA7A9@SJ0PR11MB4784.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XaqrUnmao/p86tGmNruSVVY94ohfdybZ2BmvjbhA/oEi41e2usPry5M9ey5XpF5npS0HQi9CJMfyrMztjj26C0WjomkbANZj9MbgwEV3RnrmrHUpSsqftIrBCwU+/rXQi4LmvJh0DzyzMFzJWQvdCpenPVde6DeUGkLyCv1bCh3Br1v1cSL4g+AZEyYJQgAXAYnXJbPyOt7EqluydWsi9MC39f8/P1VSxj5hSlWEfXN5c40o53FvnzeC+WjXm0fUhWh69bzf+k+Rl3SzZPldZr8DWA0kHdjT+JOG7TKN++vipM1ipgV75zQ0cp75Srnj1zoWj40Iz/T+PHvsCEK5XFXVeKNGH5q02CBh0dTA9SSScZw2KpER5en5jpgMteAdC1CSl/ZEz2OpMj4x9zmJiU3cjNQWdRchevhU7Sv/wT/vQVC1Ern7PLUsCiCzryCofZTYh/6V04DJamIBCLNC7aGQWgWg22nuK6prvugKsTcPLDe/t4UgNedpg2HyDfxJD/SkwmTgERvt2+aS6wnWan4K9dL3pQXGKID8lORaGULUqi+svCx41A4JqHlaow3BZHR/dfKK1eoE+sbPn516UDwhc9zXPvvWCXlXr/PtyNVqDsxaMnz+dre+23A1oIWBwlkm4gVV4UHyAtjD1Rl7zSvj5rpqv+BajnfZvH/GLVrw4+YWiPdw5wwwdMPeABns7e0chxVXruvmmD26a6CMwDa3wdqpnCTha6rWZNKfq7E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39840400004)(366004)(136003)(86362001)(316002)(83380400001)(478600001)(6486002)(235185007)(186003)(16526019)(66946007)(16576012)(52116002)(33964004)(36756003)(5660300002)(53546011)(2906002)(2616005)(956004)(8676002)(921005)(31696002)(7416002)(38100700001)(8936002)(66476007)(66556008)(110136005)(26005)(6666004)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WFlLWGdCUUUyemxGZ1dHM01UOVEzNGtXSSs0bWpzRnd5MlhHRnRaYTJqeDJ2?=
 =?utf-8?B?WmpGNE42eDM1Y2VXZ09FdTUrRWJ5RGpMZTU4QmZIalZNRFcwMk10MEEzVStM?=
 =?utf-8?B?SHZzcFZOOGZjbzF3eDlienJhdXpOSU9UM1d2RHA1c0JLVjhEcEF0OU1CU2NP?=
 =?utf-8?B?dWk4ck80bllWaGdUWDJiZ3JWN3o1V3N4clJ5SVgzampRUmlUS0ExUnBSdk9H?=
 =?utf-8?B?R2lKcnhNMjUrbk1iRjFzajZNcXc2OTFoVHZtU2FrVHNTTGl1VXFQUG5YLzFZ?=
 =?utf-8?B?TExzQmozcDAzdDhVV3VWc2lGdTBBMHdwNmkzRFYxUWJocCtQdDZJVFFJY0M1?=
 =?utf-8?B?ODhtcFdHOWZZcStsazZWSWttUWs0dWJXWTZVMFl2ZFdKVElxSk05c1NVc1lH?=
 =?utf-8?B?UTBwaXpTVnYzTldzWERxV1ArNVF4dVZFbk9rN09EQjNTcUxMajMvbVdsU0tq?=
 =?utf-8?B?TVNCRTFsam9PaHVmR3l6QVhLYWgzK1kxYWVMWXFQSjNZc3ZaUlh2YVg5elQ5?=
 =?utf-8?B?bEc1dHdKQzJ3cXBIc1dUU3JMM1FIT1NQR2N6VDFLS0xuTmR1SERNQlcwWXRu?=
 =?utf-8?B?YXhFcjkzRi9zdDlJVjBmR3pCa1l5SHRFOVRzZmg4cElQOHBHM1dBWSsxRUlC?=
 =?utf-8?B?blNFcWNNQjVBdGR4QW5RdlJpditFeGZjK3d6RGo5Y3psSTFaODIvOGMxSkp6?=
 =?utf-8?B?VW9xcmg1azZNSGkreEhBK053N0dTejZNUnVXbHErR1FXV2VlT1dISVdhR0RV?=
 =?utf-8?B?WEp2MWdSRzl0K3hXZlVVcW96a0NhcnprWUpXNjJ0SzN4MUJKWmIrY2ZLdGlM?=
 =?utf-8?B?RXFhWHgzRjRXL0dJVDU0aWJzcktlcTMzM0l0b2NtU1lTS0VmdTZiMmFIT0xO?=
 =?utf-8?B?eXEzV2h1Uzc5RUpDNDRCN0VRSWZHWDNwREVYT0hDZzNLbHBEcFRLbXlTU2po?=
 =?utf-8?B?MkFxeWtCVlU3SG1qQWxaM1pEUUZDUmtzRmxOWXdPUjhuVGxqYURGSWNtd3V1?=
 =?utf-8?B?Z3FPS1l5TVU3QklXNDdlZEVpaGxhQXpZVGdzUTRJOFpwelg1ZzJYc3lkdzhT?=
 =?utf-8?B?NDhIcm5EN1NxKzhiVkNKM2RYWXZzMGc4ZzJ4WTNOVWhvZDQvQVpEQndZejNh?=
 =?utf-8?B?V0c5UjVwL3VPbDF1U3drZm1uejJQWkY5UmdCKzJ1RnFQUWNvY1lidFBhemty?=
 =?utf-8?B?RWNzSWQ5Tm1leDFBZStrK25uR3VxaTUybnBhNEx2ZVNlcUduazEvdFB0UDVr?=
 =?utf-8?B?aGhwRXRKYWh6dStQbG94MGg5Q3A2c3dZQTllTlJQTm5OL2poNmV1cGlPMFZa?=
 =?utf-8?B?MUhLb3c1cWRXVW43b3A1dmNBNWNLNlVTVFJ6VnRROFhPSCtXVjh2cjVhOXpo?=
 =?utf-8?B?QWFnQVpTQ0hsOGhBZWlGNko0eko1Z21NRzVxZzlMZkhnTkNJWm14SlFrdDN5?=
 =?utf-8?B?YTIvTlMzQmE3S1laemZ2bVdnMzM4WnhUWFd5d2Urb0NFR1YxQ1pPS2FHd0ln?=
 =?utf-8?B?L0FjMk54Z3NoWElXOFlBaFMwam9YNy9CTi8xNnlDK3dtbGorcm4ybGJoeDVF?=
 =?utf-8?B?MnlsZWk0bDd6YmUxZHE5bEhRaWVoMCtDTFdWZm9kZjZuMzd4NVJPUy9BbUM2?=
 =?utf-8?B?Ym9Qa21nUTBmVXNnZ3VneGNYcWVOQWtyUUVDYWsxemlhZ2NJS3Q0cVVJYXZS?=
 =?utf-8?B?OHpQVkd5ZnpmZG40NldQMnR6WHRTK1d5a0RVZUlsRDc2bGVZaG04RFlOaXNZ?=
 =?utf-8?Q?K6Ecepxm5mj21zwqilqsGWxL1kEc1/LtW8tIkuZ?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11994c6a-a8a2-4067-58fb-08d8f5b2b0ea
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 08:38:29.5226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nUNiiVwDmViWtGZYsJHawr25GlXxIKErZxS+e9EnohxDX1HXMlPdteP1eGdN8KWxFsv6gR3a6bQaOJ2vRX6U2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4784
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms040403060606040705060809
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-04-01 20:40, Dave Hansen wrote:
> On 4/1/21 10:49 AM, Raoul Strackx wrote:
>> On 4/1/21 6:11 PM, Dave Hansen wrote:
>>> On 4/1/21 7:56 AM, Raoul Strackx wrote:
>>>> SOLUTION OF THIS PATCH
>>>> This patch adds a new ioctl to enable userspace to execute EEXTEND l=
eaf=20
>>>> functions per 256 bytes of enclave memory. This enables enclaves to =
be=20
>>>> build as specified by enclave providers.
>>> I think tying the user ABI to the SGX architecture this closely is a
>>> mistake.
>>>
>>> Do we need another ioctl() or can we just relax the existing add_page=
s
>>> ioctl() to allow unaligned addresses?
>>>
>> I've considered this. In order to do an EEXTEND without an EADD, we'd
>> need to add a flag DONT_ADD_PAGES flag to `add_pages` ioctl as well. T=
wo
>> separate ioctls, one for adding, another for extending made more sense=

>> to me.
>=20
> So, we're talking here about pages that have been EEADDED, but for whic=
h
> we do not want to include the entire contents of the page?  Do these
> contents always include the beginning of the page, or can the holes be
> anywhere?

Holes can be anywhere, and EEXTEND calls need not be sequential in memory=
 address or even relate to the most recently EADDed page.

--
Jethro Beekman | Fortanix



--------------ms040403060606040705060809
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA0MDIwODM4MTlaMC8GCSqGSIb3DQEJBDEiBCCV
32pMIXHyFO51Yhh+sX6yjxrNwSRlci1PImi3yhI+dDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAH/h8SOkGd2fPnxG7w3Ik/aY2DWacgtPt/BNUOHFwFG83p4k2A2K
X/TC4I9hCtSLpFTds3f1dJkPCiTR67Zw1MtFWBCnzJhmtriHkXy8y+TW54W1s9abdRLlg5ZV
1kzQN3+LQmAe9mY5iXeGis/Z5YvVyLqhLfKVNx8Z7GDmT1YU/ia88WQh2lT+RJkKL7KN4P5P
NgfO7Aniuh/ZQRThHPcEzyKP1LJSPifG/LhKXqU+gVFSMm5W67dXiy3HwAJvLQxe/oghxRuV
Ks0cGzZiMn4pkDoW/DMdGxmPKmQXjBhKP2EckVOzxmwngdEQj2FqM3n4q0hIaCBWwca6o2x8
zP0AAAAAAAA=

--------------ms040403060606040705060809--
