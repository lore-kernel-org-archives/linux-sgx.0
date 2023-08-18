Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DDFEE499B
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Aug 2023 21:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240789AbjHRVeS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Aug 2023 17:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240841AbjHRVd7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 18 Aug 2023 17:33:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E9C2D7D;
        Fri, 18 Aug 2023 14:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692394438; x=1723930438;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7dokjUm+KsXjYnvbxYMDBkIt0cPPt4MgN9z2YkRpAK8=;
  b=TCEI5vHuljZLAga2uA6LnXuHRXS3jJgMGk/+L6UiJFT92JgcmqdSCT35
   CAZkKHCWN6mlSZJP1ueCXa3pMwJcOiH8pNyeec0I89QFPLjbeUDzPZrQN
   J6GH6fTfSc0lvANSszzdl8Pq22zdhZZT4TRQDR8kM1MNqz0xEJ8moil4D
   MrlICLY/GjFlPk2+4Gb0sVt4PG2+5i6M2s2bw+EsiYguYzJ6uyDbnuwGR
   iZSWW8gTXLs83EAhH9/uzvqWkyH75gTNBOyMJXrodZWz61ujRaxqLhAE8
   Zk0w/by1D18T/25/8DH64XQSs6m75xfTtorDFcksx885meTVMANB0q1kU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10806"; a="372107270"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="372107270"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 14:33:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10806"; a="858834757"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="858834757"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 18 Aug 2023 14:33:58 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 18 Aug 2023 14:33:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 18 Aug 2023 14:33:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 18 Aug 2023 14:33:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juK7cZDK/0/ZErAo9RuFJbAZM45J8v2VoeGFCwBbfRjen00hpvoip/voXWyM7sepcNP7DcpIjq8JHqs2UUnFjHMRmElq7UjX4/HEu504WeCvudYhx2rZXMcnBIUujoFRBhIQiL2FlEJ0aKHeVuaUjYhuLtq0KK39e6AW+r0Jux13AAwRPcA20Y9SlroRkKQGjrH5bVTl6ke95AJuIxEHW9uB/7ZZRvDWDYNfdIsEsHdDQNurI23jW9wz7p4DCQd88pN9m9wlyPFIU8z1HpIdA8BWHYV6cYisrRyQ5VPWp+q9Mirvx/E+Sq869J3OqRpCu+yFtBZsXXvhY/O8dAeTMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7dokjUm+KsXjYnvbxYMDBkIt0cPPt4MgN9z2YkRpAK8=;
 b=kASOah53+bV8zrx57gu31N3lf2a2HHrSyvdQRPR2zVDLnfcG6RD66TABB6lEcFLQSjoLMXzcF7+q4yz/t5gNcNHOLtFBoPLAHfY73iT2KZFxg8PszCypwuUTh3OXT5kkoqfPI+VyJ28177BQ6mu0ezupNxm/y+3v6CJls9PRup4VaNKfKvfIMssEiMrIpy6rsI0euyk+Qdt/FKeL60htF1LX6ozsHL1QIZCeILR+ZfMNbvUxgOQRJEe7GtYT6Kz6vbp+aWR2fFBAEpj70ahyudtCWHR81H8bWDUrxblZfOg/qlcSx3+eoW2+RqF9N7YXRsouMAQQDnz/LUYt+Z0agA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5279.namprd11.prod.outlook.com (2603:10b6:5:38a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Fri, 18 Aug
 2023 21:33:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6699.020; Fri, 18 Aug 2023
 21:33:51 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jinpu.wang@ionos.com" <jinpu.wang@ionos.com>
CC:     "yu.zhang@ionos.com" <yu.zhang@ionos.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
Subject: Re: [PATCHv3] x86/sgx: Avoid softlockup from sgx_vepc_release
Thread-Topic: [PATCHv3] x86/sgx: Avoid softlockup from sgx_vepc_release
Thread-Index: AQHZ0f8AgQYNEwMExkeRE5T+Cd2q56/wk1uA
Date:   Fri, 18 Aug 2023 21:33:51 +0000
Message-ID: <2999685f286789d43e3b1f13c4cb65efd008d820.camel@intel.com>
References: <20230818180702.4621-1-jinpu.wang@ionos.com>
In-Reply-To: <20230818180702.4621-1-jinpu.wang@ionos.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5279:EE_
x-ms-office365-filtering-correlation-id: 9f0a1aea-afa0-417a-134b-08dba032d0b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hb2UESngJwgF2TCYhLvhGn+aGkNgoIbROOcn8fZsgG07vN06G3FPnd2sSifzjyJLJWrHKpNcRpROZmz9nqeo+gtiTiOS3/NcJAzyaSD0s1Oax/qBKojRXb4XhkiqE1bvyH2F+2NwFGFUy1OAT080FiBxDaF1H5JDqU65uYN5sRdpjYOiLlKfPZdcJ15DUMiAGDZUh2o7PYyUWczV185a7NfnO/IRbBu2ruCqlqtoLBMbOR4qGEYhiHIXTUxUpOT1RWUzHp3Vw77oVM6LZ/iQ+Tmf5BK8gmDpOxnQK3ldioPgzst9I13NVey+jc+HXaa0wb/WaJlZF3QRWStiZJQpEMcIejFK40NKi9RlWoNcrjiibxxOSsAcM09XNY5PZybsCWNl7P7sT8WaDmXDr4hDLnJUZ90UExUG21b8AYhTGVYPHUvyjFKdTEmBvQ3CHMDfVDMsZs96fYFy1nE4DG8Zls/II/UskfUVf5+crkIBjU8tytRvUE6whRhsQrtdzCdV/3UlidZywRWTKtFf48rARohdp9h2KEYYS8SuCZXcrgqaD7gq9/apJ2KCB0AbGVk0maoiC6AWPYPwh47SBvMr1bYkwIL8XPUHvsa1OEGD4jHtjAH/dT/lRuz70J5UKmS8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199024)(1800799009)(186009)(86362001)(36756003)(122000001)(82960400001)(38100700002)(38070700005)(66446008)(76116006)(110136005)(2616005)(5660300002)(6506007)(66946007)(66476007)(71200400001)(478600001)(6486002)(316002)(66556008)(91956017)(64756008)(26005)(8936002)(6512007)(8676002)(41300700001)(4326008)(54906003)(83380400001)(4744005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTE2Y0VhK2dJdDdQNUpOZE9uS05ETGk0UWp2VnMybVJVNFJwMlhDdkFBdFBU?=
 =?utf-8?B?Q0hVM3BrQlREVk8zb1BRQWU3V2RxY2M0S0dIbjFHRUJQSFVTVHY1YytxOWZR?=
 =?utf-8?B?b2ZMWE5HejZINzFZSWJtZit1cG1Pak1LNm9FZCtMWngzYjNKcDN6UXg1emdw?=
 =?utf-8?B?RXNzUjF1VWhYUVRGKzdQWEJ3SDI5OFFxc3J3WUszclpycmdVMmNxN3QvMGp1?=
 =?utf-8?B?Sk93TXBpR2dTekwwWHRlSWJQdUtWWkVlbXNwSWJPNjlaYXNxSEZrK0lLMStl?=
 =?utf-8?B?ZHdoU2Q1eWVDKzBiekdMSEdkWkdvbTB5dkVJYnp4R1czTGcxbEsvNS9Tc3RD?=
 =?utf-8?B?WnhPWGQ3cWh1RHd6ZHFuelNlYnNzTFlnbm9nQ0JXd2lKUFZZUURjN2xZd28r?=
 =?utf-8?B?QjBGRkk4UzF0dmpGZlEyaUhMQm5HS09VbFJoMGJPMHE2clRRRlVMaTNRVSsy?=
 =?utf-8?B?NWxRdWFWSWZKRWZHaE9UVXJvNlgwRzZGRFY5Umc2WmU4M1plR0s5ZEt3cVRt?=
 =?utf-8?B?OWJSRkJoVktxTjNrR21lVysvQS95dXQxWjcwOWY0Ym5PNUlSN3BtemgyOTgv?=
 =?utf-8?B?akFFc2RiR2xwVldBZHJScWNXUktHSnN0VDAycXk5a3g2SjFYU0pjSDQwc0lR?=
 =?utf-8?B?T29ZWnA4NmVEekdtUXhoMnBYaEc5VlNqR2pxL21pWXdFSk1nS1E3Qm03Y1FX?=
 =?utf-8?B?VEY2YlpWTGlydlROQmtMNmpNS2dwMzhXaFlQRzBBZGY5L2tyQW1yU01yUzVV?=
 =?utf-8?B?V2w3MjY3SHhrUjlSY2RmTjNubGs0UGlYZ25Ib2tWSWlaWGtQTDhxYVYvOTE1?=
 =?utf-8?B?V3lQZldwWW5ueTBZNnhnaFlyK3ZDTXVDYVRkdzVoRy85cHRJZnFXOGRzZSt1?=
 =?utf-8?B?RlhaOUlPSnZRb1h2blFxTzIyRHRHcStqSkYxOVhwTTZKeG5EMUxVajBlWFB0?=
 =?utf-8?B?bnB2aTlHbXBRVStnUEREblYvbjBTYk9oUFZ0ck82WlE5MkU2czZNajR5dzF1?=
 =?utf-8?B?SXpiSWtiSndLL1ZTNHBsL2lsbVJLYVVkZWRkdVVJVERYWWhNSzNrYjcydlZS?=
 =?utf-8?B?dnJqWE1BK2ViLzRGaGs2UldtT1hRU3JSOFhoYTZBNkJ6Z2hPcTNrZEZ4QURG?=
 =?utf-8?B?TTY2SmZRc2hqdXBBR3Z6WHVYU3ZGSmJRb2JuTWZHSVhubXR4VUtYUkRENHY1?=
 =?utf-8?B?cjFJQ0xGR0J0eDVrRGVSdlVSZUxacmVKODFURXIrdXNoZWIrQkVRZXNkZVdH?=
 =?utf-8?B?ZEpnc2NtTnRKMWthemlsZVpGTVhxcHdWa09oZ3Y5RnMrSGVqT3ZVTzMrUVBY?=
 =?utf-8?B?SjUxSnhITXVnSlVxTVorY05COW96TlM5c1NZT2RIV1NONWgwNE5XekZkZTEr?=
 =?utf-8?B?YUpvUVEzSzNLZ3NDS1lxOVF1RGFoNWNiYUhQWk1IcXZiWWdzNEgySkdSbVFU?=
 =?utf-8?B?NTlyTk9ydmd3S1pXQnYzV0F4Vy9NNFB3amVpUnhtNlJtOGRxQ054Q1dKVHRa?=
 =?utf-8?B?cTJ2dFJKNlFhRGNNZ3VieHdCS3JJUldRaVhPVTlLcWIwbHpHcW9GWm1rcTl0?=
 =?utf-8?B?d2tkYUxnZWw3SXNTWEVYYm90Z0Fpa05CRnVBUkJsampsVEVoZFlVZ2FIR2Fj?=
 =?utf-8?B?S1FQZVo0SFJ0T3FZS3dremtTVVlHRDdnZ29CZlAxQnVqdURrb29NRk53S3lQ?=
 =?utf-8?B?aVpaa0UvN09aanVTd2IrYWlyZzNrZzlOcFg1aGxBRkZFZTJqVmhDMmdwMzZs?=
 =?utf-8?B?bWhHUE95WFhZZXFtckxFYTR4Qmd2TjFuNFgzNllBWDFTSXpsT1oyQXREckt4?=
 =?utf-8?B?UGFxYXVoSC9mekpyeVZTSWdNVlhCRDVGdjhSRzM4QU5sc052SzFTejFJYUdC?=
 =?utf-8?B?Q2hiTXNreFhjRzdWMWtwaGRkVXQvL1Z2S0lLRHJUNTRKK0pDV05Jc2c0anUw?=
 =?utf-8?B?bVhCVExUREJBbjFLZ2NremgxUjZRYUZacW9CRS9Vc3M1NlpPamlsMy94Qitt?=
 =?utf-8?B?b1VBckZ2TjdxcVMwNnNqNm1UT2dxU2ZBS0NEMldhNmJSLzVHV09MazAzdG50?=
 =?utf-8?B?K2RpZU5Ra0dCdC9FWlpIOEk2V0dkR3RIYTN5Z0Y3SE5KelVrZFdtNlFNT0lv?=
 =?utf-8?Q?QDDGXly7aHfaD8p7BM1bk65Vt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C68B1E22D002184E9387436F80735632@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f0a1aea-afa0-417a-134b-08dba032d0b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2023 21:33:51.3423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bl0zgOH2Rc6hSdbbtlqa1I29wOfrCu7GpwDpJ8011Oc8tN/I/6SRQ+UFI9QnrDZV+ezhcLHpq6oB9OZBKzemMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5279
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gRnJpLCAyMDIzLTA4LTE4IGF0IDIwOjA3ICswMjAwLCBKYWNrIFdhbmcgd3JvdGU6DQo+IFdl
IGhpdCBzb2Z0bG9jdXAgd2l0aCBmb2xsb3dpbmcgY2FsbCB0cmFjZToNCj4gDQo+ID8gYXNtX3N5
c3ZlY19hcGljX3RpbWVyX2ludGVycnVwdCsweDE2LzB4MjANCj4geGFfZXJhc2UrMHgyMS8weGIw
DQo+ID8gc2d4X2ZyZWVfZXBjX3BhZ2UrMHgyMC8weDUwDQo+IHNneF92ZXBjX3JlbGVhc2UrMHg3
NS8weDIyMA0KPiBfX2ZwdXQrMHg4OS8weDI1MA0KPiB0YXNrX3dvcmtfcnVuKzB4NTkvMHg5MA0K
PiBkb19leGl0KzB4MzM3LzB4OWEwDQo+IA0KPiBTaW1pbGFyIGxpa2UgY29tbWl0IDg3OTUzNTll
MzViYyAoIng4Ni9zZ3g6IFNpbGVuY2Ugc29mdGxvY2t1cCBkZXRlY3Rpb24NCj4gd2hlbiByZWxl
YXNpbmcgbGFyZ2UgZW5jbGF2ZXMiKS4gVGhlIHRlc3Qgc3lzdGVtIGhhcyA2NEdCIG9mIGVuY2xh
dmUgbWVtb3J5LA0KPiBhbmQgYWxsIGFzc2lnbmVkIHRvIGEgc2luZ2xlIFZNLiBSZWxlYXNlIHZl
cGMgdGFrZSBsb25nZXIgdGltZSBhbmQgdHJpZ2dlcnMNCj4gdGhlIHNvZnRsb2NrdXAgd2Fybmlu
Zy4NCj4gDQo+IEFkZCBjb25kX3Jlc2NoZWQoKSB0byBnaXZlIG90aGVyIHRhc2tzIGEgY2hhbmNl
IHRvIHJ1biBhbmQgcGxhY2F0ZQ0KPiB0aGUgc29mdGxvY2t1cCBkZXRlY3Rvci4NCj4gDQo+IENj
OiBKYXJra28gU2Fra2luZW4gPGphcmtrb0BrZXJuZWwub3JnPg0KPiBDYzogSGFpdGFvIEh1YW5n
IDxoYWl0YW8uaHVhbmdAbGludXguaW50ZWwuY29tPg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZw0KPiBGaXhlczogNTQwNzQ1ZGRiYzcwICgieDg2L3NneDogSW50cm9kdWNlIHZpcnR1YWwg
RVBDIGZvciB1c2UgYnkgS1ZNIGd1ZXN0cyIpDQo+IFJlcG9ydGVkLWJ5OiBZdSBaaGFuZyA8eXUu
emhhbmdAaW9ub3MuY29tPg0KPiBUZXN0ZWQtYnk6IFl1IFpoYW5nIDx5dS56aGFuZ0Bpb25vcy5j
b20+DQo+IEFja2VkLWJ5OiBIYWl0YW8gSHVhbmcgPGhhaXRhby5odWFuZ0BsaW51eC5pbnRlbC5j
b20+DQo+IFJldmlld2VkLWJ5OiBKYXJra28gU2Fra2luZW4gPGphcmtrb0BrZXJuZWwub3JnPg0K
PiBTaWduZWQtb2ZmLWJ5OiBKYWNrIFdhbmcgPGppbnB1LndhbmdAaW9ub3MuY29tPg0KDQpSZXZp
ZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K
