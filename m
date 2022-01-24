Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5269C433FE
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Jan 2022 21:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446662AbiAXVJB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Jan 2022 16:09:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:47069 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357408AbiAXU7W (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Jan 2022 15:59:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643057961; x=1674593961;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CjIBzl/00tBkCP5g4XOoQsrc3YgMgH0w5/cu8XUw9ew=;
  b=VoKckISKvPMyuEOaz6idtxPpkqfzAPkxs9yeh70Bfvps4uY4Ci4qh1vr
   aOTaC1iuXle389YYi8Ir9Th344h3WcwyOfT5YO/SCkkTx1FQgY8mLuh0H
   sL4C5Ou/KHAVQbbW6oRJYYKpZ5koCaZ6Qov8mOBmuw8q5444pt9zX3dYW
   k4V+G0V7VU00izsuQEKZnzlf90k6ZkFwTBD4/OP0D2fEGPK+qcpyp0V6T
   vb7UPv9WDv+D1t4IN85Vx7Xs9t1OZvS/mOMQ0YZh/xpPUlPHc4vAFrYI6
   BuQb7cYcPDr1Ttf6vyB0uxnZk6S2VuDEX+ZaGBtsd+ZYd3uvFIlRpFRFK
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="243745911"
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="243745911"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 12:59:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="520099510"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga007.jf.intel.com with ESMTP; 24 Jan 2022 12:59:18 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 24 Jan 2022 12:59:17 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 24 Jan 2022 12:59:17 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 24 Jan 2022 12:59:17 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 24 Jan 2022 12:59:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NW2VJB7+nyScdGWG8wi5NuoTke8Jfl/tRt8NVHFkPg/bg6d4HFNwiUk9gGa2ec7cV1nrfm5BwzYNbBnxXJLqjJkUJZbky30PmvGdAxRYWEOzZra5+XyxI5f1YiGBhrz/l2CPV26qlGAVl5xQ2TwQ55YRL+znyr0PuEo2EmAuQ8kiH6PP1cyaT4It6+ssSNylU3GyHmWwzmh8cIZFilb0f07UvdRaI5/U7edBDkOoXe18GREoTriPSN3zbn57QjmWJRPjWgvz4nbp0aDif+NU+OQSCNu+VtnuTsJl0SO41GmdecN62IFpkwVI/QXM1UFmYQmBQIeWNIav3A5BhlpgfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjIBzl/00tBkCP5g4XOoQsrc3YgMgH0w5/cu8XUw9ew=;
 b=KXRF2M7P0fEnAiVyPVbgpROVUEqm7U+zgyfaY78OPSQPfaJD+zW3G7rvfQMtvwgpntlBHajUWX9O7iWxg4TVyNNZMUQPWvDEaZ63Ea7YqB6/2x0aimzTPHL4VXi1ejux84v6hIxmpKFi8pk3X0vTY8WWPQnIDDFSynr97A+m4SGrrl4BYwEyZqtACDbu8n/ByihxF+2CDZRTpFyzHbgQje7ZaFHCYkIM31gkzdBFacQGVHgTVKSvW5YeeMpEekAIA3UzuHvJw4Km8eBPxK5cRdSuO13yiEbKljhm1IYMNlaoq0DtiaUgfc/B+R9VZlHvp8Cdk+fgK83yLfYD1qel/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SJ0PR11MB5069.namprd11.prod.outlook.com (2603:10b6:a03:2ad::6)
 by BN9PR11MB5548.namprd11.prod.outlook.com (2603:10b6:408:105::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 24 Jan
 2022 20:59:15 +0000
Received: from SJ0PR11MB5069.namprd11.prod.outlook.com
 ([fe80::a479:6130:7e5:b145]) by SJ0PR11MB5069.namprd11.prod.outlook.com
 ([fe80::a479:6130:7e5:b145%3]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 20:59:15 +0000
From:   "Accardi, Kristen C" <kristen.c.accardi@intel.com>
To:     "jarkko.sakkinen@iki.fi" <jarkko.sakkinen@iki.fi>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko.sakkinen@intel.com" <jarkko.sakkinen@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: Testing 5.17 bugfix material
Thread-Topic: Testing 5.17 bugfix material
Thread-Index: AQHYDwExVXZhV/EzqUedym6PXVsG2qxydh8AgAADZYCAADL0gA==
Date:   Mon, 24 Jan 2022 20:59:14 +0000
Message-ID: <9ea2d9cdf649186a4079061bf6b654378c3d256e.camel@intel.com>
References: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
         <06fa9c6e691db71abec906ebce14167bb896ade2.camel@intel.com>
         <Ye7oYz9Lj8yLadyT@iki.fi>
In-Reply-To: <Ye7oYz9Lj8yLadyT@iki.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6c4c6c8-2352-462b-1efc-08d9df7c6143
x-ms-traffictypediagnostic: BN9PR11MB5548:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN9PR11MB5548E840ACA029610352C32BAF5E9@BN9PR11MB5548.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cicf3+GZw/oTHU3tA9Yi/TC250+de6diSUFqLC3YeX92LFZHYBw9grhpaWFrckVHtgcWOYeFk2Ss2x0jOVmKwE2lrEeK9O4sjiQ69BxuEGEwryNqsvPSPSsUaxsinvLNbtspcWqFPWnTXqOeDWm+448CRpQu9dzF1jwDuxWsTIm1PAeZ6CcqdvMgGTXP65B+RuZ4LyZ1knDRJ7/a0VYOfF4ReJUlc9/C8pJ9sG2x9+g/hsC/ZAMpLR00dtlRwmaxs58I8xwljBVa45ZPYlRcicxQL4xcHyQAj6oivEIavwlBdwI5RjwVmMrnnlDJf1x5iCxJ63AJ32YNKdPVxalzQWVVzOVvM6Kf7j2jlE5yZPta8DiH7eqlMKr3q1ZN2JBCz34FsdI0kt5gL+ASzwnU4DFJDq+nBCOvr49PgVoobn5zW3JXclUY+bKIO0sKKLuFkAVe9EGqiOKmh3WC3w3ULCrycIdRaSR1KwL+VapGQrad3JrJ/OyeQllJlKJJRYANQeu+Gy4L/9+Ex1ehTEBrKw1p+pHbPnRtFSr8xrCMdm2OOwdDymxUrJ8odisls040DLp2G2Tib60jq/pcD6pY74w9hx8Qzsp4k0GPA4+6Ib6VUdXjZD5RWGmDM45Ii+o+e89nXCx4svUNpyW04GCGUceGPAoN+rTtnbEBIRyufil8W+CiRTz6R5enVh4GD8vN+u3h1iAiMY1MC0Cha+8rPkE4dtMcgll5J96mgmF31w6Mhi2Yqf33Tq+7eTfZlLfYal+fTzcS25aIUsUgmyAgKOibDuRaUYkO+mUWubzJwdM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5069.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(53546011)(316002)(66946007)(7116003)(36756003)(86362001)(66476007)(66556008)(83380400001)(2906002)(76116006)(8676002)(91956017)(2616005)(26005)(66446008)(508600001)(6506007)(4326008)(64756008)(122000001)(6916009)(5660300002)(6486002)(186003)(54906003)(8936002)(966005)(107886003)(38070700005)(6512007)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODdnaGU4TkkxaXE5RkpvRXFvcXUwMFU1V2lOeGpGTFBpelF2TVUxY0pnUk5K?=
 =?utf-8?B?NnNYeHF0TVdBQzVCRGFudTVpeHpuTU5iWTJvVi84UWdPY0tXazMybmVHU1dS?=
 =?utf-8?B?c1ZZWFB2TklobzFhTjlIU0gxK3lId1h1cUVVSkl1bmR3T3A4Sk9VY0hKeXJy?=
 =?utf-8?B?cFplZ3daZDRqNWsxam9PLzJ3UW5SRGZ3SjBjTG5GTERCblVxeUxGc2V0WGQ4?=
 =?utf-8?B?K2Z0a0t3L01UYmlGL2Z1bmZNbXl0bS9DeEtHL2NrYktiT0pwV0hMMlhRaVlO?=
 =?utf-8?B?ZzNIbXRrN3hpOWdzQ2pOcXhld2doNllWbFMvRGFYbFlRaFZEQldmRzBoNWtB?=
 =?utf-8?B?WWF5S3BYMkViTFZldzJzNDYrSXcxa1VEN2NrM2x5SkNtMWd3SDVLK3I2Tk56?=
 =?utf-8?B?clF4TmxXbWNjYkxjdmpicFAwSkdwWjU0THlzRE1tOFlHcHRJUDRpc2xFT3k5?=
 =?utf-8?B?VVgzaUd2TDRnQU91T09rQVRlQTR2RFUyenhEUXRtYi9xdWNCS3h2dm1PeVZF?=
 =?utf-8?B?bU1iOWhYUXFEcWNUY3VBK0xUby94d0tGSWVXaDJOL0I1MUpiVHFZMlpGMEZ1?=
 =?utf-8?B?U0xpZnd4UGdTUWZoUkhkZU1tWVN0R2w5ZXhyeDM4Tm9XTnduY0R3TXJkdU96?=
 =?utf-8?B?VWsyWEM4bmxzbG9qNzlCV3NXV1dLWkVqdVlWRzB1ZHFTcmVGUVo3TTFKMU0w?=
 =?utf-8?B?YTNCbVFyYXBaS0N0dXViUXJSeWxRSUhmQ3c4dTlpTWNFdHF4bHdRWWxKTUdx?=
 =?utf-8?B?M0o5UGpmNFJnbEVteTFzaTN3WmJJRWxkaXRLOVJxaGFIdXFxRDNJN2lDbERh?=
 =?utf-8?B?cXhIMzdaN2ZGNyt2UWpxMXlSd3o4dXBkU2JiSTBPaTFHRmQwK1lEbmpLb1Vi?=
 =?utf-8?B?Z1hyVEVEbUN6Ry90QXh2QUxpVUN1S1llRlhCdmRrSDN2Wkp0YmxyMDhLcVNn?=
 =?utf-8?B?Rm0wSTNIanp6ZVU2Y2hKREZMSHRad1dpbE1ncUtkc1VRVTB2SkdvMUJHcmkz?=
 =?utf-8?B?aW55eksyQlRsNFlydDJIWk5xY0R0eTN0cHJlR0cyaXRSRFFpRGFjK1JjbXNI?=
 =?utf-8?B?NG1VeUZIbkw1eFExTDE5NTVFODVCOTNOb0dsYWJCL0s5UGVJckZ1aFZNcGdO?=
 =?utf-8?B?eGpKbVQ4QnYyREFFT1c2clhTcWRGaFp5Y1VPMVUzdjZ4aHV4elpTNFh2VGRr?=
 =?utf-8?B?Mi9JWlY1U2tzbmEvT2MrZktvS25VaHRlL0drcDAxTVNZcjlGc2Z3MnN5WTJt?=
 =?utf-8?B?VTRXakVNWmNpbDkzRmRFZHhOa21TMHNkRzZLOG5qMUpMTzFSS2ZkWXdSbnB5?=
 =?utf-8?B?QmpHdVl5T3Vnb0Jtc3h1WFZhcXlMR2M4N21GRnMrb1VlNXB5UmJtZE5vbVpN?=
 =?utf-8?B?dnk1OEVIZVN1c056TTBxZXRNVTV6TWxRemRoVEVZd1FrOUNFNkYxYlhDenp6?=
 =?utf-8?B?bnZYL1lkVlI5NjBxcGJreXlLbmpudmtpclpheVQxTjVoMlpWUGNjZHowUkNC?=
 =?utf-8?B?RFM2NjBUbXBwaWdVS0xaYjhpRkFDbTgvMHFmMHRudjhYVG9lejI5VitzdjZt?=
 =?utf-8?B?M2FSTTVBd2ZEZWVZRWkrZzV3ZkplL2llcklCbjZlNlRoWVZBWVhBL1VGNVpJ?=
 =?utf-8?B?QWkzVTl4OElHbGpRVVpETW81cnhuWU9wQ1YrNUJxNW4za05pTXZab2pSMzVV?=
 =?utf-8?B?a2NPeEZyZm1FY0ltVUEzS2hTMXNOejR2azFSamdlUWpiOVA0dmhKNnl4ZDN3?=
 =?utf-8?B?c0NnVjVvZStMcEY0NFhCamNLRjJEOTdNRWNrZkxoenZqSS9sckFUU084di9N?=
 =?utf-8?B?bUZrZTQ2UGxDRnZjL21UWEwzZXlXTWpLNitGV1BZaWxiQmpNd09IVFBEOFFC?=
 =?utf-8?B?RU9TOVBNOU1jNUxPYmtLcDlNVnQwcVdDOC9sNW1LMmx5NzhDd2JYcldoOFlk?=
 =?utf-8?B?QS9PRjh6bkNTWmZBVmpLdFR3Y3VxK3NjSzhFWGxrNWMwM2U3Yi9JM2xaeWN1?=
 =?utf-8?B?dUhlUWVoTmplcXBKWmZyb1hHano0aEYvZVdMeVVHWlg1V3lSZ2EwUlVxbXpK?=
 =?utf-8?B?UDJvUEVLVnAwSjdzSDBxVDRycE5Sa0xNcGtkWnVCcU1jN0diVHR2bnBqblJT?=
 =?utf-8?B?b09rVVVZSlA4ZFB4MEVCRm1pLzdRV2M0Y3hScGk3ejJWcW9NMFd4dElpcHky?=
 =?utf-8?B?QkNXTGNiYVBHa0taOS9ZZ1Y1bVJsbDVBYnJaeG5wa3FGUUI3dExnTjdMZW9L?=
 =?utf-8?Q?nHGvocpXnWCP48Oh0TlhWH0noHLJwwIjdzcL5nZX2U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FF3AEDB34C1A14297367DB8A7D66264@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5069.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c4c6c8-2352-462b-1efc-08d9df7c6143
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 20:59:14.9426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HhWxvEYAdiQWENVLlMVU9BWgf4PIy72wdIlBMyHh8j0HAe3Wq4+lsh+EuS9bFrBzLJkDLdQ85j9R1pdemtRoyqGKejpGCuTFLNNQKWxN2dI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5548
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gTW9uLCAyMDIyLTAxLTI0IGF0IDE5OjU2ICswMjAwLCBKYXJra28gU2Fra2luZW4gd3JvdGU6
DQo+IE9uIE1vbiwgSmFuIDI0LCAyMDIyIGF0IDA1OjQ0OjQzUE0gKzAwMDAsIEFjY2FyZGksIEty
aXN0ZW4gQyB3cm90ZToNCj4gPiBPbiBGcmksIDIwMjItMDEtMjEgYXQgMTE6NTcgLTA4MDAsIERh
dmUgSGFuc2VuIHdyb3RlOg0KPiA+ID4gSGkgRXZlcnlvbmUsDQo+ID4gPiANCj4gPiA+IFRoZXJl
IGFyZSBhIGZldyBTR1ggZml4ZXMgdGhhdCBoYXZlIHNob3dlZCB1cCBpbiB0aGUgbGFzdCB3ZWVr
IG9yDQo+ID4gPiBzbywNCj4gPiA+IG1vc3RseSBhcm91bmQgUkFTIGFuZCBmaXhpbmcgdGhlIGJh
Y2tpbmcgc3RvcmFnZSBpc3N1ZXMuICBDb3VsZA0KPiA+ID4gZm9sa3MNCj4gPiA+IHBsZWFzZSBn
aXZlIHRoaXMgYnJhbmNoIGEgZ29vZCB0aHJhc2hpbmc/DQo+ID4gPiANCj4gPiA+ID4gaHR0cHM6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGF2ZWgvZGV2ZWwuZ2l0
L2xvZy8/aD14ODYvc2d4DQo+ID4gPiANCj4gPiA+IEknbSBwbGFubmluZyB0byBzZW5kIHRoaXMg
YnVuY2ggdXAgdG8gTGludXMgYWZ0ZXIgNS4xNy1yYzEgY29tZXMNCj4gPiA+IG91dC4NCj4gPiA+
IA0KPiA+ID4gS3Jpc3RlbiwgSSByZWFsbHkgZHVnIGludG8gdGhlIGNoYW5nZWxvZ3Mgb2YgeW91
ciB0d28gcGF0Y2hlcyB0bw0KPiA+ID4gbWFrZQ0KPiA+ID4gaXQNCj4gPiA+IG1vcmUgY2xlYXIg
dGhhdCB0aGV5IGFyZSBidWdmaXggYW5kIHN0YWJsZUAgbWF0ZXJpYWwuICBJJ2QNCj4gPiA+IGFw
cHJlY2lhdGUNCj4gPiA+IHNvbWUgYWRkaXRpb25hbCBleWViYWxscyB0aGVyZS4NCj4gPiANCj4g
PiBUaGVyZSdzIGEgYnVnIGluIHRoZSBjYWxjdWxhdGlvbiBmb3IgdGhlIGF2YWlsYWJsZSBiYWNr
aW5nIGJ5dGVzLA0KPiA+IHBvaW50ZWQgb3V0IGJ5IEhhaXRhbyBhbmQgdGVhbS4gSGVyZSdzIGEg
Zml4IGFwcGxpZWQgdG8geW91ciB0cmVlLg0KPiA+IA0KPiA+IEZyb20gMmViY2YwZTcwYjEyMzUy
MjQ0MTBlMDhjOTgzZTM1N2Q1YWMzYzQzNSBNb24gU2VwIDE3IDAwOjAwOjAwDQo+ID4gMjAwMQ0K
PiA+IEZyb206IEtyaXN0ZW4gQ2FybHNvbiBBY2NhcmRpIDxrcmlzdGVuQGxpbnV4LmludGVsLmNv
bT4NCj4gPiBEYXRlOiBNb24sIDI0IEphbiAyMDIyIDA5OjI4OjU2IC0wODAwDQo+ID4gU3ViamVj
dDogW1BBVENIXSB4ODYvc2d4OiBmaXh1cCBmb3IgYXZhaWxhYmxlIGJhY2tpbmcgcGFnZXMNCj4g
PiBjYWxjdWxhdGlvbg0KPiA+IA0KPiA+IFJlbW92ZSBpbXByb3BlciBwYXJlbnRoZXNlcyBmcm9t
IGNhbGN1bGF0aW9uIGZvciBhdmFpbGFibGUgYmFja2luZw0KPiA+IGJ5dGVzLiBXaXRob3V0IHRo
aXMgZml4LCB0aGUgcmVzdWx0IHdpbGwgYmUgaW5jb3JyZWN0IGR1ZSB0bw0KPiA+IHJvdW5kaW5n
Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEtyaXN0ZW4gQ2FybHNvbiBBY2NhcmRpIDxrcmlz
dGVuQGxpbnV4LmludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgYXJjaC94ODYva2VybmVsL2NwdS9z
Z3gvbWFpbi5jIHwgMiArLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9z
Z3gvbWFpbi5jDQo+ID4gYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gPiBpbmRl
eCA3ZWQ2YTFiMTBjMjEuLjEwYTZhZjg5YmY2NCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9r
ZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9t
YWluLmMNCj4gPiBAQCAtOTIyLDcgKzkyMiw3IEBAIHN0YXRpYyBib29sIF9faW5pdCBzZ3hfcGFn
ZV9jYWNoZV9pbml0KHZvaWQpDQo+ID4gIAkJcmV0dXJuIGZhbHNlOw0KPiA+ICAJfQ0KPiA+ICAN
Cj4gPiAtCWF2YWlsYWJsZV9iYWNraW5nX2J5dGVzID0gdG90YWxfZXBjX2J5dGVzICoNCj4gPiAo
c2d4X292ZXJjb21taXRfcGVyY2VudCAvIDEwMCk7DQo+ID4gKwlhdmFpbGFibGVfYmFja2luZ19i
eXRlcyA9IHRvdGFsX2VwY19ieXRlcyAqDQo+ID4gc2d4X292ZXJjb21taXRfcGVyY2VudCAvIDEw
MDsNCj4gPiAgCWF0b21pY19sb25nX3NldCgmc2d4X25yX2F2YWlsYWJsZV9iYWNraW5nX3BhZ2Vz
LA0KPiA+IGF2YWlsYWJsZV9iYWNraW5nX2J5dGVzID4+IFBBR0VfU0hJRlQpOw0KPiA+ICANCj4g
PiAgCXJldHVybiB0cnVlOw0KPiA+IC0tIA0KPiA+IDIuMjAuMQ0KPiA+IA0KPiANCj4gU28gd2hh
dCBhYm91dCBzZ3hfcmVjbGFpbV9wYWdlcygpIGhhdmluZyBubyByZXR1cm4gdmFsdWUgdGhhdCBI
YWl0YW8NCj4gcG9pbnRlZCBvdXQ/DQoNCkknbSB0YWtpbmcgYSBsb29rIGF0IHRoYXQsIGFuZCB0
ZXN0aW5nLCBhbmQgd2lsbCBzZW5kIGEgc2VwYXJhdGUgZml4Lg0KDQo=
