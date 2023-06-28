Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9ADEC001DE
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Jun 2023 09:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjF1Jvt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 28 Jun 2023 05:51:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:50236 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231626AbjF1Jje (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 28 Jun 2023 05:39:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687945174; x=1719481174;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GYhmhmpevQG9sh0OQXB4jmW3qs+2d0qJJgZ28tm0wMU=;
  b=TykTFFOdDO5uZpWLYXH7I3CdmZT6YSaJp9io9XW/QQ371IViTu/ndXGF
   J4yP1TVLA84YBEr10ae3vVkQ8lIqf9FVALVw8Tt31r6ILFWgASCwr5SPm
   441zStvRcuwg1C794SfeUvVpGQxptx9f3mUpf7cJwx1L2ndZr8+xbjkIj
   z30g5EHl1eGfRPtmB2opIypKYtnDxWaxUJV4I2RmnG0xRnX2ucVxk0Htb
   cY7jIP64P9N/ii6Y7RrZUs2+l+2L8TjuzDEVHPQeRUtxfIlSbWjI+mfR0
   qFv4cE+A3p4+RwPla5tpNuGmZEAeU3qJhmxRuBmyOtDMO+Zhza/tIznmj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="392521362"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="392521362"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 02:37:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="1047328960"
X-IronPort-AV: E=Sophos;i="6.01,165,1684825200"; 
   d="scan'208";a="1047328960"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jun 2023 02:37:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 02:37:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 02:37:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 02:37:10 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 02:37:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWcynFSxPSmPyyF+1XJy66klfSwvLDlMX+vf2cRbY4rtJbEDUDGesEsMgvJO7rIcjkkSvrGohlFgPI78Otu9PbKewcOhdFmO8L49Og4z/8CdjhSRWjwwnX8P1VyPGd63ojDf+/0f35x3Gtr/NLRSDQmfcZScNYsAS2ZJURFAVXGLAwcAJ3gob6pWcB5NITK8Y/zKxgwx/RyzkrKpmywI20SZc7PM/1WiwUtKiLm6AhPdJeBSFPkVQ4S/sMKl1XWaB1lMgQvHcvyMZstQ4/4+mQ3VrGYYobZpW18rt9PPicq0cCVtQczn0QjORbk/ZORlMGXWEHpZuqXCScg8BTF/PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYhmhmpevQG9sh0OQXB4jmW3qs+2d0qJJgZ28tm0wMU=;
 b=T6M7J9oo11nKDHmYgtYCQiXsYj5z5fpCAwNwcbcoV1t5sTOjxet2uO0+M2GNq/saPoxeYD+PozYqmyktNzJJZUb5MZiovzbGn6SzIqV8evuxSm5md1hBUuC12k7ZXYRiDtMt7FGpbp2a/KrJFowxbaJuOCOvyrW2PUzhJHQ9nLTS24cO3LcWd9BBBb3jyQURqTf8RRIVnRfT3tQexClys16duPyJUYUbcIomAFYC5GFVres5wZkBRTkDec1w9eQkyKEtRvyhKAz5ORZRaJbhj6QeJYGJ0KnRjDu4qgeVYonKjjmSXA10OMjqb0KfkHGKk0U1ZFaJuDYDfQZ3GoYdgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6512.namprd11.prod.outlook.com (2603:10b6:930:40::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 28 Jun
 2023 09:37:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 09:37:07 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAA5ciAIAACKGAgAY6gQCAADnpAIAV3bGAgAGoFwCAALMwAIB7cDIAgA/0eQCAD7ESgIABMj4AgAQB+wCABWrEAIAAFpKAgAY6eYCAAN3pAIAANG0AgAE6tgA=
Date:   Wed, 28 Jun 2023 09:37:07 +0000
Message-ID: <1a980d3ce2caec1cf44bf97d52fa08fbe72e741f.camel@intel.com>
References: <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
         <op.15kug6t9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
         <d0b65bbdd20a79a43d979b08972dd05bfc79b08c.camel@intel.com>
         <ZIzcrmU1RA7oEeQ7@google.com>
         <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
         <ZJTEpH2yYtHmTRWr@google.com>
         <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
         <ZJoRHU1CHxIuDH29@google.com>
         <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
         <ZJr3PthzDgugKDcO@google.com>
In-Reply-To: <ZJr3PthzDgugKDcO@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6512:EE_
x-ms-office365-filtering-correlation-id: f0a39832-3468-4655-0398-08db77bb3d60
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nL3TW6v+Mjbyyj3ln2FT/RoyTsspDTsyONhpGi/ZOTVACHSo9UJbAkPYblHE36gbPOph9Q8HkhMyV1ufUY013+p8+jjjAVmKQUm9mrIit2f9JLwM6C2NoNSciESQYG0ggNDdaSFhgIO5BY7tP9/C8LnluJj8R2j8OIgzjoolQX4VvfQVG2n+rAV6LIRKeOpfWCLaC79NDpIMww/6K2RJQ6Wv5VBGdiUeFmKQI0gusqGzoYYq/jJSp0ARhywfSdzvXv1fCoDjsnFwKqyQ+Pgep3jGpQ90DsJ2d+HNZ9WYFsNlHQpX+uaO+AmxPSdsJGr2W6Iqb/44Q82QyGTTm95n8B/8jYat8Pdborse4eT4ItJx07289nZaoiCzlZ6n6hqryPwTfhoKLkElViFieVL7eYuE7TT5IL60IoQTd4QcyDCZMJ3EX1ZeNrjtr8pvDDn0BcSwz+SRFpnhnfq1EfKviozhwI2ylU1+pBI+DVw6KQRg1vxEg8aybXv+I508dGMfWuF7ZZBZyyF2mDFFJV0EA0L1sv9nMuaWKFu0pcq5blkRRs7sZezrzh0v8PngYFbGq/NkIDru1SsuUnEMaG18/NCPBRaRKWhHBYyM0gIGo++kNKQqT6uj0eqbaN9i6qLy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199021)(54906003)(478600001)(6486002)(2616005)(38070700005)(82960400001)(86362001)(66446008)(66476007)(64756008)(66556008)(6506007)(71200400001)(26005)(186003)(2906002)(6512007)(66946007)(4326008)(36756003)(6916009)(8936002)(122000001)(41300700001)(76116006)(38100700002)(316002)(91956017)(8676002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGRRM1ROUnd3ZlUyQkkrYmhDdStiSG4vSE9hdzBZdEdKMTJrSzJBUnJTckFU?=
 =?utf-8?B?enFCeVlIN0hBaCsrd3dNb1BhVFA1aGs5VThtaEg3ckhFNnFSMHArZHpxWUJU?=
 =?utf-8?B?dC92SnV1aVp1bXpQOVd4WTVoKzNEb2VybE16K2grUE1YL0JZQmZBUU52QVU1?=
 =?utf-8?B?WXpIamQ1ZkhaWlZ5TS96STZTQ0FBdndCL0R6bmFDTU5MSVhpcmxHS1V1YVZ4?=
 =?utf-8?B?MkVTVStwY0R0WDFXWTRMTzZWK1BoN1MyRG1TSXNxRm1VVE4rZHBXUHc1dVJl?=
 =?utf-8?B?MUNoYlVoZVQzeEVnZWtmQ0ZMWDI1ZGs0K2FwWDUrdWhvRDFXU0haUUdrWjE5?=
 =?utf-8?B?SnJFM3puSXgxQ0s4dTdCZjNkVFB1d2xZWHdwTDVaeFovcit5aHhvT1k5SmVy?=
 =?utf-8?B?ZllCQ1UyeG9zWnhOdlpBRGN5RTdiSlBaNEFpWHBMUE83KzlXYlhKRmlSanVT?=
 =?utf-8?B?amFneUNuLzUzL0VNR0QrMlFlV09XQTg3bHIxYVpNWUV3R3F6QXR3K1huR0N0?=
 =?utf-8?B?WmpnUWRGVTE3bUpjakRBemFhK3Bwc0RpN1ZFRjkxMDd0NnhGQm9heFdmQU9z?=
 =?utf-8?B?SjdGK0V5Qm1iR25XUGloLy9QaXhvUkxoWTRUbDZjRHU5V3B2RGh3c0dFaDdV?=
 =?utf-8?B?bmVvalh1Y0hWZ0wzMWduYk5SRmJHaUZEYlp5VEwxM2hDcll0SFFjVGtKV3pJ?=
 =?utf-8?B?eTBObWlVOTdSazhJcE8rTHV4RnZKYmFmL21qd1F6SU03aUJzVXEzKzZGNWIr?=
 =?utf-8?B?S0dGTit3RU9hcThPR01MZTZKYkhydVVsUVA0L0xDcTBjS0JwOFFjMHk2Wjdt?=
 =?utf-8?B?UnYvQ0l5Y2gwZUdIalVna0ZnUnJXNERMZ01Wd1pvTktaeEc1UTUvZ2RWcGU1?=
 =?utf-8?B?cVVzK1ZvZnN6SVNSYVg3ejNQenRPZzFYSVZ4c1VEK0VWbG81ZXplNmlHTVBk?=
 =?utf-8?B?Q25iWEZFU2JJb2ltTENhQ0RCUTk4SXNsTFVkTUJSYjg3UjB6ZzZMK0x2TG9a?=
 =?utf-8?B?R3hMQlJIM01aalBCUVM3TkJUN2ttNUkvbDNEcG52LzgvaU1zUHE0ODFTdXpL?=
 =?utf-8?B?b0RrU2ZDcHBhMUp3RTNoVGZKT2xTdWJhQWhoQTJKZjlJcXdFbkI3S29ORXB6?=
 =?utf-8?B?UlYyQ1FBcTdXaHVaVHQwN3pCbURnYlVnQkV0K1dWaVdKckxFSlpEUzNJMm9p?=
 =?utf-8?B?TFBWaU1uTTNTREc5c20vbG95MDMrU1JvS3BCVFpYUkcrRnp2dHNaWm1kL1VV?=
 =?utf-8?B?djczaHNNRmpGRjF5ZkJIVE82QWNWSDFrdTJUTk00OUI4ZWIwNEhJbUFSc3pN?=
 =?utf-8?B?R3cxeVU3OEdKZklmNTI5OXFZN0Z2MmVONUNzQzg3Qk5tZXcySW1MQmlCTDdh?=
 =?utf-8?B?L2JPRU5JNmtBTjhOWlhaWUk4ZjRmM0cyaUZhYjNoUG5mTnkyT2lPaUFER3po?=
 =?utf-8?B?aXYvYTdOcTNJMWpsbHk0UjFzUk5VNHVRM3hYbHkrL1BZYnoxbHFhQ2FCYmhX?=
 =?utf-8?B?MGtmK3JoMitZSjlYZ1QvcE9FVCtRSnY0anptMXgvZWpDV0R1NldDY0VoeWcr?=
 =?utf-8?B?UUsycExJZTNJSHllTlJUVFQvQVlmTncvN3J6NEwwTDNabURyS0VXNlNiVzFN?=
 =?utf-8?B?Q1lzVEtScVlYTmpaNTZLTkd1Tm1OY2VKMzh2NXdaRnhhbVRJZGFoQkZ1M3RN?=
 =?utf-8?B?cVVSeGhaa0xrdENQRGhjbTBWck5jSlFqU0xRK3l3Nm9UM0JOcmdwOWZNTHpY?=
 =?utf-8?B?MFpIU291NGI1bkgydzQyNXk2K2VRQkNiY0lPU2RwRmJJVDA3cnR6bmY3eitU?=
 =?utf-8?B?TWM2T1M4alBRMjhGWENYQndnU203MUlRVEhBakM0eEM3ZW9haTlUSnZLMU5l?=
 =?utf-8?B?L1p0UEl1cnRwa1dUVTNTNUY3aU5xQWNxQk5SdlYxQm5wbTJDbjVqL1BnUm9G?=
 =?utf-8?B?Q0tkNkxJYUxhYkFlakpuSFlteHNmOFM0R1ZEd2lwTXBIeklsZ1U5aHh3MnBt?=
 =?utf-8?B?S2dMZGxEZEtNMDZMWmZhUm41REdwMWhlYUFtMFVXaTlIV092QytpdHBsMFg5?=
 =?utf-8?B?dWdKdWdqNHdGTytMbENqVW5zTHplT3hlTmhVOG00Vlo3TEJiZkRNQ3BqZnNE?=
 =?utf-8?B?QXBVSnZISXpFdjdkN09mdS9DZ3FEZEtvaktSZDdWZkJydGdBQkRRUlBtT1Ny?=
 =?utf-8?B?R2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35499654335E8B47B6CF19184B56352A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a39832-3468-4655-0398-08db77bb3d60
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 09:37:07.5047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iz4JqAkybn7n7gqNPhW0GHQTq+8W9tGYyXOXMq8u1YuvoS3LulmyyrzC3YsyG3U4h2v/VUbFuk+Kstw8qPrrpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6512
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTI3IGF0IDA3OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEp1biAyNywgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gPiA+
IA0KPiA+ID4gPiA+IFlvdSBjYW4ndCBidWlsZCBhbiBBQkkgb24gYXNzdW1wdGlvbnMuICBFLmcu
IGV2ZW4gaWYgdXNlcnNwYWNlICppbnRlbmRzKiB0byBiZWhhdmUsDQo+ID4gPiA+ID4gaXQgd291
bGRuJ3QgdGFrZSBtdWNoIHRvIGNvbXB1dGUgdGhlIHdyb25nIG9mZnNldCAobWF0aCBpcyBoYXJk
KS4NCj4gPiA+ID4gDQo+ID4gPiA+IEJ1dCBJIGRvbid0IHRoaW5rIHdlIGhhdmUgYW4gd2VsbCBl
c3RhYmxpc2hlZCBBQkkgbm93PyAgTm90aGluZyBpcyBkb2N1bWVudGVkLg0KPiA+ID4gDQo+ID4g
PiBIZWgsIGp1c3QgYmVjYXVzZSB0aGUgQUJJIGlzbid0IGZvcm1hbGx5IGRvY3VtZW50ZWQgZG9l
c24ndCBtZWFuIGl0IGRvZXNuJ3QgZXhpc3QuDQo+ID4gPiBJbiBmYWN0LCB0aGUgbW9zdCBwcm9i
bGVtYXRpYyBBQklzIGFyZSB0aGUgb25lcyB0aGF0IGFyZW4ndCBkb2N1bWVudGVkLg0KPiA+ID4g
DQo+ID4gPiA+IA0KPiA+IA0KPiA+IFN1cmUuICBCdXQganVzdCB3YW50IHRvIG1ha2Ugc3VyZSwg
d2hhdCBpcyB0aGUgY3VycmVudCBTR1ggZHJpdmVyIEFCSSAoYXJvdW5kDQo+ID4gbW1hcCgpKSBm
cm9tIHlvdXIgcGVyc3BlY3RpdmU/DQo+IA0KPiBUbyBiZSBjbGVhciwgaXQncyBub3QgbXkgcGVy
c3BlY3RpdmUsIGl0J3Mgc2ltcGx5IHdoYXQgdGhlIGtlcm5lbCBhY3R1YWxseSBkb2VzLg0KDQpT
dXJlLiAgSSB3YXMganVzdCB0cnlpbmcgdG8gaGVhciB5b3VyIHRob3VnaHRzIDopDQoNCj4gDQo+
ID4gSXMgaXQgIlNHWCBkcml2ZXIgX3JlcXVpcmVzXyBwZ29mZiB0byBiZSAwIGZvciBub24tRUxS
QU5HRS1yZXNlcnZlIG1tYXAoKSIsIG9yDQo+ID4gIlNHWCBkcml2ZXIgX2lnbm9yZXNfIHBnb2Zm
Ij8NCj4gDQo+IFVubGVzcyB0aGVyZSBhcmUgY2hlY2tzIGhpZGluZyBzb21ld2hlcmUsIGl0J3Mg
dGhlIGxhdHRlci4gIFlvdSBtaWdodCBiZSBhYmxlIHRvDQo+IGdldCBhd2F5IHdpdGggY2hhbmdp
bmcgdGhlIGtlcm5lbCB0byByZXF1aXJlIHBnb2ZmIHRvIGJlICcwJywgaS5lLiBpZiBsaXRlcmFs
bHkNCj4gYWxsIHVzZXJzIHBhc3MgaW4gJzAnLCBidXQgcHJvdmluZyB0aGF0IGFsbCB1c2VycyBw
YXNzICcwJyBpcyBleHRyZW1lbHkgZGlmZmljdWx0Lg0KPiBBbmQgSSBkb24ndCBzZWUgYW55IHZh
bHVlIGluIHJlcXVpcmluZyBwZ29mZiB0byBiZSAnMCcgZm9yICJsZWdhY3kiIHVzZXJzLg0KDQpJ
IGNlcnRhaW5seSBoYXRlIHRvIGVuZm9yY2Uga2VybmVsIHRvICJyZXF1aXJlIiAwIHBnb2ZmIGZy
b20gdXNlcnNwYWNlLiAgSSB3YW50DQp0byBnZXQgcmlkIG9mIGl0Lg0KDQpJIGJlbGlldmUgd2Ug
Ym90aCBhZ3JlZSAiU0dYIGRyaXZlciBfaWdub3Jlc18gcGdvZmYiIGlzIHRoZSBjdXJyZW50IEFC
SS4NCg0KWy4uLl0NCg0KPiANCj4gSSB0aGluayB5b3UncmUgZml4YXRlZCB0b28gbXVjaCBvbiBw
cmVjaXNlbHkgZGVmaW5pbmcgdGhlIGNvbmNlcHQgb2YgQUJJLiDCoA0KPiANCg0KUHJvYmFibHkg
OikNCg0KPiBUaGUNCj4gcXVlc3Rpb24gdGhhdCB5b3UgcmVhbGx5IHdhbnQgdG8gYXNrIGlzICJj
b3VsZCBjaGFuZ2UgWFlaIGJyZWFrIHVzZXJzcGFjZT8iDQoNCkFncmVlZC4NCg0KQnV0IHNpbmNl
ICJlbmNsLT5oYXNfbWlzbWF0Y2hlZF9vZmZzZXRzIiBpcyBzb3J0IG9mIG5ldyBBQkksIEkgdGhp
bmsgd2UgbmVlZCB0bw0KYmUgY2FyZWZ1bCBvdGhlcndpc2UgaW4gdGhlIGZ1dHVyZSB3ZSBtYXkg
aGl0IHRoaXMga2luZGEgbmFzdHkgaXNzdWUgYWdhaW4uDQoNCkhlcmUncyBteSB0aG91Z2h0czoN
Cg0KKEFnYWluLCBsZXQncyBmb3JnZXQgYWJvdXQgbW1hcCgvZGV2L3NneF9lbmNsYXZlKSB0byBy
ZXNlcnZlIEVMUkFOR0UgZm9yIG5vdy4pDQoNCjEpIEN1cnJlbnQgQUJJIGlzIFNHWCBkcml2ZXIg
X2lnbm9yZXNfIHBnb2ZmIGZvciBtbWFwKC9kZXYvc2d4X2VuY2xhdmUpcyAoYnV0DQpyZXF1aXJl
cyBNQVBfRklYRUQpLg0KDQoyKSBUaGVyZWZvcmUswqAicGFzc2luZyB0aGUgY29ycmVjdCBwZ29m
ZiIgaW4gbmV3IHVzZXJzcGFjZSBhcHAgZG9lc24ndCBicmVhayB0aGUNCmN1cnJlbnQgQUJJLiAg
SWYgdGhlIG5ldyBhcHAgY2hvb3NlcyB0byBwYXNzIHRoZSBjb3JyZWN0IHBnb2ZmLCBpdCB3aWxs
IHdvcmsuDQoNCjMpIFdpdGggYWRkaXRpb25hbCBzdXBwb3J0IG9mIHNneF9mYWR2aWNlKFdJTExO
RUVEKSB3aXRoaW4gdGhlIGRyaXZlciwgdGhlIG5ldw0KYXBwIGNhbiB1c2UgbWFkdmljZShXSUxM
TkVFRCkgaWYgaXQgcGFzc2VzIHRoZSBjb3JyZWN0IHBnb2ZmIHdoZW4gbW1hcCgpLiAgSWYNCndy
b25nIHBnb2ZmIGlzIHBhc3NlZCwgdGhlbiBtYWR2aWNlKFdJTExORUVEKSB3aWxsIHdvcmsgdW5l
eHBlY3RlZGx5IGFuZCBjb3VsZA0KcmVzdWx0IGluIGVuY2xhdmUgYmVpbmcga2lsbGVkLiAgSXQn
cyB1c2Vyc3BhY2UgYXBwJ3MgcmVzcG9uc2liaWxpdHkgdG8gbWFrZQ0Kc3VyZSB0aGUgY29ycmVj
dG5lc3MsIG5vdCB0aGUgZHJpdmVyJ3MuDQoNCjQpIE9sZCBTR1ggYXBwcyB3aGljaCBkb24ndCB1
c2UgZmlsZS1iYXNlZCBBQklzIGFuZCBzdGlsbCBwYXNzIDAgcGdvZmYgc2hvdWxkDQpjb250aW51
ZSB0byB3b3JrLiAgTm8gYnJlYWsgb2Ygb2xkIGFwcHMgZWl0aGVyLg0KDQo1KSBXZSBlbmNvdXJh
Z2UgbmV3IGFwcHMgdG8gYWx3YXlzIHBhc3MgdGhlIGNvcnJlY3QgcGdvZmYgaW5zdGVhZCBvZiBw
YXNzaW5nIDAuDQoNCjYpIElmIG5lZWRlZCwgd2UgY2FuIG1vZGlmeSBzZ3hfbW1hcCgpIHRvIHJl
bGF4IHRoZSBuZWVkaW5nIHRvIHVzZSBNQVBfRklYRUQsDQpidXQgcmV0dXJuIHRoZSBlbmNsYXZl
J3MgYWRkcmVzcyAiYmFzZWQgb24gcGdvZmYgZnJvbSB1c2Vyc3BhY2UiLiAgVGhpcw0KZWZmZWN0
aXZlbHkgcHJvdmlkZXMgYWRkaXRpb25hbCBtbWFwKCkgQUJJIGZvciB1c2Vyc3BhY2Ugd2hpbGUg
bm90IGJyZWFraW5nIHRoZQ0KZXhpc3RpbmcgTUFQX0ZJWEVEIEFCSS4NCg0KSW4gdGhpcyB3YXks
IHdlIGRvbid0IG5lZWQgYWRkaXRpb25hbCBtYW5pcHVsYXRpb24vZml4aW5nIHVwIG9mIFZNQSdz
IHBnb2ZmIGluDQp0aGUgZHJpdmVyLiAgVGhlcmUncyBubyBjaGFuZ2UgdG8gZXhpc3RpbmcgQUJJ
IGVpdGhlci4NCg0KWy4uLl0NCg0KDQo+IEJlY2F1c2UgU0dYIGhhcyB1c2VycyBpbiB0aGUgd2ls
ZCB0aGF0IGRvbid0IHNldCBwZ29mZiBjb3JyZWN0bHkuICBDaGFuZ2luZyB0aGUNCj4ga2VybmVs
IHRvIHJlcXVpcmUgYW4gYWNjdXJhdGUgcGdvZmYgd291bGQgYnJlYWsgdGhvc2UgdXNlcnMuDQoN
Ck9ubHkgcmVxdWlyZSBhbiBhY2N1cmF0ZSBwZ29mZiBpZiB1c2Vyc3BhY2Ugd2FudHMgdG8gdXNl
IGZpbGUtYmFzZWQgQUJJcyBmb3IgdGhlDQpyZWxldmFudCBWTUFzLiAgVGhlIG9sZCBhcHBzIHdo
aWNoIHBhc3MgMCBwZ29mZiBzaG91bGQganVzdCBjb250aW51ZSB0byB3b3JrLg0KDQo=
