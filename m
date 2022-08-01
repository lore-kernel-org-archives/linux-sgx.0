Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58FFCC00144
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Aug 2022 17:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiHARsB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Aug 2022 13:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbiHARsA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 1 Aug 2022 13:48:00 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38542ED45
        for <linux-sgx@vger.kernel.org>; Mon,  1 Aug 2022 10:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659376078; x=1690912078;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pnGdSm+MVoec+sHS4gTKH5M9+JHt4zIl8rmX24RkM5g=;
  b=Omvp0syqE6IO+LloIWnp73qDP8Zi2oxjXLAdSKiY2XzR75iXfnBjtzGq
   Wj18zWKKA/7d3Utl0PdRespFuzkcpF7ZxQrcoTYksvvFmZJQbYTw6cVpG
   a6cyIrRRabWtPh5771E4G777WmD+s+WiKGglW8ECX3zkh3szeifS1oKgm
   cN+O/U1SHUHVG9zv9l5GSUzfyYNWbrx81Fc9xBtpg3XtpIflCbyaxwywV
   P1DLSEg6GrOaEGJ8LjzlLZ5Bbz9tGhhOcyXO+B6CUH1Y0BuEJVxQPgkx4
   s1o6DGAehFEIVM59kFKGh7tR6EN4nRXhiCEHjD8UiIRvXginICiiz+tbs
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="272251515"
X-IronPort-AV: E=Sophos;i="5.93,208,1654585200"; 
   d="scan'208";a="272251515"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 10:47:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,208,1654585200"; 
   d="scan'208";a="705056358"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 01 Aug 2022 10:47:58 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 10:47:57 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 10:47:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 1 Aug 2022 10:47:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 1 Aug 2022 10:47:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6VH6K4LBRPSKosmXQcSzBDPGqYEuv6dYhoyb05A/qDr9TFkmbAFmO96joa5apkBbYxUfw/pSXCvOoCNGaHNs4cV7+BqyLy5Kmih5S6R7Om4F0yJdb7xwehRguWP9SuAoNo47sGFAhU8jjl+dTWbnG6yfKgE1P+mZBOGb/Hpi3ozvonvTHKiw1AGewVa1oIy22RSGUPrCvclK0jROaOQDWf+tl6YT38QeYN4qF2pvoWWd40lgKzhTWMOa3fe7oH+9pryZnzk1FnVK7YNx3peJyDRGVl0oSmI6KQSi5+DBKMCzNG0k97pjNEOZYoO29evVvxkNWtI6sK3QHRM2INaSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tA8eF7uE6a3CDV/5yTNT2Suqzl4JmmjVr0SJYf71jTE=;
 b=areLGra8/XkUPJVZXubPIH6S9QHXNvKK3GgwrkVuTEQ/eQfThe8km6OXiYYl5cNKUdnHf5p0F5QdoKiZjbsUHpmyTN/7nC73E+QaCGvT9gRyZ3EW1nXJ0hkZLivVSnNAgjUPyEVuGqkmMD3tOGq10H1gCvLDg8YXCgAijpIX0M/56SnmvVEzWG1XgZXmYm8gzW+kNYu998unDNWGLijawK11OkHqayYfKZt2/xq18DC+tQJL5JC+Iu9VSktwD2/bXxh7UNiVn8E6rhJDGij39ASr22tMJuf06nrvuCKgtrNv8PVIzemCChPuCFVG4dl4Zb1J1rhSmZXnT+kZ58MQSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) by
 BL3PR11MB5731.namprd11.prod.outlook.com (2603:10b6:208:352::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Mon, 1 Aug
 2022 17:47:54 +0000
Received: from DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::b0ec:428e:d323:2bbc]) by DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::b0ec:428e:d323:2bbc%4]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 17:47:52 +0000
From:   "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>
CC:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: RE: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC
 pages
Thread-Topic: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC
 pages
