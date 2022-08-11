Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E395C00140
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Aug 2022 02:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiHKCCC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Aug 2022 22:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiHKCCB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 10 Aug 2022 22:02:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFC1E0A0
        for <linux-sgx@vger.kernel.org>; Wed, 10 Aug 2022 19:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660183318; x=1691719318;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WqSF2a516ZGrW8X4xLqbUucHzoZgY/3I9gM6tlgAbVI=;
  b=VD2owIN/AA3fQF4aiNfOqzAXaLYhzCn9QuIQ0BkvBXDgpJXfu2/r6rZs
   24peYsjLjhGWB+RuRxJurlqFOGWSR/d7/Fvx3HrmvDNFOIxIzpno7+Y5i
   xCSd4agQI94oAkAnzzh1rhHZ9sIFUeOOsp66wcpEb3hNc4Q8qTT9+c68B
   1hBxkLMhkY6E3bUhK7hVMiVEFbadj9fJnBjblKUZ7z8zNwTx4V/vrPQpa
   WH3mMTFoP52XS/ZEpCvq+Irg8aDhfQIJAwSbDVi6x5EwwHPHp/oioTwTL
   N1oBf0uzdZ3sQUUXcsUb7I+i90V+LGpO66T8P6JWMMVmGEwNCqzV5Fe+0
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="278179908"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="278179908"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 19:01:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="665162551"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 10 Aug 2022 19:01:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 19:01:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 19:01:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 10 Aug 2022 19:01:56 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 10 Aug 2022 19:01:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llEDyFGc+Zgv3HgVdl18FQGWYV/r2YzS3duDRzG5vkw+KO+kFohWQ4EAoz8/BnCTlPVYGqPX+oiN8y7gC+2ypfYsODFPxqZPf3RRCLvMLFMol9DR5GahBLFd0zyhnwrkaxekkQkjjFmR6bV1fc+uHWfX6S13Zni6FxUauyQa2Bdy67pdi8JxiMEcR2Yc7ppesabi+OH2omAVQnpJxhCfPv6ue532gVvlTmALKIyAlTxbJ8hbtSN0a5Jo3UKTh5U5hXb3c/hi4vMW1Rri42cSqIlZuGpRmy6+aGRGtIEqmgITnTvFrXdoYUnHBJIxBlf66f7XTqGKOLNah0vaq3lC+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Er+FgB/Ep2ylLfE1Fz4Sl0L/7UfngqBVQ6x6iGTwJXg=;
 b=cd1F65F8w4hJ6WJQ5A3L7m16gaE+DViyqASTOP75FUESuxcaaMCjMzxo6GjG3PfKBy9Xxy5vi2URGXfXw5cHXXE6PnPIJWr10IiTKeC6sBfAg8B1sFHgWzW2VRh4rfvYjy9XFIVn8l2lYY6zLXPcIqJ25//zmvTd+TW7x/7bBHUZQzLomg+fvYqC9UdZNs/zutAwVxYeJFCJLHnSuAEp/6gvM0htbg/XVLfu5nwzmUUYekhSXrmF1B4BF0+23zkoN6kEV/dYTjuJBFgmhC9si4lMPPKONIojbzvMaVxbz+PfcqPgDfMIyPvlueRr9Sm+EliCP4CeKfax5qf3Paj1EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) by
 BYAPR11MB2853.namprd11.prod.outlook.com (2603:10b6:a02:c8::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Thu, 11 Aug 2022 02:01:54 +0000
Received: from DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee]) by DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee%8]) with mapi id 15.20.5525.011; Thu, 11 Aug 2022
 02:01:54 +0000
