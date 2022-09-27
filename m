Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81888C6FA83
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Sep 2022 08:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiI0I1m (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Sep 2022 04:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiI0I1h (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 27 Sep 2022 04:27:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC45B1B88
        for <linux-sgx@vger.kernel.org>; Tue, 27 Sep 2022 01:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664267256; x=1695803256;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/3wzLSaWyHbiddAUywlTL90qkQoScxRfukiBqB016us=;
  b=J75+tqbc8mkilorqkTeap9O4qQkuljK7mw4ZtC3t0e/a/lLwka4XBR9k
   YWWRb+Vvy9vTomSHiyWJbLYYgjJn7aX2nODTGIJSaciZEspUjupu86UuL
   zlTV9Pc2BSz+y3NFcnzDATkRSwt0zIf7d2FRSXthPHRtkOWxkQa5CQJ+2
   +V72ZGI5TYKSwgrcKjf0Pc2zMs9HkXF6Nb7AAOa8DofRxCFHo2Nr4cIle
   2OwvlRQk2f7tLkdTyEklqxu4oewRHm9LoVdCvxqGmYzseB/1HadYuNR/9
   SuTGALv0UASQj61i+5Kw3fOU8kDZIok7pn+3XijYvdASxoKFAYBvf+qPy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="298854206"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="298854206"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 01:27:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="683895519"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="683895519"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 27 Sep 2022 01:27:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 01:27:27 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 01:27:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 27 Sep 2022 01:27:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 27 Sep 2022 01:27:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Stcll5ub/pcZRNNeOSFjopgm4+jircEeOud0ak63ghqgeUxt6cJFYqtQuNkD1WOq2zUDeiD88kpJV0n5MYEbsFUwT8d2DdpUoAAZ45DkR0kSmwjuCtg9Lz/y3y9qHeMQB+9DO/ETPYH6TKpilLd0k9I1AqnVIQTwI2pPOOFB/uFYJIKVNUgU6YMVEFMk5nQespm7JSvvBnvhgUjCCuyKXduQrX8pzBWpWtRSw+BMFIAheWzMVo7BYFcXbyT/xjTtjsTtP6XJFg12erbjVrjdTO3Dhzci9RqDtFaTN1uu2IyAstHfgKP8akK0S65sZ6eIIHXI+kqYjFG7zfqGlV3Jxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3wzLSaWyHbiddAUywlTL90qkQoScxRfukiBqB016us=;
 b=J4UC/PSl0LMEjhbRsrOeNjKmZWLoCqIuj/ATOYiNIqmvoRkcGzDRGioyya+Cw4N8tz749bT45QGJxT+Tn5V+TBl+qz6o4nMbhcHDD1vPKq2SuM4sWiRmNUqY90obVAVdoSw5gJ5q4KJ137SFAr5CdKdVZQcoC1Ot6Y80vcnja+2OUBm5xWLH9iiRKAZtqOEV55Lb3V85Fs5LmPSKLxw+cYaKkP1lQSlLvZibHvqjtpegzZYDWhPdAESOqYYUFXXCJQkqgeAMXmRN8zSBB253ftigHwoEaDX1upfvDqK7JH82fw78xDLAf1tO/ed0XOk3fMeF0n0eKJd0bT5tBaB4xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6226.namprd11.prod.outlook.com (2603:10b6:a03:45b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Tue, 27 Sep
 2022 08:27:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 08:27:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Patel, Himanshu" <himanshu.patel@intel.com>
CC:     "Kuvaiskii, Dmitrii" <dmitrii.kuvaiskii@intel.com>,
        "Hossain, Md Iqbal" <md.iqbal.hossain@intel.com>
Subject: Re: SGX Information needed
Thread-Topic: SGX Information needed
Thread-Index: AdjSMHtEN6s2Yxc1QLyD7dLPR7WkjQAE9gVQAAGowIA=
Date:   Tue, 27 Sep 2022 08:27:23 +0000
Message-ID: <b6db6b4434f013b8a885cc0edd1bcc9f57111567.camel@intel.com>
References: <SN6PR11MB297464FB9E509850C1599F0280559@SN6PR11MB2974.namprd11.prod.outlook.com>
         <BL0PR11MB29631E761E1DBC175E0C21C180559@BL0PR11MB2963.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB29631E761E1DBC175E0C21C180559@BL0PR11MB2963.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6226:EE_
x-ms-office365-filtering-correlation-id: e01a8f86-c49c-44ae-7ea4-08daa0621a87
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 49drzclyaLdajSZNbzDzIm+k+Ygc8w3yrvvxzhUvDSRnkK3QKeNQeuUvn+q7BKJr75cV2pWslka95xDC8NKtZ3oJfWtkh1/v+kl8Dt4wmz3JXvfKqrSdfBE3e7B90ZAiwUHymKebwD/vL5JZ3WWDTMhS8QEJ2+1e8NFAH8NclZ9KUjVzjI1D/jfJE+RNt45k/JHmsJ8eCEATLzkTY56YcPxDuxRTKBUZrl4J6+oqPWl9AiRlpKyMnU2LeuQcR6bgDgoYy2RC1iHzftcXkcLMYUUwTXumXdQ7YlOQCRpWa2hVTrpjtRIGw08PjmFEAnFjfds7nPNIh5R0oNa9l43m3Jn0YCEBV8/gcAbh5Iv4Gf8+yW91VDFPZ8h8HzY5IIThpehf2ybbSjWoaOcqPC4DdF1pLJSZJBqxayD/F/cSsKHd/2DPFVcDi2+VWRPgWqe/kn2n+Kkp8TQ0OCz8LHDp5MmO/I8sJT3wfiTsaqy1L0dPZoWQIp849xx9ilMq2ev9h8WpCzWDe7phM0TrF1DF9OXsasSeM14ydsFZcahgvcKqG/wNXm5Bd/WzUVZhJ2RM/O7oPLC1nYdR7HMgmydxVNHPSqIO5vaTTMjxV3i6oIkGCT5p97w1Nu/P9/wK7vc9xrlAsy2QMumPhRn6zmtQuP8HsoAMXmNlfFKiC4HFw2M6zj8ABbTQ/CHvGaEuRe4W1BxTUUlxm2E2UZl/V6pAVoURWpu3wwzHMsgIzKTl+ODBNPVAGyu0im5l7FCFR841YSltp86fu6Eek6BHJNuRXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199015)(41300700001)(38070700005)(122000001)(91956017)(66556008)(6512007)(26005)(4326008)(8676002)(66476007)(86362001)(2906002)(64756008)(76116006)(36756003)(66446008)(8936002)(7116003)(186003)(2616005)(5660300002)(478600001)(107886003)(71200400001)(6486002)(6506007)(316002)(82960400001)(66946007)(3480700007)(38100700002)(6636002)(54906003)(110136005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVg2SUZIZFVib2dud24rNWZ3RE1RRi9tNE1HQ3RZTjNlcVdLVlJHVUdDZThl?=
 =?utf-8?B?MDNmWTZnSHVqQmtUVGlYQlB6OWN3NS9Xa2ZxVEl2WXI5UkoyWVBvT0JrbHVr?=
 =?utf-8?B?bzhoYVBTbW5pY1ZIL3NneUQ4a0xMUEJoeHEwZVdLRmNCbnFVRVprbnVvc2tp?=
 =?utf-8?B?M2NBTmduY0grYjMxaDdic0paaGd4dThBMklJN3NKRjJ1QUxLYm41S3NzK2ww?=
 =?utf-8?B?K1RYUkQyczJWNHlCVWtIMlJqYVFXZUx2SzQzNDZ2S2RPQS93Q2x1RWxxVFFM?=
 =?utf-8?B?QlpEOXZ4Q0gvN1lJcXNFR2x2ZmpwU0s0aURTSXA3KzJJMHBIaFJJUlZuMUo3?=
 =?utf-8?B?a1lzS2poRTk0QjVrb2tXbXFHNndSRUlFNEZmM3k3aTBNYUxZUnVkL0dlNVVS?=
 =?utf-8?B?MmJWNkJKQWpqUHBmOGFsOHBzekRpSVRXVStNT2x4cmN2eGxmaUpmS0NIdjlN?=
 =?utf-8?B?d05EMGFPU3FPVnZ3N2IxTDQ3elI5am1DUi9FelV6M21mRktuVmlGTEorNnFF?=
 =?utf-8?B?QmJDbC8vNHJhMGhVVTVBR3ZTYjFWV1NETFFZNGJCVW5taHh1ODJHOVB3Q3JQ?=
 =?utf-8?B?YlBLTUJ6QmRnSEFjOVVWeW5JRFhnbS9LbTgxN3lBbUVJd0lkeVJaWndHMXpp?=
 =?utf-8?B?MWJuaEZLM0dablZlYjl5MUJjRDFkcmNLUGUvZFFHY29JWHhjTnFTL3BxZXM4?=
 =?utf-8?B?TW8zTnJhbFdrNm1kcFJSeHZTUEQ1NEhIejhkekpsWGI0OVpZQVpyZVA5Qmk2?=
 =?utf-8?B?cEVxL3Y2RkFxS1pTc0RhQ2EvaURHQ1VmQkhaU3VuSWRTeEhPZDlkbUFvR1JC?=
 =?utf-8?B?QkxZZjlCanFBclh0bFlKQzh3empGbkM5M0g0SjR6cFpXOXZTbWFJMkp2Zm8w?=
 =?utf-8?B?UHN0NDkxWjRlNXgzaVFjaERrZGFUYS96MzYzUit0MWd5UExQaEdQWEtkTmZn?=
 =?utf-8?B?V2pGUVZPQks0QzJ2a1VnTDFaeVdhak12NWtqZVk3bFVIMCtkczNYbXczdTN6?=
 =?utf-8?B?ZHlRZ29hdHdYdXF0cVJpWkZhZUJtdURNQTlDVDVVR2hWU3B3eEJuV3M4Vlpj?=
 =?utf-8?B?VU9QYWkrTURQVTJ3VlZ0MmdsbjFlWDNRUkxDVFRFbkhVeWxOOUJsTWUreGRH?=
 =?utf-8?B?ZmQ5aDV3WVRndURMTTY2dnl0M2N6SFZRVDMwZVcxSFlQdlRLdldDN2xWVXBP?=
 =?utf-8?B?WUNNOUQzbTRzWE45RnBMVVdiRjYzYkNwTkpFOFVRSEM4bml6eERaK1VSNm9t?=
 =?utf-8?B?NXdLYjV2Ky9lRG1hMVZuS1VFLy9uOHJzWWwxQm16akxyVXFtdTRNN3p4V3c0?=
 =?utf-8?B?REsyUXczZGxmTExxclJ3ZGFiSzJIRllpZjBWYXI0c2pjam1wYmtlN3R5dXZn?=
 =?utf-8?B?c1kwQjVqM3RLMndXOWtTakxHUGJpQlE4M1B6TjNkbnB3UW9uZzFqYWJXeGVk?=
 =?utf-8?B?bWk5YXA5RTR5WENtQ0lTaVdmSDJNYzM1bGxaVXNhNEdod0FvRmhJbXJQb01Y?=
 =?utf-8?B?QjkxZnNNQU1iVzZhTGFXNzFnMXJ4eW1UaEJmcTJ6bVdZTHcrdzJLSnlTMGhx?=
 =?utf-8?B?MUlzVHdqZGVBRDczUEVySmhEUW1LQk51M2ltbjNGNTlscDdHTitRU3cyVHRU?=
 =?utf-8?B?aHhubzB6VnpQNWZXL0tBOGlKWXFzejBTRy9ENHptMDBmdTNoYkhuaytPTG5s?=
 =?utf-8?B?ZStTQ2IvTXB3K3N6bHl1dHZyM0NzVy9hejFzaVVuQk8vRUdQeStqMGFYSlZX?=
 =?utf-8?B?ODVpbGp0cThPWDVqM3pBMjN4RDFvRFEvM2Y0V2UvTmIzTi9HTi9UUUN6Nndj?=
 =?utf-8?B?T3EzUHhuM002U3V3d0x5YjlLdXRtUjl3dDBodDI5aFRiVllyR0RxZXVCM1k1?=
 =?utf-8?B?V2ZXb0pXVngzZGRKSHMzUEZGQU81TXhka2MyUzFtcEZiSTdMREVPc0FJU2No?=
 =?utf-8?B?Z0ZEWmJ4ZmIrZTh2ZFJoUFprUVZLMUMzVS9DSHd4b1JZSm1TaFZVTTFyWTRv?=
 =?utf-8?B?N3dOYVJRcW5pZVZBV1pNN3BTYVVRQU4waEpYQmVSaE9GSVFYWmxmckFoQlJR?=
 =?utf-8?B?OXRJYlBnUHBYYTNka09Wa200WUtxbEgrRjUrRUk0S3lVck9xMVROMDNGQ3J1?=
 =?utf-8?B?WUZGRUN3dEJVTTdNdG1Xd3Jha002MWwzUUV0SnBYbmVTYlVNcWVZSDJ0Z3BG?=
 =?utf-8?B?UVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B354B4BAEF6899429DB1217A949EC0D7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e01a8f86-c49c-44ae-7ea4-08daa0621a87
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 08:27:23.8516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A6D3FQhFa+AaT0AvcDbvSXBDxQrnUuAYswMvS8KpyKcH247MCyOq9ychfb1X2g2K2tnUfjA0t8FIVnnQdaUL+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6226
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVHVlLCAyMDIyLTA5LTI3IGF0IDA3OjQxICswMDAwLCBQYXRlbCwgSGltYW5zaHUgd3JvdGU6
DQo+ICsrbGludXgtc2d4QHZnZXIua2VybmVsLm9yZw0KPiDCoA0KPiBQbGVhc2UgZXhwbGFpbiBt
ZSB0aGUgcHJvY2VzcyBmb3IgbXkgYmVsb3cgcXVlc3Rpb25zLiANCj4gwqANCj4gVGhhbmtzDQo+
IEhpbWFuc2h1DQo+IMKgDQo+IEZyb206IFBhdGVsLCBIaW1hbnNodSANCj4gU2VudDogVHVlc2Rh
eSwgU2VwdGVtYmVyIDI3LCAyMDIyIDEwOjQ4IEFNDQo+IFRvOiBIYW5zZW4sIERhdmUgPGRhdmUu
aGFuc2VuQGludGVsLmNvbT47IEh1YW5nLCBLYWkgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+IENj
OiBIb3NzYWluLCBNZCBJcWJhbCA8bWQuaXFiYWwuaG9zc2FpbkBpbnRlbC5jb20+OyBLdXZhaXNr
aWksIERtaXRyaWkNCj4gPERtaXRyaWkuS3V2YWlza2lpQGludGVsLmNvbT4NCj4gU3ViamVjdDog
U0dYIEluZm9ybWF0aW9uIG5lZWRlZA0KPiDCoA0KPiBIaSBEYXZlL0thaSwNCj4gwqANCj4gSSBo
YXZlIHNvbWUgcXVlc3Rpb25zIHJlbGF0ZWQgdG8gU0dYLiBJIGFtIHB1dHRpbmcgYSBzY2VuYXJp
byBoZXJlLg0KPiDCoA0KPiBzdXBwb3NlIHdlIGhhdmUgMTZHIFBSTSAocGVyIHNvY2tldCkgYW5k
IHNneF9lbmNsYXZlX3NpemU9NjRHICwgc28gd29ya2xvYWQNCj4gd2lsbCBuZWVkIHJlbW90ZSBz
b2NrZXQncyBlbmNsYXZlIG1lbW9yeSBhcyB3ZWxsIHJpZ2h0Lg0KPiB3aGljaCBlbnRpdHkgKFNH
WCBkcml2ZXI/KSBpcyBkb2luZyB0aGUgam9iIHRvIGRlY2lkZSByZW1vdGUgc29ja2V0cyB0bw0K
PiBmdWxmaWxsIHdvcmtsb2FkJ3MgcmVxdWlyZW1lbnQ/DQo+IMKgDQo+IElmIFNHWCBkcml2ZXIg
aXMgZGVjaWRpbmcgLCBpdCBtdXN0IGJlIGxvb2tpbmcgc29tZXdoZXJlKGxpa2UgYW55IG1hcHBl
ZCB0YWJsZQ0KPiBvciBhbnl0aGluZyBlbHNlKSB0byBzZWxlY3QgcmVtb3RlIHNvY2tldHMsIHdo
YXQgaXQgdGhhdD8NCj4gwqANCg0KSGkgSGltYW5zaHUsDQoNCkphcmtrbyBzaG91bGQgYmUgdGhl
IHBlcnNvbiB0byBhbnN3ZXIsIGJ1dCBJJ2xsIHRyeSBmaXJzdDogwqANCg0KWWVzIHRoZSBTR1gg
ZHJpdmVyIGRlY2lkZXMgd2hpY2ggbm9kZShzKSB0byBhbGxvY2F0ZS4gIEZpcnN0bHkgdGhlIGRy
aXZlIHRyaWVzDQp0byBhbGxvY2F0ZSBmcm9tIHRoZSBsb2NhbCBub2RlLiAgSWYgbG9jYWwgbm9k
ZSBpcyBydW5uaW5nIG91dCBvZiBFUEMgcGFnZSwgdGhlDQpkcml2ZXIgdHJpZXMgdG8gYWxsb2Nh
dGUgRVBDIHBhZ2UgZnJvbSB0aGUgJ25leHQtaGlnaGVzdCBub2RlJyAoaS5lLiBub2RlIDAgLT4g
MQ0KLT4gMiAuLi4pLg0KDQpFUEMgZG9lc24ndCBoYXZlIGl0cyBvd24gU1JBVCB0eXBlLCBzbyBp
dCBkZXBlbmRzIG9uIFNSQVQgdGFibGUncyBtZW1vcnkNCnJlc291cmNlICh3aGljaCBjb3ZlcnMg
RVBDIGluICBwcmFjdGljZSwgaWYgSSByZWNhbGwgY29ycmVjdGx5KSAgYWZmaW5pdHkgdG8NCmRl
Y2lkZSB3aGljaCBFUEMgcGFnZSBiZWxvbmdzIHRvIHdoaWNoIG5vZGUuDQoNCkhvcGUgYWJvdmUg
aGVscHMuDQoNCi0tIA0KVGhhbmtzLA0KLUthaQ0KDQoNCg==
