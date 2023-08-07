Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E19C001B0
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Aug 2023 20:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjHGULS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Aug 2023 16:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjHGULR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Aug 2023 16:11:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC0D10C0
        for <linux-sgx@vger.kernel.org>; Mon,  7 Aug 2023 13:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691439076; x=1722975076;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=coVGDZu6Dq1K6k1Bl+gPvVffi45qE9V1Vp+tnhStTb0=;
  b=nwTdZyKCYKIwnLXUQGPCLfZiK6P9Wr0uy9akt9Mna4A1J0h9a5KXSqWi
   sbUm5bDy+lJdtP2KjxUG19XqJ89aOks8eP/40e3zrUT4bW8hX9NREV7+l
   iplXJrvPzLvx+Y76X+ncgDjs//uR7yqyBAxpTXKNVMg/Zg0d0vDWpTnnj
   +JhN3aoj6yQNK2hKodLUwHnCya2Az/CnDccH5zIhm8RwTdsfAo4cOW45k
   7GjmRBTpjVtfJZENGT00iHCYvSIhyZR+RgQRkBXtWijn4f/g4f9poEs7U
   pcSy+yNjkJb78VREfEpUYLcsTppswFeV2Mall0NWOa0weERmKJ0mjVM8K
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="350230859"
X-IronPort-AV: E=Sophos;i="6.01,262,1684825200"; 
   d="scan'208";a="350230859"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 13:11:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="680920156"