From:   "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: RE: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Topic: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Index: AQHYqD8zl0cVZTXY9kygyA0BTFvLEK2k8WeAgAAK/MCAACpYgIABQxaAgABajACAAA2M0IAAICAAgABWSfCAAaLlgIAACfYAgAAD6gCAAALkoA==
Date:   Thu, 11 Aug 2022 02:01:54 +0000
Message-ID: <DM8PR11MB55918AAF9E30BF84EC60994AF6649@DM8PR11MB5591.namprd11.prod.outlook.com>
References: <YvD/DUGRBR2Tns88@kernel.org>
 <DM8PR11MB559100639C945285BF1D6F87F6639@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvEryXfefz62ivEa@kernel.org> <YvI6z7wgV2VQtNV7@kernel.org>
 <YvKGxIEpdnawb0bY@kernel.org>
 <DM8PR11MB5591108F54901FBB198E6E04F6629@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvKskgNrTDC/e8pf@kernel.org>
 <DM8PR11MB5591D9B8653A2CF9D9CD5A3EF6659@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvRU29VR/bkPLzS+@kernel.org> <YvRdNnvS71U+6Dq7@kernel.org>
 <YvRgfhHFAHCvH820@kernel.org>
In-Reply-To: <YvRgfhHFAHCvH820@kernel.org>
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
x-ms-office365-filtering-correlation-id: bfff63e0-cc70-49b6-db6a-08da7b3d76b6
x-ms-traffictypediagnostic: BYAPR11MB2853:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zfo4N6mEV4x11RrHG5PijgeXuTCSY/lJ7IDvPnXfQf4nyZierdQ9Ny6XZPcwKmUWFqtJmCzvxl9AhnQO5LRJ75d5Qh8S2Mb3c4BsHKstbp9WzKNoe5ZXnz19dCQnGAoHIeRuCKOa0uz0S4jTyrrU4Hr3hSe544gvWRG3B8JuHx28ErHhiFCpbu5qehsvPQmiR4KRYYNDXyopts85z7FnPGuMfWlDY6pQWLfXd2/aP3NjvpeHAO7SczL/unRxlMhUvxMTwCRCLVxXw6UvqZe0uvUJhCLWSjvQ3hawCLaeT1VQJzVQ3uIGWS0ZgnyJuqKyGkINpgo5A+ALXGfhWsGV+Mz0+ep7KxpiGIQdG50+2g7cOBi2CehphLj/8jxXZO1lhSaE+gGPPOG1fiD+5OBS7P6u+6vqAFRKkyjwCSQYfnw0/mrRQXrXQKc9kyEIKaET6Y7SVgM2aJSeHJQNqTSHYFIQ+PzpN2dmyFMIJhDll9FQ/FcashKcnluJRVwBw9eMOrbvkBMZ1mts07r3J7Pjj8WYKwSs9LmrjHtqQmb/PcVblaQZ6sSS7juvbXieJJwXaA7nE3aZgUsY3W2s19TubVDLrnM1jJOQEmYNlYXdlhI8MvpZjLtqOjPAAU4Hl67T35zeuoI6D2qrHDa7U4QMOvpVyxdMtynDVxndFyu7ETzYArkALiiN8YrLG4stBoX1nrLkRloLgarpF1ZGmBoAyM7Xd7Rfvl7EfrPsbZVeW7nMeir39hhGtS7LGA5WQ62NRvzLHwuXNEw/CnUWN8RYPbko6jczRU6GG2uNTjpV034koMJPg351YYJ/SajkkgzUTrgQ5TTFLGX5aZw8pXM2oQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5591.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39860400002)(136003)(376002)(366004)(38070700005)(83380400001)(26005)(4326008)(8936002)(186003)(316002)(76116006)(33656002)(9686003)(86362001)(6506007)(2906002)(7696005)(53546011)(6916009)(66556008)(41300700001)(38100700002)(66446008)(66476007)(71200400001)(64756008)(66946007)(5660300002)(54906003)(82960400001)(8676002)(52536014)(122000001)(478600001)(55016003)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WLBPzhOAfx4uvfgjQPeP0SGBSBvBc3PX9/KBMs0nQ0vaNU+r7MWRA2sB12ZA?=
 =?us-ascii?Q?kOoEmgH1tFJy2LbBx7HQ015THob3j47HB8RnHIDxT/lb28NmiQ/ZdiJKLvaj?=
 =?us-ascii?Q?rrTAdCiKKhIjkKS82pGqGrE5zl2Ghbi6XjWEd1b56GNcw2CAqMPrWjt3DRAk?=
 =?us-ascii?Q?YluIDV124qqX9WIkxh29MH8+FI8mgFl/3OjNPXN8AslqSzbhLDy24r89iEGV?=
 =?us-ascii?Q?pYwV4riM0DGELCk+NNZH7Fn/iJPysHtse86ukNArsh4jZdJIbDvXmyTNFH0e?=
 =?us-ascii?Q?HaQq39HwbnYjNvqx01Qz9WXwfPQP+/XPP+0dwQRorAA/W8UaBe518hx9dvg1?=
 =?us-ascii?Q?tyq/RMbtGxLSdpYamJjq62LbAZf1dpJ3o8nxocm1CesV2iTyEtWygkacPAtF?=
 =?us-ascii?Q?crOou7/tkNak+B6VQijLF8tgn79+clO+j6CLyvWyCCHSQE/63BfGA9hDnoQb?=
 =?us-ascii?Q?x6+PRoSh93XyzMNL90Fp8TaM7HzKIfBIuhsRhBlAFDIyW09jdjRZGuTQePaL?=
 =?us-ascii?Q?OAHRP51Hb0GgiXOrywR4qroMecOnCKad41fYEw+1XyDtbsXgJu5dGh/YJsjR?=
 =?us-ascii?Q?56WqyRbQauxGrTm0+3WC/PowuKsBvfXI3AzzWsBuTBAcX+inzXCl5IIf7Swq?=
 =?us-ascii?Q?joBk5wLV+Ux3zWvU6V0nQfPT/AmdkDS3y/RgxAUKLfTm9iic71lV+CTIJXGB?=
 =?us-ascii?Q?V970vd3WsbrrmM1pGguLQ8bfwFRsvrffYBQRG8O9S4z8R9CBiDS4/my5EjLW?=
 =?us-ascii?Q?ehml63h3tpeEnETr2RVPo7U2FKBUHVthOGxqbiYM5eMJdX9LcQEtLTEdFgNN?=
 =?us-ascii?Q?PnYbZtVht1BXZXgLcS7sdZTEMbT6X8sIn21TjWeLW4gt1joNUrLVkwTM3RqO?=
 =?us-ascii?Q?dB7vVNryH5xXkdfY4+m9m6deYTJcLIcPvUsJ+RQyFCzfpb8n3vFZyNDfTPB7?=
 =?us-ascii?Q?zR4tgJjoysCqhu9MfAE67zWVeLHbU0uLZg68Hg9FXs9OxZYA1aBw/liowtil?=
 =?us-ascii?Q?ZneoLhz4kTm3aYE3MZCic63n1CEH3dTcQWcx4TI8UsolsyIyh2F+nfPmGGtc?=
 =?us-ascii?Q?Ty4rkblDSQ+Q0/+qr7qySUqAJ+S3yb7ed6LRRY4+1gHzyTDbZyeDOsrlMpDv?=
 =?us-ascii?Q?My654MTGLrbFV/yzoK3PrLXPRAGkULhSfaahvEIVU+JGUWKzepfqzSQoXr6h?=
 =?us-ascii?Q?LAj5JTHnh/RRJKTNlntKJKFFzRoW1NNDoM6T1ApWybDG8klLUbtcWK6D7dXz?=
 =?us-ascii?Q?m2kLt8WTSES6rbQLIda1v67K+pqNoBSr6TSTNQtv8QYrl9v0BxHiLilPXOtj?=
 =?us-ascii?Q?tnAThBfsaOVMwxIJaPVu55xqkifxkBYkskX1P56DiwVMYG65Dgf3H6+tej/V?=
 =?us-ascii?Q?4p3lIU4Dx+oXKRUWrWH6u0Lsk7sWKUtjjiE+XJmTshJOUewK/9btHkm7NMnc?=
 =?us-ascii?Q?IAS2wUB38AzMHDu1qLvMlpY30KkT5ZtR/MF6AyVTbWHgcxKym4iFunhUPt+Y?=
 =?us-ascii?Q?C5AuzhPHzq6HCc1lBY9b/mmEIxGyCcJZEkUrrRjSgrLfHI5a8n2Tws7SY95E?=
 =?us-ascii?Q?ZfbiBBuQt7kAnPjYZqNuIAxYhlNw7IQZ65Px6D02?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5591.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfff63e0-cc70-49b6-db6a-08da7b3d76b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 02:01:54.0950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: buGVJU7vV9raPZEMlInrw/63rbjzvjIkXWVODKmAIAbR9Z306V7jj0+L4RvF4ufp7YdaJm9LmrBaW+jZC8QK/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2853
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> -----Original Message-----
> From: Jarkko Sakkinen <jarkko@kernel.org>
> Sent: Wednesday, August 10, 2022 6:51 PM
> To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang, Haitao
> <haitao.huang@intel.com>
> Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
>=20
> On Thu, Aug 11, 2022 at 04:36:57AM +0300, Jarkko Sakkinen wrote:
> > On Thu, Aug 11, 2022 at 04:01:15AM +0300, Jarkko Sakkinen wrote:
> > > On Wed, Aug 10, 2022 at 12:09:56AM +0000, Dhanraj, Vijay wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > > Sent: Tuesday, August 9, 2022 11:53 AM
> > > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang,
> > > > > Haitao <haitao.huang@intel.com>
> > > > > Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
> > > > >
> > > > > On Tue, Aug 09, 2022 at 05:08:21PM +0000, Dhanraj, Vijay wrote:
> > > > > >
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > > > > Sent: Tuesday, August 9, 2022 9:10 AM
> > > > > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > > > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > > > > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com;
> > > > > > > Huang, Haitao <haitao.huang@intel.com>
> > > > > > > Subject: Re: [PATCH] Add SGX selftest
> > > > > > > `augment_via_eaccept_long`
> > > > > > >
> > > > > > > On Tue, Aug 09, 2022 at 01:45:35PM +0300, Jarkko Sakkinen wro=
te:
> > > > > > > > On Mon, Aug 08, 2022 at 06:29:13PM +0300, Jarkko Sakkinen
> wrote:
> > > > > > > > > On Mon, Aug 08, 2022 at 01:00:54PM +0000, Dhanraj, Vijay
> wrote:
> > > > > > > > > >
> > > > > > > > > > > -----Original Message-----
> > > > > > > > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > > > > > > > > Sent: Monday, August 8, 2022 5:18 AM
> > > > > > > > > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > > > > > > > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > > > > > > > > > <reinette.chatre@intel.com>;
> > > > > > > > > > > dave.hansen@linux.intel.com; Huang, Haitao
> > > > > > > > > > > <haitao.huang@intel.com>
> > > > > > > > > > > Subject: Re: [PATCH] Add SGX selftest
> > > > > > > > > > > `augment_via_eaccept_long`
> > > > > > > > > > >
> > > > > > > > > > > On Thu, Aug 04, 2022 at 01:14:56PM -0700,
> > > > > > > > > > > vijay.dhanraj@intel.com
> > > > > > > wrote:
> > > > > > > > > > > > From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > > > > > > > > >
> > > > > > > > > > > > This commit adds a new test case which is same as
> > > > > > > > > > > > `augment_via_eaccept` but adds more number of EPC
> > > > > > > > > > > > pages to stress test
> > > > > > > > > > > `EAUG` via `EACCEPT`.
> > > > > > > > > > > >
> > > > > > > > > > > > Signed-off-by: Vijay Dhanraj
> > > > > > > > > > > > <vijay.dhanraj@intel.com>
> > > > > > > > > > > > Signed-off-by: Haitao Huang
> > > > > > > > > > > > <haitao.huang@linux.intel.com>
> > > > > > > > > > >
> > > > > > > > > > > Hey, to reproduce the original issue: does it
> > > > > > > > > > > reproduce on VM or should I run baremetal kernel?
> > > > > > > > > > >
> > > > > > > > > > > BR, Jarkko
> > > > > > > > > >
> > > > > > > > > > Hi Jarkko, The issue should be reproducible on baremeta=
l
> kernel.
> > > > > > > > >
> > > > > > > > > Thanks.
> > > > > > > >
> > > > > > > > I need comment out other tests in order to make sane out
> > > > > > > > of this
> > > > > > > > :-)
> > > > > > > >
> > > > > > > > Mentioning this because came into realization that stress
> > > > > > > > tests should be IMHO moved each to a separate binary (so
> > > > > > > > that they can be run separately). Just a note (TODO) to mys=
elf.
> > > > > > > >
> > > > > > > > I'll work on this today again and *possibly* split your
> > > > > > > > test to its own application to get a starting point for
> forementioned.
> > > > > > >
> > > > > > > I got
> > > > > > >
> > > > > > > #  RUN           enclave.augment_via_eaccept_long ...
> > > > > > > # main.c:1241:augment_via_eaccept_long:test enclave:
> > > > > > > total_size =3D 8192,
> > > > > > > seg->size =3D 8192 # main.c:1241:augment_via_eaccept_long:tes=
t
> enclave:
> > > > > > > total_size =3D 12288, seg->size =3D 4096 #
> > > > > > > main.c:1241:augment_via_eaccept_long:test enclave:
> > > > > > > total_size =3D 36864,
> > > > > > > seg->size =3D 24576 # main.c:1241:augment_via_eaccept_long:te=
st
> enclave:
> > > > > > > total_size =3D 40960, seg->size =3D 4096 #
> > > > > > > main.c:1259:augment_via_eaccept_long:mmaping pages at end of
> > > > > enclave...
> > > > > > > # main.c:1273:augment_via_eaccept_long:Entering enclave to
> > > > > > > run EACCEPT for each page of 8589934592 bytes may take a whil=
e
> ...
> > > > > > > #            OK  enclave.augment_via_eaccept_long
> > > > > > >
> > > > > > > The CPU used for testing was according to /proc/cpuinfo:
> > > > > > >
> > > > > > > model name      : Intel(R) Xeon(R) Gold 6338 CPU @ 2.00GHz
> > > > > > >
> > > > > > > I have couple of queries:
> > > > > > >
> > > > > > > 1. Is it possible to get dmesg output?
> > > > > > I did check the dmesg output but couldn't find anything
> > > > > > related to the
> > > > > failure. Just the general log messages.
> > > > > >
> > > > > > > 2. Do I have to repeat the test multiple times, or does it
> > > > > > >    occur unconditionaly?
> > > > > > >
> > > > > > I was able to repro every time but it was a bit sporadic for Ha=
itao.
> > > > > >
> > > > > > > BR, Jarkko
> > > > > >
> > > > > > Also, did you set the PRMRR size to 2GB per socket in the
> > > > > > BIOS? The issue is only reproduced for oversubscribed
> > > > > > scenario. When I set my PRMRR to 64GB per socket, I wasn't able=
 to
