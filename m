Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F131C282E7
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Aug 2022 03:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbiHLDXy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Aug 2022 23:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiHLDXc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 11 Aug 2022 23:23:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D89DA346F
        for <linux-sgx@vger.kernel.org>; Thu, 11 Aug 2022 20:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660274610; x=1691810610;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6BkyBoLbypVuHiiVgoYRjFk+nLlWmvtTOcNxzBT15fQ=;
  b=g8CZwhlxwS0zfPSAgKshEK6XqOEU3q5DEIbk0WC9gyqUDRgEyCbSNaYI
   PMtWTDm0QYNG+kvRszoNiacsg9hCMCaA1cMsgusOF+8K+oOZcKvRStNUC
   +Run6yvgIplbdIS5v91fdEoX0IRknAWbCUXkwSfpTmtSxTDNUWJbg05Nw
   PSDVTi3Ryaegf5tdondRHNM8ktzwwT7baxs0WJnFTf2vYppa+ercBb9+R
   YqfAnKKBZZM9YUYavdhmsGNgBjBWdnf3jWfHO/y+ohJNJCaJSSR+e6k87
   D5IUhKzgmFtdz1G2/6ayyrt7bixvfxgtYCedX3Fc0mB8IQP1FApTV2yzE
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="377803536"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="377803536"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 20:23:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="673939141"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 11 Aug 2022 20:23:29 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 20:23:28 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 20:23:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 20:23:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 20:23:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWAR52CdStumB69hqTiYZNVrpwvkclZo2wV5qNOFP1jjGjk+7x6EGyb4fDSRxqGOVb/4BtlPWqYUBhBqkxcexKyDjD6xYAbB9jJOsI/2K1Bj2Y27JwYjczyVUbRoUiN8/+ERkMspqOReKevtdHYbEgZkCBPPv/Ce8lsEVQzShRGOTyY83Vj5Slg5Gh73DWFtdP5XI+jwz8I3/m+Q9RXxY4Bhf/i10e+0jeVpwvhmRj/tNQcIKVh3f0DmLyOL+urwFLQYZTN8Znv9TO9OAlZFq9CSTR/x8drI/vWT1RSvCFBOMHtHmt2PxvXIvb6Whu714syu0WRbxBsMYIulPKL1xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPdI6MMTgC9fzWyGBP6JZ6D5bRoGLLjGtzTc4v3nCdI=;
 b=S2FeuuSPbfbJS+jdcgU++ymYPAkVRKKu988E61sVFgwEGJ1w29p5cRANCL/96uvu4AvmIvOhvZPW5YsLlChSTU1IGZ6jO0Fd4pKxZNfqY/VYnBHk7+np2myHH7oba5ls4aEHFEToVx51NpD1xH2Adp8iO+pnxR5J30mfcPBh+53XS4Bop0OBPS9Y/W4ZvV5HzxjCba5ZauDtzMYTGL6vJ89IcE7ACkg3awFBbYCrzFIK1vzotsHibP+GzT6MvWElHNDcgISvCPZ9X8QL0enAiilAF8r5GQAiGTH7NwnuJug4WkorZIywWgVoUq5bdymBePAHYdW6GwjBNASUekPp5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) by
 SJ0PR11MB4894.namprd11.prod.outlook.com (2603:10b6:a03:2d4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.10; Fri, 12 Aug 2022 03:23:26 +0000
Received: from DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee]) by DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee%8]) with mapi id 15.20.5525.011; Fri, 12 Aug 2022
 03:23:26 +0000
