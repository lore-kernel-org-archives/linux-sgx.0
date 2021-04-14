Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC69BC433ED
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Apr 2021 11:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3A61613C7
	for <linux-sgx@archiver.kernel.org>; Wed, 14 Apr 2021 11:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbhDNLBh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 14 Apr 2021 07:01:37 -0400
Received: from mail-mw2nam12on2099.outbound.protection.outlook.com ([40.107.244.99]:25137
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232359AbhDNLBe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 14 Apr 2021 07:01:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1EP1xQBzKx9rmEQrrVNMHnTIIrynurauIuuxvJuArMI2TBbUIcfC3S2GScHd5pQTVZkO7NYCRDED7+tEnS/r6gmDPH6oWx0tgGGqNp/7Bcc8Tq/8Ii3otLfN28EynVBeZgpw/p744wRcwRhW+5zI3ETwfnG7Qb7Twl35+PZpkEe0SHMDotSTHQXELmsdXT3GoKnUuXdoCYCIYUcOofX3yO+Ur+/uyE+H9jaRRDeCWGcMVKqg9Scu9sLwA6QI6TP6fZ7/7s07bevFy3xBvjpqfeUuj/rifW+eNMyQKaaTNMayhaIQk01C2tx2bkHyivC30AWJwWICEv6HObf1vvbgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDf6YBqT4JSQfyCEh2djV+8HrhKuCVCGxDOlw2AfCJQ=;
 b=mux2IIVj++zS78Myar5WIUQS2oCN3Yl7HYARW/pNkh3KWDtWEAh0ZCDuyNs0bSmaoYQkU7tRuDeKOc4vESl/80nLrOptTtwILJEe+H/7LEY046AilYiwJV4mkkgVabhJGB7C4OrnWtDXcZXS2lMB3Lxltv+l1EOc27hJ706oLXSk0+JKUBIDvgHCrlrHPGeSs4QScJbI6hNAavFBDJyEDWc/Bm8RzMuS7CleBe0qT/mD5VC+Z91uwzMJXMDEvuEGLXuQYh8hEHCDSKK9YGJU2kHDTz4kgGcO06//xGaXsLwcdIPenDj/zqdbu0GfRhxMs1QTKMLDtbtOzA1pI3YDKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDf6YBqT4JSQfyCEh2djV+8HrhKuCVCGxDOlw2AfCJQ=;
 b=j5LmZDO0DwP2etP6cPo5kevIusFePQojPTFA1eZeLz51fsvNu4O+ExJEA+P+jZWxEhKWjgnGbteeOwIyyCCoTDQsOAVoxXECUpSouzoyW0Fng8QHwwynN7j5qsdRDLUMX8F4MriT5aAhN4aX2qhWd2gJUcoWVenkPZAjxQTVj5Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB2838.namprd11.prod.outlook.com (2603:10b6:a02:cc::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Wed, 14 Apr
 2021 11:01:11 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0%4]) with mapi id 15.20.4020.022; Wed, 14 Apr 2021
 11:01:11 +0000
Subject: Re: [PATCH v2 0/3] x86/sgx: eextend ioctl
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Raoul Strackx <raoul.strackx@fortanix.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <da7ae1e7-59b8-63db-a9f1-607b4e529639@fortanix.com>
 <YHbJfXqyhtUb1AKw@kernel.org>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <928ded49-3e86-eae0-de87-f570cf477aef@fortanix.com>
