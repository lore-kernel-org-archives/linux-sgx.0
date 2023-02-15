Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54311C636CC
	for <linux-sgx@archiver.kernel.org>; Wed, 15 Feb 2023 08:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjBOIqL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 Feb 2023 03:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjBOIqK (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 15 Feb 2023 03:46:10 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EEC14EAC
        for <linux-sgx@vger.kernel.org>; Wed, 15 Feb 2023 00:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676450769; x=1707986769;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=KmWpKJnOcyOCzcJfgYJWp+utMqqnxlBrV23b2YLgO5Y=;
  b=Ui97kdX+PnU5cLiwvVDQMghRWIBQkZ0qiVdhTUhOZJ5y1/RFk1Jd+gvD
   Yd0du6CiyAS6MaUIj955FhGcxpnPaUril/edcFsi1gO9u/3hcCesIzl9B
   XMq5mMwGqXQIUARXro9zGqLZo6BWwNYnYGaJpgEpGFWSiy4Hj1PiAVZkA
   pbQE4+i3tcLZif1AxmslILJ3A0CJbKDlHRZQ4hThPHMuTGhLecBLYsKLL
   zekS0MvCplB2JVyNY7/RJgMgQCtvL2TYRS3lmoE0+QcnxqWo+U3zmCnLt
   H67pevdhPo1Cc/49rtzV2xAED8lIXn9lOvGA5uUPN3tOmQC5+/xa+arXG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="319409862"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="319409862"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 00:46:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="662849387"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="662849387"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 15 Feb 2023 00:46:08 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 00:46:07 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 00:46:07 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 00:46:07 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 00:46:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/jLoBx2rN9PvAYzIhvad1m0hV/8G3fj2o0Do9y3xZSdP1RrtuSR2JUyd+fXe1s+ht7wvnuhmjXS7oASiicFsi4wMzyzuVO7pcNejt5YYNQ7QdIZcDI28q4vwgpjs3ExrpUTXGPobgqjBAI5bhIsXsA7w/K3D35LA2ieFVEaGHdzg5y/z1LNNNod3+iZ9mILm8wWQKTeftCLESYBcmnEgV3vHmcg92RaqpRu2Fn1ERCpIDtdCx6sSKkFsVFtreXUW2Zxo4ReG6LQHRemNJ7qkjfHI/Hz7Gt2KaWURAUupiNHTA4ofMHb59B3Z8DnD+LRcJufy0uuOI0V6/dnkRzuog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmWpKJnOcyOCzcJfgYJWp+utMqqnxlBrV23b2YLgO5Y=;
 b=c8de+bO4vmiEnE8XGzg3iD9yWWVcWVzhYm3rLHdpXJl7W72iosqchZvmZ4ht2OFcz2JVKju3E0qgpgiNUd011B0e91hKXao6wxk0fh7LIbX8Taj3ReQAAgJ9fWT+KWcqQNuO3BPng5ryHqbn2Rar+mfoGHuiVAEsaVCjcyAY3eIMhZYuXoSQoUa+ELT7tTAeeW6aapzqW7vjbnSfZtDhn3jloraRuXDOZupXmnErfsUZeZiqWnoqWlyf5ayHwWxN+qZcvKSCLHCBE1xyhKgJS7cDn1zTyL4UmF9v1t9fX8/ftgEb4XFRMN8c4Rzc/nzht0u/U1WVtkQ/qaiVRWrG8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6908.namprd11.prod.outlook.com (2603:10b6:510:204::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 08:46:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 08:46:05 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 4/4] selftests/sgx: Add test for madvise(...,
 WILLNEED)
Thread-Topic: [RFC PATCH v4 4/4] selftests/sgx: Add test for madvise(...,
 WILLNEED)
Thread-Index: AQHZMtTH5vmG3AnJqkqaKdt8RGDk367PZ38AgAAiyoCAAEPqAA==
Date:   Wed, 15 Feb 2023 08:46:05 +0000
Message-ID: <a9003c4ed2fac5a736a7317a3d4614de26bfb464.camel@intel.com>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
         <20230128045529.15749-2-haitao.huang@linux.intel.com>
         <20230128045529.15749-3-haitao.huang@linux.intel.com>
         <20230128045529.15749-4-haitao.huang@linux.intel.com>
         <20230128045529.15749-5-haitao.huang@linux.intel.com>
         <66db7859f696743b036c9dba3d040d196477984d.camel@intel.com>
         <op.10d4pvguwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.10d4pvguwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6908:EE_
x-ms-office365-filtering-correlation-id: a4c7b4bf-a744-413a-f442-08db0f311359
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i+PSvizga7ljhSvILb40xA8NhpUNPKBsRhlwW7sxYayPaH0WBpBdcP2a+EegS+KFBgfB1qBMLA8P04JZWgks4Bmq0wh7jqrxZPTUCh3NBfv8cyKar5DUD/riIbbhM/e+yJ6ycgAtUwef+/rDSj+6SbU4cJwlwaHstF3Ysbu6dFJ29dnuZtpjbmDHP8S9v52RzJ9TtyTA6kD1J8KdggMPQx1JpFQlOj1IXDU+7DzKSyO8KSlxth1iYxCPEO3GwOVYPhc4ZKceTQJt1Y795aOLvCZHpoj7CEBGxPZqLg9AaFiSlzPrH/3mMBxTduh0NUnjrpyhuAJk/Fb/XfVboMZzt5LTFpid3/WLXGJ0oEyPfQaQefFNuKZ4b3Bgu5LySgW5KDSns7FvXPPiAeZl/2cl5hhKyU38Vz8Y476EF39Qy7hL9XfZagfo8PPk0teN+nNOGrqkPJdUTPvOOuPoBVpmd3KfKpWAU+0ULKYKgxhVSqqDJWYKp1HknkYkW6QoRzhjBAGDB3odFaQUt/jsx1XI7XKmtjgXGLhGwDcH2bVQDFDpqmIcuAsWoi9qRtwas1gPW0rZ0WWvhLpu6bukjVw6BILZchTi5nhmD5EhQBxjWOdLTYOTOHeQ38lfxdaTEqXndBEKSZcitypVYigNbLkTOxVWQ1xGE/iYexT6jwYNTcBeojjsK1wqoBYSv2sHqLQ1DpSCbF8o5BkBqF9ES2hChA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199018)(5660300002)(26005)(6512007)(186003)(41300700001)(38100700002)(82960400001)(36756003)(91956017)(71200400001)(38070700005)(6486002)(66446008)(66946007)(8676002)(478600001)(66476007)(66556008)(64756008)(76116006)(6506007)(122000001)(8936002)(2906002)(2616005)(83380400001)(316002)(86362001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUJTUlFoOHBsWlJ2TmxqeWs3OEs3V2tZRy9sOENPWURjb1Z2MFpMMDZwWWp4?=
 =?utf-8?B?WWFJZUFqS2VBSW43ZXgvOGhqUDNocHpxSVNzZHlKc2o0TmNHSjFOQUpGUEto?=
 =?utf-8?B?MFczQmkyMXowYUpvK2lsR1ZqUE5oUCt3M0QvdVR0ZCtEbDNqSzBuYTZoSVFv?=
 =?utf-8?B?K2Fib3NxOFM1UnNmd2luWWhhaG1JTDd3ZlBFSHlwY1BqWk14bTZVYTU5U3FU?=
 =?utf-8?B?SnlPTkpRMlR5VG9OUlJiVVUwNVYrU0xab2ZDTUpURGxDNFFDWFdOSUF5cEx5?=
 =?utf-8?B?bWJ1NFY3dTVMcGNsZCtldWtMUE1NUEU5eEhDQnJiZUE0R1pFMWRCME9paTZN?=
 =?utf-8?B?NW1tYXJhbGlDZTQxdnJGQWxjZFRCTVcyU2c3WFNaSjFwKzZVekxWSVdjOGVS?=
 =?utf-8?B?K0dLWkhFSVBXcFlVTHZkak5HOHFzOXpqdTR6SGJXRVR6MXdqcWhLMXN6dmw5?=
 =?utf-8?B?ZTh2TFhpNkQxSkVBSDRLZ0JFTEh1UER4ejdGeXp1enArM1pjd2RUeC9jS04w?=
 =?utf-8?B?T0ZkTy9tbmJ1T3lCdFN1V09vY3gvQ3NZNll0N2xDTW8vRVN2VnlSVk1kRFk4?=
 =?utf-8?B?Y1FMYjY0djJrUWF3eENnbFRNQWhTU3dwcFF1TTV6aFczNjZlcGJtRFQ5VkRC?=
 =?utf-8?B?Y1pGMmZCL2tucE5ueWNWckZxUGZPQjR6N1gwdng2dFUvcmdSYURJUTg1Wll1?=
 =?utf-8?B?M0huWlFNd1N5ekQwYVVTMG1rTXNrV0dCdmZ3M2toVWcxcmhacnNoaG11YXR2?=
 =?utf-8?B?c0VIbDdTSndLNlV0V2lidUJ2VERKcDhDYlNTeXN0amlPbEd1ancza2J3SmhV?=
 =?utf-8?B?RUI2ZVYrNVljUmIzNHlOZ3hGRUIrbDB5eEVTMkV3SzVDZXhqek9xZTlxVWsw?=
 =?utf-8?B?TnVXODFvdlZaTHA4MDd2SUhqQ2krbmNRSytrWVdBQ2MyODNTMURiNXFESlBR?=
 =?utf-8?B?b1VBN3JMaFNZTVE3RkdMdG1tS1dlKzJaOXhNTEYydXphNmxwQkYyeitCWENL?=
 =?utf-8?B?RHJOOHJReU4xYXNwa0FTYy80VjFhdnpHdlcwbFhVdjlGWWtXNmR1MWVhdnRV?=
 =?utf-8?B?VXpyTmY3YjFiUWROUDN1NHU2Z21OOU1zVzJrMi9YWGNDUHhKeEpzUDVyQnND?=
 =?utf-8?B?SlBZSmJxbDBuYXVSVy9CeWRPRk1EVXh0ektpU0d5VmFzNVF2R3UvZm1ibzBN?=
 =?utf-8?B?UVNMclp3d0ZFSmlVOXVlZEJQbDBiVC95bVBoeTY5Qnk1UVhlTHNkL0p4TmtD?=
 =?utf-8?B?a3RVcVA4Rnp6OWVTVExyV1ZNQzJoZWd1OCt2b0Y0dUw1NVlydy8raFFCZHBj?=
 =?utf-8?B?cStrTnZJTUpBb01OZ2s2QVo4U2ZnMjZXOG9iSm5qM0cvTi9tSHpaWTI2TUlN?=
 =?utf-8?B?LzlPa2dKTm9NcEhpWEw1dFJwdWppdkUzeWhqMEVJR2J3RXNtVUZUK3phcVlj?=
 =?utf-8?B?S1lQaXpqM1JoZGdkWG0zdDhQT2lVMExvbE11ZjFtR2tVTEJBNUVrckZkcjZq?=
 =?utf-8?B?NTJsNERpYWZ4aWEzaERMcXlreWlxSzRWcXdwU1FXNzZIRjByQWhlU21jdWVV?=
 =?utf-8?B?NVhuR2d6UzFCcUl5OUVlYWpQYXIydHRNd1B4MFpyNnRMdDVkb2x1ekJNL0JO?=
 =?utf-8?B?Q21uRlZUOEk5eHBOUGZxcGZwL3k5eUR2Z3FDbm45TEFrb2xhZCtVWEhNQnNs?=
 =?utf-8?B?bEF5eCsvOWJHNTVsWmlnb3V2YmJpZzhEU1Y2L2RXUEV2cEUrU3hUUThwR1FN?=
 =?utf-8?B?K2ZBNWN6NDI3bmEzQkxkMWlDbGovczdNbFUvZmxDeStJcjc0YmZzSEs4U0RG?=
 =?utf-8?B?dE5MeURmM1FHRG1EMEhwNGx0em4valdiSTBJY0h2Wm14OFVuSjFyQWZDZTli?=
 =?utf-8?B?VjhrcnVUV2g0cWYvbzJNTGI4MnpDc3dzK2pGNG1KWjdwTWJsaXZMSVZQV24x?=
 =?utf-8?B?S3F0T2EydjlXZ01qMm5nMkoyWEUzdHQ5dFBBK3R6YnJ1U01yT3lKTnNaMjdW?=
 =?utf-8?B?VVRsS0lUWDVwVnRtdDdXSnJXeHg1U3hzU1V0aVhoUEdCUkh5d1lsWjJqbWJ6?=
 =?utf-8?B?b2N6Mk5Qei9PMVdPNVUxV1NzbUFMbUgwSEp3UFRPMkNWWSszNFdsYnVXWHlH?=
 =?utf-8?B?MDJRUnNkT3NnR0U1VEV0cytnOStrTmFHKzZGUWN4dmY3U05nN3JoN21vK0lp?=
 =?utf-8?B?Unc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8F132C862DA014F9CD11A5E813709E6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c7b4bf-a744-413a-f442-08db0f311359
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 08:46:05.5377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XqFeVol5R9w5DIwbkSARrVKojcloGD4rHHjN2/TviqHodTArtf1xBQZe9L03OYpmyhVaUDpEcYl06aJLOrSSdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6908
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTE0IGF0IDIyOjQyIC0wNjAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+
IE9uIFR1ZSwgMTQgRmViIDIwMjMgMjA6Mzg6MjkgLTA2MDAsIEh1YW5nLCBLYWkgPGthaS5odWFu
Z0BpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBGcmksIDIwMjMtMDEtMjcgYXQgMjA6NTUg
LTA4MDAsIEhhaXRhbyBIdWFuZyB3cm90ZToNCj4gPiA+ICsvKg0KPiA+ID4gKyAqIENvbXBhcmUg
cGVyZm9ybWFuY2Ugd2l0aCBhbmQgd2l0aG91dCBtYWR2aXNlIGNhbGwgYmVmb3JlIEVBQ0NFUFQn
aW5nDQo+ID4gPiArICogZGlmZmVyZW50IHNpemUgb2YgcmVnaW9ucy4NCj4gPiA+ICsgKi8NCj4g
PiA+ICtURVNUX0ZfVElNRU9VVChlbmNsYXZlLCBhdWdtZW50X3ZpYV9tYWR2aXNlLCBUSU1FT1VU
X0RFRkFVTFQpDQo+ID4gPiArew0KPiA+ID4gDQo+ID4gWy4uLl0NCj4gPiANCj4gPiA+ICsNCj4g
PiA+ICsJZm9yIChpID0gMDsgaSA8IHNlbGYtPmVuY2wubnJfc2VnbWVudHM7IGkrKykgew0KPiA+
ID4gKwkJc3RydWN0IGVuY2xfc2VnbWVudCAqc2VnID0gJnNlbGYtPmVuY2wuc2VnbWVudF90Ymxb
aV07DQo+ID4gPiArDQo+ID4gPiArCQl0b3RhbF9zaXplICs9IHNlZy0+c2l6ZTsNCj4gPiA+ICsJ
fQ0KPiA+ID4gKw0KPiA+ID4gKwlmb3IgKGkgPSAxOyBpIDwgNTIgJiYgYWR2aXNlX3NpemUgPCBt
YXhfYWR2aXNlX3NpemU7IGkrKykgew0KPiA+ID4gKwkJYWRkciA9IG1tYXAoKHZvaWQgKilzZWxm
LT5lbmNsLmVuY2xfYmFzZSArIHRvdGFsX3NpemUsIGFkdmlzZV9zaXplLA0KPiA+ID4gKwkJCSAg
ICBQUk9UX1JFQUQgfCBQUk9UX1dSSVRFLCBNQVBfU0hBUkVEIHwgTUFQX0ZJWEVELA0KPiA+ID4g
KwkJCQkJc2VsZi0+ZW5jbC5mZCwgMCk7DQo+ID4gDQo+ID4gSSBzZWUgdGhlIHByb2JsZW0gbm93
LiAgSGVyZSAncGdvZmYnIGlzIGFsd2F5cyAwLiAgSSB0aGluayB0aGlzIGlzIHdyb25nLg0KPiA+
IA0KPiA+IFNob3VsZG4ndCB5b3UgdXNlIHRoZSBhY3R1YWwgb2Zmc2V0IHJlbGF0aXZlIHRvIHRo
ZSBmaWxlIGFzIHBnb2ZmLCB3aGljaCAgDQo+ID4gaXMNCj4gPiAJDQo+ID4gCXRvdGFsX3NpemUg
Pj4gUEFHRV9TSElGVA0KPiA+IA0KPiA+ID8NCj4gPiANCj4gQnV0IHRoYXQgd2lsbCBiZSBpbmNv
bnNpc3RlbnQgd2l0aCBjdXJyZW50IHVzYWdlLiBXZSBoYXZlIGJlZW4gdXNpbmcgemVybyAgDQo+
IG9mZnNldCBhbHdheXMgaW5jbHVkaW5nIHRoZXNlIHNlbGYgdGVzdHMuIFRoZSBvZmZzZXQgaXMg
YWxzbyByZWR1bmRhbnQgaW4gIA0KPiB0aGlzIGNhc2UgYmVjYXVzZSBpdCBpcyB0b3RhbGx5IGRl
ZmluZWQgYnkgdGhlIGFkZHJlc3MgZm9yIGEgZ2l2ZW4gZW5jbGF2ZSAgDQo+IGZkLg0KPiANCj4g
DQoNCkZyb20gbW1hcCgpIG1hbnBhZ2U6DQoNCiAgICAgICB2b2lkICptbWFwKHZvaWQgKmFkZHIs
IHNpemVfdCBsZW5ndGgsIGludCBwcm90LCBpbnQgZmxhZ3MsDQogICAgICAgICAgICAgICAgICBp
bnQgZmQsIG9mZl90IG9mZnNldCk7DQoNCiAgICAgICBUaGUgY29udGVudHMgb2YgYSBmaWxlIG1h
cHBpbmcgKGFzIG9wcG9zZWQgdG8gYW4gYW5vbnltb3VzDQogICAgICAgbWFwcGluZzsgc2VlIE1B
UF9BTk9OWU1PVVMgYmVsb3cpLCBhcmUgaW5pdGlhbGl6ZWQgdXNpbmcgbGVuZ3RoDQogICAgICAg
Ynl0ZXMgc3RhcnRpbmcgYXQgb2Zmc2V0IG9mZnNldCBpbiB0aGUgZmlsZSAob3Igb3RoZXIgb2Jq
ZWN0KQ0KICAgICAgIHJlZmVycmVkIHRvIGJ5IHRoZSBmaWxlIGRlc2NyaXB0b3IgZmQuICBvZmZz
ZXQgbXVzdCBiZSBhIG11bHRpcGxlDQogICAgICAgb2YgdGhlIHBhZ2Ugc2l6ZSBhcyByZXR1cm5l
ZCBieSBzeXNjb25mKF9TQ19QQUdFX1NJWkUpLg0KDQpJIHRoaW5rLCBjb25jZXB0dWFsbHksICJh
bHdheXMgdXNpbmcgMCBhcyBvZmZzZXQgdG8gbW1hcCgpIGRpZmZlcmVudCBvZmZzZXQgb2YNCmVu
Y2xhdmUgZmlsZSIgaXMgd3JvbmcuICBZb3UgbmV2ZXIgZW5jb3VudGVyZWQgYW55IGlzc3VlIGlz
IGJlY2F1c2UgU0dYIGRyaXZlcg0KZG9lc24ndCB1c2Ugdm1hLT52bV9wZ29mZiBhcyB5b3UgbWVu
dGlvbmVkLg0KDQpJIGFtIG5vdCBlbnRpcmUgY2xlYXIgYWJvdXQgU0dYIGRyaXZlcidzIGhpc3Rv
cnksIHNvIEkgYW0gbm90IHN1cmUgU0dYIGRydmllciwNCmJ5IGRlc2lnbiwgaGFzICJyZWxheGVk
IHNlbWFudGljcyIgb2YgdGhlIG9mZnNldCBwYXJhbWV0ZXIgb2YgbW1hcCgpLCBmb3INCmluc3Rh
bmNlLCBhbGxvdyBpdCB0byBiZSBhbnkgdmFsdWUuICBCdXQgdG8gbWUgSSBzZWUgbm8gcmVhc29u
IFNHWCBzaG91bGQgaGF2ZQ0Kc3VjaCByZWxheGVkIHNlbWFudGljcy4NCg0KSWYgeW91IGZvbGxv
dyBtbWFwKCkgc2VtYW50aWNzLCB5b3Ugd29uJ3QgbmVlZCB0byBtYW51YWxseSBzZXQgdm1hLT52
bV9wZ29mZiBpbg0Kc2d4X21tYXAoKSAod2hpY2ggaXMgaGFja3kgSU1ITykgYW5kIGV2ZXJ5dGhp
bmcganVzdCB3b3Jrcy4NCg0KSmFya2tvL0RhdmUsDQoNCkRvIHlvdSBoYXZlIGFueSBjb21tZW50
cz8NCg0KDQoNCg==
