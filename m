Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14882C19F2D
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Aug 2022 17:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiHIRI3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Aug 2022 13:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245366AbiHIRI0 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 9 Aug 2022 13:08:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B491322B31
        for <linux-sgx@vger.kernel.org>; Tue,  9 Aug 2022 10:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660064905; x=1691600905;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DCniCIvmLyZ14/DGyyYX572JYvE9mgQDO5jzUDwL5Bo=;
  b=T6zbCLdgTnQAbObqYRX6IViiX4qLloeJ9KgYd6iXeqlzDdRENnJ1b2JR
   sOESF9yr8V7vAhk9Ed21v849eLjS0zQiNAepyPYx5eAlpj4pUHl65ZHWy
   au0aqJydUrPfk3+9YwBoFJxh6fz8F//RsKxxCmiHeHXEdVIUWyc2darRA
   xCKbdEbG/o8MlCKO07uW+db9c+dV2SMYShOsLEUhLboy0bFFUANTtMwEt
   L5rHRh4cwCJaFVwOb1icUlzTiTeVmf+iRUsYMJGrLhsIkTs2kRR2ceoyX
   19ABEes86HMuk2vs3ZQYT+ZvjFqdfmWgDb0lq8vZGw4PKv3rVWI/Wm6xk
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="290891239"
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="290891239"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 10:08:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="780941731"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 09 Aug 2022 10:08:24 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 9 Aug 2022 10:08:24 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 9 Aug 2022 10:08:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 9 Aug 2022 10:08:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 9 Aug 2022 10:08:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DM/8T19jwQRx0PvfJZ1jNAw/9KdaUtlhbd6vS7Qi6NOQxpD3OcEkIwWnyxwOj9WFwLJQZFYzZJ9q0PW/PzEny7O1EHSLS9ffFGbsELWPp+RurBsWXWyMX/PsBwMm/XDxxqerUnoXHBSiHoCF48ycZy8ThqgUs9/Aa7ugTV+ZeRYbO5X37Rv3jMXaxZBvJ0f5T2IVdhIjrdCg99fElQ60FifNjEslg3bCVZNfOiHc4x/rFPrSeQkntpNLw20M1F1MbqfDJbmAEQ6glvZMNdAmLOA80ROBt0yzIvWlHLXrK/0LyIRsuTy2c6OdzkseRDiuLhCZh5w8R4ru8vBfUm1Vow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8M0NM4Ro8SRUsLeIM7JHYRgqPYhN3OrBR28weQV+fgU=;
 b=MoLBH+MMjtSy28jEuXwiys9/nqRvL2kjmYrYzO2oW68Y3gq9TjcwUMIk62tjshyY50RJN90kiZ7jvp75ndYuvpDP38WKyo+zhPRcQEA6gDkI36FJfcdLbJqnHHKWO3by5iRCLFTO3hJhGKtdoN/m8mtzpODJq0KuGDWIurQdPVmYh0mFGlZKJUM9AC6mFv91NLn9LPS1FDLcdCO+lPxllO6ygQfEx4cRMgymG6IgBg/D6SRBXFJQy905UMEE6YCEorbXnJtM1he6JgrEJyDM3dpHQy3h0t4kFWl3wF6M3II37tGFZXNnEmRLftjuhexrY4YOtLhIfqkdiI3GXhnkgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) by
 CH0PR11MB5217.namprd11.prod.outlook.com (2603:10b6:610:e0::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 17:08:22 +0000
Received: from DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee]) by DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee%7]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 17:08:22 +0000
From:   "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: RE: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Topic: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Index: AQHYqD8zl0cVZTXY9kygyA0BTFvLEK2k8WeAgAAK/MCAACpYgIABQxaAgABajACAAA2M0A==
Date:   Tue, 9 Aug 2022 17:08:21 +0000
Message-ID: <DM8PR11MB5591108F54901FBB198E6E04F6629@DM8PR11MB5591.namprd11.prod.outlook.com>
References: <20220804201456.33418-1-vijay.dhanraj@intel.com>
 <YvD/DUGRBR2Tns88@kernel.org>
 <DM8PR11MB559100639C945285BF1D6F87F6639@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvEryXfefz62ivEa@kernel.org> <YvI6z7wgV2VQtNV7@kernel.org>
 <YvKGxIEpdnawb0bY@kernel.org>