Date:   Wed, 14 Apr 2021 13:01:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YHbJfXqyhtUb1AKw@kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080407080300050604040102"
X-Originating-IP: [213.127.124.30]
X-ClientProxiedBy: AM4PR0101CA0052.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::20) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.30) by AM4PR0101CA0052.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Wed, 14 Apr 2021 11:01:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09e48a0e-7588-44c1-345f-08d8ff349d15
X-MS-TrafficTypeDiagnostic: BYAPR11MB2838:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR11MB283842A979003BD20B35A38BAA4E9@BYAPR11MB2838.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0WXT1JIe/7d9FPtICPo4IVt8INn/mp6cSALKRvEFgZJazH5CNjtoP4NeaUDBHC1MsSTb/yBoTBJ8PnJVP/KzdiS5X6YxUfPq0ulTe9R9n3sdUR6W59Gy+8QvEV4WMRDXO2rpdEYQbZwQAqkGrQxNe2xRDAWHKhu4e35QQ1AqZSyY0heDJZROnjmBKnKbJE+KVQDHX4hnYBFUIru1WfxoeVirBbsmVGnYpOZO4KaWUBS3HdVtsSFICZtvWr7M1gIensjTvB9x5bpK3r6waHb0qzbSLwkFiNq5cKz70yAFDQfl7se7QC5Q4ofk6ckJ4F/Y4bYqer3C6Tw6olCGuEEQVLSkpPKxTp6QYOWVSFDZdsLLrl/s1XRqTnB8TpBSAaoCzZQ+76TaEqR5pynbynbXbq4Nkm6p1zanZXZPRKdStAmkRO2IeAz/tj/xOSRlhRu9USzmo3o0Nw2d/HbVUfZ+wEtjEEK2YUklicl9WU+aR3onoBF3wML11OkCyYQ5vMYOnh0pKbRaOf2zBL0dEfl31yYzZi5NnwqrNJ94yqxIQWXPzY8dj1oW28D63MgF0OfPk6zercEmJ/XOi3qV1irRT3HsCeA9uyXY/UcsoHRAyB2Efr+Q9sGScko10QBb5M27BLTU/aM6C+K6bEWcQI7QFJlkvxp82vOCxcxeJFKmcydeWpkU2s5BO+zbPuZgifyaTIkDSFVj5xUfXKnXIeqrATUQ0Ho7uDLLORP6+ESZDpbUf5U/PT8FsZEL45mwxTfFOrO1XkXRAWeFEUIlINqSrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(346002)(39840400004)(83380400001)(86362001)(2906002)(53546011)(5660300002)(956004)(110136005)(966005)(8936002)(4326008)(6636002)(66476007)(66946007)(31696002)(66556008)(235185007)(2616005)(8676002)(54906003)(38350700002)(6666004)(316002)(38100700002)(31686004)(16576012)(26005)(33964004)(6486002)(478600001)(186003)(16526019)(52116002)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WjN3dEJ4Y3JIS3pIMWhZYWNPczY2bS9BTnRtVDE3d2VCeFlqcVM5c3hHNlJt?=
 =?utf-8?B?YlpjZ3F1YlpDYVJZQTlrWDN0a25Ceks4WGYzRHdSdDdZVlpDNVljeE1yVFl5?=
 =?utf-8?B?Q2IwRnhsZGkrNFpDRldJamQ2Z2NzWVJmQXVXOWpUOTREOFdpSksyanZ1QVAy?=
 =?utf-8?B?Zk1qTnIvODlzSitFVjgzUmZ2VEFsQWdBNTdlM1lrK0c4ZVNNT2R2b0paNjZL?=
 =?utf-8?B?bkpVeWJna1BaalREMmpWMHdhdXBQWWJzYndCRlBUSGtQTndsMXorZmZxZVRQ?=
 =?utf-8?B?SThqbGFVS0JRQ2tzT0J0RVdEc3FVb3FjOW42WmJKTERBSmJKZzErSzYwcXVI?=
 =?utf-8?B?a1FRTHdjcm5JRUl3dmpSTWtZQ1NSd0NpNTgwVDJQdndzQXU1bjZxYzdWZWZ3?=
 =?utf-8?B?SWRFS3lvaHJJL2NyaUE0VXR2eXdsM3N4Zjcweno0WDArZ3EzaWdVdEZHaUVj?=
 =?utf-8?B?TmtyUUtPbzlqdXliMVdETkl4dEs1K09IajZ4OCtyRUlvYW53Q0svbEV1aEc1?=
 =?utf-8?B?L0VzK2Q5b1hoRDM4SUpLakVhVnVVbjZyOExDMDZuanZjMVhIS3g2ZktUSzU2?=
 =?utf-8?B?TGtLRGhvOUc2c0ZtZ1krcjBjamhCNXljeWt5MEU1VEhhRnQzeHlIcXEyTzJL?=
 =?utf-8?B?QmsrbXJLVTNMSVdHQmJFbFlMTGE2djFkRFlkUCtncTZldUl6bERZWnFaakZX?=
 =?utf-8?B?cnVTTUx6TTJzRDlHc0JtaUdUVmxaVm8yeUFkSE5kS2xiMC9kN1dPZHYxZ0VT?=
 =?utf-8?B?Zkhnd2EwaUhYejRZa1lsTUtnN2NhWVUyUHZIRmtXcUlVNGpZWk1BU2xRRVh2?=
 =?utf-8?B?emw5T2NTT3FUNEdMWFdNMUZXamYrYzgxTGFWaE5WOE5sNDZyaUhXbHVvSzlS?=
 =?utf-8?B?UmlrNEVaTC9wRDNOdkp6eFk1SXNaYTA4WjM3b3hPUlhJcFdkZGU1MkJodDli?=
 =?utf-8?B?OEs1d01TSG5LOTRYeUViUTdjbndOb3kzWjRyM28ydGJWaTlBMHVyQUgvM0Jj?=
 =?utf-8?B?NG9vYWNqOXVYV2ErVXoyWitjdnBGdlYrbXozcW14MWFyU0tpVlpkVUdQckFw?=
 =?utf-8?B?dUY4dDRjUUoyRjg5MCtiakJGSDhRUStBU3d2bllvTXl3SVdlSWpxbCtmK2dq?=
 =?utf-8?B?WkN5Rjh3SzJNa3VFVE04c0dYOXgxTHhDdlQ2eFVvaG43Q3BGWFBaV29aYWhm?=
 =?utf-8?B?WkxmYVhFUDlmb0lIOXBFN0h0anFUMmxaVGJpK1lOL1orSGNWK2tOaUpFKytx?=
 =?utf-8?B?MElUMTZUenRnNEVjWlFDaWJQRFJZQnRJaXgrVCtnRXlOSCs1aG1EUU5EY2Nx?=
 =?utf-8?B?VXExMFJhRFNpN2huc2FBVkZaWE1VbTBUU2hVc3RDcWV3dGpHMnlzMlAwTCtR?=
 =?utf-8?B?eE5VV1lWeHcxaUh4Nk1EZ3pkL2tpZUFzb3NBbVhXNW9IR09rSlFmUXdXeVF3?=
 =?utf-8?B?d04ycVIwWW5PUHIzL3pNbllFdHpiaDF2TUwyaU5vWC84M3RDeE1KSWprSm90?=
 =?utf-8?B?b2tNYXB6WkRmeUQvbVRkbkNDNGUwN003S1YvdGJQSFdXd1pSN0FSTWlPZTRa?=
 =?utf-8?B?c2d6ZkdUWXlxazh3VGRneDhVRDN1TEx5MFZIZ0MzdkRqWnhINlpVSEczN2VM?=
 =?utf-8?B?TjVJbkRTdmxLVHA3ZHJCb0xZdnVQZFQ5RURGay9GUEFlejZjdHZpMnV5cnhi?=
 =?utf-8?B?Q1RGS25ITHhrWDVGeEYzUWZjN1NPZXIrT0RieDI2T2RUSCtPMGw0ZEhoQ2lY?=
 =?utf-8?Q?ihVuZWffyRRCp4hD7BdTE9CPBTxEVb5Moc5xaGi?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e48a0e-7588-44c1-345f-08d8ff349d15
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 11:01:11.4488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lbqIEH59AECSU8JRJCpfS9VPBDhOCWiL5pzeJJiy+R9GVP/aaFLfx0kH5U82id96sm5499ia8KAVgCPHZkxGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2838
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080407080300050604040102
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-04-14 12:52, Jarkko Sakkinen wrote:
> On Mon, Apr 12, 2021 at 10:59:56AM +0200, Raoul Strackx wrote:
>> Creation of an SGX enclave consists of three steps. First, a new encla=
ve
>> environment is created by the ECREATE leaf function. Some enclave sett=
ings
>> are specified at this step by passing an SGX Enclave Control Structure=

