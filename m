Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD54C433ED
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 20:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FF4761177
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Apr 2021 20:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhDBUUw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 2 Apr 2021 16:20:52 -0400
Received: from mail-mw2nam12on2090.outbound.protection.outlook.com ([40.107.244.90]:26017
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229647AbhDBUUw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 2 Apr 2021 16:20:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vd1qH3CkeUSD02VB1z9iGmJ2lg6GTLJgoQvfr6t4EihcHGAwA4O1yJggRyxSbBoxTL3UTwOmwElbHDnZ6ZvARoW8hTbtofoFySilHDKIuQqZTZU5KaZS6djdFzWUFhUjoxoWcbB/047fJsx2uLeId+3grFNsuWRoHogIZHY5OmnaPx+05LvDUCUrj4zdrdrGggvyDhhlrEjzZUwX3Ggcs/+LD78v+uifhov/tSmZqRLQl3fPBajORE7adc3AKKMY0TL2SBCnIZ2iPFLeoUqIvURNB2PhflOCBK/g5h+NgQiNspKfW/OjxiKIuIB4G6Tj1QNXq6zuc6ZNnuMAlxuAGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtnxpyOGPjHlSZvShZnmP4CMcQ7U5/kArjbtLa4rFrY=;
 b=BcKyiouftbvlF1EhPYxgJk4Cp0cWpDvky/ZQv3MG+h1hUncXPKlTZl5ORQsA6rmxKeJCt/lxdAE4H7od9Hd2BwgJnqvbErln2iqRTXTgS7KcWHFZNslgcjajqV1NiyHYxsOIQ5pNfy+pZYGHZzK6rhO8dQ8ZAi82W/MHwmAfeDSQc10IiqCy03vxM+oJmQFJUd4RJZJbqy2FdVs2MR61lbvh56GTMk9WdzI3dbr8t+vRxzPQ7JCHXtVs7DpAvcDF4W/6fQPbiZxfYGFNiuWPGjbeC7UctEF9Oy4reqedNixGSGPniaVcMRJKpo9Yf26PMbHFCbIVyoJ06pekqIVXyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtnxpyOGPjHlSZvShZnmP4CMcQ7U5/kArjbtLa4rFrY=;
 b=pJpj6uUEMil2MhQbf2VdtU7kr01FA7aUMdjOT5IXUDEv28VuuYKCky25GJO5037Q0hQECHRtELwIeZk28bjCkALWFc3thZzvUaOw2vlPIbceA09cg8n1tIuasP0rWm/evOHmlToHaZcffBBwifVdoRgN4tS6o80VykgkFK5dc/k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4007.namprd11.prod.outlook.com (2603:10b6:a03:189::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 20:20:47 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0%4]) with mapi id 15.20.3977.033; Fri, 2 Apr 2021
 20:20:47 +0000
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
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <619aad50-073d-b0a4-6dcd-3e222166c4a3@fortanix.com>
Date:   Fri, 2 Apr 2021 22:20:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <3eaead9e-e197-4bbb-5666-a6fb24b2b349@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050502070008020302040400"
X-Originating-IP: [213.127.124.30]
X-ClientProxiedBy: AM4PR0501CA0053.eurprd05.prod.outlook.com
 (2603:10a6:200:68::21) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.30) by AM4PR0501CA0053.eurprd05.prod.outlook.com (2603:10a6:200:68::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Fri, 2 Apr 2021 20:20:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a19f078-61c1-4c54-0251-08d8f614ccd1
X-MS-TrafficTypeDiagnostic: BY5PR11MB4007:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR11MB4007FD552819C2749212258DAA7A9@BY5PR11MB4007.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q5kQ17cd4FowpylAaWF+6KKu5XTjnqFUCXbSMd39rCAorq27GnbWrTTolokVS+CQk6XS4+o3QUelr2dcrLwKDHB4Vg232Md8Ex1AkDk9y0ioZeYy9eDgmRVjEBYqvm/Kb8bEgdywjXmUBF4Q8jqV6gZEkOKGV6DEkhLDD/cIj4Z1Zf5OxKC9O4/8mnIxnWqRIu6xh+gvH5LydoGPn/YsCVq3MCqo2vGlHPiAwOUE0IbnKWrM81+IuOfriwc/XQVROzepiO39y3JKboHvFSeSUmvLYslaQO3CWNIEbgkWgKNNmzyF5t99vuaP3Cg+TLhdYfYSHSo3vDxO799tzJLwDkR0vrsBowTa+chmI+z9iHDONdLHXkTpZVi+mrYsErV/GuX9plQGlsot328CiWxAbLo0icWxT4zcFaJQ+WL35GSZL+pDDndBSNkuTzxWemrzJAI9a/kStZ19JUDseHyRua21oVxr7O+MeoduIY/JDcX+U6NYJncBWmlBr47pVm7Bj3KOnqYy8gSXBHwApAsL9M7OKlY7tHiPndjl77cj5PY6Wf+7hzoVL/kJJnj8WVNyPXy8XfikUETNCjDlvBsbzffwMYdVlWHxipDv78KarsgzO5C0AiC4imBrvMsaE1V0lqEp3e+nHNH7rJArKMuav3NIPw71wIay2I491SfTlqlgcPLmYdWY5kvTHX35WV54Xu+G/iEE1iyFH3D/v7Euk+zT0fhxS9/vNZVKw4G3CuSUz9Ra+pStxZY8Agz76FwzlvekO8tIRb/tndIfeBiLwI5W+hCAj0HiNiQd+LnoIBWH1wsFAT9cs6ohpYDiERT3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39840400004)(366004)(376002)(136003)(396003)(6486002)(110136005)(2906002)(16526019)(83380400001)(8676002)(26005)(8936002)(921005)(316002)(16576012)(186003)(38100700001)(53546011)(31686004)(478600001)(2616005)(5660300002)(966005)(33964004)(66556008)(6666004)(7416002)(66946007)(66476007)(86362001)(52116002)(235185007)(956004)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RWh0L2VjZUovTnc2RVV1TWQ2MEI1M2NHcXRJMFphaVZob3BnSWY3b3RibGRY?=
 =?utf-8?B?UnllM3EwRkYrbGN6OEVMa1Bic0xhZWRodkM2QmNDaHRCT3FGR3dRZWhVcWtT?=
 =?utf-8?B?S05aZ1BTaU9UeWRXRjRzVE1PVWVSZ0FpU3hncEZWemx1UzJMSG1kZFFIYW1q?=
 =?utf-8?B?YXRpSy9EM1hFRDlaeEZCYngyQldxYjRWWWdRN0xNSGZOVHBuU3F0VzNkV0Vo?=
 =?utf-8?B?aExodmNORzNDZFlmRFFucFNteEVGVFgyNmR2cDdBWmpJalU5K2NoeDlFZHNB?=
 =?utf-8?B?S09LQjdxSVFITDdOZkpEeTZGdGtpODBmVmhGQSt6RTZHd29JTGx6dnJBVWdW?=
 =?utf-8?B?ZHpEeG9GNkZRYlF1SmRXdXlaYktLWXV3eFBGS3QzS1Z4YzdZZGdKa2FPdmMy?=
 =?utf-8?B?VkwxdjJBaWpGRWt6aFJ4VDhnbk9Vd1lCTEJoK2J0R3VsRE82dlgrODY3ck05?=
 =?utf-8?B?anIxclhDdCtCc0JEV0dCZ2hOajNZQmtOaCsrZEIzMlMrRkREcVdvdmpxN202?=
 =?utf-8?B?RFdEbE94UVJvMlk4Um4rc0RCb2k1QThRZXQ2U3RpTXc4NG04cEZkZ1pPcFRj?=
 =?utf-8?B?NE5MZlVqcmRqMVBib2t0Y2dzZ1ZPWXo1ZkZXcDdFK0V6OE1mcm9RWUdnTnFR?=
 =?utf-8?B?a2tFY1V4aDkvTUlUU3RtMDFHdjNKM0FleVFEQ0xpRXo0ZjRTRGV0QmllUVhP?=
 =?utf-8?B?blM0NG9ZbmtEZWxqR0dVN0VwWXd3QjhxaSt5czhiQlJxd2lzQ2xFRzMrSFdm?=
 =?utf-8?B?SmFwZTY5UXdFZE9LRFVNdGR2c3RVYXFCaDBvSUlVaDJXWDdmMXYyZ2tqQjBv?=
 =?utf-8?B?bEN0aXJrejA2ck5SNngyNzVudndqdWw5SnNPK0ZmTGhyQ0l0VXUxMXZpUkQr?=
 =?utf-8?B?Qmg4Nm9FQ3NLWk9UQmxrWjQ3REtzZm5CcVhqZmxvNEpHVm9CaFYrODl4bTFa?=
 =?utf-8?B?NnFwTWRIS1FGRVpYUHZUZU1WUkFyYXNVUE9wZDJhMlNkRnA0M3NWK3ZPU2Yv?=
 =?utf-8?B?QnpORTh5dWJUU3ZDV1FFMmNzaEpFV1Q2bWdwUDg0eXlkRmg1M1FpcXUwSVVE?=
 =?utf-8?B?UHl4bVQvMWFVZXNmUnNlb1REcnJzakY0WW4zOGlqbnovVzd5TkxDTzFkRnZs?=
 =?utf-8?B?NVQ5dm9hU1AvY05XTVphUTlwcW5XcW12a2NJR3h1dGIvWXp3ZEROMXFsWU5p?=
 =?utf-8?B?bThsZEZVUktIUlFHZ3JyZ0pIWk9TdGJsYTRZMlZhNEhISGhaSVVBbnVYeHBG?=
 =?utf-8?B?NHE4dW9FNGsvZG13WjdRa0M4c01vQVFGZFFpb1N3bElSN1hCaGxuV1Q3UlRj?=
 =?utf-8?B?Y0sxSW9WK0xTRlkxMml3b3loWW1MRWtHa09aNitnbFN3QWpJYkhoQWc0anE0?=
 =?utf-8?B?ZFJsbzJzVi9RamFvZWZvS245RW9jbDVCVWFuNzYrRlZ5bFlXNHFDakFHemdv?=
 =?utf-8?B?WUFCdzMxeDZ3YnVwUWpyWThTTEptSFFvWHFkaFQ0cjFDbE1qeVJMQ3RGeU85?=
 =?utf-8?B?UUtxL3NtNzF1ZStCWmF4OUJnRnp5d3ROOWFrZUZySVFjQnBLTHY2dUpmNEFE?=
 =?utf-8?B?YzA0VElVNFBqSkVmUVR2cUxhdVFiVDZjWFFKZzNUM05zRUZvSDIyR1I1dEZt?=
 =?utf-8?B?emN1QTViSEpLb0dEMG9YMHlKTkYzaS9oNVNIK2UyMzlQU0QwMnJmU1hZeFZQ?=
 =?utf-8?B?bFNwNnkrb1BxYzN1WG85VG5JOEJMdzJmL0ZwaStoNGhnaUVPR244ZE8ydyti?=
 =?utf-8?Q?AB5Da7wveN4Pm8Uyi44ZUGQXpA+ubas6ebQu59X?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a19f078-61c1-4c54-0251-08d8f614ccd1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 20:20:47.1082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xLDAzswFt4wpWRTqmt9A3fN09P3X6YsDVhGKJkcvnYNFoT7DyAzFP8Sfrq8avW80PL8Cqwc8M+HQr+EwJ9iubw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4007
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050502070008020302040400
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-04-02 21:50, Dave Hansen wrote:
>=20
> On 4/2/21 12:38 PM, Jethro Beekman wrote:
>> On 2021-04-02 20:42, Dave Hansen wrote:
>>> On 4/2/21 11:31 AM, Jethro Beekman wrote:
>>>> On 2021-04-02 17:53, Dave Hansen wrote:
>>>>> But, why would an enclave loader application ever do this?
>>>>
>>>> e.g. to save space
>>>
>>> How does this save space, exactly?  What space does it save?
>>
>> With the current driver interface, if you want to communicate an=20
>> application binary that has pages that are at least partially
>> measured, you need to communicate the entire page (to ensure the same
>> measurement for the entire page), even though most of  that page's con=
tents
>> are irrelevant to the application.
>=20
> Again, how does this save space?
>=20
> Are you literally talking about the temporary cost of allocating *one* =
page?

