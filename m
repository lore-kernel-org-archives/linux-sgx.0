Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C15C6FD19
	for <linux-sgx@archiver.kernel.org>; Sun, 12 Mar 2023 22:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjCLWZ5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 12 Mar 2023 18:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCLWZz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 12 Mar 2023 18:25:55 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A07F2A159
        for <linux-sgx@vger.kernel.org>; Sun, 12 Mar 2023 15:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678659955; x=1710195955;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bmlBcXaUmfpA+XpPdAujNZOKn5H14ZXdbYNfuGfdq/Y=;
  b=idP9i76X583duShMJB0Bjo2KGzO399pqVfLJEV1HeBubzK0vVdObaQxk
   8q5VX8kVi2pwZhk7LpEr32I7KSmg5111NvpE3kG6yM49JePaFjwMtn1uZ
   bz0NOHA+aP0ywUGEhXL7NcbXm8TPkCDUsbDGbHThiXpDYWDRqETinZ9NU
   CntekOFRSxoukKfHo/6f1CcGX8aRltOFz6AtX3rKDXXxsOmYEBziTolVe
   YsN78bUObogFkxTGPTmbz1H0BxT+N72Bm6sUfyghiWbJseDmYq/VmCsq8
   lH1zs/4wP8IUaBJtmoY8GulPxBCkuZ+hKHL3ph1C/Bd12v1XXu/QvDp8j
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="423292700"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="423292700"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 15:25:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="821732308"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="821732308"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 12 Mar 2023 15:25:54 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 15:25:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 15:25:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 12 Mar 2023 15:25:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=id5XACHkiQYu6lCOn6RLG2dPUa7VfUc5IGrkydh4tuV4i+KSZqAdicEA5AhQP6ZXsAIRmLu0qnq1bGRCtZQwIo3Wj9aYeh1c4ssLByUPdCBGImisyq/NNy89T42dTdMY6gxrKEekxmLcRTryaNefgkuZcYhCG9PG4m3Qu5R6Y1tBCDQ/gtsvAnfF5eNxtacIqQiAEp5Iwd5BPkZ9vxyMdv2GTDCUwPmLdgMGAdPkYT0SGgPxy06fyiPyCxIZgeg2xhkNGi1xGLh+A9TZG7PQDE9zCXjj+USSS09LZHWjrBy1zSmADJ5xolNHRBkAf+DX+jAMBzJoETCysmiAZa3uYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmlBcXaUmfpA+XpPdAujNZOKn5H14ZXdbYNfuGfdq/Y=;
 b=eOY2aTLxpu+TrTmGjzENf6R4RO5bnu+TTZG0YNKFNdF4eVWdC1mQ+WaP0yAp0okXLs8/84azK6yThF1wAVuTDIsrM6CxDP8F8eUKEWtk0naXpIWRja8zKOLlkawYVkrPKsRTtqrqpRKDWnay+5pO7J0yUVBvOIr8Ja6m5jdIFXudotBFn9i4eyJFDbSZ3YJqlOpQapfYGsv3XG3QGgcCxfHyHn18j3J5YwyPTFlwkiuKabmR4d4NHG4D/J9bF/MUirPnMRs6eluaDryrvBx1U5qdLVevxIqF5hXGNlKYrlqmZt8w1J0mBgmEEfeaxrTbkkmXjpNF2WAIpwVWsFSyqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4961.namprd11.prod.outlook.com (2603:10b6:303:93::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Sun, 12 Mar
 2023 22:25:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 22:25:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAA5ciAIAACKGAgAY6gQCAADnpAIAV3bGAgAZo3ICAAWA2AA==
Date:   Sun, 12 Mar 2023 22:25:45 +0000
Message-ID: <d37990018617357537456c4554edf8c7f3fc71b0.camel@intel.com>
References: <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
         <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
         <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <Y/AAbC/j04aUkd8R@kernel.org>
         <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <Y/VBOkmi7VbVuzAh@kernel.org>
         <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
         <ZA0p4Kf8sLcGBAJb@kernel.org>
In-Reply-To: <ZA0p4Kf8sLcGBAJb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4961:EE_
x-ms-office365-filtering-correlation-id: 93d65575-adb6-47e3-7d26-08db2348b91f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4WulCgseOtZGTyKqWTT/P8/sEqA/+msTUSWkYhC9ztVTqq78KV99IpqejWD3JCkomFkDGxOXT6fL/knbYaNElvG7LlyXcLSOG3fIqqUcz6SeUFTFHFdW8T/A3y/aD6rKY2s2KrzxjsAQ7omk/SoC7HVsQUxDMZni9oTQ8CxdZhUKbCBGMA/w6yKOweRaNHWX0JHbebYbE/LFWlqVHyB4gw2iVA6m7BrWM+tzuZpZ5OczqZV9K5SSVnRCAhD2BJlyQa3trv8WpfD8oQ5rQsRtGL1kStX2Gjdn9IFb6oeSFJcCaLFZHACeABSKvlKIVusGfF7PQ7hFUOjpVIJA34xtvHmG5nZa+dVVCbtOAG7uXajTo3iz5c+yhP9RCcbjkF1hpEExIvDCcdbVM1u7fPWwL8ryqg86GxVgg2clp3cKO2KuJlv7nAnJnlr9lTtrVFpqsEaZEAC8lku/I6nYD+Y+YLSvRuEAwVzM+I4PYPXyEeshEaa3vayytFq1RD/xNm22LUs5rB8LJvXf4kAecUFnep8ISXeJ4ZyvPYOx87vmRXrdXyZ6zJmoat2kw3wfXGx1KQERv3tvl1xIkmGJDEuGtvXitfcrRoWSZbfVYTflDv+3sZrbXPTa8hLSN3nWs2wmlaourBIsYjTvuA03BKkHtyjHyrc3kYPLK26InJZbggUzkhY2daPMjzkkHz0/jNW89pwJJDR5anc9YEU2FNq2EQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199018)(38070700005)(2906002)(66446008)(5660300002)(26005)(8936002)(36756003)(8676002)(4326008)(66556008)(6916009)(76116006)(66476007)(41300700001)(86362001)(91956017)(316002)(54906003)(71200400001)(478600001)(66946007)(6486002)(38100700002)(82960400001)(6512007)(122000001)(64756008)(6506007)(2616005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXVsODUrMUZESzdQY2xZalZ4RDJlOCsydmJDTi9FQXFuY1ZEdHJ1TldHd01x?=
 =?utf-8?B?T1dXRnVDcHBYVnE5MmlpRVliQjhGdG1IbW9TMVNmL3FMVkUwZFhzdFA0dEpX?=
 =?utf-8?B?ZlVpYmtvZm4wWGUwaGVWWVNITlgyZXkzNmJxeGdWRXJHaklnUmpRbU1wcGVG?=
 =?utf-8?B?elFiVmpoQXJ6RUZJeU9UbVpmdG5JYld3SzQrR05VYlhZSFRVZ0FGWVZyTkh4?=
 =?utf-8?B?czgxaWsvdnJUOW5KeGh5NkJaZFhJZVZIOUJ3dFZMNUlXSFZsd20vWUErbHdN?=
 =?utf-8?B?NW1KdXg4TVFyb1BqQ1BMK0p5THJ2N05YRWV5by8wNXJGMmJCRjEyV3BPZUxa?=
 =?utf-8?B?ck9HQkQ1N0c2Wk92QVpiYXBCbEMwTkVHbnBtbkR6NUdRaDhDb0hqTkQ2bnV4?=
 =?utf-8?B?SEhPa05HTjdCS29xdnZXdDdRbndWZGlFeXFxeEJ2RUxIZEJZOWduQVJQclZr?=
 =?utf-8?B?cUEwMC94OXZwYVV5MjlUa3VvUkdpME5yalovWnJKRS9QeWNCdkc1bDlRRlpQ?=
 =?utf-8?B?akxMTlloc2hVcWQ2bkJoZkI3UzVXU05BVFVyUHZibzVwT0VxU0NGbkFWZDJC?=
 =?utf-8?B?eHpGSWN5NW9CbFJCRys0Ykd1ZHNsM044aTdVeGd5MmV0dVR6cjhuQkRnSUFU?=
 =?utf-8?B?UEVpNUc3MnFNWWFDVzQ5NVM0N0NOK2JpRDJjdnlpejhlemNKNTcrSkhWb2Fa?=
 =?utf-8?B?ZG94aElLekwyZ0xqQ3A1OTd1YUlsTDVzei9QdmJNWWZxM0grcUxiWHQxaDZU?=
 =?utf-8?B?bE1nMDlOcnlQalpOYUtuRWQ4eTlnaEdSblBxanZENko3ZFdzdU45Nm45YmE5?=
 =?utf-8?B?a3JrU3Q1RUlJaW1PZnVScUluWmF2TWhwVGRUbnd2SWJWdnR2YXM2S0xEcWZM?=
 =?utf-8?B?dFR6RUtYd3J4OVRoVWVRU2tJRVNuYURSSVlLVFcvdTRhSjlaUUQyZ2VxSEFa?=
 =?utf-8?B?R3hoSnR3dlVsdWUwNTB2dTF3citFYVZBUlh3SDh4cW8wSVZFNDM5V2tRSzMw?=
 =?utf-8?B?MVBRNVpueWJCdE5mMnFibFhtNjVlY1ZRTWFuaFlLTWZyLzd1b3UxNkRkbUhu?=
 =?utf-8?B?c0JIcVhTbmxsQ3prZDhCTGlYZHNqNWdQTXplS01yUlBNK1lEUE1kOWZyVHQ3?=
 =?utf-8?B?R2NHKzRXbFIrUWJjV0kzaUhYb1VtSjYwWWc5RGdKNlNUYW5qNmtXKzRhSXBa?=
 =?utf-8?B?Z0h1OHRKUnRONkREMllUTXBEU2g0NUtwVEFUNGRFdUZVcjNKTW1hSlo0YmRm?=
 =?utf-8?B?UVJLSy9oSysrRjkzbGp1NTlneXF6dFBuQ1QyS1grZkY4MFE4cGNPVWJDL2o4?=
 =?utf-8?B?VWowNzR2YzZ1b3BXYVVKOU8wc0lwOGM2c292Z3NnQ08xRzVaSVhuVjAyeUY1?=
 =?utf-8?B?ekw4MkJrdUxUYytOL1ZYeVBYeGVtRUFWY05tREl2UDJyMzJ4cnE3bXVpYWo3?=
 =?utf-8?B?ZUFoZkxMa0dtajVmTVVqbmhWT3NCTEFRQUkxWG0vcWVZcmxKTklRaEZzSFFk?=
 =?utf-8?B?OFJpTmNwUmovU240WEQ2ZUxqNUszOENQWndIMmJBTmVQSFpFdVlwYkR1ejla?=
 =?utf-8?B?UllnZXBJR0diZjMrVHVnanNyc0RNSi9PdElBc1JWbnB2blFweWMxOEFTUXMy?=
 =?utf-8?B?bmI0NUpUek85ZXhEemI3VXFiZ2Y2Ymh5elFCVTVzemM4UklIUU1qcUFyV1M2?=
 =?utf-8?B?REUxb0IyUVJGaUNSQVpDOWRLTW5jSGJHN3VKUmNvUlNGY3pRcXRRTVhlZHhC?=
 =?utf-8?B?MVRUZXlsSHVYaTNKZlRROGlKUDNWR1NtN3ZxK29QNFhRa1k4TWpZL0t3S2Rh?=
 =?utf-8?B?czZ2VXdKUGNreVd1T2RwYms5RXRiSWdFam1iOGpwUHNURnkzeW10amVQTFhF?=
 =?utf-8?B?dEJPNjNKM2U3U0dnRHo4c2dleUtyRkViQ0FFaWsrNHNBRExTckZRSWNyWnJJ?=
 =?utf-8?B?OXZVRTFKRW5tclp0azR2ZmxTRmUwTjMzRlpvdWpmOU5JUDZsVm41SnE1Vnlz?=
 =?utf-8?B?V1YrVndYUjZtUFc3TDBNUWdQWklDSHZFdVo5VTQxLzRYMVBqSHN5TitpRkpk?=
 =?utf-8?B?WllVMGNERFFqNVMzRGZreFlMVmgvdkZlNHJrQkFaL3dXZWNsQ2wvUVNRallP?=
 =?utf-8?B?OGluR3Z5SjVWeTFpQTNXNFJBenRXcFBSWkN6YmovbUtnYWR5V3hUTnJsMEZs?=
 =?utf-8?B?OWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D8DC9C36B2FE54FB9F8D2CA13D790D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d65575-adb6-47e3-7d26-08db2348b91f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2023 22:25:45.3054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pOwZD7GG/F1XMJ5m2vFTrnOlQkp7OuI0IFtwsyRmbqamxywONRfn8WwSBqobF/tLK5GdMpfsKrBXeOSh2EHwBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4961
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gU3VuLCAyMDIzLTAzLTEyIGF0IDAzOjI1ICswMjAwLCBqYXJra29Aa2VybmVsLm9yZyB3cm90
ZToNCj4gT24gVHVlLCBNYXIgMDcsIDIwMjMgYXQgMTE6MzI6MTVQTSArMDAwMCwgSHVhbmcsIEth
aSB3cm90ZToNCj4gPiBBbmQgaW4gZm9sbG93aW5nIG1tYXAoKXMgaW4gd2hpY2ggd2Ugd2FudCB0
byBtYXAgYSBzbWFsbCByYW5nZSBvZiBlbmNsYXZlOg0KPiA+IA0KPiA+IAllbmNsX2FkZHIgPSBt
bWFwKGVuY2xfYWRkciwgTUFQX1NIQVJFRHxNQVBfRklYRUQsIGVuY2xfZmQsDQo+ID4gCQkJKGVu
Y2xfYWRkciAtIGVuY2xfYmFzZSkgPj4gUEFHRV9TSElGVCk7DQo+ID4gDQo+ID4gPw0KPiA+IA0K
PiA+IEFueXRoaW5nIHdyb25nIGFib3ZlPw0KPiANCj4gSSdtIG5vdCBzdXJlIEkgZnVsbHkgY29t
cHJlaGVuZGVkIHlvdXIgcmVzcG9uc2UgYmVjYXVzZSBpdCB3YXMNCj4gaG9uZXN0bHkgYSBiaXQg
c2NhdHRlcmVkIHNvIHBsZWFzZSBjb3JyZWN0IG1lIGlmIEknbSBtaXNzaW5nDQo+IHNvbWV0aGlu
ZyBidXQ6IHdoeSBhIHByb2Nlc3Mgd291bGQgd2FudCB0byBtYXAgYSBzbWFsbCByYW5nZQ0KPiBv
ZiBhbiBlbmNsYXZlPw0KDQpGb3IgU0dYMiwgaWYgbW1hcChNQVBfQU5PTllNT1VTKSB3YXMgdXNl
ZCB0byBnZXQgdGhlIGVuY2xhdmUgYmFzZSBhZGRyZXNzIGJlZm9yZQ0KRUNSRUFURSwgeW91IHdp
bGwgbmVlZCB0byBtbWFwKGVuY2xfZmQpIGZvciBhbnkgcmVnaW9ucyB0aGF0IGFyZSBub3QgcHJl
LQ0KcG9wdWxhdGVkICh2aWEgRUFERCksIG5vIG1hdHRlciB3aGV0aGVyIHRoZSBmaXJzdCBtbWFw
KE1BUF9BTk9OWU1PVVMpIGhhcw0KY292ZXJlZCBhbGwgZW5jbGF2ZSByYW5nZSBvciBub3QuICBP
dGhlcndpc2UsIHRoZSBmYXVsdCB0byBTR1gyIHJlZ2lvbnMgd29uJ3QgYmUNCmhhbmRsZWQgYnkg
U0dYIGRyaXZlci4NCg0KWW91IGNhbiBmaW5kIHN1Y2ggbW1hcCgpIGluIHBhdGNoIDQgaW4gdGhp
cyBzZXJpZXMgdG9vLg0KDQpBbHNvLCBhcmNoaXRlY3R1cmFsbHksIGZvciBTR1gyIHRoZSBmaXJz
dCBtbWFwKCkgKGJlZm9yZSBFQ1JFQVRFKSBkb2Vzbid0IGhhdmUNCnRvIG1hcCB0aGUgZW50aXJl
IGVuY2xhdmUgcmFuZ2UuICBGb3IgU0dYMiBpdCdzIGZpbmUgdG8gcGFzcyBhIGxhcmdlciBlbmNs
YXZlDQpyYW5nZSBpbiBpb2N0bChFQ1JFQVRFKSB0aGFuIHRoZSByYW5nZSBnb3QgZnJvbSB0aGUg
Zmlyc3QgbW1hcCgpLiAgVXNlcnNwYWNlIGNhbg0KbGF0ZXIgb24gY2hvb3NlIHRvIG9ubHkgbW1h
cCgpIHRoZSBkeW5hbWljIHJhbmdlcyB0aGF0IGl0IHdhbnRzIHRvIHVzZS4NCg0K
