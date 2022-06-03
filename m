Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52193C43334
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Jun 2022 01:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbiFCBPc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Jun 2022 21:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242120AbiFCBPX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 2 Jun 2022 21:15:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4606A38DAD
        for <linux-sgx@vger.kernel.org>; Thu,  2 Jun 2022 18:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654218921; x=1685754921;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rWcqgTxFzEaHGtYIpFEfYDSzih5ADndX1gAyUR1KuE0=;
  b=JZs8qRkR3XE7yfbYTntjSrIQ4QDsqZAQoo6QyT4K8slOKKReXtJMTEjf
   0qyTgAbtq2A3kDDd6P9jLPJ7N4CAUv0Ashoso8RbSXHUQWRnFjZ1a6h7C
   KIJTA2YElNZtjY+/G2mOGJJYfSaoW3zaJE330NU16xrdYmBPD5PdJu9Do
   AAam4onfwHHbmUZp0piLegHSBzYxpYSQ7Jg35vwcCNIwX3BVOWr1Kpgqp
   LTB1ZtkYYdlHv0rN1L5JFx3BjRBeUhQvM4qTVbt4rSOmKdGs5yDTcTLdW
   ioS3+oyBCWBXyX4oapaI/pe1pTz1Wz4guvcR76EvUf7uHLLtMsA+iy4lD
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10366"; a="301502398"
X-IronPort-AV: E=Sophos;i="5.91,273,1647327600"; 
   d="scan'208";a="301502398"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 18:15:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,273,1647327600"; 
   d="scan'208";a="646250923"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 02 Jun 2022 18:15:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 2 Jun 2022 18:15:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 2 Jun 2022 18:15:20 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 2 Jun 2022 18:15:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLwxNZOdLyDoUBwseFRaGab8FUxqCkRQ5OAdH1+q2Yz7Cu4W4f6nNiFECc22IApofUv9SdaTr3abV3mjpbC9/hKjPnEjPLAsPfLVfYb//hRchulnCCdpar50Zv58ycDpclqkDbL8tRPcd3IFIwmw0x4jjB+Xt0YQLUmCRBxjaIE2D5P8fnekvrkveN+THgZsk7WaXsSVW+HEd9Xu/8ejCJ+pkDvOUy5sUL/wR3WvEShDECCyD3yQLGpskodM6mdCAXBWxBXw/Vz/kE2VceBazVx27dXdfpWRn4XHANQx0+YflWlwjawSowtXW3EFoIB10wmI8CqasQfN+pxLCtlfvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWcqgTxFzEaHGtYIpFEfYDSzih5ADndX1gAyUR1KuE0=;
 b=NUbasd1oVHRRgXj+GrVXrG24FH9PNK9WECC6wIgpnwjq0NPWlqaN09BQzQTtylPkrRoCBgdOZLrm0thufEzsPuoi1QmjZ7BSIS7J/k7EKHXEEr2DyvdF935e/GJtrplsmHFQ/ApBWbGXzWPVjYGWjXFvQxctuzTS8d2MDRkwPTzREjz+KGITs1YMeIZkLOvEI3cT2rDUFT61KxEPawiSBQVPDX/O5pTYFp0uIKAQBDXyTd76UadJr8HdtFVO8bWTNzLbDqKok+cgz0VW0xUqYULkCKWY/Q+nSto4kjDtTtRt9cugeVmWY4Vlxwma6nzEFYCSqXT22xSsqF23idWjqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB6181.namprd11.prod.outlook.com (2603:10b6:208:3c7::13)
 by CO1PR11MB4916.namprd11.prod.outlook.com (2603:10b6:303:9c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Fri, 3 Jun
 2022 01:15:18 +0000
Received: from MN0PR11MB6181.namprd11.prod.outlook.com
 ([fe80::5c32:21fc:e4bd:f128]) by MN0PR11MB6181.namprd11.prod.outlook.com
 ([fe80::5c32:21fc:e4bd:f128%6]) with mapi id 15.20.5314.015; Fri, 3 Jun 2022
 01:15:18 +0000
From:   "Du, Fan" <fan.du@intel.com>
To:     "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Jarkko Sakkinen" <jarkko@kernel.org>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Huang, Kai" <kai.huang@intel.com>, "Du, Fan" <fan.du@intel.com>
Subject: RE: [PATCH v3 0/3] x86/sgx: fine grained SGX MCA behavior
Thread-Topic: [PATCH v3 0/3] x86/sgx: fine grained SGX MCA behavior
Thread-Index: AQHYcB721C+wXsjY7kSjwSTSBqWOp60wUJ8AgAxvWtA=
Date:   Fri, 3 Jun 2022 01:15:18 +0000
Message-ID: <MN0PR11MB6181099B27E37C05659A30B199A19@MN0PR11MB6181.namprd11.prod.outlook.com>
References: <20220525100604.760576-1-zhiquan1.li@intel.com>
 <f239a63d32cb8b3d8d6730dac940a51e92831828.camel@kernel.org>
In-Reply-To: <f239a63d32cb8b3d8d6730dac940a51e92831828.camel@kernel.org>
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
x-ms-office365-filtering-correlation-id: 7c38169b-ac7d-4aeb-2c53-08da44fe85c6
x-ms-traffictypediagnostic: CO1PR11MB4916:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CO1PR11MB4916FD41837A1B6E45D971DD99A19@CO1PR11MB4916.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cy+x4Ro6vyenHbprGgJbDSOncFUhoJN7HMXu/TuB+Vix6VrVUQPhMDAIQQ9L61fnit6z9UmWW5JB1zEUrGTDAjV2YfW61uy+AMEDXAh4pHDhFbrQLcVC4pJTzGzreg8tzj5Norc3J0hS8BgNUGbxF/BVD4JPthaxlB0jPWXfuVsE4hsHqMb8xgfuMi6Kwak+rdSSj87I+RBQby5AaPg2XOgEJVsK3hFctwfDohVEFz0AweBPoslK2p1WpB7/EIckprFFlI/9E9XefC6FAHjEFcHcrfNX8Y4SWiKldAiojMsEpZWfkIz12FpzWdlaGfdedAZrtzxji1h/E0aUWIajyg+3lOXugmfs5bc1OxF+0+THJf95ZiPiXxFJtBUaLMugHr3AHTOnpgmaGsCGoAQCztWuptkFlvY5+Ot2ismNtRjtG9BV47miGrfyftDrIlVzo8pg13Qrvh+Ojs92tovuL1h0qO0Kwf8NUj6/+tlkglP34K6vScrXvvrcqB6QaLxvhzS93duC5DYPZr3aNHbOsHJYfoi0tzVpCs/cDfRU4YzCft4oGYyE07c9MqpWJZUGfqqduumSCuazBmod1KIrsMx4dh8O3+JJu6uwO7Le3ApiQ+lCZZwvGSyDI8S00ad2F3PwwkxUsuTWOXBnvUAmJN0E9aT/iHMHv2Kf6lPjLxyqHhAec7sg3HvXwlzRw69cdRT2M9tQzup38ZZQKnZXEGzf6k0Bir91vox76/1bAnaAovWPCiSzUlRFayjKA0UNHaB71BzVMZkGFLjZ6y1Dpr1C2LFKOVNEVN9ZLpRwDB3pZkG/PYvLI5uaGLlK2XXhr8/gDo1jRCYWh30NKRe0WWWF3za4fIB+P7KREh6Oxmk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6181.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(2906002)(508600001)(52536014)(5660300002)(55016003)(8936002)(966005)(26005)(6636002)(66476007)(66946007)(66556008)(66446008)(64756008)(71200400001)(33656002)(7696005)(38100700002)(38070700005)(76116006)(122000001)(8676002)(186003)(84970400001)(4326008)(921005)(82960400001)(6506007)(9686003)(54906003)(86362001)(83380400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFhEWmVYa3ZxdmxnRFVGR1VCTThQRk9yZlNaa2kxYXhhaittMWhBNExtSkVS?=
 =?utf-8?B?d0IvOGd0U3NXQ2diTThpb21qM1BPRU9rc2dBMDUxd1c4RVh6TjcxanNmdWM4?=
 =?utf-8?B?MWx5Y0l1QzA5dENCUGswajdiL1AxR28xOVV1dzhmOHNWUFlVYkhrbFllMHZq?=
 =?utf-8?B?bXRhblNMSW5VYmY2YTBXU1BJUTU4UU5wK1hOaFhsejFzUmUyNWVoelNrY2Rh?=
 =?utf-8?B?R1I3WVRVdHZWcDRvNzdKZnkyeWgyRmsvK1phNGV3dE52WGh1ZHNiZ3BYSzE2?=
 =?utf-8?B?ZXZvWmE2dytrajd5czRaMWc4OFZWY1ROVGtwRm1aVGxWRzVBSjJRbjNIRXg0?=
 =?utf-8?B?ZzVjTWJvSUk0dld2LzJHMDQwU2orOEVGd01yTnVlMDJJNEc1ZVhZWmhYeXQy?=
 =?utf-8?B?NWFzcnZrU2R2ZW1ETTJaNnFDYnRINy8rMCtISGpRNzFuM1RWa0NCNExYQUFs?=
 =?utf-8?B?SzBzdmdaM1VuOGFvQ2h1Zy9HRlk0OFpMaWhFWmp0ZUpCWmEyeE5NVXdWQ2Vi?=
 =?utf-8?B?cG96Ty9IOEJOWWF1T1JqN2d6dTB1d1prM0VWNGpVRUxrcXluNGRQTGI5ZHhm?=
 =?utf-8?B?S0doY0xERjMreHk1ZXpzcDN1K2N3ZzFsMUZsQU5kRTZuSVBHODVTY1gxWjNH?=
 =?utf-8?B?SUxleFdGYitwS2crYXBIVjc4NCtOQzN6a1k2dFd2cUExRnJweTJKdkc4RjA5?=
 =?utf-8?B?cUJTM3RhOUVKN0trZklpSFg3L2locW1kMHhGb1kyTFJkdVFBMTMvRFdiRkVP?=
 =?utf-8?B?TmtuN1BnVHUxRUlIM1drOFRCRjV2NW9kVjF0ZVlITkZpVXdFVnA4dWJROXdE?=
 =?utf-8?B?QXpPRmhRSGRtM0cvKzR4QmNGUElVbngwWVF0NmE4YTBsdXRHTCs2aXQ5ZTQw?=
 =?utf-8?B?clJUSUxXUzZSL3gvb2V4ZnF1MktZTnNCeE54UEFnNm1Ja0pKQ2puQ0FaYWMv?=
 =?utf-8?B?d2I2Sk03b2VMSis5SUZYV293YTFndU03dlordEpoM0d4MkhoWVpRR0Fwa1Y0?=
 =?utf-8?B?SlNUVDF5ZDBFS2M0ZG82LzA5UFprT1M4ZDFybktsR2x6R1Z0cFRyOVlmb2JG?=
 =?utf-8?B?dFFsamt2VlpJaDRzUW55N0hYTzBnbzhZVW9zeVdLZmxWM0lPSi9kR1B2VmpY?=
 =?utf-8?B?TG1HeG0vVVppKy9SQ0hwZEthTWc1LzJPanRocy81eTRaRm40RXllWThiSlFp?=
 =?utf-8?B?NzBkdkJIY3ZXNWFXTkNsVzhpSENIRWZzVmpKSEtnY2dCTlk4cVVQcll4ZXFs?=
 =?utf-8?B?Z1RQYTBFenNraWVJaXV0RUt1SG9KcEdWeGhtTWgzclVTdmhNbHlEU05IYnUv?=
 =?utf-8?B?Z3dLYjdrS1pJQ3NCV1JLdGdKNFhVMGg2S2dsY3ZFY2RlbDB2aUphZ2xuS2VR?=
 =?utf-8?B?TnJ6SXhPemJVMTk5MVFsSGpQNjlTemhEaXlJOVhkWXgzQ082czhoZzlsTmh5?=
 =?utf-8?B?RTl4MmlTVitOMkZaeW8xWjNzcXB6M3hSRUJlSHBqS2ZpY204R1lobXQ5RGhr?=
 =?utf-8?B?RkYyK2swVG85M2xXa3VkdVZ3VUVQdEJKSUNWTThYbEhScFp3U0ZBbEhCbjdP?=
 =?utf-8?B?R3JNSVhJRkN1RklhdlVOZi9YcUtSRjRFVEhGQkxFM1dHL2J2aEYrbnhxeWJU?=
 =?utf-8?B?Z05FVG1JazZkMFByd1UyZmhtT1paWi9jQnRmK1hqbjB6cUUvWmFrY3NTaWZG?=
 =?utf-8?B?L0l6TzlyOXU4dWN4dytrd0srVnZtMy9SQ2hiYnhpd2dYSmU1V1o4cDdHNmVC?=
 =?utf-8?B?YVlBTnh5WjR5TnFnWFV6M2ZQdGdTMzRpckFmaUlTb2piRWF2ekw3akdjVFU3?=
 =?utf-8?B?MDAyNEYxcy9SNjdOZzl6VlVHNHh0blZ5WXRqUk5LZ2pXSEFUbXNpSFNVYlZO?=
 =?utf-8?B?RVBjcEZML3hnMDNsaFNIMi93YVFWQXJsSXdub2ZOTUh2SjBvQ2RVeDE0b0dZ?=
 =?utf-8?B?UjZWV0YzeGNLVDlkWFd5ZE9MVGNJb2hVN1VMQ203aDA0UkNVYjRsZG5Rektq?=
 =?utf-8?B?aDB4K1llTTdzZDgrUmRrUmxVRndGTk4wcjlBSXBoTWQ4U2JiUU1zaU9pdXRL?=
 =?utf-8?B?YVBIb2RUNUtZSTlURi9Vc25HR0U4ZUg4cmFZWkJhVDZxdlh2c0I3MURrS2dX?=
 =?utf-8?B?YnkzY2FqZXNNeVpaWm5YOGl6eFZJaThPa2RYWFZDaWtPUlJOVEtVaE8vQWJX?=
 =?utf-8?B?ckVCaU5rNWxlL1M2Mk5IczhVN3FRbnAyZDlFelJMUG10SjErYUtlL1ljQWw4?=
 =?utf-8?B?L3pFVnFsbVNMWjg2NUt6REg3VjA3ZXh0Q2Z0aFk5TzVTVm5xcWdsZDJEZUpJ?=
 =?utf-8?B?cXZVV0U5ZnZxTTU4dWdGbTU2Y3RiTkgyZWtwem9SNE15VVVrd1RDZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6181.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c38169b-ac7d-4aeb-2c53-08da44fe85c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2022 01:15:18.2929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u/2zJJlm2be2CibzfIS3RCLHElMu13GzWCtANnY++eA/a72yjJ9+7GQOojeoCkS/lm/0ptBux2BsKavUm+C08w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4916
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IEphcmtrbyBTYWtraW5lbiA8
amFya2tvQGtlcm5lbC5vcmc+DQo+U2VudDogVGh1cnNkYXksIE1heSAyNiwgMjAyMiA4OjM1IEFN
DQo+VG86IExpLCBaaGlxdWFuMSA8emhpcXVhbjEubGlAaW50ZWwuY29tPjsgbGludXgtc2d4QHZn
ZXIua2VybmVsLm9yZzsgTHVjaywNCj5Ub255IDx0b255Lmx1Y2tAaW50ZWwuY29tPg0KPkNjOiBk
YXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb207IENocmlzdG9waGVyc29uLCwgU2Vhbg0KPjxzZWFu
amNAZ29vZ2xlLmNvbT47IEh1YW5nLCBLYWkgPGthaS5odWFuZ0BpbnRlbC5jb20+OyBEdSwgRmFu
DQo+PGZhbi5kdUBpbnRlbC5jb20+DQo+U3ViamVjdDogUmU6IFtQQVRDSCB2MyAwLzNdIHg4Ni9z
Z3g6IGZpbmUgZ3JhaW5lZCBTR1ggTUNBIGJlaGF2aW9yDQo+DQo+T24gV2VkLCAyMDIyLTA1LTI1
IGF0IDE4OjA2ICswODAwLCBaaGlxdWFuIExpIHdyb3RlOg0KPj4gVjI6DQo+aHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgtc2d4LzY5NDIzNGQ3LTZhMGQtZTg1Zi1mMmY5LWU1MmI0YTYxZTFl
Y0BpbnQNCj5lbC5jb20vVC8jdA0KPj4NCj4+IENoYW5nZXMgc2luY2UgVjI6DQo+PiAtIFJlcHVy
cG9zZSB0aGUgb3duZXIgZmllbGQgYXMgdGhlIHZpcnR1YWwgYWRkcmVzcyBvZiB2aXJ0dWFsIEVQ
QyBwYWdlDQo+PiAtIFJlbW92ZSBzdHJ1Y3Qgc2d4X3ZlcGNfcGFnZSBhbmQgcmVsZXZhbnQgY29k
ZS4NCj4+IC0gUmVtb3ZlIHBhdGNoIDAxIGFzIHRoZSBjaGFuZ2VzIGFyZSBub3QgbmVjZXNzYXJ5
IGluIG5ldyBkZXNpZ24uDQo+PiAtIFJld29yayBwYXRjaCAwMiBzdWdnZXN0ZWQgYnkgSmFya2tv
Lg0KPj4gLSBBZGFwdCBwYXRjaCAwMyBhbmQgMDQgc2luY2Ugc3RydWN0IHNneF92ZXBjX3BhZ2Ug
d2FzIGRpc2NhcmRlZC4NCj4+IC0gUmVwbGFjZSBFUEMgcGFnZSBmbGFnIFNHWF9FUENfUEFHRV9J
U19WRVBDIHdpdGgNCj4+IMKgIFNHWF9FUENfUEFHRV9LVk1fR1VFU1QgYXMgdGhleSBhcmUgZHVw
bGljYXRlZC4NCj4+IMKgIExpbms6DQo+aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtc2d4
L2ViOTViMzJlY2YzZDQ0YTY5NTYxMGNmN2YyODE2Nzg1QGludGVsLmMNCj5vbS9ULyN1DQo+Pg0K
Pj4gVjE6DQo+aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtc2d4LzQ0M2NiNDI1LTAwOWMt
Mjc4NC01NmY0LTVlNzA3MTIyZGU3NkBpbnQNCj5lbC5jb20vVC8jdA0KPj4NCj4+IENoYW5nZXMg
c2luY2UgVjE6DQo+PiAtIFVwZGF0ZWQgY292ZXIgbGV0dGVyIGFuZCBjb21taXQgbWVzc2FnZXMs
IGFkZGVkIHZhbHVhYmxlDQo+PiDCoCBpbmZvcm1hdGlvbiBmcm9tIEphcmtrbywgVG9ueSBhbmQg
S2FpJ3MgY29tbWVudHMuDQo+PiAtIEFkZGVkIGRvY3VtZW50YXRpb25zIGZvciBzdHJ1Y3Qgc3Ry
dWN0IHNneF92ZXBjIGFuZA0KPj4gwqAgc3RydWN0IHNneF92ZXBjX3BhZ2UuDQo+Pg0KPj4gSGkg
ZXZlcnlvbmUsDQo+Pg0KPj4gVGhpcyBzZXJpZXMgY29udGFpbnMgYSBmZXcgcGF0Y2hlcyB0byBm
aW5lIGdyYWluZWQgU0dYIE1DQSBiZWhhdmlvci4NCj4+DQo+PiBXaGVuIFZNIGd1ZXN0IGFjY2Vz
cyBhIFNHWCBFUEMgcGFnZSB3aXRoIG1lbW9yeSBmYWlsdXJlLCBjdXJyZW50DQo+PiBiZWhhdmlv
ciB3aWxsIGtpbGwgdGhlIGd1ZXN0LCBleHBlY3RlZCBvbmx5IGtpbGwgdGhlIFNHWCBhcHBsaWNh
dGlvbg0KPj4gaW5zaWRlIGl0Lg0KPj4NCj4+IFRvIGZpeCBpdCB3ZSBzZW5kIFNJR0JVUyB3aXRo
IGNvZGUgQlVTX01DRUVSUl9BUiBhbmQgc29tZSBleHRyYQ0KPj4gaW5mb3JtYXRpb24gZm9yIGh5
cGVydmlzb3IgdG8gaW5qZWN0ICNNQyBpbmZvcm1hdGlvbiB0byBndWVzdCwgd2hpY2gNCj4+IGlz
IGhlbHBmdWwgaW4gU0dYIHZpcnR1YWxpemF0aW9uIGNhc2UuDQo+Pg0KPj4gVGhlIHJlc3Qgb2Yg
dGhpbmdzIGFyZSBndWVzdCBzaWRlLiBDdXJyZW50bHkgdGhlIGh5cGVydmlzb3IgbGlrZQ0KPj4g
UWVtdSBhbHJlYWR5IGhhcyBtYXR1cmUgZmFjaWxpdHkgdG8gY29udmVydCBIVkEgdG8gR1BBIGFu
ZCBpbmplY3QgI01DDQo+PiB0byB0aGUgZ3Vlc3QgT1MuDQo+Pg0KPj4gVGhlbiB3ZSBleHRlbmQg
dGhlIHNvbHV0aW9uIGZvciB0aGUgbm9ybWFsIFNHWCBjYXNlLCBzbyB0aGF0IHRoZSB0YXNrDQo+
PiBoYXMgb3Bwb3J0dW5pdHkgdG8gbWFrZSBmdXJ0aGVyIGRlY2lzaW9uIHdoaWxlIEVQQyBwYWdl
IGhhcyBtZW1vcnkNCj4+IGZhaWx1cmUuDQo+Pg0KPj4gSG93ZXZlciwgd2hlbiBhIHBhZ2UgdHJp
Z2dlcnMgYSBtYWNoaW5lIGNoZWNrLCBpdCBvbmx5IHJlcG9ydHMgdGhlIFBGTi4NCj4+IEJ1dCBp
biBvcmRlciB0byBpbmplY3QgI01DIGludG8gaHlwZXJ2aXNvciwgdGhlIHZpcnR1YWwgYWRkcmVz
cw0KPj4gaXMgcmVxdWlyZWQuIFRoZW4gcmVwdXJwb3NlIHRoZSAib3duZXIiIGZpZWxkIGFzIHRo
ZSB2aXJ0dWFsIGFkZHJlc3Mgb2YNCj4+IHRoZSB2aXJ0dWFsIEVQQyBwYWdlIHNvIHRoYXQgYXJj
aF9tZW1vcnlfZmFpbHVyZSgpIGNhbiBlYXNpbHkgcmV0cmlldmUNCj4+IGl0Lg0KPj4NCj4+IFRo
ZSBFUEMgcGFnZSBmbGFnIC0gU0dYX0VQQ19QQUdFX0tWTV9HVUVTVCB0byBpbnRlcnByZXQgdGhl
IG1lYW5pbmcNCj4+IG9mIHRoZSBmaWVsZC4NCj4+DQo+PiBTdXBwb3NlIGFuIGVuY2xhdmUgaXMg
c2hhcmVkIGJ5IG11bHRpcGxlIHByb2Nlc3Nlcywgd2hlbiBhbiBlbmNsYXZlDQo+PiBwYWdlIHRy
aWdnZXJzIGEgbWFjaGluZSBjaGVjaywgdGhlIGVuY2xhdmUgd2lsbCBiZSBkaXNhYmxlZCBzbyB0
aGF0DQo+PiBpdCBjb3VsZG4ndCBiZSBlbnRlcmVkIGFnYWluLiBLaWxsaW5nIG90aGVyIHByb2Nl
c3NlcyB3aXRoIHRoZSBzYW1lDQo+PiBlbmNsYXZlIG1hcHBlZCB3b3VsZCBwZXJoYXBzIGJlIG92
ZXJraWxsLCBidXQgdGhleSBhcmUgZ29pbmcgdG8gZmluZA0KPj4gdGhhdCB0aGUgZW5jbGF2ZSBp
cyAiZGVhZCIgbmV4dCB0aW1lIHRoZXkgdHJ5IHRvIHVzZSBpdC4gVGhhbmtzIGZvcg0KPj4gSmFy
a2tvJ3MgaGVhZCB1cCBhbmQgVG9ueSdzIGNsYXJpZmljYXRpb24gb24gdGhpcyBwb2ludC4NCj4+
DQo+PiBPdXIgaW50ZW5zaW9uIGlzIHRvIHByb3ZpZGUgYWRkaXRpb25hbCBpbmZvIHNvIHRoYXQg
dGhlIGFwcGxpY2F0aW9uIGhhcw0KPj4gbW9yZSBjaG9pY2VzLiBDdXJyZW50IGJlaGF2aW9yIGxv
b2tzIGdlbnRseSwgYW5kIHdlIGRvbid0IHdhbnQgdG8NCj4+IGNoYW5nZSBpdC4NCj4+DQo+PiBJ
ZiB5b3UgZXhwZWN0IHRoZSBvdGhlciBwcm9jZXNzZXMgdG8gYmUgaW5mb3JtZWQgaW4gc3VjaCBj
YXNlLCB0aGVuDQo+PiB5b3UncmUgbG9va2luZyBmb3IgYW4gTUNBICJlYXJseSBraWxsIiBmZWF0
dXJlIHdoaWNoIHdvcnRoIGFub3RoZXINCj4+IHBhdGNoIHNldCB0byBpbXBsZW1lbnQgaXQuDQo+
Pg0KPj4gVW5saWtlIGhvc3QgZW5jbGF2ZXMsIHZpcnR1YWwgRVBDIGluc3RhbmNlIGNhbm5vdCBi
ZSBzaGFyZWQgYnkgbXVsdGlwbGUNCj4+IFZNcy4gSXQgaXMgYmVjYXVzZSBob3cgZW5jbGF2ZXMg
YXJlIGNyZWF0ZWQgaXMgdG90YWxseSB1cCB0byB0aGUgZ3Vlc3QuDQo+PiBTaGFyaW5nIHZpcnR1
YWwgRVBDIGluc3RhbmNlIHdpbGwgYmUgdmVyeSBsaWtlbHkgdG8gdW5leHBlY3RlZGx5IGJyZWFr
DQo+PiBlbmNsYXZlcyBpbiBhbGwgVk1zLg0KPj4NCj4+IFNHWCB2aXJ0dWFsIEVQQyBkcml2ZXIg
ZG9lc24ndCBleHBsaWNpdGx5IHByZXZlbnQgdmlydHVhbCBFUEMgaW5zdGFuY2UNCj4+IGJlaW5n
IHNoYXJlZCBieSBtdWx0aXBsZSBWTXMgdmlhIGZvcmsoKS4gSG93ZXZlciBLVk0gZG9lc24ndCBz
dXBwb3J0DQo+PiBydW5uaW5nIGEgVk0gYWNyb3NzIG11bHRpcGxlIG1tIHN0cnVjdHVyZXMsIGFu
ZCB0aGUgZGUgZmFjdG8gdXNlcnNwYWNlDQo+PiBoeXBlcnZpc29yIChRZW11KSBkb2Vzbid0IHVz
ZSBmb3JrKCkgdG8gY3JlYXRlIGEgbmV3IFZNLCBzbyBpbiBwcmFjdGljZQ0KPj4gdGhpcyBzaG91
bGQgbm90IGhhcHBlbi4NCj4+DQo+PiBUaGlzIHNlcmllcyBpcyBiYXNlZCBvbiB0aXAveDg2L3Nn
eCB3aXRoIHRoZSBmb2xsb3dpbmcgYWRkaXRpb25hbGx5DQo+PiBhcHBsaWVkOg0KPj4NCj4+ICJ4
ODYvc2d4OiBLZWVwIHJlY29yZCBmb3IgU0dYIFZBIGFuZCBHdWVzdCBwYWdlIHR5cGUiDQo+Pg0K
Pmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXNneC9lYjk1YjMyZWNmM2Q0NGE2OTU2MTBj
ZjdmMjgxNjc4NUBpbnRlbC5jDQo+b20vVC8jbWJkMmNhNjE5ODNmMWY5NTE0YThiYWYwN2ZkYjE3
ZDMzNDk1ZWVhZGENCj4+DQo+PiBUZXN0czoNCj4+IDEuIE1DRSBpbmplY3Rpb24gdGVzdCBmb3Ig
U0dYIGluIFZNLg0KPj4gwqDCoCBBcyB3ZSBleHBlY3RlZCwgdGhlIGFwcGxpY2F0aW9uIHdhcyBr
aWxsZWQgYW5kIFZNIHdhcyBhbGl2ZS4NCj4+IDIuIE1DRSBpbmplY3Rpb24gdGVzdCBmb3IgU0dY
IG9uIGhvc3QuDQo+PiDCoMKgIEFzIHdlIGV4cGVjdGVkLCB0aGUgYXBwbGljYXRpb24gcmVjZWl2
ZWQgU0lHQlVTIHdpdGggZXh0cmEgaW5mby4NCj4+IDMuIEtlcm5lbCBzZWxmdGVzdC9zZ3g6IFBB
U1MNCj4+IDQuIEludGVybmFsIFNHWCBzdHJlc3MgdGVzdDogUEFTUw0KPj4gNS4ga21lbWxlYWsg
dGVzdDogTm8gbWVtb3J5IGxlYWthZ2UgZGV0ZWN0ZWQuDQo+Pg0KPj4gTXVjaCBhcHByZWNpYXRl
IHlvdXIgZmVlZGJhY2suDQo+Pg0KPj4gQmVzdCBSZWdhcmRzLA0KPj4gWmhpcXVhbg0KPj4NCj4+
IFpoaXF1YW4gTGkgKDMpOg0KPj4gwqAgeDg2L3NneDogUmVwdXJwb3NlIHRoZSBvd25lciBmaWVs
ZCBhcyB0aGUgdmlydHVhbCBhZGRyZXNzIG9mIHZpcnR1YWwNCj4+IMKgwqDCoCBFUEMgcGFnZQ0K
Pj4gwqAgeDg2L3NneDogRmluZSBncmFpbmVkIFNHWCBNQ0EgYmVoYXZpb3IgZm9yIHZpcnR1YWxp
emF0aW9uDQo+PiDCoCB4ODYvc2d4OiBGaW5lIGdyYWluZWQgU0dYIE1DQSBiZWhhdmlvciBmb3Ig
bm9ybWFsIGNhc2UNCj4+DQo+PiDCoGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYyB8IDI3
ICsrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPj4gwqBhcmNoL3g4Ni9rZXJuZWwvY3B1L3Nn
eC9zZ3guaMKgIHzCoCAyICsrDQo+PiDCoGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3ZpcnQuYyB8
wqAgNCArKystDQo+PiDCoDMgZmlsZXMgY2hhbmdlZCwgMzAgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkNCj4+DQo+DQo+VGhpcyBhcHBsaWVzIG9uIHRvcCBvZiBDYXRoeSdzIHNlcmllcywg
cmlnaHQ/IFdoeSBub3Qgc2VuZCBvbmUNCj5zZXJpZXMgd2l0aCBhbGwgMTIgcGF0Y2hlcyBpbmNs
dWRlZD8NCj4NCj5JdCBtYWtlcyByZXZpZXdpbmcgZWFzaWVyLCBhbmQgd2UgYXJlIHdlbGwgYmV5
b25kIDUuMTkgdGltZWxpbmUNCj5mb3IgdGhlc2UgZmVhdHVyZXMuDQoNClBhdGNoZXMgZnJvbSBa
aGlxdWFuIHRyeSB0byBpbXByb3ZlIFNHWCBNQ0EgaGFuZGxpbmcsIGFjdHVhbGx5IHRoaXMgaXMg
YSBCVUcgYmVpbmcNCmRpc2N1c3NlZCB3aXRoIGN1c3RvbWVyIHdpdGggU0dYIGRlcGxveW1lbnQg
YWxyZWFkeSAtIFNHWCBWTSBpbnN0YW5jZSBnb3Qga2lsbGVkDQppbiBjYXNlIG9mIFNHWCBhcHBs
aWNhdGlvbiBpbnNpZGUgVk0gY29uc3VtZWQgcG9pc29uIEVQQyBwYWdlcy4gRXhwZWN0ZWQgYmVo
YXZpb3I6DQpTR1ggYXBwbGljYXRpb24gZ2V0IGtpbGxlZCBvbmx5IGluIHN1Y2ggc2NlbmFyaW8u
DQoNClNlYW1sZXNzIHBhdGNoc2V0IGZyb20gQ2F0Y2h5IGlzIGFub3RoZXIgc3RhbmRhbG9uZSBm
ZWF0dXJlLCB0aGUgZGVzaWduIHNlZW1zDQpzdGlsbCB1bmRlciBkaXNjdXNzaW9uLiBDb21iaW5p
bmcgdGhvc2UgdHdvIGRpc3RpbmN0IHB1cnBvc2UtYnVpbHQgcGF0Y2hzZXQgdG9nZXRoZXIgDQps
b29rcyB3aXJlZC4NCg0KWmhpcXVhbidzIHBhdGNoc2V0IGludHJvZHVjZWQgdGhlIFNHWF9FUENf
UEFHRV9JU19WRVBDIFsxXSBtYWNybyB0byBtYXJrIGd1ZXN0DQpFUEMgcGFnZSwgbHVja2lseSBD
YXRoeSdzIHBhdGNoc2V0IGFsc28gaGFzIGEgcHJpb3IgYnVpbHQgbWFjcm8gU0dYX0VQQ19QQUdF
X0tWTV9HVUVTVA0Kd2l0aCBzYW1lIHNlbWFudGljcyBhcyBhIHNpbXBsZSBzdGFuZGFsb25lIHBh
dGNoWzJdLg0KDQpGb3IgY29tcGxldGVuZXNzLCBob3cgYWJvdXQgaW5jb3Jwb3JhdGUgQ2F0aHkn
cyBwYXRjaFsyXShrZWVwIG9yaWdpbmFsIGF1dGhvcnNoaXApDQppbnRvIFpoaXF1YW4gdXAtY29t
aW5nIG5leHQgdmVyc2lvbigzIHBhdGNoIGZyb20gWmhpcXVhbiwgMSBwYXRjaCBmcm9tIENhdGh5
KT8JDQpPZmZsaW5lIHN5bmNlZCB3aXRoIENhdGh5LCBzaGUgaXMgcGVyc29uYWxseSBvay4gd2hp
bGUgbGV0J3Mgc2VlIHdoYXQgb3RoZXJzIHRoaW5rIGFib3V0IG9uDQpob3cgdG8gcHJpb3JpdGl6
ZSB0aG9zZSB0d28gdGhpbmdzIC0gYnVnZml4IGFuZCBmZWF0dXJlIGVuaGFuY2VtZW50Lg0KDQpT
byAsIFRvbnksIERhdmUsIGFueSBzdWdnZXN0aW9uIGhlcmUgb24gaG93IHdlIGNvdWxkIG1vdmUg
b24/DQoNClRoYW5rcyENCg0KWzFdDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2pl
Y3QvaW50ZWwtc2d4L3BhdGNoLzIwMjIwNTE5MDMxMTM3LjI0NTc2Ny0xLXpoaXF1YW4xLmxpQGlu
dGVsLmNvbS8NCg0KWzJdOg0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L2lu
dGVsLXNneC9wYXRjaC8yMDIyMDUyMDEwMzkwNC4xMjE2LTQtY2F0aHkuemhhbmdAaW50ZWwuY29t
Lw0KDQo+QlIsIEphcmtrbw0K