Thread-Index: AdijZFc8mcX23sq9QFWgzapOaA5FWACYeDSAAAH5tJA=
Date:   Mon, 1 Aug 2022 17:47:52 +0000
Message-ID: <DM8PR11MB5591C1CAA9867AA6BEC575ADF69A9@DM8PR11MB5591.namprd11.prod.outlook.com>
References: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YugDWezt7WtUip9Z@kernel.org>
In-Reply-To: <YugDWezt7WtUip9Z@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b11f334-4552-468f-d509-08da73e5f53b
x-ms-traffictypediagnostic: BL3PR11MB5731:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nKlYbz2han9Tkk5U6/773kuSY1HBwkbaLiAr00Fi0phtV1XAlc21Zcjwm5oSuvOtUUxfQtHwZ1fQv4DdCugFeKIhwhXJ9dtaa2SsgJWnhW/X2B0uK8gYCUFsyhqSTfsfZXlPIhB6nD72aP5tdlrXoTOGEtWU9BMrwg1KQUiyPFgkLmHQwqtrlXS7UTXftBTDm3UDYKcPhstjl9/sNlGVYW6PGkKy5v3VUbC1hsWc5CBFv1zjg/WtzleaXSc3Aw+99M8mZBQ1HWgUzoT38gpE2f/n/4KtsCRHLRk3OYJeUFgFQqKLpyT2CA1IW/dHZ0vPgppC3ISbFEzUmi7SOR8Vs/E+VLxl6V5Mn3sKgi/nve2crxnXXpprbXMlePlfR/RzW8o/6u226OXq0Gv6PfeTxbIsmCjsyKx9EdOfJJ8A9OBNMNh2eMSgCSGaf2dBST82TO9kaNq8Ix/MIqhudsI/Jn4ZXBfp79Dc8wJtkWPZbI2ng4mUBuJvW6jh1gLugkyR75LLHR1NJPS4cjgMr00DMLsTxFpyKUGW+vKhW/naFTKavjjG4HtPPv/ZER5oZcjL3eSeBELyHb6Ukz3A0GmAOn0Uj6o+QWkZ+869fTBGXWOZnunQIwgS6a1U7/bUSqXIZADvxW2gPLhHr0OL9wFavQzMuuwAfkv9JejO8qFOu3S7NF+HXopuClmOot0iOKgSNvE0LW+eSYev7u2HA5QAk0fipThYRrgXgs66R1YGqco2/Xl9kvex90s1dtrIaLpTxyypCTSqvce1CK8rERp53CoqZ68qpGbYErOC4Qhmzzc5k/0cAkws6QojMsvqxw4HmqumbAwCVHXWMslGO0n6LA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5591.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(346002)(39860400002)(376002)(122000001)(30864003)(52536014)(41300700001)(316002)(186003)(6916009)(86362001)(33656002)(55016003)(26005)(9686003)(5660300002)(6506007)(8936002)(53546011)(7696005)(8676002)(83380400001)(38070700005)(4326008)(76116006)(66946007)(2906002)(64756008)(66476007)(66446008)(66556008)(478600001)(54906003)(71200400001)(38100700002)(82960400001)(473944003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4nUYbsk9y+3EQr/h6OsWO7KrtDw/QuUY3dOFBQAYlMmlFN2R+9Lp7abuYDhE?=
 =?us-ascii?Q?+tYt9bKW5iT38lzLjkNXoeJAX7mljKq1vbT2pgKBF6JQjwQG+MBoXCqfj+L6?=
 =?us-ascii?Q?JqS6xTOdYCPXh35rhK3/RLz2RYSVaLcbkd3/qUEx17+520ZbBnZUS9UEJaxT?=
 =?us-ascii?Q?qn5aLNX9xvXBANAgmDZDpea68yVhPcVvrv5yeepJST1aMkXFxSUhusDJ/Ioq?=
 =?us-ascii?Q?atatGTcjtOzo+E+WmH+X7sXmHvrptrFig7K6iVjDyMEh5llg5TJNUYRkXyVd?=
 =?us-ascii?Q?rsPTmU2XSvEeB49S/Cq7lQwP9/rWwLyvuY6KYyF8FHFvO6wor7eo4FVQAAvI?=
 =?us-ascii?Q?uPFO6dXsMGFRTceFsgCM0AQXXeZ4sc4LH2yxFuNQCLqzSgz/sqtdkMnBJ9kV?=
 =?us-ascii?Q?m2cZpvwK+cUdqz67YHQBJ/93ojk0uuhLYCuoGJNddeDJtVIlyRBoXQ67Uhz7?=
 =?us-ascii?Q?kRc4p3STFC1MjsaW/5IFgt4GHbsFwQMim1YFqst3hz1LkH6D5RbkXu0nnN2c?=
 =?us-ascii?Q?bJ1nPA+oUpjjZm16j5tcL8X5CBu2luZL3pBFtthvOxf3uynxerobgoaoEA73?=
 =?us-ascii?Q?bVQTmy3EJZznXrui2HU4loQhF3qIaO2KWWoTGSOJZnZjO8YBOzXnPfUz85qM?=
 =?us-ascii?Q?iC3b0QualiqsSjG/oDObMHUYWBzq2CQcYcHIaeG/nqIxs7PalhSrONkgpq9E?=
 =?us-ascii?Q?gbCH+ORphbJrA6s1fBDKCM18jLoJA+ptK85lHNSMp/UFUowjaybM7+pMG+I2?=
 =?us-ascii?Q?zJU+KspyJdj2E6DXWDLxXzHqsYbO+3th37BCrb4DYenf2XZyqCsW3szosCg6?=
 =?us-ascii?Q?oIsiZ8OyjisCMNHIV1Jtf+IVtAQkj/ptxvWjJhCokFn0XEjnW9oDxC1qdlFU?=
 =?us-ascii?Q?zf7WE2JW/lWkU+xxePjgxJtjQ/7HunIgvx0yeo1U44e+gxL+/qn89uE4Pxd9?=
 =?us-ascii?Q?wl3/tdWFFLaWq+o0vyQFfSdUyjP1jFMuKtKx5/mnqZxCYP/IbaU8U0cuOMf8?=
 =?us-ascii?Q?bAJUuBZIYAh8Jz4J+Q0BYZ9bYYVgcQ2PGTWX0Yv6kWANR0XvhXiU9DZZmXHA?=
 =?us-ascii?Q?Lf8jyfLZqArDAW9EAYF1vxWridqtwwWg8jEIqlZRFmo7Hahg1F5gplxjE6iJ?=
 =?us-ascii?Q?sjOuG3sIM6ThDJsnNmrk8rvb8M2etWQblxYKcI+OBbhNu8ESZGOE8XCMhXC/?=
 =?us-ascii?Q?8AY/glehnFLg7mTHmVSHmI83rnCWzI6o9rv2HQ0wHFKY+I0sXsDdyu0OZnbB?=
 =?us-ascii?Q?I4lagquQ7ci9qCPfPc3WVqBGnMgvC8jqCSQLSxjCA807ZZ9yfztI1MkVC6yc?=
 =?us-ascii?Q?XbLw3JxfypMN602eemztNb2Boo2A6Q8xpNShhoijOjUVADrWi2NMvucjnErp?=
 =?us-ascii?Q?n029Tq46ElrCkWp+1c4rH/pa3z4vawDsIA+9/O7ZY0FKpEpwTuoecReaIh9A?=
 =?us-ascii?Q?vQqisOJUYVh0nNG6eh4iFkQ7XBqute8d4lVn3pGmfmuK7UsS0/nscJhX1DxL?=
 =?us-ascii?Q?+/TA0d5IPiehtTsdiz/wOqq9jjx39dUy2/lwQbfdHFaVknTASC0jSscO2QrR?=
 =?us-ascii?Q?lWxEUSwM0us9T9aFT8fa69mB/84C3EsmHMAtOfPg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5591.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b11f334-4552-468f-d509-08da73e5f53b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 17:47:52.4908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sdoqA8+sBRKyLmNTUOyshpcSc2ILt7ONK4dsEQbuvyIZ001VHW0107rf3HjT5VVZwW+T8lRHTCDCEsM1W17TfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5731
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> -----Original Message-----
> From: jarkko@kernel.org <jarkko@kernel.org>
> Sent: Monday, August 1, 2022 9:46 AM
> To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> Cc: Chatre, Reinette <reinette.chatre@intel.com>;
> dave.hansen@linux.intel.com; linux-sgx@vger.kernel.org; Huang, Haitao
> <haitao.huang@intel.com>
> Subject: Re: Support SGX2 V5: Seg-fault with EACCEPT for large number of
> EPC pages
>=20
> On Fri, Jul 29, 2022 at 04:01:04PM +0000, Dhanraj, Vijay wrote:
> > Hi All,
> >
> > I recently tested the V5 version of the patch with Gramine and ran into=
 a
> seg-fault during EPC allocation that is `EAUG`ing via `EACCEPT`. Allocati=
on
> worked fine for smaller requests and even up to 2GBs. But when I tried wi=
th
> 4GB allocation I got a seg-fault.
> > Huang, Haitao and I created a simple patch to repro this issue using th=
e SGX
> selftests and we do see the issue when using V5 (5.18.0-rc5) but cannot
> repro the issue in V4 (5.18.0-rc2). Not sure if this is a driver issue or=
 kernel,
> can you please check?
> >
> > Results with V5 using modified `augment_via_eaccept` test:
> > #  RUN           enclave.augment_via_eaccept ...
> > # main.c:1135:augment_via_eaccept:test enclave: total_size =3D 8192,
> > seg->size =3D 8192 # main.c:1135:augment_via_eaccept:test enclave:
> > total_size =3D 12288, seg->size =3D 4096 #
> > main.c:1135:augment_via_eaccept:test enclave: total_size =3D 36864,
> > seg->size =3D 24576 # main.c:1135:augment_via_eaccept:test enclave:
> total_size =3D 40960, seg->size =3D 4096 #
> main.c:1153:augment_via_eaccept:mmaping pages at end of enclave...
> > # main.c:1167:augment_via_eaccept:Entering enclave to run EACCEPT for
> each page of 8589934592 bytes may take a while ...
> > # main.c:1184:augment_via_eaccept:Expected self->run.exception_vector
> > (14) =3D=3D 0 (0) # main.c:1185:augment_via_eaccept:Expected
> > self->run.exception_error_code (4) =3D=3D 0 (0) #
> > main.c:1186:augment_via_eaccept:Expected self->run.exception_addr
> > (140106113478656) =3D=3D 0 (0) # main.c:1188:augment_via_eaccept:Expect=
ed
> > self->run.function (3) =3D=3D EEXIT (4) # augment_via_eaccept: Test
> > terminated by assertion
> >
> > Results with V4 using modified `augment_via_eaccept` test:
> > #  RUN           enclave.augment_via_eaccept ...
> > # main.c:1135:augment_via_eaccept:test enclave: total_size =3D 8192,
> > seg->size =3D 8192 # main.c:1135:augment_via_eaccept:test enclave:
> > total_size =3D 12288, seg->size =3D 4096 #
> > main.c:1135:augment_via_eaccept:test enclave: total_size =3D 36864,
> > seg->size =3D 24576 # main.c:1135:augment_via_eaccept:test enclave:
> total_size =3D 40960, seg->size =3D 4096 #
> main.c:1153:augment_via_eaccept:mmaping pages at end of enclave...
> > # main.c:1167:augment_via_eaccept:Entering enclave to run EACCEPT for
> each page of 8589934592 bytes may take a while ...
> > #            OK  enclave.augment_via_eaccept
> >
> >
> > Test Patch:
> > diff --git a/tools/testing/selftests/sgx/load.c
> > b/tools/testing/selftests/sgx/load.c
> > index 94bdeac1cf04..7de1b15c90b1 100644
> > --- a/tools/testing/selftests/sgx/load.c
> > +++ b/tools/testing/selftests/sgx/load.c
> > @@ -171,7 +171,8 @@ uint64_t encl_get_entry(struct encl *encl, const
> char *symbol)
> >  	return 0;
> >  }
> >
> > -bool encl_load(const char *path, struct encl *encl, unsigned long
> > heap_size)
> > +bool encl_load(const char *path, struct encl *encl, unsigned long
> heap_size,
> > +			   unsigned long edmm_size)
> >  {
> >  	const char device_path[] =3D "/dev/sgx_enclave";
> >  	struct encl_segment *seg;
> > @@ -300,7 +301,7 @@ bool encl_load(const char *path, struct encl
> > *encl, unsigned long heap_size)
> >
> >  	encl->src_size =3D encl->segment_tbl[j].offset +
> > encl->segment_tbl[j].size;
> >
> > -	for (encl->encl_size =3D 4096; encl->encl_size < encl->src_size; )
> > +	for (encl->encl_size =3D 4096; encl->encl_size < encl->src_size +
> > +edmm_size;)
> >  		encl->encl_size <<=3D 1;
> >
> >  	return true;
> > diff --git a/tools/testing/selftests/sgx/main.c
> > b/tools/testing/selftests/sgx/main.c
> > index 9820b3809c69..8d7ce9389c8f 100644
> > --- a/tools/testing/selftests/sgx/main.c
> > +++ b/tools/testing/selftests/sgx/main.c
> > @@ -25,6 +25,8 @@ static const uint64_t MAGIC =3D
> 0x1122334455667788ULL;
> > static const uint64_t MAGIC2 =3D 0x8877665544332211ULL;
> > vdso_sgx_enter_enclave_t vdso_sgx_enter_enclave;
> >
> > +static const unsigned long edmm_size =3D 8589934592; //8G
> > +
> >  /*
> >   * Security Information (SECINFO) data structure needed by a few SGX
> >   * instructions (eg. ENCLU[EACCEPT] and ENCLU[EMODPE]) holds
> > meta-data @@ -183,7 +185,7 @@ static bool setup_test_encl(unsigned
> long heap_size, struct encl *encl,
> >  	unsigned int i;
> >  	void *addr;
> >
> > -	if (!encl_load("test_encl.elf", encl, heap_size)) {
> > +	if (!encl_load("test_encl.elf", encl, heap_size, edmm_size)) {
> >  		encl_delete(encl);
> >  		TH_LOG("Failed to load the test enclave.");
> >  		return false;
> > @@ -1104,14 +1106,19 @@ TEST_F(enclave, augment)
> >   * Test for the addition of pages to an initialized enclave via a
> >   * pre-emptive run of EACCEPT on page to be added.
> >   */
> > -TEST_F(enclave, augment_via_eaccept)
> > +/*
> > + * Test for the addition of pages to an initialized enclave via a
> > + * pre-emptive run of EACCEPT on page to be added.
> > + */
> > +/*TEST_F(enclave, augment_via_eaccept)*/ TEST_F_TIMEOUT(enclave,
> > +augment_via_eaccept, 900)
> >  {
> >  	struct encl_op_get_from_addr get_addr_op;
> >  	struct encl_op_put_to_addr put_addr_op;
> >  	struct encl_op_eaccept eaccept_op;
> >  	size_t total_size =3D 0;
> >  	void *addr;
> > -	int i;
> > +	unsigned long i;
> >
> >  	if (!sgx2_supported())
> >  		SKIP(return, "SGX2 not supported"); @@ -1125,6 +1132,7
> @@
> > TEST_F(enclave, augment_via_eaccept)
> >  		struct encl_segment *seg =3D &self->encl.segment_tbl[i];
> >
> >  		total_size +=3D seg->size;
> > +		TH_LOG("test enclave: total_size =3D %ld, seg->size =3D %ld",
> > +total_size, seg->size);
> >  	}
> >
> >  	/*
> > @@ -1132,7 +1140,7 @@ TEST_F(enclave, augment_via_eaccept)
> >  	 * test enclave since enclave size must be a power of 2 in bytes whil=
e
> >  	 * test_encl does not consume it all.
> >  	 */
> > -	EXPECT_LT(total_size + PAGE_SIZE, self->encl.encl_size);
> > +	EXPECT_LT(total_size + edmm_size, self->encl.encl_size);
> >
> >  	/*
> >  	 * mmap() a page at end of existing enclave to be used for dynamic
> > @@ -1142,10 +1150,10 @@ TEST_F(enclave, augment_via_eaccept)
> >  	 * falls into the enclave's address range but not backed
> >  	 * by existing enclave pages.
> >  	 */
> > -
> > -	addr =3D mmap((void *)self->encl.encl_base + total_size, PAGE_SIZE,
> > -		    PROT_READ | PROT_WRITE | PROT_EXEC, MAP_SHARED |
> MAP_FIXED,
> > -		    self->encl.fd, 0);
> > +	TH_LOG("mmaping pages at end of enclave...");
> > +	addr =3D mmap((void *)self->encl.encl_base + total_size, edmm_size,
> > +			PROT_READ | PROT_WRITE | PROT_EXEC,
> MAP_SHARED | MAP_FIXED,
> > +			self->encl.fd, 0);
> >  	EXPECT_NE(addr, MAP_FAILED);
> >
> >  	self->run.exception_vector =3D 0;
> > @@ -1156,25 +1164,29 @@ TEST_F(enclave, augment_via_eaccept)
> >  	 * Run EACCEPT on new page to trigger the #PF->EAUG-
> >EACCEPT(again
> >  	 * without a #PF). All should be transparent to userspace.
> >  	 */
> > -	eaccept_op.epc_addr =3D self->encl.encl_base + total_size;
> > +	TH_LOG("Entering enclave to run EACCEPT for each page of %zd
> bytes may take a while ...",
> > +			edmm_size);
> >  	eaccept_op.flags =3D SGX_SECINFO_R | SGX_SECINFO_W |
> SGX_SECINFO_REG | SGX_SECINFO_PENDING;
> >  	eaccept_op.ret =3D 0;
> >  	eaccept_op.header.type =3D ENCL_OP_EACCEPT;
> >
> > -	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
> > +	for (i =3D 0; i < edmm_size; i +=3D 4096) {
> > +		eaccept_op.epc_addr =3D (uint64_t)(addr + i);
> >
> > -	if (self->run.exception_vector =3D=3D 14 &&
> > -	    self->run.exception_error_code =3D=3D 4 &&
> > -	    self->run.exception_addr =3D=3D self->encl.encl_base + total_size=
) {
> > -		munmap(addr, PAGE_SIZE);
> > -		SKIP(return, "Kernel does not support adding pages to
> initialized enclave");
> > -	}
> > +		EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
> > +		if (self->run.exception_vector =3D=3D 14 &&
> > +			self->run.exception_error_code =3D=3D 4 &&
> > +			self->run.exception_addr =3D=3D self->encl.encl_base) {
> > +			munmap(addr, edmm_size);
> > +			SKIP(return, "Kernel does not support adding pages
> to initialized enclave");
> > +		}
> >
> > -	EXPECT_EEXIT(&self->run);
> > -	EXPECT_EQ(self->run.exception_vector, 0);
> > -	EXPECT_EQ(self->run.exception_error_code, 0);
> > -	EXPECT_EQ(self->run.exception_addr, 0);
> > -	EXPECT_EQ(eaccept_op.ret, 0);
> > +		EXPECT_EQ(self->run.exception_vector, 0);
> > +		EXPECT_EQ(self->run.exception_error_code, 0);
> > +		EXPECT_EQ(self->run.exception_addr, 0);
> > +		ASSERT_EQ(eaccept_op.ret, 0);
> > +		ASSERT_EQ(self->run.function, EEXIT);
> > +	}
> >
> >  	/*
> >  	 * New page should be accessible from within enclave - attempt to
> @@
> > -1207,7 +1219,7 @@ TEST_F(enclave, augment_via_eaccept)
> >  	EXPECT_EQ(self->run.exception_error_code, 0);
> >  	EXPECT_EQ(self->run.exception_addr, 0);
> >
> > -	munmap(addr, PAGE_SIZE);
> > +	munmap(addr, edmm_size);
> >  }
> >
> >  /*
> > diff --git a/tools/testing/selftests/sgx/main.h
> > b/tools/testing/selftests/sgx/main.h
> > index fc585be97e2f..fe5d39ac0e1e 100644
> > --- a/tools/testing/selftests/sgx/main.h
> > +++ b/tools/testing/selftests/sgx/main.h
> > @@ -35,7 +35,8 @@ extern unsigned char sign_key[];  extern unsigned
> > char sign_key_end[];
> >
> >  void encl_delete(struct encl *ctx);
> > -bool encl_load(const char *path, struct encl *encl, unsigned long
> > heap_size);
> > +bool encl_load(const char *path, struct encl *encl, unsigned long
> heap_size,
> > +			   unsigned long edmm_size);
> >  bool encl_measure(struct encl *encl);  bool encl_build(struct encl
> > *encl);  uint64_t encl_get_entry(struct encl *encl, const char
> > *symbol); diff --git a/tools/testing/selftests/sgx/sigstruct.c
> > b/tools/testing/selftests/sgx/sigstruct.c
> > index 50c5ab1aa6fa..6000cf0e4975 100644
> > --- a/tools/testing/selftests/sgx/sigstruct.c
> > +++ b/tools/testing/selftests/sgx/sigstruct.c
> > @@ -343,7 +343,7 @@ bool encl_measure(struct encl *encl)
> >  	if (!ctx)
> >  		goto err;
> >
> > -	if (!mrenclave_ecreate(ctx, encl->src_size))
> > +	if (!mrenclave_ecreate(ctx, encl->encl_size))
> >  		goto err;
> >
> >  	for (i =3D 0; i < encl->nr_segments; i++) {
> > --
> > 2.17.1
> >
> >
> > Thanks,
> > -Vijay
>=20
> Which hardware was used to produce this bug (e.g. /proc/cpuinfo)?
>=20
> BR, Jarkko

It is an IceLake server with 128 logical processors (64 LPs per socket). Bu=
t the EPC memory was set to 2GB per socket.

Output from /proc/cpuinfo:
=20
processor       : 127
vendor_id       : GenuineIntel
cpu family      : 6
model           : 106
model name      : Intel(R) Xeon(R) Platinum 8352Y CPU @ 2.20GHz
stepping        : 6
microcode       : 0xd0002a0
cpu MHz         : 800.000
cache size      : 49152 KB
physical id     : 1
siblings        : 64
core id         : 31
cpu cores       : 32
apicid          : 191
initial apicid  : 191
fpu             : yes
fpu_exception   : yes
cpuid level     : 27
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx p=
dpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopo=
logy nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 ds_cpl vmx smx est t=
m2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt=
 tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpu=
id_fault epb cat_l3 invpcid_single intel_ppin ssbd mba ibrs ibpb stibp ibrs=
_enhanced tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust =
sgx bmi1 avx2 smep bmi2 erms invpcid cqm rdt_a avx512f avx512dq rdseed adx =
smap avx512ifma clflushopt clwb intel_pt avx512cd sha_ni avx512bw avx512vl =
xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_=
local split_lock_detect wbnoinvd dtherm arat pln pts avx512vbmi umip pku os=
pke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg tme avx512_=
vpopcntdq la57 rdpid sgx_lc fsrm md_clear pconfig flush_l1d arch_capabiliti=
es
vmx flags       : vnmi preemption_timer posted_intr invvpid ept_x_only ept_=
ad ept_1gb flexpriority apicv tsc_offset vtpr mtf vapic ept vpid unrestrict=
ed_guest vapic_reg vid ple shadow_vmcs pml ept_mode_based_exec tsc_scaling
bugs            : spectre_v1 spectre_v2 spec_store_bypass swapgs mmio_stale=
_data
bogomips        : 4427.06
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 57 bits virtual
power management:

Thanks,
-Vijay
