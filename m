Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FC6C19F2D
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Aug 2022 00:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiHJAKI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Aug 2022 20:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiHJAKG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 9 Aug 2022 20:10:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A23367CB5
        for <linux-sgx@vger.kernel.org>; Tue,  9 Aug 2022 17:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660090205; x=1691626205;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5GCH3OxT9voQ6fxaMeK/QOGeHVf4olVlBZih+0k5kzI=;
  b=inr68TjEkuYGZu2Sgrpx8FMoSv4gHsu6UYXxD4nOUpWwqKJzBvKQ1u/a
   Z4qavDOBsYsw85Al91x9uwJcwTV+u2oOXwVtYGWWTKpva6hsGEWYrRV3a
   grlytQjdxeMfyP3D9h316OOb3tFuI2vsrK0FwzYKhwqhf6OEwETIW6S1t
   cDhXJrFG5+O1PYCqS0qaNdf6qc5blqq+FqFkAoLMSWQ0YV9iR7pJZjLbH
   rbESQp8OWEibm/3OpVpevZ87Y6xdDSi9oshlKcy1YBI4m43iA4nCkiAbx
   AYmaH0HpUSY7LLRJqo7Mkqlqd7KpAqaC9VU4KI1tBxOrhm3/VSpzT34/r
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="274012840"
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="274012840"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 17:10:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="601627534"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 09 Aug 2022 17:10:04 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 9 Aug 2022 17:10:03 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 9 Aug 2022 17:10:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 9 Aug 2022 17:10:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 9 Aug 2022 17:10:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUjCjcmAtVAE6hf8BfL8DLoSlawgNPpOVypvoku7ruSaDBVV1nkJ+tZOOJP10XBeO1cNv3PlkLLZiECSptoONd31w2MrzYllvAy9aTW1tps/5svHFfOY6LEabWGiEN+NKbkhU7dMccmufVJFtUsSjJJprcbrEXFxzfLXDi7N9H4nEd1xYTJ78H+g2wJE/spQfvi22QDkAk28b/+YIxQEqpXMuXInKvpPNQnC//V+u9dvRtEnsbf+g7Lg/dXgJF2nigpB/fF4ZnL/EVblLD+2wRgQPtnc0Kl7IvQ72vQc3IUbwNkG2xJMnBF5NgNHbrXzsPzc/6r0WYtG/ulSi4N6sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mtmk2/4zrqnCdSaNFhUOVt3CJvKUshjfjb5CcgT2TyQ=;
 b=mFiIp7LgzmbOKTtc+w3+yP2mhquT7OTWFns3PVeY0R6UzE7dt6MMrAtcvDYk6xdK+/+QhgyRQwzHh2oh0BkiDAdC2kxym30afApBgbYJZO1L4C8TSnmnhQLZol8hRb+uTBqlWBMPDS7st0xxV2IAZHiE/G3p1lCtkyQKuk0vONZK7wvWqP3gtpIdu4jgj3raDLyrQDspDDyxArgjLNKW2yEaWqfa0ZgD5yt7CMcDWgSo62E501QG459ES7AFB4zoOvZqRUIrUVgcvkv1tqqX4T2SMdG3csIIynIuWbtgS17rEAponNdVq6ZSTZ+lHbsMyTDHn7JSdKXTdakJ4HTIxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) by
 SA2PR11MB4953.namprd11.prod.outlook.com (2603:10b6:806:117::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 10 Aug
 2022 00:09:56 +0000
Received: from DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee]) by DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee%7]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 00:09:56 +0000
From:   "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: RE: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Topic: [PATCH] Add SGX selftest `augment_via_eaccept_long`
Thread-Index: AQHYqD8zl0cVZTXY9kygyA0BTFvLEK2k8WeAgAAK/MCAACpYgIABQxaAgABajACAAA2M0IAAICAAgABWSfA=
Date:   Wed, 10 Aug 2022 00:09:56 +0000
Message-ID: <DM8PR11MB5591D9B8653A2CF9D9CD5A3EF6659@DM8PR11MB5591.namprd11.prod.outlook.com>
References: <20220804201456.33418-1-vijay.dhanraj@intel.com>
 <YvD/DUGRBR2Tns88@kernel.org>
 <DM8PR11MB559100639C945285BF1D6F87F6639@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvEryXfefz62ivEa@kernel.org> <YvI6z7wgV2VQtNV7@kernel.org>
 <YvKGxIEpdnawb0bY@kernel.org>
 <DM8PR11MB5591108F54901FBB198E6E04F6629@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YvKskgNrTDC/e8pf@kernel.org>