No I'm talking about the amount of disk space/network traffic needed to d=
istribute the application.

>=20
>>> We don't blindly support CPU features in Linux.  They need to do
>>> something *useful*.  I'm still missing what this does which is
>>> useful.
>>
>> Enclaves can only be loaded exactly as specified by the developer,
> this is the whole point of the measurement architecture. By not
> supporting arbitrary EADD/EEXTEND flows, the SGX application ecosystem
> is effectively split into two: SGX applications that run everywhere and=

> SGX applications that run everywhere except on Linux. So, the "somethin=
g
> useful" is being compatible. Linux has plenty of features that exist
> solely for compatibility with other systems, such as binfmt_misc.
>=20
> That's a mildly compelling argument.  Is it theoretical or practical?
> Are folks *practically* going to run the same enclave binaries on Linux=

> and Windows?

This is certainly practical. As you mention below, enclaves don't interac=
t with the OS, so this should really be the default. It's quite puzzling =
to me that the Intel SGX SDK /doesn't/ let you do this (easily, it's poss=
ible with https://github.com/fortanix/rust-sgx/blob/master/sgxs-tools/src=
/bin/isgx-pe2sgx.rs). The x86_64-fortanix-unknown-sgx target that's part =
of Rust is fully designed to be OS-agnostic.