From:   "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: RE: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Topic: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Index: AQHYqD8zl0cVZTXY9kygyA0BTFvLEK2k8WeAgAAK/MCAACpYgIABQxaAgABajACAAA2M0IAAICAAgABWSfCAAaLlgIAACfYAgAAD6gCAAZ0sAIAADc0A
Date:   Fri, 12 Aug 2022 03:23:26 +0000
Message-ID: <DM8PR11MB5591076474DE227F6D9A90D2F6679@DM8PR11MB5591.namprd11.prod.outlook.com>
References: <YvD/DUGRBR2Tns88@kernel.org>
 <DM8PR11MB559100639C945285BF1D6F87F6639@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvEryXfefz62ivEa@kernel.org> <YvI6z7wgV2VQtNV7@kernel.org>
 <YvKGxIEpdnawb0bY@kernel.org>
 <DM8PR11MB5591108F54901FBB198E6E04F6629@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvKskgNrTDC/e8pf@kernel.org>
 <DM8PR11MB5591D9B8653A2CF9D9CD5A3EF6659@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvRU29VR/bkPLzS+@kernel.org> <YvRdNnvS71U+6Dq7@kernel.org>
 <YvRgfhHFAHCvH820@kernel.org> <op.1qrnu0e4wjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <op.1qrnu0e4wjvjmi@hhuan26-mobl1.mshome.net>
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
x-ms-office365-filtering-correlation-id: b338b0dc-0e5e-46e8-a39d-08da7c120519
x-ms-traffictypediagnostic: SJ0PR11MB4894:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BUUWRbbT3C2qOaDI4typRLmQvYMaaTyRY6MzLcwMprfIJgLbE9EUcZKo7NBcAe5T+4mmF4Octjd6dW8DlQSXBJBhTB/Zz/nz1ORena7Gr8cKfXFqJtn3Zc2blf+V5AHlwm3oc9Y+dd/W141Pc/QXu3/2dIkA5mp512Ebb8d/J81nyjaWaNfL46hu1MpOFo1Y/CKR6NkKcBgBGpoaPG8DA0hXJCSY5NkqqDzOcfFRIwmEYZRB5sSvLuccK29SlquhXvrk8WabqbwWsUCzENccVhBhUB14dKQGmlwKTAA+aAeO9g9R+689wcBrGH7nRnS+Zk7SUbUNRS0NI8nktWccettkfbezIpb8SwFWf/WHQly0v3WKCr+TaNUpNa9kbq3lcCBcfb9cEMm7BMZ02n2xhMMwe91E8gSHCdDUCvpS79rM79UDCgkK5798vV+vLYGQnYvIBL9aFXERSp7bEZLN4gLIQ3RE82xBPNOayY7GauAzHbkV6HDWpA6GQTLUrDF7cUwXBS/EPyFT5sr21vEEmGOZ4mFqARbJKzeznxJieCpynQ3mV6qr5PTNEs4aFaf7h2ipHv8aIOkIWFmTHN1UD/dVD0Gwxnai2vd8Njfl4vsPqlU/V99hdp34b9F7s0u2oBCWlkmpdary/WASiH6FiHJWOm9L1kDXexO2G5zW9N76xama6Gjjf4HnAImwgL4yKzv8lUnHMFuJIWsnGreLmlIm/1DK7TNPbUhE6AZv0Mr1KyRUIvgaDGpwxMU18AhpHjd3GEeFHy5guZdtrfUTxxIbTBMXeNCZOQkSIWq7QcjZ3H8Zgno9TCzEDG7zcolKElrJGvMZpe2pq62m26r67w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5591.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(346002)(376002)(136003)(4326008)(5660300002)(66556008)(8676002)(66476007)(64756008)(76116006)(316002)(66446008)(54906003)(55016003)(66946007)(8936002)(2906002)(52536014)(38100700002)(30864003)(33656002)(122000001)(86362001)(82960400001)(478600001)(6506007)(71200400001)(26005)(7696005)(53546011)(9686003)(41300700001)(38070700005)(110136005)(83380400001)(186003)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xTFFaHI7cZfYFlqkrkTQrsGuvWmvT/CYVFFl9Kvds6MdNC7YIAio86LT8sY8?=
 =?us-ascii?Q?jXvmcYgpMnrPLEtSwCjTswkszF6m96BqCRuU3RxD0ugWWMYn9nDa3ZcLm3c/?=
 =?us-ascii?Q?SRyKzMCM1wt15cILeHZ4xK37ojIDB5UhTyLm50OXo5y+YPbh4LK+SyLUQFxO?=
 =?us-ascii?Q?zHT4DeVZOzek9xB5kRnxWkRbm0QZxksxcrSM6kCFmx1CuFl7pbOJVJxjazHD?=
 =?us-ascii?Q?Xi7EZ5jaUpK98J4pCowOFu0rsYH5hSsz6widF5zIa8jQwWZaM8mSGMGX8tdi?=
 =?us-ascii?Q?YBM7fUdFhVMyokDAn+FG6egMs1agoZ1f70sBrOllaX6q461b+qbl1qGjksGT?=
 =?us-ascii?Q?CM7SBaaD6YvhrrAsSErXzgoyIFHAWQO8ikXbYyoWwbWWlhYvhSvaWLGh8lyI?=
 =?us-ascii?Q?Y2ekhKcmYCvltXcpC7WtRGcPy3AHhCeyisyjAKmoB+Ex3nK0OoxRiX9YFolV?=
 =?us-ascii?Q?ZGAEeZ8EbQQYeFL3wwFBUPIRSCypPxGdtHSkiVVA4BKN9+j0E4nlCDFWVsex?=
 =?us-ascii?Q?LXeuIs6lSQ5TRJcJ6jYapJdSHZVY5ZXH+XLB0rDH0x8aFk0IXLNf1FVJWCLp?=
 =?us-ascii?Q?lx+qz6/H4S0ZXpxaV9yg3C6Ub1oshA9MPBqmJ5YHknifyR06HVyXpO9dixV3?=
 =?us-ascii?Q?CFFtNXuqO+ganwaSQ7munzkTi1iQ45nqJo35oITzI9iZcemh1gXeqhhNDOuA?=
 =?us-ascii?Q?IU31mL7DBzqZ3qn5/JUEYZG59gGP8oQk4U7pfqTigQLiU85Cjzgjjgmfakdy?=
 =?us-ascii?Q?LSIl2RT79yhYO6H4l6koZBtTDEJEsu8gf5pfLNKfaRFbiD7jI+gFzZAiHYOT?=
 =?us-ascii?Q?nkRIN1PN40zF7ZWWd9G1iEscn5ER9FR9qS0a7NcbWMT88eJCdcVKrM/WXEWn?=
 =?us-ascii?Q?VSRvTMp2d+SgzfIUTOPOQ2HhoexyPKSAceDzwRx/JPqSoa8sMzrWXU+Cwxud?=
 =?us-ascii?Q?5/E6UJVMEAyDuiEjvzQc8wFoXnpACtkZrSLD4WcVMh7lhxWCywMPJL8g5iKi?=
 =?us-ascii?Q?K+WqxwR6QgJrPCemaBYaIr7rUAFCSZEGgvbNfdvryUlYBMw07UBGozV1k1ld?=
 =?us-ascii?Q?ZYal9O4uycEwqQyd6i6z7XYWs0MIrQyGOmbDvcVxTAOt5nDDpxrtBUxEdaUH?=
 =?us-ascii?Q?DnaL/ssx8Pu+G/mWSmS1jXWDIu+/fzstarFKvpMBN9phFD++FQmla4FtZgss?=
 =?us-ascii?Q?UD9OCTJpmBN1ZemGZo1VynhpVSpcFplVdxklBpzE+KFp/7MJlmYGHOatrQ61?=
 =?us-ascii?Q?wu7yHzMwzKncHCgd8btPuGmr8aiLVflWcgwInGOoRFecHfUuuzPpBU8+F355?=
 =?us-ascii?Q?6TCZBSodGaFOT+GW4/0gLwEZED6tINsWZQD5lzrfXBfMnoRyytTtQXOygp6U?=
 =?us-ascii?Q?OB6NqGjHuabOQMrvP1e9H3c7UM8LRyyq2laOwQUjrQJzZbBPK2xt/8C/9uZe?=
 =?us-ascii?Q?lnsiBYcf9jM6msWs0snOcvBjoZezJ2u3sGymSqAfR1NBz31b7LniXNXKp48L?=
 =?us-ascii?Q?mJcJPG2p8WTBZCAAhlD7Ihre3Fy756NW0qWSaaJHXdthMCNdVvxzs3A3/zQD?=
 =?us-ascii?Q?26Zs4AP9tYZrHfQm9BUwtlQMkEFivqqv3bNGFoOZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5591.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b338b0dc-0e5e-46e8-a39d-08da7c120519
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2022 03:23:26.2544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OZ6ak1XYkudxpH2QA1KhFT2RcuCahTt8tIgYtn9N53xz6X4Ky9Fan98ojpfwvSKhUvhBKiKD1AGok5X+6ygj+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4894
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> -----Original Message-----
> From: Haitao Huang <haitao.huang@linux.intel.com>
> Sent: Thursday, August 11, 2022 7:30 PM
> To: Dhanraj, Vijay <vijay.dhanraj@intel.com>; Jarkko Sakkinen
> <jarkko@kernel.org>
> Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang, Haitao
> <haitao.huang@intel.com>
> Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
>=20
> Hi Jarkko
>=20
> On Wed, 10 Aug 2022 20:50:54 -0500, Jarkko Sakkinen <jarkko@kernel.org>
> wrote:
>=20
> > On Thu, Aug 11, 2022 at 04:36:57AM +0300, Jarkko Sakkinen wrote:
> >> On Thu, Aug 11, 2022 at 04:01:15AM +0300, Jarkko Sakkinen wrote:
> >> > On Wed, Aug 10, 2022 at 12:09:56AM +0000, Dhanraj, Vijay wrote:
> >> > >
> >> > >
> >> > > > -----Original Message-----
> >> > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> >> > > > Sent: Tuesday, August 9, 2022 11:53 AM
> >> > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> >> > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> >> > > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com;
> >> > > > Huang,
> >> Haitao
> >> > > > <haitao.huang@intel.com>
> >> > > > Subject: Re: [PATCH] Add SGX selftest
> >> > > > `augment_via_eaccept_long`
> >> > > >
> >> > > > On Tue, Aug 09, 2022 at 05:08:21PM +0000, Dhanraj, Vijay wrote:
> >> > > > >
> >> > > > >
> >> > > > > > -----Original Message-----
> >> > > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> >> > > > > > Sent: Tuesday, August 9, 2022 9:10 AM
> >> > > > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> >> > > > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> >> > > > > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com;
> >> Huang,
> >> > > > > > Haitao <haitao.huang@intel.com>
> >> > > > > > Subject: Re: [PATCH] Add SGX selftest
> >> `augment_via_eaccept_long`
> >> > > > > >
> >> > > > > > On Tue, Aug 09, 2022 at 01:45:35PM +0300, Jarkko Sakkinen
> >> wrote:
> >> > > > > > > On Mon, Aug 08, 2022 at 06:29:13PM +0300, Jarkko Sakkinen
> >> wrote:
> >> > > > > > > > On Mon, Aug 08, 2022 at 01:00:54PM +0000, Dhanraj,
> >> > > > > > > > Vijay
> >> wrote:
> >> > > > > > > > >
> >> > > > > > > > > > -----Original Message-----
> >> > > > > > > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> >> > > > > > > > > > Sent: Monday, August 8, 2022 5:18 AM
> >> > > > > > > > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> >> > > > > > > > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> >> > > > > > > > > > <reinette.chatre@intel.com>;
> >> dave.hansen@linux.intel.com;
> >> > > > > > > > > > Huang, Haitao <haitao.huang@intel.com>
> >> > > > > > > > > > Subject: Re: [PATCH] Add SGX selftest
> >> > > > > > > > > > `augment_via_eaccept_long`
> >> > > > > > > > > >
> >> > > > > > > > > > On Thu, Aug 04, 2022 at 01:14:56PM -0700,
> >> > > > > > > > > > vijay.dhanraj@intel.com
> >> > > > > > wrote:
> >> > > > > > > > > > > From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> >> > > > > > > > > > >
> >> > > > > > > > > > > This commit adds a new test case which is same as
> >> > > > > > > > > > > `augment_via_eaccept` but adds more number of EPC
> >> pages to
> >> > > > > > > > > > > stress test
> >> > > > > > > > > > `EAUG` via `EACCEPT`.
> >> > > > > > > > > > >
> >> > > > > > > > > > > Signed-off-by: Vijay Dhanraj
> >> <vijay.dhanraj@intel.com>
> >> > > > > > > > > > > Signed-off-by: Haitao Huang
> >> <haitao.huang@linux.intel.com>
> >> > > > > > > > > >
> >> > > > > > > > > > Hey, to reproduce the original issue: does it
> >> reproduce on
> >> > > > > > > > > > VM or should I run baremetal kernel?
> >> > > > > > > > > >
> >> > > > > > > > > > BR, Jarkko
> >> > > > > > > > >
> >> > > > > > > > > Hi Jarkko, The issue should be reproducible on
> >> baremetal kernel.
> >> > > > > > > >
> >> > > > > > > > Thanks.
> >> > > > > > >
> >> > > > > > > I need comment out other tests in order to make sane out
> >> > > > > > > of
> >> this
> >> > > > > > > :-)
> >> > > > > > >
> >> > > > > > > Mentioning this because came into realization that stress
> >> tests
> >> > > > > > > should be IMHO moved each to a separate binary (so that
> >> they can
> >> > > > > > > be run separately). Just a note (TODO) to myself.
> >> > > > > > >
> >> > > > > > > I'll work on this today again and *possibly* split your
> >> test to
> >> > > > > > > its own application to get a starting point for
> >> forementioned.
> >> > > > > >
> >> > > > > > I got
> >> > > > > >
> >> > > > > > #  RUN           enclave.augment_via_eaccept_long ...
> >> > > > > > # main.c:1241:augment_via_eaccept_long:test enclave:
> >> total_size =3D
> >> > > > > > 8192,
> >> > > > > > seg->size =3D 8192 #
> >> > > > > > seg->main.c:1241:augment_via_eaccept_long:test
> >> enclave:
> >> > > > > > total_size =3D 12288, seg->size =3D 4096 #
> >> > > > > > main.c:1241:augment_via_eaccept_long:test enclave:
> >> > > > > > total_size
> >> =3D
> >> > > > > > 36864,
> >> > > > > > seg->size =3D 24576 #
> >> > > > > > seg->main.c:1241:augment_via_eaccept_long:test
> >> enclave:
> >> > > > > > total_size =3D 40960, seg->size =3D 4096 #
> >> > > > > > main.c:1259:augment_via_eaccept_long:mmaping pages at end
> >> > > > > > of
> >> > > > enclave...
> >> > > > > > # main.c:1273:augment_via_eaccept_long:Entering enclave to
> >> > > > > > run EACCEPT for each page of 8589934592 bytes may take a whi=
le
> ...
> >> > > > > > #            OK  enclave.augment_via_eaccept_long
> >> > > > > >
> >> > > > > > The CPU used for testing was according to /proc/cpuinfo:
> >> > > > > >
> >> > > > > > model name      : Intel(R) Xeon(R) Gold 6338 CPU @ 2.00GHz
> >> > > > > >
> >> > > > > > I have couple of queries:
> >> > > > > >
> >> > > > > > 1. Is it possible to get dmesg output?
> >> > > > > I did check the dmesg output but couldn't find anything
> >> > > > > related
> >> to the
> >> > > > failure. Just the general log messages.
> >> > > > >
> >> > > > > > 2. Do I have to repeat the test multiple times, or does it
> >> > > > > >    occur unconditionaly?
> >> > > > > >
> >> > > > > I was able to repro every time but it was a bit sporadic for
> >> Haitao.
> >> > > > >
> >> > > > > > BR, Jarkko
> >> > > > >
> >> > > > > Also, did you set the PRMRR size to 2GB per socket in the BIOS=
?
> >> The
> >> > > > > issue is only reproduced for oversubscribed scenario. When I
> >> set my
> >> > > > > PRMRR to 64GB per socket, I wasn't able to repro the issue.
> >> > > >
> >> > > > I need to revisit this.
> >> > > >
> >> > > > Can you simply run test_sgx with gdb and see where it hits?
> >> > > > HOST_CFLAGS has apparently "-g" already.
> >> > > >
> >> > > > > Regards, Vijay
> >> > > >
> >> > > > BR, Jarkko
> >> > >
> >> > > I am able to repro the issue when I reduce the PRMRR to 2B/socket
> >> but not but not able to break on the assertion failure with gdb. I
> >> also enabled debug attribute in the secs but still no avail. Anything
> >> I am missing here?
> >> > >
> >> > > diff --git a/tools/testing/selftests/sgx/load.c
> >> b/tools/testing/selftests/sgx/load.c
> >> > > index 7de1b15c90b1..c4bccd3f5f17 100644
> >> > > --- a/tools/testing/selftests/sgx/load.c
> >> > > +++ b/tools/testing/selftests/sgx/load.c
> >> > > @@ -87,7 +87,7 @@ static bool encl_ioc_create(struct encl *encl)
> >> > >
> >> > >         memset(secs, 0, sizeof(*secs));
> >> > >         secs->ssa_frame_size =3D 1;
> >> > > -       secs->attributes =3D SGX_ATTR_MODE64BIT;
> >> > > +       secs->attributes =3D SGX_ATTR_MODE64BIT | SGX_ATTR_DEBUG;
> >> > >         secs->xfrm =3D 3;
> >> > >         secs->base =3D encl->encl_base;
> >> > >         secs->size =3D encl->encl_size;
> >> > >
> >> > > Regards, Vijay
> >> >
> >> > I get also full pass with 2GB configuration (and also observed that
> >> > kselftest runs much faster with this configuration).
> >> >
> >> > But I looked at sgx_alloc_epc_page() and saw this:
> >> >
> >> >                if (list_empty(&sgx_active_page_list))
> >> >                         return ERR_PTR(-ENOMEM);
> >> >
> >> >                 if (!reclaim) {
> >> >                         page =3D ERR_PTR(-EBUSY);
> >> >                         break;
> >> >                 }
> >> >
> >> > In sgx_vma_fault(), when running completely out of reclaimable
> >> > pages,
> >> this
> >> > causes VM_FAULT_SIGBUS returned instead of VM_FAULT_NOPAGE:
> >> >
> >> > 	entry =3D sgx_encl_load_page(encl, addr, vma->vm_flags);
> >> > 	if (IS_ERR(entry)) {
> >> > 		mutex_unlock(&encl->lock);
> >> >
> >> > 		if (PTR_ERR(entry) =3D=3D -EBUSY)
> >> > 			return VM_FAULT_NOPAGE;
> >> >
> >> > 		return VM_FAULT_SIGBUS;
> >> > 	}
> >> >
> >> > Not sure if those should be re-ordered that would keep the process
> >> stuck up
> >> > until there is something to reclaim. Now we use NOPAGE to address
> >> situation
> >> > when there is actually something to reclaim but because of locking
> >> side of
> >> > things we pass reclaim=3Dfalse to sgx_alloc_epc_page().
> >> >
> >> > So this is kind of OOM behaviour how it works now instead of
> >> > stalling processes.
> >>
> >> Right, I looked at the original email at was really a page fault that
> >> was catched. The above theory cannot possibly hold, as the process
> >> does not exit with a bus error.
> >>
> >> I looked next to sgx_encl_eaug_page(), and found this:
> >>
> >>         encl_page =3D sgx_encl_page_alloc(encl, addr - encl->base,
> >> secinfo_flags);
> >>         if (IS_ERR(encl_page))
> >>                 return VM_FAULT_OOM;
> >>
> >> This is AFAIK the only code path in sgx_vma_fault() flow that
> >> allocates non-EPC memory, and the code paths where EPC allocation
> >> fails the result would be SIGBUS.
> >>
> >> So perhaps allocation is failing here. You could pretty easily trace
> >> allocations with bpftrace and kretprobe to see if this is what is
> >> happening, e.g. in one terminal:
> >>
> >> sudo bpftrace -e 'kr:sgx_encl_page_alloc /retval !=3D 0/ {
> >> printf("%d\n", retval); }'
> >
> > Should be
> >
> > sudo bpftrace -e 'kr:sgx_encl_page_alloc /(long)retval < 0/ {
> > printf("%d\n", retval); }'
> >
> > BR, Jarkko
>=20
> I tried these probs and got following results when failure happens (not
> always happen on my device).
>=20
> sudo bpftrace -e 'kr:sgx_encl_page_alloc /(int64)retval <0 / { printf("%X=
\n",
> retval); }'
>=20
> --> lots of negative values, I believe they are valid addresses in
> unsigned long type. So I looked up IS_ERR_VALUE macro and translated it i=
n
> following probes.
>=20
> sudo bpftrace -e 'kr:sgx_encl_page_alloc /(uint64)retval >=3D (uint64)(-4=
095)/ {
> printf("%X\n", retval); }'
>=20
> --> none triggered
>=20
> sudo bpftrace -e 'kr:sgx_alloc_epc_page /(uint64)retval >=3D (uint64)(-40=
95)/ {
> printf("%X\n", retval); }'
>=20
> --> FFFFFFF0 printed, which I believe is -EBUSY.
>=20
> BR
> Haitao

I see the same behavior as Haitao.=20
sudo bpftrace -e 'kr:sgx_encl_page_alloc /(long)retval < 0/ { printf("%d\n"=
, retval); } -> This one gave an error stdin:1:24-31: ERROR: Unknown struct=
/union: 'long' =20

So switched to sudo bpftrace -e 'kr:sgx_encl_page_alloc /(int64)retval <0 /=
 { printf("%X\n", retval); }' as suggested by Haitao and do see lot of posi=
tive and negative values.

sudo bpftrace -e 'kr:sgx_encl_page_alloc /(uint64)retval >=3D (uint64)(-409=
5)/ { printf("%X\n", retval); }' -> No output.

sudo bpftrace -e 'kr:sgx_alloc_epc_page /(uint64)retval >=3D (uint64)(-4095=
)/ { printf("%X\n", retval); } -> FFFFFFF0 is printed.

Thanks, Vijay


