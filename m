Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3304DC43616
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Apr 2021 18:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 016176112F
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Apr 2021 18:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbhDASDk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:03:40 -0400
Received: from mail-eopbgr700113.outbound.protection.outlook.com ([40.107.70.113]:50273
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237003AbhDAR7W (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Apr 2021 13:59:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeZnkGX8ioVJkv+V7ebiZkCcRoUOqJExOqjKGtPoF2RwYMJU0RKcj5Ef3suqdSN8ZGucS2248mJPA7upUaSFgqjjQE2/0aS19MN2+odA2hd2PkKOysIoA669hHBmSK7nicm1BW2iRCcFPFq1OWRMFL1PCPY3gnRfNSYmog0cQ4GSnvyoLIVDqJI7vzgKmoHskc5kkt9gKT8WgRVuc01JaXI+zHur7xec8SGqdVGuRwcXJkOExUGbFcT1wxKlO/6DtEqm7puWtKpHVhbUDDdjRkY8VxB+f3+33f8Ug6dQJHjvMD9mPUxQ+P2PNLb2gIosv0N/S51txlKFPrrIpcjwQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFqFcTL9XdGQhIeXgylSEOE9w1ki9UrQRBHso2Racds=;
 b=hDJxjN5xcGwFZxPRvJ2xO/THIuR0mbRjjBcFY+0YnBrhEcSdHlpmei121Y2kJNbUrF3JIP91DqQ4fhU2I3rReWhY81kMuU7Hhul+UzUEaNOvFLHKHV0BFfRJJwPZYlh0HW+03VifYKId+KX2RQ603j3v3bOfJsgR9TSM0PhHT7EH6UtAhx+iTVVHbo/zrIhAy7aMHaW6lZS2emNBKlv7UhSNTTjCexNnI6XZ2H6Q6lfgHPdmRc+G2Ff9Bd+NNfb3RMrSzgjp7KYe6wqEZ8wRfVzkYOz9wjRMsKC+Y4+JHzlrutx7FTN5x/kAsmG755wVxmEAEtrKwPn59otD0GB9Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFqFcTL9XdGQhIeXgylSEOE9w1ki9UrQRBHso2Racds=;
 b=tV0MkAPLJ5364D4Fk3+B8KC/i99CL+Vyh29Uk8sIiz6sDEXU8xLgVEaLzXdlWdUwd1iR4RHsUi6Rowop9exoygdWSrzAzCp2jX/teCHaZ4SkH/Ck+E4PxQGInh7r7IsKcDDE/WE09YOE73oz2EUZ/e8bygolHqUU6rlDaeW/W68=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4182.namprd11.prod.outlook.com (2603:10b6:a03:183::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 1 Apr
 2021 17:59:15 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0%4]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 17:59:15 +0000
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
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <1101066d-7d12-420a-a2a1-08ba9fdce8bf@fortanix.com>
Date:   Thu, 1 Apr 2021 19:59:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <0498080e-6fdc-ed6d-8efa-d9c3265fe7e5@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080100090003000500050802"
X-Originating-IP: [213.127.124.30]
X-ClientProxiedBy: AM3PR07CA0121.eurprd07.prod.outlook.com
 (2603:10a6:207:7::31) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.30) by AM3PR07CA0121.eurprd07.prod.outlook.com (2603:10a6:207:7::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Thu, 1 Apr 2021 17:59:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5debc2de-0572-4aee-e064-08d8f537dd0a
X-MS-TrafficTypeDiagnostic: BY5PR11MB4182:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR11MB4182E5DB7BF778AC5E188AC3AA7B9@BY5PR11MB4182.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /xxyQUTtfHWjPAsLgMbcUEMjZc6tkQDLTrtD9JJUSryh/ARkNoxL8kDrTrUAXyC2sZVZyTnUb8PPXMUUDWP3pOVK2iqTRt34fHeJVTs0vUINGL4Zs12YS5++KdxjB5Yr4UUrZTRlLCL5jlaDUxYherUOXnu1sHbD6LqyQ1c1YifH/s3cGsp0NKySl2V+fevrNcMddOiy58epslo1hJ9FzGhNpQ6rM0L7hYLxK89LwFcKtkgVA3tH7ZhmPBoF7664qeA63UbWU9hrODFMkoxDE0qfC0OULZ9+3qibFgiMz1WF6wRv3d82oAr/p3EJ9nxO3p+XkWXfk+0SlJpFB/Yy3U4TwkqEj+zTCuCpDLf7Md5zLD16LAyHUvxvcVqqmZK/P+keN4sX/te19Gss0+xwgY5YHOgIzgfDZlxY38jW1iiJCozmeVyXggTyrSr8JJCa1stTy4UWJB9wqbd1/kmCTz1LRasxsUDc/Ts8CSj4+WTqxB5FTE1FKGtvA0Z0xeVgAjqG1UomyHyjcLTNRilWSHbaNO7LZmAVfYBRPmENMA2XY2H9mGIzrwZ8cmNxQosUM2MRAWehfQcqQXUVWtpdbel8uMXcv1AB+HLKVr2aL1WlKvuuhbRiE4GAs9yyOl3M3lzl24tcn8IPxDquCw65KK0iIFvZlz+hNH+hxncV0wDIxf1jlV6dU+B9YNcPiByfyQpJuIgtiZe7YAyoh+3y49UcvyHqFv+Ce9n5B1Xv3XM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39840400004)(376002)(346002)(396003)(86362001)(5660300002)(52116002)(921005)(2906002)(45080400002)(53546011)(36756003)(8936002)(66946007)(66556008)(186003)(110136005)(2616005)(8676002)(16526019)(478600001)(83380400001)(316002)(6486002)(956004)(6666004)(31686004)(16576012)(7416002)(33964004)(26005)(235185007)(31696002)(38100700001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VmxYTWk1QklMM1V2dUI1VlJKeU00dlBTc2QvcXFHbjh6U3REeDFXUW0vV2N2?=
 =?utf-8?B?bVRCWkpxc3NBK0hIVHJsSGlRQTNVdmZ2dkNVOGJqNG0raSt4dUZncURIOEg2?=
 =?utf-8?B?MzhsdFZueDcvQU9wOFpQK1lwWFVpalNWYUMzeTVueUV4Y1lTalVLQ0xxTVUv?=
 =?utf-8?B?LzBiQWs5VlRyd0tRelQ1N1NmR3dXMG9zbDB3MkQ4Sno0WDNYeFd5SHRVaXM5?=
 =?utf-8?B?YnVjdlJNVGZhZ2JyQU9UbDZWak5iakR6VlFTVnpIS0dDY01GVUlOMEx2NUJo?=
 =?utf-8?B?N2UvZEYxNUlpUHg3bEJvMEN0SUVRWktnOFJkNTRLZGM0ZkhBc0xYSU11cHhJ?=
 =?utf-8?B?Vy9tR3Jld3UwbnZuOGdOTjFqc05Oc2FBL05VMGtPbUJjWkRvbU8zNmMveVpm?=
 =?utf-8?B?NXRlZXp3dUdqeU04ckRYWmUvdnlJTFg1elhybTMrdUtBaDViMEVIR3FuRlBS?=
 =?utf-8?B?aXhjbDlDVzNsK0tITjlvblJxL1dhY0djY3ozbDBNd1o2SVBuUlM2VVRqMDda?=
 =?utf-8?B?OXJZNitkSlRwUlpCNFZ2bzhVOVhLcEd0N25Bbk43LzZadWFDSHVBZEtaNlNx?=
 =?utf-8?B?Qy9MSnZoa00wbitBV004M0xPbHROeit4T0RUbUVEUHpXWFFtcEVCaW9mMlJl?=
 =?utf-8?B?QUNvcGJDN2ZqSzEvSEF1aDVFY2orYnRmMlVVbXM2VlZucjBBeDFnL0M5bzdG?=
 =?utf-8?B?WmJWRmV5VG1tTFU4cXZIeGUyQ1hzdXhWMkNyTlZ4NFdFRGR1L1U0OE1IY3VH?=
 =?utf-8?B?b01EeXhnRnB2SWN4NkJuTFBFd1VYOXVBNGgxd010WWllRVZUZjhrNFlPWDRZ?=
 =?utf-8?B?MEc0TzVNRHlIdkM5Yy9rR1dNL0JhWm5LV2ltTjR6T0c2R25EcXZqOWxueTAy?=
 =?utf-8?B?RmFqd01xMWUxRHAxdFhRN25rZ2VhWG4wVHI5ZWd3dUEzU0ljS3dRLysvRVNo?=
 =?utf-8?B?U2R6NDM2eUY4VTJwdDNvMTlyNE5zVjlQdWtEVVZvVDIvT3VYL0J5NFplcEtp?=
 =?utf-8?B?S09acU9tZGR3QmhDVm83TThYcEh0OXBoR0N0b0h0NlBQTjU0UFU2ZnJyL3A5?=
 =?utf-8?B?V2NxbHdCSEc0QmtzVTZ5Y3lkejFrbjE5VFhPTlY2Y2FLdTJURDRhb0hJOENY?=
 =?utf-8?B?UjlwRmZ3SXpUV0syM2hLY0t0SmNuTEt2c2RMYzI0Z3JQTjRvWTFiL1k2VjlR?=
 =?utf-8?B?ZGVRb3B3TjVYa2RnZHMwaDlvMEtsNmFXVjR5TkZjNDJ3MGpTdi9GK1pUOU93?=
 =?utf-8?B?R01LS1hDVzJjbkQ2NGhLMWtmU1dWM3VLU0hLS0wwYXhVcVV6Vk1RWXJZdHNN?=
 =?utf-8?B?UEtha2l2Nm1UNE5lYTMxcHloQTVvY3UyaTJNNVhucmU3SGFZaUVxamtRMER5?=
 =?utf-8?B?cWRCSlZnNks4bnE0bzN2QUVXYmlRSUdzeCs0emxTYTJBNzNiZW9nWm5SNWV6?=
 =?utf-8?B?WmRTalRQcm1WQ29keUptZE1oeFFTNmxmdG1iaGwycG1LV1hhZCs3T2RxaUIv?=
 =?utf-8?B?R2xNbTlEWHhYL0xWWjRtRk13MXFlNXlmU2tqQmtjaGxsSVVOTkNvdlJBZTQ2?=
 =?utf-8?B?WmU4S3ZPRUJvbVdkWUlnWXFzSFR2em1uY1pFOG1hdG1TL2liaGZ5L3ZlZmcv?=
 =?utf-8?B?THBySjlwRVFzWUtJSUU3SWZXY0o0djJjTUNzRll3MEpXQUdBbm1kSzl5Myt3?=
 =?utf-8?B?VGNaZGFsOWFrMnBKRWRzY1dYSUZYdnNmUmNYYUJZbmU3UWVaS3ZBMFI5VmFP?=
 =?utf-8?Q?wHnrBLa2Mq+rG63N/2dy3af9W2/fBeGZr6HTWpf?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5debc2de-0572-4aee-e064-08d8f537dd0a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 17:59:15.5877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KpOvG350jSgZXf5pXceBOBVyiaRvXRtM36GT3vZIDfjncRxTQlPS4YhBUY3cZkuevpgeFJ02LvPaH8Ui/2h4Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4182
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080100090003000500050802
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-04-01 18:11, Dave Hansen wrote:
> On 4/1/21 7:56 AM, Raoul Strackx wrote:
>>
>> SOLUTION OF THIS PATCH
>> This patch adds a new ioctl to enable userspace to execute EEXTEND lea=
f=20
>> functions per 256 bytes of enclave memory. This enables enclaves to be=
=20
>> build as specified by enclave providers.
>=20
> I think tying the user ABI to the SGX architecture this closely is a
> mistake.
>=20
> Do we need another ioctl() or can we just relax the existing add_pages
> ioctl() to allow unaligned addresses?
>=20

Some version of the driver used to pass a 16-bit bitset of which of the 1=
6 256-byte parts of a 4096-byte page to measure. This was removed at some=
 point in favor of a separate ioctl to be added later. That is this. See =
the discussion linked in the cover letter.

--
Jethro Beekman | Fortanix


--------------ms080100090003000500050802
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA0MDExNzU5MDdaMC8GCSqGSIb3DQEJBDEiBCBs
0INA7FwikZc3yojYgYXNeYMguhbfwzo13n/MzwGVxTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBACCtcro0Lbg9Vl6ATjVCMPSEvrDyRC2tK2AVRjoC+eFUxLxbLOMC
j3c8iNA2qjFDvd70jHdmwcVst9a5D9EILAV/bD585Kw4vjpD/9GvxYfTPVAtDmLWeU+gv4kO
TkQfhNVslxH5m4HXM7K0CQqSmQlgAizUGJIzG6xsSGM9yn4gS2ok2R38Vd3KYdDQet2lCrJ1
gIaEuvqJZSROp/b4t3fhJ7TOyniNLvbVtCrh6201mh3CvWjsX5vTcRBF6sX33GNtPESPbHXA
neLKHg2ZjGKvb6zffYGEHumcGUmTa8caHdSWZnzkzVxMfaxoNM3kG5HXp8S2pivSMfnaboie
+HsAAAAAAAA=

--------------ms080100090003000500050802--
