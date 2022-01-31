Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4EAC4332F
	for <linux-sgx@archiver.kernel.org>; Mon, 31 Jan 2022 17:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381072AbiAaRkT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:40:19 -0500
Received: from mga05.intel.com ([192.55.52.43]:56303 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381065AbiAaRkS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 31 Jan 2022 12:40:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643650818; x=1675186818;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=agG9oBSKvjQaqt79sctP7jqAz8Ry8r0ZjEkZMKv82Ss=;
  b=OK+lr1TmthZHGdx/DcLp5E6i4IVgiYbaHzssBXXSaMR7pbTpo52TYMs7
   gkkE5i75/stGxd+NDzauINr9ToJKLV3nEcG9gbjvckSX0H2Z6yzJsY/JI
   bjO6GjdXc4H2Z5AAYjdJWhV8CQmUn3jxXOXkxaP4iMDcu5FA1ZNdh1HSy
   qeyY7XjsMrzuOoynoN+fEcMNg32CbSVbKCMLMU9CtOXP2L93x8cI0Kv8d
   5pWwojRtOLNjdXiyxLpeciqwNiKb/O0TaDPqpPnKnvlF0gWCIs5tpjjsQ
   7oLMyuJMTXVNEWECHCo8KltX/B3IEUeO0F1fWfyJQ+3gKXpmNy1g4rmY+
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="333869176"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="333869176"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 09:40:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="497000815"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 31 Jan 2022 09:40:16 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 31 Jan 2022 09:40:16 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 31 Jan 2022 09:40:16 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 31 Jan 2022 09:40:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7i/3ny8/YsAW7LRm2PCZv7yTCE9nXw8tB6RGJuyuYhyiXgkTYJS8vvdWAYwXCNdwlshJyXOJN6iZAz4EWPmbi38qUUV34NSdMxP6/Ju1fMxACAKYKOD4Mhq0fy6w5oRojHx0opWwvqbn9IQ7j1rmS+30Ve736150ok9uH8SHgNHGSMrBGDTSu8s84baCk4ha8ZUY3kUf3ev1etBAWDikkXTQEpSo70m2+MQWdyPQsn+Ghnae72Q3jBgbIKrWeUYN3AwS5BvwmXyK52nBpImdlBxYthvHx4P4HQ0fZiJizxMbxcz6R8dA5I1Zq7CWq6fst1QsTbw2zq0D5UaxVJFYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=agG9oBSKvjQaqt79sctP7jqAz8Ry8r0ZjEkZMKv82Ss=;
 b=BGinmU/RrzGLwdDUSIaJXEYdg1L9xsA/fe2ozHyZBKW5478Y7PyS7EidOLcGZ4PvJ9sPeJiCA//aCwdBxkvIN7toQK5c1bya2PX/43RwvpdEOoY7zVd8TP3fSTPgb8MrZ2yt8KX89juLOTmq8vhDC24DgWD8KdN4qszi23hnV45JxaH1qc19U+ehSJ8seWnxwk2OrCcHGf48nrHHf8oFvJYZKp3SGhc4xUG421jTZYdOJqWgXU55LWd+JNro5/QZxhadCw8ufQR7XcczPu6QJeAUYyi/12RhxUEWXsJimCKeL8qwYJdyo71jd2k3OFXu64DmxTh+Pn8UK5rECVs31Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SJ0PR11MB5069.namprd11.prod.outlook.com (2603:10b6:a03:2ad::6)
 by SA1PR11MB5922.namprd11.prod.outlook.com (2603:10b6:806:239::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 31 Jan
 2022 17:40:15 +0000
Received: from SJ0PR11MB5069.namprd11.prod.outlook.com
 ([fe80::790d:e24d:589c:80a]) by SJ0PR11MB5069.namprd11.prod.outlook.com
 ([fe80::790d:e24d:589c:80a%4]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 17:40:15 +0000
From:   "Accardi, Kristen C" <kristen.c.accardi@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "anakrish@microsoft.com" <anakrish@microsoft.com>
Subject: Re: [PATCH v3 1/2] x86/sgx: Add accounting for tracking overcommit
Thread-Topic: [PATCH v3 1/2] x86/sgx: Add accounting for tracking overcommit
Thread-Index: AdgT5goRrUm3pX5+QG+mFKVsbXdXLgC44+eA
Date:   Mon, 31 Jan 2022 17:40:15 +0000
Message-ID: <75c5aa1a25acaf32a3bd89d62f59f892b676fa90.camel@intel.com>
References: <DM5PR2101MB108074567B5D75229FFA6D23C4229@DM5PR2101MB1080.namprd21.prod.outlook.com>
In-Reply-To: <DM5PR2101MB108074567B5D75229FFA6D23C4229@DM5PR2101MB1080.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d60aea4-8a51-4732-5b20-08d9e4e0bd6b
x-ms-traffictypediagnostic: SA1PR11MB5922:EE_
x-microsoft-antispam-prvs: <SA1PR11MB5922E73FCDFA01F2F739F0F5AF259@SA1PR11MB5922.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kcvHkYjuBWvGAESdQfPT1f4uDVor+jOLXBRXeC1SrEn2h/aTSZ+eoShZ6HaB7259Gnpvf6dK3dnZR8363BvsxnVkOptsYigYtE7rVsZAoJPmBtjgBNf7VL4RsQBEe/1nO68aFtxzaOLRViLBDo6UICfS80ZsGlKKuiQV4qbngnASohkoiZZ/eVAYjccC5q2hz4J4VcOteZdgIyGmDTig9UEPb2cBZymAGgTZVhhPD0q3pcr0rHts9GE+xQDCc+OxBKGDQeOtwbmjSpKQqRlvjhZn3L9pmKojWPI+P7c5ntrkfE323mIFK7w+PYnRdFVaXJSuAGPchVUfZrGW1bNa8zly6k/3cYO3MwckCxGluT8MEqKorO5HFbT4zyrltH2unuZL1wcPftUSEdbvM92qqJ9tfSDD+/h41EzMq+xozh7Eh9Sn139tvyr+eEarWMIYHZBKARX89kLBk3cXFXBk0QuTumSMF7wZXjsBurmKTXoTwdKxFuFTDexA5eoyktFkFHB3Vn/o9vLNXwpDiVVlRWnxlZd3ieyTQO3HWtyftM7R4eYDv2wrTT10fvDQ4AmGgmJLjhtnsNOs5JumtZFnk5nh9S3p/+GDDOEG9NrzeumL7WGCpAZdcTzdK48AWvilVW6I5s5JJXQ9pn0Em8ZLj7hf+N4dsAyj/Q7nstfy5nfPIAjqdXC4HR9UfK6cuTzqG5FFw7098IxAsECkQEk19A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5069.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(66476007)(122000001)(6506007)(38100700002)(508600001)(26005)(186003)(82960400001)(4744005)(8676002)(2906002)(110136005)(86362001)(2616005)(36756003)(83380400001)(8936002)(316002)(38070700005)(76116006)(91956017)(6486002)(6512007)(66556008)(64756008)(66446008)(71200400001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VThOT0NKR2Z3ZmdmbFRhQlk1eldBbno5NHZsSTZZOVMrSFk3VHZKQnZ2dkRF?=
 =?utf-8?B?eWlzemdHSjhJajNLODVDYjIyK1B3NzlOd1hzUHoxR2pCTjBLeVJjVGJFeHJU?=
 =?utf-8?B?M1pWcThLR0c1enlpVHk4Y1ZLN2JQY294ZDErZ0prVEwvVlh2YXFua2hoNy9S?=
 =?utf-8?B?dVdCWDk1ZWdDY1RKbGtyUTh5TlFGeTRRWDBXbnk3Ykt1Y1pNUmhUZmtQTHRV?=
 =?utf-8?B?MUp6VTV2REVtVkM4Tm5NQU54MG9nMUxpcDdMU2svM2xNNjIzWmN6ZTloU1Br?=
 =?utf-8?B?cnkwOXNmdDh3UEQ3SFZmVVpPVE5FVURTT3VlMGMzcmVqY3NGZDg0SGJkZ1Va?=
 =?utf-8?B?SXFHcGdNVGtxWGx0WUZxbXNZclRnZkdodXdBYmZtNXF3TkF5Vml0amZ2Ukhi?=
 =?utf-8?B?UlE5cVM5ZXE1MG9nYTFTNTJlQmg3ZFVlc0xKZ213MmFSRFM4ZkpSOHpFcnBP?=
 =?utf-8?B?VjhxeFhlN2pHM0UxMHpvdjg5RkVuc3lrSnRlNVFWRmFZUXkvSktNdHlhZUFT?=
 =?utf-8?B?bTdlTDIzdEl2VXdaK3o5a1NjZkNJemlpNkoxWUdBWkZxYTJ2R1VrcUhqdHpN?=
 =?utf-8?B?bmhBU0RNekdoZWxvVE13ZmlwekZyVGYvSEJqQyt6Zy9lR3VCWnUvVUdFM1hm?=
 =?utf-8?B?MmRwd3d2K3J1L1JhWEtubVMwRkoxU1NTZmlMY1NsSlBhVjJJRytvMTJla1Mv?=
 =?utf-8?B?ZUxGWUJBTjFyUVJOdUk2SVQ5VEM0QzZYUmZFL1ZvS1hJQXdkNHRwSVo2RDdh?=
 =?utf-8?B?QllEbWJTUTdxVW9ReG5VRmtGRDV2MFJIU2hyM3pJOEYxOEZwQ2ZMa0dVTjVY?=
 =?utf-8?B?ejNmRk9PRzAvbUZEWXk5S2dEamo0NzRuY29jb2t2d3NJbTh5Tll1eWozUnJK?=
 =?utf-8?B?UDh1NHJhbGJPaGRERUhSZGtrdGIyRXBlVmJUbWZrSzJ6MmVmc01mc2VEdXAz?=
 =?utf-8?B?akVSM0lSNkFpRVNDRzJBQ3E1amxVVlF2YWZCbTRIYmdEeXpoN0RCUUR0emg3?=
 =?utf-8?B?V0NlclRvSWc3Z0FHdzljVE9JUTNtd21UZmZVVUdQVDhGR1FVS2NnRk50b09C?=
 =?utf-8?B?dkVRaU9NTmNxeTJTd2xEK2dJWHZLTTE1cUxHQ2VrTGVMbkNUSmd2aFhERjRn?=
 =?utf-8?B?aFB2aThNZkowR3dtelVld3laWnZLdU5OQldwTGUwR2gwakkrcTU3djd5VmdN?=
 =?utf-8?B?WW1lUVI4WDR3dzJOMzFvVWh0bVZQeC9xbzA1dVJWZDhmdVNWT0xjY1B5K21P?=
 =?utf-8?B?RWRLdm5rcExVZGdKR0UzTi9OR2ZZckNla2FJdHJhdzFzNmdLdjhXVlBFMS9S?=
 =?utf-8?B?U2ZDZ2krbW84cTU3KzFSa01zWUkxSkFReTBOMWh3WWtkcWN2MHFnb2MydDJi?=
 =?utf-8?B?ekRnaUdSVks3Q3U3SG45Z1BrWnJ1TS9uUVkzUVgwUlNsMVZmd2J0SE1uaEhk?=
 =?utf-8?B?Vy9XYXRKVkhzQjgwd0VveGMwS1FkNEZVU0crR2JIc2xBSEs3VW5kamtIUFBU?=
 =?utf-8?B?VnI4aGtzRHJFOVd3U0VUTmUycGtZTmNwSEt0WkRyZkN1K3JSdklGVzRwUFYx?=
 =?utf-8?B?T0VKY1BIZTRjSU14ckozR29DVmo5ZFFhcGxiRGUyTlY4NmsrZzdaZGI1S1VH?=
 =?utf-8?B?elUrSmdMQ1dHNzFOSWRkN0ZBN0FJYzJ0Qmpram5aZTlQWnlEbW1RWGFHeFVt?=
 =?utf-8?B?N1cxQjRzSVlvLzFOWFlHZVg2aWpOVkwrMURicWJkeHBkR2pmeXNBc1hxUnFu?=
 =?utf-8?B?bzRjTWNXZjlsQ0NPcXlueWhMTjJxVG95OWUwbyswQm1sZlY2VThqamtTWEdD?=
 =?utf-8?B?NGdGenEzQ0RWcE9tbi9IQWhZZzlnZFpvL1I3RHVUT0trYkVCZjB0ZUs0WFpi?=
 =?utf-8?B?S09DOVp5RHVMWlNwSnVnUHJMbXVkc3BjZ0IvZHRUemFRYjVvT1JpVGlaWUJV?=
 =?utf-8?B?bGUzeUVxelRURy9rSnhCNU8weCtXMzJyTVdneEpscGwrSXRpV0F4NllHamlt?=
 =?utf-8?B?SENSVzNxNVpSVUZWaWNUMGNsdnBvU1hVaTkxSFdHOEtTeEgzb0FDOThkbitT?=
 =?utf-8?B?VEV3U1lrN243UGV4bmZ6MkF0VUYzUEFrYmdYV01icU1qK3hYcnVNUENsbDlm?=
 =?utf-8?B?UkRSN1lwREZkc0xFcFhWRy81MVZ2czI1NlJCZWpJKzR2UndydWx3dHJjcHNH?=
 =?utf-8?B?a0ptQ0xOQm5VUzh3bitRQXRXZkh4L0pUOHpyQ1diWlJlQ0hrQkw3Tjd2L1k4?=
 =?utf-8?Q?pmvY+drkEpn9jcdGHnEidGTlHFdH4iXJY4B77nsKFA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AEBAEF73DBEF6B4CACC4FD3B727F1FEA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5069.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d60aea4-8a51-4732-5b20-08d9e4e0bd6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 17:40:15.0591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NkKXwHcazcRLHjrFK2JjOK5gb1z3kQlmnTZfRgtlcXMXBtSGTJplvUqYZ5i82riH5kaNfIsmJy1xa4J41tW8zKQX5asYKV9HX11G+EUhvR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5922
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gRnJpLCAyMDIyLTAxLTI4IGF0IDAxOjMwICswMDAwLCBBbmFuZCBLcmlzaG5hbW9vcnRoaSB3
cm90ZToNCj4gU29tZSBvZiBvdXIgdXNlcnMgcmVseSBvbiBFUEMgcGFnaW5nIHRvIHJ1biBlbmNs
YXZlcyB0aGF0IHJlcXVpcmUgR0JzDQo+IG9mIG1lbW9yeSBvbiBDb2ZmZWUgTGFrZSBWTXMgd2l0
aCBsZXNzIHRoYW4gMjAwTUIgRVBDLg0KPiBXb3VsZCB0aGUgMS41eCBFUEMgYmFja2luZyBwYWdl
cyBsaW1pdCBwcmV2ZW50IHRoZXNlIHVzZXJzIGZyb20NCj4gcnVubmluZyB0aGVpciBlbmNsYXZl
cz8NCj4gDQo+IC0gQW5hbmQNCg0KSWYgeW91IGhhZCAyMDBNQiBvZiBFUEMsIHlvdSdkIGJlIGxp
bWl0ZWQgdG8gMzAwTUIgb2YgYmFja2luZyBwYWdlcy4NClRoZSBnb2FsIG9mIHRoaXMgcGF0Y2gg
d2FzIHRvIHByZXZlbnQgdXNlcnMgZnJvbSB1c2luZyB1cCBhbGwgdGhlDQptZW1vcnkgb24gdGhl
IHN5c3RlbSB3aXRoIGJhY2tpbmcgcGFnZXMsIHdoaWNoIGhhdmluZyBHQiBvZiBiYWNraW5nDQpw
YWdlcyB3b3VsZCBkbyBwcmV0dHkgcXVpY2tseS4gQSBtb2R1bGUgcGFyYW0gd2hpY2ggdGhlIGFk
bWluIHVzZWQgdG8NCmFkanVzdCB0aGUgb3ZlcmNvbW1pdCBwZXJjZW50YWdlIHdhcyBwcm9wb3Nl
ZCB0byBoYW5kbGUgY2FzZXMgbGlrZSB0aGlzDQp3aGVyZSB1c2VycyB3b3VsZCB3YW50IHRvIGRl
dGVybWluZSB0aGUgbGV2ZWwgb2Ygb3ZlcmNvbW1pdCB0aGV5DQphbGxvd2VkLiBXb3VsZCBzb21l
dGhpbmcgbGlrZSB0aGlzIGJlIHVzZWQgYnkgeW91ciB1c2Vycz8NCg==
