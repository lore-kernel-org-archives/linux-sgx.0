Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4510BC00140
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Aug 2022 13:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237695AbiHHNBR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Aug 2022 09:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235289AbiHHNBQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 8 Aug 2022 09:01:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AD7C19
        for <linux-sgx@vger.kernel.org>; Mon,  8 Aug 2022 06:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659963675; x=1691499675;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PErWQT4E6Yis5cqZVS7DdvqW43heE5tSk8vr4hdnYvE=;
  b=PCtRlkyahFiN8ToaOjqHaI/I+NhpZjlbyt9Dv1Wryh0XAYBgOTacXkqg
   WlPt/cUuwmQm/R6GIe14p1Hj3n1P7zE90gDGmtZgsqV1Sxu5dh3BmqAXb
   tED70rMzpMhMvKUmnlq7rs7eLW5bcFXOjhzYXd89MzAgZl8ATVuxf/opc
   XNJglgG3PyoA/d6NcZnPjDvuhiiMF7QJZSig3DRZ1G1+kkFjKT8jPgpb9
   NzKGCejqXsCFEkdCcziXhRZslLmCFVrzrXvlnONzbawN7GMhO8cczFynj
   IyS9vHSSB/rcJX2qDhtUAqdu+ULYLor/K+LoXYOkV4/3NzZ6NyaikX88K
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270358775"
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="270358775"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 06:01:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="693749457"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Aug 2022 06:00:59 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 06:00:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 06:00:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 8 Aug 2022 06:00:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 8 Aug 2022 06:00:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ww9T2YaS8QUu5CWULp8RpgjzL0kkLZ3XSU1kkVdYzjNJn9zeaRzLVuwZXBbLCVvQGRaJemD0IyCafblHNDgQI/lue2Rodv5jnGhJ/i0dTFA+aXYFsue/3d9XNET2Blh/0ZUC5BeawbjQuTz2MDUjF4PDZsVeNMwNvfVLyEi7Aquydy/nnn7TBt3XffTpGWGO+SHlwUM8XzUxKwATcaXZNgzcmhgdLy4z18p9Yb4QETsYhZrbfEwapZiAsIXf2F7xsvepHm4SkD8Aqns59n7spOhiIUREjjaJHO4VdwDpCeStVCni64X163et3SLziMPb6D6GUPosE1/IXQvZdehdbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PErWQT4E6Yis5cqZVS7DdvqW43heE5tSk8vr4hdnYvE=;
 b=U4jRcUIhBULn43RR9p/rJu5irxqPz0R7NmIpsNkWOlF0qN1AKyuNGXCaKMXkPBE3kU4OsbALTd+RrIYoty9QtEOKpxbq6lKyhpcI4fFUJACfuU5j3PJWYRUzX+zrChrlynZ2x9eXQF74Q/EI2Hkqfx0LZik8fZD+PYuxRiUn77t06Hz/qhRmLem4ypnOC8T3hfw/4QEk9f2vZmusHvU3JStZ5QabZcSoYAsIgJkFCFvuW4AJ5TeHQozAwKgdvhPxFCn6+FtDBdMyUaZg7BzjkXuz9HGPyKnPoN8xF8pn4FnWeyaA1QuMrD2PIHppB5OtVvSXiGPXU7RKHVteKWbISw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) by
 BY5PR11MB4209.namprd11.prod.outlook.com (2603:10b6:a03:1cc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Mon, 8 Aug
 2022 13:00:55 +0000
Received: from DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee]) by DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee%7]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 13:00:54 +0000
From:   "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: RE: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Topic: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Index: AQHYqD8zl0cVZTXY9kygyA0BTFvLEK2k8WeAgAAK/MA=
Date:   Mon, 8 Aug 2022 13:00:54 +0000
Message-ID: <DM8PR11MB559100639C945285BF1D6F87F6639@DM8PR11MB5591.namprd11.prod.outlook.com>
References: <20220804201456.33418-1-vijay.dhanraj@intel.com>
 <YvD/DUGRBR2Tns88@kernel.org>
