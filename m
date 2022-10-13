Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627D7C433FE
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Oct 2022 21:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiJMVvi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Oct 2022 17:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiJMVum (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Oct 2022 17:50:42 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B9C27DD5
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 14:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665697791; x=1697233791;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IIALtqHadLi3aypGaLjrv0low3XP/mcMGL9M7CB4pTc=;
  b=SEz7IRjxDKgAiNEZ16w8qw0UutGgn/9JkHMK+cGhhheXyiL8RLtPbuJj
   jK/vQwAORoZ65zACMZ/KSFmBtjQscjpXFukgtuxmJ8orWI6VoYb6Wbtcz
   ZPoNVkKZYeLryHZXmJfOEl63WxoaYBp+v0U09jSKdb3emxxewoSVbXiyD
   QacnhSEGq9/zkkN+3O3oLcdxsA4fYNwMWhy00Q4bsZ+IjGhxspgdXfNRt
   +D5I+ZowpXm4chjZnibGq/SyxXLBQonAlaaIvgMN3mzGn63jh/GtNCjiq
   1hSMLrhCXt4GARAmPHKnwMEc1USFqqyzCpy+zdrL6o4mExcQ05t9Q1kO7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="288496715"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="288496715"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 14:49:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="658350620"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="658350620"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 13 Oct 2022 14:49:33 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 14:49:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 13 Oct 2022 14:49:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 13 Oct 2022 14:49:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1TzfZgmsFUSsZiZ3tsIRlsSFexX2db/jWe855YyWV34scNiKoIXdfIlDuxahFp5h5B5K5nxOdzFuAH5ZAb5VLytiwuP5rSWSgkAvts3NRifPU+GGQ7SLZk4lGG6XHr/KyhwKaYxnyssUcjeQ0W+1/KOSFLqVYI+luRUMZFy9j17x84gnhcv3uibHMDAYEJm2zZYWZCrP45d8DiZXv4myQFzX+bgrQRDjlU5Zq6OFDQgEGkvYyYDiQCvms6LhaQWI2nCxnKfJoF1r9CKAdnjZ1c9o7Mr47XkA7Pv3aIhJ509C0dLMJj2HrdZB2aVsFYOtoBEfJOefSfDL/zYdsQ7hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IIALtqHadLi3aypGaLjrv0low3XP/mcMGL9M7CB4pTc=;
 b=hIpLTYgfaeGsXHza2OrHh16/JkNXakW7WduiP6nSjNha/dpSdXB8fliC82HtOcj7HAyMlan9NXFlSh4PPnvEyf3QD7kMqd62K+44R6mdQQMCW/r4nr/psn+qRrqa1QYeMQ3tTuslyrq00B6pwAX5x7l6i4UpZLwGWdqPJ4zwWJnlxXjeXSaWdNRbAvMVFNHuzvIXLPjeA6eBsEM217ykZVTOrQaBBZhXyLby9YjMz1Inam2je7JozcnVIHm6a5erfdRoiEmNGkrKBP5j4D1+h1WMH6UfsoQXYFfbxN+a3O1Sik8DbjLndW7FN1tL48Zgj5+9W1m6d9t2qHw3NCqAQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6151.namprd11.prod.outlook.com (2603:10b6:8:9c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Thu, 13 Oct
 2022 21:49:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5676.032; Thu, 13 Oct 2022
 21:49:28 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Topic: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Index: AQHYzLsOovV5qYztIkquos7ZMS9Qjq4JWziAgAD86YCAAJ5RgIABk7IAgAARzYCAAGXuAA==
Date:   Thu, 13 Oct 2022 21:49:28 +0000
Message-ID: <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
         <20220920063948.3556917-4-zhiquan1.li@intel.com>
         <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
         <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
         <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
         <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
         <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
In-Reply-To: <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6151:EE_
x-ms-office365-filtering-correlation-id: f6150ca5-9a4e-45a4-1633-08daad64cdb3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7g/m3TgiRqHQS6ofwVsfVl2L3uTduWXDbB6tSRPFoTfmM0JOYcUSs6DTWs5lpiJwh3Sljn0P0jEZnT5zSWVIO4ioLqIjr3TqXTlhYYdLyYsvE3da7XBVgcdRTRmNoOGLOSyjH2clA55O6tsHYayZD2uE5myBMK/EfT/0hiTfAtkzGU0WIO3XT7vDDfw1U9OSQFUoxj8qg/XyrlhlGt2oZ4OPezDpxzWqloGKtEw51DUBSIMFyH6jriifJKUwDGFOTFBuT6RIe3dZ5yZ3pL/mLkiD/XwmcF8q/aW2t9T4dr8rNS8hKss5dva5P3NcbDdWxtCWkIYfct8w2hrbBtERSLmaVP5Ocu9uDfmzwUXd8NiFAdClP+hwD5NjOnz54hgkAP9CovB5DKCgx7zlprCyyQiGHs6VTOPdGQWT/ZvnmRUTLSFIziWZP8YvXQlJ/S1tG2aXuetzSUQf8JiiMfq4VjPhy1Svbp5xRiNiyHa5vB0X89lQ029GIqs5xKZIVJcR06pXhFt8zhSL9hzsm/sFI5LOi3fyuWau66Kphg3LeEo+hPiVce5P5JbIoYeSJyeHYoAB4EAjofm2g8H8KHWDdamIncBYkKymq3z9GmTeSsw2fLuEgJR2FGoj271iyuzk+Fu1JG5zT0x0Qu0+cJDKQ/m6VEM54RNMsIK+HzxJY57BA9Ltc/J5IXMh9HXwTpYTbqYc0S2JMHwuSTIWZzy8POnLi9K2jrKtE5/xreUwM2LxIhyBHXlJPrf9TqNLDFaHXtc8/hv8LQT49WGI2j0CKirn7Ib+cnZtUKDmnsHmoisjMksTTaivSPnx6olLLqScrjtthLu5oOZ/fhqylaF9lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(346002)(366004)(396003)(451199015)(36756003)(86362001)(122000001)(66556008)(5660300002)(2906002)(41300700001)(64756008)(66476007)(8936002)(4001150100001)(6512007)(8676002)(26005)(66446008)(4326008)(38070700005)(66946007)(91956017)(54906003)(76116006)(71200400001)(38100700002)(186003)(83380400001)(316002)(53546011)(82960400001)(966005)(2616005)(6506007)(6486002)(478600001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVhTd1ltNHlJbGN3bXY5MS8wMzJJTml5dXIrczFiWUFEakRsUjhkUmg3dUd4?=
 =?utf-8?B?NlNsQ0lYZHk5NWdHa1ZlYW9rY1JPR092Tis4eVdCSHhoOGdITWw5a1pJRXdF?=
 =?utf-8?B?SkJpUW9EVitYbFVvODBhSmx4Zk8zRVVOVTZpMHNUS2pseVFHYTNtU0gyV1U1?=
 =?utf-8?B?UlhzUUFScHhkT2VhRjh1cTZlaGttZE96MWVqcHlpQzJjOUdNUkZnMGR2am0w?=
 =?utf-8?B?angzUkNEVEJaS3pzNU9HYiszbnA1elA1L04yc2Z0WnhxS2toTEJMT2RPb3lT?=
 =?utf-8?B?Ymc2VjhaZXU0dS9KaHJHWU5tMENlYy9HTng1d0VTUUwwYm9QNCt4M3JQMTBZ?=
 =?utf-8?B?SUMvYy9MUWd4Q3BibW11NVZkUGY1UlJ6YldHaTE4M2lNNmhLS3Z1NUNaclIw?=
 =?utf-8?B?bEM0SkJldDh5S3Zibnprclc4cXZDVElUdTFJam43dzFnb0RhTVo0WTNtMTds?=
 =?utf-8?B?VlFYNDJucVFoU3lkZG4yVisrRzB2OCtsZG1sSy9tVW1zTEkxZU91ZVo2QzhZ?=
 =?utf-8?B?NmZMaWhySHZMeWhGMlB5aVRCNEpKeUREcmZocUZycjl0MHR3Tng1MStXM2tR?=
 =?utf-8?B?LzBqUmJjS2pUZHJKSmlGV0tIZFBXMzBOVzhaNEluR0pZZXNzbjd4NENTN2tP?=
 =?utf-8?B?SGR4N2wzc2JiQW9QOFNKTitDVE02T2ZNTzJhMXk4RElmZ1VEZnV6a3A0Tnla?=
 =?utf-8?B?NkVJNFNhVmpDdDVPeVhiOThFTy9QNlBZd2NlUlV1M3BpbENsb3kyOUZWdm1B?=
 =?utf-8?B?bjEwbVlScWo5eVdRNGUvaGRTZExpQ0lHUmRMWWhnY2hHbTRPSDViUWhmTVNt?=
 =?utf-8?B?TG1NTElZOVAydngwU1JLdU9nOXBqNnNMam1ZVk1VODlDdXMrV1NNUy9VaEd1?=
 =?utf-8?B?dDUvQzNCZSszQzd6YWtrNW9sZ3FSVmNUU0RNUFJ2eDlNdm5IWWkrL3lqRkJI?=
 =?utf-8?B?R1BJTnA1RG5LYWxDLzBKRlZGUUcvZ3lLNkZpZlJ5NDRoWTU2bVNYbU8vcXRM?=
 =?utf-8?B?d2xsTUJnZE1SZjBaVEhyb3FTMXQvNFZMaEczRjdaKzBsNDdyNllNRjg2Y1lw?=
 =?utf-8?B?YUxLL3M2MWNJQmxTZFJ1ZXhFazZ6VWx2c2ViTUwyaHVSMENQN3Q1UkhYY1dQ?=
 =?utf-8?B?MHRFTnpxY0VSWGc3eGJOTVNyNlloS2hqR0Z1Y1BPQ2d1NVNOY2c5TGFkd0cx?=
 =?utf-8?B?YTJJMzFLUTFNc3RFbEtSSVJiOS9zWGdsdHFwN0dmMzBwZXo1OEV1UkVLd1Rs?=
 =?utf-8?B?OWdaVGNad0FFWW1vamFrR2pZT0tLVjFsRHlzclpWQ0lMYzNEL20yZGlmSWE0?=
 =?utf-8?B?OTRFNkF6SEtvMVI1VHlxWlpEQU5jV3NML3FTdmVZM1hZR3p6M2ErdkZxWjVK?=
 =?utf-8?B?SDI2TzBtQ0lsM1BtL09wUm84blRnbERpeEt3YzdMYlFtcTQrR3E5WFN2TUFh?=
 =?utf-8?B?MGZtNGV1T0JJSXNiTjNDMzAwQU5HQ2FySFI1S1JYOUFKUHk0aUQwTkUyMTdv?=
 =?utf-8?B?M3hoY2hnandZUXZ6ZVdCTVFoMVQzdVNLTWRmOTFyQTBFWW11eWRlYm45T3Qw?=
 =?utf-8?B?dWFpbHg0aEZCZCtHS2s5Sldrc3dId291UWEwbE1HS3BnZjJoc2dYTGxFQXgw?=
 =?utf-8?B?VnpnSVY2Z3VZS1EyUXh1SEcwWmZneUtwdm93WDVBN3JaTmhUY1V2bGZoUEZw?=
 =?utf-8?B?cnVOUHVrS1BIWTh5RjYvK0U3bDBNazJrb3RCeERPMkNicldTaTdxODVrcE1w?=
 =?utf-8?B?cHZUeldBcXBLeG1XSjQ1emN6czBzdjlyUDZMWGVxaVpIWXJnQ01CekFYVVdG?=
 =?utf-8?B?ZU44NEJKL2xybGJ5MlNrSHZoVHBoWkNvMEk3bWQ0Zkd0QnJPK1BZOEVSaHBB?=
 =?utf-8?B?cmxBMEpiNmIrTXp6V3lBK0gyS0xmb1R3QVB6d0ZiV2ZaQ0xiQTMwRys2Z3g4?=
 =?utf-8?B?c2JvTGJEeVdaemtqVjZCVXh6LzNWeHZQcDJWckVITGo5MTRkTGtoUFhCWjBh?=
 =?utf-8?B?YUFBNVp0djlsYTlBa3oyKzVtNzh1d1VVUXQ1aE5nTjBUOGo4OS9EOEwxMUZJ?=
 =?utf-8?B?QnoxaDQ1OFVRWTk4anZreGxna0JMSHJjVEFJaUhCUFZJT3g1WllDY2htWkJr?=
 =?utf-8?B?VEdpQ2ZMc0NLV08rR0ltVE1ZTlMrS2E0bkNkY3dkOTdydVV2b0Joak5BZ3Jw?=
 =?utf-8?B?K3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1B0D9770BB65145AC937DB54C4E4AA8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6150ca5-9a4e-45a4-1633-08daad64cdb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2022 21:49:28.5278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jO1zlNCnzBDZCEK1s1PIVvL2bAdkFi6aETR8/phOoF01ab9opKtw0/MwQX3hPFWkKxXPtDjguvU5HVcK/aovNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6151
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTEzIGF0IDA4OjQ0IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvMTMvMjIgMDc6NDAsIFpoaXF1YW4gTGkgd3JvdGU6DQo+ID4gPiA+ID4gV2hhdCBoYXBw
ZW5zIGlmIGEgaHlwZXJ2aXNvciAqRE9FUyogZm9yaygpPyAgV2hhdCdzIHRoZSBmYWxsb3V0Pw0K
PiA+ID4gPiBUaGlzIHBhcnQgb3JpZ2luYXRlcyBmcm9tIGJlbG93IGRpc2N1c3Npb246DQo+ID4g
PiA+IA0KPiA+ID4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1zZ3gvNTJkYzdmNTBi
NjhjOTljZWNiOWUxYzMzODNkOWM2ZDg4NzM0Y2Q2Ny5jYW1lbEBpbnRlbC5jb20vI3QNCj4gPiA+
ID4gDQo+ID4gPiA+IEl0IGludGVudHMgdG8gYW5zd2VyIHRoZSBxdWVzdGlvbjoNCj4gPiA+ID4g
DQo+ID4gPiA+ICAgICBEbyB5b3UgdGhpbmsgdGhlIHByb2Nlc3NlcyBzaGFyaW5nIHRoZSBzYW1l
IGVuY2xhdmUgbmVlZCB0byBiZQ0KPiA+ID4gPiAgICAga2lsbGVkLCBldmVuIHRoZXkgaGFkIG5v
dCB0b3VjaGVkIHRoZSBFUEMgcGFnZSB3aXRoIGhhcmR3YXJlIGVycm9yPw0KPiA+ID4gPiANCj4g
PiA+ID4gRGF2ZSwgZG8geW91IG1lYW4gaXQncyBub3QgYXBwcm9wcmlhdGUgdG8gYmUgcHV0IGhl
cmU/DQo+ID4gPiBJdCdzIGFjdHVhbGx5IGEgcHJldHR5IGltcG9ydGFudCBwb2ludCwgYnV0IGl0
J3Mgc3RpbGwgb3V0IG9mIHRoZSBibHVlLg0KPiA+ID4gDQo+ID4gPiBZb3UgYWxzbyBkaWRuJ3Qg
YW5zd2VyIG15IHF1ZXN0aW9uLg0KPiA+IE9oLCBzb3JyeSwgSSBmb2N1c2VkIG9uIGFuc3dlcmlu
ZyAiV2h5IGlzIHRoaXMgaGVyZT8iIGJ1dCBmb3Jnb3QgdG8NCj4gPiBhbnN3ZXIgIldoYXQncyB0
aGUgZmFsbG91dD8iDQo+ID4gDQo+ID4gSXQncyBhIHZlcnkgZ29vZCBxdWVzdGlvbi4NCj4gPiAN
Cj4gPiBMb29rcyBsaWtlIEthaSBoYWQgYW5zd2VyZWQgaXQgYmVmb3JlOg0KPiA+IA0KPiA+IAlG
b3IgaW5zdGFuY2UsIGFuIGFwcGxpY2F0aW9uIGNhbiBvcGVuIC9kZXYvc2d4X3ZlcGMsIG1tYXAo
KSwgYW5kDQo+ID4gCWZvcmsoKS4gIFRoZW4gaWYgdGhlIGNoaWxkIGRvZXMgbW1hcCgpIGFnYWlu
c3QgdGhlIGZkIG9wZW5lZCBieQ0KPiA+IAl0aGUgcGFyZW50LCB0aGUgY2hpbGQgd2lsbCBzaGFy
ZSB0aGUgc2FtZSB2ZXBjIHdpdGggdGhlIHBhcmVudC4NCj4gPiANCj4gPiAJLi4uDQo+ID4gDQo+
ID4gCVNoYXJpbmcgdmlydHVhbCBFUEMgaW5zdGFuY2Ugd2lsbCB2ZXJ5IGxpa2VseSB1bmV4cGVj
dGVkbHkgYnJlYWsNCj4gPiAJZW5jbGF2ZXMgaW4gYWxsIFZNcy4NCj4gDQo+IEhvdywgdGhvdWdo
PyAgVGhpcyBiYXNpY2FsbHkgc2F5cywgIkkgdGhpbmsgdGhpbmdzIHdpbGwgYnJlYWsuIiAgSSB3
YW50DQo+IHRvIGtub3cgYSBmZXcgbW9yZSBzcGVjaWZpY3MgdGhhbiB0aGF0IGJlZm9yZSB3ZSBt
ZXJnZSB0aGlzLiAgVGhlcmUgYXJlDQo+IEFCSSBpbXBsaWNhdGlvbnMuDQoNClRoaXMgaXMgYmVj
YXVzZSB2aXJ0dWFsIEVQQyBpcyBqdXN0IGEgcmF3IHJlc291cmNlIHRvIGd1ZXN0LCBhbmQgaG93
IGd1ZXN0IHVzZXMNCnZpcnR1YWwgRVBDIHRvIHJ1biBlbmNsYXZlcyBpcyBjb21wbGV0ZWx5IGNv
bnRyb2xsZWQgYnkgdGhlIGd1ZXN0LiAgV2hlbiB2aXJ0dWFsDQpFUEMgaXMgc2hhcmVkIGFtb25n
IFZNcywgaXQgY2FuIGhhcHBlbiB0aGF0IG9uZSBndWVzdCBfdGhpbmtzXyBvbmUgRVBDIHBhZ2Ug
aXMNCnN0aWxsIGZyZWUgYnV0IGluIGZhY3QgaXQgaGFzIGJlZW4gYWxyZWFkeSB1c2VkIGJ5IGFu
b3RoZXIgVk0gYXMgYSB2YWxpZCBlbmNsYXZlDQpwYWdlLiAgQWxzbywgb25lIFZNIGNhbiBqdXN0
IHVuY29uZGl0aW9uYWxseSBzYW5pdGl6ZSBhbGwgRVBDIHBhZ2VzIGJlZm9yZSB1c2luZw0KYW55
IG9mIHRoZW0gKGp1c3QgbGlrZSBMaW51eCBkb2VzKS4gIEFsbCBvZiB0aG9zZSBjYW4gY2F1c2Ug
dW5leHBlY3RlZCBTR1gNCmVycm9yLCB3aGljaCBjYW4gbGVhZCB0byBmYWlsaW5nIHRvIGNyZWF0
ZSBlbmNsYXZlLCBhbmQvb3IgYnJlYWtpbmcgZXhpc3RpbmcNCmVuY2xhdmVzIHJ1bm5pbmcgaW4g
YWxsIFZNcy4NCg0KPiANCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1zZ3gvNTJk
YzdmNTBiNjhjOTljZWNiOWUxYzMzODNkOWM2ZDg4NzM0Y2Q2Ny5jYW1lbEBpbnRlbC5jb20vI3QN
Cj4gPiANCj4gPiBNb3Jlb3ZlciwgSSBjaGVja2VkIHRoZSBjb2RlIGluIGJlbG93IHNjZW5hcmlv
IHdoaWxlIGNoaWxkIHNoYXJpbmcgdGhlDQo+ID4gdmlydHVhbCBFUEMgaW5zdGFuY2Ugd2l0aCBw
YXJlbnQ6DQo+ID4gLSBjaGlsZCBjbG9zZXMgL2Rldi9zZ3hfdmVwYyBlYXJsaWVyIHRoYW4gcGFy
ZW50Lg0KPiA+IC0gY2hpbGQgcmUtbW1hcCgpIC9kZXYvc2d4X3ZlcGMgdG8gdGhlIHNhbWUgbWVt
b3J5IHJlZ2lvbiBhcyBwYXJlbnQuDQo+ID4gLSBjaGlsZCBtbWFwKCkgL2Rldi9zZ3hfdmVwYyB0
byBkaWZmZXJlbnQgbWVtb3J5IHJlZ2lvbi4NCj4gPiAtIGNoaWxkIGFjY2Vzc2VzIHRoZSBtZW1v
cnkgcmVnaW9uIG9mIG1tYXAoKSBpbmhlcml0ZWQgZnJvbSBwYXJlbnQuDQo+ID4gDQo+ID4gSXQn
cyBqdXN0IHRoYXQgdGhlIGFwcCBtZXNzZXMgaXRzZWxmIHVwLCB0aGUgdmVwYyBpbnN0YW5jZSBp
cyBwcm90ZWN0ZWQNCj4gPiB2ZXJ5IHdlbGwuDQo+ID4gTWF5YmUgdGhlcmUgYXJlIG90aGVyIGNv
cm5lciBjYXNlcyBJJ3ZlIG5vdCBjb25zaWRlcmVkPw0KPiANCj4gLi4uIGFuZCB3aGF0IGhhcHBl
bnMgd2hlbiAqVEhJUyogcGF0Y2ggaXMgaW4gcGxheT8gIFdoYXQgaWYgdGhlcmUgaXMgYQ0KPiBt
YWNoaW5lIGNoZWNrIGluIFNHWCBtZW1vcnk/DQoNCldpdGggdGhpcyBwYXRjaCwgd2hlbiAjTUMg
aGFwcGVucyBvbiBvbmUgdmlydHVhbCBFUEMgcGFnZSwgaXQgd2lsbCBiZSBzZW5kIHRvDQp0aGUg
Vk0sIGFuZCB0aGUgYmVoYXZpb3VyIGluc2lkZSBhIFZNIGRlcGVuZHMgb24gZ3Vlc3QncyBpbXBs
ZW1lbnRhdGlvbi4gIEJ1dA0KYW55d2F5IGJhc2VkIG9uIFRvbnkncyByZXBseSwgdGhlIGVuY2xh
dmUgd2lsbCBiZSBtYXJrZWQgYXMgImJhZCIgYnkgaGFyZHdhcmUNCmFuZCBpdCB3aWxsIGV2ZW50
dWFsbHkgYmUga2lsbGVkOg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1zZ3gvNTVm
ZmQ5NDc1ZjVkNDZmNjhkZDA2YzQzMjNiZWM4NzFAaW50ZWwuY29tLw0KaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGludXgtc2d4LzViNmFkM2UyYWY2MTRjYWY5YjQxMDkyNzk3ZmZjZDg2QGludGVs
LmNvbS8NCg0KSWYgdGhlIHZpcnR1YWwgRVBDIGlzIHNoYXJlZCBieSBvdGhlciBWTXMsIHRoZSB3
b3JzdCBjYXNlIGlzIHdoZW4gb3RoZXIgVk1zIHVzZQ0KdGhpcyBiYWQgRVBDIHBhZ2UgKGFzIHdl
IGNhbm5vdCB0YWtlIHRoZSBiYWQgRVBDIHBhZ2Ugb3V0IG9mIFZNIGZvciBub3cpLCBzb21lDQpT
R1ggZXJyb3IgKEVOQ0xTL0VOQ0xVIGVycm9yKSBvciAjTUMgY291bGQgaGFwcGVuIGFnYWluLiAg
QnV0IHRoaXMgZG9lc24ndCBtYWtlDQp0aGluZ3Mgd29yc2UsIGFzIHdoZW4gc2hhcmluZyB2aXJ0
dWFsIEVQQyBwYWdlIGFtb25nIFZNcyB5b3UgYXJlIGxpa2VseSB0byBicmVhaw0KZW5jbGF2ZXMg
aW4gVk1zIGFueXdheSAoYXMgbWVudGlvbmVkIGFib3ZlKS4NCg0K
