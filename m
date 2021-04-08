Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6140C433B4
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 15:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A07161132
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 15:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhDHP2W (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Apr 2021 11:28:22 -0400
Received: from mail-bn8nam12on2121.outbound.protection.outlook.com ([40.107.237.121]:58113
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231630AbhDHP2V (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Apr 2021 11:28:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMBdFn5+47f3c63Gifsk6StC0iBOIKp66OKmcM6KNT+1bSfqtIwcaeSj4NzvCeWRUOeEu13nvw9stZb114QW4Njd6uidJOnez+9Tqwq77/RhGgE2Qx3WxyXhjOpkkzsj/+5JybhaD1TRmLU0X9MZMPbMNlBC3vT22RADF4yOazitAQTuRDbSNFujzSwUjBQCCQvTbxx2z3CMK9yu2/6nb07vGab7JSpkLd6xplyUQuSEsENtXh8nN245p0ZL9pfPIrXrplNYYfnt5o+b1tbbRYFDMpMjBDJQheXBsZZG63B7mKSGZjMCB2WEVIvRoDDmmmyOpoFsSGUsB1OO7uYgww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Du9VkxET0U0ouS0RKD+RK+0P+3dPuLfCbKiOGz4JGns=;
 b=d0S8H9dbUaL9taLXGUl8bVoM5HR99jmaZCZonsD+fCuXs/wyKAZjUf/G43LNspe386hKbxvkZKLKDpex1/BWNZ6S7mlYdggtAjrxZgKeatxyd//+gHDygDSMqdZSEPc3jqBbWx9R/MLEMO8aXjxx7L9bvN2QAW9DWUljQTK6ej6JmKfG725n7WK97+DtOhsz5JjcthRAQ6HIFwRmiAJqy5KoI3IAURKN+bSdn5c7YMk0jIQEwjzdQgQMdcJaHGwReiz/RW3wSccdegJK6P+P8GS+EykyKxPgnNoOZSZ7gBskFK87nvgvuhgVOwZCa40o9Fve0eR/HgtYj3ndE+MpdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Du9VkxET0U0ouS0RKD+RK+0P+3dPuLfCbKiOGz4JGns=;
 b=W+RIHDoYH6p85eZLEp6uQOamelrszuFaU5XGgqNs8DcoPK23Dq/36Yaro/Pxunhdxxjg1IM504/lxfLx76/nGRr02CndABAzyIRDYZseoZS6yAVxHAR/HNo9xHXBDAxHCsVRW2NXPIYYsbOpVVIjxOX3g4M1ufc1unpxzQaIKTc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by SJ0PR11MB5168.namprd11.prod.outlook.com (2603:10b6:a03:2dc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Thu, 8 Apr
 2021 15:28:08 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0%4]) with mapi id 15.20.4020.017; Thu, 8 Apr 2021
 15:28:07 +0000
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
 <3a8cec45-87e6-9192-e556-2f3c85ec16dd@fortanix.com>
 <3eaead9e-e197-4bbb-5666-a6fb24b2b349@intel.com>
 <619aad50-073d-b0a4-6dcd-3e222166c4a3@fortanix.com>
 <1eec29ab-b979-7919-677b-2cfa147c4c61@intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <2c38deba-47c1-2800-1215-a3a12cc06316@fortanix.com>
Date:   Thu, 8 Apr 2021 17:27:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1eec29ab-b979-7919-677b-2cfa147c4c61@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080205090505090008070807"
X-Originating-IP: [213.127.124.30]
X-ClientProxiedBy: AM4PR0701CA0015.eurprd07.prod.outlook.com
 (2603:10a6:200:42::25) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.30) by AM4PR0701CA0015.eurprd07.prod.outlook.com (2603:10a6:200:42::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Thu, 8 Apr 2021 15:28:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d355b8d1-bb5a-429c-f39d-08d8faa2e91c
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR11MB5168DEAA58B2F0D5B21FF636AA749@SJ0PR11MB5168.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yK1thGOqaYzrXV/0HRfZjE5Ldgdt0MmPWpPyg9xwAH/B6A6L/jmGek4LPncs52dpY2f+4mPMon7l8Q+FYPMJyG2RfKPAYienmoKcdE341M2FeZKyzUai36OpcQGt3AWDhxfEppo7819ujSG5WZMGKibZrX/y5lDGstwEyRI7PeAdPsViSGOBk4J9X9hEaxsAGOw+SjaUbPiOzPDtvqby0ZRIl65ah5EsCf/CjErZ8OeIlxry46f8HwnY0aCB0pfncwR0bKq0R0caMSO0Vw2dBloeUYeuy59pHIi+vUEDanOEFpxEuiHzW6u4pfBPUoNWN1i/YiLN9pYwr+tepFK8C+vABPEVWut/r+rtskw77IrHp0MNpM+VaZK/BrmPUqsEHELknAWPu/R1ObVLBx+qAiX2KEmLBpJnhPj/vOVHBKybHcDrVs6YtRDH3Nybv4Mmw59giHvJiI9NwpF0oRb66sPptxMu4tFhRkxRyGgCT0qS4KIKCF3VL7oZW40lfEK5flwMQcUHNiXuqs6RQA1Q+5xU96987+hZ+bCzrLLk9WOU9/8a9YrwXVJ9IwObOLcTMs19CkgfXtfTVfAXQjwPj5ha2kXYxFR2yvn6Yps2DunsLNjdDcaB65fQnSCLbZ3IV+POGzdfQ1r5gzRf40n4qB7iu4mB6lqBrCB1IbpqE9bDj2IoZAofhqWE8zRXbtKJdNE3rQifGrFVrZ+Ak+bFoaCITvtrIs/h0U+StTHUa3SHtesB2sPTlBgQGvodakmjrmiTePv6HOrtLrnCNBfZSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39840400004)(136003)(396003)(366004)(316002)(5660300002)(36756003)(31686004)(8676002)(16576012)(235185007)(2906002)(921005)(83380400001)(110136005)(956004)(2616005)(7416002)(53546011)(478600001)(66946007)(38350700001)(31696002)(6486002)(66556008)(33964004)(66476007)(26005)(6666004)(16526019)(186003)(8936002)(86362001)(38100700001)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UHJlMjVpMXp1SEs0NStYN0I5TlRXeFZxL0ZUaUNoY0EvRVFrVlFXMjRqNkM1?=
 =?utf-8?B?Y3g4WlBxSEdYNDVvemp2bnNZV3g2T2gyMW1MUjVwNE9lTmVuMVd0Z1ZQK3RM?=
 =?utf-8?B?VUlQNk1rd0RvUnEzSUdQRFozYWFrU3htWmlGTnBjdTh3RUs3Z3pLcjZNNnhY?=
 =?utf-8?B?NHNwaHBob2JBZ0ZWKzFQTCsxT3hJMmZiNGEwV0ZhNDlzVXFtNHFEUUtieGRF?=
 =?utf-8?B?dGFReHZrZlRseUJnYWZWemh5ZGV2cGdZYTllTUVVN2hnb3Y0K1VPWmpKb2FD?=
 =?utf-8?B?bSthWWdDejNKOGJyanNqNzk2YUFycnZsOGZBajZXeDVvMlNBRy9MNk1xbG9B?=
 =?utf-8?B?LzA3VTg1N2FKNDgyK1ZPNUlBMHI4SzRzNXNWRUtFWEF3SVRxOUpuV09zRkcv?=
 =?utf-8?B?M1M5VGJVdnpCTVVxYis0T3ZydThaSmdsakttZE9BVWJMaGQ2WTdlTFlSMW5J?=
 =?utf-8?B?ZTZUWVo2SjUzby9xTnlpUGRGQkN1alkrcE15QzlBVDZLVXNrait4WEJlT3BG?=
 =?utf-8?B?R2N2bk5CdENkUlNSRUhjK29DaG91clk4UWZQaGc4alhGV2JaYWloOHBIVkJu?=
 =?utf-8?B?SWNuQkNSOUFnVmMxSVM4bmh4NzVzVzJvM0pzN0g5YlEvajBrU3JHQkNUT2Zx?=
 =?utf-8?B?UjdoOUJQSUl0OHNIdFZOQmxRcTV5dnQ5bW5YcFNvWlZpS3pPYXdOeHE3OVI2?=
 =?utf-8?B?MHcwMmE1YnlTWVc5bEtCNTZWb21MM2xDZHBWU29iSzJTVElBNE90bGo3YnFS?=
 =?utf-8?B?alZnekJWU3pwQk5oR3psT0pQcHlydG5aWkk5elJtck85dUpnVEgybDhXMEt1?=
 =?utf-8?B?N1I2VWlKTjZ5Tng3dXBwd2hkWUIvS1UwVWNmYWJyNFlvcStYRERLQUNTN3Fs?=
 =?utf-8?B?YnNDcU9HWGlmbmt6R3U0bWx5UVhzV3owdTIvaWQxSXpXUk5vZkZTRVpiZnRN?=
 =?utf-8?B?Yjh1NU15OE9mS0g4ZHhTdkIvQlFuSnF5T283cDJEMGJpblJhNmFKaXgvTXFO?=
 =?utf-8?B?eXYraDJXSWpDUXB6VlhCcFhqek5jVWpodExGVGFPVFpxODcrMWNnazJaell2?=
 =?utf-8?B?b2p0OE41QmVOSDBHSEphLy9tY2h1Vm5mNzdhZDk0dEt3M3BxbjJKZlZCZFMr?=
 =?utf-8?B?Mm4rSWRvSGdCazVDbDZNMmNoQ3RXZVVyTElVb3IvZkdZUk83eWRieDZoNEdr?=
 =?utf-8?B?b05rZFhja2xObFVoemFWUEFKQnl2QjVlSldjN2pzdW0vVGNwbWJJdkdHTGJV?=
 =?utf-8?B?WEZYRi9rUXY5cnZJSDJJVXlPRUxCNnordTZUTUhkNUUrTGtPTGtyeFdNNklV?=
 =?utf-8?B?V1Q4VlB2YitMMnRjVkdNN1dQa3RET0FNVS91UVZmWndHU2FVc3U1dnRmYmt5?=
 =?utf-8?B?RXozVUxOMkphcmJsQnI3UU9zQi9QcEJ4NE9UODBQaVZ6S2FIQ3E5SzZMNjds?=
 =?utf-8?B?K2dYS1BQVjV4azQ5MVdtVDV3NHBFbStZV1BnVFJCT2N6YUxudlhUbWt0NUJ2?=
 =?utf-8?B?ZmN3cUpvS0tHZ2JXMG43YnhwMFA0cHpNa0h4dlBGcm04V0FCcTlUVFNLUW9H?=
 =?utf-8?B?Ymg1a2htcVg0TE1ZWEVYWEIxZXFjRmkwQXVRbysyQ0tDeGVqUGk5d3RHWWNP?=
 =?utf-8?B?VWoxVlJHQWRwNUpGZVRLS1h3NDNSaFBVOFcxQmdsMWI3KzFFdVZuN2syVHFp?=
 =?utf-8?B?MDcvaGNZMHhjS2FBWStLZ2FlQVYzblREM2hxT3RUeCsvNEVmU1hlMXBaRGlj?=
 =?utf-8?Q?vt0dRnd88lHPMhk4PBrcJwLwt1CuI2V1Voaj6pj?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d355b8d1-bb5a-429c-f39d-08d8faa2e91c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 15:28:07.8648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vM9NiRr8mMU3y5KjbgR7Q4F2Lm1mbdyTeSgPcCcUHXH/nypDI+cVrMk9qyUeQFQdPeJZckfB+8GOY13c+QFm0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5168
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080205090505090008070807
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-04-02 22:48, Dave Hansen wrote:
> On 4/2/21 1:20 PM, Jethro Beekman wrote:
>> On 2021-04-02 21:50, Dave Hansen wrote:
>>> Again, how does this save space?
>>>
>>> Are you literally talking about the temporary cost of allocating *one=
* page?
>>
>> No I'm talking about the amount of disk space/network traffic needed
>> to distribute the application.
>=20
> Am I just horribly confused about how executable formats work?
>=20
> Executables go through an SGX loader that copies them into SGX memory
> with the kernel's help.
>=20
> That executable can have *ANY* format, really.
>=20
> Then, a loader needs to read that format and turn it into data that can=

> be shoved into the kernel.

Sure, you can define any compression format or conversion rules between e=
xecutable formats. But the native =E2=80=9Cexecutable format=E2=80=9D for=
 SGX is very clearly defined in the Intel SDM as a specific sequence of E=
CREATE, EADD, EEXTEND and EINIT calls. It's that sequence that's used for=
 loading the enclave and it's that sequence that's used for code signing.=
 So when I say save space I mean save space in the native format.

Not EEXTENDing unnecessarily also reduces enclave load time if you're loo=
king for additional arguments.

> The simplest way to do this is to just
> mmap() the executable and point the kernel ioctl()'s at the executable'=
s
> pages one-by-one.
>=20
> The other way a loader *could* work is to copy the data to a temporary
> location and then hand the temporary location to the SGX ioctl()s.
>=20
> Let's say the kernel *REQUIRED* page-aligned and page-sized ioctl()
> arguments forever.  If an executable had a 256-byte-sized chunk of data=
,
> all the loader would have to do is allocate a page, copy the data in
> there, and then pass that whole page into the ioctl().
>=20
> In other words, the loading restrictions (page alignment) have little t=
o
> nothing to do with the format of the thing loading the executable.
>=20
> But, in no way does a kernel page-size-based ABI *REQUIRE* that an
> underlying binary format represent things only in page-sized chunks.
> Look at how many page-sized executables there are in /bin.  Yet, they
> can only be mapped into the address space in PAGE_SIZE increments.
>=20
>>>>> Does any actual, real-world enclave want this functionality?  Why?
>>>
>>> I didn't see an answer on this one.
>>
>> Yes, we have enclaves that use this functionality. They already exist
>> so they can't be changed (without changing the measurement) and we'd
>> like to stop using the out of tree driver as soon as possible.
>> However, we are not able to load the enclaves.
> OK, so please give this series another shot.  Please explain why you
> *ACTUALLY* need it and what the goals are.  Please explain why you can'=
t
> just relax the restrictions of the existing add ioctl() to take
> <PAGE_SIZE arguments.
>=20
> As far as I can tell, there are only two coherent arguments for this
> functionality:
> 1. It makes the loader simpler so that it doesn't need temporary pages
> 2. It would allow old enclaves created with non-upstream-Linux SGX
>    implementations to end up with the same signatures on these
>    implementations as upstream Linux.
>=20
> I find both of those pretty weak arguments.  Doing #2 just for the
> out-of-tree Linux implementation also encourages folks to establish ABI=

> out of the tree and then foist it on upstream later.  That's not super =
cool.
> But, I guess this would be nice to the folks that have gone to the
> trouble of building SGX enclaves for all these years with no upstream
> support.

Linux doesn't exist in a vacuum. People who write SGX applications write =
those applications for SGX, not for Linux. For Linux to claim to support =
SGX version 1, it should support all SGX version 1 applications. The curr=
ent implementation is not SGX version 1, it's some limited subset of it.

The cost to Linux for supporting all of SGX version 1 seems excessively l=
ow.

SGX defines lots of things and you may not see the use case for all of th=
is immediately. No one has a usecase for creating enclaves with SECS.SSAF=
RAMESIZE =3D 1000 or TCS.NSSA =3D 3. Why did you not demand checks for th=
is in the ECREATE/EADD ioctls?

>=20
> I'll try to look at it with fresh eyes once this is in place.
>=20

--
Jethro Beekman | Fortanix


--------------ms080205090505090008070807
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA0MDgxNTI3NTlaMC8GCSqGSIb3DQEJBDEiBCDm
0fqHfTKC2pRqg5ecPjKjXI+DR6kTPbwk8sGJs4Y9KDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBABFQsI//NzPxUz3MKBKXMbgrNREDIKHyOysGrsL0lHpFo1ZQ3pN3
xk1tBKUMf2ejrLaYBMQreQF1/hBQrBphFVh1Q6Dyn5wJ63Te43Qci3Z08LF44VuOsnwE3jS3
3sqfARhG5vMd+JHcMsM0pzpyndTs/ssmz0b5Rnp1hc94Kx/Z+f1m3+Hz1ogE+/FLG+DV01L8
t9NkkHIMOu+9engtTfrbmA1YMgQXnDh/nLpyNp5av3F//hx4eiPLRlqiZGoCUGfxsJNkNbX8
UEOQdY3TVogmyT8n7FINFzctj4wEuV9RGsXvHh+0tIjg/WPos3Krjn2wp5Yc7otFmKnWWlNC
jRoAAAAAAAA=

--------------ms080205090505090008070807--
