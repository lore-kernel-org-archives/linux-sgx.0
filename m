Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E9BEC00140
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Aug 2022 22:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbiHLWlg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Aug 2022 18:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiHLWlf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 12 Aug 2022 18:41:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CA26DFB4
        for <linux-sgx@vger.kernel.org>; Fri, 12 Aug 2022 15:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660344094; x=1691880094;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=zIXrgW93hydxzL2Gor7WK7bOtpjskbqsNy5SMFfoKCs=;
  b=fmYj9crPxWsUKRCqpjsd4EADitQ1ETArwwXxpl+/bBrnaG4gyy10C3Sl
   H9XH8DgE78nyHhWXjMdazwNpsytqG/yp5uRrseuYgkatN+Ie62VAyJWB/
   VWGMDPl9Ju79Qo3+k0h7omLN48zflwFfaU2ropUOgdLNCdZEuHyjVnbeG
   hlz6x/YEejhgEbyAhXm8/Ad4iI6XFztW3faM4kuKQQMoVvaqOvQaNhk96
   2AFh1Xl+kY9TvQfrCkyAaA3w9JmiEk1jiODYKWxN2Detyi01yNPhUh+D3
   PYabS4ExBnI5DDcv7zed8yiNAPiCAtpa1FVAv6Y5ioIAjM47Rp3GDy6w0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="271474111"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="271474111"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 15:41:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="609397448"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 12 Aug 2022 15:41:33 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 12 Aug 2022 15:41:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 12 Aug 2022 15:41:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 12 Aug 2022 15:41:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOsaCWBzFZrxL5rQICyosajY8mcfWPb0T+QErDc1peZNow9PM+0Ghb7N6Hu4Dfx5wyJ69TDLj3t/ai05IMc4Ft6x9bVqe8jWJfH3IXo1/M4Fq4rPo27psk21M+1XTXbqKTi3kHwtB1q1DjvADvbGnUKX6JgGvKqYRST5BQmwxpS0P/l2jpKVuzeB500Ls85uQbCDDz57lDYFb7L4jgRPmKTYktAouSQra3T3ZA3qal54ZWNUN/c7fVceeVqV6+Yska4sr35uLE/CZr/QQFzl0OActHWjY9LQGWA9JWeawMY+EmQQQ9/Sot5aEU9KbnmpjlwWVgyKidde4cOeWOdxug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2oD67QVhotG8wRd+8NWCfJCgjPWlqo0ugaNY8OKpFZs=;
 b=fTJL7jEHn1NZ5pipFKIuDEn7Awx+ZhX4RH1ZV6UCpDiyB1dhuQySMJF6U/ewTHFrTGWkhhNKsFPuju1dkW3tLU9818o4y3dhuvGG9ccu9/r4gTUtA2sY73VfYJW77bMdt2oKc3XWveflN9kKuGZX7+JYFNk6H4OXcPcth8ioIlfGOVViZHufQM/yEWbE7ZOWMeg7iHP5JdwWx7RObH8+tpPUHYh0xLoRgtFlnhwNgKQVNp3k8L/rUGfvjHg6qNmsdCq6eX3rLkiSAPdLX8H26pjii/hiZ5MrHZ722vESbs5O1KnjByX5rXvYnYy/MULs6Mlu3D5RG+h+f79wOsj+/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) by
 MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.11; Fri, 12 Aug 2022 22:41:31 +0000
Received: from DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee]) by DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::21ea:5b3b:c98a:d2ee%8]) with mapi id 15.20.5525.011; Fri, 12 Aug 2022
 22:41:30 +0000
From:   "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: RE: [PATCH] x86/sgx: handle VA page allocation failure for EAUG on
 PF.
Thread-Topic: [PATCH] x86/sgx: handle VA page allocation failure for EAUG on
 PF.