>=20
> I guess the enclave never interacts with the OS directly, so this is
> _possible_.  But, are enclaves really that divorced from the "runtimes"=

> which *are* OS-specific?
>=20
>>> Does any actual, real-world enclave want this functionality?  Why?
>=20
> I didn't see an answer on this one.

Yes, we have enclaves that use this functionality. They already exist so =
they can't be changed (without changing the measurement) and we'd like to=
 stop using the out of tree driver as soon as possible. However, we are n=
ot able to load the enclaves.

>=20
>>> P.S. There are plenty of things you can do with the SGX
>>> architecture that we probably won't ever implement in Linux.
>>
>> How so?=20
>=20
> For example, the architecture allows swapping VA pages and guest enclav=
e
> pages.  But, we may never do either of those.
>=20

This is not an application-visible part of the architecture.* Resource ma=
nagement is squarely in the kernel's purview.

(* I suppose you could argue that without VA paging the practical enclave=
 size is limited to 512=C3=97 the EPC size, so ~46GiB for systems with 12=
8MiB PRM Considering the overhead of EPC paging in general, that really s=
eems more of a theoretical limitations)

--
Jethro Beekman | Fortanix


--------------ms050502070008020302040400
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA0MDIyMDIwMzZaMC8GCSqGSIb3DQEJBDEiBCC1
P+B0uQ9SOOdsM4NwvWHZfj7W+rp1uUD/gIqFxp8i9DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAGeT7780nSNriM4NqEeo3/NGtVnhtx4F7aKa6g5Ot8iA1xYa++2b
EJVy9gBH3Jo3RH6sumKN1RnvqPBk5TnqQ03SNsDK/cFD2ZrxIVubIxlVMVLXI9cI8sZIF3K+
gZJRCVmSNbLh2tovmTpCIkP2CwjUJ3gbDWoCdS3QBeGFpZNxW083kDQI9U1dOBCD7l1XzLht
oSzF6YQu4yQE8xzWn2tQMWm+oT34B8g/KzWM8GN4JcPVucgDFy9V1HjQs2m17ElY+4roHnu3
o0TYZ/gqybRMzfigMSJCGNYLlkDowj6+Q+ziuFjxDomWp+qZ2/9jpSp+pEoMj88jX+cW1TpL
+MAAAAAAAAA=

--------------ms050502070008020302040400--