>> (SECS) that contains the enclave MRENCLAVE, MRSIGNER, etc. This
>> instruction also starts a cryptographic log of the enclave being built=
=2E
>> (This log should eventually result in the MRENCLAVE.) Second, pages ar=
e
>> added to the enclave. The EADD leaf function copies 4KB data to an emp=
ty
>> EPC page. The cryptographic log records (among other properties) the
>> location and access rights of the page being added. It _does not_ incl=
ude
>> an entry of the page content. When the enclave writer wishes to ensure=
 the
>> content of (a part of) the enclave page as well, she must use the EEXT=
END
>> leaf function. Extending the enclave cryptographic log can only be don=
e
>> per 256 bytes. Extending the log with a full 4K page thus requires 16
>> invocations of the EEXTEND leaf function. It is however up to the encl=
ave
>> developer to decide if and how enclave memory is added to the=20
>> cryptographic log. EEXTEND functions may be issued only for relevant p=
arts
>> of an enclave page, may happen only after all pages have been added, a=
nd
>> so on. Finally, the enclave is finalized by the EINIT leaf function. A=
ny
>> new invocations of the EADD or EEXTEND leaf functions will result in a=

>> fault. With EINIT a number of checks are performed as well. The=20
>> cryptographic hash of the final cryptographic log is compared to the
>> MRENCLAVE field of the SECS structure passed to the ECREATE leaf funct=
ion
>> (see step one). The signature (MRSIGNER) over this MRENCLAVE is verifi=
ed
>> as well. When all checks pass, the enclave loading is complete and it
>> enters the executable state.
>=20
> Who do you expect to read this paragraph, seriously?

