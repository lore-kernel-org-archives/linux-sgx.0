Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8291EC43600
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 16:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60A1161356
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 16:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244306AbhDLQvH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:51:07 -0400
Received: from mail-eopbgr750090.outbound.protection.outlook.com ([40.107.75.90]:20483
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343491AbhDLQl5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Apr 2021 12:41:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RheYzmc3xo+NZoM3hWG/mt+/5zBm+WuEgQ8MJ2gnHoq2+sW1TAe8U4+EiiOTAc17WWzcoCRrH7nkFWdFnA1NyZfDyPhhXuMFb/CaCBGRlvSeKVMyBTwe18W6BazBdJ0ZLkeA2Uy9sovQoNP8/wSaj72b/gSu7uGNOC0aF0hU+bIzVdXu9glUJ0hGJneNc9OJlKsUv94Ycq+0Eb7fVFWj5l6EkgPeJvQGpS3AQqs55jh69I5wVI+QxiZUKWy9kElOBSJ/mhx9UD3aGCQeqGjOe6gAtU3cg7Y+dUlEfzXKmOPRo+YF2H0U2q3QTrwCQ4JPJhhu9ICofJCluteDXpVq9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzztUPVfymQGGdWKPQBly8QI70bJlr8sWD5jdrcisKw=;
 b=TlEzg2a2GYQMbhm3iRZImRix5SRZJdIVOy03YwJVrHZkvhY0audrgzfjEpVqL007ZPZAug4qRm0+HOJQMJtTHIdExOO8vyeziSvmAqkGW4psgqEk2cTCOYR2Yn5S3B4eCcdaVkKmQuGgBqkFk++Rutmfz764TbYGmH62AsfPsZ4xWA/DBhVBXIjzgKbZUddDmNAp6uB5ktKqvx76G7Th9ng5TrNIWQRW5ANxpfimsqbgCT6PZcYmPvslMz+xe3mr2oV3bJkPNGTSx8nb/+RPA4pt8HzqY99Ipkk2Jvlj3vY2cSOgPSgXoV6qsQNo/zgUPBAOfL57p2q3FVWWLGiohg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzztUPVfymQGGdWKPQBly8QI70bJlr8sWD5jdrcisKw=;
 b=jb7fRBQgnn0KhP0PgC7vd/rib9pVgalxBop5eLDBMECiYd0u4sN0WeIAma4jBFsuIV3eXQILfHGuD0D7ssK18fE7RA8NOdVADGof4CbdMlMQyNSscu2EJ08jI3LY9dcCORJXgRD3kRKRK7t25YfIeaYvgzEDbgCJ8DTSqiHiJ5s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by SJ0PR11MB4928.namprd11.prod.outlook.com (2603:10b6:a03:2d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 16:41:33 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::3ca5:41b6:52e:edc0%4]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 16:41:33 +0000
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
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <29cbfb1b-848a-2e14-5c0f-5d39d372bfcf@fortanix.com>
Date:   Mon, 12 Apr 2021 18:41:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <ae4b4271-9e74-99e6-fa59-369863c891b5@intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000601060603040204000200"
X-Originating-IP: [213.127.124.30]
X-ClientProxiedBy: AM4PR0302CA0030.eurprd03.prod.outlook.com
 (2603:10a6:205:2::43) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.30) by AM4PR0302CA0030.eurprd03.prod.outlook.com (2603:10a6:205:2::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 16:41:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 600fb5aa-1c7e-4b9b-e667-08d8fdd1d4cf
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4928:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR11MB4928EB8332805D429C77EB2DAA709@SJ0PR11MB4928.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9bkpLY8zV+N+tImF2rQSzP3Q7yIsCTc6S+k3eIZnw4U0D73ZibEx3HOGqY2TDWpdz8GfpIjRuU7dxH4iAvN3nvz6b+vVKl4tdNLtFshd8sVR+MhGaIAadAPLdj5AmC4aa4dLxuh5yYtx6f5j4Z57KJaWK1SqcKzT9z4RXIGLGTNtTXC2u/SAS8xr/oOpoX4LThyWPVbn8p6ZEqWEv+R88JlkHla0EJ8nI52nRyWQqbLLQ4FEsupHBsPXDvIvXBdamJQTknZ0rKBaG3KeuQNWfM43ffgKAFTxIbQUziop4ZucYUZseoyobPtS06Hg2UJ4MwP4w1HhHc/4a8UGricTPXjmByeHIJx3Mk7SVzLDNmA6WhZ56WPBYvPxbjqwUt7P06j/ZCBDtdjuPRMippCHTG17zbC++pyCviV2vGtM90r/WRgO6XWakgjruAFelN3boJBQe0bJU70fpwBF+jX8MfAP8GJmOE9tgqKh1Xa/IsOS5jzyiJJ2A2QSCKQw1AxGuMD1RfRKoJLQZH0OY/F7cBPc/QkStTqROxFRfJ/HavnaU1mfoxZP1hYrMAAK1jqvY+sSZ6DTSVf/UZ2a/GxPPdocNLtMUL0QSVeXHPIo/teZcevm7op/M9mh/4058zBD4sm1joAYrglCv9LOl1wE46/YsV2IvR7SNnKWVEabiz/IczZXIFifohKg55Ua/ZYhTUMreFk/ostS+tjCpRhPzNi8oqzcoknyX+/xugqgt9gJc3PYokr10bPPsGDCbA9t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39840400004)(346002)(396003)(376002)(136003)(66556008)(66476007)(16526019)(2616005)(316002)(186003)(956004)(66946007)(2906002)(921005)(31696002)(52116002)(26005)(6666004)(53546011)(8676002)(235185007)(8936002)(38350700002)(7416002)(5660300002)(31686004)(110136005)(86362001)(6486002)(478600001)(16576012)(38100700002)(36756003)(33964004)(43740500002)(45980500001)(352734003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dzhuTGc2akxOeHI5MXUwMXVtajJSa09wLzJwTGNwY0ZPRHB1R1FCcXBSZ3Ru?=
 =?utf-8?B?SytpaVRQQ3loaWJoTWZnSTJVaUpkVG84UU9KRHhBSmt5L0ZBeVNRZ2dUazU1?=
 =?utf-8?B?V3J1ejF0bThXcEhEUDdKYW1IVmRnZkxjQXVBRm5zTlhNdzAxNFE3b3U1enlp?=
 =?utf-8?B?aHBNeWtSQ0tGelYvMUJLZ1pPajZFU2k1SVArYnNYeDBOeWNHcHgxZm1vd28x?=
 =?utf-8?B?TkZxSWNEa1JTWVQ3bVQ2cDlYMzNuMTNGRVA1VFcrYklCbkgwRjVSTHpSLy8v?=
 =?utf-8?B?WnVQSlBxOG95MExrNTR2bmNWZVJvbVArajFNTGVxR2hUS0pIMkcwVCtRZWNU?=
 =?utf-8?B?SVZpWmJLRUhBZWJ1QnJvSHA4cWlnYzI0QWRhMFFyazA2T0t5THpEN2RQTVZG?=
 =?utf-8?B?cGlESjF3Y1NCVXowamRWYks3aVo0R21TclFHQnlnaVIzT01LbW9GSFFDWStU?=
 =?utf-8?B?UG5ZRTFSd1BRUlVVbWJJTlZQbXFSSW0zd3ZBT0pJT0RHK2NxRXhRakdCbkJi?=
 =?utf-8?B?WTlHVkVrKzVhdDlIN0w1dkhoL0hvZzRRT0VQMngvN25udlFsb1BaTFYveWNU?=
 =?utf-8?B?Z05Fc0V5TngyWCs1WEV6ZC9XY1ZZQW5pSlAwckEvRVpCckFDVUtIdzExd3Vw?=
 =?utf-8?B?R3E2WjVycUZVek5RYU9mRC9qT21mZllrc0IyRnk1WkIza2pjb1lpYmh5Z2Mx?=
 =?utf-8?B?MkhtOERWY0tkbVJtY25LaEJEZnk3SGpoem1MY2ZSK043cTcvY3FPbUVYVUd0?=
 =?utf-8?B?b0hWSXcrUHBsSWtjRHo3d0xkOU1hK3UvL25YMHlCWGdhYVNQTm1kb0FZYUtS?=
 =?utf-8?B?a25LQk1rNVBmMlBKVWd4RVlkTnJzTm5DRkVrV2lxRGFzMVk5YmlET1pJTGpp?=
 =?utf-8?B?Zzl1YnlVVXNwU0Z6WmhGSnFhTzU4RGtqT3FyMG9wT1F0ZXo2NHNqandPSmxi?=
 =?utf-8?B?eXorK3N0Wk84Rzd5YnI0V2dCMGVJd25WSHpTMllHVDdoSzg4Y0hqOUdVaUdt?=
 =?utf-8?B?SnJxaFJha3RFRUVaMXo4dERaNkVhWm9FSjQwMUtnSGJpQ1dGa3d3VHBLRTRw?=
 =?utf-8?B?WFUwcGpQaXBTL1YvZlp1K3JXWTd0cXdvT000VnBXQkZNL1J4bzJKTzAvT2M4?=
 =?utf-8?B?OTcxekg0dkV3eTVsK09WTWZMNE1JVXNKYTZxOWdzNGluRFVVUmhGdk9SVHdU?=
 =?utf-8?B?bEYxQ1pkNkhDZGZOd1VCSFlMVFlPV2luaWlyYTBSZ29PeUFLalBGS2xMY3pB?=
 =?utf-8?B?WFQrOUNHNGV0bnNVd2tyZDUralZXSk1VV2N2QlVqMzMzZDZ4UzRsZExhSmNx?=
 =?utf-8?B?cE5VOUJVeU84WlhSS0V1MXBKeTdMYi80UW44MVVIZ0RYd1BxNHhIQ05NbGtN?=
 =?utf-8?B?K1lrLytZd0tJVEpuaGk0N3pOc3pTMFNod0ZNQTJHREgxUmQyL0R3dlpuSmxa?=
 =?utf-8?B?dC9PNGNub0s2cy9kdjRKdFV6cGFJUWJzRkdhTkg2QWVDYVpjUSt2bnpFcHBn?=
 =?utf-8?B?cDQrcDl0SlRpZW00TytvQjRtR3V6ODN1UHJ3YjliUlpYTjZUckJUWFBnNnc4?=
 =?utf-8?B?eFpZS1dIQTZXRStrZXNPN3VZNkRjNEgxU0JqZTVJd3hwY3ZLRmRha1dXQ0RD?=
 =?utf-8?B?d1hUZEJRbGUzbHlVdEU2Ny85TVJIc0wxY2UrSnIzYlVtMzZsRFNMUmZVQ0Ev?=
 =?utf-8?B?UVd6SEdTc0kvVERmVU1KWm5kMFhlTkNGVXFkN0M3ckg4TTBuZ01iRFJFM24v?=
 =?utf-8?Q?ipfnONT3C4UPrqm1IAKRJWzgZ84pSmS2LaA7WIG?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 600fb5aa-1c7e-4b9b-e667-08d8fdd1d4cf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 16:41:33.4641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qMWxGoDOIMdM06g3RfbEGRCRyZcvOR9n9EEpuLUFxI8XX6Do4zJ+y6fiqNSrzzhGWzeyZnWp7svN9nR2uH6vdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4928
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms000601060603040204000200
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-04-12 18:40, Dave Hansen wrote:
> On 4/12/21 8:58 AM, Jethro Beekman wrote:
>> On 2021-04-12 17:36, Dave Hansen wrote:
>>> On 4/12/21 1:59 AM, Raoul Strackx wrote:
>>>> This patch set adds a new ioctl to enable userspace to execute EEXTE=
ND
>>>> leaf functions per 256 bytes of enclave memory. With this patch in p=
lace,
>>>> Linux will be able to build all valid SGXv1 enclaves.
>>> This didn't cover why we need a *NEW* ABI for this instead of relaxin=
g
>>> the page alignment rules in the existing one.
>>>
>> In executing the ECREATE, EADD, EEXTEND, EINIT sequence, you currently=
 have 2 options for EADD/EEXTEND using the SGX_IOC_ENCLAVE_ADD_PAGES ioct=
l:
>> - execute EADD on any address
>> - execute EADD on any address followed by 16=C3=97 EEXTEND for that ad=
dress span
>=20
> I think you forgot a key piece of the explanation here.  The choice as
> to whether you just EADD or EADD+16xEEXTEND is governed by the addition=

> of the: SGX_PAGE_MEASURE flag.
>=20
>> Could you be more specific on how you're suggesting that the current i=
octl is modified to in addition support the following?
>> - execute EEXTEND on any address
>=20
> I'm still not convinced you *NEED* EEXTEND on arbitrary addresses.
>=20
> Right now, we have (roughly):
>=20
> 	 ioctl(ADD_PAGES, ptr, PAGE_SIZE, MEASURE)
>=20
> which translates in the kernel to:
>=20
> 	__eadd(ptr, epc)
> 	if (flags & MEASURE) {
> 		for (i =3D 0; i < PAGE_SIZE/256; i++)
> 			__eextend(epc + i*256);
> 	}
>=20
> Instead, we could allow add_arg.src and add_arg.offset to be
> non-page-aligned.  Then, we still do the same __eadd(), but modify the
> __eextend() loop to only cover the actual range referred to by 'add_arg=
'.
>=20
> The downside is that you only get a single range of measured data per
> page.  Let's say a 'X' means measured (EEXTEND'ed) and '_' means not.
> You could have patterns like:
>=20
> 	XXXXXXXXXXXXXXXX
> or
> 	XXXXXXXXXXXXXXX_
> or
> 	____XXXXXXXXXXXX
>=20
> but not:
>=20
> 	_X_X_X_X_X_X_X_X
> or
> 	_XXXXXXXXXXXXXX_
>=20
>=20
> Is that a problem?
>=20

Yes this still doesn't let one execute all possible ECREATE, EADD, EEXTEN=
D, EINIT sequences.

--
Jethro Beekman | Fortanix



--------------ms000601060603040204000200
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA0MTIxNjQxMjRaMC8GCSqGSIb3DQEJBDEiBCAP
ZyKO6WKdkUByMaKuGyqHfLgssLALFPvMpST1j7487zBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBADckiJmmFEopngL+GkioGQTr1Rg66Gp1JOO1h2r+cJuXau9rpM/Q
jeD6LGtHk8/L2E8LU+p31DYSSJU1IKfQtkmcOqobMinQLzYsVcPl+Kt8+8fZ4KIpYtLmOwxJ
BRqlpbArt276t/mv8SSfTyyKAStuDimgNF8kLfFy50cIh93s31AspLoeeoO/eGsRaOIQjVBA
ZBPiFgePzN1nAMXEfp74jVZBdGuRyMHWVQZp26xSW+dd2Ud4vscLkziCsnkwsA+GOkvAslY3
tN/GkXV3AL7R71/gz10iuz+6DLIwGYLkJyYKACnx0zWw/SA7fi20GoZWGDXuAViOls0sHfRe
XoQAAAAAAAA=

--------------ms000601060603040204000200--
