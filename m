Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFD6C67871
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Oct 2022 00:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiJYAGt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiJYAGe (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 24 Oct 2022 20:06:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174E7EC1ED
        for <linux-sgx@vger.kernel.org>; Mon, 24 Oct 2022 15:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666650194; x=1698186194;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uLG7UP0bbMY6x7Jx2DKaClplBec1fJGaS2mqn048+Ww=;
  b=Y42WkNh56GNO9fiHfYVnZIedZx2Apd/ldeLpvRCBnTZwxzWVTZWdlrS7
   3SrKtR8ITAqDvKSjz8PyTqpC5tFMjW9J6w5ofGJa5VN0zVuLmSti6XGfD
   vB43Jp8m90FE4Ko17UmhP4WlbPq0q0UN7uLE28BXRalZ/RlrvB3AElVyz
   URRodSCZHp36akho4ugirxJ6XPoxPejVlIyJpHaFefUFlP9uZYFPrKNo8
   22Zmd0pLARmLHYb8AgMmR8/P0JyW09laMyaq2fxGE95NYxiUJja/fjlLC
   mbb5y6NtIke2BtxA9Tcs2Riv4BTpfTAdzjuU+hYyBs0QVXJaFkNRU2tfE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="287255082"
X-IronPort-AV: E=Sophos;i="5.95,210,1661842800"; 
   d="scan'208";a="287255082"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 15:23:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="756724466"
X-IronPort-AV: E=Sophos;i="5.95,210,1661842800"; 
   d="scan'208";a="756724466"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 24 Oct 2022 15:23:13 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 15:23:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 24 Oct 2022 15:23:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 24 Oct 2022 15:23:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxJ1I8vuKNTV4rCyGijcuj5G9lt9/GjcDnL0ssnC89YoAk7v7SJevc/jDWZZVh6jWQCqGYY07/z9s29/LIKY/kWRrpQME+5HQ43IN/Ixkli8QWON8FGuYada9Wty4+qjgU8swwlHt8Bd09tcjACwmQtqV8XJ+gT2EBbTMyNZNcQ5gQiTaa7b7mHqUiMDaELQww+0La9GOR8TEDjQFcYMhcBJ4Itbw3KpgeZLdUdvm3WPal+GBWBKi8Yq3AR3J9uRNaY0hDqABLM9cHkDUu17T4x/DPgu3prvPQOV8KE13JQlUaJZnf7m90pjp/8o/Gtv2XVdiNRfMLmrRHMr2CClrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uLG7UP0bbMY6x7Jx2DKaClplBec1fJGaS2mqn048+Ww=;
 b=TwH4YkbVSoSaNfcJk9IF8fAUefV0zGUyWIAa71E8CZ4XhsNxj0YiafPG5U7AShGmJk8nIGKHdRPZPAnltzhczEFvehF6hkTor07wllRiX52OnV2t1pW7sLGL0dEvPgudQfR4PnKCM9Ojv6ABd2R80lcbXrxbVoRCpje1aWIyM2aglgE39SNuOpCpodrSu19/a9iX9SAWDUpUHneyFRplZ8uuEfVnwWtJAfTDjylrZkBWReUacYLusjlk6Uekt+WezVMJ0dPY0oGxiWOLdyRWHyNf98Mlv937ZoMRpDrU742sKdh2qwGSSQyGqQH3/S4fcWC6KcZTzTA+p5Spn7RCOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7298.namprd11.prod.outlook.com (2603:10b6:610:14c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Mon, 24 Oct
 2022 22:23:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5746.021; Mon, 24 Oct 2022
 22:23:10 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@suse.de" <bp@suse.de>, "Zhang, Cathy" <cathy.zhang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>, "Du, Fan" <fan.du@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Topic: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Index: AQHYzLsOovV5qYztIkquos7ZMS9Qjq4JWziAgAD86YCAAJ5RgIABk7IAgAARzYCAAGXuAIAAA7UAgAADhICAAAPHAIAAFAEAgAAE0QCAAAYhAIAIjmSAgAbrTACAAa9rgA==
Date:   Mon, 24 Oct 2022 22:23:10 +0000
Message-ID: <31afc45e67f303645b81d231e4a5cb6878b30016.camel@intel.com>
References: <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
         <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
         <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
         <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
         <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
         <4930999a-888f-88bc-a05c-86762504f059@intel.com>
         <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
         <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
         <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
         <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
         <Y1WmZgqIkl8GkR/i@kernel.org>
In-Reply-To: <Y1WmZgqIkl8GkR/i@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7298:EE_
x-ms-office365-filtering-correlation-id: f4938a81-7fc8-42fb-1ea1-08dab60e5560
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UzhjvqLMIdJeGmgHnjaGIrLcpQNLx77chJfi8SCW+/aO+k5+kpgUBP1bE/E0li2vsUoIKWtM6u5Jj0tm4hgreqF2igkH3C6HQprTzxV0YX25uQ/lAida7r79o6bBBCGps3yhG1XmKDJEKFyT2kBXSSHJo0dqgnWYUjQGL8/a+Jrwb/8cbdXD+bbpMlBdx4KaM36XPC2zKa4WMPdfRUATCPFd9B4DhSb2+OiPknfar8T3BuApc2oWZ/jtHhvNaHqovRmeA1lAPfG3hSshcKruc0/2UcE1Nd/Dhm3kqkDFAbwncZ/hOXn8e0iGBVaSzwTzvbfcv9OpPwj+6Kh/L0z2j1m2INxQebTpM3aKaewA4MC/WFFRxa/4wCMWoK9MNTHGat/WX4MtPJV7AmnMNOePviiK1YYyrOE+p2EbE9gAJlob13nhWl8ZIEj4a9KMATBMUCosSHIQQgv8NAukMkuTwQZa3ZYPQwin0rQESMhmudYVu3z57OV8sK1GPaHLBhdSbUHyrgZRiQY1+0gC1yVVSAy++DSxdHykleMHaU3ed/g2u4PVVHUHYOAkk/Brmn243Qz9YxEsAbUZSCUNXKGhyvnKcPQ7jx8elmCFMVRQVnM6ORCWnUAsqK1UfFssUuCMWDOSlL6tXIeB4nWhKsKjctVey3FQWFlT3K91plpc3EsO4wK5nciUNql62OhVM6WKn5vbFE/Lb0waSGrZQU4MzCd3y0P9a+AGlquLsLAAhjP/jGC2FuFxgYnqzAa2ZMl7uyrJahSAwcumPvipQSitSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(396003)(136003)(39860400002)(451199015)(36756003)(82960400001)(38100700002)(122000001)(186003)(83380400001)(8936002)(4326008)(91956017)(76116006)(4001150100001)(2906002)(66446008)(66556008)(66476007)(8676002)(66946007)(64756008)(54906003)(5660300002)(41300700001)(86362001)(6916009)(316002)(6506007)(2616005)(71200400001)(6512007)(38070700005)(26005)(478600001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODllWVN4ZVFyS0tCVmx5SysraWpybGdHVHk5Y2ZPV2NQWnVCUmQ4ckFiQ0dZ?=
 =?utf-8?B?N050WTN6UTJJN0Q4VlNxRCtnZ1dxdTdicFdCcnlqZFZxOFkwOER4V29ydHlw?=
 =?utf-8?B?emtmTWJjdXd5T2o1ZzcwUzljbk5nMkY2ZU1zQzluQVU2UzdrcDdUUk9SOFB3?=
 =?utf-8?B?UzM0U2EreDdFRC94emdVYld2eXNuWE9ZTmJLcmFCU1h3eFBCRkJrS3pEb051?=
 =?utf-8?B?T0RMTjB0eWs4QlQ2WUE1ZWp3NlhTQXVZcktKWTVHczdCclloRm9LNk1lQzhO?=
 =?utf-8?B?MUoxeHdEcDNPbldxbXJYSnZkdFhwSm9FKzJBL3pJOHN0NDNaUmsyUTdvL0lV?=
 =?utf-8?B?SDdZMWE4UGFRV0pNUzBmaUxDOE5yK2xvdFh1VHE3VS91V3hMLzRNcHY2OHIy?=
 =?utf-8?B?d0JpQzlicFY5dk9nbUFMVnpMUEYwZTc3YjVSSGJ4c3RUNldESWJXYVdRbmcv?=
 =?utf-8?B?QmxmL0hOSHRtOTlETVB5RlVwT2twQXM0a3A2dXAwcUV5OVBaWW1ycWxacHBy?=
 =?utf-8?B?Z2pJVDFlWEJoT1d0N1BwVEdJL2xVZWwwUm9CQU1aVlNDT2dqeVcvNlBuUUhL?=
 =?utf-8?B?dkUrQ1RtQ0xjbGMrUjF4QW5telNUWWVRdmd5NnVtMG5DWUhkTExCbjBxWHFz?=
 =?utf-8?B?V01vVzdWSGxJblFuRmt5aGdWTjJiY09VeGxNRVBvajFnRzJzZ0pKU2VsK1JT?=
 =?utf-8?B?aXVLL1ZRQTY1MlZ4YTErbzJ2ZEtoVU1kclpPdnhOYnJmZXd6S29CQlNqZHZv?=
 =?utf-8?B?YzhoeXQrVWpIT2x0QmlkNGZQM094b0d3c3hKNGk2bDcybFNrTFkyWmdDcEY4?=
 =?utf-8?B?aC9pY1h1UTFvYmNzeEcweWdZdTBBaXhnN3NGUWJ2WUtZLzhZdlhDRHRVbERv?=
 =?utf-8?B?VVdzbnE3VTdHdTk4L3ZraG5PczlDRlZDYXFjNFF6RHBDbHo1S0lUbXpReGFN?=
 =?utf-8?B?V3orL2R1YUJRS1hBeDBadjlmd3c5YnVQT2tCczNDSnV1OG83QWVjSWtZTlc1?=
 =?utf-8?B?QnpHUjRPRUVXbnY3OFIxTjJGUmFsOTJnbDZQR2hDNVNWT0Q4VEEyYlNiRlVp?=
 =?utf-8?B?S1JqTkE4d05zK0xNOHdFUFpMMEhhRS9LSXhyMHNJL1pSYjFaTEVrN01UTk9u?=
 =?utf-8?B?QWlpbTd5b2RDQUlUbmpwZ2wzZVljcFI4RW56SWpORWNIeks4Z0tlVHNSUmJP?=
 =?utf-8?B?cVZ4ZlYvbHI2K2Q4TERvK1Z0cVBlRCs3Z0wvVCtWWEJWY21Zc29jc3hZRHdY?=
 =?utf-8?B?cU5vUDlqYUNtNVBVd1VWbTY2Y3BGZ0U4dVdyY0NWam9MQmd5S1lQbjZ6eThI?=
 =?utf-8?B?dXpZM2drc3l5NUpVelJxNlo0dVZLa0ErREdzRUtjNERURmxZWklHU1BhSUNV?=
 =?utf-8?B?U1BOUVdBcmNuZktid0pVSXlhTDB2dGRJaDhRNkpzaWp1RHdEaUlsejVOempU?=
 =?utf-8?B?aUJVdEpZNnd1SGlJTzRDQks0dmJwOVZncEdxcG1qL1IwQnRsZmNudXgyL1Qx?=
 =?utf-8?B?SDR3ditaVTlDV3lmeXoyZEpwSFdVUWdkby9oYmg3TEdpOXlKWXNZYnU3VkJN?=
 =?utf-8?B?UG9IR3pVNHVTOGNQNHYwTCt5YUp3TE1QckdQRnN2UGdmV05vbVVyOUpWVVZG?=
 =?utf-8?B?eDMxMVNXT2g4U1h3RHJTN3VVUC8wRlhTbmUrR0R1Ry9WS0dqNDhzOWFKSElK?=
 =?utf-8?B?eHU3M2p0TXVHdC91ZzlCa0twdjlONE1PZXV6LzVYUjdqaUZFZStEUTZnblQ0?=
 =?utf-8?B?cUpBcWpiZlZGaDJTTlMvNXZvWGJoZ0VHdVpoMVR3RExsYTc0Q2l3YThkcWlq?=
 =?utf-8?B?TGZSc2lSTE5nZU5TYkdnY2hMQnM3Nm94b1pma0l0ZTBORFd0Y2lRVTJRU3BN?=
 =?utf-8?B?Q3VMZ2dpcXR4UW9JS1RHZllwajVvTWcvek5KdS9zZ3ZhOThZM2VzS1Q4V3pQ?=
 =?utf-8?B?QlpldStsMWxyRGJnZWlvaStzWnF5TW9Uc084bS9HN1l6emgzMCs4Q0sycnJo?=
 =?utf-8?B?K2JUaVl1RnA0cWl5U3NLTlI4NWVSYmc0c0dBNGlYZ2N0bWVJSmVkcmZWQ2Jw?=
 =?utf-8?B?TlJ1LzJYUzM1YXAwWnBiTFc2Zy9jV1BXS0ZycEpETU5nakgrc0tOYWp0cjMx?=
 =?utf-8?B?ZFcxd21uZjdFd01JN053UWVYUlB5R2JrZU1Xdms1WmwvTFRkNVJ6ZmUxb2Zl?=
 =?utf-8?B?ZGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <343B6D75EAADF1418B9E4660FFB64D2C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4938a81-7fc8-42fb-1ea1-08dab60e5560
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 22:23:10.3881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5lEOhf2mAOJyqP6dOeVK9Mj/aWORIEYJY01RVy+yiDe4gzpb404AmQQMNgDNm4mxuNDX873KfdRxVHo8+3FQSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7298
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gU3VuLCAyMDIyLTEwLTIzIGF0IDIzOjM5ICswMzAwLCBqYXJra29Aa2VybmVsLm9yZyB3cm90
ZToNCj4gT24gV2VkLCBPY3QgMTksIDIwMjIgYXQgMTA6NTk6MjBBTSArMDAwMCwgSHVhbmcsIEth
aSB3cm90ZToNCj4gPiBzdGF0aWMgaW50IF9fc2d4X3ZlcGNfZmF1bHQoc3RydWN0IHNneF92ZXBj
ICp2ZXBjLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3Qgdm1fYXJlYV9z
dHJ1Y3QgKnZtYSwgdW5zaWduZWQgbG9uZyBhZGRyKQ0KPiA+IHsNCj4gPiAJLi4uLi4uDQo+ID4g
ICAgICAgICAvKiBDYWxjdWxhdGUgaW5kZXggb2YgRVBDIHBhZ2UgaW4gdmlydHVhbCBFUEMncyBw
YWdlX2FycmF5ICovDQo+ID4gICAgICAgICBpbmRleCA9IHZtYS0+dm1fcGdvZmYgKyBQRk5fRE9X
TihhZGRyIC0gdm1hLT52bV9zdGFydCk7DQo+ID4gDQo+ID4gICAgICAgICBlcGNfcGFnZSA9IHhh
X2xvYWQoJnZlcGMtPnBhZ2VfYXJyYXksIGluZGV4KTsNCj4gPiAgICAgICAgIGlmIChlcGNfcGFn
ZSkNCj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ID4gDQo+ID4gCS4uLg0KPiA+IH0N
Cj4gPiANCj4gPiBBcyB5b3UgY2FuIHNlZSBpZiB0aGUgRVBDIHBhZ2UgaGFzIGFscmVhZHkgYmVl
biBwb3B1bGF0ZWQgYXQgYSBnaXZlbiBpbmRleCBvZg0KPiA+IG9uZSB2aXJ0dWFsIEVQQyBpbnN0
YW5jZSwgdGhlIGN1cnJlbnQgZmF1bHQgaGFuZGxlciBqdXN0IGFzc3VtZXMgdGhlIG1hcHBpbmcg
aXMNCj4gPiBhbHJlYWR5IHRoZXJlIGFuZCByZXR1cm5zIHN1Y2Nlc3MgaW1tZWRpYXRlbHkuICBU
aGlzIGNhdXNlcyBhIGJ1ZyB3aGVuIG9uZQ0KPiA+IHZpcnR1YWwgRVBDIGluc3RhbmNlIGlzIHNo
YXJlZCBieSBtdWx0aSBwcm9jZXNzZXMgdmlhIGZvcmsoKTogaWYgdGhlIEVQQyBwYWdlIGF0DQo+
ID4gb25lIGluZGV4IGlzIGFscmVhZHkgcG9wdWxhdGVkIGJ5IHRoZSBwYXJlbnQgcHJvY2Vzcywg
d2hlbiB0aGUgY2hpbGQgYWNjZXNzZXMNCj4gPiB0aGUgc2FtZSBwYWdlIHVzaW5nIGRpZmZlcmVu
dCB2aXJ0dWFsIGFkZHJlc3MsIHRoZSBmYXVsdCBoYW5kbGVyIGp1c3QgcmV0dXJucw0KPiA+IHN1
Y2Nlc3Mgdy9vIGFjdHVhbGx5IHNldHRpbmcgdXAgdGhlIG1hcHBpbmcgZm9yIHRoZSBjaGlsZCwg
cmVzdWx0aW5nIGluIGVuZGxlc3MNCj4gPiBwYWdlIGZhdWx0Lg0KPiA+IA0KPiA+IFRoaXMgbmVl
ZHMgdG8gYmUgZml4ZWQgaW4gbm8gbWF0dGVyIHdoYXQgd2F5Lg0KPiANCj4gSSB0aGluayB5b3Ug
bWVhbiB0aGF0IHZtX2luc2VydF9wZm4oKSBkb2VzIG5vdCBoYXBwZW4gZm9yIGNoaWxkIGJlY2F1
c2UNCj4gb2YgZWFybHkgcmV0dXJuPw0KPiANCg0KWWVzIGV4YWN0bHkuICBTb3JyeSBmb3Igbm90
IHBvaW50aW5nIG91dCBkaXJlY3RseS4NCg0KPiBJIGRpZCBub3QgdW5kZXJzdGFuZCB0aGUgcGFy
dCBhYm91dCAiZGlmZmVyZW50IHZpcnR1YWwNCj4gYWRkcmVzc2VzIiwgYXMgaXQgaXMgdGhlIHNh
bWUgbWFwcGluZy4NCg0KVGhlIGNoaWxkIGNhbiB1c2UgbW1hcCgpIHRvIGdldCBhIG5ldyBtYXBw
aW5nLiAgV2hldGhlciB0aGUgdmlydHVhbCBhZGRyZXNzIGlzDQpkaWZmZXJlbnQgZnJvbSB0aGUg
cGFyZW50J3MgZG9lc24ndCBtYXR0ZXIgYWN0dWFsbHkuDQoNCg0KLS0gDQpUaGFua3MsDQotS2Fp
DQoNCg0K
