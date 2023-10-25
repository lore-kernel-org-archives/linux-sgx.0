Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2CDC0032E
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Oct 2023 23:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjJYX6h (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjJYX6g (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 25 Oct 2023 19:58:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BF0A1;
        Wed, 25 Oct 2023 16:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698278314; x=1729814314;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6FzDBOlusjuUJIQMw6nuE7N6bK6/weEKuiQRnMS3tqc=;
  b=AHmY3PVQ2c+eHB3CJFXE6TitJjNFteZZHqA/7U7USsaZ+iM3xIIQlslR
   bWgOQ0t6GvtNQgTpgaFyNiNpMe8smggs6yE50m0HSfLPCFKN87F97GQMh
   C0D1xfPosUFDwkF5ZmoxKkj2FlgA24V3q4cqKcZbC+6tD75f0z1HSY2Zg
   kvBQT1aJmSdnVuDYEwPvmTYYl/De3wWeovHE8rFsKuaeTTfZZttlEMkBA
   jSZPKeyiDVBDIwIK7OL4T4eLS9UcD0rwsZL2eqXWzqNpm+xPnwAH5QgV6
   je2gP4FT7uf6cJpOS5VdZ6BUCyvMRcjh51cxolhzJCz5ULiQeeeAGqjfk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="377792276"
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="377792276"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 16:58:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="7025447"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2023 16:58:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 25 Oct 2023 16:58:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 25 Oct 2023 16:58:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 25 Oct 2023 16:58:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fT+OS6os+RheHzhm5NZ0F9HqpjXL1xxcnYmg64uZWk7o4xxlwXTKo327ELZ6PD0DWWVnF85YI21POYmy+lQSmdKBeIxqFt3nzxnuGEVePGT2nBwa7oXz9r1FAHPWhTAN0tGr7AZOzZgmVGqVA1UmyLo6SZgEtyW9FQ1RG5x9MOunLZF0WU1+TAWhFsuaPuIRSiqZ+1WGUVtmHaa0HMVMOWvld3NGSk+4VUUDAeHTWAO0cAjwFYeMVZkzgDtSZ+WxUj5uXa04om/4OFyVTDGpl7GdErlnTFC8A9cUs5+GsYLG7ZNRymRFqRDX8+TXziGy3NaFt4B0uh1mRVKOcaYx4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6FzDBOlusjuUJIQMw6nuE7N6bK6/weEKuiQRnMS3tqc=;
 b=kT5X3QgJGJhJTYwFSrvu5mwVUv27RUuD7O2vyWXzKWH/8umDNVRG8pu1NhxcucZj5DkI5l3rxnW08DT0PcYMcZV0eJND0TiPX11ZrtYv6cVbHKyF6TgW323zsSoaveHNA8BK3tF7xK/qwYeFjU9AKd9+ekBg5FITpOCOxzfRgZFL04JjyqQTeyzlNxDJQV56blHP7YdouIkWGyZD8qyar3Z6y0HM4RclfJY/czj1CD34VTsUey3Sjk56vEVSYQystkpKZxVAojx1/ow+Wt+bh9Num4gb9AkFVAO3KYJjQkDY/vFSBx6tPSrxwUk1cEtf2PeYrsfkuv8eAaEmOM38LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by CH0PR11MB5380.namprd11.prod.outlook.com (2603:10b6:610:bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 23:58:29 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::64e:c72b:e390:6248]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::64e:c72b:e390:6248%7]) with mapi id 15.20.6907.032; Wed, 25 Oct 2023
 23:58:29 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Return VM_FAULT_SIGBUS for EPC exhaustion
Thread-Topic: [PATCH] x86/sgx: Return VM_FAULT_SIGBUS for EPC exhaustion
Thread-Index: AQHaAwC5HZkcwOUwLUG/lq0JhfdEybBamgKAgACeRYA=
Date:   Wed, 25 Oct 2023 23:58:29 +0000
Message-ID: <b389986bac0e65ce128c9553603436efdda24a58.camel@intel.com>
References: <20231020025353.29691-1-haitao.huang@linux.intel.com>
         <b8ec3061-436f-41d3-8bff-635a90774dfb@intel.com>
