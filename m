Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E44ECAAD1
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Sep 2022 03:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiIADgx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Aug 2022 23:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIADgu (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 31 Aug 2022 23:36:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF2512F561
        for <linux-sgx@vger.kernel.org>; Wed, 31 Aug 2022 20:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662003409; x=1693539409;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KyGl0emnOuIC/GLC4riNf4ET3034x2ogR1VGnm+vqGU=;
  b=Fz59r4IdnD33wVI799zzDcXMoofRqrcSyKxXObYrZVHlLEkPzP4Xz/2J
   CHCl8pyDy25VZPNeOgfiVGPJsNU2sH1S9BDzUFhyrcoTlFXRsLm4veb5o
   4QtunzwKNa16XTvL4fWhsrW/V71tJL112Zvf7CKXYTGONFqIiJGNc+IqS
   W7p5mMO4kipRIo4vIwi9fZAnpWAE+rNkiseaxLT+3lABqEmzgHVJyHanJ
   wpp14gRQ2umlx/xc/a5KqK1m77KLDkV97d9rjyqC2zNJS161Qo90PVNLN
   d/UsTQb7DxyIjRr5VsuJvYvZPZ6/G9a8CvVghYyn2Ak9ru3etuPnEHtMh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="381902625"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="381902625"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 20:36:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="788079681"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 31 Aug 2022 20:36:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 20:36:48 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 20:36:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 20:36:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 20:36:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2VTA+KpuTNC0rgZcyTJHTl18n6/ql2ZsH16+3dMRZ/md5x/xtYYE4BbAXhnab1zrPRh5vDXFlsX5CIfIObJA2fNKgklxdPKiyst+FZ2hdKRhb7ZmcWapGk4m17db7MhV/P+qnIMMK6s8LD+pyvP4Ou/HpRdjbukxfDK29H5iNe0nYmj+gnIxEieKpCyE6AK5ErblrrXKfebqMxNsDRmAdGZ7OKa4BdD8a+Balnn4Swm0QL4uXZZwTPSr1jKyT8REVYBaZ0pzm/4xu8LqUqHoet/0mHT3k1mLAQR+5woxoveRjdwitqbfR/w85RZlupYTnEcp5TNm5lMI91dUd1y4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KyGl0emnOuIC/GLC4riNf4ET3034x2ogR1VGnm+vqGU=;
 b=KZALScITho0mlaWNh/Q6tboYiC+JKj6qvdH71r5timHH+ahgPY/JQJ+iw9oPN/xFVaYxn/nYv05evdL2i6sebigH/L1PcVAOFYwSMIGAh790GffogfGkDa+pb3Zxmq4FiaSmtWSXLKqinw5b851H6u9xylnDY3rAo4tZehKFiRPor0VoDtE7OkDmVrFHusivJcxWDAgCSYygWiSi76Knbt15xPzUC8pLR3YArUsMo819Um469TCTQqsBj6sZkv8KBdjv/TyCN8UzActvsAvsw59xcKHt211eiQPZyPWV/3S8fuYKDOUru+BoRkpHFM6M/hsAD7CVwibRPXc+BCBAAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN6PR11MB4098.namprd11.prod.outlook.com (2603:10b6:405:7f::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 03:36:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fce1:b229:d351:a708%8]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 03:36:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC:     "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
Subject: Re: [PATCH v7 1/3] x86/sgx: Rename the owner field of struct
 sgx_epc_page as encl_owner
Thread-Topic: [PATCH v7 1/3] x86/sgx: Rename the owner field of struct
 sgx_epc_page as encl_owner
Thread-Index: AQHYvZor9AX1oLj3E0WkmXG4tC6J8a3J7OeA
Date:   Thu, 1 Sep 2022 03:36:45 +0000
Message-ID: <7d222818eabcecc1376c616f8f2fcbb89f0df70e.camel@intel.com>
References: <20220901003601.2048563-1-zhiquan1.li@intel.com>
         <20220901003601.2048563-2-zhiquan1.li@intel.com>
In-Reply-To: <20220901003601.2048563-2-zhiquan1.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 020f3d1e-6f12-4c64-d891-08da8bcb3181
x-ms-traffictypediagnostic: BN6PR11MB4098:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d8ddA7lP5EGLbvz7o/ZQ5+k5gzGhcOjEtJ77Yt2/h+Sbo5Qo41r26zafob9OaVmDFWQEEuOeCeEptJWy4om3CR5nNcjGKrle8ZCyDhwLzP1znui+bw7MUoGBmfx3czFsyO3inCKoVPTViNXLV9gDPfBf3HW0aPuSVJsE0bJtQcWUE/br2eQoIeSbos736qoBdxEKOr4iI+k/hPsa5zmzusHhTNCbjaOlYxgHlj2BgNqnnBO8TtDFe1fuMIZ9p54U97pIQEVmFdBeJ1oW91lIxgU2Ds3v3ODOs17wqyMHG5d0vS5xBczWdyEaVfc7RWiQp12eJXfhYhA1AO60aL4yXLqJ3mrtl/js6eRrPBtIQve4X8k57aQbCyMSIaHqwDX2HG8UJMl4Q0JPZ2DneBeegu5ZNyyqRHM1zuUnntI5il9H0QwMEmwxAKpKmTn2tOLQ8jx7vx+3UoQmrvq3De51KO5ouqB3eCtgVO/bTkn2Rh3FYj4fOlhw3aHoLc61dxKzz61bmI5nrCQxOk10yTS8+t9Q2F30wxcouDXu5gesRCfkan09OzNWnk6vy6X0uyOIXAei3OtDWnI7cxzKIJQC5kIZ8A7nLY50XExX2dJATb0ZJPpZLxiV9inVvKria8sCEM8zt2iSevTCwMUSjyBTWEErcCEbgbpdiyf2q87eOTygdsoZyLUaaSt9jZTne70lf9KCqw7zMbpDU+VrcXKNYdIB/GQkrgg8NbWf2ePB6UPDodlcHxrHXze6yKKqfYJM1mq4fJlQUZPJbVP0rMbQCJBdM98JGR5yHY2sY+cafYQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39860400002)(136003)(376002)(396003)(2616005)(64756008)(38070700005)(6486002)(71200400001)(82960400001)(66556008)(66446008)(4326008)(966005)(66476007)(86362001)(186003)(83380400001)(76116006)(66946007)(6512007)(8676002)(478600001)(26005)(5660300002)(36756003)(8936002)(122000001)(38100700002)(2906002)(91956017)(316002)(6506007)(41300700001)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b0VWWjdkNGJ5UGQ0MnVieG91b2w1YnBiNG9VazRhRXhmN3BjNFF4ZG9SeXhD?=
 =?utf-8?B?ckcydmQvVFBvK3hsR2wyelJ4TEF1R1pqYldtdkVQcWgxVjVrbDM5UnVnR0tI?=
 =?utf-8?B?VEtIMzdtZHlHaFU1VlMwRm96dndHQW15d2FwSENjaTBuRW1kLzM3dUFzTkMy?=
 =?utf-8?B?V2dGdm12SEg5L3pWY1BlSWdyZFdyTlRSdmR3R09YVUUrTStOT0gxUzk3VDdR?=
 =?utf-8?B?Qy8zWUcxUXRYQjJuYlo5eUF1TzQzYk94Smkvb3BwaWMwWWdFV2MrZm9laWpE?=
 =?utf-8?B?aEdIWnpCTElCSVZEU3U3Mi8xZnpkb1pkcGJqdk13dkZOVEh3SUdyMU9tNkJQ?=
 =?utf-8?B?bGI5UGVQcThVOFdraitVMFlndm1hb2o3bTEyVzVTbHB6VWlMRS8reGp1TUNS?=
 =?utf-8?B?d3dqY1ljSFF4TUYzYVg1QytYcmo2OGRjLzBFdXJoUTM4d0ZXZlU5VUk2L2Mx?=
 =?utf-8?B?V2U2Y2Ziakt4S1BNNWFiaThackJpeXFWamlkMzNuQnN5MVdWcnhldXoxZHdT?=
 =?utf-8?B?N3ZpT1pZWk9yZjloRWcvR25ZNkIyZ1FObjk4ZWNyeC9uVG5yRXFNc1hBcWpZ?=
 =?utf-8?B?Sm9hR3B5dk5FQmlnaThBN2UwQnd1TjlnY1JIakNHMy8zc3ZOMitZdENsbytS?=
 =?utf-8?B?WnpmakZwelR4QzhiclJ6UnQvM25leHpDY0hsbG1mZ2YrU3ZidEQ2Uy9FTHkv?=
 =?utf-8?B?aUxtK1c4TWVkNzF3OUtES0c4TlZDR3d0TkNzR3JLRGRsUTlMaHRYL2xTblNa?=
 =?utf-8?B?L2ljaVdwdG9HTFhkNG1qT0ZrSHdvdUtNajFQd1U5eEh1WWRrd3M3aXFmZzVT?=
 =?utf-8?B?bGhVTm9MdDlZbFV0VnFTaEpSMGRDU0Y3S3I0dmlCMTh5Z3ZRVUM3eW9mK3RM?=
 =?utf-8?B?S3NKSUJyMkVyT2YvTmlTQ1hmV1BHeUdyNzc0bit0SWw1c0xKT242ZjE4RERn?=
 =?utf-8?B?Y2o0cjgwN1g4Rm44WDVGeTN0ZURxcE1OSXhUdWJEQ2FiNHJVcDd6OGRGZFNV?=
 =?utf-8?B?cUlPZFB3TFVVdWxRcjdWRndQNU1YUm16Q25ldzdrK1UvQkRuYkFQL0JqMkpu?=
 =?utf-8?B?TzRBcm9lcUtqNEd6QmtpZ3M3SWRNNDV2NUhLZEhkOUoycGRIT3pCNmlXQkY5?=
 =?utf-8?B?UkFkaWlLTGlWSEdaS3B5ako2anU4UC8zZGZydG9HMDJ6TGZDV2daQ3ZqSmVa?=
 =?utf-8?B?Mi83emZCR2R1ZmtyOFV6d2NaUzB4OWd1MzF1dzlXZG00eWxLZ3c2eWJ1U2lK?=
 =?utf-8?B?YzI3MXdRZXgwVjZudDlUQTRlUEpDVGZSdGlUb042ejlJNEEyUkNuUFQ0Y1NW?=
 =?utf-8?B?ZEtHcmFKSEhBYndNTUd5YWI1MEM0ejNVS2NOcCt0cEh1WTdIdE5KdWZTNU9V?=
 =?utf-8?B?RS9mbXE3ZDVSOWQ1YmlmcW1tdUlDSzJTa3NzWnNoNnhzdVp3c0lJQUtrU256?=
 =?utf-8?B?K25lcjlUYktOUGltSzhwMFBRZ013cHFGeFZyMjRFR0NIeGpVR3NpRkVZcloz?=
 =?utf-8?B?c0JOTW9TL1FUSXBCcGVjbU1KNlFybzNkNWQrMTVScUQwUUJWS2wzbzQ5STZG?=
 =?utf-8?B?bFNsVVA1T1JwbUt3NERKSGZHeWlkeVZPd1pqbUxTUEN6dEpuNndVQlV6S0h2?=
 =?utf-8?B?a2k1YWRDbEU3N3ozS0IyYnZUOWJjVjN3SEJvTUtVaWl0SHZzdlNSbmJxcm9U?=
 =?utf-8?B?WWwxaE1vNldUMUpjU1RPNGM2aVpORXNFaVR5OVIvTlVIczkyWHZyMm9OaE1r?=
 =?utf-8?B?RjRVZk5hVWkya1JBRjN4UXVTcjJRMmt5N0xkOC8xNTZwOGZVVE40bExmdVRR?=
 =?utf-8?B?aVhudVZUckRrUTRwTWZLcFc1dkUzekhjYTRuV05SaVJDWURrMTd3UjRIdDU3?=
 =?utf-8?B?NkN4R0tZNmtoekxiQkJnWm9YL2RZS2NqS2tDNEJUNkx0KzRGTmdwRVY0OFA4?=
 =?utf-8?B?SUlLVlBadHpaNk5lbWJpZDBLdE5mM05mM2ZXVDJXWlM2VG5DdEMxbXFjb01q?=
 =?utf-8?B?L29RUlRrTTRCNXRqbUoxTlpTelJEbzNtd0NCUlZEc04waW5mbWU3UUFhOHZ1?=
 =?utf-8?B?UUtNVlowM1FDZ1Y0d1lwZ1d4UTE0MmZWeDBuYTdpNFhBMkZ4TVNTdFM1SnZ3?=
 =?utf-8?B?WVZTQ3hYemJOQ044YUlaai93T3NpS1BRS0lTL0RpTnRkYzlEQmZtaVlMRjdm?=
 =?utf-8?B?ZGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A40497D532523649B1E2AE651E5BEDCF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 020f3d1e-6f12-4c64-d891-08da8bcb3181
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 03:36:45.1092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rPvvx2jpFG++U9OCgpXD6jxHk8QaIGGoPv5/29uyBNKgSf/9xxPGiLp91WCq64+Y+4wuGenpTh15nV240UAH6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4098
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVGh1LCAyMDIyLTA5LTAxIGF0IDA4OjM1ICswODAwLCBaaGlxdWFuIExpIHdyb3RlOg0KPiBJ
biBvcmRlciB0byBhdm9pZCB1bm5lY2Vzc2FyeSBjYXN0aW5nLCByZW5hbWUgdGhlICdvd25lcicg
ZmllbGQgb2YNCj4gc3RydWN0IHNneF9lcGNfcGFnZSBhcyAnZW5jbF9vd25lcicsIGFuZCB1cGRh
dGUgYWxsIG9mIHJlZmVyZW5jZXMuDQoNClRoaXMgY2hhbmdlbG9nIGl0c2VsZiBkb2Vzbid0IGV4
cGxhaW4gX3doeV8gcmVuYW1pbmcgJ293bmVyJyB0byAnZW5jbF9vd25lcicgY2FuDQphdm9pZCB0
aGUgZXhwbGljaXQgY2FzdGluZy4gIEluIGZhY3QsIHRoZSByZWFzb24gaXMgdGhhdCB5b3Ugd2ls
bCB1c2UgYSAndW5pb24nDQp0byBzZXBhcmF0ZSB0aGUgdXNlIG9mICdvd25lcicgb2YgdGhlIEVQ
QyBwYWdlIChiZXR3ZWVuIFNHWCBkcml2ZXIgYW5kIHZpcnR1YWwNCkVQQykuICBUaGUgcmVuYW1l
IGlzIGp1c3QgdG8gbWFrZSB0aGUgbmFtZSBtb3JlIGNsZWFyLCBidXQgY2Fubm90IHJlYWxseSBh
dm9pZA0KY2FzdGluZy4NCg0KU28gSSB0aGluayB0aGVyZSBzaG91bGQgYmUgbW9yZSBzZW50ZW5j
ZXMgdG8gZXhwbGFpbiBoZXJlLCBzdWNoIGFzICJpbiBvcmRlciB0bw0Kc2VuZCBTSUdCVVMgdG8g
dXNlcnNwYWNlIGh5cGVydmlzb3IgdG8gYWxsb3cgaXQgdG8gaW5qZWN0ICNNQyB0byBndWVzdCwg
dXNlDQp2aXJ0dWFsIEVQQyBwYWdlJ3Mgb3duZXIgdG8gYmUgdGhlIHVzZXJzcGFjZSB2aXJ0dWFs
IGFkZHJlc3Mgb2YgdGhlIEVQQyBwYWdlIiwNCmFuZCBhZnRlciB0aG9zZSB5b3UgY2FuIHNheSBz
b21ldGhpbmcgbGlrZSAiaW4gb3JkZXIgdG8gYXZvaWQgY2FzdGluZywgdXNlIGENCnVuaW9uIHRv
IHNlcGFyYXRlIHRoZSB1c2Ugb2Ygb3duZXIgZm9yIFNHWCBkcml2ZXIgRVBDIHBhZ2UgYW5kIHZp
cnR1YWwgRVBDIHBhZ2UuDQpBbmQgcmVuYW1lIG93bmVyIG9mIFNHWCBkcml2ZXIgRVBDIHBhZ2Ug
dG8gJ2VuY2xfb3duZXInIHRvIGJlIG1vcmUgc3BlY2lmaWMiLA0KZXRjLg0KDQpUaGF0IGJlaW5n
IHNhaWQsIEkgZ3Vlc3MgeW91IGNhbiBqdXN0IG1lcmdlIHRoaXMgcGF0Y2ggd2l0aCB5b3VyIHNl
Y29uZCBwYXRjaCwNCndoaWNoIGFjdHVhbGx5IGludHJvZHVjZXMgdGhlICd1bmlvbicgYW5kIHVz
ZXMgdGhlIG93bmVyIGZvciB2aXJ0dWFsIEVQQyBwYWdlLg0KQW5kIGluIGNoYW5nZWxvZyB5b3Ug
ZXhwbGFpbiBldmVyeXRoaW5nIGFib3ZlIHRvIGp1c3RpZnkgdGhlIHBhdGNoLg0KDQpEb2VzIHRo
aXMgbWFrZSBzZW5zZT8NCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWmhpcXVhbiBMaSA8emhpcXVh
bjEubGlAaW50ZWwuY29tPg0KPiANCj4gLS0tDQo+IENoYW5nZXMgc2luY2UgVjY6DQo+IC0gUmV2
aXNlIHRoZSBjb21taXQgbWVzc2FnZSBzdWdnZXN0ZWQgYnkgSmFya2tvLg0KPiAgIExpbms6IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXNneC8yMDIyMDgyNjE2MDUwMy4xNTc2OTY2LTEt
emhpcXVhbjEubGlAaW50ZWwuY29tL1QvI21iMjAxNTA2ZWQwNjkzMjQzOGM4MmQ0ODkxNWNkNGNl
YWU5NzQ1YmMyDQo+IC0tLQ0KPiAgYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jIHwgMjAg
KysrKysrKysrKy0tLS0tLS0tLS0NCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3NneC5oICB8
ICAyICstDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYyBi
L2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiBpbmRleCA1MTVlMmE1ZjI1YmIuLjEz
MTVjNjlhNzMzZSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5j
DQo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYw0KPiBAQCAtMTAyLDcgKzEw
Miw3IEBAIHN0YXRpYyB2b2lkIF9fc2d4X3Nhbml0aXplX3BhZ2VzKHN0cnVjdCBsaXN0X2hlYWQg
KmRpcnR5X3BhZ2VfbGlzdCkNCj4gIA0KPiAgc3RhdGljIGJvb2wgc2d4X3JlY2xhaW1lcl9hZ2Uo
c3RydWN0IHNneF9lcGNfcGFnZSAqZXBjX3BhZ2UpDQo+ICB7DQo+IC0Jc3RydWN0IHNneF9lbmNs
X3BhZ2UgKnBhZ2UgPSBlcGNfcGFnZS0+b3duZXI7DQo+ICsJc3RydWN0IHNneF9lbmNsX3BhZ2Ug
KnBhZ2UgPSBlcGNfcGFnZS0+ZW5jbF9vd25lcjsNCj4gIAlzdHJ1Y3Qgc2d4X2VuY2wgKmVuY2wg
PSBwYWdlLT5lbmNsOw0KPiAgCXN0cnVjdCBzZ3hfZW5jbF9tbSAqZW5jbF9tbTsNCj4gIAlib29s
IHJldCA9IHRydWU7DQo+IEBAIC0xMzQsNyArMTM0LDcgQEAgc3RhdGljIGJvb2wgc2d4X3JlY2xh
aW1lcl9hZ2Uoc3RydWN0IHNneF9lcGNfcGFnZSAqZXBjX3BhZ2UpDQo+ICANCj4gIHN0YXRpYyB2
b2lkIHNneF9yZWNsYWltZXJfYmxvY2soc3RydWN0IHNneF9lcGNfcGFnZSAqZXBjX3BhZ2UpDQo+
ICB7DQo+IC0Jc3RydWN0IHNneF9lbmNsX3BhZ2UgKnBhZ2UgPSBlcGNfcGFnZS0+b3duZXI7DQo+
ICsJc3RydWN0IHNneF9lbmNsX3BhZ2UgKnBhZ2UgPSBlcGNfcGFnZS0+ZW5jbF9vd25lcjsNCj4g
IAl1bnNpZ25lZCBsb25nIGFkZHIgPSBwYWdlLT5kZXNjICYgUEFHRV9NQVNLOw0KPiAgCXN0cnVj
dCBzZ3hfZW5jbCAqZW5jbCA9IHBhZ2UtPmVuY2w7DQo+ICAJaW50IHJldDsNCj4gQEAgLTE5MSw3
ICsxOTEsNyBAQCB2b2lkIHNneF9pcGlfY2Iodm9pZCAqaW5mbykNCj4gIHN0YXRpYyB2b2lkIHNn
eF9lbmNsX2V3YihzdHJ1Y3Qgc2d4X2VwY19wYWdlICplcGNfcGFnZSwNCj4gIAkJCSBzdHJ1Y3Qg
c2d4X2JhY2tpbmcgKmJhY2tpbmcpDQo+ICB7DQo+IC0Jc3RydWN0IHNneF9lbmNsX3BhZ2UgKmVu
Y2xfcGFnZSA9IGVwY19wYWdlLT5vd25lcjsNCj4gKwlzdHJ1Y3Qgc2d4X2VuY2xfcGFnZSAqZW5j
bF9wYWdlID0gZXBjX3BhZ2UtPmVuY2xfb3duZXI7DQo+ICAJc3RydWN0IHNneF9lbmNsICplbmNs
ID0gZW5jbF9wYWdlLT5lbmNsOw0KPiAgCXN0cnVjdCBzZ3hfdmFfcGFnZSAqdmFfcGFnZTsNCj4g
IAl1bnNpZ25lZCBpbnQgdmFfb2Zmc2V0Ow0KPiBAQCAtMjQ0LDcgKzI0NCw3IEBAIHN0YXRpYyB2
b2lkIHNneF9lbmNsX2V3YihzdHJ1Y3Qgc2d4X2VwY19wYWdlICplcGNfcGFnZSwNCj4gIHN0YXRp
YyB2b2lkIHNneF9yZWNsYWltZXJfd3JpdGUoc3RydWN0IHNneF9lcGNfcGFnZSAqZXBjX3BhZ2Us
DQo+ICAJCQkJc3RydWN0IHNneF9iYWNraW5nICpiYWNraW5nKQ0KPiAgew0KPiAtCXN0cnVjdCBz
Z3hfZW5jbF9wYWdlICplbmNsX3BhZ2UgPSBlcGNfcGFnZS0+b3duZXI7DQo+ICsJc3RydWN0IHNn
eF9lbmNsX3BhZ2UgKmVuY2xfcGFnZSA9IGVwY19wYWdlLT5lbmNsX293bmVyOw0KPiAgCXN0cnVj
dCBzZ3hfZW5jbCAqZW5jbCA9IGVuY2xfcGFnZS0+ZW5jbDsNCj4gIAlzdHJ1Y3Qgc2d4X2JhY2tp
bmcgc2Vjc19iYWNraW5nOw0KPiAgCWludCByZXQ7DQo+IEBAIC0zMDYsNyArMzA2LDcgQEAgc3Rh
dGljIHZvaWQgc2d4X3JlY2xhaW1fcGFnZXModm9pZCkNCj4gIAkJZXBjX3BhZ2UgPSBsaXN0X2Zp
cnN0X2VudHJ5KCZzZ3hfYWN0aXZlX3BhZ2VfbGlzdCwNCj4gIAkJCQkJICAgIHN0cnVjdCBzZ3hf
ZXBjX3BhZ2UsIGxpc3QpOw0KPiAgCQlsaXN0X2RlbF9pbml0KCZlcGNfcGFnZS0+bGlzdCk7DQo+
IC0JCWVuY2xfcGFnZSA9IGVwY19wYWdlLT5vd25lcjsNCj4gKwkJZW5jbF9wYWdlID0gZXBjX3Bh
Z2UtPmVuY2xfb3duZXI7DQo+ICANCj4gIAkJaWYgKGtyZWZfZ2V0X3VubGVzc196ZXJvKCZlbmNs
X3BhZ2UtPmVuY2wtPnJlZmNvdW50KSAhPSAwKQ0KPiAgCQkJY2h1bmtbY250KytdID0gZXBjX3Bh
Z2U7DQo+IEBAIC0zMjAsNyArMzIwLDcgQEAgc3RhdGljIHZvaWQgc2d4X3JlY2xhaW1fcGFnZXMo
dm9pZCkNCj4gIA0KPiAgCWZvciAoaSA9IDA7IGkgPCBjbnQ7IGkrKykgew0KPiAgCQllcGNfcGFn
ZSA9IGNodW5rW2ldOw0KPiAtCQllbmNsX3BhZ2UgPSBlcGNfcGFnZS0+b3duZXI7DQo+ICsJCWVu
Y2xfcGFnZSA9IGVwY19wYWdlLT5lbmNsX293bmVyOw0KPiAgDQo+ICAJCWlmICghc2d4X3JlY2xh
aW1lcl9hZ2UoZXBjX3BhZ2UpKQ0KPiAgCQkJZ290byBza2lwOw0KPiBAQCAtMzU5LDcgKzM1OSw3
IEBAIHN0YXRpYyB2b2lkIHNneF9yZWNsYWltX3BhZ2VzKHZvaWQpDQo+ICAJCWlmICghZXBjX3Bh
Z2UpDQo+ICAJCQljb250aW51ZTsNCj4gIA0KPiAtCQllbmNsX3BhZ2UgPSBlcGNfcGFnZS0+b3du
ZXI7DQo+ICsJCWVuY2xfcGFnZSA9IGVwY19wYWdlLT5lbmNsX293bmVyOw0KPiAgCQlzZ3hfcmVj
bGFpbWVyX3dyaXRlKGVwY19wYWdlLCAmYmFja2luZ1tpXSk7DQo+ICANCj4gIAkJa3JlZl9wdXQo
JmVuY2xfcGFnZS0+ZW5jbC0+cmVmY291bnQsIHNneF9lbmNsX3JlbGVhc2UpOw0KPiBAQCAtNTYw
LDcgKzU2MCw3IEBAIHN0cnVjdCBzZ3hfZXBjX3BhZ2UgKnNneF9hbGxvY19lcGNfcGFnZSh2b2lk
ICpvd25lciwgYm9vbCByZWNsYWltKQ0KPiAgCWZvciAoIDsgOyApIHsNCj4gIAkJcGFnZSA9IF9f
c2d4X2FsbG9jX2VwY19wYWdlKCk7DQo+ICAJCWlmICghSVNfRVJSKHBhZ2UpKSB7DQo+IC0JCQlw
YWdlLT5vd25lciA9IG93bmVyOw0KPiArCQkJcGFnZS0+ZW5jbF9vd25lciA9IG93bmVyOw0KPiAg
CQkJYnJlYWs7DQo+ICAJCX0NCj4gIA0KPiBAQCAtNjAzLDcgKzYwMyw3IEBAIHZvaWQgc2d4X2Zy
ZWVfZXBjX3BhZ2Uoc3RydWN0IHNneF9lcGNfcGFnZSAqcGFnZSkNCj4gIA0KPiAgCXNwaW5fbG9j
aygmbm9kZS0+bG9jayk7DQo+ICANCj4gLQlwYWdlLT5vd25lciA9IE5VTEw7DQo+ICsJcGFnZS0+
ZW5jbF9vd25lciA9IE5VTEw7DQo+ICAJaWYgKHBhZ2UtPnBvaXNvbikNCj4gIAkJbGlzdF9hZGQo
JnBhZ2UtPmxpc3QsICZub2RlLT5zZ3hfcG9pc29uX3BhZ2VfbGlzdCk7DQo+ICAJZWxzZQ0KPiBA
QCAtNjM4LDcgKzYzOCw3IEBAIHN0YXRpYyBib29sIF9faW5pdCBzZ3hfc2V0dXBfZXBjX3NlY3Rp
b24odTY0IHBoeXNfYWRkciwgdTY0IHNpemUsDQo+ICAJZm9yIChpID0gMDsgaSA8IG5yX3BhZ2Vz
OyBpKyspIHsNCj4gIAkJc2VjdGlvbi0+cGFnZXNbaV0uc2VjdGlvbiA9IGluZGV4Ow0KPiAgCQlz
ZWN0aW9uLT5wYWdlc1tpXS5mbGFncyA9IDA7DQo+IC0JCXNlY3Rpb24tPnBhZ2VzW2ldLm93bmVy
ID0gTlVMTDsNCj4gKwkJc2VjdGlvbi0+cGFnZXNbaV0uZW5jbF9vd25lciA9IE5VTEw7DQo+ICAJ
CXNlY3Rpb24tPnBhZ2VzW2ldLnBvaXNvbiA9IDA7DQo+ICAJCWxpc3RfYWRkX3RhaWwoJnNlY3Rp
b24tPnBhZ2VzW2ldLmxpc3QsICZzZ3hfZGlydHlfcGFnZV9saXN0KTsNCj4gIAl9DQo+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9zZ3guaCBiL2FyY2gveDg2L2tlcm5lbC9j
cHUvc2d4L3NneC5oDQo+IGluZGV4IDBmMjAyMDY1M2ZiYS4uNGQ4OGFiY2NkMTJlIDEwMDY0NA0K
PiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9zZ3guaA0KPiArKysgYi9hcmNoL3g4Ni9r
ZXJuZWwvY3B1L3NneC9zZ3guaA0KPiBAQCAtMzMsNyArMzMsNyBAQCBzdHJ1Y3Qgc2d4X2VwY19w
YWdlIHsNCj4gIAl1bnNpZ25lZCBpbnQgc2VjdGlvbjsNCj4gIAl1MTYgZmxhZ3M7DQo+ICAJdTE2
IHBvaXNvbjsNCj4gLQlzdHJ1Y3Qgc2d4X2VuY2xfcGFnZSAqb3duZXI7DQo+ICsJc3RydWN0IHNn
eF9lbmNsX3BhZ2UgKmVuY2xfb3duZXI7DQo+ICAJc3RydWN0IGxpc3RfaGVhZCBsaXN0Ow0KPiAg
fTsNCj4gIA0KDQo=
