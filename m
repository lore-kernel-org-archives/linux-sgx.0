Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BFFC25B0D
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Aug 2022 16:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiHOQQu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Aug 2022 12:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiHOQQt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 15 Aug 2022 12:16:49 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B741211818
        for <linux-sgx@vger.kernel.org>; Mon, 15 Aug 2022 09:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660580207; x=1692116207;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZZbHjkDAMkS9ptfgrnbgR2Bhkmu/O/gQmhJFu1CmJsM=;
  b=aLDwHNYlpQ8BYToRFf2HJeYeGpEfJ9EyyKOO4vT7EJiFN+oELDIniKqR
   MC1qhh1mzhck1xBAozdfG05pREYjPYKZPqq4t9fcg6eum3TLitQHDbT4E
   tm3WdKhTG8e+Espyz9oqtrzOqsOUkfG9N8EPRTxeHvjpe1RhVdcIVkKlC
   GWuL8Zje2h1mhBHD2OPCYS8edlsF7syPllVAMpg3pJrjh+XgukmKE/4TC
   QwiMhizb/mJXK6OQhgRNcgjXztEPYlhWBxDGKv30tLwVCI8Ei8G8s+/pX
   7/KMS+G1DQFBazp5efqjmzkjkH0TU+BitCJ5cbiJq+ZhRw/IqLEZedQEO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="290748374"
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="290748374"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 09:16:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="782703444"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 15 Aug 2022 09:16:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 15 Aug 2022 09:16:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 15 Aug 2022 09:16:46 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 15 Aug 2022 09:16:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4ZFqmfj0nV49byRL/a9yrxfqdB1LSwWQ+xRLzuhMHxW5JTnDTASMJPedX30MLgpfJucRL3UiUAXGef6poIzSh6hLT/uSuIusKABVaZhVFpg+3ja2/TwOB3xM0emHz2079LuQvs+dikxo5wV/QjsbU8DEaIDr3gLm5nxT4YmuPrgTE6SrhNrFEB0w+99J7flHYV2vqvQD6KNF5aICcQ1gxzlm0Az7FjTAzVhrZWyMI3j478P7eghrh1QB6QcWRhzWvrOYt0unHzg86ePPfvMwo332NoeJzdFFNu2CZXY/6x4JEaCjCwVKtVXJqoWMpB2VBSermI8zpMSWteXE5RPJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wnYogxsGXw8zwVLeqz4Q7zRrMmnxwLQwZ1FuvfjrC+c=;
 b=KvxPftRO0tkOILL8ymK06jCPd/lq6GABQfCIxU9x9IPfN7EbxjF+0xGh1eXtR+ft/gbBpl79RTH9aHNhrgotKEH7pjOkgiefCL12CthA8QfzsEmczn1yO5Hazfc1akAAfbPIRK5KRfWP6UjSz3v5i2XyMb8TUySME0J1A3y41stR18ltVY8FGgi4YPmjNW6JSVMbd/2Ojzu/vkjIU1vyv4E1c5uGMxN7kQw9W8Pl+TlsjT21U3RiLk0lNuXy+JN+8mC9y4rObcUsL7+FJYvA3Y+x1+TESwQt/Orxp/aurU3m0EW/CIuaK9m/+tpLR8W9mOB6D0oMPU19MAsXItQW0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) by
 SN6PR11MB3038.namprd11.prod.outlook.com (2603:10b6:805:cd::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Mon, 15 Aug 2022 16:16:44 +0000
Received: from DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee]) by DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee%8]) with mapi id 15.20.5525.011; Mon, 15 Aug 2022
 16:16:44 +0000