In-Reply-To: <b8ec3061-436f-41d3-8bff-635a90774dfb@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|CH0PR11MB5380:EE_
x-ms-office365-filtering-correlation-id: b0c6430d-877a-465b-41c2-08dbd5b64931
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6EighQ6Br9KUU45M7sVekxk8EZuZ3reSZhdz5ybNwU7Ehbz96TZplFGRDgVsuqnZYupfbxkVBLarfl+AiDuD9fCM5z8B7qajmFEfGpClIkse6uRmayZJjXKzVStsxJbLRx7U3f9oQct9LlxHSQLBkq3kv+mxD6yDGSBbOUc0F2mLcO80XkgND7ppgTiMgY4hz/D+sikyGa6Tykljj3dMrnli2PbmeoOjQJQcKhVQ6iMd4VUXG5SC39Wv3jDGTpXj0EU1xAHRMhHtZUV2Qi2GyA79OFkh+Wx9/jKztPkAnDV/VdYdzDWmDhsHzSSjV722wyCEqysyELz9/loMvJnIN4hmBazRe8voCvxkG+w7RQbgQvZFZo8tkGH/9fNF0fVTxuOE6xlT5msQQH0zDkmxwUiou3OL6vypvqO2ZKohBu/LjY4mvjf17FzVwuogcCt9Jxr84wCM4E/R0GV7msAKzFx6a0M6WOh+Ng/kOisCWPBpV+Zrh2swMoOP1i5eau0RX63ZTmfZTWpkDAa4abEDb871NKRIh6u5+XpRJQrpBjSG6BH946dvhaulUwMu0b9jGCVQ5KOkuLGpqPJIL79w5GzlLtCliC29JMBuXwbDbXs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(346002)(376002)(39860400002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(2906002)(86362001)(41300700001)(38100700002)(6506007)(91956017)(122000001)(76116006)(66446008)(71200400001)(54906003)(316002)(66476007)(64756008)(66556008)(66946007)(110136005)(478600001)(82960400001)(6512007)(53546011)(6486002)(83380400001)(966005)(36756003)(5660300002)(2616005)(8676002)(4326008)(8936002)(26005)(38070700009)(4001150100001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmdBd0Z2Rk5UVy9iclljeDlzaWJMY2txdjc1QzhNQVNPSHZPYXdYUkEwYmRK?=
 =?utf-8?B?K2tQUzYyb1NVZEdlekFnM2xLS3ZTQ0lnVm5YUGJiWER4VU1TMVNJNjF0NC9Y?=
 =?utf-8?B?T1FvME5jUWptWGdkS0tIMVlJNjVRS1plRGRtRit0Zk9XUDF2cXQyc0ljNVZY?=
 =?utf-8?B?ZEZlRWtXczdONTJpOVVRd3J0Vy82ODJBdFBjUHQ4VGpRZ2ovUmU5VFFNS1lI?=
 =?utf-8?B?U29TSEl4cng5a09QbWMwN3RrUFA0Mnc5TElTcHhNWXRwam12Y2lRNThSZUcw?=
 =?utf-8?B?L2RTaS82YXAyWnUzUGZIRjlWTnpxMlFIMGxMOHM2VUFkcFRoakVMNTFXT2pZ?=
 =?utf-8?B?TE1PTGFTVUVtbkY4a2h3bm5vd3I3WnlxQ0hzcVVYTXk2dTlFNG9YenFYd2xs?=
 =?utf-8?B?dVBoTi9oNG1ETFN4Ri82OWNDUjhIYm9EdUNIRGlRQjFQK3I5Tk5NR2xYdllJ?=
 =?utf-8?B?ZEdHeUZiQXI1SUYwQWpFQUVYbURlUEJhTHhDY3lkUVZyRk1NTWo1dzFKeEhR?=
 =?utf-8?B?N2JPdFdjRi83cDdMSDJHcUsxY3Q3SlpqYTA4VzdLS3huZ0VSeDRucGR1by9q?=
 =?utf-8?B?bm5XTEErbE1kVUZud1BuTEtKNHRTaTZ5dk1sMDJYM3BpRTBtZ3JCRjRVWnMy?=
 =?utf-8?B?WHplMnczSFluc3E5R0prbnVaUXovaGo4bmk0Ymw0b0YyWXNxL3ZPemRDN3l5?=
 =?utf-8?B?ckdaaFA3Z0QvcmlJUXk5WUl0aCt6dEQzMWNjMEh2LzBxdm9HaDhtOGNINDJL?=
 =?utf-8?B?RytKNzBlaXkrMHNabVYvQjk3SElQUkdZWHJCb09ZSm5lTk80bGJpSnN4MzlQ?=
 =?utf-8?B?dWwrSy9YTTE0QjdZYzVmUkFmenBjcWF2WmtZSkNQdFlzNjc3TmRNYzRndjg4?=
 =?utf-8?B?eWt4UGdESWlTUzBtbGZNa2JzMm1ReFdKOVlKMXU3M2g0dVAwSjc5QUhzVm8y?=
 =?utf-8?B?U0xEUFFwK2xLNHRIOVhMN2JNcnV5WkVtTHlrZ09QbXlTRVhTamd0a3dNMm9X?=
 =?utf-8?B?UmpsMC8vWHNPclp4VjhsN0phYVd3VUxMQ1NnSHFnbzNqSkF0VW5WOGlxZSt3?=
 =?utf-8?B?SlIxVUJtbUpXa0loZERmNk1oSGQ0Um9SbmE1cnMrQ20rMmpkRHBEdjZ1a2FE?=
 =?utf-8?B?clBUUU5HQ0gvRlVacDhwdGVpR0kybWZZSklJSFhaNkczVC9tUnl1amsrTGpu?=
 =?utf-8?B?WklJKzJkMndjN3ZZZTEvVmFaVUFHL2tUQUh3Z1gzTU5IM09wQVE0S1gyUVBp?=
 =?utf-8?B?VnNFQ1BRcllvNWlPTTNrRTNPVkYvNWlqUVQ5TG52N0lWLytBZkVhS2hFcm1M?=
 =?utf-8?B?dWV0MU9FTHdhVC9VTjBXU2xzQTZaVTZkNWFuZERBak1zc0hRcWpYNnhNajhU?=
 =?utf-8?B?TWFDYlcxbjJhbTZzNGFGbUU4S2pja1UwL09yVHZpT2hxQitZRmo5bmc3NWtG?=
 =?utf-8?B?UUV4UTMyTzM1TS91QWtoQ015R3NUc0xnaGtWQi9SWU5CR3lEZVA0VHJWeTlX?=
 =?utf-8?B?MnNjc3Awa2hpbHVaTzJGaFg3am84Q3hSKzBlRW5FZ0VESFM1ekFHWnpuSjhy?=
 =?utf-8?B?V1B1c1paQlZsd3d2b25GKzFreGxrT3J3ZFhWNEZYbVNNUnlnSEo1K0pRbTRX?=
 =?utf-8?B?aDVzMjJKQ1lNWTdtUU5haEFqdTZqdWhkUVpiOFVJalNmbEh1RHpPbm1tNjRD?=
 =?utf-8?B?UE9HeXlRZDY3bjRaRm5pc3pwUFkxVEtBZUUrK2NrZWg3dlFVVjNZUVNZZHNp?=
 =?utf-8?B?ckMxN3JNeGl4ZW5OejUrRjZDVjJUc2lLSWozVHBjTERVdjJUZHlQeE5XZHZJ?=
 =?utf-8?B?WjBESE9LUmVsVVlrM29xZE5GZzByYmdrMTk1ZE5vZUxBcDQvTXVaMkpGbzhq?=
 =?utf-8?B?TXREcE1hVm1uTlJJY2E3dHdwaStmT0FING1jTTllKy9EejdjVHNXNzA5K3A3?=
 =?utf-8?B?K3Y3bkoyNURNT0U5NHlpakZ0RXJTbHkzdVZPS3lUWmVRbXYzRit6SWhiaW1y?=
 =?utf-8?B?cUFobnQyMFFFZnMybVI0OE90aXJLTXpaaGRkaGVsREduOWoreDZCcGxReXp5?=
 =?utf-8?B?UXhkZkFwcG5SYXNxdXNFcmtQMnlydVhlWmhoNnE0NDJjZW1sWXc1UWNVbjZ1?=
 =?utf-8?B?WW1tRmt1YmNRdndtcndnaFJXc3hiY0hqM1B6bFp3Mm9DWjl4SVl3WVpUR3F6?=
 =?utf-8?B?RGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81376DBA0A897F4CB04A471507E2C175@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c6430d-877a-465b-41c2-08dbd5b64931
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2023 23:58:29.1450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tuNrC6CEU+k2Xu3DMBiIqVDlhRjbwwKqU3AO2XVpUusBzGabklWFR1vBr8bgcMokmzuNbAaPU7mCS7G8mBdEqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5380
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gV2VkLCAyMDIzLTEwLTI1IGF0IDA3OjMxIC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDEwLzE5LzIzIDE5OjUzLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+ID4gSW4gdGhlIEVBVUcg
b24gcGFnZSBmYXVsdCBwYXRoLCBWTV9GQVVMVF9PT00gaXMgcmV0dXJuZWQgd2hlbiB0aGUNCj4g
PiBFbmNsYXZlIFBhZ2UgQ2FjaGUgKEVQQykgcnVucyBvdXQuIFRoaXMgbWF5IHRyaWdnZXIgdW5u
ZWVkZWQgT09NIGtpbGwNCj4gPiB0aGF0IHdpbGwgbm90IGZyZWUgYW55IEVQQ3MuIFJldHVybiBW
TV9GQVVMVF9TSUdCVVMgaW5zdGVhZC4NCj4gDQo+IFNvLCB3aGVuIHBpY2tpbmcgYW4gZXJyb3Ig
Y29kZSBhbmQgd2UgbG9vayB0aGUgZG9jdW1lbnRhdGlvbiBmb3IgdGhlDQo+IGJpdHMsIHdlIHNl
ZToNCj4gDQo+ID4gICogQFZNX0ZBVUxUX09PTTogICAgICAgICAgICAgICBPdXQgT2YgTWVtb3J5
DQo+ID4gICogQFZNX0ZBVUxUX1NJR0JVUzogICAgICAgICAgICBCYWQgYWNjZXNzDQo+IA0KPiBT
byBpZiBhbnl0aGluZyB3ZSdsbCBuZWVkIGEgYml0IG1vcmUgY2hhbmdlbG9nIHdoZXJlIHlvdSBl
eHBsYWluIGhvdw0KPiBydW5uaW5nIG91dCBvZiBlbmNsYXZlIG1lbW9yeSBpcyBtb3JlICJCYWQg
YWNjZXNzIiB0aGFuICJPdXQgT2YgTWVtb3J5Ii4NCj4gIEJlY2F1c2Ugb24gdGhlIHN1cmZhY2Ug
dGhpcyBwYXRjaCBsb29rcyB3cm9uZy4NCj4gDQo+IEJ1dCB0aGF0J3MganVzdCBhIG5hbWluZyB0
aGluZy4gIFdoYXQgKmJlaGF2aW9yKiBpcyBiYWQgaGVyZT8gIFdpdGggdGhlDQo+IG9sZCBjb2Rl
LCB3aGF0IGhhcHBlbnM/ICBXaXRoIHRoZSBuZXcgY29kZSwgd2hhdCBoYXBwZW5zPyAgV2h5IGlz
IHRoZQ0KPiBvbGQgYmV0dGVyIHRoYW4gdGhlIG5ldz8NCg0KSSB0aGluayBIYWl0YW8gbWVhbnQg
aWYgd2UgcmV0dXJuIE9PTSwgdGhlIGNvcmUtTU0gZmF1bHQgaGFuZGxlciB3aWxsIGJlbGlldmUN
CnRoZSBmYXVsdCBjb3VsZG4ndCBiZSBoYW5kbGVkIGJlY2F1c2Ugb2YgcnVubmluZyBvdXQgb2Yg
bWVtb3J5LCBhbmQgdGhlbiBpdA0KY291bGQgaW52b2tlIHRoZSBPT00ga2lsbGVyIHdoaWNoIG1p
Z2h0IHNlbGVjdCBhbiB1bnJlbGF0ZWQgdmljdGltIHdobyBtaWdodA0KaGF2ZSBubyBFUEMgYXQg
YWxsLg0KDQpJZiB3ZSByZXR1cm4gU0lHQlVTLCB0aGVuIHRoZSBmYXVsdGluZyBwcm9jZXNzL2Vu
Y2xhdmUgd2lsbCBnZXQgdGhlIHNpZ25hbCBhbmQsDQplLmcuLCBnZXQga2lsbGVkLg0KDQpzdGF0
aWMgaW5saW5lDQp2b2lkIGRvX3VzZXJfYWRkcl9mYXVsdChzdHJ1Y3QgcHRfcmVncyAqcmVncywN
CiAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgZXJyb3JfY29kZSwNCiAgICAg
ICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgYWRkcmVzcykNCnsNCgkuLi4NCg0KCWZh
dWx0ID0gaGFuZGxlX21tX2ZhdWx0KHZtYSwgYWRkcmVzcywgLi4uKTsNCgkNCgkuLi4NCg0KZG9u
ZToNCgkuLi4NCg0KICAgICAgICBpZiAoZmF1bHQgJiBWTV9GQVVMVF9PT00pIHsNCiAgICAgICAg
ICAgICAgICAvKiBLZXJuZWwgbW9kZT8gSGFuZGxlIGV4Y2VwdGlvbnMgb3IgZGllOiAqLw0KICAg
ICAgICAgICAgICAgIGlmICghdXNlcl9tb2RlKHJlZ3MpKSB7DQogICAgICAgICAgICAgICAgICAg
ICAgICBrZXJuZWxtb2RlX2ZpeHVwX29yX29vcHMocmVncywgZXJyb3JfY29kZSwgYWRkcmVzcywN
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBTSUdTRUdW
LCBTRUdWX01BUEVSUiwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBBUkNIX0RFRkFVTFRfUEtFWSk7DQogICAgICAgICAgICAgICAgICAgICAgICByZXR1
cm47DQogICAgICAgICAgICAgICAgfQ0KDQogICAgICAgICAgICAgICAgLyoNCiAgICAgICAgICAg
ICAgICAgKiBXZSByYW4gb3V0IG9mIG1lbW9yeSwgY2FsbCB0aGUgT09NIGtpbGxlciwgYW5kIHJl
dHVybiB0aGUNCiAgICAgICAgICAgICAgICAgKiB1c2Vyc3BhY2UgKHdoaWNoIHdpbGwgcmV0cnkg
dGhlIGZhdWx0LCBvciBraWxsIHVzIGlmIHdlIGdvdA0KICAgICAgICAgICAgICAgICAqIG9vbS1r
aWxsZWQpOg0KICAgICAgICAgICAgICAgICAqLw0KICAgICAgICAgICAgICAgIHBhZ2VmYXVsdF9v
dXRfb2ZfbWVtb3J5KCk7DQogICAgICAgIH0gZWxzZSB7DQogICAgICAgICAgICAgICAgaWYgKGZh
dWx0ICYgKFZNX0ZBVUxUX1NJR0JVU3xWTV9GQVVMVF9IV1BPSVNPTnwNCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgVk1fRkFVTFRfSFdQT0lTT05fTEFSR0UpKQ0KICAgICAgICAgICAgICAg
ICAgICAgICAgZG9fc2lnYnVzKHJlZ3MsIGVycm9yX2NvZGUsIGFkZHJlc3MsIGZhdWx0KTsNCiAg
ICAgICAgICAgICAgICBlbHNlIGlmIChmYXVsdCAmIFZNX0ZBVUxUX1NJR1NFR1YpDQogICAgICAg
ICAgICAgICAgICAgICAgICBiYWRfYXJlYV9ub3NlbWFwaG9yZShyZWdzLCBlcnJvcl9jb2RlLCBh
ZGRyZXNzKTsNCiAgICAgICAgICAgICAgICBlbHNlDQogICAgICAgICAgICAgICAgICAgICAgICBC
VUcoKTsNCiAgICAgICAgfQ0KfQ0KDQpCdHcsIEluZ28gaGFzIGFscmVhZHkgcXVldWVkIHRoaXMg
cGF0Y2ggdG8gdGlwL3VyZ2VudDoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzE2OTc3
ODk0MTA1Ni4zMTM1LjE0MTY5NzgxMTU0MjEwNzY5MzQxLnRpcC1ib3QyQHRpcC1ib3QyL1QvDQoN
CihBbHNvLCBjdXJyZW50bHkgdGhlIG5vbi1FQVVHIGNvZGUgcGF0aCAoRUxEVSkgaW4gc2d4X3Zt
YV9mYXVsdCgpIGFsc28gcmV0dXJucw0KU0lHQlVTIGlmIGl0IGZhaWxzIHRvIGFsbG9jYXRlIEVQ
Qywgc28gbWFraW5nIEVBVUcgY29kZSBwYXRoIHJldHVybiBTSUdCVVMgYWxzbw0KbWF0Y2hlcyB0
aGUgRUxEVSBwYXRoLikNCg0K
