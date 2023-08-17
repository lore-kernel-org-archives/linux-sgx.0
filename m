Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499D5EB64DD
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Aug 2023 10:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbjHQKBb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Aug 2023 06:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349291AbjHQKBH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 17 Aug 2023 06:01:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF85B2D61
        for <linux-sgx@vger.kernel.org>; Thu, 17 Aug 2023 03:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692266466; x=1723802466;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=466cA2bcElKOIntAcBrwy/xNPMccVpbHkwN+nWyJJJ4=;
  b=VF4s/k063+EHkFXvo/2a6vcBEXWBg8/uzuuIK1GnOmF0eYBrbYw0PuxC
   ojYqbKN9caoSVFEiHrH6nXRbQ2wuohgffg6wHYo26V81jmYWbvCgBRebT
   YemOYFYE4DfqTR2sJx7Vb2fLBA8nvYsjgD3mhdZx9o+8+vEgz2laB+Lqb
   wKFPBIZU35zk89g1UADrsB/kc9M87XHphSan/OT1/2FRIjfRwyKYZSZql
   eyDo6sSRhkw4TNG2J/u4/1styvgHBYOdKaVTHYu3FIEXAkaGqPVxWMUXt
   XoecqTE8q9DKydhI5HAZYqlzCW4BmAKRRqUSrFM6cfd2zdCInFLTAulLT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="403747577"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="403747577"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 03:01:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="804570956"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="804570956"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 17 Aug 2023 03:01:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 17 Aug 2023 03:01:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 17 Aug 2023 03:01:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 17 Aug 2023 03:01:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 17 Aug 2023 03:00:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTyymaPTMISshkwjDgzp59eGfi/44yEV5NzdCNeOUv4KqifDDqcgzZmnJxcHpy7GobgCBHOoaNJorZhzPqXFv67HWv0MLOdSg7d19/Lthz8Sg8drYqKz/24bs81+nEAn7KevpPdjEjsvm+R3X4YfpRe2u80OA77/8bijaVgB6dl/oZrpaFNG26Xbg1SCx8cXkkzelh5XBx/3m0ZZUXpMrmcexYsHSXHs1Uz9erw+bS45NOUcN4XkkK45V+rUZ1ZD8886ch++A4SA12UQz6hGIujmMokuv7DigCTppSrtfEbSrLuQmF20qA795wzLv4Nnf669NoiY77U/CCAXIxbKNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=466cA2bcElKOIntAcBrwy/xNPMccVpbHkwN+nWyJJJ4=;
 b=bC2HwMjOTb+vFMUFxWnIEaHxnVFFiWzMXQE/VgHqxU12OCH8bn6O8n0sU41W22HTCta+FC0vGnLS+WMUnQIRjB3BCWq+GI8UmMB+05A0Ji/xaTtlhp1v2vWISE9df1GDrve38g+uGa/+zUlLwlMwcJQ/MLML/wPZidQ6Gk0usvJQMWJO2QL+k4Muh6LRtESAdiWgRM+9r5R8tvfepLrZKjDTlbBeYOZdPEADY0NgRowtTXbyaYQmGAUpkfon3J9gWEtQ4vwW1FHCB91ihXjdjibP1wux34CN09RDrV0QQAMh5DesKzfIml9lvjEH+li5J8ZDOMOH26W7RIt4m+W4eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6690.namprd11.prod.outlook.com (2603:10b6:303:1e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.29; Thu, 17 Aug
 2023 10:00:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6678.029; Thu, 17 Aug 2023
 10:00:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jinpu.wang@ionos.com" <jinpu.wang@ionos.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "yu.zhang@ionos.com" <yu.zhang@ionos.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
Thread-Topic: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
Thread-Index: AQHZzmkroZaxadBVA0ehaaHZdR7fIa/qeaaAgAOlDQCAACfhAA==
Date:   Thu, 17 Aug 2023 10:00:52 +0000
Message-ID: <3061b0ccb3a61b856498ebfc27d400250fa550c6.camel@intel.com>
References: <20230814043714.107971-1-jinpu.wang@ionos.com>
         <3954697abb1a6c84c4b30fbd0d5edcafae6f6966.camel@intel.com>
         <CAMGffEk_ojyRsMy_7d1R0aacwNQ0itDV+ZYTDH0Fpoy03iPkTg@mail.gmail.com>
In-Reply-To: <CAMGffEk_ojyRsMy_7d1R0aacwNQ0itDV+ZYTDH0Fpoy03iPkTg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6690:EE_
x-ms-office365-filtering-correlation-id: 93fece26-99e9-4812-9a71-08db9f08d75b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 49MDm8qXF72/4hLQFs8UqINu5jGiicnXwjSJNmTTpLR0xMr7Hx18Xo1w0FDWY39H3YJCSAxXa80DZ3WTZw6LcxAF59EJ9ZsPdYPgdpzc6JH1QD/HwubaploNoqbby3Q5X4XfNgR8LN56n/rtXqLAIkHXBgDDRCOgDMiHbeLcWAUAILI450L/9YfsdoSoncGoNUeM423Uma/QgXlLAQKc5cyiSvp534Af7udA2hIVxmdMWM9O98ZTvjlybaWBw8SJiwyh4RAuezOBl9xQwsoXKO6SdDu+ht59bclrvuUGJX0jNBI1AvwrC3fftpniImiO6KsdCqebumELo4ygkP6XYTxfLJ6uezFudTYCMAPA6+oh6Br7lbb1RmWs7IqvBRm3+naSYydsXSAzZQvnqKl+yAn0Rv5LnY6/nOUzknHeYuNJoXxtK+rQPQLJfGkSpxefDGIvHXve2vPb3DqD+8BwcUt5MmCZTZ+PU3JpG6ZFLW1fp5FA3+Kltst+y8G/FX1/wDD3FY5XgdvdoDv77o7rjixF/Kw3ZXEkPtsdbaIs1LEguSq+z/Lbr9+g/c9ckS/NqTgwmf01ZlLAXNwLoNgrAfy+A3xW6p8td2gQTQVWBaHqHoqMcMiWk1cGcBkaOw26
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(396003)(346002)(186009)(1800799009)(451199024)(316002)(54906003)(66476007)(91956017)(66946007)(66556008)(64756008)(76116006)(6916009)(66446008)(122000001)(5660300002)(41300700001)(38100700002)(38070700005)(4326008)(8936002)(8676002)(82960400001)(26005)(2906002)(4744005)(83380400001)(478600001)(86362001)(6512007)(6506007)(36756003)(71200400001)(6486002)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWpRVXJRaXp6aGVZOFBERmRvN0hNN1c5UVJwUUJ1dEFNSGlaQzNVak8zQnJG?=
 =?utf-8?B?bldpbVVhZWNTY1B4Wkh1bGVsQWVveVNZK2x2ZEtSOVVVTyt4OUEwOElVNys1?=
 =?utf-8?B?OUlJR0MvdDZaRS85cEd0ZTRyNFZBL1pTU2x1MGlBSDhrczZBZ2JIUFVoWXJk?=
 =?utf-8?B?UE4vZ2hBc3ByaHpSRDhlMWdhaFFmV0tSY0toK0twbkYyYlZNY0ZnMFBmdFJS?=
 =?utf-8?B?OUV1QUFHN3NVUFpNTGJZYkhrR25VYk5DWmxxbDMweTR4ejkzM3pHb3BHQjBG?=
 =?utf-8?B?QzlacVk1dDFETjhPRjdTbms3TE9jMTd6d1B4UHNFc2tha0luaDVGVU1kUXBG?=
 =?utf-8?B?dStmWkkvcEhrQ0hlUUJOVzVaejhpSFlLRzVXNE5FYnJOZWhQeFd3SVk0TTZz?=
 =?utf-8?B?K0lIUEI1NUF4dy90STZJWDYwMEs5QnBZdUFsK1VOd1ZLMXlxc0UzSkVVamRQ?=
 =?utf-8?B?emxBbEtzbTExbjNHVG5aTUZZZzBaY2FqMlhxN3ZBZW9aVlQrOEpES3V1RE43?=
 =?utf-8?B?TTkwTW1GZ2NrN280VnRQWE9zaFFkNytYVHJ5NGdIcTJyeTg0NDhYdC9KZmgx?=
 =?utf-8?B?NGdYL3dUZjBYT2k2dHBlK1FRejlqTFo4d2tWaGwwWm91bld2d2REcFVDcWNu?=
 =?utf-8?B?bnBiaUYxUysyR2pkK0VyNk1PZXVBTFFOcStMZVdwaHZUbyttNE5GaGtiNmN5?=
 =?utf-8?B?eDl4R1lreXN1elNKVmxTUW92MWVMSTJmMUdITGJtZ3RVa0N4Y0IrRUp1T0hu?=
 =?utf-8?B?dys4NmQwYk4vN3h4cFQ2TDU0VVdyaCt0amtpOVU5ZlcwK1VzdE1FVTJvNXEr?=
 =?utf-8?B?L3dxbjVld2w5bi91a21WMXJKZk9McWlkaWV3c241UzZ1SWR1YlpnUVlndllJ?=
 =?utf-8?B?QnhQcEc5ZDhvMDFhZHZIekJ1SDVlaWYyZ1JmMG1DNXh2RHR4WWJwQ25JdFdQ?=
 =?utf-8?B?QjFqMWFOdWdsSHFVNU5OTVNhSHY3Sms2Q3RBQXhhWVdLODY0NTAzOWFnTW13?=
 =?utf-8?B?T0xsVjI2Sysrcmk0YVdZTWFuQnNOeUpTQ3MvSlMvTTNHWnEyVXdxNG5jNmNI?=
 =?utf-8?B?ckc1WVJ1MW9lTi9JSis0b0xWQ3d6aDdCWWlWckJTK1gwUk5QUFVxM0p4MTFk?=
 =?utf-8?B?NHJxMlI0UElxK3BiTUdUa0N0MUkzdlJSOTFWSVBxbGtNU24vczNwL1cvMmIv?=
 =?utf-8?B?SGVjREJXU0lWRUNUWDFFU3F4THpHWHNFNlY2THFTb1BTTTBxUEFiaW04RXJq?=
 =?utf-8?B?Rmo2S1RORFpoRHRuMWtETEFldlg3WkdhWSt0eTdiNVN2azVPaG11cnZtbmVy?=
 =?utf-8?B?dDNiSG5HVENoM2M3UFlTRUNFV1NvaU5udHYyLzZhRVJkNUFqclFQcm4wVFRP?=
 =?utf-8?B?N1BzU3pRRjdidzM0bUk1MDNGay9FbWxTbWd3bWRzZG5mVGtocTl3bXMrb1A4?=
 =?utf-8?B?KzljNHRHQXVYRjdmQnNCdytGUVRMS0JsTHBTVVJQdnQya2dNcm9RdGNNZzJX?=
 =?utf-8?B?aDM0OWl6SDFsZ0FEcG9DMy9sNitwSDBDRzlwMTVUN1hXbUxERW94Wk1iRDRw?=
 =?utf-8?B?OGtFc3dHb0cxT3dGd016MW00OE9CRkJhZG5XcSs4cXFTeEpTcVNPU2VGWHNp?=
 =?utf-8?B?MDRTSGd0ZmF1OXNaTnNybGI4bTNtOFJoTjBIazlYUlJBUm8zRFNqb3k2ZWpU?=
 =?utf-8?B?SHR6dno2dEtsd2YwNDdGRG1NMnBvT1d3QXd6bzdlenhZWWhhOXF1VllXTVph?=
 =?utf-8?B?Q2lnTU0rL3ptejNPRzBGSWoxVVljOGV1NmhVNzJ2WnVYTUFyOXZvSEQzRXR6?=
 =?utf-8?B?c3VaWDlQRU9oVG84bysvdGJXbUI3YVN0aUtpRFFBRjlCbW03UW5xVEFjN0dZ?=
 =?utf-8?B?eTQ0MHY5N1lwUzlRVkFIM1F1OGdJc28ySHlFK3hueTJRcGhVS29kQmFPRDlp?=
 =?utf-8?B?ZCt4dkg3MWllQThOMU9JejN4bmZHb0ExQUtvWWdKRWN5S3V4Tk84akk4blpq?=
 =?utf-8?B?NVJlejRsM1hmL2VQaDFMSHFnRDlHL2ZueUxWYjc4NHRKakltRmVoVmc3bi91?=
 =?utf-8?B?YVNWUkJlTCtUSHpDQzNrYS9VbjJoN244Z3hER3F6L3JOY0MvajVGS2wzTzJx?=
 =?utf-8?Q?Lo5Pk3JAWP2ltOCiIEPSBnU/1?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28F60D2E0BEF9E4D96E8287A447C68CC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93fece26-99e9-4812-9a71-08db9f08d75b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2023 10:00:52.4166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sIRsHyiJ8Vf28cnqGO6fNcp1e8804woGy7DywvaxJDhnNfb6c8xZ1Xn6SDNAV99DAOZHyE2il3yCVuPLZYRyPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6690
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVGh1LCAyMDIzLTA4LTE3IGF0IDA5OjM4ICswMjAwLCBKaW5wdSBXYW5nIHdyb3RlOg0KPiA+
IFRoaXMgYWRkcyBjb25kX3Jlc2NoZWQoKSB0byB0aGUgZmlyc3QgdHdvIGxvb3BzOiByZWxlYXNp
bmcgbm9uLVNFQ1MgcGFnZXMgYW5kDQo+ID4gcmVsZWFzaW5nIFNFQ1MgcGFnZXMgd2hpY2ggZG9u
J3QgaGF2ZSBjaGlsZHJlbiBvbiByZW1vdGUgdmVwYyBpbnN0YW5jZShzKS4NCj4gPiBUaGVyZSBp
cyBhIHRoaXJkIHJvdW5kIGxvb3AgdG8gcmVsZWFzZSBTRUNTIHBhZ2VzIHdoaWNoIGhhdmUgY2hp
bGRyZW4gb24gcmVtb3RlDQo+ID4gdmVwYyBpbnN0YW5jZShzKS7CoCBJIHRoaW5rIGl0J3MgYmV0
dGVyIHRvIGFkZCBjb25kX3Jlc2NoZWQoKSB0aGVyZSB0b28sIGFsdGhvdWdoDQo+ID4gaXQncyBl
eHRyZW1lbHkgdW5saWtlbHkgaXQgY291bGQgdHJpZ2dlciBzb2Z0bG9ja3VwIHcvbyBjb25kX3Jl
c2NoZWQoKS4NCj4gDQo+IEkgYWxzbyB0aGluayB0aGUgdGhpcmQgb25lIGFyZSBleHRyZW1lbHkg
dW5saWtlbHkgY291bGQgY2F1c2Ugc29mdGxvY2t1cC4NCj4gQW5kIG91ciB0ZXN0cyBkbyBub3Qg
aGl0IGl0IGVpdGhlci4NCg0KSWYgd2Ugb25seSBjb25zaWRlciB5b3VyIHRlc3RzLCB0aGVuIEkg
YmVsaWV2ZSB5b3UgZXZlbiBkb24ndCBuZWVkIHRoZSBzZWNvbmQNCmNvbmRfcmVzY2hlZCgpPw0K
DQpJIHRoaW5rIHdlIHNob3VsZCBqdXN0IGFkZCBjb25kX3Jlc2NoZWQoKSB0byBhbGwgdGhlIHRo
cmVlIGxvb3BzLiAgTm8gaGFybSwgYW5kDQp3ZSBkb24ndCBuZWVkIHRvIHdvcnJ5IGFib3V0IHRo
aXMgYW55bW9yZS4NCg==