From:   "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     Haitao Huang <haitao.huang@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: RE: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Topic: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Index: AQHYqD8zl0cVZTXY9kygyA0BTFvLEK2k8WeAgAAK/MCAACpYgIABQxaAgABajACAAA2M0IAAICAAgABWSfCAAaLlgIAACfYAgAAD6gCAAZ0sAIAADc0AgAQdOoCAAXKnEA==
Date:   Mon, 15 Aug 2022 16:16:44 +0000
Message-ID: <DM8PR11MB55913F03BCDA4A076A26F9ADF6689@DM8PR11MB5591.namprd11.prod.outlook.com>
References: <YvI6z7wgV2VQtNV7@kernel.org> <YvKGxIEpdnawb0bY@kernel.org>
 <DM8PR11MB5591108F54901FBB198E6E04F6629@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvKskgNrTDC/e8pf@kernel.org>
 <DM8PR11MB5591D9B8653A2CF9D9CD5A3EF6659@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvRU29VR/bkPLzS+@kernel.org> <YvRdNnvS71U+6Dq7@kernel.org>
 <YvRgfhHFAHCvH820@kernel.org> <op.1qrnu0e4wjvjmi@hhuan26-mobl1.mshome.net>
 <DM8PR11MB5591076474DE227F6D9A90D2F6679@DM8PR11MB5591.namprd11.prod.outlook.com>
 <Yvk6LWH1sBYUCuCa@kernel.org>
