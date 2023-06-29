Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11ADEB64D7
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Jun 2023 03:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjF2DLC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 28 Jun 2023 23:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjF2DLB (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 28 Jun 2023 23:11:01 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686BC187
        for <linux-sgx@vger.kernel.org>; Wed, 28 Jun 2023 20:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688008259; x=1719544259;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ivWTUw2d7Q3rJ464MaE10KlS8dieDWHig/tv33b87C4=;
  b=b1ooN/SD0Ywwf7/+/uGu0ZrP6LXlwPeW9mWUscAkA3xpZXnqhZ2yOsWG
   WAt1tJEl3p4WJbeu2d7MZ0vjgX3x6mQnL02Wm3UY2u7KEyJ+m+j6FZtMz
   LWlbwGL37b0LXXkP5Jl/+wVdePaXZlineSmSUN4uQ/PUGFwboPujWdTwu
   74mv+KS+Pe3FezxVqGdoetYhq9dBsrc4hcCHqAlnNwmBySn0QOEHu1LJ2
   j3HXicxcg6KN088ptAJ3CIyx4Cp9E/NWKS+VEhcPL35E9hSikg517+Lr5
   sa/3ZOSJkRhFofCMCpBJKmKKM+G5XkrTMwMZ+8HgMPypSZ4aCWFo9jZpw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="364558725"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="364558725"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 20:10:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="1047626173"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="1047626173"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jun 2023 20:10:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 20:10:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 20:10:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 20:10:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PLg1JWCTeSv11htTaKBwhzbR5pUPwkdEQQjGU1nd5cH594gSx4qM9qGl6nWEBkpkqd/0bPKm0FzBtK/Pi2vYsPjxFHuIKebm/umnrgLJ7lIJjGTAgxpCx6Y2pY/r+36P2/1LI6NcCEDP0hKi+h5IJTEObqeAdrU0jaJymUF/p8xsHu0FuCX116hWWKQCNQhht1G8bUiK8u2XymUmMWt1rS1tUbtgb3Rbml1KQWEAcGaA4YexUpFsnfYT3pLbU3chy9jfKj6J6fQFJrmdbNa1FDNfvxv9J4ZzhjR0pR4w/nbBuXpi+i2Hn8gJrPyvRXPxe04Gdddv/3zh1NXLq4ry1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ivWTUw2d7Q3rJ464MaE10KlS8dieDWHig/tv33b87C4=;
 b=LwocHHSJRQ772XrNCVRA2jqcP8pCtnM11XNwUh5qs+hIUPhGPEykkhayDaYG/jBZfMznXzY92A6k4StNSyj4DlOHglGDJICw+LufgpQ0V/fENSyxbxSgfzc7vvgpg+fuxmCTx7F8KL55GEOCzOtIzeGoZ6FsYnSXylzlBOaO6LZj9782A4cRn5CnXAIWJnJyJ1mve3XHJXf1w6JOyhAsaA8m2crGtg5lvT2Uh3ETnlMI5H3127cGIdb7hVVKbbbPN2J4ybVVlCMZsvE1DPfLaelPQMxdHokoZpYgIALyWj5jccc6JLSm/iAaqvtDOqcWmVpS8fiTaTuUkUDz4uDj2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW6PR11MB8365.namprd11.prod.outlook.com (2603:10b6:303:240::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 03:10:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 03:10:52 +0000
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
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAA5ciAIAACKGAgAY6gQCAADnpAIAV3bGAgAGoFwCAALMwAIB7cDIAgA/0eQCAD7ESgIABMj4AgAQB+wCABWrEAIAAFpKAgAY6eYCAAN3pAIAANG0AgAE6tgCAAFmGgIAAzOeA
Date:   Thu, 29 Jun 2023 03:10:51 +0000
Message-ID: <60f96055b73932ef3550eb562d2f42440d534e69.camel@intel.com>
References: <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
         <d0b65bbdd20a79a43d979b08972dd05bfc79b08c.camel@intel.com>
         <ZIzcrmU1RA7oEeQ7@google.com>
         <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
         <ZJTEpH2yYtHmTRWr@google.com>
         <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
         <ZJoRHU1CHxIuDH29@google.com>
         <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
         <ZJr3PthzDgugKDcO@google.com>
         <1a980d3ce2caec1cf44bf97d52fa08fbe72e741f.camel@intel.com>
         <ZJxKV1/2M+OeIXAN@google.com>
In-Reply-To: <ZJxKV1/2M+OeIXAN@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW6PR11MB8365:EE_
x-ms-office365-filtering-correlation-id: b6bc4b9b-e789-4417-5908-08db784e720e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UNWiRVT+H7FlJlO7UxQzRsQ/omn+/d1gY5soKfZSRFYkElCZSxnSxZN5a/rRJuuT/d7LAu447LYU5RT1MaCirwzCaXmafpzpIXVfO6C2szwGS4OVSOpCyS1qxiwMtXJEERgGc84bhAGPlRDhyRmv6J/I4qD71vpKXFHoOScpk8qlwdTT2aeDxDIXY9xtOt/MN78nddiaBHcwXPza6f2ebBhfc0cYjrRlLjVw725qn9JHgfaeTHucO2YEWjvEjT/z9UbkpbjQOfxc5LfSMTZ/ZtBUHr934UZ7uzZBwMfBETOfJwhTJjuXlBAi7tNXNy+nxPU5WdZs5S53po9//9mrGtW0EpKCEgXxnY8driUAPft+y/gQdnxSNAc0Tj6/wSWnDra0kItrM64lLjc6HIIV0HDESxtinw+E7liWf5qq9X82HJPTKaf3YkJALmG2C/dZ7DRJL1FYM+XqKWHnd4Ezw2tFlsTqXy1atSHZ+89tOeiYgbUJGCTKB9lNfMW818QJwEoy1E7OdK5NFjYpGyqbNLJ4mP3hscXMAtXJs5+HPvd0RTUmkBPt/CBV4n2dQyffUK3HyNRGOsNDzCOox69gX+whztek4NaJ9lmHRtgJ5jX3BCQuCXsbIS20xubkO3uc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(376002)(366004)(396003)(451199021)(6512007)(66446008)(38070700005)(26005)(66556008)(66476007)(4326008)(66946007)(36756003)(122000001)(86362001)(6916009)(8936002)(41300700001)(316002)(8676002)(82960400001)(5660300002)(91956017)(64756008)(38100700002)(76116006)(6506007)(6486002)(186003)(2906002)(71200400001)(54906003)(478600001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWQ0OHd0a1pidWRqUlhuVXZGSHNYT0tYSXVqQmpnWHIybjJWUVdLMVlhU3VG?=
 =?utf-8?B?QWNEajh0Q2hBUWdtN2pKTWl1TW02Z1d6V2R1Ukw2TlV3OVFhblE3UWxpUS9H?=
 =?utf-8?B?YXdSeTJwRGhpdkc4Q2J2QklVVVMrTE5IMGhYemVadUJTcFRPaDlMaTV2M2pu?=
 =?utf-8?B?OFRpK25POGtEci9Oei8wMVN5ckJwYkpzLzN0SENCM2NnNHBlYmVlWHFmUUZi?=
 =?utf-8?B?SGxCeEF6eDRpWGVRalpqT0x1MWFJZ21rR0h1cGhUcUZnMnZiL24vZy9BcmJX?=
 =?utf-8?B?N3hQcmRuNjFUVEVGOWJSdWxSNVFNTmdmWDRXcTBjSXgrRjRxYnVMOERpU0hh?=
 =?utf-8?B?Ty9RNlExOXpqeDIrcm91S05Lc1orYmFYSFZpL2hEOE1BS2VuRlNsM1hYVUda?=
 =?utf-8?B?WmZka084SlNMcGhDQUE2N1FWcUR6cXIvOGlVamJ4Rm9uNFh6Um0xTEtCeUh0?=
 =?utf-8?B?ejhMeTYwZEo3NFdCR0RNZEZEWEp4eXM4ZVVGZkM3NGlUazBCYTd1TXlPZnl1?=
 =?utf-8?B?VFh3M2JQWEdDaDErSGg3SEE5OEdJT3hySGpzTFVwSFlTSjc4VkVGNWtIQXgr?=
 =?utf-8?B?Y24yT2ROUUxpYi9sa2g5bGE1QnhwempJK3pMcVc1d0ZndGhBblgrb1JYekxt?=
 =?utf-8?B?eFA1ZUVSRXF5RmhLUlA1b3pSeGhsZ0RBcXo2RG9QOXJqOUdJRnNPTU1rZVJT?=
 =?utf-8?B?OHFGd1lLR0FsRHFGdnNWZml2Z1JWVmlVNnFGelVXMnFPc0FVcXc1UXMvK2VV?=
 =?utf-8?B?MXZJdmNFTFNCQXNaZFBSalVPdW1mYkVRVVBvaGM0SEVnUTN2ai9vVWorM004?=
 =?utf-8?B?anZ3eUZmc3QrYWsvMCs4MWRZckVvY1NpdXcrSkNGYWFhN3lEaDVncnpkVHg4?=
 =?utf-8?B?R3Z2NVBrRE1iQndBcXI5eDlkRmtNT1M3RFZCK3lDT21VVStDajJ0cnp4Zytw?=
 =?utf-8?B?TWZDWHRzMkppODNsbXBybkNnT0twMzlzK1R3UzEzam1hV0x0NXRnbTVqWTVN?=
 =?utf-8?B?NmxUdnJRaTJJRDgrYjZhWGliM2VHMmtQQTJGeFFla3llVVNTeVJpVjQzY2th?=
 =?utf-8?B?TWh5SXVXRGNEd3FZSlAzaWtJU0R2cUhZdkhXUkVVSDdwakI0SG9BVUJ4Wmxm?=
 =?utf-8?B?WmRlWEhzdjlRQUh2NGhCOXNNcE9pOHJ0eWp2Z0NVODJBM0ZKM3B5L2h0Wjgv?=
 =?utf-8?B?dlZud3JHSmZGbHlKdVIzU0VNMENYaURBb0hFcHVXNGdMTVg4TVNQSmxINmJS?=
 =?utf-8?B?M0tTZHBHeWd0Nmx0ZmdGSkhXUytOWFBJbERqNnlCT3hHZGxQcExsNGh2MmJJ?=
 =?utf-8?B?QklqTWhpZTZLakJSUC9ES2pQc0lsNEltZ1NNdVUwdEx5cWhHQ0t3WDh2UDhv?=
 =?utf-8?B?OTJMYWIwNDB2UE81bzY0RUdRUHd2aXp4K0I3Znk3M050Z0RVclZBSCtFa2hZ?=
 =?utf-8?B?TDY2WVp2MDlvekhZK29keENZdW1ucEhzZW94QUtlWWpKYTd0cStUM3Jid21O?=
 =?utf-8?B?WFVQbGlrV3VrY0VEL1RnMXJsZkpTQnhhcVl6ZDVCUG1ic2g4SzlQQmVKK01n?=
 =?utf-8?B?a3BXV0YrZ2YrWUJnYVpZQ2kwYzBpM3J2SStLNHM3OGFoM3FlMzYxeEZ6d2d6?=
 =?utf-8?B?c241TTJNQzRPUlo5aDdJVkdFelFrWVBOVHVQZHRUZTJqTG5qNnozcUV6TzFB?=
 =?utf-8?B?cXkvNE5iRFRrN0pjRlFOb21mN3hXZy9sMTRrZjAwYjdDQmJhS0V5NXQ1aE55?=
 =?utf-8?B?ekZUYmI0VThBRUJsWjFrQ2hZZzhpZE5Wc0JPZVArUWNMcVBicXNzWE5EbTZy?=
 =?utf-8?B?ZTJSOGVLcm5ocXNPKzhnekk3T2ZOdWVxZWRCOWxLU2k2VDlPTXB5ZUZEK0tn?=
 =?utf-8?B?ZDlNdWw1b2ZCVnE1ZzA3eStRMkR2Q1FVNkV4ZXE1MU1yUDZXYlhqUXVNbnFX?=
 =?utf-8?B?YU9lUURYTUg0eFY2RHRkMkZvbmowclh2NUdSSGNObkhFWkVzaXVOaklYRk9N?=
 =?utf-8?B?U1NZMzV5d0JYREZraTF2S2FrNVNuT09ubTBxSnk5UGlYZWFtbm44dVJjUWxH?=
 =?utf-8?B?T3dhS2dqRnBYZ3RRVkVqVEgyR01aVjVkY2s3b2ZNN1ZHZHN6UmFvVE9rcENl?=
 =?utf-8?B?M0ZWaEtrbzNROWdJV21YTitmYjhwOXRrOEhuakVzZFpZS2NITUk3Q0FWalA0?=
 =?utf-8?B?YVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F25E9DBC08ADC45AE435ED5AF4C5AB9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6bc4b9b-e789-4417-5908-08db784e720e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 03:10:51.9248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h9U4Gi+XUpR89bk9hq1TPDg7GQ0FdyH+sNuyScV3Rq2IWThoonWq1LGln/dnVRylsFpQaNkrneGxlLqciTNYbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8365
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDA3OjU3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEp1biAyOCwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyMy0wNi0yNyBhdCAwNzo1MCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IFRoZSBxdWVzdGlvbiB0aGF0IHlvdSByZWFsbHkgd2FudCB0byBhc2sgaXMgImNvdWxk
IGNoYW5nZSBYWVogYnJlYWsNCj4gPiA+IHVzZXJzcGFjZT8iDQo+ID4gDQo+ID4gQWdyZWVkLg0K
PiA+IA0KPiA+IEJ1dCBzaW5jZSAiZW5jbC0+aGFzX21pc21hdGNoZWRfb2Zmc2V0cyIgaXMgc29y
dCBvZiBuZXcgQUJJLCBJIHRoaW5rIHdlIG5lZWQgdG8NCj4gPiBiZSBjYXJlZnVsIG90aGVyd2lz
ZSBpbiB0aGUgZnV0dXJlIHdlIG1heSBoaXQgdGhpcyBraW5kYSBuYXN0eSBpc3N1ZSBhZ2Fpbi4N
Cj4gPiANCj4gPiBIZXJlJ3MgbXkgdGhvdWdodHM6DQo+ID4gDQo+ID4gKEFnYWluLCBsZXQncyBm
b3JnZXQgYWJvdXQgbW1hcCgvZGV2L3NneF9lbmNsYXZlKSB0byByZXNlcnZlIEVMUkFOR0UgZm9y
IG5vdy4pDQo+ID4gDQo+ID4gMSkgQ3VycmVudCBBQkkgaXMgU0dYIGRyaXZlciBfaWdub3Jlc18g
cGdvZmYgZm9yIG1tYXAoL2Rldi9zZ3hfZW5jbGF2ZSlzDQo+IA0KPiBZZXMuDQo+IA0KPiA+IChi
dXQgcmVxdWlyZXMgTUFQX0ZJWEVEKS4NCj4gDQo+IE5vLCBTR1ggZG9lc24ndCByZXF1aXJlIE1B
UF9GSVhFRC4gIFRoZSByZXF1aXJlbWVudHMgb2YgRUxSQU5HRSBtYWtlIGl0IGV4dHJlbWVseQ0K
PiB1bmxpa2VseSB0aGF0IG1tYXAoKSB3aWxsIHN1Y2NlZWQsIGJ1dCBpdCdzIG5vdCBhIHN0cmlj
dCByZXF1aXJlbWVudC4gDQoNCkxvb2tzIHcvbyBNQVBfRklYRUQsIHRoZSBkcml2ZXIganVzdCB1
c2VzIHRoZSBnZW5lcmljIG1tLT5nZXRfdW5tYXBwZWRfYXJlYSgpIHRvDQpyZXR1cm4gdGhlIGFk
ZHJlc3MsIHdoaWNoIGRvZXNuJ3QgZ3VhcmFudGVlIHRoZSByaWdodCBhZGRyZXNzIHdpbGwgYmUg
cmV0dXJuZWQNCmF0IGFsbC4gIEVzcGVjaWFsbHkgd2hlbiBFTFJBTkdFIGlzIHJlc2VydmVkIHZp
YSBtbWFwKE5VTEwpLCB0aGUNCm1tYXAoL2Rldi9zZ3hfZW5jbGF2ZSkgd2lsbCBub3QgcmV0dXJu
IHRoZSBjb3JyZWN0IGFkZHJlc3Mgbm8gbWF0dGVyIHdoYXQgcGdvZmYNCmlzIHVzZWQgSUlVQy4N
Cg0Kc3RhdGljIHVuc2lnbmVkIGxvbmcgc2d4X2dldF91bm1hcHBlZF9hcmVhKHN0cnVjdCBmaWxl
ICpmaWxlLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2ln
bmVkIGxvbmcgYWRkciwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB1bnNpZ25lZCBsb25nIGxlbiwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB1bnNpZ25lZCBsb25nIHBnb2ZmLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3MpDQp7DQogICAgICAgIGlmICgoZmxh
Z3MgJiBNQVBfVFlQRSkgPT0gTUFQX1BSSVZBVEUpDQogICAgICAgICAgICAgICAgcmV0dXJuIC1F
SU5WQUw7DQoNCiAgICAgICAgaWYgKGZsYWdzICYgTUFQX0ZJWEVEKQ0KICAgICAgICAgICAgICAg
IHJldHVybiBhZGRyOw0KDQogICAgICAgIHJldHVybiBjdXJyZW50LT5tbS0+Z2V0X3VubWFwcGVk
X2FyZWEoZmlsZSwgYWRkciwgbGVuLCBwZ29mZiwgZmxhZ3MpOw0KfQ0KDQpTbyB0byBtZSB1c2Vy
c3BhY2UgaGFzIHRvIHVzZSBNQVBfRklYRUQgdG8gZ2V0IHRoZSBjb3JyZWN0IGFkZHJlc3MuDQoN
Cj4gDQo+ID4gMikgVGhlcmVmb3JlLMOvwr/CvSJwYXNzaW5nIHRoZSBjb3JyZWN0IHBnb2ZmIiBp
biBuZXcgdXNlcnNwYWNlIGFwcCBkb2Vzbid0IGJyZWFrIHRoZQ0KPiA+IGN1cnJlbnQgQUJJLiAg
SWYgdGhlIG5ldyBhcHAgY2hvb3NlcyB0byBwYXNzIHRoZSBjb3JyZWN0IHBnb2ZmLCBpdCB3aWxs
IHdvcmsuDQo+IA0KPiBZZXAuDQo+IA0KPiA+IDMpIFdpdGggYWRkaXRpb25hbCBzdXBwb3J0IG9m
IHNneF9mYWR2aWNlKFdJTExORUVEKSB3aXRoaW4gdGhlIGRyaXZlciwgdGhlIG5ldw0KPiA+IGFw
cCBjYW4gdXNlIG1hZHZpY2UoV0lMTE5FRUQpIGlmIGl0IHBhc3NlcyB0aGUgY29ycmVjdCBwZ29m
ZiB3aGVuIG1tYXAoKS4gIElmDQo+ID4gd3JvbmcgcGdvZmYgaXMgcGFzc2VkLCB0aGVuIG1hZHZp
Y2UoV0lMTE5FRUQpIHdpbGwgd29yayB1bmV4cGVjdGVkbHkgYW5kIGNvdWxkDQo+ID4gcmVzdWx0
IGluIGVuY2xhdmUgYmVpbmcga2lsbGVkLiAgSXQncyB1c2Vyc3BhY2UgYXBwJ3MgcmVzcG9uc2li
aWxpdHkgdG8gbWFrZQ0KPiA+IHN1cmUgdGhlIGNvcnJlY3RuZXNzLCBub3QgdGhlIGRyaXZlcidz
Lg0KPiANCj4gSG1tLCB5ZWFoLCBpdCdzIHByb2JhYmx5IG9rIHRvIGxlYW4gb24gZG9jdW1lbnRh
dGlvbiBpZiB1c2Vyc3BhY2Ugc2NyZXdzIHVwLiAgSQ0KPiBnZW5lcmFsbHkgcHJlZmVyIGV4cGxp
Y2l0IGVycm9ycyBvdmVyICJ1bmRlZmluZWQgYmVoYXZpb3IiLCBidXQgSSBkb24ndCBoYXZlIGEN
Cj4gc3VwZXIgc3Ryb25nIG9waW5pb24sIGVzcGVjaWFsbHkgc2luY2UgdGhpcyBpc24ndCBteSBh
cmVhIHRoZXNlIGRheXMgOi0pIA0KDQpNeSBhcmd1bWVudCBpcyBmb3Igbm9ybWFsIGZpbGUgb3Bl
cmF0aW9ucywgaWYgeW91IHVzZSBtYWR2aWNlKFdJTExORUVEKSBidXQNCmRpZG4ndCBtbWFwKCkg
d2l0aCB0aGUgY29ycmVjdCBwZ29mZiwgeW91IHdpbGwgZW5kIHVwIHdpdGgga2VybmVsIGFjdGlu
ZyBvbiB0aGUNCndyb25nIHBvcnRpb24gb2YgdGhlIGZpbGUgKHdoaWNoIG1heSBub3QgcmVzdWx0
IGluIGZhdGFsIGVycm9yLCBidXQgY2VydGFpbmx5DQpub3QgdGhlIGNvcnJlY3QgdGhpbmcgZnJv
bSB1c2Vyc3BhY2UncyBwZXJzcGVjdGl2ZSkuDQoNClNvIGtlcm5lbCBkb2Vzbid0IGd1YXJhbnRl
ZSBhbnl0aGluZyBoZXJlLCBidXQgZGVwZW5kcyBvbiB1c2Vyc3BhY2UgdG8gZG8gdGhpbmdzDQpj
b3JyZWN0bHkuDQoNCj4gDQo+ID4gNCkgT2xkIFNHWCBhcHBzIHdoaWNoIGRvbid0IHVzZSBmaWxl
LWJhc2VkIEFCSXMgYW5kIHN0aWxsIHBhc3MgMCBwZ29mZiBzaG91bGQNCj4gPiBjb250aW51ZSB0
byB3b3JrLiAgTm8gYnJlYWsgb2Ygb2xkIGFwcHMgZWl0aGVyLg0KPiANCj4gWWVwLg0KPiAgDQo+
ID4gNSkgV2UgZW5jb3VyYWdlIG5ldyBhcHBzIHRvIGFsd2F5cyBwYXNzIHRoZSBjb3JyZWN0IHBn
b2ZmIGluc3RlYWQgb2YgcGFzc2luZyAwLg0KPiA+IA0KPiA+IDYpIElmIG5lZWRlZCwgd2UgY2Fu
IG1vZGlmeSBzZ3hfbW1hcCgpIHRvIHJlbGF4IHRoZSBuZWVkaW5nIHRvIHVzZSBNQVBfRklYRUQs
DQo+ID4gYnV0IHJldHVybiB0aGUgZW5jbGF2ZSdzIGFkZHJlc3MgImJhc2VkIG9uIHBnb2ZmIGZy
b20gdXNlcnNwYWNlIi4NCj4gDQo+IEFzIGFib3ZlLCB0aGlzIGlzbid0IGEgcmVsYXhhdGlvbiBv
ZiBhbnl0aGluZyBzaW5jZSBNQVBfRklYRUQgaXNuJ3Qgc3RyaWN0bHkNCj4gcmVxdWlyZWQsIGl0
J3Mgc2ltcGx5IGFkZGl0aW9uYWwgZnVuY3Rpb25hbGl0eS4NCj4gDQo+ID4gVGhpcyBlZmZlY3Rp
dmVseSBwcm92aWRlcyBhZGRpdGlvbmFsIG1tYXAoKSBBQkkgZm9yIHVzZXJzcGFjZSB3aGlsZSBu
b3QNCj4gPiBicmVha2luZyB0aGUgZXhpc3RpbmcgTUFQX0ZJWEVEIEFCSS4NCj4gDQo+IEkgZG9u
J3QgdGhpbmsgeW91IHdhbnQgdG8gZG8gdGhpcy4gIFRoZSBNQVBfRklYRUQgY2FzZSB3b24ndCBi
ZSBhZmZlY3RlZCwgYnV0IHRoZQ0KPiBhZGRyZXNzIHByb3ZpZGVkIHRvIG1tYXAoKSBpcyBhbHNv
IHVzZWQgYXMgYSBoaW50IGluIHRoZSAhTUFQX0ZJWEVEIGNhc2UsLCBpLmUuDQo+IE1BUF9GSVhF
RCBqdXN0IG1lYW5zIHVzZSAqZXhhY3RseSogdGhpcyBhZGRyZXNzIGFuZCBkb24ndCB0cnkgYW55
dGhpbmcgZWxzZS4gIEl0J3MNCj4gdW5saWtlbHksIGJ1dCBub3QgX3RoYXRfIHVubGlrZWx5LCB0
aGF0IHRoZXJlIGFyZSB1c2Vyc3BhY2UgYXBwbGljYXRpb25zIHRoYXQNCj4gc3BlY2lmeSB0aGUg
ZXhhY3QgYWRkcmVzcyB3aXRob3V0IE1BUF9GSVhFRCBhbmQgd2l0aG91dCB0aGUgY29ycmVjdCBw
Z29mZi4NCj4gDQo+IElmIHRoZXJlIHdlcmUgbW9yZSB0byBnYWluIGJ5IHN0ZWVyaW5nIG1tYXAo
KSBiYXNlZCBzb2xlbHkgb24gcGdvZmYsIHRoZW4gaXQgbWlnaHQNCj4gYmUgd29ydGggdHJ5aW5n
LCBidXQgdGhpcyBkb2Vzbid0IHNlZW0gdG8gcHJvdmlkZSBtdWNoIHZhbHVlIHRvIHVzZXJzcGFj
ZSBzaW5jZQ0KPiB0aGUgdmlydHVhbCBhZGRyZXNzIG9mIGFueSBnaXZlbiBlbmNsYXZlIG1hcHBp
bmcgaXMgbWlzc2lvbiBjcml0aWNhbCwgZS5nLiBpdCBzZWVtcw0KPiB1bmxpa2VseSB0aGF0IHVz
ZXJzcGFjZSB3b3VsZG4ndCBhbHJlYWR5IGtub3cgdGhlIHZpcnR1YWwgYWRkcmVzcyBpdCBuZWVk
cy4NCg0KSSB0aGluayB3ZSBjYW4gZm9yZ2V0IGFib3V0IHRoaXMgZGlzY3Vzc2lvbiByaWdodCBu
b3csIGJlY2F1c2UgaXQgaXNuJ3Qgc3RyaWN0bHkNCnJlbGF0ZWQgdG8gdGhlIHByb2JsZW0gdGhh
dCB3ZSB3YW50IHRvIGNsYXJpZnkgYXQgdGhpcyBtb21lbnQuICBNeSBiYWQgdG8gYnJpbmcNCml0
IHVwIDopDQoNCg==
