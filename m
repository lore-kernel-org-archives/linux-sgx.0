Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60223C433B4
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 15:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30A0E6113D
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 15:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhDHPHp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Apr 2021 11:07:45 -0400
Received: from mail-dm6nam10on2119.outbound.protection.outlook.com ([40.107.93.119]:40768
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232058AbhDHPHl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Apr 2021 11:07:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuoOFtFX4KptUIIZT1a7zpe6E2UcLUzzOcy8CYcJqn64IiNy1HngNr9zdrw9L85F1yCrsF0/eq0GqdnlnNO1donONoaswZ0YZJ0SsvCggWQASLiH5dHbEogAOT2D6+WP91KOaMGzpDAlr5BIp165JsuO86l80jqQukeacCHXRfhFvycpFfkJKSW1bM2kY8ozJSZjOfe+DX4z8TYrcJj8n1wqYCp+ARK04ymsnuyPlz6dEavsFkqwE97IZTDoiKFQF07Ul9WXy2cirOdvPX59AtGM/kgcpE4i9PJx8wxQPl2iDF1lEnVdCCC6+O38psJ2IzjiT7jEqRJHlUlgoeUQxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bn0XeTSMn5qM8GcwhOj0nrMCgm/pb2+eedUOdjLVb0s=;
 b=DBHrKFEPM8v35eYtAW4NI7vWDmmqAKacz1fIKQmxOOcixrQr94uNqyYU+LFL+PIA3sFT9oX64bCFRNcfYr2cZvVkNLApzt7w1d6cERBOWBSvFgua3m3WhfIidzjuO9jPEEuNWWILYFmbkBc9fWuiE+K113hFE/XXRidww5XvucqmY1NgNKQf9LdHLXoIf8eUryWltnv2i37ZVVm5p8Jd6WA0K4MlUp1ACRs5+LnEj03GWb8j+/K5vw3Cs3wZ5VhiF2Om8DvSyegXJBNwmJkAYoOsBmTn23ihVsajRGU7OQ29MEq66gs7yBR7fMPeQ3jUUbeOzBYpXEnIyTeI/2ngxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bn0XeTSMn5qM8GcwhOj0nrMCgm/pb2+eedUOdjLVb0s=;
 b=JlBJ0gTqTqGLdYLrXmWhmvSTPwdx8/Gf6RBJq5ODOkGoV18QN132XyOzc2CgJgqPXQXZM3Q3meouMGlXbQfYcqweTk1S7Mq8BBD4+EXUW0Pdn4zdvSEz59x/Vg3Iw/SlygRpmkEwfpZ3ubEGBC206hHD6YdesZ9bZJGxkRXJuvw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4008.namprd11.prod.outlook.com (2603:10b6:a03:186::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Thu, 8 Apr
 2021 15:07:25 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0%4]) with mapi id 15.20.4020.017; Thu, 8 Apr 2021
 15:07:25 +0000
Subject: Re: [PATCH RESEND 0/3] x86/sgx: eextend ioctl
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Raoul Strackx <raoul.strackx@fortanix.com>,
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
 <YGnjgkAQjiS8QcS7@kernel.org>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <7c93136a-3906-e225-3007-ebf13569ab52@fortanix.com>