> repro the issue.
> > > > >
> > > > > I need to revisit this.
> > > > >
> > > > > Can you simply run test_sgx with gdb and see where it hits?
> > > > > HOST_CFLAGS has apparently "-g" already.
> > > > >
> > > > > > Regards, Vijay
> > > > >
> > > > > BR, Jarkko
> > > >
> > > > I am able to repro the issue when I reduce the PRMRR to 2B/socket b=
ut
> not but not able to break on the assertion failure with gdb. I also enabl=
ed
> debug attribute in the secs but still no avail. Anything I am missing her=
e?
> > > >
> > > > diff --git a/tools/testing/selftests/sgx/load.c
> > > > b/tools/testing/selftests/sgx/load.c
> > > > index 7de1b15c90b1..c4bccd3f5f17 100644
> > > > --- a/tools/testing/selftests/sgx/load.c
> > > > +++ b/tools/testing/selftests/sgx/load.c
> > > > @@ -87,7 +87,7 @@ static bool encl_ioc_create(struct encl *encl)
> > > >
> > > >         memset(secs, 0, sizeof(*secs));
> > > >         secs->ssa_frame_size =3D 1;
> > > > -       secs->attributes =3D SGX_ATTR_MODE64BIT;
> > > > +       secs->attributes =3D SGX_ATTR_MODE64BIT | SGX_ATTR_DEBUG;
> > > >         secs->xfrm =3D 3;
> > > >         secs->base =3D encl->encl_base;
> > > >         secs->size =3D encl->encl_size;
> > > >
> > > > Regards, Vijay
> > >
> > > I get also full pass with 2GB configuration (and also observed that
> > > kselftest runs much faster with this configuration).
> > >
> > > But I looked at sgx_alloc_epc_page() and saw this:
> > >
> > >                if (list_empty(&sgx_active_page_list))
> > >                         return ERR_PTR(-ENOMEM);
> > >
> > >                 if (!reclaim) {
> > >                         page =3D ERR_PTR(-EBUSY);
> > >                         break;
> > >                 }
> > >
> > > In sgx_vma_fault(), when running completely out of reclaimable
> > > pages, this causes VM_FAULT_SIGBUS returned instead of
> VM_FAULT_NOPAGE:
> > >
> > > 	entry =3D sgx_encl_load_page(encl, addr, vma->vm_flags);
> > > 	if (IS_ERR(entry)) {
> > > 		mutex_unlock(&encl->lock);
> > >
> > > 		if (PTR_ERR(entry) =3D=3D -EBUSY)
> > > 			return VM_FAULT_NOPAGE;
> > >
> > > 		return VM_FAULT_SIGBUS;
> > > 	}
> > >
> > > Not sure if those should be re-ordered that would keep the process
> > > stuck up until there is something to reclaim. Now we use NOPAGE to
> > > address situation when there is actually something to reclaim but
> > > because of locking side of things we pass reclaim=3Dfalse to
> sgx_alloc_epc_page().
> > >
> > > So this is kind of OOM behaviour how it works now instead of
> > > stalling processes.
> >
> > Right, I looked at the original email at was really a page fault that
> > was catched. The above theory cannot possibly hold, as the process
> > does not exit with a bus error.
> >
> > I looked next to sgx_encl_eaug_page(), and found this:
> >
> >         encl_page =3D sgx_encl_page_alloc(encl, addr - encl->base,
> secinfo_flags);
> >         if (IS_ERR(encl_page))
> >                 return VM_FAULT_OOM;
> >
> > This is AFAIK the only code path in sgx_vma_fault() flow that
> > allocates non-EPC memory, and the code paths where EPC allocation
> > fails the result would be SIGBUS.
> >
> > So perhaps allocation is failing here. You could pretty easily trace
> > allocations with bpftrace and kretprobe to see if this is what is
> > happening, e.g. in one terminal:
> >
> > sudo bpftrace -e 'kr:sgx_encl_page_alloc /retval !=3D 0/ { printf("%d\n=
",
> retval); }'
>=20
> Should be
>=20
> sudo bpftrace -e 'kr:sgx_encl_page_alloc /(long)retval < 0/ { printf("%d\=
n",
> retval); }'
>=20
> BR, Jarkko

Thanks let me check and get back to you.

Regards, Vijay
