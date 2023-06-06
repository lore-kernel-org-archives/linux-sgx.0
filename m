Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48078C77B73
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Jun 2023 04:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjFFEMM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Jun 2023 00:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjFFEML (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 6 Jun 2023 00:12:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC9418E
        for <linux-sgx@vger.kernel.org>; Mon,  5 Jun 2023 21:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686024730; x=1717560730;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ztOn+T7MldoAvBP4ApUS8iYQTNWZL1H+JLYDsztlL1A=;
  b=e6rNJ27nEVJK9+QWH+Y5vCbZY5pQZSmFBizTOaS0g7hrhieiVi1KLVrv
   8PIX8KfW4VIVFGNE8hZYB6V6Z2rAxYEABMR6V+/KH5pV1ZEjhbPsHJGZz
   gMcAYqWmNJF55V2rOXXokfteIfaD4M2p/mRqFQ+rzauOeggn7u0RkTpnO
   YRhYGZ9PscSdLclTh/FG0uveXtNGoH8WCVYOze+jSbT5khlKrIMlAe808
   jqo16060+hQKVuUy4GHpY0Mg0k2X9sTKiXE2/dQrKETsfnBVibr2np3OU
   mWwowLkI3lypQ74wFEocLAtany5CnGU3N/Okw7PGrqQqAiHXPtip9rkxx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="356566249"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="356566249"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 21:12:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="853246904"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="853246904"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 05 Jun 2023 21:12:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 21:12:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 21:12:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 21:12:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c97lVAxmAEx8R/mPHOwmh+2feslDZ+npTT4qYXvzl6TolBI2uXF0JiMmH3DFxOcQMI3SZCQahAkrxNAh+bbAKVGI9TvYdLrtBHhbQ1zyrg+9VTtbejpLJ1UBcrevrTe2B1BXciYSrxz6Y9kElgG9wSXQI91JFKRQ6ZzH1sIECvLmkwZ09DEMF+L8/GDIAqeHRkq1Wc+bdHdreOQOsrvv7MCbuWIFWeA/TaVVDuMc2QPlVgfebxhVzoT1w/m6ShDmSm3cFcV3QPm86OTCiSwW+VgDWveBRXfYvu4IJYOWiI0Kpn6KYfAbKxT18U4npGgvGmYpKzAPBJMJY5n38/gxRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztOn+T7MldoAvBP4ApUS8iYQTNWZL1H+JLYDsztlL1A=;
 b=bZfTfWUzCEdAswxYtwiflKHcozjRzLB9T7Dq4gVRDwkP5G1JTiFGHbcEetCjw+b+LT4gQr+Wg2nIIfMTynQBSbEnOiY1UpxAOBipn5pIOEdhM5RCuD8cu275ozOgr4Jpl5FgdWMgNxOrewWFvs7uKpZy4O0o7XCPTiXbtvEvZEa1GSyPiOWW+F+6H/f5BF16LAbFTIZy3WKK19CtpYSCgcwMgXwTsEqpDtHV6yZdYyhK7itUtctdaGr+AGmuFqACGvhcJpICukZMauGiBmOzfsL6BRdERKxWIDdBAwR3y9NycDgj6Hg4eTLUsO3rMvCu1j3f3/PTGWFnBtO+NtD5ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by SA1PR11MB5825.namprd11.prod.outlook.com (2603:10b6:806:234::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 04:12:00 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::b429:a482:736e:e1ff%5]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 04:11:59 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAA5ciAIAACKGAgAY6gQCAADnpAIAV3bGAgAGoFwCAALMwAIB7cDIAgA/0eQA=
Date:   Tue, 6 Jun 2023 04:11:59 +0000
Message-ID: <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
References: <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
         <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
         <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
         <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
         <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <Y/AAbC/j04aUkd8R@kernel.org>
         <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <Y/VBOkmi7VbVuzAh@kernel.org>
         <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
         <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
         <op.15kug6t9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.15kug6t9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|SA1PR11MB5825:EE_
x-ms-office365-filtering-correlation-id: 490e02d3-017f-4a02-a9bf-08db66442ca0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p/Hlu2MAWT0P95W7pYyc24YO3R+5tvGDK+gBVACkDmXkkJfL7Wb3oVfhI54Dmp88hFBBldJt3DikLDJPy92gf4H8C9uh33S+nhwVQZYuw9VkCPhSyp1r4l1PvLtw36+X/OR4W94au5/k5JjojyRnVHfrZWTok20A4T0DHPqy/estLfQ6ULAvRGx6QDV6kvLUMYYrQDxli3fWpyCL0B+QoWWSJdlwDpqSgeIFOJA4sTM3w2a37ypg/ISMkt5iQeZ8xmzGXNO6iZ17Y6maIJk45scnvwii1KTh+WOS5ft3w9K4uJAWvZpDjYkmVlabk8kBtyTcf6jr3JUlA/S8ySEy6Wb6d2RdmBtAUa2doz0+ZPmrJX+vvokSSa0UAwnh2Jw9f11tH5+c89sxYpYB+a33I/jIDchFJEXttMoHfT99do3ZWkXeynQePS/T8Jj6KOCdhV14y4MviydlncBNMT92roFaDI3y0QR9bq8w06FpLJsCQ6WdYjLjiTD3jPvHQ9cLA7d7kHDLYVi4i5yfMuCdS/iBeM+/oefuZe/LgeuXiu2vrbsf9irODXiM/txQruzbFJALncjpqT4/77cSMCje12HoMTW595J1KqQjqZYcrP1yopNUebVwfaNNkIx8/E4j
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(366004)(39860400002)(376002)(451199021)(6506007)(6512007)(26005)(36756003)(83380400001)(122000001)(38070700005)(86362001)(38100700002)(82960400001)(186003)(2616005)(54906003)(110136005)(41300700001)(2906002)(91956017)(66446008)(478600001)(76116006)(66946007)(66476007)(8676002)(8936002)(4326008)(64756008)(316002)(5660300002)(6486002)(71200400001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2tJcUMrVHVRMkZVTElvWWZ1ajlMWWpqc1Z3alIvYjR6SVJodS8rVDFyWTlC?=
 =?utf-8?B?dmZucVY0U1lMQ2F2UWhaQklVRHphNWdaVyttTXVWS1B2Rk14UmZQc1ZOeWds?=
 =?utf-8?B?bUZEL1ZvL3ZLNVU2MkkvaFJhSDV0a2x5ZTBhbEdsVGVIZTRBT2JSM1dDUS9w?=
 =?utf-8?B?djZqSGtnZFpyMGRpbmsvWUxYZG1xRFhRbUtiU013dXRmZTU0T25pRUg0ZXg0?=
 =?utf-8?B?SHdxZjFoS3A5ZjAwUEF2VmFnRTZFUWJ1ZlBqNkN6d0lOb0ltK3FLdG4rc2l4?=
 =?utf-8?B?M25tbjdRVlcxRVVsMUUrQWlRMTVpNkVsOUtGdTBjYTQyUi9RQnFyQllnTWZa?=
 =?utf-8?B?RVdmVC9LVnpJRGU3TlBPK2Q5bTZaZTU2WWdqU0RTaElkSURZYW5uY01FeXkx?=
 =?utf-8?B?VHprT1lFZkZlYndpMEVJQTJGenNuZVR5VzlUOGJRTGdaZ1NuYjA1bE0wRG9X?=
 =?utf-8?B?cCthU2dacG5OMFBCL3Y5Sm5MZGtVaXkyYk1MTGZnNkpGa1lQcDZzalZmYUlF?=
 =?utf-8?B?d2ZINE1qVFlFMEVTWitkYnI3bW05MjRxYWF4TjZSaHdsSnFyYnc1cWlWdzZO?=
 =?utf-8?B?WG90TVVTaFFRY1c0RHBacENlWExrOWk0STl0SFltYm03V2ZyWFBTL1JacDg0?=
 =?utf-8?B?YWp4TzAvbGNhZmVHelhOb1dRUUswN3JhbmlQa1gvWThEMnF6UVVNU1JpUDQ2?=
 =?utf-8?B?QmRmUjVjcnp0MWdDbW13WDhMQkp5U3Mza3VQVDVuOUZYQUpWQVJLOHBiVWFy?=
 =?utf-8?B?Nm8yb1lrWDBCQ2FrOWxBVHRydnU2b0p3cWhtLzJKVzdPWUtmVGpoSTlkR1l4?=
 =?utf-8?B?amFSaUZzTjhBM0dpdHdaTmtsQnlSMlp2S2hJRnhEMDhqWVpQQzc1MEMxdG1C?=
 =?utf-8?B?ZWp2QnllSzBaS283aWNWTUVwN3dmOGx6V0ZUd0V3QXNHL3VSMmFIU05uZ1Y1?=
 =?utf-8?B?b3ZxWEtHZlR3bDliVVFWY1lHckIxSEZ4blkxaWRlc2M4RHk1ZldIRG5nakE2?=
 =?utf-8?B?dkJjdW5XWS9YS0hheVVDQmxRc3ZCNkpwZWN0aDRUWmhuenBBZUNMcnRkMDls?=
 =?utf-8?B?WmhBbmFYN2k3S0xyOW1OWHl4SUNEdWZGdWt2YnFkaFFaWXljMTljaS9PQ0hq?=
 =?utf-8?B?WDk5LzJ0cUdaS1FnYk04VnBPTEd5SWwyNkorZ1F0UTBXQnlOdkI3VzllczUx?=
 =?utf-8?B?MFNuY0hhdVRBYzduNVEzVUVLTXZQSUNNcG1KdEVteFV2MGYycC9FTnZFZWQr?=
 =?utf-8?B?bitQd0ZDNC80aFFNWUNZZC9uSnBvQlRMUXhLY1lHeHhyRzNKQ3VXWFVQL28x?=
 =?utf-8?B?Uy83dXBLblNRajVudDJBVWpuRlJUVk8vOWtKNTdWMnBqRUNEbDM5UUlsS2FX?=
 =?utf-8?B?REx6Y0NBSzhYK21uM3ZyMGVETmo2YzVidzB0eEY0aHcrZUYwblV0S3h0U1Z2?=
 =?utf-8?B?NzRwMzRmd2pXZUNCcEM2STZLNmk3Y0JybzF0Q0ZVS09zZHB5ZStkRDIwUEZl?=
 =?utf-8?B?akZRaU1BazBLeGNVeUdpbTR0ckQ3aUZZRTJmUm03UW01WTgzY1pmSzJmYWZy?=
 =?utf-8?B?a3BBVFZrbVVuMFhtaDJSR2NYODd2NGFKN3d6UklRTDQvZ09IdXlYNFRlY2hI?=
 =?utf-8?B?Mm5vQjZ0dmRjTEdUVWRmNHNYWTNZM1U3Y2oxYjJiWU5WZ1piZ0xYd2lPQzlG?=
 =?utf-8?B?UkQ4bW0vU2VBc1l2b0d0b0Vnc1JnNi9XWWk2dXFHSUo5YW0wUWRFaUNsY29G?=
 =?utf-8?B?elh1RWZwbDUyd1JtMFZIcmRvanlzRDZtOHNreUMvTkFxNkFWZSsxcU5QZWNH?=
 =?utf-8?B?OHNUK1EwYjVZelRWaWlpdlVsakhoSTUySG9ld0RudnhIcUF4ZXlpdTNaMUti?=
 =?utf-8?B?VXF4WXFQZkxNTUpTaE0rRnVmcVRYWEhYUHhoM3pLUVJ6bGhJUmRFUGI2QTNE?=
 =?utf-8?B?eGY1cXRhWUZiUGZKd2JZVlpQOGswN0hlS0RVdk8vWjAzM0dKNGV6eThFZk9N?=
 =?utf-8?B?S1k3NW5HVklPK2JvL1R1TmdvYmN3WEZMajBkdXB6dDUzRkxPM0Q4cnlxWWIx?=
 =?utf-8?B?RFVYUi9hM0ZxRW4wZzJMZTRka0JJZDJOYmR6bUlDaTd3ME9lVHM1NGtESlpv?=
 =?utf-8?Q?u+UdF1Db3ewJLXhiLvccaDmKN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A85B9D0E7586245B1B801467924DAEA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 490e02d3-017f-4a02-a9bf-08db66442ca0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 04:11:59.5265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WmDUJ8PDK3GqgbUuPpWlo+AbtEG9ZOtk+SnBv2RiGF3ytNR9empn/i3qOID5P/IPJ+UNQ0PA2S+lEDpySyNIOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5825
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTI2IGF0IDE5OjMyIC0wNTAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+
IEhpIEthaSwgSmFya2tvIGFuZCBEYXZlDQo+IA0KPiBPbiBUaHUsIDA5IE1hciAyMDIzIDA1OjMx
OjI5IC0wNjAwLCBIdWFuZywgS2FpIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gPiAN
Cj4gPiBTbyBJIGFtIHN0aWxsIGEgbGl0dGxlIGJpdCBjb25mdXNlZCBhYm91dCB3aGVyZSBkb2Vz
ICJTR1ggZHJpdmVyIHVzZXMNCj4gPiBNQVBfQU5PTllNT1VTIHNlbWFudGljcyBmb3IgZmQtYmFz
ZWQgbW1hcCgpIiBjb21lIGZyb20uDQo+ID4gDQo+ID4gQW55d2F5LCB3ZSBjZXJ0YWlubHkgZG9u
J3Qgd2FudCB0byBicmVhayB1c2Vyc3BhY2UuICBIb3dldmVyLCBJSVVDLCBldmVuICANCj4gPiBm
cm9tDQo+ID4gbm93IG9uIHdlIGNoYW5nZSB0aGUgZHJpdmVyIHRvIGRlcGVuZCBvbiB1c2Vyc3Bh
Y2UgdG8gcGFzcyB0aGUgY29ycmVjdCAgDQo+ID4gcGdvZmYgaW4NCj4gPiBtbWFwKCksIHRoaXMg
d29uJ3QgYnJlYWsgdXNlcnNwYWNlLCBiZWNhdXNlIG9sZCB1c2Vyc3BhY2Ugd2hpY2ggZG9lc24n
dCAgDQo+ID4gdXNlDQo+ID4gZmFkdmljZSgpIGFuZCBwZ29mZiBhY3R1YWxseSBkb2Vzbid0IG1h
dHRlci4gIEZvciBuZXcgdXNlcnNwYWNlIHdoaWNoICANCj4gPiB1c2VzDQo+ID4gZmFkdmljZSgp
LCBpdCBuZWVkcyB0byBwYXNzIHRoZSBjb3JyZWN0IHBnb2ZmLg0KPiA+IA0KPiA+IEkgYW0gbm90
IHNheWluZyB3ZSBzaG91bGQgZG8gdGhpcywgYnV0IGl0IGRvZXNuJ3Qgc2VlbSB3ZSBjYW4gYnJl
YWsgIA0KPiA+IHVzZXJzcGFjZT8NCj4gPiANCj4gDQo+IFNvcnJ5IGZvciBkZWxheWVkIHVwZGF0
ZSBidXQgSSB0aG91Z2h0IGFib3V0IHRoaXMgbW9yZSBhbmQgbGlrZWx5IHRvICANCj4gcHJvcG9z
ZSBhIG5ldyBFQVVHIGlvY3RsIGZvciB0aGlzIGFuZCBmb3IgZW5hYmxpbmcgU0dYLUNFVCBzaGFk
b3cgc3RhY2sgIA0KPiBwYWdlcy4gQnV0IHJlZ2FyZGxlc3MsIEknZCBsaWtlIHRvIHdyYXAgdXAg
dGhpcyBkaXNjdXNzaW9uIHRvIGp1c3QgY2xhcmlmeSAgDQo+IHRoaXMgYW5vbnltb3VzIHNlbWFu
dGljcyBkZXNpZ24gaW4gZG9jdW1lbnRhdGlvbiBzbyBwZW9wbGUgd29uJ3QgZ2V0ICANCj4gY29u
ZnVzZWQgaW4gZnV0dXJlLg0KPiANCj4gSSB0aGluayB3ZSBhbGwgYWdyZWUgdG8ga2VlcCB0aGlz
IHNlbWFudGljcyBzbyBubyB1c2VyIHNwYWNlIHdvdWxkIG5lZWQgIA0KPiBzcGVjaWZ5ICdvZmZz
ZXQnIGZvciBtbWFwIHdpdGggZW5jbGF2ZSBmZC4gQW5kIGhlcmUgaXMgbXkgcHJvcG9zZWQgIA0K
PiBkb2N1bWVudGF0aW9uIGNoYW5nZXMuDQo+IA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL3g4Ni9z
Z3gucnN0DQo+ICsrKyBiL0RvY3VtZW50YXRpb24veDg2L3NneC5yc3QNCj4gQEAgLTEwMCw2ICsx
MDAsMjMgQEAgcGFnZXMgYW5kIGVzdGFibGlzaCBlbmNsYXZlIHBhZ2UgcGVybWlzc2lvbnMuDQo+
ICAgICAgICAgICAgICAgICAgc2d4X2lvY19lbmNsYXZlX2luaXQNCj4gICAgICAgICAgICAgICAg
ICBzZ3hfaW9jX2VuY2xhdmVfcHJvdmlzaW9uDQo+IA0KPiArRW5jbGF2ZSBtZW1vcnkgbWFwcGlu
Zw0KPiArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiArDQo+ICtBIGZpbGUgZGVzY3JpcHRvciBj
cmVhdGVkIGZyb20gb3BlbmluZyAqKi9kZXYvc2d4X2VuY2xhdmUqKiByZXByZXNlbnRzIGFuDQo+
ICtlbmNsYXZlIG9iamVjdC4gVGhlIG1tYXAoKSBzeXNjYWxsIHdpdGggZW5jbGF2ZSBmaWxlIGRl
c2NyaXB0b3JzIGRvZXMgbm90DQo+ICtzdXBwb3J0IG5vbi16ZXJvIHZhbHVlIGZvciB0aGUgJ29m
ZnNldCcgcGFyYW1ldGVyLg0KDQpJIHRoaW5rIHdlIGFsbCBuZWVkIHRvIHVuZGVyc3RhbmQgYmV0
dGVyIHdoeSBTR1ggZHJpdmVyIHJlcXVpcmVzIGFub255bW91cw0Kc2VtYW50aWNzIG1tYXAoKSBh
Z2FpbnN0IC9kZXYvc2d4X2VuY2xhdmUsIGFuZCBhcyBhIHJlc3VsdCBvZiB0aGF0LCByZXF1aXJl
cw0KbW1hcCgpIHRvIHBhc3MgIDAgYXMgcGdvZmYgKHdoaWNoIGxvb2tzIHdhc24ndCBldmVuIGRp
c2N1c3NlZCB3aGVuIHVwc3RyZWFtaW5nDQp0aGUgZHJpdmVyKS4NCg0KSSdsbCBkbyBzb21lIGlu
dmVzdGlnYXRpb24gYW5kIHRyeSB0byBzdW1tZXJpemUgYW5kIHJlcG9ydCBiYWNrLiAgVGhhbmtz
Lg0KDQpbLi4uXQ0KDQo+IFRoaXMgaXMNCj4gK3VubGlrZSByZWd1bGFyIGZpbGUgbWFwcGluZyBp
biB0aGF0IG5vIGNvbnRlbnQgb2Zmc2V0IGNhbiBiZSBkZWZpbmVkIHRoYXQgIA0KPiBpcw0KPiAr
aW5kZXBlbmRlbnQgZnJvbSB0aGUgdmlydHVhbCBhZGRyZXNzIGl0IGlzIGxvYWRlZCB0by4NCj4g
Kw0KPiANCg0KRG9uJ3QgcXVpdGUgdW5kZXJzdGFuZCB0aGlzLiAgVGhlIHZpcnR1YWwgYWRkcmVz
cyBvZiBhIHJlZ3VsYXIgZmlsZSBtYXBwaW5nIGNhbg0KYmUgbGlua2VkIHRvIGZpbGUncyBvZmZl
c3QgZnJvbSBWTUEncyBwZ29mZi4NCg0KDQo=