Date:   Thu, 8 Apr 2021 17:07:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YGnjgkAQjiS8QcS7@kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070205080703040205080807"
X-Originating-IP: [213.127.124.30]
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.30) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Thu, 8 Apr 2021 15:07:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b518881-aa91-4764-0678-08d8faa00453
X-MS-TrafficTypeDiagnostic: BY5PR11MB4008:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR11MB4008614E99111A0697831B52AA749@BY5PR11MB4008.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +E2ymadZHq4vMg8XmU6N/UH2hqkd9/8ONNxldHfzeua8EBrz3lvMkBvEFjK92RZn4ttMlCTm6a1pKQbbfGrrqO5bs9DErZg8Qp2uRG6VfzCq/Uxplxfw+uDFmG2wqRCfyEcBdDDvu8clOD4dfww4onjK/HMvwAvLsOp45cJg9nFGSCVP9ibQ6i+PDLBlwJJprorSjsC4rx9Usu5SYgdfk/WMNsJXd4Y2oDSLkYOW47x0es6tifOtbJq3dUWtS6Fm9jLhf/Qn8abDLNZxH7WWUdgqYhJfl3pg7+i9lP+yd9CSVSCEC/a5M91EbkbMwGJfWOHE9J6PYhn+wPtGwRJHA2l2BK2jW+DCYMDlw6RBQYUupAvEyuU6SCnwCojzN45PdBx2HrbiQk9SdUBYLBNL5WzR6uBZaFrqCkMTCxUcyt8LVBSeZj4pFOyqBdthowSxBb9XIdELvPEMHlpI8dE1N5kaq50q/O0EEPTVuRJSkJinw3hSrVaj6MZ25F8vKykdlB/QIsrmBCw79wQFRCDYGNcc0agoP8/AbjrWc772aaU5CuW8igIRjiKxS0vwXhF/WbFjV+Nd1J5GlP/HgLFCFOFUDaUr7pnuTJm7Em/FXvDjuZ8H8GkkJwE9cHjiPfYy/y00WypEvFnF1W6kOv3QjiS9fXBIZbwj4Pa0KuieFWqJoE2GbOBOey+jVraSUMV7/677r/vJsfGtVpESGklRgfi2FSiO/tm4hZdjz+lumxKY7QYFVq5uyBMuf+x5klnQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39840400004)(136003)(396003)(346002)(376002)(235185007)(6666004)(38350700001)(5660300002)(83380400001)(38100700001)(6916009)(86362001)(478600001)(8936002)(66476007)(6486002)(66946007)(66556008)(53546011)(4326008)(7416002)(33964004)(2906002)(26005)(316002)(36756003)(31686004)(54906003)(186003)(16576012)(8676002)(956004)(2616005)(31696002)(52116002)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?REs2Qmhwa0dyMzd2L0s3SG5PWFBzenF2b2RETE4wVVU0VDhQcmoyMjAvNnM4?=
 =?utf-8?B?N0VFNUJjajQ4cmZCUXFWWS9MV2t1MUdvTEhCTVdDUmdLdVlvZmNiRzJOSmRG?=
 =?utf-8?B?alVScnIyaDZBT1RreVhlRjMrWjRMVkU3bXRLeEZaVUkzMUUxWFNSdkhoTnF1?=
 =?utf-8?B?YVhWcityWkhvNS9IdE9abFI4aXg3dmIvUUJaWDl0L04rM2M4bkI2MUthSklQ?=
 =?utf-8?B?TE1rU2wrb1pkWWxNUENDVUtDYk1FeDc1Mjl3a29leTZmb2FKcEhocldmcnht?=
 =?utf-8?B?MUhDSitra1IxMDNWNDgzTEU3dzQrZlRnNnAwWHkwWVhObk9JK3ZVcitjM0tq?=
 =?utf-8?B?N3g1dlVnV2Fqei9JOVdIblZpY2xJallvZ3ZOMWNJK2xGSDZDbEZZY2UxSWlS?=
 =?utf-8?B?WU9jbmEyRlhQVG9Cak9GYk5LcUJBbjU4azZ2SDd0RVdrQ2Zoa1hvTDVUdHNH?=
 =?utf-8?B?bnF1V2tFM0c4bkpIeHE5djh5T1QwUk1GWVhiWUVJRzFvWGZnZEN1TzIyTUxS?=
 =?utf-8?B?RHBDck9RdXBjYnNUTE9VNzZGNS91UjRuQnV6QjJDZ0tZWkF0ZExyYWpVQVJP?=
 =?utf-8?B?VDFaOGtrSEdBUm9MeGlvRUFYUnZySm5JR2tXT3RjZ1JnR1FPYlduZDdnVUsv?=
 =?utf-8?B?Y0hHRGVaS0tLWmRvSXNtTHMxUzVIQTF3UlZjL2svN280Q01SakNJMUd6d1VL?=
 =?utf-8?B?VVhSbGRvdVpDYlBuU3pmZ25TV1gzd2xjcWw3MWlQYXNFWGoxWkx5VDN1aEVk?=
 =?utf-8?B?d3VtYk9BU3VjU2dnNjc2OXRIYzNsazE3NVpwbllObWNIZXM2SlFkeDM4MDRo?=
 =?utf-8?B?Qk8xQ3VBY0pYWkQ2RFZSZjNDWThLRkdYNG5WUlhOUjBaamlXc3EwVTdKRDhT?=
 =?utf-8?B?WVlNUDZYS0VYZWNaemFVL0VGcW5UOGdlU1pra1NJMFg5T1haUWZlb2NieVpE?=
 =?utf-8?B?eWxHRThOenZxOWM2d2hZOWdzMzI4MlBKYzNiRzlFL0NHNmlKQS9nUGZ2c2dk?=
 =?utf-8?B?cmM0d0p3aVMvQXpueGVTSHdlamJaRDJrTXJiajVMVTZ0TGtuanZvWUhvVk9a?=
 =?utf-8?B?MzdDN3B6d2ZDRzdXMDJtaHVoTXU0ZjhhSU5EZzdsSEhXWDY3ay9uQ2N6bDJu?=
 =?utf-8?B?MklPZ09kTlVNRXJFb0VzS3dINkdVTzlja2hOb0NDeVJYUllEaURVbFl6dmx3?=
 =?utf-8?B?UHBGcUxYWUJpMWdpT0ducVFRanU2ZWs5eUZIby9UMHZXOHFUUE9TVHBPRVlx?=
 =?utf-8?B?amhoNTBPcFJRM3MrNVV5YXZLQVl1bm90N0U0STF5cnBCVUQ5ZGo4OUdGeERR?=
 =?utf-8?B?NXdaRkthczlVK3RFbUt5WTlUeFEyS2xGUmsreWxTS3cwVzE3ZnJvanZpQXBG?=
 =?utf-8?B?WEIwQWoraitmQUdwM0VBY2xOSFF6U2g1b0p3VDhtMklCS2ZsbEEwYXZqdDVV?=
 =?utf-8?B?dzBkTUh4Wm5VVjlUdDdlUHozSjZZQXhjbGZLZUlJM21hSXlVQnphQ2RqWDU0?=
 =?utf-8?B?MjN4Q1g3d3I5T0V0YVNlZVhBYktRSU54d2U5aFdIVHVHNnBiemt6VzE4WG8y?=
 =?utf-8?B?Mk9XNXpxRkNMS1gvTzROSStaY2YwY3FmZWs4Um9Lb0xveVpDVC9acmVWQXl6?=
 =?utf-8?B?OTJtb0U5MzRDaExMbDBqZE5MY2hadW4zTG9kOVg3STRmZi9uMkRtY1JCK0x3?=
 =?utf-8?B?ZmRtQnBXdE8raFdraTdGK0xTRDBzbVZLNlhjUlU1QTZCMDZ0SUxxbERuYWwr?=
 =?utf-8?Q?8IjEbBPZi+Cq7TuTVdKL7GAw9giUBMGWCK3X+am?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b518881-aa91-4764-0678-08d8faa00453
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 15:07:25.0354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWL5pOGrV3na9IqR53lESF6kpLZelbwa7CLH6t3MGKHq/NF6FCHcTKG0LemVpEMZQjLngAXMlUwGxfBGQJK8rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4008
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms070205080703040205080807
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-04-04 18:04, Jarkko Sakkinen wrote:
> On Fri, Apr 02, 2021 at 08:31:19PM +0200, Jethro Beekman wrote:
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
>>
>>> Is this something we want to support in Linux?
>>
>> Why not? Is there a good reason to not fully support this part of the =
CPU architecture?
>=20
> Yes, in generic sense :-)
>=20
> If one would disagree, that would be same as saying that everything sho=
uld
> execute in ring-0 because that only gives "full support".

How is that the same? Please make an effort to reasonably interpret what =
I'm saying.

--
Jethro Beekman | Fortanix




--------------ms070205080703040205080807
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA0MDgxNTA3MTdaMC8GCSqGSIb3DQEJBDEiBCBo
vXprtUnVvsrgTNdeAo/d/VoSDohygd1gFfcm/ejiyDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAEzxHNQcQUpXiegdbNVxNmg4MOGLaXUsNUn6bPeuTPELuZhit6Kz
wHadqHadZgPpB2FASZYQsLVlUVuIp3DG974eC22i48RIF7LTWTOSTHDp/+77JDp0LvN+aKQI
uexGuN1QIJhuL0jl92WI4ni65VYBigRzjvLDwzJYP2TgINLRvrkBtIhBA8IW0sKiQaMowFcI
nypOoc7+stmdm3rt6kYxZpSfzv//qY7VFYdC4gUlh0rFi1gPfFk4oURoRz/CS8ozSgWRDXsm
Fa0p7Z+IoyNdxmqyH1mlzYT57Wg3oJTcr16g3bUbUSs/8B3tkPNYHODV3egtsZrMKSLVUas3
crgAAAAAAAA=

--------------ms070205080703040205080807--
