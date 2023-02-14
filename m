Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BBDC05027
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Feb 2023 09:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbjBNJsL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Feb 2023 04:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjBNJrf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Feb 2023 04:47:35 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08686D50A
        for <linux-sgx@vger.kernel.org>; Tue, 14 Feb 2023 01:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676368050; x=1707904050;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=JbpbXAYyxDtrKWU414tOdyDTBz1x49K5dV6cMzDVMRY=;
  b=C3q/6vliaTx/GXuIKbRumFzbH5Db+kj1zvp4cYc8iXWLIblnva7bjfou
   nFQ84NNJR8PItBEK0MkVzS8HmZg6IOsDm9ne4oOkPmx1JdnIwwd456aJm
   nOtU3qwxm8wgASpCQyUj45B5bpXAEvXoSBBZcBBmmk1TgeeJ3CGQo6HsO
   OshLQA3pyJjAsNf+9lfpokkcq4OXiBc2fGG6M0GKWvTJKRQ5KmJOnYkFa
   OmeYYwlRiXdjs8X6MQ3rublFQJZMMht/yT05ZCcc4Hg7uF0C5EH7E5NJF
   GO/amoGHJzfF7XOJWcXGp4hiD4Kyu2tWw+RNmFXc6lMVLlogvdaYzchw4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="358535186"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="358535186"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 01:47:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="737837369"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="737837369"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 14 Feb 2023 01:47:29 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 01:47:28 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 01:47:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 01:47:27 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 01:47:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDunUQU6KRkBWorykdyogB+xc7pEKCRdYmK58L19IY0nLHs1Vft2dPmeOlzGmMeeDFT4dHXiDhAv0jARa7cnb4LPFLwu7pzvTU8ftD1X/ICia+6SmiNDa9SNWqjrfdjS9azSFaJLq7nHdiraVHYYB+v0aelEHGlohJOKC68HbPZ648iPXhHsSjk1zc0ufjBOq5GTS+aiw+PA2s4YJXFUtwSjjUsR7wHmuOkEcPnHd+WOpm0/DbGR/94yhfFQjvivygfC/qTY7IwyO5S4N/0GU+DoPWGDTRbtJHCFxmyRuSp0JH55+61T39gpXg8WlnpOw98cJ02jib5T6R8hYrMihw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbpbXAYyxDtrKWU414tOdyDTBz1x49K5dV6cMzDVMRY=;
 b=jNSej7ZJL+2y4pF/ThBUuvQQs6aTagYmIO8w25cB60CJdjBj9qTJbHNtKmbgD+jdN04FK+j8snsyNt+HPc9OQw//Kfw7OfaR8jhVoAtoCqtfH5h9LDEkMS0qA6hGOuoM6LVTV8bas7sf/zgDND5DIccL3UuBhPXcbS+h7kfsSItkLCObV2c8/GJAZC7vzf3kps4VLEJCsKRsregEbTCz+MClnNFg/L1iS8Ckf8qjpYjcU84kqOnic7/eIUq9z1gMSzPgsWAVh3OSHwzEUbWKSPEj/DthhH1da7XgC1E+QS2Yw3Eb46vVOmWWWr8UmtbY90cTfuLSMya3Dz7bnRdyCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6617.namprd11.prod.outlook.com (2603:10b6:303:1ed::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 09:47:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 09:47:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIA
Date:   Tue, 14 Feb 2023 09:47:24 +0000
Message-ID: <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
         <20230128045529.15749-2-haitao.huang@linux.intel.com>
         <20230128045529.15749-3-haitao.huang@linux.intel.com>