In-Reply-To: <YvD/DUGRBR2Tns88@kernel.org>
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
x-ms-office365-filtering-correlation-id: d449fe13-d7d8-48e1-0422-08da793e07a0
x-ms-traffictypediagnostic: BY5PR11MB4209:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: raV5VRk1Au/xyB7lhIS6hEQI+A5flQ4Y33i3h70H+6znMjJZ/eEb+xJ7IbM2hmt4kUmGLQReGEpR2iQRPhT0yQvjmvVyvdUJ0vqL5YMmTUuoHr45lzmxdm3t32bTDRNJ8svSyGqtTGEX+pRNMVvWeTiMwcbTmmwUpVLRQmUXrdUObonCfEwPZHvb/LO5uCvFuFOc+f6PDOeDBHUxdv+fj9wVJ2dXAuC2vqWlVCgsm/JvstQeYl1JCfjHbY+X7RMC2XHDXyuYjfGtrAmxIHlkC03c7515Xh39gOJZNIOSlu1hCk5+L05I7T4R54sh46GlubLUGiuyWWrds+fF1k1jL2jkcYmaeWOEtcy2ucnXVF8h5qdcLcM1JCFrcqw5tUITfdr2k6YbqDT93LF+kp/9P38wdysbYq7u2f8HhqtbYrhknSGx9Hs3XTSavujWXIhK9qx0rRuS68oXkfoneCaMdJxp1yBzlN+WetWhLrqYa1xT2lwJIRa5+o+3dML9BGSTd5yuMrrr/Vvuk+Pvd7tmncuXkAILWlk813XUycO8v2HEfQSkr0xm/Gigt3ckxuDOs5h5lKV4dySL4AmIWy1iScXMPoVrZi2Mu8PhQgKFhxOgDWq4j50HhU6g/BjJmt5U/mdfjD90zndHN8ybPWSnyLqJ5y8R7mJy60w5+BdRAjFh/p66Fxaya2JBBh407NTTH1JyGhH10bvfomWOadnj3x3g5WujLU4goLMFQTO5Lt/TTUVZfIgS1sPAyqYt+cFw1XLrnLm+d7cZ9/3ehnkVoAeaguGN4PKoXtis11fOOssU+9kRNDWAKDsCx1FNS5BPdi/O09iYbyWdDgYl5k2Erg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5591.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(366004)(136003)(39860400002)(186003)(478600001)(53546011)(71200400001)(5660300002)(66556008)(66476007)(66946007)(7696005)(6506007)(66446008)(64756008)(26005)(9686003)(55016003)(33656002)(4744005)(41300700001)(86362001)(76116006)(2906002)(38100700002)(122000001)(83380400001)(38070700005)(52536014)(54906003)(6916009)(8676002)(4326008)(8936002)(316002)(82960400001)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KfhfDc+D1Sik5jWcE5jdNokPw8OAMizjkAwT5nmUK80Kt3qk1nX5GeMrJ2nt?=
 =?us-ascii?Q?UXVr7oVdcupFRYR55mzPJVaqX3hRBsf6473i4MdozKpPXVmGRc9cde067Dja?=
 =?us-ascii?Q?wAbY5byAvavGR8Av2evmSY2FpHBcy66jQiXuEwXGeJZ+/5GIXBAlTvZLUE2L?=
 =?us-ascii?Q?M4Ly7hLLkSMbIadD3AyaGIG1cwlQ7UVK1xp3Ew13q7hfr0j9j/0FoK3+H2ZU?=
 =?us-ascii?Q?h6CqUDGA5RFlrUlhCpVyXsxDrd0Czp1dwTUJ5qSqigKm9cf9kJMQP7GEtgba?=
 =?us-ascii?Q?OpDJKawrCz9aspLzw8qdvOPqKBbVwTM0m9dk3XR7LDiRD9d1NyT6hYt7O7rH?=
 =?us-ascii?Q?HDf4slVeSwRbrCC0fl0sVwyDG22xCQmYy3xpWsj85/jXTvXAYnBiCAg0C8/U?=
 =?us-ascii?Q?/P5riSgchpW+UTrQ7im96Rg27nhVcoUDgasTux1lWPjGxZfsrPLRMgTvCgMY?=
 =?us-ascii?Q?jop+8AF5Aaj7gVgcIDpyGGo0ghUGiFgtC7QemH31LMebw9fAuXMXRUdqougC?=
 =?us-ascii?Q?2jOKe32WmflTKImTFKq/FhoziYQCDPirmpWm3eAA2TPaIAIqLiOKgdo1kAIH?=
 =?us-ascii?Q?a/fvfL7Yh4ikVVJqmRUvGtp8Hqz8itLg89d5rQmDLK1XAsAF4nJiJZwPWPuI?=
 =?us-ascii?Q?Px8jPudhGVRjciQWE6T/UdHwTZAlBgSMW/c7ReuTj8mD7CSoOESo1zRH+NYw?=
 =?us-ascii?Q?mU76cM+esn3Zjuw6Bu7DhJKYIHvAFdY2O1kkl6wQlyeAHctbcUNlFyTsNxaP?=
 =?us-ascii?Q?h/bpSxsoYRiT92DNLhRm89vHrZs30H5dBO1exwE74cqhbbeRY+YAyUHkjs7S?=
 =?us-ascii?Q?Y3BUYkwo8ycF4M0fTJW5010N4u7CqBuJJsIMhmGRi/i1gOFsD5h+Opyn/g6u?=
 =?us-ascii?Q?yOxyZBYBQ059sCSUaqlfAalzY2u/VHcSSfZZREfuFlPV+4ko/j7oR5AUbbeb?=
 =?us-ascii?Q?Jd0Zzqq1zgoRI8E0ydVGd1w4Tbf598LWCPJMq4nrQEs3ZeLlO3tmgFefjfX2?=
 =?us-ascii?Q?tdJlmF/QH4IFQKzo5r4lH3ymz1Zp9c1CQxZYzbTukFFIHTQkYd60n1dOIKQE?=
 =?us-ascii?Q?EnWIlaZnU/uBKCLe1CLPB5Gy0VTlE7+OBWO56YW4EfAymuzJtQmmGq4fyOzY?=
 =?us-ascii?Q?c383y5oi+EnTFByzXCY7dlUrA84BNvemILaro8LYb+HBRuMYAOEBez+G1/OZ?=
 =?us-ascii?Q?7a9oasDBELcH+MtovB1PUNVUD4Hw2vfcvYbKfPItUOMqiiXWVNPaO9DQ4S75?=
 =?us-ascii?Q?B4Fx1pIUQKzPbvYyZ6GXTch7jj4QLWvjaWKYUnlwvf+tTtjJk91oChiJzr6g?=
 =?us-ascii?Q?rg4oY1YryvL6UCsQ57iy++9NTs0Ip5neOFIfEAqTh/BLiTW4OZB3cyLCGBjS?=
 =?us-ascii?Q?2L3ksfR6/p4s7hI8hGiLJQ0fh2W0jMHexL+5juGHVMVmrE1apNCPwiBL/o32?=
 =?us-ascii?Q?j99Ny6B1P8/C+eXJVqiSILjxkXJbsDEW1Dw79MczgPo9qAv6L3ty0PFw/HFb?=
 =?us-ascii?Q?iPflWGca8gopKSNbXBgPFR7gJa/Rh9nzLeDLX6yU7U3y9uFI4Gv63iED8kfx?=
 =?us-ascii?Q?tpQdd2fCYxGOrdeYH8T1H/mKUywcteeSB3/izOUd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5591.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d449fe13-d7d8-48e1-0422-08da793e07a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 13:00:54.8894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bULPMkTwNsFtoGmcjsSnkjOlkVfqHXQmW6YvnfGkVFIgl1Fef4CDSM/i0Ax0Sp52swTYpkkBp2VoXILiVW3nIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4209
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> -----Original Message-----
> From: Jarkko Sakkinen <jarkko@kernel.org>
> Sent: Monday, August 8, 2022 5:18 AM
> To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang, Haitao
> <haitao.huang@intel.com>
> Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
>=20
> On Thu, Aug 04, 2022 at 01:14:56PM -0700, vijay.dhanraj@intel.com wrote:
> > From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> >
> > This commit adds a new test case which is same as
> > `augment_via_eaccept` but adds more number of EPC pages to stress test
> `EAUG` via `EACCEPT`.
> >
> > Signed-off-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
>=20
> Hey, to reproduce the original issue: does it reproduce on VM or should I=
 run
> baremetal kernel?
>=20
> BR, Jarkko

Hi Jarkko, The issue should be reproducible on baremetal kernel.
-Vijay