X-IronPort-AV: E=Sophos;i="6.01,262,1684825200"; 
   d="scan'208";a="680920156"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 07 Aug 2023 13:11:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 7 Aug 2023 13:11:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 7 Aug 2023 13:11:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 7 Aug 2023 13:11:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 7 Aug 2023 13:11:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oM5f5O08pHL0vmcTQrjCQeqvPXwRX1byIRN6KqcngDpxCTIQNHHmTHjE6w5ujzA73gGGuqW7rC5KP/6TXmrxhLoFp54yJZ9mS9ZkzR9vtTAeP9htx869W73aAH8PGoFy87CSYRGbZpiqhc1UPDI5bnuPE1b9480qO2+FR/VUDuV1GFBUA0OfQnHI+kvXQ8pQjRo9Se959ofwKmQsFR7mpPzu/ztPm42NdDniBAUvBJpbsYW7HST4Hjb1iI+Z0TcDdG/kaKpEj2gcvcNWMuHyEoiLyAws6udH15+2gqUVOKEYAZo1cTJApxGE8YRB7h80PySWxzXxbSNsVU3XbiepIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=coVGDZu6Dq1K6k1Bl+gPvVffi45qE9V1Vp+tnhStTb0=;
 b=WCtF8UCyVddfHaQ3F2kwb5SuoXzhBAN/XZEOF0/XAZQEJLhdK7qZZDpd6R81uPVl8uEWiyyn5c9hKbMUAOmPWcX1jAhuKMzcUhz72VjQbcUwfDinJEMl3BYShoWe3EtndguUDi5PY/twlwBIjjZwxpqhfSlaE5DkcrNZz9bmplH1oU6SEUh4en+KcbMgOgOIz4IJB9l628erdZ41xUg/5h2R58Xi6VX3zgNhYGDXjFz8sO7pwutbpVpBvQe6nlSAfl69B2m8IdCdb7amNedfrLqIMyfu/dXhR4gvsjTLWD6pnN4bFpSB1ivJfk5w/mq0e7LWa7XK1nL3N77ViJ8P0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8415.namprd11.prod.outlook.com (2603:10b6:610:17b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.22; Mon, 7 Aug
 2023 20:11:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6652.026; Mon, 7 Aug 2023
 20:11:10 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Shutemov, Kirill" <kirill.shutemov@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
Subject: Re: SGX Memory Reservation on SPR
Thread-Topic: SGX Memory Reservation on SPR
Thread-Index: AQHZxxfUAdEKDWIs0EmlOr7+M9Sr/6/e2TiAgAAEcwCAAGq/AA==
Date:   Mon, 7 Aug 2023 20:11:10 +0000
Message-ID: <9433be2309c3f1a6ced71fc2467e3d9ed27015be.camel@intel.com>
References: <ce32998f-1d7f-9481-ddb8-961b5d0f6a83@intel.com>
         <op.19a6ljf3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <op.19a7b20rwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.19a7b20rwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB8415:EE_
x-ms-office365-filtering-correlation-id: e59e1b0d-d260-4767-3911-08db97827182
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EVriUAqIka51VRbi65/iw6o/9pzJ9/BZi5B/585IjyNBqXACl1FxmQQav34BW6hP3Su98KSzGS47pX9QxNSP61vOKGWHojQIORV3wL8y+u37xmdn6qqh7TZSWrIZqQDwrobe4ByiChaSQZdGEMUA6s8VkXNBA6e3yba0X79zzbUXU11SdOYZm0MNC/Hkr/yn9aF/de+cOByCDhF4EteBoEmoSrLj/QAQDEWH5Col7VrBwMLLggY+MqdJdZyKcf8BgS42N9xKvD1QDGnb/rbBZm2na0TzrrQm3sDPWGlSynct5ZgZBJ3eY1h/m3pus7ggWD1d2rU2Hlg7wORqwkWc+HanGNcLSwMseW52DuV+j+DLNl6IOuBSIO9/wWYxIwYyzLI3QfSsdSsBLf11j8KwmKPur/zzhECXuzmNdkdDSnzhrhRc8v7GBE9Aa72DBFq9wCKieVnl85a8u6Z8Ps8b52g4LX2Eq5FY5Jw3pWqCCIURb9Jeehg62wc4zedHhqgztmYjOY+EgPjzn/F4McUIte+LCC6ln2n71ORRUg7mC7YCOsG44FUUATn41JFrJaXtSPflktTlWHyyxY507KeI2Z0ebtzVNASTctxYYRzRhc9b0M+9DIlxSfHTZzazY4iB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(376002)(396003)(366004)(186006)(1800799003)(451199021)(38070700005)(41300700001)(26005)(2906002)(5660300002)(8676002)(4744005)(8936002)(2616005)(86362001)(82960400001)(316002)(6506007)(38100700002)(76116006)(110136005)(478600001)(6486002)(64756008)(66446008)(66476007)(66556008)(122000001)(91956017)(71200400001)(66946007)(6512007)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QllNNHFXVCtTeGRDMmE3VmFHeUp0SGpJYVlTTjVQSFVvRkZXODRTTmNwRHAv?=
 =?utf-8?B?QW9DU1FxaVNyRC9hbVFHVnpqM0xoS0tFL3g3SkFYT2FRdi9NM1BNZTNNSVZC?=
 =?utf-8?B?OElDMnhvOXc2bkp4VWpxNEMxd0Z0Z3ZCdHdHNkNDeGxoUVZ5MmN4cHYzbkdU?=
 =?utf-8?B?RTNZcm5tb1NpL2htVTdWOXpsd1drVUd1a2E1ZmlPeGg2V3c0bmFPMzFWRmdH?=
 =?utf-8?B?UmFTZVlsbDV1MTBUT3l2L1I2R0JQQ1ErQWY4cFExQ0tUUFVzRkhtUEdwa2VZ?=
 =?utf-8?B?SXNKMUoyTSt1RGJXaStnd0prQ05YSWpyWXR2S2dmZDB4SHVkNGNMYXBGeVd3?=
 =?utf-8?B?azJsTGY4VVAwK0dKdm9hL3NXUG9yZDRCWTFZNWdrNU4rMjFBVzEwMHl1TTZ5?=
 =?utf-8?B?LzlOT0xNV2dDS1EyVGpobHNkSTVXWmlKQXhadGxONkJXeCswVmc4RVVmMklC?=
 =?utf-8?B?ZlF2UzRaelJCc0dwWjVBb2hTTU5XU1lsSHd6V3F5UlhPWGRTS3UrTlRYYWpw?=
 =?utf-8?B?SnJFM2wyNFNQc1FVSEgrUmZaL2tzeDBtcVo3a2NPV0ZyOXltNTZLdjZkalVJ?=
 =?utf-8?B?Z0JRQnh5amJVQkVNdUV1bXZCbGZPTWNLS0hxblNQK0wrbDFobEE4K00yYlFp?=
 =?utf-8?B?TDFVTHlLMHh6T2VKUW1YVEhYeTFYUVlpVmhiOVNBaGhIR2FENG9LdnFHZFFH?=
 =?utf-8?B?Sm5CSDRoUDk5Zkhpa2h3VWM0aGZuaGJtUkRQU3QyRjg5OERJYVpwWC81U2Fo?=
 =?utf-8?B?a1FmQzhaSkFyR3NaaXByeEkxdUlFd0dLMjIvdXp0Q1ZZa1pzNWR2NkJySEYx?=
 =?utf-8?B?bGFDNzlkWEdwMkdRU1NDajQxV0U0anRtYk9POUtQK1BQTENsTXh3dlEyNmlF?=
 =?utf-8?B?bjBtUllvbmxudXBLS2xFK0pkWkxBc0hIMytDNEYrQWJ2VEZMVWNTd1pFYnVy?=
 =?utf-8?B?N0FQSnV5SlNSZDRZNkg1b01OK091UjJXZlQ1MnJUMHozSE92Y2F1UmVsV1Y4?=
 =?utf-8?B?cVBvYm9wUlpRUlBKams1TGdIV2liMG5YcjRhV0J5d0JLVFFZR3dSazhiVGh4?=
 =?utf-8?B?YUtxSlNrbWtuN1J2MDFTRklsaXU2bTFoNStTRG4rN2RUdEhFMFNzdkhQc1ov?=
 =?utf-8?B?VVA5SXJpU0JWYWU1NDJXdkVnZGgwUWRqZ3gyMHBiRG9LMngwT2xFQWZSNVcv?=
 =?utf-8?B?dm4xbHQwZUxBQUxMK093VlF2c3pGcHRwZW1aekt0QURjVnArNWJYQVQrRzBj?=
 =?utf-8?B?YUJqVFA4SVFIRzgzOE1YNkVwRWlXK2dwOGlIbFZPTHBPd2tNZUQ0VlplQlpz?=
 =?utf-8?B?SXRJVk1OenpRNmVoUWJjL00xOFRlWWRLb1FrcU9FSWl5Mm9JWkJYVWg0OUVG?=
 =?utf-8?B?b3FtQkhkQmRlYlFpcUlnalNhMEh6L2p5cjhOQ0hKSDQwdW9aeDlqbUVmQnB1?=
 =?utf-8?B?R1pFd3hsNjN1Uk5qQmZ1NWRaV1VtbUFXdGY0d0QxUTNGb1YyaEtseVhrT0Vt?=
 =?utf-8?B?OVprTW40bDFsV2EwNVNBS0U4eldRUUxydzB5S0VuNGNZMHdlVCtiUGlodHpu?=
 =?utf-8?B?S0VxaWdrWjRBZlV2N29haG5kY1VVK2w4ZW1mbnhuTVlmakJadzhlYXoxS1dZ?=
 =?utf-8?B?UFpWL3ZBYzBPNHBhK1ZRL1dieTRpeWZrUFlHeFFiWTd2MWlCL2JvaHkzRW13?=
 =?utf-8?B?V3RML3FpRE5sa0tKbTdQWUJHUkdOZEt1eXNIQUhITkI0K3lvY2IvMXBaaWx1?=
 =?utf-8?B?YjNIamVtZzdkeVkzNzRvbHBRUkQrLzFLWkV1WVRmNnl3Uzh1cEpxTHJMQ1BW?=
 =?utf-8?B?cHlsSHd2Q1MrbTF2a1NNUGxrMmUrMkZuWFVJMDFETEFVMzBjZ0lWWkptWUVh?=
 =?utf-8?B?MWNtT2FhaHhmTUVwbFVoaENreDJ0cHByWHNyTi8xcjBpemJHL0o2NWV1T2ph?=
 =?utf-8?B?WHd3MWxuSHJZYXNUYVVMZTN2Qk5tU2lJVHpJTVprcEp2VFVnb1VKVzBaVk93?=
 =?utf-8?B?ZEFwYTAvK1pIcFliM0FyRW5Ta3J2RDlnWGZZVDVpU2NtRGlVL0sxdWIyTldY?=
 =?utf-8?B?aEZuQkRZdTBWdjRqOFVtTHc5bE1LbTloRmhCeU5mUWFpK0hVOFhZNWMyYkhO?=
 =?utf-8?Q?IaePejWXGVaAkPBtAIjvFX5Sa?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7BFBCB6B3203442B3AA9037324184C4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e59e1b0d-d260-4767-3911-08db97827182
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2023 20:11:10.8587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IKE0wT7/DKOVVm8xYjG3CM8Z+IY33On7dM5ADKb8N0I5eKG8TlgmOVIwhyZy2XS7Bl3GdWyrm7waNnY2rDjwkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8415
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gTW9uLCAyMDIzLTA4LTA3IGF0IDA4OjQ5IC0wNTAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+
IE9uIE1vbiwgMDcgQXVnIDIwMjMgMDg6MzM6MDkgLTA1MDAsIEhhaXRhbyBIdWFuZyAgDQo+IDxo
YWl0YW8uaHVhbmdAbGludXguaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gSGkgRGF2ZQ0KPiA+
IE9uIEZyaSwgMDQgQXVnIDIwMjMgMTY6MDY6NTAgLTA1MDAsIERhdmUgSGFuc2VuIDxkYXZlLmhh
bnNlbkBpbnRlbC5jb20+ICANCj4gPiB3cm90ZToNCj4gPiANCj4gPiA+IFdoYXQgY2hvaWNlcyBk
byBvdXIgZW5kIHVzZXJzIGhhdmUgYWJvdXQgaG93IG11Y2ggRVBDIFJBTSB0byBkZWRpY2F0ZSB0
bw0KPiA+ID4gU0dYIG9uIFNQUiBzeXN0ZW1zPyAgSSBhc3N1bWUgdGhlcmUncyBzb21lIGFiaWxp
dHkgdG8gdHdlYWsgdG8gdHdlYWsgaXQNCj4gPiA+IGluIHRoZSBCSU9TLg0KPiA+IA0KPiA+IE9u
IG9uZSBwbGF0Zm9ybSBJIGtub3csIEJJT1MgcHJvdmlkZXMgY2hvaWNlcyBmcm9tIDI1Nk0gdG8g
MjU2RywgIA0KPiA+IGRvdWJsaW5nIGF0IGVhY2ggaW5jcmVtZW50LiBUaGlzIHNob3VsZCBkZXBl
bmQgb24gT0VNL0JJT1MgYW5kIGF2YWlsYWJsZSAgDQo+ID4gdG90YWwgUkFNIGNvbmZpZ3VyZWQu
DQo+ID4gDQo+IEFsc28gdGhlIHNpemVzIGNvbmZpZ3VyZWQgYWJvdmUgaXMgcGVyIHNvY2tldC4g
U28gZm9yIHRoaXMgcGFydGljdWxhciAgDQo+IHN5c3RlbSB3aXRoIDIgc29ja2V0cywgdG90YWwg
RVBDIGNhbiBiZSBjb25maWd1cmVkIHVwIHRvIDEwMjRHDQo+IA0KDQpZZWFoIG90aGVyIHRoYW4g
Y29uZmlndXJpbmcgdGhlIEVQQyBzaXplIGluIHRoZSBCSU9TLCBJIGRvbid0IHRoaW5rIHRoZXJl
J3MgYW55DQpvdGhlciB3YXkgd2UgY2FuIGFkanVzdCB0aGUgRVBDIHNpemUuDQo=