In-Reply-To: <Yvk6LWH1sBYUCuCa@kernel.org>
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
x-ms-office365-filtering-correlation-id: fbe07f55-6b78-43dd-b26e-08da7ed98ba8
x-ms-traffictypediagnostic: SN6PR11MB3038:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T5tq6rxl/2cuJO+37OqOG1s7NWGDXiYympfNOqydZRqE+go/UiH8wowaUsrlrrdVsJ2GUsk0qfmDpUTYf13NPGiDSzuWN6cl1gBo7K1JQUe7kfgr72p97smLE84b77QwCe1Jqh3y0J5c8i0Ox0ylpHlOVM3Wdf71MvKcjILHVTacHY3JqiXRG126djdfNBqoP8higTQx9/iQ0shyfnGckigNxJvPCHVqJmJwpq7Q638V9fUW2t8DRT4DE1/ionWW6lpoMBsRAccrRUpcrJbzg5qUlZES8eVdShWJnJQdpJoNk1jD3KcSH1hVRMeiMGZBRYkU3ZCUumaCAzl0WVmyYvFnyXFCpIPriUP+IozhHrIDjpxlLAlVJEOQt5WIyFup5mGEYXQ3SLWoDE8yEmP2cGBbzuXSeaBF08IwiFcQEQ9jKOVfnUie/goMjO+7KDNiOejg9N1IUx1TF+T3IJBURTD7USecP+ttZJOP6+2ZyLDPTIbXGTDhGkDntx6LLr06LDYsw8Nox7S8VzpxqCLFDkaapdUWNVwncuh1k6/ztVuUGIOhGEclMXDAQDhNwa7jrmDMF85WK5/SKaxBUmL73z03JXo3fmn+f60/Z5uwaQbPJOhwKKLfZVqgZsG5XGdbv907b4G2L4Ad7mzJQH8e/TkU/VCoYy2Hcu+Y7KgWTkmkuVBxQiew/a2fVN+m5UCYkIovxr4stTfxtZb2Z4nt76uTPHyRYdZG0R5w5OvcFXkQDVSKzIHdR8IAypANGTZhbAApbJ+DkvGXC6y+J8nbPtLiVQU6zEW+gsRNcXu0tnGQHU7AP83/EAG7ZPPbhh5h8T58tepWkCtnK5bYfPPUBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5591.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(376002)(346002)(366004)(396003)(26005)(9686003)(71200400001)(41300700001)(83380400001)(7696005)(6506007)(53546011)(66446008)(64756008)(8936002)(316002)(54906003)(66946007)(6916009)(66476007)(4326008)(76116006)(66556008)(8676002)(186003)(2906002)(38070700005)(55016003)(52536014)(5660300002)(30864003)(478600001)(38100700002)(33656002)(86362001)(82960400001)(122000001)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sdsM9E5/+JR+apxN7sSXfMUqf+DEkTz+4sSrNmmFDRmajokR3JshWye9EjE1?=
 =?us-ascii?Q?BjeosDSZ7fALNnN9AkUC5XJ9PMgmItO2NbaZIWQMny0o2fpGBeUNr6V1TtOz?=
 =?us-ascii?Q?nT9pFjBLD3NeGNHs89EimE/nIDCR4F6NjWuU6ahuQVt+PmWlwevw0ljsJijb?=
 =?us-ascii?Q?5pOaFgCzPEd14AZUyq644jbwguQk7MyDXYadjLByjf08BLhwxHzmwl1JqXSf?=
 =?us-ascii?Q?qQ+s7FI/XkKBIoM/5W83fE04X/KQq3RzEeZWXvMH31d+vYkP0Pg7QBQDREga?=
 =?us-ascii?Q?hVdCWrNTeRi/ug/W1SCL+S+01cgP2mgiY1lws091gE/ny5DPgnKnPUztlKpI?=
 =?us-ascii?Q?b9juG/aVZl5oOZ4v0r9vtZeSDc9z5W31HB/SIEtP96GhTcTVKgBi9e3/ggWK?=
 =?us-ascii?Q?RM03TaWd8TskMHCpMOcuZTKicn/d7PG9GmkoPBGvEzW2KBromtSY0EACxNY8?=
 =?us-ascii?Q?+9suHWrBavtZolrRPYBzU8G7iMZKC3glYdwGXohMh7OdiXDduOr88iDKGIJJ?=
 =?us-ascii?Q?keup3lGtbisnK0eKR328eFAk3OuG67qW2hgiFVwioU9EnnfjChlPvXbKq5TZ?=
 =?us-ascii?Q?8pW877JmlMhTcSRsy7dM7iSfkNPEmOQw6sUUh3yUqLSy3+qtS8co3C0TisWp?=
 =?us-ascii?Q?Dd39vcYmyvSEp2kfnt3mQryU9xomtPbWUAuwwJzHZcDNYLrrfoJIR9TwO4LB?=
 =?us-ascii?Q?Jidzpr0u9Pkrdk2TgCKKz+ziBUR/+zrEsxdaaDUChqC8C3raCq+FJ4rY9DJ3?=
 =?us-ascii?Q?TeH5v8ZRnULyH23fFiFcxHdqCKRp76sGUtn6KOQz9Ej3XDLngQAXppxQC4TH?=
 =?us-ascii?Q?fScnJ//75b23xLpF1fj91LjHKhmN3HdaT1uxbIQjkmx1op1e8vptREcXDiIU?=
 =?us-ascii?Q?ro/X4iwowoY4rzu6y/ActCFSLngyBxecRzWiP1quwAB2nBRvkPLmwVwthxn2?=
 =?us-ascii?Q?F0FYw0Ac4zzr3+PLpI382gHCm3NS6Ze3JSOQ5CTG8XBC5rHiQfS3Hna9oZNX?=
 =?us-ascii?Q?QNoiu8KBbwqOSJq3gpHanjIj+YAlWAMQKG5MlAyck7yYGdDr12UjvYhPxb/Q?=
 =?us-ascii?Q?q4FMmqmrjtSn+slPCWf9fJVsBOH85GcfLEEnllaGeLz8VkfHPuYNwoW8dbEI?=
 =?us-ascii?Q?P7jP2Ig+9WMdWlxvnp0ctSsSqo032b+7LiPfKA/osyTgP/kohCS7SgfqU+v8?=
 =?us-ascii?Q?Imt06XWzgQOp8UbqLzmcPHaXuQRp7nNJQX6FZnARC5hRRfo2LiUvxh5Xf+6u?=
 =?us-ascii?Q?yig5V+X1cA2HrvOrcfOSpv5sBwG8Kk7cPo3udS5J4+SWmyg5hqB1YTAuSm4/?=
 =?us-ascii?Q?K+bMpxT6xP6dgZO9JsjoUOFb48lX6R0gX2Jt4CiLp3XPVETJGdbPyi5OPnDe?=
 =?us-ascii?Q?2NUhWKyagS91xcdKMgCrChqbJHRhen2vVvD/FmVvbxilHwHBYIlsZ/+wasVK?=
 =?us-ascii?Q?PZ2rZHRrrdCnLEYsvDlqQ4cRe/yF4sdzJQUCEWiotOzffgD5tVFT2vgcofMk?=
 =?us-ascii?Q?V6mzGws9LInzyQaiHNs64mAbNfzZgKbpg/9FaS/pEJSqfRwHrNxhSwf1QC+z?=
 =?us-ascii?Q?+xMg0ws3DorIITdpGeSyU5l8FhpxPupgi+uKq/N1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5591.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe07f55-6b78-43dd-b26e-08da7ed98ba8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2022 16:16:44.2125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WW7UQ6lGdBhB/k98biuPtzlEVoUfkXY2GbuJk5fCsaXK/IaHCEW+z0KE6KKo55TqtPu3hHwNUXWoAsDOG4vxDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3038
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> -----Original Message-----
> From: Jarkko Sakkinen <jarkko@kernel.org>
> Sent: Sunday, August 14, 2022 11:09 AM
> To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> Cc: Haitao Huang <haitao.huang@linux.intel.com>; linux-
> sgx@vger.kernel.org; Chatre, Reinette <reinette.chatre@intel.com>;
> dave.hansen@linux.intel.com; Huang, Haitao <haitao.huang@intel.com>
> Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
>=20
> On Fri, Aug 12, 2022 at 03:23:26AM +0000, Dhanraj, Vijay wrote:
> >
> >
> > > -----Original Message-----
> > > From: Haitao Huang <haitao.huang@linux.intel.com>
> > > Sent: Thursday, August 11, 2022 7:30 PM
> > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>; Jarkko Sakkinen
> > > <jarkko@kernel.org>
> > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang,
> > > Haitao <haitao.huang@intel.com>
> > > Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
> > >
> > > Hi Jarkko
> > >
> > > On Wed, 10 Aug 2022 20:50:54 -0500, Jarkko Sakkinen
> > > <jarkko@kernel.org>
> > > wrote:
> > >
> > > > On Thu, Aug 11, 2022 at 04:36:57AM +0300, Jarkko Sakkinen wrote:
> > > >> On Thu, Aug 11, 2022 at 04:01:15AM +0300, Jarkko Sakkinen wrote:
> > > >> > On Wed, Aug 10, 2022 at 12:09:56AM +0000, Dhanraj, Vijay wrote:
> > > >> > >
> > > >> > >
> > > >> > > > -----Original Message-----
> > > >> > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > >> > > > Sent: Tuesday, August 9, 2022 11:53 AM
> > > >> > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > >> > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > >> > > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com;
> > > >> > > > Huang,
> > > >> Haitao
> > > >> > > > <haitao.huang@intel.com>
> > > >> > > > Subject: Re: [PATCH] Add SGX selftest
> > > >> > > > `augment_via_eaccept_long`
> > > >> > > >
> > > >> > > > On Tue, Aug 09, 2022 at 05:08:21PM +0000, Dhanraj, Vijay wro=
te:
> > > >> > > > >
> > > >> > > > >
> > > >> > > > > > -----Original Message-----
> > > >> > > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > >> > > > > > Sent: Tuesday, August 9, 2022 9:10 AM
> > > >> > > > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > >> > > > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > >> > > > > > <reinette.chatre@intel.com>;
> > > >> > > > > > dave.hansen@linux.intel.com;
> > > >> Huang,
> > > >> > > > > > Haitao <haitao.huang@intel.com>
> > > >> > > > > > Subject: Re: [PATCH] Add SGX selftest
> > > >> `augment_via_eaccept_long`
> > > >> > > > > >
> > > >> > > > > > On Tue, Aug 09, 2022 at 01:45:35PM +0300, Jarkko
> > > >> > > > > > Sakkinen
> > > >> wrote:
> > > >> > > > > > > On Mon, Aug 08, 2022 at 06:29:13PM +0300, Jarkko
> > > >> > > > > > > Sakkinen
> > > >> wrote:
> > > >> > > > > > > > On Mon, Aug 08, 2022 at 01:00:54PM +0000, Dhanraj,
> > > >> > > > > > > > Vijay
> > > >> wrote:
> > > >> > > > > > > > >
> > > >> > > > > > > > > > -----Original Message-----
> > > >> > > > > > > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > >> > > > > > > > > > Sent: Monday, August 8, 2022 5:18 AM
> > > >> > > > > > > > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > >> > > > > > > > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > >> > > > > > > > > > <reinette.chatre@intel.com>;
> > > >> dave.hansen@linux.intel.com;
> > > >> > > > > > > > > > Huang, Haitao <haitao.huang@intel.com>
> > > >> > > > > > > > > > Subject: Re: [PATCH] Add SGX selftest
> > > >> > > > > > > > > > `augment_via_eaccept_long`
> > > >> > > > > > > > > >
> > > >> > > > > > > > > > On Thu, Aug 04, 2022 at 01:14:56PM -0700,
> > > >> > > > > > > > > > vijay.dhanraj@intel.com
> > > >> > > > > > wrote:
> > > >> > > > > > > > > > > From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > >> > > > > > > > > > >
> > > >> > > > > > > > > > > This commit adds a new test case which is
> > > >> > > > > > > > > > > same as `augment_via_eaccept` but adds more
> > > >> > > > > > > > > > > number of EPC
> > > >> pages to
> > > >> > > > > > > > > > > stress test
> > > >> > > > > > > > > > `EAUG` via `EACCEPT`.
> > > >> > > > > > > > > > >
> > > >> > > > > > > > > > > Signed-off-by: Vijay Dhanraj
> > > >> <vijay.dhanraj@intel.com>
> > > >> > > > > > > > > > > Signed-off-by: Haitao Huang
> > > >> <haitao.huang@linux.intel.com>
> > > >> > > > > > > > > >
> > > >> > > > > > > > > > Hey, to reproduce the original issue: does it
> > > >> reproduce on
> > > >> > > > > > > > > > VM or should I run baremetal kernel?
> > > >> > > > > > > > > >
> > > >> > > > > > > > > > BR, Jarkko
> > > >> > > > > > > > >
> > > >> > > > > > > > > Hi Jarkko, The issue should be reproducible on
> > > >> baremetal kernel.
> > > >> > > > > > > >
> > > >> > > > > > > > Thanks.
> > > >> > > > > > >
> > > >> > > > > > > I need comment out other tests in order to make sane
> > > >> > > > > > > out of
> > > >> this
> > > >> > > > > > > :-)
> > > >> > > > > > >
> > > >> > > > > > > Mentioning this because came into realization that
> > > >> > > > > > > stress
> > > >> tests
> > > >> > > > > > > should be IMHO moved each to a separate binary (so
> > > >> > > > > > > that
> > > >> they can
> > > >> > > > > > > be run separately). Just a note (TODO) to myself.
> > > >> > > > > > >
> > > >> > > > > > > I'll work on this today again and *possibly* split
> > > >> > > > > > > your
> > > >> test to
> > > >> > > > > > > its own application to get a starting point for
> > > >> forementioned.
> > > >> > > > > >
> > > >> > > > > > I got
> > > >> > > > > >
> > > >> > > > > > #  RUN           enclave.augment_via_eaccept_long ...
> > > >> > > > > > # main.c:1241:augment_via_eaccept_long:test enclave:
> > > >> total_size =3D
> > > >> > > > > > 8192,
> > > >> > > > > > seg->size =3D 8192 #
> > > >> > > > > > seg->main.c:1241:augment_via_eaccept_long:test
> > > >> enclave:
> > > >> > > > > > total_size =3D 12288, seg->size =3D 4096 #
> > > >> > > > > > main.c:1241:augment_via_eaccept_long:test enclave:
> > > >> > > > > > total_size
> > > >> =3D
> > > >> > > > > > 36864,
> > > >> > > > > > seg->size =3D 24576 #
> > > >> > > > > > seg->main.c:1241:augment_via_eaccept_long:test
> > > >> enclave:
> > > >> > > > > > total_size =3D 40960, seg->size =3D 4096 #
> > > >> > > > > > main.c:1259:augment_via_eaccept_long:mmaping pages at
> > > >> > > > > > end of
> > > >> > > > enclave...
> > > >> > > > > > # main.c:1273:augment_via_eaccept_long:Entering enclave
> > > >> > > > > > to run EACCEPT for each page of 8589934592 bytes may
> > > >> > > > > > take a while
> > > ...
> > > >> > > > > > #            OK  enclave.augment_via_eaccept_long
> > > >> > > > > >
> > > >> > > > > > The CPU used for testing was according to /proc/cpuinfo:
> > > >> > > > > >
> > > >> > > > > > model name      : Intel(R) Xeon(R) Gold 6338 CPU @ 2.00G=
Hz
> > > >> > > > > >
> > > >> > > > > > I have couple of queries:
> > > >> > > > > >
> > > >> > > > > > 1. Is it possible to get dmesg output?
> > > >> > > > > I did check the dmesg output but couldn't find anything
> > > >> > > > > related
> > > >> to the
> > > >> > > > failure. Just the general log messages.
> > > >> > > > >
> > > >> > > > > > 2. Do I have to repeat the test multiple times, or does =
it
> > > >> > > > > >    occur unconditionaly?
> > > >> > > > > >
> > > >> > > > > I was able to repro every time but it was a bit sporadic
> > > >> > > > > for
> > > >> Haitao.
> > > >> > > > >
> > > >> > > > > > BR, Jarkko
> > > >> > > > >
> > > >> > > > > Also, did you set the PRMRR size to 2GB per socket in the
> BIOS?
> > > >> The
> > > >> > > > > issue is only reproduced for oversubscribed scenario.
> > > >> > > > > When I
> > > >> set my
> > > >> > > > > PRMRR to 64GB per socket, I wasn't able to repro the issue=
.
> > > >> > > >
> > > >> > > > I need to revisit this.
> > > >> > > >
> > > >> > > > Can you simply run test_sgx with gdb and see where it hits?
> > > >> > > > HOST_CFLAGS has apparently "-g" already.
> > > >> > > >
> > > >> > > > > Regards, Vijay
> > > >> > > >
> > > >> > > > BR, Jarkko
> > > >> > >
> > > >> > > I am able to repro the issue when I reduce the PRMRR to
> > > >> > > 2B/socket
> > > >> but not but not able to break on the assertion failure with gdb.
> > > >> I also enabled debug attribute in the secs but still no avail.
> > > >> Anything I am missing here?
> > > >> > >
> > > >> > > diff --git a/tools/testing/selftests/sgx/load.c
> > > >> b/tools/testing/selftests/sgx/load.c
> > > >> > > index 7de1b15c90b1..c4bccd3f5f17 100644
> > > >> > > --- a/tools/testing/selftests/sgx/load.c
> > > >> > > +++ b/tools/testing/selftests/sgx/load.c
> > > >> > > @@ -87,7 +87,7 @@ static bool encl_ioc_create(struct encl
> > > >> > > *encl)
> > > >> > >
> > > >> > >         memset(secs, 0, sizeof(*secs));
> > > >> > >         secs->ssa_frame_size =3D 1;
> > > >> > > -       secs->attributes =3D SGX_ATTR_MODE64BIT;
> > > >> > > +       secs->attributes =3D SGX_ATTR_MODE64BIT |
> > > >> > > + SGX_ATTR_DEBUG;
> > > >> > >         secs->xfrm =3D 3;
> > > >> > >         secs->base =3D encl->encl_base;
> > > >> > >         secs->size =3D encl->encl_size;
> > > >> > >
> > > >> > > Regards, Vijay
> > > >> >
> > > >> > I get also full pass with 2GB configuration (and also observed
> > > >> > that kselftest runs much faster with this configuration).
> > > >> >
> > > >> > But I looked at sgx_alloc_epc_page() and saw this:
> > > >> >
> > > >> >                if (list_empty(&sgx_active_page_list))
> > > >> >                         return ERR_PTR(-ENOMEM);
> > > >> >
> > > >> >                 if (!reclaim) {
> > > >> >                         page =3D ERR_PTR(-EBUSY);
> > > >> >                         break;
> > > >> >                 }
> > > >> >
> > > >> > In sgx_vma_fault(), when running completely out of reclaimable
> > > >> > pages,
> > > >> this
> > > >> > causes VM_FAULT_SIGBUS returned instead of
> VM_FAULT_NOPAGE:
> > > >> >
> > > >> > 	entry =3D sgx_encl_load_page(encl, addr, vma->vm_flags);
> > > >> > 	if (IS_ERR(entry)) {
> > > >> > 		mutex_unlock(&encl->lock);
> > > >> >
> > > >> > 		if (PTR_ERR(entry) =3D=3D -EBUSY)
> > > >> > 			return VM_FAULT_NOPAGE;
> > > >> >
> > > >> > 		return VM_FAULT_SIGBUS;
> > > >> > 	}
> > > >> >
> > > >> > Not sure if those should be re-ordered that would keep the
> > > >> > process
> > > >> stuck up
> > > >> > until there is something to reclaim. Now we use NOPAGE to
> > > >> > address
> > > >> situation
> > > >> > when there is actually something to reclaim but because of
> > > >> > locking
> > > >> side of
> > > >> > things we pass reclaim=3Dfalse to sgx_alloc_epc_page().
> > > >> >
> > > >> > So this is kind of OOM behaviour how it works now instead of
> > > >> > stalling processes.
> > > >>
> > > >> Right, I looked at the original email at was really a page fault
> > > >> that was catched. The above theory cannot possibly hold, as the
> > > >> process does not exit with a bus error.
> > > >>
> > > >> I looked next to sgx_encl_eaug_page(), and found this:
> > > >>
> > > >>         encl_page =3D sgx_encl_page_alloc(encl, addr - encl->base,
> > > >> secinfo_flags);
> > > >>         if (IS_ERR(encl_page))
> > > >>                 return VM_FAULT_OOM;
> > > >>
> > > >> This is AFAIK the only code path in sgx_vma_fault() flow that
> > > >> allocates non-EPC memory, and the code paths where EPC allocation
> > > >> fails the result would be SIGBUS.
> > > >>
> > > >> So perhaps allocation is failing here. You could pretty easily
> > > >> trace allocations with bpftrace and kretprobe to see if this is
> > > >> what is happening, e.g. in one terminal:
> > > >>
> > > >> sudo bpftrace -e 'kr:sgx_encl_page_alloc /retval !=3D 0/ {
> > > >> printf("%d\n", retval); }'
> > > >
> > > > Should be
> > > >
> > > > sudo bpftrace -e 'kr:sgx_encl_page_alloc /(long)retval < 0/ {
> > > > printf("%d\n", retval); }'
> > > >
> > > > BR, Jarkko
> > >
> > > I tried these probs and got following results when failure happens
> > > (not always happen on my device).
> > >
> > > sudo bpftrace -e 'kr:sgx_encl_page_alloc /(int64)retval <0 / {
> > > printf("%X\n", retval); }'
> > >
> > > --> lots of negative values, I believe they are valid addresses in
> > > unsigned long type. So I looked up IS_ERR_VALUE macro and translated
> > > it in following probes.
> > >
> > > sudo bpftrace -e 'kr:sgx_encl_page_alloc /(uint64)retval >=3D
> > > (uint64)(-4095)/ { printf("%X\n", retval); }'
> > >
> > > --> none triggered
> > >
> > > sudo bpftrace -e 'kr:sgx_alloc_epc_page /(uint64)retval >=3D
> > > (uint64)(-4095)/ { printf("%X\n", retval); }'
> > >
> > > --> FFFFFFF0 printed, which I believe is -EBUSY.
> > >
> > > BR
> > > Haitao
> >
> > I see the same behavior as Haitao.
> > sudo bpftrace -e 'kr:sgx_encl_page_alloc /(long)retval < 0/ { printf("%=
d\n",
> retval); } -> This one gave an error stdin:1:24-31: ERROR: Unknown
> struct/union: 'long'
> >
> > So switched to sudo bpftrace -e 'kr:sgx_encl_page_alloc /(int64)retval =
<0 /
> { printf("%X\n", retval); }' as suggested by Haitao and do see lot of pos=
itive
> and negative values.
> >
> > sudo bpftrace -e 'kr:sgx_encl_page_alloc /(uint64)retval >=3D (uint64)(=
-
> 4095)/ { printf("%X\n", retval); }' -> No output.
> >
> > sudo bpftrace -e 'kr:sgx_alloc_epc_page /(uint64)retval >=3D (uint64)(-=
4095)/
> { printf("%X\n", retval); } -> FFFFFFF0 is printed.
>=20
> And you are still encountering segfaults? And does it happen when e.g.
> EBUSY is encountered, which should be fully legit. E.g. if there was segf=
ault
> simultaneously perhaps that code path has something wrong.
>=20
> BR, Jarkko

No, with the proposed VA page allocation fix from Haitao I no longer see th=
e segfaults with Gramine tests.

Thanks, Vijay