In-Reply-To: <20230128045529.15749-3-haitao.huang@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6617:EE_
x-ms-office365-filtering-correlation-id: 2b2d7a3f-6050-4b30-012c-08db0e7079a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YBKXuEi2OOLqxAbcJQezFDyMCTuSy1P+D6sJkaA+gr7NIfWCQVX8bZOMUXRu2tIczi09M0CKnXOcx5uBLFChFfFsGXkSmEtlwd5n0JgcXddBPJ+ObfbxslW1r4csIXGuSbL2tyYrobqEWBLUECw3GIaSCmu8I4wDaMJMHYLZ4h2oZm/pugxOEkSpn5gHJQAjfL4XmoW3k/wiS4rKpNI1nAQHmZYbyh5/XSuKBzU1lMHdzlNEtsZOjSMlGitvFTfeWKXOH+G57JXer2DqO6+439Sy9pciyox+/kC+0/370oAb+1p7tE86n4WL0Li5UnWuv5HXcRFGjNjc+WRizD5rHrmiT9OuhwpcM6pB4cFc99eaCRbhF6plmaKnipW0zrkN/79Q56yiWFV/z3bxrk/LYEOMWnsuq6s/aE8m4EpbGbb5MiRLazwiu9dKj31ukG9jCTamRNPlfPwlDcU71QlGUG9cU6dK4IMIMe46XXru5G3UFo6tkEoxgo8Oc7iAbhziAwsXxyJQZOP/nrQ+AhDr0sJb0zZcDbc624CZEUvJfnlnVxUyXDeGWLA9tcMV2Fr5Ig2PnNoVHvvEvyYP/YUEW3A6P2YM1pDZqrewN+5nwGX7SdYtgYMnATWIGtee4ZdiGAjULaPlQCmVhs6hwULa3mO64dH8IGeGJxZbC1SWpqfsQoC+E87N6yd9SzFXEbZodOuCo18pz3ip+wTaEJJ0AA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199018)(86362001)(36756003)(110136005)(66946007)(316002)(8676002)(91956017)(76116006)(71200400001)(478600001)(2906002)(6486002)(41300700001)(64756008)(66446008)(5660300002)(8936002)(66476007)(66556008)(82960400001)(38100700002)(38070700005)(122000001)(2616005)(26005)(6506007)(6512007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NW1BK2dIa0xzUEhTR20rcjNabEp0Tm40Y29ZRjUrdXBCSXU4SDFvdnNNY0dZ?=
 =?utf-8?B?cHowc3BibUtGZDd0ZmdFdmliS2M1YktVMFhDelA3djEzOUlPWER6S3ZyV2pT?=
 =?utf-8?B?WVlCRXNWT0hpa2FlQmlyR1dpUkY2SjgzVVhSaU8rZHZUeWZ2cWx3dmZsMWdX?=
 =?utf-8?B?NTk2NU1uUGFSUnMzSjRsZGlvT3BCOHpMUmtTWGxVMzc3Wk80dXZPTE1XZ29W?=
 =?utf-8?B?OXZ6STE0REtJOVNOcXRuSVNsNFRNaklESlV0NFM5Y2JzWE5CZkdCNy9wL01P?=
 =?utf-8?B?azF6M3hWZlF6WExzM1I4K0g1WGVHZmsvSUFFc0JISmVrU3RTTjUxQU9OWCtG?=
 =?utf-8?B?ZmcvUE5zRkc0dFpvMmVpbm1Xd21wMy8zZDZKdk5BWVhuTHVHaU5zWHpzWTh4?=
 =?utf-8?B?QzNYYk9ma2gyL1RHbmtXN21xT2xQdjdIZk9QZFc5MHkrRy9mcTh3dlIrSFlG?=
 =?utf-8?B?dEYyNlJOMGNmR2YxbXZZNUMxZVArVFNKWWtBRHVDQVBNQ2ZnekpOSDZwOHNF?=
 =?utf-8?B?eFRFdHVvM1VrUDU0ZFRlTmxtNkVWOGhJM1g4MzROOCtaUFRrWitWQno4aEg0?=
 =?utf-8?B?SGluWU1Ra0tWVlRUeEg1eUdwcDl0bHFxL3BESkRQd1R6R1dOcFpuUkQvWDVW?=
 =?utf-8?B?aWRINTc3ZklaeXh5VEx5QXJDbTdvKzgzUHJjaEhCS21Wam1hNDRmRTk5WUZl?=
 =?utf-8?B?M0w3dXFDYXgwTjZVNi9ZYlJQUzZucm1lS1lXM2VzejhSaHVucllVNHZRMXZz?=
 =?utf-8?B?b0R2dDdDZytLU0pLRTAvbFFjUUIxUmoxazhoSVh6eS9QRVdQNEJISnk0ejJ5?=
 =?utf-8?B?bVYxL3pLSmJJbC9KTFplc3FTVDlsM2szRjQxcXFKL0FzSnhSd3JOc24waklI?=
 =?utf-8?B?czM0YnhwaXl2UnVZSEpDVmpwcWhMYWdUM3R6dVp4NHVFeTZyRGVsaGN3UDg0?=
 =?utf-8?B?RW1EMEEwdGxOTzJxSWh4VUFLQVFlQ3dBUDZCVUZGcXNVWVU3SlZ1UzgzWWc3?=
 =?utf-8?B?RW5mbjAvVFhOOTN1R2pRSVlzYnVFTklqbDhSRElKbE1jSFYzcGdvZ1MySkhr?=
 =?utf-8?B?Z2xXTk1CUGdzM2dBS1RFVHY5RlhQWnNEL1Rrak54d2l5ZFBzTVhCNkdtNGhj?=
 =?utf-8?B?c0F3dkVUNktiL2dRdGZYSXBsUUtxNWhCQVNtcUJSVHplLzc4SXorSUxxQzNu?=
 =?utf-8?B?OGMzaXRiaFpLUXlxeXllTnY5UjhJTFcra0UrYnhQanp1TFhNZzgvV1R4T0Ro?=
 =?utf-8?B?VGR4NHFDWWdBb2N3Sm1mN0hDRE5KY2prK1lGL09rbW1QSEdlcVkrZmJqUTJB?=
 =?utf-8?B?cEJFaVMxUzRWM0tlNWI0ZjRYRy96OWxudkExZUNqQ1pxMHFseDF6R3lzclA5?=
 =?utf-8?B?MkN1TG55UGU5a3F1YktCVFlyaWlOSnBUclZPQXJaa1lTak1Ec2ZreENBbkJq?=
 =?utf-8?B?SXhjOWM4TkpMMzlwTWZ6dWVmMFNzREJIQ2hzenFWNkcrZGorRzVxNWFReTMr?=
 =?utf-8?B?LzdLaXhSdUVPN3lrZUxkYkRnY3laVzJ1bmpCay93SUl1a3lxRTB1VzNFM0h1?=
 =?utf-8?B?eEVhVHA0ajJSckhPdVhpSEhCd1dVQ0lOd0lEdCtLRm1TREp0Nnl6N3NFSm11?=
 =?utf-8?B?WHNSN3FtaHVEd09yajN5SzY2M3BRcXcxTGVWenhRUWZPa1gzVEw5ZWM2em91?=
 =?utf-8?B?VFFpc0VkSEFTWklPV01Mdm1ZZjZ5Tlc2T08wMjBPWXRWYitkdGptaTl3YWlY?=
 =?utf-8?B?RkhRSWk1bHRyMTliT0Y1dGtlRmtUbzlReWtKYzk2Mzlkd2xSMzRSSktUVmUx?=
 =?utf-8?B?WjVXQkpmRkxDZEJWb01FV2UrVGtTd1pPVXVlY3B6ZEtpM0lna0YzcnZBKzRh?=
 =?utf-8?B?aktJZUlrcWJiWktFbnE4M25pVE02c0FPRjduRG85dkhFTW1sVzZvQ1VmUXRU?=
 =?utf-8?B?L2JDTW5lK0M5WmtkQXhnakhrTXExYWxWL25hdklobm1qRHVJZC9FRUlod1RL?=
 =?utf-8?B?VW40STl3dWt0SE1Ea2VaYkp5TTZEVVovREd1SkdESHc0OVU2YkpBeWpCSDVr?=
 =?utf-8?B?dUFHaGJDQUlFRVB5d1dNYXo0ODg0QlM2eFdpdFNuQ1VUMXZBeDlPN2JQVkdS?=
 =?utf-8?B?bEJFalV2bGJ3enhRVGM1c0kvWFJ0dXZ0SGc0bTRaekF1dDErTEZ0TlBtVnor?=
 =?utf-8?B?NkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E78FC3DBA2B4AE4EA567AE0A30C117A9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b2d7a3f-6050-4b30-012c-08db0e7079a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 09:47:24.2622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AUKZtiVDQS92qF9DXDL4V6Wwb0khOToAwG8bxwl/yshKFoCOczlCDMaeYVQy24LsKW0nvaWL3feGwFuI2s4Eyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6617
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTI3IGF0IDIwOjU1IC0wODAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+
IEBAIC05NywxMCArOTksODEgQEAgc3RhdGljIGludCBzZ3hfbW1hcChzdHJ1Y3QgZmlsZSAqZmls
ZSwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpDQo+IMKgCXZtYS0+dm1fb3BzID0gJnNneF92
bV9vcHM7DQo+IMKgCXZtYS0+dm1fZmxhZ3MgfD0gVk1fUEZOTUFQIHwgVk1fRE9OVEVYUEFORCB8
IFZNX0RPTlREVU1QIHwgVk1fSU87DQo+IMKgCXZtYS0+dm1fcHJpdmF0ZV9kYXRhID0gZW5jbDsN
Cj4gKwl2bWEtPnZtX3Bnb2ZmID0gUEZOX0RPV04odm1hLT52bV9zdGFydCAtIGVuY2wtPmJhc2Up
Ow0KPiDCoA0KPiDCoAlyZXR1cm4gMDsNCj4gwqB9DQoNClBlcmhhcHMgSSBhbSBtaXNzaW5nIHNv
bWV0aGluZywgYnV0IGFib3ZlIGNoYW5nZSBsb29rcyB3ZWlyZC4gwqANCg0KQ29uY2VwdHVhbGx5
LCBpdCBkb2Vzbid0L3Nob3VsZG4ndCBiZWxvbmcgdG8gdGhpcyBzZXJpZXMsIHdoaWNoIGVzc2Vu
dGlhbGx5DQpwcmVhbGxvY2F0ZXMgYW5kIGRvZXMgRUFVRyBFUEMgcGFnZXMgZm9yIGEgKG9yIHBh
cnQgb2YpIGdpdmVuIGVuY2xhdmUuICBUaGUgRUFVRw0KbG9naWMgc2hvdWxkIGFscmVhZHkgYmUg
d29ya2luZyBmb3IgdGhlIG5vcm1hbCBmYXVsdCBwYXRoLCB3aGljaCBtZWFucyB0aGUgY29kZQ0K
Y2hhbmdlIGFib3ZlIGVpdGhlcjogMSkgaGFzIGJlZW4gZG9uZSBhdCBvdGhlciBwbGFjZTsgMikg
aXNuJ3QgbmVlZGVkLg0KDQpJIGhhdmUga2luZGEgZm9yZ290dGVuIHRoZSB1c2Vyc3BhY2Ugc2Vx
dWVuY2UgdG8gY3JlYXRlIGFuIGVuY2xhdmUuICBJZiBJIHJlY2FsbA0KY29ycmVjdGx5LCB5b3Ug
ZG8gYmVsb3cgdG8gY3JlYXRlIGFuIGVuY2xhdmU6DQoNCgkxKcKgZW5jbF9mZCA9IG9wZW4oIi9k
ZXYvc2d4X2VuY2xhdmUiKTsNCgkyKSBlbmNsX2FkZHIgPSBtbWFwKGVuY2xfZmQsIGVuY2xfc2l6
ZSwgMCAvKiBwZ29mZiAqLyk7DQoJMykgSU9DVEwoRUNSRUFURSwgZW5jbF9hZGRyLCBlbmNsX3Np
emUpOw0KDQpXb3VsZCB0aGUgYWJvdmUgY29kZSBjaGFuZ2UgYnJlYWsgdGhlICJtbWFwKCkiIGlu
IGFib3ZlIHN0ZXAgMj8NCgkNCg==