Thread-Index: AQHYrn95k7VDoB+QBEerfnWLU21GFK2r200w
Date:   Fri, 12 Aug 2022 22:41:30 +0000
Message-ID: <DM8PR11MB559143ADF2DD1A8053641F5AF6679@DM8PR11MB5591.namprd11.prod.outlook.com>
References: <20220812191224.15561-1-haitao.huang@linux.intel.com>
In-Reply-To: <20220812191224.15561-1-haitao.huang@linux.intel.com>
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
x-ms-office365-filtering-correlation-id: 5433a0e3-8770-4214-1347-08da7cb3cd1f
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uk8WmooR1aTYrA2nfTcdir7ukLb7EBCKicJlPu4rxv10+ve6GL0gZp0PjOtEsMVkFAFwMmlS+qNlrNaFKnWHtWOhwizCRu6U9BccapakLJSWalqXZEiE/ZQbqHAVhVaPvflD38O1SQoEL4rXLhsuxeoIKIgdGk2cNkFbUCcI6hVg+FeblC02GCTmUuTuPN8tXg4YZKxvTxGM861ZYrXxpox88vDjM1fuIUQm6INap5PJ4b/gX3MsQzDdb1wytUqSW9vmGHoX5GJMp6H5fo/zRw5L1CzfrvP+BS3YdaEcmCbI2F9PsuGSwCWB4viw6sBSR+QH00YEkuq49kwoS9+fLdPZvZtLUENH7SlAmkwPltZFLmwABEKIgkTsbuReFHDccqxU8ZaT/pe8ENcLh4KyBdNEewG8sfb+Vw3q5LfVt43uiRfznYWIRnonk7KXyiTB49N70+6mmrQIjD/vqvsw3ThXTnYUbhN31m+m9uueVXlXADpPvkY4zukajgskGt8PfDcp7XkcDk+3qzCR9nW3uUUDxZ7QYDb/CFtTiGdPkmZPZetzG/V3JZPU6atyiWbJW1oIHxDXP9NIxuSdIzkK/C97O4lHAM6AsILr2vZLSLIS6mlxdY2ewQF5QS09ubQqVkpZJ7q1NdXTFigc8Uu3c1dtISyWSzVGpXa/eSF3TtJK6RQoUlGuRbCuakyrcqbS3rxaBZ7IcDlVFxC6rd0qVnlVYhRQ39gSawRJGCBBCL4G5rytUtqm6CcL1y+b58xIVvOdS8bLr+Cc9tENgvNAG9RSvPvTRDQTX4Ed6Vp3NFKjZHLx4HrBO7Y774SMS+tDQ9zau6AfK+AhPMoIkwndkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5591.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(366004)(376002)(39860400002)(346002)(41300700001)(478600001)(7696005)(966005)(83380400001)(26005)(6506007)(53546011)(52536014)(5660300002)(186003)(33656002)(2906002)(71200400001)(55016003)(9686003)(316002)(66946007)(8676002)(86362001)(66556008)(66446008)(64756008)(66476007)(76116006)(38070700005)(38100700002)(8936002)(82960400001)(122000001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hJGKSPmchDI0WmnIuXu9ACY5fF0STAE8y8i9wbueADsZ3b2RU0jpdaKPUZsO?=
 =?us-ascii?Q?g8Q0TygJAcM5/aPMj8l9M9F4idgPpV0knc0D3parwIGliAtyolP60f3wKhuu?=
 =?us-ascii?Q?UgGWr6av6SiH8AgLZit7+F082VtQLogYoNe7xVk74ebg51FRK2AOHMBTrxxT?=
 =?us-ascii?Q?wHJdUL6FIK0Y9PLhW/ZvUvWOQkz4WDFuXqynU6mj4tdbTlbKvzWV2UsYP3lv?=
 =?us-ascii?Q?FWQp8aiBPdTY5a7WvpThN7LdGATnViiALv/nYUe7q+wGaHMPUdWKDKXeRgqy?=
 =?us-ascii?Q?8T6eCtn6MT0QVAh3Ym46axINER94bI+hcevZOHZZ3q5w2mzc8KsFSVpQR96o?=
 =?us-ascii?Q?Zed4z4PTSOn4NuoN4YKrnBHbiBK/lkYhv40j3VA3VEAkaaxb8GDNUvVJLHyO?=
 =?us-ascii?Q?8fr5toKHwgnn4hj2ra46EV3d0RbxrWO8+JQU48nsmvMgkTu93YS/dbDuCFTw?=
 =?us-ascii?Q?6hcNkIEw277j7/3DexoY2KPJXjuOWOzFGvLdQRozZR/zY00mQgtk1AeDcTum?=
 =?us-ascii?Q?UlOaVme0Kxg9nvMQd02iUSZIECRDRQ5Re9pdTh/AA38+tQF82QK/3rQzCoiq?=
 =?us-ascii?Q?0CHWbbli55F8+ZeO6y2fk/CciQ80WYKX6XaPuvEuMItW5YtsD06oT2i8iuCq?=
 =?us-ascii?Q?ZMKMTfjGRn9jJPYggNkX97R+iv24weQ5RDRax9uCjRSa90Cnas3NdlAjqJKy?=
 =?us-ascii?Q?Zdw77NKEX8yWtZ4dhxC6MGLldbMfFguXswSupF+uC2RSx/YP3Zw3DPdnq38V?=
 =?us-ascii?Q?9J6WJ2364dh2e3IGTgTIStfzmm8jfCQDWmVW1x9g0BhnNcj92XYBzWZJ6zfF?=
 =?us-ascii?Q?eYLLyVvJ7fa/V6JFJtclUqwfn3bTx3y9R0kAR1sWz9WkPi/FUhrwzSdXC7J5?=
 =?us-ascii?Q?3opZbF43mJ8V4HBdgejzWIAYddXM5V3bq8yNnPAe5VBvDP7HAwPv16xFV22p?=
 =?us-ascii?Q?kutABQChQGR3R3Byo8qRTReADKR+iNdmEh5yRCYBZ5YWyQNjEzSc+FFTjYFm?=
 =?us-ascii?Q?s/FYSoTOQwad+ClptFFWLF/hM/L8T0WmAo9RKN+0LRn1FUIBG8pW8clbpelX?=
 =?us-ascii?Q?LZ+BnqeG2U1N5uEVK7x3ReuYcE0KiMFkMUTRyJeAk5hNNK/kUzGQ2b1nFl+n?=
 =?us-ascii?Q?p0/NOrEyHuncvT/idE10D2FVfbPjfgm9QTyJx9IJTK+XyPXbwb4u70tSzbug?=
 =?us-ascii?Q?AkGPf73zYwrRyOyLaBBRzPygflF27t3TF2Uge5M97Ybh7oVb55JF+zz1dXcl?=
 =?us-ascii?Q?4l+SDXw0pYKFWApVWDjQh2GhvPx7Lgyg3QAx052mkVngJtVJT4MUa+Y4CyjP?=
 =?us-ascii?Q?sKQP4BYl3l85pxDdR0bOTQ66dPY1wWIR6KF+LkdLAwzAyGFEt0OjO9mT4J+A?=
 =?us-ascii?Q?htop0WHQ4eplyLxD1D+Vxlm3iDU0qSnoS65XJfKPtuU2yyVl8e4taUI0cyJA?=
 =?us-ascii?Q?0oAxy0QahIq8Ryp9jRwQ+RPNPrO+pkYKF4hpJi4bfk+tLauVTFyyJNZdzxqu?=
 =?us-ascii?Q?oJV8zsa1JmFrUs1E6EL3NfYRvpus9itu69pqbi7WpPByGQ1MJoosVsHiAAdZ?=
 =?us-ascii?Q?ciTIXB414gRcwr3qYZ9Hos4wduAlhF0w1oK3zDwh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5591.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5433a0e3-8770-4214-1347-08da7cb3cd1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2022 22:41:30.8233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JSP2qjEeNIDPAXbRT75uOl1yEA9SnzCL5PdbwS3JAn5qaTGIz8/CyZrYh9mDx2gEH5BTrCHqgs8j9SkNJNIG5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5776
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Haitao,

> -----Original Message-----
> From: Haitao Huang <haitao.huang@linux.intel.com>
> Sent: Friday, August 12, 2022 12:12 PM
> To: linux-sgx@vger.kernel.org; jarkko@kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; dave.hansen@linux.intel.com; Dhanraj, Vijay
> <vijay.dhanraj@intel.com>
> Subject: [PATCH] x86/sgx: handle VA page allocation failure for EAUG on P=
F.
>=20
> Return VM_FAULT_NOPAGE to allow the swapping thread to catch up.
>=20
> link: https://lore.kernel.org/all/20220804201456.33418-1-
> vijay.dhanraj@intel.com/
>=20
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/enc=
l.c
> index 24c1bb8eb196..1f88f80c4477 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -344,8 +344,11 @@ static vm_fault_t sgx_encl_eaug_page(struct
> vm_area_struct *vma,
>  	}
>=20
>  	va_page =3D sgx_encl_grow(encl, false);
> -	if (IS_ERR(va_page))
> -		goto err_out_epc;
> +	if (IS_ERR(va_page)) {
> +        if (PTR_ERR(va_page) =3D=3D -EBUSY)
> +            vmret =3D  VM_FAULT_NOPAGE;
> +        goto err_out_epc;
> +    }
>=20
>  	if (va_page)
>  		list_add(&va_page->list, &encl->va_pages);
> --
> 2.25.1

After applying this patch, I don't see the allocation failure issue with `a=
ugment_via_eaccept_long` test case. Ran the test for about ~60 times and al=
l the time it passes.
Tested-by: Vijay Dhanraj <vijay.dhanraj@intel.com>

