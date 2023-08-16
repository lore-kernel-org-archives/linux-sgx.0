Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0ACC04FDF
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Aug 2023 10:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243783AbjHPKOw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Aug 2023 06:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243800AbjHPKO2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 16 Aug 2023 06:14:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607522735;
        Wed, 16 Aug 2023 03:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692180826; x=1723716826;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cop6fWAejRnzVYTHXiHeZPAu60MUnkvpNaf/tt1KwYU=;
  b=Xx9KOtyLn9VtjROFPVqf9EXrPf1QYCjBj1TksvJBj9ZdWn78hGveq0D+
   IF2BqiJtaxpCsxbprUj+AGJElHibkHlBsvDzAHdP+N9TPWKYpfPAp9E13
   HxAsU0vilEeB679HxqNT+tuvqbzycNjL+YaqYiQ0vvIR+EPGOiPDjR7o7
   UMcqPiZIQAC2hTSSjv1z6b6qZh03ms3eyiV4PPYv2krdm8cYuN2EWBiAb
   NDf6PLUPe/kHZNyXIoglnMCHPkbv2+pf9URc/fM4bxBU2jOpIQmzAQ8di
   2+c/g+50Kv2zom2d+l10mKEPU9IFwdmOByshTyUXOAsDn514MrlNFFs+k
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="362646454"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="362646454"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 03:13:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="877727838"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 16 Aug 2023 03:13:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 03:13:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 03:13:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 16 Aug 2023 03:13:45 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 16 Aug 2023 03:13:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mh+ma8g8NPlUYKBrrgq9HAKWS8RrdUkmG551nfEjcDjuZQdbcufJBUHGAH4KId7cxcSW4cLk9aAaDyBKh4s6Je+dEj4uXCTaDyK5ME9XgZEN3q8rp/yVrxGUYjTB1UOa7WyqMzJR8/8J8cJXXY7yKHYdi6yV21VBMtzGMTFSmxXEaBNVHeBpeF/WSw64TQz/H9Zb2gr13dnArWwzMTqiPC3+4ga02sqQfgcYLktvWoQpy+YOCzvARD5l1NRbre5M1hedKKPlaOUvNXrJC/CzPwCiQ/sH/yk7iYiWuwTF7FyRcwKkgznBmTuwcGSEC2oO/RLd46KFXG8BNgLzCgmJuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cop6fWAejRnzVYTHXiHeZPAu60MUnkvpNaf/tt1KwYU=;
 b=ETswL0cfywLMvnJEhbZnemVY3gJ5ZLaaMBf/YI2lr43w9LUGV2WCnnJd0MAtKtLF43k14B4GNWDcXZlAfaF+sRoWGi6P7srOIhwEWp35hXVloNyy4XaoUXeMBNlvoV5jhXs4GzXnDHxOPQZFQlrZ1yKnjS3PfUJ5f+Qepbfp0+Wryq6evrk4mvunRs0niMNmIl6VCblUdqc8woOkahpQdEEC4Nwzve462KeyjhArHKWqE34PYnDTdwhjLPS2C7HFHMWGVopkc4Uy+HRQiHmXFJVcjSeNcwON4I4oJcxHVaZSLmVKYfeCm+zooR6LwAhSTHvVwGkIPU/wAOYnt1MJwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB7737.namprd11.prod.outlook.com (2603:10b6:8:e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Wed, 16 Aug
 2023 10:13:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 10:13:43 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jinpu.wang@ionos.com" <jinpu.wang@ionos.com>
CC:     "yu.zhang@ionos.com" <yu.zhang@ionos.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
Subject: Re: [PATCHv2] x86/sgx: Avoid softlockup from sgx_vepc_release
Thread-Topic: [PATCHv2] x86/sgx: Avoid softlockup from sgx_vepc_release
Thread-Index: AQHZz6Wxc2hxtuiR9UyvW3/XfrWkdK/stVwA
Date:   Wed, 16 Aug 2023 10:13:43 +0000
Message-ID: <3b93dfa438fb2f42f917393c3752ffc2dec35e52.camel@intel.com>
References: <20230815182258.177153-1-jinpu.wang@ionos.com>
In-Reply-To: <20230815182258.177153-1-jinpu.wang@ionos.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB7737:EE_
x-ms-office365-filtering-correlation-id: 2c4e981b-6e15-4e56-699b-08db9e417877
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ds/jWb8A3E7ua2pyHx9y3HmjTD4ljPcNYWTUlYXjjSuaVyivev7Nq2Dgpreg9rVB8xmkYWHminzOj7N7g81QUYV5sy1g6WljjYA6Vzh9xD2PpU+c8pzMuz71+oY7t20/DJQDhBuKzWBailUkCPTynXH2TvzA773k6twF1DfE1kGD5p4IZLlMsbg2CcNAmORpLw+qJf+pwgXqwmUrkFDOK1BM1vSUmr6yJubcb+Lmjtlw4XVyB3TM3ijB7UBOTGrR9TMjrCyI1waSPm6iLDemMow1mCurLvA1UwpZMitAOwZP9fY2JgODwbZcaM+3oW/+fP0iXLnf4er2XzvB8u9vcmJ4cP470gm/5MVK+Xek81BCwNcur1f/hnGAbH2ty/taLCrVsWkrM4VzSIqQlctMGAVc6v+vxJwLWqgNyFJr4Iv/zwD4x+cm6iGFxjlEwBsRkUmmo95PJZY4612qKXboj19PjTSvHoDalwsUfoISELP6L/LOmB0fdrXHvV/o8MffGU5xymskqio0cb3WWo6Ei+T4Lg+lzusku2K4ewFNtHs59544PLhrPsc40tOdT/j2A2lW64NS6hv23SNSfwmK0d5zmgbM4F1K1iueR3ZOvOI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(136003)(396003)(39860400002)(1800799009)(451199024)(186009)(2906002)(83380400001)(86362001)(478600001)(6506007)(36756003)(6486002)(2616005)(71200400001)(6512007)(26005)(966005)(5660300002)(41300700001)(122000001)(54906003)(316002)(66946007)(66556008)(66476007)(66446008)(64756008)(110136005)(91956017)(76116006)(8676002)(8936002)(4326008)(82960400001)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjNCTW9wQkhKR3BuNkllTnNqWlgyVlAyOFJQRFcwNjZrZFpKTSs3dWJ2eDNr?=
 =?utf-8?B?V3VaRFh2MjUvMDZnc3IwenZyL0UrZU9IZjc0YnFCeER6K1lWeFpzM092ZzNm?=
 =?utf-8?B?U0FkSVFrU3pzbExEdUdXV3Y4SUZORGl3by9IT2ZMemdKM1lVdmhTT3UvTkdk?=
 =?utf-8?B?dHR0b2NnOTlJOEpiN2RaVVljaGNKK01TTjFNWUdmZzdCMDBTVHA0SDdvd0tO?=
 =?utf-8?B?ZDZtQ2Njc2xicWFTMTV5bUVaYmFqb096TTZEK1BvRVJCa1dDM1JDenFZc3Ez?=
 =?utf-8?B?NWh4b3FuS05xOFlnazhxQ3owMWMzdWpaazNSbGpZRkM4ZGpaWFZxWU5UT044?=
 =?utf-8?B?SjQ3RXlNYk9IL051OS9NRVJrMGVGOUEwN2doOFRpa2R4clB6MDdGMnVYQUNL?=
 =?utf-8?B?aU1BNkFzMXZqd1VtZlBTSnJIQlpNYWFlUVZKY3FTdTFLR3ErVy9nM2lxNkdq?=
 =?utf-8?B?OU04RVVSWmEvOVJNYkpmZDdzbDdtZ2dDcTNPa2F0YkRSbmtRcVlKVW1jbEZ4?=
 =?utf-8?B?QWphb2ZkUFg0S1ZkUHFLTmI5RldkTUQvMjkyU1BQT21RVzM4MTkxTHZXZWR2?=
 =?utf-8?B?aTlGQzdRYVdSNTU4UjFtT0hlYVIzNjB6aUZ3TmxsV2dYazdyN2hSMzBPQkhn?=
 =?utf-8?B?SXJLVDArNHpqSERZZVdDUGVLVHF3ZUNMajRBTXpoeWN1RDVqajdxMmZwWnJj?=
 =?utf-8?B?SDVLaWV1N1dDcjRxMjRLRThVNkMwQ0F4OUwrVWFQcjZVMld6Ni8ybWpHaFVx?=
 =?utf-8?B?cmtibDhjSzZDSkNIRjVxbXdYVEZBOHFnU3VxMU5mK0RxTWh3ejAzYmthb3FJ?=
 =?utf-8?B?NVYwQmY2QXc5YVVUMDl5alEreEZZM2ZGS0lzR0FoendweXJRUVVMSnRQQ3Bl?=
 =?utf-8?B?MERjVzJSWXh1MU96YjEwNElYRFJnV1R4SWdmNURmbjdDQTVkRXlkMnZvcmFK?=
 =?utf-8?B?SzlHc08veFdLazNhZzZUUFFpdU1ZK0xRUmFVL0hjdmNyZjRkWWFjQnBpVEIy?=
 =?utf-8?B?TnpHeW1NMkJRQlkyb0RSeG56SkYyVGJRNlFqeU8rYlRVV0JSUzZKeGVYYThU?=
 =?utf-8?B?cENveUF1Rmh1Q3lQWW9RRFErWUVwR2tSNFdWeUNzcVFyNzVqYnlFS1Y0dlE3?=
 =?utf-8?B?QTJLVkdSaVhkKzZJajVLd2VCcjk0T09GSGN3VUdDWGdRc1puRzNUZURIYStj?=
 =?utf-8?B?aE8rTlg2THp5NElkZlNCNWszZHZpWWRuemRFS1I0RFZ6b3lQMTZXZDFMTzdr?=
 =?utf-8?B?UmV0dXpIWEZFcE1sQWd3ZDFDOVljL3Z3N3NocitTSFZnZzhjbU9FNjByRDI2?=
 =?utf-8?B?QVJwa0t2YW02QTBqdXBHN3pERk1RV05YUGRUMUtaaVdaQ0FXSml1NmZpSGZL?=
 =?utf-8?B?Tk1NTjFCcXJCNVBVM2F3YW9ma2hBeDh2d1V5UFQyZEppTmhWNk81QUlsWXpW?=
 =?utf-8?B?T29YWU1qOTcwTnZ6YkpIYVhrUURhc1VwVlhEQjgwZUc5Z1Byek9vdUt5am1w?=
 =?utf-8?B?QzZxV2c0UitOOE1zdVpMQ1diRHFnem9TS2ZBaWExM1JNL1NDYWI4dVZ1SHNJ?=
 =?utf-8?B?c1JuRGprbVI0WlNwMTVCaFVOeGZkYVlCZ2VVbW12K2NmczB3TFdabFgvRjNB?=
 =?utf-8?B?eVV5dnEvUUtlMER1REk1UWdUbG9BV0JuaUdlR1VSemJxZlUyTnZGOWxoQlN6?=
 =?utf-8?B?UFBOTElzQmVDQ0ZGRGlEN1Rpc3g1N1dSSkFHbXZxSFpKSEZJOEpyVDVrMk9y?=
 =?utf-8?B?THZ4REJrMVZseVV5c0lCbzIxUHZMSUlCczFNK1BWRlN6QVltU0RGYWg2aERq?=
 =?utf-8?B?UGRhZEd0WUY1WVNhV28wcVZTeml3eGVHYmNVcVAzL3padEtKLzdLamVIR1o0?=
 =?utf-8?B?aHIxTG82RFVDVEY1emVXS0pxOTBkcDJjNlB5Y3lxbjBjNVE3eGlQQWxrbmdx?=
 =?utf-8?B?QnV0VzRTTlY0dnVIYUVPMXl3T0ZNTHZVQXNEQ1JZQWlsT3h0UWtJQVNSem0v?=
 =?utf-8?B?RUJmeHlJelA3dW10Ynl4M3F5bnA5eXNXZ2FDZXRTWWh0eDU2UXZHMWswcEs3?=
 =?utf-8?B?T2FlcllyaGdWSzB5Q0dBUm5RMytkVStQVi93bmg3Y2dZQTlMQXJsNFNtTWxB?=
 =?utf-8?Q?0vTITn/dVO20IejftoisXZs1i?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A89C474CF8E804C96F28528F95FD2CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c4e981b-6e15-4e56-699b-08db9e417877
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2023 10:13:43.3746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oku6i+3bED30oHwdz4iSrNc3MjX83kJAaZ/eB0AF2SGAgbHMvhJe+4Wn0kdoxLwegmQEjBhqRo+gi9WbdZte1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7737
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVHVlLCAyMDIzLTA4LTE1IGF0IDIwOjIyICswMjAwLCBKYWNrIFdhbmcgd3JvdGU6DQo+IFdl
IGhpdCBzb2Z0bG9jdXAgd2l0aCBmb2xsb3dpbmcgY2FsbCB0cmFjZToNCg0KUGxlYXNlIGFkZCBh
biBlbXB0eSBsaW5lIGZvciBiZXR0ZXIgcmVhZGFiaWxpdHkuDQoNCj4gPyBhc21fc3lzdmVjX2Fw
aWNfdGltZXJfaW50ZXJydXB0KzB4MTYvMHgyMA0KPiB4YV9lcmFzZSsweDIxLzB4YjANCj4gPyBz
Z3hfZnJlZV9lcGNfcGFnZSsweDIwLzB4NTANCj4gc2d4X3ZlcGNfcmVsZWFzZSsweDc1LzB4MjIw
DQo+IF9fZnB1dCsweDg5LzB4MjUwDQo+IHRhc2tfd29ya19ydW4rMHg1OS8weDkwDQo+IGRvX2V4
aXQrMHgzMzcvMHg5YTANCj4gDQo+IFNpbWlsYXIgbGlrZSBjb21taXQNCj4gODc5NTM1OWUzNWJj
ICgieDg2L3NneDogU2lsZW5jZSBzb2Z0bG9ja3VwIGRldGVjdGlvbiB3aGVuIHJlbGVhc2luZyBs
YXJnZSBlbmNsYXZlcyIpDQoNClBsZWFzZSB3cmFwIHRleHQgcHJvcGVybHkuDQoNCj4gVGhlIHRl
c3Qgc3lzdGVtIGhhcyA2NEdCIG9mIGVuY2xhdmUgbWVtb3J5LCBhbmQgYWxsIGFzc2lnbmVkIHRv
IGEgc2luZ2xlDQo+IFZNLiBSZWxlYXNlIHZlcGMgdGFrZSBsb25nZXIgdGltZSBhbmQgdHJpZ2dl
cnMgdGhlIHNvZnRsb2NrdXAgd2FybmluZy4NCj4gDQo+IEFkZCBhIGNvbmRfcmVzY2hlZCgpIHRv
IGdpdmUgb3RoZXIgdGFza3MgYSBjaGFuY2UgdG8gcnVuIGFuZCBwbGFjYXRlDQogICAgICBeDQoN
CllvdSBhcmUgYWRkaW5nIG1vcmUgdGhhbiBvbmUgJ2NvbmRfcmVzY2hlZCgpJywgc28gcmVtb3Zl
ICdhJy4NCg0KPiB0aGUgc29mdGxvY2t1cCBkZXRlY3Rvci4NCj4gDQo+IENjOiBKYXJra28gU2Fr
a2luZW4gPGphcmtrb0BrZXJuZWwub3JnPg0KPiBDYzogSGFpdGFvIEh1YW5nIDxoYWl0YW8uaHVh
bmdAbGludXguaW50ZWwuY29tPg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBGaXhl
czogNTQwNzQ1ZGRiYzcwICgieDg2L3NneDogSW50cm9kdWNlIHZpcnR1YWwgRVBDIGZvciB1c2Ug
YnkgS1ZNIGd1ZXN0cyIpDQo+IFJlcG9ydGVkLWJ5OiBZdSBaaGFuZyA8eXUuemhhbmdAaW9ub3Mu
Y29tPg0KPiBUZXN0ZWQtYnk6IFl1IFpoYW5nIDx5dS56aGFuZ0Bpb25vcy5jb20+DQo+IEFja2Vk
LWJ5OiBIYWl0YW8gSHVhbmcgPGhhaXRhby5odWFuZ0BsaW51eC5pbnRlbC5jb20+DQo+IFJldmll
d2VkLWJ5OiBKYXJra28gU2Fra2luZW4gPGphcmtrb0BrZXJuZWwub3JnPg0KPiBTaWduZWQtb2Zm
LWJ5OiBKYWNrIFdhbmcgPGppbnB1LndhbmdAaW9ub3MuY29tPg0KPiAtLS0NCj4gdjI6IA0KPiAq
IGNvbGxlY3RzIHJldmlldyBhbmQgdGVzdCBieS4NCj4gKiBhZGQgZml4ZXMgdGFnDQo+ICogdHJp
bSBjYWxsIHRyYWNlLg0KPiANCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3ZpcnQuYyB8IDIg
KysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC92aXJ0LmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L3Nn
eC92aXJ0LmMNCj4gaW5kZXggYzNlMzdlYWVjOGVjLi4wMWQyNzk1NzkyY2MgMTAwNjQ0DQo+IC0t
LSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3ZpcnQuYw0KPiArKysgYi9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L3NneC92aXJ0LmMNCj4gQEAgLTIwNCw2ICsyMDQsNyBAQCBzdGF0aWMgaW50IHNneF92
ZXBjX3JlbGVhc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpDQo+ICAJ
CQljb250aW51ZTsNCj4gIA0KPiAgCQl4YV9lcmFzZSgmdmVwYy0+cGFnZV9hcnJheSwgaW5kZXgp
Ow0KPiArCQljb25kX3Jlc2NoZWQoKTsNCj4gIAl9DQo+ICANCj4gIAkvKg0KPiBAQCAtMjIyLDYg
KzIyMyw3IEBAIHN0YXRpYyBpbnQgc2d4X3ZlcGNfcmVsZWFzZShzdHJ1Y3QgaW5vZGUgKmlub2Rl
LCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gIAkJCWxpc3RfYWRkX3RhaWwoJmVwY19wYWdlLT5saXN0
LCAmc2Vjc19wYWdlcyk7DQo+ICANCj4gIAkJeGFfZXJhc2UoJnZlcGMtPnBhZ2VfYXJyYXksIGlu
ZGV4KTsNCj4gKwkJY29uZF9yZXNjaGVkKCk7DQo+ICAJfQ0KPiAgDQo+IA0KDQpDb21tZW50cyBp
Z25vcmVkIHdpdGhvdXQgZXhwbGFuYXRpb246DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xp
bnV4LXNneC9vcC4xOXAwMTFwYXdqdmptaUBoaHVhbjI2LW1vYmwuYW1yLmNvcnAuaW50ZWwuY29t
L1QvI21mMDA0ZGViODFmOWViMWVhYjdhZDNjMWM4ODc0NmJmYTIzZDUxMDljDQoNCg==