In-Reply-To: <YvKskgNrTDC/e8pf@kernel.org>
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
x-ms-office365-filtering-correlation-id: 87116481-35e7-427f-39e8-08da7a64a830
x-ms-traffictypediagnostic: SA2PR11MB4953:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yhMWFsqiStTnqmggI8nBx3mD0drtN0rK/eZiBJ4IfXHuKqcHglib2ff8COv5wKhYUcYlzC8ty7cYO2e503MC8EiwRroZZ8Jc8ENv1xhmVbQspRglxiEvKNd07O4c4rq42makrK9D8XE5fw8ERUMB7nMipnUJaJA/d9YYS3z0g4ZscIwUOCG/0ECU88dbiFwJau6aglAu2s1TzNzscimAJ7ha4uK3jKZ6smLN6d03y0inS5CRLJzppAVoL0BiB/IHBXdT+RhboXjEYQgOo9zX/5rXkt+/+gG/63iamRlwKXYKuG73D/AfbsK4pQKVsXUYw8iGHPhBNAiwJ4wZevqxN0EpPOMeDifY7nS8mAQsgJ8pwBw+5VTTrYwplWt2gn1Ow6oP9FKUUmfZ0d4ysSceqWyXunqSA3fFo3Jj5EJ9QET/lfpka3Ufd/WElXFrlOLPbkC+UIN9szSCHXkeYlADLwHzx1xXWE0gbOhD7yvGizmScb63TkHtBIA4I3HqOyshPIrFgsnP+KxjkWiftG0zu5j4mJi5ij/6Wltl9kSFTEGwNFXmiB1ey1JUp+zCm+dYZwQA8BUlEbYDTMB0Ra/Omu8cSEvkDiRjf1oq3x05xKqpwATvIjZ03tkkZAeLwHc78pwhxTTR9FzIcfx6x7mdxiraNv8f92o9ifczO/DMXqFOGKGa8g72JUzvyel7ZsAv9lfCJCXP6uWX7RA36yY4nw4G/hszsMrEegGlgeTzhoEUzqXxHEcrUIM+y8dt9vBJGNVlLXYjiRBNz3hYDTHGZ7q63fTUa4u1B/AJZHpKJIy8XXLVz8STjM4Quj2g48w2HgLZbsbke7V6GX4sr54+QQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5591.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(346002)(39860400002)(376002)(136003)(66446008)(66556008)(66476007)(76116006)(64756008)(66946007)(8676002)(5660300002)(4326008)(316002)(55016003)(6916009)(8936002)(52536014)(2906002)(33656002)(54906003)(38100700002)(122000001)(86362001)(82960400001)(38070700005)(478600001)(6506007)(7696005)(26005)(41300700001)(71200400001)(9686003)(83380400001)(53546011)(186003)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uiTcsceogO0LDGxnRAl3OOaGo5e544eb1WPsXU5XXa9vga14KQVMpCMqPYh/?=
 =?us-ascii?Q?RupsqMp9YcOwJZn1QhXUTUkjhdAILmqe8dszPjHkiWanAQY1NQamHqqmn8wQ?=
 =?us-ascii?Q?3VLofzm2oOfwK+eGVMgkb6MfUsJYxVjeE3m7gkOY+f11ztlUdLYA05aVQUYu?=
 =?us-ascii?Q?sXhjIAen+WQl9dMZKAcz659qFZDXuGJEA6P9xsYFmLIK/hIBh47LK0hA9oFz?=
 =?us-ascii?Q?b7s8ONH3u+EmEUf3s7cdvnhwIraNjmd+XWzBkWuCHvygyY0Mo32aIor+XL97?=
 =?us-ascii?Q?hFVrycYq5MaN2wx5c9Dc0HbXbjIhIGYvTgtMzL9IJ/i5blCW0o1FNMjHvPW8?=
 =?us-ascii?Q?S0h0JaZ+LmTmqup04XL2sIQJ/oUbBepVey0v+Ln5QG7vJntvd5EQiHvJfsQd?=
 =?us-ascii?Q?BDFHqML4zU4o2dv/HX3lUAxE9EbDUOBX7elvu4biy+IQrJ7cbL9q1drm1SY5?=
 =?us-ascii?Q?aEYzj+WYse0JxmIRvDHOYKln5Dpipcq4OhJPiiG5JuVI0t0jCCtsr2vcsdQV?=
 =?us-ascii?Q?BTDiLn8EGphheICAu5ZFJjp1TqfZztC8qt98bhmue/3kmHH9B105rSJ0rzpG?=
 =?us-ascii?Q?8R8Mz5QPxSQnZJoPzxZpbPOuBLKqnqRY+R1Uvf9MkgarT9cUJdFGqrSZKTEJ?=
 =?us-ascii?Q?1Jxi6NRPj8jx6GYNP4VOkKj7hzh5U6HfO4K+fB58X1OyJPJqHTlVvtHDlHvD?=
 =?us-ascii?Q?gL2W1zFay7ITAl0vYJgNDIhPO2k6RSphcNguCiu+dEleBK0GQ1o6pesmLjao?=
 =?us-ascii?Q?h4SoW1jnWg5Q9kMWl/cCOkCBXKBPsAHSZ5xgAuI49ljavjneTaYfWALXtiaa?=
 =?us-ascii?Q?atjsPBuAQxYWeE0+FqRXVBNVdd5E+oC7LYwC5pOInuKCUlkg2sz8HJMAvNXL?=
 =?us-ascii?Q?jzepKslsBh7AUeqpJvthihXWF5lzgbDFgzBUA4m7dRM5vpQkpRCGklnKv39O?=
 =?us-ascii?Q?DYeuHMDXNsvMqWAGS4SPVuT3PQqFRhfGUaYQPlb5FGh2ANXJgsmPVzg7z12y?=
 =?us-ascii?Q?CGxR5dXLJqkh9tTQe3yco2itohP6aaIQFF+FAAI1xf0ft5W8rukzu2nXWhkF?=
 =?us-ascii?Q?+m0gxwnB4o9/fWzUsc6rEt0HaFBN9dyzG4nC8GIUp9TTxtihXa4vUvO7SQ07?=
 =?us-ascii?Q?U7EOVtc4ZfyIdb7NZv8eJ5FBuayoyiujv9LHHLaobPDdmSD8LW9aUB6uK2Fc?=
 =?us-ascii?Q?oR9jhLI//YFh0g4CICBNyqsXEg71AMMPbjFnGx8vAqAPdSBtQ/FXenlk72qF?=
 =?us-ascii?Q?XWuQANZweEQ9w0XbM6qiqFRyXrIs2hhhIKRHvMoUotUmEs3yZgp8wjR01aCF?=
 =?us-ascii?Q?5qK1swMbFt45cymzXxdQHwA85DyBdWu/+vcdX92+F6b0ayIggF+scpSpDXRE?=
 =?us-ascii?Q?gScl5Z1gLgodGF4EIxqpONKWtUrIEZiS0VPILPVr7wc18HDjGVLK8GWPA4kr?=
 =?us-ascii?Q?RwKHpLV6OSbOOUHKk2Kxrk/WMIq3BjTPK+N9XYMJcrvHw3J2gXg4GsqK1HCu?=
 =?us-ascii?Q?6M2OHsesbxMeRYEFQ1YkKn13I0S0mYV54g9sgXuW1bV3YXHAvVUv7vVvlZGq?=
 =?us-ascii?Q?lJh9hFjYXWee81OWQITn4jdQyM1larJbzCy7OJaB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5591.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87116481-35e7-427f-39e8-08da7a64a830
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 00:09:56.3241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +2V8ppGaKtfSE2rwdhHANc2jFqVZlHef7weir7P2OhZOukmyHTVZbtx5sNTJohTPVygqc/Pxt2qJPlO+Gu6QAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4953
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> -----Original Message-----
> From: Jarkko Sakkinen <jarkko@kernel.org>
> Sent: Tuesday, August 9, 2022 11:53 AM
> To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang, Haitao
> <haitao.huang@intel.com>
> Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
>=20
> On Tue, Aug 09, 2022 at 05:08:21PM +0000, Dhanraj, Vijay wrote:
> >
> >
> > > -----Original Message-----
> > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > Sent: Tuesday, August 9, 2022 9:10 AM
> > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Huang,
> > > Haitao <haitao.huang@intel.com>
> > > Subject: Re: [PATCH] Add SGX selftest `augment_via_eaccept_long`
> > >
> > > On Tue, Aug 09, 2022 at 01:45:35PM +0300, Jarkko Sakkinen wrote:
> > > > On Mon, Aug 08, 2022 at 06:29:13PM +0300, Jarkko Sakkinen wrote:
> > > > > On Mon, Aug 08, 2022 at 01:00:54PM +0000, Dhanraj, Vijay wrote:
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > > > > Sent: Monday, August 8, 2022 5:18 AM
> > > > > > > To: Dhanraj, Vijay <vijay.dhanraj@intel.com>
> > > > > > > Cc: linux-sgx@vger.kernel.org; Chatre, Reinette
> > > > > > > <reinette.chatre@intel.com>; dave.hansen@linux.intel.com;
> > > > > > > Huang, Haitao <haitao.huang@intel.com>
> > > > > > > Subject: Re: [PATCH] Add SGX selftest
> > > > > > > `augment_via_eaccept_long`
> > > > > > >
> > > > > > > On Thu, Aug 04, 2022 at 01:14:56PM -0700,
> > > > > > > vijay.dhanraj@intel.com
> > > wrote:
> > > > > > > > From: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > > > > >
> > > > > > > > This commit adds a new test case which is same as
> > > > > > > > `augment_via_eaccept` but adds more number of EPC pages to
> > > > > > > > stress test
> > > > > > > `EAUG` via `EACCEPT`.
> > > > > > > >
> > > > > > > > Signed-off-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> > > > > > > > Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> > > > > > >
> > > > > > > Hey, to reproduce the original issue: does it reproduce on
> > > > > > > VM or should I run baremetal kernel?
> > > > > > >
> > > > > > > BR, Jarkko
> > > > > >
> > > > > > Hi Jarkko, The issue should be reproducible on baremetal kernel=
.
> > > > >
> > > > > Thanks.
> > > >
> > > > I need comment out other tests in order to make sane out of this
> > > > :-)
> > > >
> > > > Mentioning this because came into realization that stress tests
> > > > should be IMHO moved each to a separate binary (so that they can
> > > > be run separately). Just a note (TODO) to myself.
> > > >
> > > > I'll work on this today again and *possibly* split your test to
> > > > its own application to get a starting point for forementioned.
> > >
> > > I got
> > >
> > > #  RUN           enclave.augment_via_eaccept_long ...
> > > # main.c:1241:augment_via_eaccept_long:test enclave: total_size =3D
> > > 8192,
> > > seg->size =3D 8192 # main.c:1241:augment_via_eaccept_long:test enclav=
e:
> > > total_size =3D 12288, seg->size =3D 4096 #
> > > main.c:1241:augment_via_eaccept_long:test enclave: total_size =3D
> > > 36864,
> > > seg->size =3D 24576 # main.c:1241:augment_via_eaccept_long:test encla=
ve:
> > > total_size =3D 40960, seg->size =3D 4096 #
> > > main.c:1259:augment_via_eaccept_long:mmaping pages at end of
> enclave...
> > > # main.c:1273:augment_via_eaccept_long:Entering enclave to run
> > > EACCEPT for each page of 8589934592 bytes may take a while ...
> > > #            OK  enclave.augment_via_eaccept_long
> > >
> > > The CPU used for testing was according to /proc/cpuinfo:
> > >
> > > model name      : Intel(R) Xeon(R) Gold 6338 CPU @ 2.00GHz
> > >
> > > I have couple of queries:
> > >
> > > 1. Is it possible to get dmesg output?
> > I did check the dmesg output but couldn't find anything related to the
> failure. Just the general log messages.
> >
> > > 2. Do I have to repeat the test multiple times, or does it
> > >    occur unconditionaly?
> > >
> > I was able to repro every time but it was a bit sporadic for Haitao.
> >
> > > BR, Jarkko
> >
> > Also, did you set the PRMRR size to 2GB per socket in the BIOS? The
> > issue is only reproduced for oversubscribed scenario. When I set my
> > PRMRR to 64GB per socket, I wasn't able to repro the issue.
>=20
> I need to revisit this.
>=20
> Can you simply run test_sgx with gdb and see where it hits?
> HOST_CFLAGS has apparently "-g" already.
>=20
> > Regards, Vijay
>=20
> BR, Jarkko

I am able to repro the issue when I reduce the PRMRR to 2B/socket but not b=
ut not able to break on the assertion failure with gdb. I also enabled debu=
g attribute in the secs but still no avail. Anything I am missing here?

diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/s=
gx/load.c
index 7de1b15c90b1..c4bccd3f5f17 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -87,7 +87,7 @@ static bool encl_ioc_create(struct encl *encl)
=20
        memset(secs, 0, sizeof(*secs));
        secs->ssa_frame_size =3D 1;
-       secs->attributes =3D SGX_ATTR_MODE64BIT;
+       secs->attributes =3D SGX_ATTR_MODE64BIT | SGX_ATTR_DEBUG;
        secs->xfrm =3D 3;
        secs->base =3D encl->encl_base;
        secs->size =3D encl->encl_size;

Regards, Vijay
