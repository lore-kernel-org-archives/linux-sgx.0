Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9C7C00140
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Aug 2022 03:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbiHODLo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 14 Aug 2022 23:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiHODLk (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 14 Aug 2022 23:11:40 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA6B6552
        for <linux-sgx@vger.kernel.org>; Sun, 14 Aug 2022 20:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660533099; x=1692069099;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lohofCkCl0tD9zCDlgpd4K02kVZSdMKfHmsUUP/u18Q=;
  b=Brj7+iVYQYERZR3KgvXcnrXYBmgbl3l0pmsO5wn/FDB2vub6mmvPcUOT
   FykVfHwD9Z0L1Fxwi6rth9kAi5a/BO7q9KlkJXrT0RHnt5XrIXzbYL7/N
   QfP3at44+H1UH06FmxKHVndWczoVOvs7N5v3zW5FHlb0PYFSTNqluU8Ch
   vyBr6S2xtTItq6qLv7yp6Sm27Xd5jOC/zc66J1VjUkPx/GNn1+31ucU9Y
   4mW4EtMHbKjxXw6OkUOYkpNGWMLfwBNP4BaBLLv3yXEh4sSd2rD7VAQLb
   jE9oC5afLSd+v2BzlbnCkrgDO5Ms7QLNu7G88Tj3XfuQO70BU/I2XA+Gp
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10439"; a="292676200"
X-IronPort-AV: E=Sophos;i="5.93,237,1654585200"; 
   d="scan'208";a="292676200"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2022 20:11:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,237,1654585200"; 
   d="scan'208";a="639509258"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 14 Aug 2022 20:11:38 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Sun, 14 Aug 2022 20:11:38 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Sun, 14 Aug 2022 20:11:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Sun, 14 Aug 2022 20:11:38 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Sun, 14 Aug 2022 20:11:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgNuQuW5uEl1Cg79vrHd4qdMdo9YL91wmA9o3ApYtZu7qgsGS65LiXi0ucQBEtJEwELpyf72ppmOs+BBCn2POEKYPVtTcTTvg/QSKi/nQRwvSeSgdktNpmQeMYaxzOFNmwm3GC1WQdyKlyWOLMZdtrPB9rjaNI0wG1oJqATWo+KaqG6AfqDVqbdqoNg2WBIZkJacNCQ+WRuYPBZcLn/VCwE9yUeDy+8MGbEor762S93ZmeG5kDOKNiqgzXtFL/P0kTWoihB4NJeP8urLEVw1LKn/8GlBQFRu+qpNAQsyWx8re60DdMYPx8LwKXvMXcheNCDfpZD+YikDDeuoaVLIHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lohofCkCl0tD9zCDlgpd4K02kVZSdMKfHmsUUP/u18Q=;
 b=G/lKg75BIVfvB6QFJLMUpyDFnyOoJMGsC5EqnbmIaRpzs+qgAD/MxlQKysZ7nLaJ+Y6eJ7sA3LQoe/QnqkghM4Wqm284yrKdRdB139tlwNDglks5fJj0jNZH75aGrOKu62yefu0SKpX/tLAXGD2PWzpz6wQSqy9ZMSWbaeE5TARNCOwMSDthPLta35OdVIq7Z1N9P/hLijiuzGHrOVpppLU9cTLhmg1wtzuDI3/XkyhNZlnzLYPK19I301B7mwNF1bYVClZxzKAJJJ1w2WZoTL1YXqT1Zx2H0vaQhC2uq/hE7tbtWuqk5oipO2pCPYT4pw6vy6AMU12aeOfAH6A/dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB6181.namprd11.prod.outlook.com (2603:10b6:208:3c7::13)
 by DM6PR11MB2826.namprd11.prod.outlook.com (2603:10b6:5:c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Mon, 15 Aug
 2022 03:11:36 +0000
Received: from MN0PR11MB6181.namprd11.prod.outlook.com
 ([fe80::8138:b9dd:f7f6:5b19]) by MN0PR11MB6181.namprd11.prod.outlook.com
 ([fe80::8138:b9dd:f7f6:5b19%9]) with mapi id 15.20.5504.021; Mon, 15 Aug 2022
 03:11:35 +0000
From:   "Du, Fan" <fan.du@intel.com>
To:     "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "Du, Fan" <fan.du@intel.com>
Subject: RE: [PATCH v6 0/3] x86/sgx: fine grained SGX MCA behavior
Thread-Topic: [PATCH v6 0/3] x86/sgx: fine grained SGX MCA behavior
Thread-Index: AQHYno5j18bKHj9Y2EaXaxPieOBA562vbBvw
Date:   Mon, 15 Aug 2022 03:11:35 +0000
Message-ID: <MN0PR11MB6181A14ED05182E44C1F5E6B99689@MN0PR11MB6181.namprd11.prod.outlook.com>
References: <20220723122343.598783-1-zhiquan1.li@intel.com>
In-Reply-To: <20220723122343.598783-1-zhiquan1.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ecfd4625-c161-4f73-7c7e-08da7e6bdca5
x-ms-traffictypediagnostic: DM6PR11MB2826:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iNI9fJrFvZ19j6hm7XMOqIlLBwr6lSRthLJQquet1AL/Z+FxKXtxGThy/q4KEAjqjhSRj+yUrd145sS05JHlH9ePI2htveJdBuu7+g6rb65hLsjLMXSXgnC6r7m3qy08cJPVGLu7bVzA/6kDIrR0wuXAJnUoosUV1kg2Z+Bii9O4TbgY62CzPm10SwS13ccsIZBvUcz6aplXvUFAIFEHjB7cTItor8Mg7T9bELjH4IriN3ZS2pRjezg1hYCosdVMdkuZTHArtZUE0wFiI+tK/3GEXaHilR9a1NOYEx6o8JnoEkpyM6DG2ChVvGRyktawo10GeOidfcZt+fVig8OfDpmZ9QXM9EP2WTtcKz9aqrLICqmHg5xaoYC5xHwM/5bHuiZw2CxNHLmZfwPm9LVJJL/qkMJ9nzg6Zf+49l7e/mqJYkuaBfFqGp/9wcJ/gyBovPsyPAl7xtPBnI+dhNoYh9BxF3rMRI7Ds677uPCCT73IqnPbw4sv8oe74ILdVahdxUU4bqEEJ9wFH9CwWvZTVKOvCP8vI/Yde0dUpbThke+6Y+TZPK3VOHMPqyK9g2wbpzik6Mg4IlWPwReri5vVoBZ/MzXqECb+1B3EpWZF0nIVhE5ocfD8WuTTcZ4vY4AIXHxzCTV+YUG0aBxSE7pzRxcLJb2dmOvazkWDgCnoHlTm15hZKSKqA/ne7KFaHo4/dYa+uCkR+BJaikv13WEfgLLh1y1KmiPqCcw7tH/0mjkF9E4XX3ld6A23rHgfE+hBkLlcGJtIUyc2Eg1OrsPjhTfMSaHnu330OjVdjm1ryq/Mc+dPPUKqunojk7GYS/TFwg7ZGb7O8JogslHnjRjyQZPccalIFPzFhrQUKH4wL+eiQu/JbauOZkP4zExCIOQW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6181.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(346002)(136003)(376002)(83380400001)(82960400001)(38070700005)(86362001)(122000001)(38100700002)(66556008)(66476007)(66446008)(64756008)(110136005)(66946007)(8676002)(4326008)(54906003)(76116006)(316002)(52536014)(8936002)(2906002)(5660300002)(53546011)(7696005)(6506007)(9686003)(26005)(186003)(71200400001)(55016003)(41300700001)(966005)(478600001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnJibG93b21LRzZFWXFNQVlDOEhYNUJiU3lWNkIwT2RnUWVDaVdSSWtWTzdq?=
 =?utf-8?B?SmtFcXlqbDhyR01zOWJ3aUwvbXRsc2ZtdDlpUlp4R3ByV1ZJelhQWkhJN1dC?=
 =?utf-8?B?WTdHUlZDZ1pwb0ZERWp4cEZqOVhTelVldTRWS2lLVnl6RnlyaDRDWS9KQ21O?=
 =?utf-8?B?N3FYdU9FMjhjVXRrdlhWRzFKSlZaWVlTQkNYWDBTZTJ5QlhqK3B3WFhhNnBl?=
 =?utf-8?B?K0tFODdjRG5HVzRtMUliRnFOYVJaU1kyQi9XbVFHbUdlT2greWRrZm1LaE9i?=
 =?utf-8?B?eGZtZ0p3c25NTFJBM1ZVaUNnSWtwc3g1c05GdmVNSFM5cXJiUk5rbWpTUkVR?=
 =?utf-8?B?TXhPL3pSU0gxNWl5SHZuNGRNb29VMDZ2VzVhZFprZGRNeTB0YjRFQjhPWDV1?=
 =?utf-8?B?aGtBeHZhcXFQeFQ5VzhBK2NITjd6WXpaV1h6SUE1QmFuQnkzV1phYWUxb2dw?=
 =?utf-8?B?bk5zdDUweVR1c0VYcmVXcEFsaEk4cmw0d296dHZPVVBmQ0l6QjVEeTlRd1ZV?=
 =?utf-8?B?S0hCSzZzRmhmY29WODBDUWlMZEZnK1E4UFVHSitmc3ZOakk1NkJDTStndUE4?=
 =?utf-8?B?a1MybkdLbWk5dG5NcDQvTmF3cDgrS2c1Y0xWNVB0UTBVZGhvYzhhZGJjamE1?=
 =?utf-8?B?WnIrNjNsVDh4M0Y5TU5EU3hSSERqYzNTNmNQQ05mQklDcVBTbDIrcVJsMVZF?=
 =?utf-8?B?NWtjL3hRT2dzRjVaYUdDT1RkSU1pREppWEZDQUd5bVJXdDVxbWlTak81dktU?=
 =?utf-8?B?cWtxT1JNYWJuYzBnY3dJSzc2eGRjeXJEQm0xRU5YUUxSVXhacHBic1IyZzIy?=
 =?utf-8?B?SEwxWTBZVG51Sk9HS0lOVDQrTTVOd0VLZ2VqS2lxeURKaGNHbGovTjBXS1BP?=
 =?utf-8?B?NFovOUVrLzhJQ0V6NVV3YWRIa0hXM1lIRXJ6MmwvUGNuSkNkakZudHF4cm1p?=
 =?utf-8?B?VzcxamN0Y3BXOExHTDVVd3hSWmpGeWN6UllBKzBmeWI3aDNYS0dDZzNoVWZ0?=
 =?utf-8?B?Mk1wbytEZzA3dWVDeXoyVTNoSmMrV3F3Mm1JZWY4dE9BeGY3TlgrSFNSTDU4?=
 =?utf-8?B?NUpkS2h5SVluZitOS01YdjFTS2FBQzZJanFWU3VEdnV6YnVyMS9NZjVtNVB6?=
 =?utf-8?B?bDQ0R0pqU0ZEcHdOWUcrNi9za3Jzc0d3eFhRcVFyZ1F2Y2xBSU95QWhQd1Rp?=
 =?utf-8?B?TUNqd2VGWlV4UGVUMUFNUGdQdVRQVFd2K1BPSG5MaFFFRitCZzAzclByVGUv?=
 =?utf-8?B?VWZ3MjRicmNNVWlIL2YyRXo2K3pDSnF0WlBjYVA4dzJSQ3RmWnhFNHpNNkhU?=
 =?utf-8?B?ZXJ5S3BOY3htVGtKYmNDVWFpTU9DY1Nxb2JJajNQS0dpM0ZQY01IamZXL2FJ?=
 =?utf-8?B?UXYyZEoyUWEwT29MalFOd29ZOS92ZS9KQTBhL3crVVUraFJYNjJMdkM2T0li?=
 =?utf-8?B?N0pENzludU1VeFJDdVVFMXhHZ3FxQ3dFZnlmOHg5MElyTERER0RRbU1Qa2VL?=
 =?utf-8?B?L3MxU0pzcEhDMXRJQ25vNjZ6UjM4dHV2UnJWUWFtek9FeDcrNnIvL2JGcjVh?=
 =?utf-8?B?cXczcXpKS01BTTBTWk9CN3U4QXYxMUlBOCtJSWxMYUxyUVJ6UU8zS0g4TXhx?=
 =?utf-8?B?VXdMdXhjYjRyT1FmdDF2c2ZzZWt6ZHlMUjc1dDFpM2lnMWI1L1lQSWE1SXBm?=
 =?utf-8?B?bVFRcmoxcy9wZHhiQU1nUmcxNnZhQ0hiSjVKbENLZEhWU1F6WnV3RTZoWWxU?=
 =?utf-8?B?c0VoZlNCbWNyUEZtL09ZVE40bUVQYUZUZUlxeWtXbUpXYjhMWVkxWWNEK3R3?=
 =?utf-8?B?UVU0d3I2ZURrZ3JVWGswMHpGL3FzcEFNRnZKdFJkOExyMDZtZXVyTjl4d0Nk?=
 =?utf-8?B?OUlRQXhsckxlWGNKMjROMVZHMkFHRUxxd3hpd2pkcC9Pd3l6U0xDUlFSQ1o3?=
 =?utf-8?B?dEhJQzFlNEl6YTNlSU5zVzdMV3FPOE5qbHYwMDRmRm8rWjY4OVBKN1hKRVNO?=
 =?utf-8?B?MHpla3NKTlpVTGFvUE5HVWxjanV5aVl4bUNxUDRzQ2ZJckZtOHQvZmw4anUr?=
 =?utf-8?B?VDF6OXM1NHJCWWo1cHJVZ2dKT0RSb2NmbTBqSTQyM1VrVk1zUzBBT05WYmtl?=
 =?utf-8?Q?45os=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6181.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecfd4625-c161-4f73-7c7e-08da7e6bdca5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2022 03:11:35.4467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6A8slYKW/aKAmrxF2XB0DzZtKyiSfI570knmEoCwTjgszV03srffiKi3QDSizrpZhvL6IYjQvLB+M9JEW8/Fow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2826
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGkgRGF2ZSwgDQoNCkFueSBtb3JlIGNvbW1lbnRzIGZvciB2Nj8NCg0KVGhhbmtzIQ0KDQo+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IExpLCBaaGlxdWFuMSA8emhpcXVhbjEu
bGlAaW50ZWwuY29tPg0KPiBTZW50OiBTYXR1cmRheSwgSnVseSAyMywgMjAyMiA4OjI0IFBNDQo+
IFRvOiBsaW51eC1zZ3hAdmdlci5rZXJuZWwub3JnOyBMdWNrLCBUb255IDx0b255Lmx1Y2tAaW50
ZWwuY29tPjsNCj4gamFya2tvQGtlcm5lbC5vcmc7IGRhdmUuaGFuc2VuQGxpbnV4LmludGVsLmNv
bQ0KPiBDYzogQ2hyaXN0b3BoZXJzb24sLCBTZWFuIDxzZWFuamNAZ29vZ2xlLmNvbT47IEh1YW5n
LCBLYWkNCj4gPGthaS5odWFuZ0BpbnRlbC5jb20+OyBEdSwgRmFuIDxmYW4uZHVAaW50ZWwuY29t
PjsgWmhhbmcsIENhdGh5DQo+IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+OyBMaSwgWmhpcXVhbjEg
PHpoaXF1YW4xLmxpQGludGVsLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIHY2IDAvM10geDg2L3Nn
eDogZmluZSBncmFpbmVkIFNHWCBNQ0EgYmVoYXZpb3INCj4gDQo+IFY1OiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9saW51eC1zZ3gvWXJmMjdmdWdEN2xreWFla0BrZXJuZWwub3JnL1QvI3QNCj4g
DQo+IENoYW5nZXMgc2luY2UgVjU6DQo+IC0gUmVuYW1lIHRoZSAnb3duZXInIGZpZWxkIGFzICdl
bmNsX293bmVyJyBhbmQgdXBkYXRlIHRoZSByZWZlcmVuY2VzDQo+ICAgYXMgYSBzZXBhcmF0ZSBw
YXRjaC4NCj4gLSBUbyBwcmV2ZW50IGNhc3RpbmcgdGhlICdlbmNsX293bmVyJyBmaWVsZCwgaW50
cm9kdWNlIGEgdW5pb24gd2l0aA0KPiAgIGFub3RoZXIgZmllbGQgLSAidmVwY192YWRkciIuDQo+
IC0gQ2xlYW4gdXAgdGhlIGNvbW1pdCBtZXNzYWdlIG9mIHBhdGNoIDAyIHN1Z2dlc3RlZCBieSBE
YXZlLg0KPiAtIFJlbW92ZSBwYXRjaCAwMyB1bmxlc3MgdGhlcmUgaXMgYSBiZXR0ZXIgcmVhc29u
IHRvIGtlZXAgaXQuDQo+IC0gQWRkIFJldmlld2VkLWJ5IGZyb20gSmFya2tvLg0KPiANCj4gVjQ6
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXNneC8yMDIyMDYwODAzMjY1NC4xNzY0OTM2
LTEtDQo+IHpoaXF1YW4xLmxpQGludGVsLmNvbS9ULyN0DQo+IA0KPiBDaGFuZ2VzIHNpbmNlIFY0
Og0KPiAtIFN3aXRjaCB0aGUgb3JkZXIgb2YgdGhlIHR3byB2YXJpYWJsZXMgYXQgcGF0Y2ggMDIg
c28gYWxsIG9mIHZhcmlhYmxlcw0KPiAgIGFyZSBpbiByZXZlcnNlIENocmlzdG1hcyBzdHlsZS4N
Cj4gLSBEbyBub3QgaW5pdGlhbGl6ZSAncmV0JyBiZWNhdXNlIGl0IHdpbGwgYmUgb3ZlcnJpZGRl
biBieSB0aGUgcmV0dXJuDQo+ICAgdmFsdWUgb2YgZm9yY2Vfc2lnX21jZWVycigpIHVuY29uZGl0
aW9uYWxseS4NCj4gLSBBZGQgQ28tZGV2ZWxvcGVkLWJ5IGFuZCBTaWduZWQtb2ZmLWJ5IGZyb20g
Q2F0aHkgWmhhbmcgYXQgcGF0Y2ggMDEuDQo+IC0gQWRkIEFja2VkLWJ5IGZyb20gS2FpIEh1YW5n
IGF0IHBhdGNoIDAxLg0KPiANCj4gVjM6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LQ0K
PiBzZ3gvNDE3MDRlNWQ0YzAzYjQ5ZmNkYTEyZTY5NTU5NTIxMWQ5NTBjZmIwOC5jYW1lbEBrZXJu
ZWwub3JnL1QvI3QNCj4gDQo+IENoYW5nZXMgc2luY2UgVjM6DQo+IC0gVGFrZSB0aGUgZGVmaW5p
dGlvbiBvZiBFUEMgcGFnZSBmbGFnIFNHWF9FUENfUEFHRV9LVk1fR1VFU1QgZnJvbQ0KPiAgIENh
dGh5IFpoYW5nJ3MgdGhpcmQgcGF0Y2ggb2YgU0dYIHJlYm9vdGxlc3MgcmVjb3ZlcnkgcGF0Y2gg
c2V0IGJ1dA0KPiAgIGRpc2NhcmQgaXJyZWxldmFudCBwb3J0aW9uLCBzaW5jZSBpdCBtaWdodCBu
ZWVkIHNvbWUgdGltZSB0byByZS1mb3JnZQ0KPiAgIGFuZCB0aGVzZSBhcmUgdHdvIGRpZmZlcmVu
dCBmZWF0dXJlcy4NCj4gICBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC0NCj4g
c2d4LzQxNzA0ZTVkNGMwM2I0OWZjZGExMmU2OTU1OTUyMTFkOTUwY2ZiMDguY2FtZWxAa2VybmVs
Lm9yZy9ULyNtDQo+IDk3ODJkMjM0OTZjYWNlY2I3ZGEwN2E2N2RhYTc5ZjRiMzIyYWUxNzANCj4g
DQo+IFYyOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1zZ3gvNjk0MjM0ZDctNmEwZC1l
ODVmLWYyZjktDQo+IGU1MmI0YTYxZTFlY0BpbnRlbC5jb20vVC8jdA0KPiANCj4gQ2hhbmdlcyBz
aW5jZSBWMjoNCj4gLSBSZXB1cnBvc2UgdGhlIG93bmVyIGZpZWxkIGFzIHRoZSB2aXJ0dWFsIGFk
ZHJlc3Mgb2YgdmlydHVhbCBFUEMgcGFnZQ0KPiAtIFJlbW92ZSBzdHJ1Y3Qgc2d4X3ZlcGNfcGFn
ZSBhbmQgcmVsZXZhbnQgY29kZS4NCj4gLSBSZW1vdmUgcGF0Y2ggMDEgYXMgdGhlIGNoYW5nZXMg
YXJlIG5vdCBuZWNlc3NhcnkgaW4gbmV3IGRlc2lnbi4NCj4gLSBSZXdvcmsgcGF0Y2ggMDIgc3Vn
Z2VzdGVkIGJ5IEphcmtrby4NCj4gLSBBZGFwdCBwYXRjaCAwMyBhbmQgMDQgc2luY2Ugc3RydWN0
IHNneF92ZXBjX3BhZ2Ugd2FzIGRpc2NhcmRlZC4NCj4gLSBSZXBsYWNlIEVQQyBwYWdlIGZsYWcg
U0dYX0VQQ19QQUdFX0lTX1ZFUEMgd2l0aA0KPiAgIFNHWF9FUENfUEFHRV9LVk1fR1VFU1QgYXMg
dGhleSBhcmUgZHVwbGljYXRlZC4NCj4gICBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9s
aW51eC0NCj4gc2d4L2ViOTViMzJlY2YzZDQ0YTY5NTYxMGNmN2YyODE2Nzg1QGludGVsLmNvbS9U
LyN1DQo+IA0KPiBWMTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtc2d4LzQ0M2NiNDI1
LTAwOWMtMjc4NC01NmY0LQ0KPiA1ZTcwNzEyMmRlNzZAaW50ZWwuY29tL1QvI3QNCj4gDQo+IENo
YW5nZXMgc2luY2UgVjE6DQo+IC0gVXBkYXRlZCBjb3ZlciBsZXR0ZXIgYW5kIGNvbW1pdCBtZXNz
YWdlcywgYWRkZWQgdmFsdWFibGUNCj4gICBpbmZvcm1hdGlvbiBmcm9tIEphcmtrbywgVG9ueSBh
bmQgS2FpJ3MgY29tbWVudHMuDQo+IC0gQWRkZWQgZG9jdW1lbnRhdGlvbnMgZm9yIHN0cnVjdCBz
dHJ1Y3Qgc2d4X3ZlcGMgYW5kDQo+ICAgc3RydWN0IHNneF92ZXBjX3BhZ2UuDQo+IA0KPiBIaSBl
dmVyeW9uZSwNCj4gDQo+IFRoaXMgc2VyaWVzIGNvbnRhaW5zIGEgZmV3IHBhdGNoZXMgdG8gZmlu
ZSBncmFpbmVkIFNHWCBNQ0EgYmVoYXZpb3IuDQo+IA0KPiBUb2RheSwgaWYgYSBndWVzdCBhY2Nl
c3NlcyBhbiBTR1ggRVBDIHBhZ2Ugd2l0aCBtZW1vcnkgZmFpbHVyZSwNCj4gdGhlIGtlcm5lbCBi
ZWhhdmlvciB3aWxsIGtpbGwgdGhlIGVudGlyZSBndWVzdC4gIFRoaXMgYmxhc3QNCj4gcmFkaXVz
IGlzIHRvbyBsYXJnZS4gIEl0IHdvdWxkIGJlIGlkZWEgdG8ga2lsbCBvbmx5IHRoZSBTR1gNCj4g
YXBwbGljYXRpb24gaW5zaWRlIHRoZSBndWVzdC4NCj4gDQo+IFRvIGZpeCB0aGlzLCBzZW5kIGEg
U0lHQlVTIHRvIGhvc3QgdXNlcnNwYWNlIChsaWtlIFFFTVUpIHdoaWNoIGNhbg0KPiBmb2xsb3cg
dXAgYnkgaW5qZWN0aW5nIGEgI01DIHRvIHRoZSBndWVzdC4NCj4gDQo+IEhvd2V2ZXIsIHdoZW4g
YSBwYWdlIHRyaWdnZXJzIGEgbWFjaGluZSBjaGVjaywgaXQgb25seSByZXBvcnRzIHRoZQ0KPiBQ
Rk4uICBCdXQgaW4gb3JkZXIgdG8gaW5qZWN0ICNNQyBpbnRvIGh5cGVydmlzb3IsIHRoZSB2aXJ0
dWFsIGFkZHJlc3MNCj4gaXMgcmVxdWlyZWQuICBUaGUgJ2VuY2xfb3duZXInIGZpZWxkIGlzIHVz
ZWxlc3MgaW4gdmlydHVhbGl6YXRpb24NCj4gY2FzZSwgdGhlbiByZXB1cnBvc2UgaXQgYXMgJ3Zl
cGNfdmFkZHInIC0gdGhlIHZpcnR1YWwgYWRkcmVzcyBvZiB0aGUNCj4gdmlydHVhbCBFUEMgcGFn
ZSBpbiBzdWNoIGNhc2Ugc28gdGhhdCBhcmNoX21lbW9yeV9mYWlsdXJlKCkgY2FuIGVhc2lseQ0K
PiByZXRyaWV2ZSBpdC4NCj4gDQo+IFN1cHBvc2UgYW4gZW5jbGF2ZSBpcyBzaGFyZWQgYnkgbXVs
dGlwbGUgcHJvY2Vzc2VzLCB3aGVuIGFuIGVuY2xhdmUNCj4gcGFnZSB0cmlnZ2VycyBhIG1hY2hp
bmUgY2hlY2ssIHRoZSBlbmNsYXZlIHdpbGwgYmUgZGlzYWJsZWQgc28gdGhhdA0KPiBpdCBjb3Vs
ZG4ndCBiZSBlbnRlcmVkIGFnYWluLiAgS2lsbGluZyBvdGhlciBwcm9jZXNzZXMgd2l0aCB0aGUg
c2FtZQ0KPiBlbmNsYXZlIG1hcHBlZCB3b3VsZCBwZXJoYXBzIGJlIG92ZXJraWxsLCBidXQgdGhl
eSBhcmUgZ29pbmcgdG8gZmluZA0KPiB0aGF0IHRoZSBlbmNsYXZlIGlzICJkZWFkIiBuZXh0IHRp
bWUgdGhleSB0cnkgdG8gdXNlIGl0LiAgVGhhbmtzIGZvcg0KPiBKYXJra2/igJlzIGhlYWQgdXAg
YW5kIFRvbnnigJlzIGNsYXJpZmljYXRpb24gb24gdGhpcyBwb2ludC4NCj4gDQo+IFVubGlrZSBo
b3N0IGVuY2xhdmVzLCB2aXJ0dWFsIEVQQyBpbnN0YW5jZSBjYW5ub3QgYmUgc2hhcmVkIGJ5IG11
bHRpcGxlDQo+IFZNcy4gSXQgaXMgYmVjYXVzZSBob3cgZW5jbGF2ZXMgYXJlIGNyZWF0ZWQgaXMg
dG90YWxseSB1cCB0byB0aGUgZ3Vlc3QuDQo+IFNoYXJpbmcgdmlydHVhbCBFUEMgaW5zdGFuY2Ug
d2lsbCBiZSB2ZXJ5IGxpa2VseSB0byB1bmV4cGVjdGVkbHkgYnJlYWsNCj4gZW5jbGF2ZXMgaW4g
YWxsIFZNcy4NCj4gDQo+IFNHWCB2aXJ0dWFsIEVQQyBkcml2ZXIgZG9lc24ndCBleHBsaWNpdGx5
IHByZXZlbnQgdmlydHVhbCBFUEMgaW5zdGFuY2UNCj4gYmVpbmcgc2hhcmVkIGJ5IG11bHRpcGxl
IFZNcyB2aWEgZm9yaygpLiBIb3dldmVyIEtWTSBkb2Vzbid0IHN1cHBvcnQNCj4gcnVubmluZyBh
IFZNIGFjcm9zcyBtdWx0aXBsZSBtbSBzdHJ1Y3R1cmVzLCBhbmQgdGhlIGRlIGZhY3RvIHVzZXJz
cGFjZQ0KPiBoeXBlcnZpc29yIChRZW11KSBkb2Vzbid0IHVzZSBmb3JrKCkgdG8gY3JlYXRlIGEg
bmV3IFZNLCBzbyBpbiBwcmFjdGljZQ0KPiB0aGlzIHNob3VsZCBub3QgaGFwcGVuLg0KPiANCj4g
VGhpcyBzZXJpZXMgaXMgYmFzZWQgb24gdGlwL3g4Ni9zZ3guDQo+IA0KPiBUZXN0czoNCj4gMS4g
TUNFIGluamVjdGlvbiB0ZXN0IGZvciBTR1ggaW4gVk0uDQo+ICAgIEFzIHdlIGV4cGVjdGVkLCB0
aGUgYXBwbGljYXRpb24gd2FzIGtpbGxlZCBhbmQgVk0gd2FzIGFsaXZlLg0KPiAyLiBLZXJuZWwg
c2VsZnRlc3Qvc2d4OiBQQVNTDQo+IDMuIEludGVybmFsIFNHWCBzdHJlc3MgdGVzdDogUEFTUw0K
PiA0LiBrbWVtbGVhayB0ZXN0OiBObyBtZW1vcnkgbGVha2FnZSBkZXRlY3RlZC4NCj4gDQo+IE11
Y2ggYXBwcmVjaWF0ZSB5b3VyIGZlZWRiYWNrLg0KPiANCj4gQmVzdCBSZWdhcmRzLA0KPiBaaGlx
dWFuDQo+IA0KPiBaaGlxdWFuIExpICgzKToNCj4gICB4ODYvc2d4OiBSZW5hbWUgdGhlIG93bmVy
IGZpZWxkIG9mIHN0cnVjdCBzZ3hfZXBjX3BhZ2UgYXMgZW5jbF9vd25lcg0KPiAgIHg4Ni9zZ3g6
IEludHJvZHVjZSB1bmlvbiB3aXRoIHZlcGNfdmFkZHIgZmllbGQgZm9yIHZpcnR1YWxpemF0aW9u
IGNhc2UNCj4gICB4ODYvc2d4OiBGaW5lIGdyYWluZWQgU0dYIE1DQSBiZWhhdmlvciBmb3Igdmly
dHVhbGl6YXRpb24NCj4gDQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMgfCA0OCAr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tDQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1
L3NneC9zZ3guaCAgfCAgOCArKysrKy0NCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3ZpcnQu
YyB8ICA0ICsrLQ0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA0NiBpbnNlcnRpb25zKCspLCAxNCBkZWxl
dGlvbnMoLSkNCj4gDQo+IC0tDQo+IDIuMjUuMQ0KDQo=