In-Reply-To: <YvKGxIEpdnawb0bY@kernel.org>
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
x-ms-office365-filtering-correlation-id: 4f45e689-2bb9-433d-e835-08da7a29c36b
x-ms-traffictypediagnostic: CH0PR11MB5217:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CK7ACNlnV+ywF1kWem3c5EsGuy7DTn4w/gbe/rhjw/Egm6+WRS9q52plc4eKbey9u8foBadyXk96RmxTwzV3Tvni8mUBg7EjpXy75xskyktjotOicpWqyKyzQ+ZUWKrva0zwFkTI9I5TI0uO8FgNAvjfAfAPNNKz8+MA3d7QqvtRyMMdUgqr+4sjfXGPwyIz9jjUflSKdqF3OgGoNvXkBLR/hRJH5mpS9PDZOYQk5IFafL3bEZ6SVPqfzuqtt4104stdhrxzcE+16Fz3M0Wby6e64Or13DeWsbTJCSl4yXLwvLNw3RoW3xb+lp/jN47loHqouI92cM+w3qyecTh9Kk3+vOMYpgIpSxPFX9RKMV04EA9tmz7x4MhxNuJtZN5AYBQzXakAKG2xPFqgWQd+aXATLjnzwO3U1NNlHimb1Y7e4w1LUtoPtJSkEK6z2Je0bQdkdlX9Oxcn+/HYamgmaeX61xj3NJ7ZuiK86ESJhR2/YRnpRol8YhMmxa0pp4+DUh2Y24davQyUIZSPyaN69ZnhJypv38hX72v3blcI1gKJ0258FOsMfVH3mlbzfLoHttPAWyn6RFaVfPRCsXcTQtFLM8vO7bnwKCWBfy4UmrYkm4khrepP0K1s/TXPN1cz9KTzzKVrc8JebRB5nMa79+725RjJZlRE6L5agDyY7j/3paJkBD2JJQLkF7pdE+NGqAOBBmFXOsLko5jb3aAXu7F2OUKqqQXnB/GdBiW8G4dC7QM8Epe7vRGRjMW1f/NxObRE/B/YI9VwenQy4kvy/8h+mS2J4qz2PlvWIpSTO35cYyjOQ8LS+z16xlU84U5NGUDEAlT0NutKytIz5l8f1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5591.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(39860400002)(396003)(366004)(136003)(64756008)(66446008)(66556008)(66476007)(9686003)(82960400001)(4326008)(66946007)(8676002)(55016003)(76116006)(6506007)(478600001)(53546011)(26005)(7696005)(2906002)(33656002)(38070700005)(41300700001)(86362001)(71200400001)(186003)(83380400001)(52536014)(5660300002)(122000001)(316002)(6916009)(54906003)(38100700002)(8936002)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?D7rN/zSyQNq9WYTFq/E82Tq8Ov9yf9V3/A5E2OlVq4dROzta4HOqUl2odGa/?=
 =?us-ascii?Q?wFoN9lpii6sJJUVK765/3p/nxswuCJu6Z45KdqsaUAzOcy28Nv727RQxiQm8?=
 =?us-ascii?Q?73llADFHMX8JtuI+wFsi6CzFF0RkmRTnWrmYAEgM/uxs2rN2rqmdDNhddxFN?=
 =?us-ascii?Q?HWasx4pVW+H08O70B4GlsBZPq/ECoc9V7JxLbaVQziydzkpvvxsgINKH8DXu?=
 =?us-ascii?Q?hqT1JdQSdvINZ8LUbLizXOyFu29TwwZWcbkeXKnQmhk2LYXoKbBj2eCP86J0?=
 =?us-ascii?Q?YEK5+TJHP6eQstB2lKBYfQiURIdBQ/cjizTqLaGOTVJXAnAwFIrO66OSJg1Q?=
 =?us-ascii?Q?Q/21EKFOuBQwENVND8M7/rhhbOEMx43vNU9IYndAY0BPhqVEzgxAdJGhE4yY?=
 =?us-ascii?Q?4aB6tpdXo7AAujC6QTafeRhA1y+IAPXHe05FCCGvanb9rajH9gUsZKhQJjtF?=
 =?us-ascii?Q?y5BcB5hlFrw5WnVJ3+nRV5e7xlHs/y+LbCd2CyiwI94jHr+tPjShcPjWyxga?=
 =?us-ascii?Q?z/LWGU5MORieGB+cQQBHmv9hVAO/i2B6K7J8RJFmxQfllRjSS8sXHVZHnBG+?=
 =?us-ascii?Q?1U/Xkjk9AQc0/myHx7cwD99qX42rlTYDCqJ8rGHsZ+6RAZ/Sr8rm7TQ1wDa5?=
 =?us-ascii?Q?UK143vtcTjuV2UnDwtWGmizmn7+HvyG/Xya98YKOHX8HLfOqbR43qSqNIM0x?=
 =?us-ascii?Q?d6ZFiVueNtyLNt/Hor35hOp7To2ko3TLrdHQwTVI6eJlxzZJTmfSULKfx248?=
 =?us-ascii?Q?FCdd6uwP+7AwOtDg0UjssJAW44Q5vzk8Fb8aIkj19yIj7tx/LdEOO7leb3U5?=
 =?us-ascii?Q?R/oapQOD7z8I3zIgntdmSJZyelc7O62ijn0Usk0BbQFt4g0VlBcpse7BWG8L?=
 =?us-ascii?Q?Uh8A/pGjXc/QMptUDqqOL89fWzCetscbrN6aR1Tcmkb/4/Qa8WAATP1XVvVd?=
 =?us-ascii?Q?TvF7k8sf8D5NPGTxsPVGS+7i4qcKanxWsfuCtf93hLxmwwUw9p4cADRS9eG7?=
 =?us-ascii?Q?zbu/bzojcCvqKjw/ODjMSQlX+i5gn5aiioVcI8NRJwVPChOAunwmX6DHHqtc?=
 =?us-ascii?Q?+dNtkhX9G8hye8jC/h0zW0E3XFMtO2Z6GcoV+surgAgV0Fe4ZmS1guSesyGV?=
 =?us-ascii?Q?PTTma3JKbom2aKPbD3KXuNmVQi0p0Jjy93uxFs5maozBL0Ff/jPyK9bA/WZB?=
 =?us-ascii?Q?QZoKfR1SGEgcqxOgELUyK+Y7sXeAZkhVvq+DAPQfsR+Qn9FQ7OlYqe2uRZgM?=
 =?us-ascii?Q?8raTxV3nYEPIDCXRyjCtOm7HS3re/46nw8dh3phDMwN9SoorN8x+m42mH+lt?=
 =?us-ascii?Q?G40pgQysHXag447u0O5ivNevndcWZn2EQ76CXxqmDKv86bulKwvsJCPOiGqD?=
 =?us-ascii?Q?7JhDPV8yiwCXbL+a6ICcjpjnCoO3C2y52ExDLGfKwt2sOllbtHj0FSgh4+9C?=
 =?us-ascii?Q?7MlR/K/lrQeN4MRQ3HaiXIrLVqkqKRjzyHmMGU8t+hUFq8yFtckT/VwSE9l8?=
 =?us-ascii?Q?/YUGy0lPAO9UmxvH+JA3F9ckJq6H29luSFlu9AzGsbykyU8BJ+ezuWddxxBf?=
 =?us-ascii?Q?ZEfAdo7/TrvS/CwN/dfubYWQ/3ZdnABr36WlAb1C?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5591.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f45e689-2bb9-433d-e835-08da7a29c36b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 17:08:21.6127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NXXXXE5lKHFs5kVOqrtajgp6wzY2rIixpASf0c2JYPaQlU7+H7HRNGZmQ8OVmqrZtZg1lIMhV/EBJ0YRFyKmcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5217
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> -----Original Message-----
> From: Jarkko Sakkinen <jarkko@kernel.org>
> Sent: Tuesday, August 9, 2022 9:10 AM
> To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang, Haitao
> <haitao.huang@intel.com>
> Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
>=20
> On Tue, Aug 09, 2022 at 01:45:35PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Aug 08, 2022 at 06:29:13PM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Aug 08, 2022 at 01:00:54PM +0000, Dhanraj, Vijay wrote:
> > > >
> > > > > -----Original Message-----
> > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > > Sent: Monday, August 8, 2022 5:18 AM
> > > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang,
> > > > > Haitao <haitao.huang@intel.com>
> > > > > Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
> > > > >
> > > > > On Thu, Aug 04, 2022 at 01:14:56PM -0700, vijay.dhanraj@intel.com
> wrote:
> > > > > > From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > > >
> > > > > > This commit adds a new test case which is same as
> > > > > > `augment_via_eaccept` but adds more number of EPC pages to
> > > > > > stress test
> > > > > `EAUG` via `EACCEPT`.
> > > > > >
> > > > > > Signed-off-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > > > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> > > > >
> > > > > Hey, to reproduce the original issue: does it reproduce on VM or
> > > > > should I run baremetal kernel?
> > > > >
> > > > > BR, Jarkko
> > > >
> > > > Hi Jarkko, The issue should be reproducible on baremetal kernel.
> > >
> > > Thanks.
> >
> > I need comment out other tests in order to make sane out of this :-)
> >
> > Mentioning this because came into realization that stress tests should
> > be IMHO moved each to a separate binary (so that they can be run
> > separately). Just a note (TODO) to myself.
> >
> > I'll work on this today again and *possibly* split your test to its
> > own application to get a starting point for forementioned.
>=20
> I got
>=20
> #  RUN           enclave.augment_via_eaccept_long ...
> # main.c:1241:augment_via_eaccept_long:test enclave: total_size =3D 8192,
> seg->size =3D 8192 # main.c:1241:augment_via_eaccept_long:test enclave:
> total_size =3D 12288, seg->size =3D 4096 #
> main.c:1241:augment_via_eaccept_long:test enclave: total_size =3D 36864,
> seg->size =3D 24576 # main.c:1241:augment_via_eaccept_long:test enclave:
> total_size =3D 40960, seg->size =3D 4096 #
> main.c:1259:augment_via_eaccept_long:mmaping pages at end of enclave...
> # main.c:1273:augment_via_eaccept_long:Entering enclave to run EACCEPT
> for each page of 8589934592 bytes may take a while ...
> #            OK  enclave.augment_via_eaccept_long
>=20
> The CPU used for testing was according to /proc/cpuinfo:
>=20
> model name      : Intel(R) Xeon(R) Gold 6338 CPU @ 2.00GHz
>=20
> I have couple of queries:
>=20
> 1. Is it possible to get dmesg output?
I did check the dmesg output but couldn't find anything related to the fail=
ure. Just the general log messages.

> 2. Do I have to repeat the test multiple times, or does it
>    occur unconditionaly?
>=20
I was able to repro every time but it was a bit sporadic for Haitao.

> BR, Jarkko

Also, did you set the PRMRR size to 2GB per socket in the BIOS? The issue i=
s only reproduced for oversubscribed scenario. When I set my PRMRR to 64GB =
per socket, I wasn't able to repro the issue.

Regards, Vijay