What do you mean? There was a request for more architectural details in t=
he cover letter.

>=20
>> The SGX driver currently only supports extending the cryptographic log=
 as
>> part of the EADD leaf function and _must_ cover complete 4K pages.
>> Enclaves not constructed within these constraints, currently cannot be=

>> loaded on the Linux platform. Trying to do so will result in a differe=
nt
>> cryptographic log; the MRENCLAVE specified at enclave creation time wi=
ll
>> not match the cryptographic log kept by the processor and EINIT will f=
ail.
>> This poses practical problems:
>> - The current driver does not fully support all possible SGXv1 enclave=
s.
>>   It creates a separation between enclaves that run everywhere and
>>   enclaves that run everywhere, except on Linux. This includes enclave=
s
>>   already in use on other systems today.
>> - It limits optimizations loaders are able to perform. For example, by=

>>   only measuring relevant parts of enclave pages, load time can be
>>   minimized.
>>
>> This patch set adds a new ioctl to enable userspace to execute EEXTEND=

>> leaf functions per 256 bytes of enclave memory. With this patch in pla=
ce,
>> Linux will be able to build all valid SGXv1 enclaves.
>>
>> See additional discussion at:
>> https://lore.kernel.org/linux-sgx/20200220221038.GA26618@linux.intel.c=
om/
>> T/#m93597f53d354201e72e26d93a968f167fcdf5930
>>
>>
>> Raoul Strackx (3):
>>   x86/sgx: Adding eextend ioctl
>>   x86/sgx: Fix compatibility issue with OPENSSL < 1.1.0
>>   x86/sgx: eextend ioctl selftest
>>
>>  arch/x86/include/uapi/asm/sgx.h         | 11 +++++
>>  arch/x86/kernel/cpu/sgx/ioctl.c         | 81 ++++++++++++++++++++++++=
++++-----
>>  tools/testing/selftests/sgx/defines.h   |  1 +
>>  tools/testing/selftests/sgx/load.c      | 57 +++++++++++++++++++----
>>  tools/testing/selftests/sgx/main.h      |  1 +
>>  tools/testing/selftests/sgx/sigstruct.c | 43 ++++++++---------
>>  6 files changed, 154 insertions(+), 40 deletions(-)
>>
>> --=20
>> 2.7.4
>>
>>
>=20
> /Jarkko
>=20

--
Jethro Beekman | Fortanix


--------------ms080407080300050604040102
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA0MTQxMTAxMDNaMC8GCSqGSIb3DQEJBDEiBCD4
C2/Gwr6GCUZjE1jkVJizvII6BJQySkf3R56X/J6i5TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAM5VoOA5QcCMJ70yPpu21LSeOaxXgjMGsWVYLZ9XtI7Osv847Iaq
uzoqvVuHHbFn27Aa+V4o6IPgnmJIJA4bHnr8XN7WU/rH1MRsF8JkzlMlt2kwTV4N72AZFlMd
g6i6LNH50F5/sUzmuBlSRRDNa5mBblLpvkITPGdbTC8c1MOhr0Oh+MquSXv8KoGPPS4fMgvE
cWU95nhmFlt6wrGK7C8Ch5hFwa7GMEUoRtSYPHqTWwPf2XcUKq9wLdbioFUqIxXz9yTZnfal
uRRhmB/Aj1a9jUbAqP9Q+NZIq4qKX3nKqBRfnfVIsSG+wcFRiws0VyRFcEq7j/2YCBo9PKLs
d5QAAAAAAAA=

--------------ms080407080300050604040102--
