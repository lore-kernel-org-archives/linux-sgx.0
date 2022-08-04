Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AAEC19F29
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Aug 2022 00:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237226AbiHDAiR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Aug 2022 20:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237066AbiHDAiQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 3 Aug 2022 20:38:16 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638FD3190B
        for <linux-sgx@vger.kernel.org>; Wed,  3 Aug 2022 17:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659573496; x=1691109496;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a/N9d1NmgVkT9SH8U2DkaqteqjHtii0M7yhhPeTe6Nw=;
  b=VtdkgNZPmJJdwYdlA9YKN6FAht3wpfcxKn1bcIir0piUpcgHDyKvAuNH
   eAUIRGf7r3sEYmx/i/a3PsMnIQwDzHN7NjOJN+m+ktijkv6V9QO0gLFYV
   laqXjMfYWUs/hx8g6odwV7gl+OwOPqRoXDLSYqUF/mxiLSPpiqzazDsP2
   y7yqK54/NySw/At9TAFid6LpN494MPvT5bQNqnd8WROhss/NaukJt03P3
   o3V7ttQeAUp95CTrdVry2qXf5dHmTqULoW1ScwPyi3rLEZsky4mTk/sxe
   IvSnybtgnUkMU+6Cv5Y6JyvFAZx0JaQtkfgU03PRuhEi+mfvyAh1VpQRw
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="287369832"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="287369832"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 17:38:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="553519685"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga003.jf.intel.com with ESMTP; 03 Aug 2022 17:38:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 3 Aug 2022 17:38:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 3 Aug 2022 17:38:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 3 Aug 2022 17:38:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOR5IdVx7jX5nJ+b7gNAf0k2xc8kY0f7bFGAFCxIuJ0/lK3Y+YFpP9sGRWCOeV6xKqLN5NedD6b7XGuc0ynPsb87Sla225DPMM6d/hnJzFqFE4U9XGotHckH6kD1ELgMpQ3dqk288iiaBXEIYPCEHd68/jxTOwoAeyanc6WHJ2p0b9EmZ4ds6mnN5/qNSJ3ErDweZOQYbF0iq2sHoIObaCX+PgCYIdYGkbLxrm97vqwprald6FSD3P+KwRSH2mARE/CzLU//igp5/oxfQKaubV9BToykr3GGOWZz0rYcrsjU96Qy2eKZkaDphRmBseQunnrE8hpvhwr3ZLYsxLXC7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/N9d1NmgVkT9SH8U2DkaqteqjHtii0M7yhhPeTe6Nw=;
 b=Wd8Wu+rVrlPYv1q3TeVYCKFvz+sdElW9nodCkDU1zhebQEJdah5CNAczOm07Y6WEl0pajtdAa+IiuhYuhkCnmhOjW+CTdqHcnPFfyNkJ7MCMamC+nPCGLrCLrXoGKfn+v3d+Z6KZ/OHeSpXxZ6/CU3wXlWRFdaZvgcpZ8CnWOqslxI7GiTG7ZUwVEXkl9DzQNPirY/arVCSe2EDuwpqBrB2LxjOzYrPuKLzsVgmYXu4yKtRC/oRjoVstS6BzsnMzxfhJjpu7qvegvKx8gYbzDN19B0FsJs3+FTYaj19SNph8NRpJigACb7g9kd1Y2WP3nIQIOMQRT2wyhvCIOUgenw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) by
 CH2PR11MB4230.namprd11.prod.outlook.com (2603:10b6:610:3b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.12; Thu, 4 Aug 2022 00:38:12 +0000
Received: from DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::b0ec:428e:d323:2bbc]) by DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::b0ec:428e:d323:2bbc%4]) with mapi id 15.20.5482.016; Thu, 4 Aug 2022
 00:38:12 +0000
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
Thread-Index: AdijZFc8mcX23sq9QFWgzapOaA5FWAD+iMuAAA705nA=
Date:   Thu, 4 Aug 2022 00:38:12 +0000
Message-ID: <DM8PR11MB5591174FF99D6D2092E959A9F69F9@DM8PR11MB5591.namprd11.prod.outlook.com>
References: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YuqwSw3enyOUTdON@kernel.org>
In-Reply-To: <YuqwSw3enyOUTdON@kernel.org>
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
x-ms-office365-filtering-correlation-id: 491278c7-016a-43bf-bf3e-08da75b19cc9
x-ms-traffictypediagnostic: CH2PR11MB4230:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T2jVg9aj7DlTJJX60C0YMLUci2XHE4CIiZg+41bnHvv0fqGRw2x4oy/P9f+m8G7BnCMjAeAiPNnFA1eQhlDBl+z73+WLPeIdPaCas3K73pvhBjTBcO0B3uJSUAfBMBDQtwYFvnPfY8Chn6sZueclbUw6lleNMo9o8g7IzlCFtEgI10gX+5yOKr/xug6yObjWMunge/68qBOYFUmzLhTUu4kcPnJxPYA9Ki+AuJ3rmlq5k4XTyurSuyE4xyFhZKpvO3fJNdH4dTigERGQcd2or0Q1qSbqLjlEwEmxFq+gS2A3tgH3Mo64/eLvIuB8MhstCrBsjGgx5DHHEKeoj3+2pjG+leuSb2ljYGrZl2KhAZt3N9grWh1qGnageS+GHkU172Us152Wdt60rbwioBViUiED1CYLLIJrjfd54W0Xka2lVVFeFmXAFfngkv3AFWa5+AUuXerLnAik/OcDCZcqMvYkinJCSJ6trWtEeazsS7IIOgW0eCafhYiw3Ckl3NCHQsya7nvB3e4b3F4wdmQJ4RQxqnx/y/TMyACxjx2hN3B2ZH+C/zQBraOeaWAmGTVLvcUYYvNuUwDYW2M00P21rKtBXv9rZ+H07ujM6wcXncQFSdepPLhcUhvc7V1/9nYoaZ9IPabNXsQp3aE0uQfA4FGL7I/q6dbBnzuhW2UOJmbtLlSGHM9+xe71AM8C0oUK866vBocfm/ce1iGalRmDbvI5DtsEEi+XrAGz0VyGWmNHljLVdilJBEHQtRaYknJ84/H6iYnQDpt+7D/m0EUR/tN9F6oeOeNfaxEaCqJY4B+vi5mUq3XFe4WM/ZxqDFVM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5591.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(39860400002)(396003)(136003)(366004)(86362001)(26005)(9686003)(6506007)(7696005)(186003)(41300700001)(33656002)(2906002)(122000001)(38100700002)(38070700005)(6916009)(316002)(5660300002)(4744005)(76116006)(71200400001)(82960400001)(54906003)(4326008)(52536014)(8676002)(66446008)(55016003)(66476007)(8936002)(64756008)(66556008)(478600001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/tTfiD0R5tlRZIlg+4XbdN0/5EdRZeBkrMtnhsOS5mSTTeP/OOLNOzArOmn9?=
 =?us-ascii?Q?vyfRPaNfOZDvxqzw40CSOmCykW0oDewhLH/TS2Lgtsy0gEipKfGfF3tMR4oK?=
 =?us-ascii?Q?Hh5+8kF9riMCVGfw8cEIHPNyVul0uLxRN8hQBBRz/RThrAE6yutYtcOBXkvJ?=
 =?us-ascii?Q?fnBwCpc8D9dJg9d314XYS+YYhKURfYQEbB//JNu1+z4Xe5+kWojZYDIXY994?=
 =?us-ascii?Q?zw5rkn51T/g6DhEQOF8Psd2yp9vWm9PSFgGab1y/jOj+VlxZaRa09Cvr5xml?=
 =?us-ascii?Q?q2c9LbiVskpcIUmrho/tiTVa53k2lk7pjiEvW3b3GaTWp8PY0PiPdHF4dHV1?=
 =?us-ascii?Q?s0iubaAifs1/3SLPtoaWPsoi1NxCSg1EiPTt7MW5wiD2+L9YaElBkSsuQ3bf?=
 =?us-ascii?Q?MH3Et5wmVndq3sFcUYXT80keitgTR9AyZjb9Usc7dOv87WY6U7a0jWZe4JVF?=
 =?us-ascii?Q?9eFLZQL90OiFkyp1sOeGrIgbCCfy27EUjaQgRFqrJAVLivK0YpeT03MVYBzb?=
 =?us-ascii?Q?4KHqkiqU8xFCKwhyvvf9/NlJmNeJU8bhDreVlVQeC/9eBdsuT9HVT9Cqq55s?=
 =?us-ascii?Q?JO+VMk0bDEFgvKzX6FXQlcYdz8oBszwP3xd3Gq9cbtN5pZuRZo1pKelrzprq?=
 =?us-ascii?Q?mFjI5ala0yNiFsQmzwC+d7S/1RTENfDK/GUMLrQ95VMLobiklb0nfB2MKCUp?=
 =?us-ascii?Q?cO4d1UZzd6B1dmpo1YGl0U4VGbwU8o0vKtkJH5ExURg2ytO3od06A4ap2TD5?=
 =?us-ascii?Q?T94Tc+e+XwRpuJvUr8mkR8CLPMPuckIME/RfyD4MZXd8fsA1EqBrc/kpjVrS?=
 =?us-ascii?Q?NIK4oM3Ao+PfWAwePX0ZuVW3pPXxB8Qw/HxNrz0iM0+RLuULkbRfKX2VUzV6?=
 =?us-ascii?Q?drzl9C8JMUC+0CqxBrEnixX4hcvBuKQdRWTipELeyWHHWeNmFUV5zRpFxnyA?=
 =?us-ascii?Q?GhE1hwo+4D+vP40f2Xiz2N0pIej4E8jV9fxYUi6GLrgd2u2qXVGqcQnx40VR?=
 =?us-ascii?Q?6n2aLmLXnmUb5/+kx+o2KRQ6qWUXqaW8dJxi/AgmygZ4UK33f8IfKL9oHbLr?=
 =?us-ascii?Q?bR2NFl8u+wBjZ38FCMXuEPoIoE05vtS1ISarS41H3V/qlwjwLBPPknlyWpPI?=
 =?us-ascii?Q?htmJDht1maQIRU2/EujRFGcRTp/Hxj7CM0iN/WDq3XCLkVQJ/iq1jn3012wC?=
 =?us-ascii?Q?g/SfhcrxIu7N/oDajS+eW3dhdD0eOCuT19Pl6Y2SgSuUOIRewdMiJM20azPo?=
 =?us-ascii?Q?tJhRBVmkLPIAOf+tS72ryQHdtohrMzdiknIwaSqGCIWBYBlYPuLHbdw/CyvN?=
 =?us-ascii?Q?M7vNRsLKqmdLV46eni6LIP1zzsquhLI4RI/1LR/8Q9+2r8NClV/eZNWiNsad?=
 =?us-ascii?Q?F7Fb2/t9HJ/CbeOaqHIfnnjtFnvq+V1WiRoJ/5sWyXyNJ4W7smoO+Tr9MJlM?=
 =?us-ascii?Q?eW/iRwlY0dlysx4nel7uGfFrprl2sxc16+IwmVE3gFume5uISswcXheQfJuz?=
 =?us-ascii?Q?UmsunclmmraFOB2OUXelXVMgmkKrdcJ/w62Om9KorMSw1Cf5+u3CUZ5gZaS/?=
 =?us-ascii?Q?ByRB0kVV8TynvmeGBHX5gYLbwMMbwnCEWbq+glch?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5591.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 491278c7-016a-43bf-bf3e-08da75b19cc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 00:38:12.6006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n8VhZNdYA3/SNknBDyk3AfeELm0AidGUwiDTLUM+lAzKj8M9ZVeajkmbNj3ztn0/KUUIYychSiI5jMhH1y9AbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4230
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

>=20
> Could you make this a proper patch for kselftest?
>=20
> It looks fine. Only thing you need to do is to add instead a new test add=
 a
> new test called augment_via_eaccept_long. Please, also define this before
> TEST_F's:
>=20
> #define TIMEOUT_LONG 900 /* seconds */
>=20
> Then we can test against a commit instead of attachment and we obviously
> want a test case for this, after the issue has been fixed. And I can easi=
ly build
> a kernel for Geminilake, XPS-20 and Icelake server, and run the equivalen=
t
> test.
>=20
> BR, Jarkko

Sure, will work on a patch and submit it.
